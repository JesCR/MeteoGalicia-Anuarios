# -*- coding: utf-8 -*-
"""
CLI para generar fichas de estación en PDF.

Usage:
    python generate.py 2024                      # PDF completo (portada + indice + coord + tablas + mensual + fichas + glosario)
    python generate.py 2024 --estacion 123       # Generar una sola ficha de estación
    python generate.py 2024 --coordenadas        # Generar solo el PDF de coordenadas
    python generate.py 2024 --tablas             # Generar solo el PDF de tablas de datos
    python generate.py 2024 --mensual            # Generar solo el PDF de resúmenes mensuales
    python generate.py 2024 --glosario           # Generar solo el PDF del glosario
    python generate.py 2024 --portada            # Generar solo la portada
    python generate.py 2024 --start-page 85      # Empezar numeración en página 85
"""

import os
import sys
import argparse
import time
from datetime import datetime

from config import OUTPUT_DIR
from charts import (
    chart_temperaturas,
    chart_precipitacion,
    chart_humedad_insolacion,
    chart_rosa_vientos,
)
from pdf_layout import FichaEstacionPDF


# ─── Logging dual (consola + fichero) ────────────────────────────────────────

class _TeeLogger:
    """
    Sustituye sys.stdout para escribir cada línea tanto en la consola
    como en un fichero de log con marca de tiempo.
    """
    def __init__(self, log_path, original_stdout):
        self._log   = open(log_path, 'w', encoding='utf-8', buffering=1)
        self._out   = original_stdout
        self._buf   = ''          # buffer para acumular hasta \n

    def write(self, text):
        self._out.write(text)     # consola sin cambios
        # Acumular en buffer y volcar líneas completas con timestamp
        self._buf += text
        while '\n' in self._buf:
            line, self._buf = self._buf.split('\n', 1)
            ts = datetime.now().strftime('%H:%M:%S')
            self._log.write(f"[{ts}] {line}\n")

    def flush(self):
        self._out.flush()
        self._log.flush()

    def close(self):
        # Volcar cualquier texto pendiente sin \n
        if self._buf:
            ts = datetime.now().strftime('%H:%M:%S')
            self._log.write(f"[{ts}] {self._buf}\n")
        self._log.close()

    # Delegar atributos que pueda necesitar argparse u otros módulos
    def __getattr__(self, name):
        return getattr(self._out, name)


def _setup_logging(label):
    """
    Crea el fichero de log en output/logs/ con el formato:
        generate_<label>_YYYYMMDD_HHMMSS.log
    Devuelve el _TeeLogger activo (ya instalado en sys.stdout).
    """
    logs_dir = os.path.join(OUTPUT_DIR, 'logs')
    os.makedirs(logs_dir, exist_ok=True)
    ts = datetime.now().strftime('%Y%m%d_%H%M%S')
    log_path = os.path.join(logs_dir, f'generate_{label}_{ts}.log')
    tee = _TeeLogger(log_path, sys.stdout)
    sys.stdout = tee
    print(f"[LOG] Fichero de log: {log_path}")
    return tee


def _teardown_logging(tee):
    """Restaura sys.stdout y cierra el fichero de log."""
    sys.stdout = tee._out
    tee.close()


def _merge_pdfs(input_paths, output_path):
    """Fusiona varios PDFs en uno usando pypdf."""
    try:
        from pypdf import PdfWriter, PdfReader
    except ImportError:
        try:
            from PyPDF2 import PdfWriter, PdfReader
        except ImportError:
            import shutil
            print("  [WARN] pypdf no instalado. Índice no incluido en el PDF final.")
            shutil.copy(input_paths[-1], output_path)
            return
    writer = PdfWriter()
    for path in input_paths:
        reader = PdfReader(path)
        for page in reader.pages:
            writer.add_page(page)
    with open(output_path, 'wb') as f:
        writer.write(f)


def generate_all(year):
    """Genera fichas para todas las estaciones activas del subred 102."""
    from data_queries import get_connection, get_active_stations
    
    conn = get_connection()
    try:
        stations = get_active_stations(conn)
        print("=" * 50)
        print(f"  GENERACIÓN MASIVA - AÑO {year}")
        print(f"  Estaciones encontradas: {len(stations)}")
        print("=" * 50)

        os.makedirs(OUTPUT_DIR, exist_ok=True)
        filename = f"Anuario_Fichas_{year}.pdf"
        output_path = os.path.join(OUTPUT_DIR, filename)
        
        pdf = FichaEstacionPDF(output_path)

        for i, id_estacion in enumerate(stations, 1):
            print(f"\n[{i}/{len(stations)}] Procesando ID {id_estacion}...", end=" ")
            try:
                _add_station_to_pdf(conn, id_estacion, year, pdf)
            except Exception as e:
                print(f"  [ERROR] Falló ID {id_estacion}: {e}")
        
        pdf.save()
        print("\n" + "=" * 50)
        print(f"  PROCESO FINALIZADO")
        print(f"  PDF generado: {output_path}")
        print("=" * 50)
    finally:
        conn.close()


def generate_from_db(id_estacion, year):
    """Genera una ficha desde la BD real."""
    from data_queries import get_connection
    conn = get_connection()
    try:
        print("=" * 50)
        print("  GENERADOR DE FICHAS DE ESTACIÓN")
        print("  Modo: BASE DE DATOS")
        print("=" * 50)
        
        from data_queries import get_station_info
        station = get_station_info(conn, id_estacion)
        clean_name = station['NombreCorto'].replace(' ', '_').replace('/', '-') if station else str(id_estacion)
        
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        output_path = os.path.join(OUTPUT_DIR, f"Ficha_{clean_name}_{year}.pdf")
        
        pdf = FichaEstacionPDF(output_path)
        _add_station_to_pdf(conn, id_estacion, year, pdf)
        pdf.save()
        print(f"\n  [OK] PDF generado: {output_path}")
    finally:
        conn.close()


def _add_station_to_pdf(conn, id_estacion, year, pdf):
    """Obtiene datos de la BD y los añade como una nueva página al objeto PDF."""
    from data_queries import (
        get_station_info,
        get_annual_summary,
        get_monthly_data,
        get_station_image,
        get_province_images,
        get_wind_rose_10min,
    )
    
    # 1. Leer BD
    t_start_db = time.time()
    
    t0 = time.time()
    station = get_station_info(conn, id_estacion)
    t_info = time.time() - t0
    
    if not station:
        print(f"\n\t[SKIP] No se encontró info de estación.")
        return

    t0 = time.time()
    summary = get_annual_summary(conn, id_estacion, year)
    t_summary = time.time() - t0
    
    if not summary:
        print(f"\n\t[SKIP] Sin datos para el año {year}.")
        return

    t0 = time.time()
    monthly = get_monthly_data(conn, id_estacion, year)
    t_monthly = time.time() - t0
    
    t0 = time.time()
    station_img = get_station_image(conn, id_estacion)
    t_img = time.time() - t0
    
    t0 = time.time()
    prov_imgs = get_province_images(conn, id_estacion)
    t_prov = time.time() - t0

    t0 = time.time()
    wind_rose = get_wind_rose_10min(conn, id_estacion, year)
    t_wind = time.time() - t0
    
    t_db_total = time.time() - t_start_db
    print(f"\n\t- Leer BD ({t_db_total:.1f}s)", end="", flush=True)
    print(f"\n\t\t. Info estación: {t_info:.1f}s", end="", flush=True)
    print(f"\n\t\t. Resumen anual: {t_summary:.1f}s", end="", flush=True)
    print(f"\n\t\t. Datos mensuales: {t_monthly:.1f}s", end="", flush=True)
    print(f"\n\t\t. Imagen estación: {t_img:.1f}s", end="", flush=True)
    print(f"\n\t\t. Mapas/Provincia: {t_prov:.1f}s", end="", flush=True)
    print(f"\n\t\t. Rosa vientos (10min): {t_wind:.1f}s", end="", flush=True)

    # Inyectar datos de viento en monthly (para la gráfica) y en summary (para las tablas PDF)
    monthly["wind_rose"] = wind_rose
    summary["wind_summary"] = monthly.get("wind_summary", {})

    # 2. Generar gráficas
    t0 = time.time()
    g1 = chart_temperaturas(monthly)
    g2 = chart_precipitacion(monthly)
    g3 = chart_humedad_insolacion(monthly)

    # Solo generamos la rosa si hay datos clasificados
    has_wind = wind_rose.get("n_total", 0) > 0
    if has_wind:
        g4 = chart_rosa_vientos(monthly)
    else:
        g4 = None
        
    charts = {'g1': g1, 'g2': g2, 'g3': g3, 'g4': g4}
    t_charts = time.time() - t0
    print(f"\n\t- Crear gráficas ({t_charts:.1f}s)", end="", flush=True)

    # 3. Montar página PDF
    t0 = time.time()
    pdf.add_station_page(
        station_info=station,
        annual_summary=summary,
        charts_io=charts,
        station_image_bytes=station_img,
        province_images=prov_imgs,
    )
    t_pdf = time.time() - t0
    print(f"\n\t- Montar página PDF ({t_pdf:.1f}s)", end="", flush=True)
    
    # Liberar memoria de los buffers de las gráficas
    for buf in charts.values():
        if buf:
            buf.close()


def main():
    parser = argparse.ArgumentParser(
        description="Generador de Fichas de Estación Meteorológica (PDF)"
    )
    parser.add_argument('year_pos', type=int, nargs='?', default=None,
                        help='Año de los datos')
    parser.add_argument('--estacion', type=int, default=None,
                        help='ID de la estación (si se omite, genera todas)')
    parser.add_argument('--year', type=int, default=None,
                        help='Año de los datos (vía flag)')
    parser.add_argument('--start-page', type=int, default=1,
                        help='Número de página inicial (por defecto 1)')
    parser.add_argument('--coordenadas', action='store_true', default=False,
                        help='Generar PDF de coordenadas de estaciones')
    parser.add_argument('--tablas', action='store_true', default=False,
                        help='Generar solo el PDF de tablas de datos anuales por parámetro')
    parser.add_argument('--glosario', action='store_true', default=False,
                        help='Generar solo el PDF del glosario de términos')
    parser.add_argument('--portada', action='store_true', default=False,
                        help='Generar solo la portada del anuario')
    parser.add_argument('--mensual', action='store_true', default=False,
                        help='Generar solo el PDF de resúmenes mensuales (desde CSVs)')

    args = parser.parse_args()

    # Prioridad al año posicional o vía flag
    year = args.year_pos if args.year_pos else args.year

    # ── Arrancar logging ──────────────────────────────────────────────
    if year:
        if args.estacion:
            log_label = f"{year}_est{args.estacion}"
        elif args.coordenadas:
            log_label = f"{year}_coord"
        elif args.tablas:
            log_label = f"{year}_tablas"
        elif args.mensual:
            log_label = f"{year}_mensual"
        elif args.glosario:
            log_label = f"{year}_glosario"
        elif args.portada:
            log_label = f"{year}_portada"
        else:
            log_label = f"{year}_completo"
    else:
        log_label = "help"
    tee = _setup_logging(log_label)

    try:
        if year:
            if args.portada and not args.estacion:
                # Modo: solo portada
                os.makedirs(OUTPUT_DIR, exist_ok=True)
                output_path = os.path.join(OUTPUT_DIR, f"Portada_{year}.pdf")
                print("=" * 50)
                print(f"  GENERACIÓN DE PORTADA - AÑO {year}")
                print("=" * 50)
                pdf = FichaEstacionPDF(output_path, start_page=args.start_page)
                pdf.add_portada_page(year)
                pdf.save()
                print(f"\n  [OK] PDF generado: {output_path}")

            elif args.mensual and not args.estacion:
                # Modo: solo resumen mensual
                from mensual_data import load_all_mensual
                from config import DOCS_DIR
                csv_dir = os.path.join(DOCS_DIR, "csv", str(year))
                os.makedirs(OUTPUT_DIR, exist_ok=True)
                output_path = os.path.join(OUTPUT_DIR, f"Mensual_{year}.pdf")
                print("=" * 50)
                print(f"  GENERACIÓN DE RESÚMENES MENSUALES - AÑO {year}")
                print(f"  Directorio CSV: {csv_dir}")
                print("=" * 50)
                all_months = load_all_mensual(csv_dir, year)
                print(f"  Meses encontrados: {len(all_months)}")
                pdf = FichaEstacionPDF(output_path, start_page=args.start_page)
                pdf.add_mensual_pages(all_months)
                pdf.save()
                print(f"\n  [OK] PDF generado: {output_path}")

            elif args.coordenadas and not args.estacion:
                # Modo: solo coordenadas
                from data_queries import get_connection, get_coordenadas_estaciones
                conn = get_connection()
                try:
                    print("=" * 50)
                    print(f"  GENERACIÓN DE COORDENADAS - AÑO {year}")
                    print("=" * 50)

                    coord_data = get_coordenadas_estaciones(conn, year)
                    total = sum(len(v) for v in coord_data.values())
                    print(f"  Estaciones encontradas: {total}")

                    os.makedirs(OUTPUT_DIR, exist_ok=True)
                    output_path = os.path.join(OUTPUT_DIR, f"Coordenadas_Estaciones_{year}.pdf")

                    pdf = FichaEstacionPDF(output_path, start_page=args.start_page)
                    pdf.add_coordenadas_pages(coord_data)
                    pdf.save()

                    print(f"\n  [OK] PDF generado: {output_path}")
                finally:
                    conn.close()

            elif args.tablas and not args.estacion:
                # Modo: solo tablas de datos anuales
                from data_queries import get_connection
                from tablas_queries import get_tablas_data
                conn = get_connection()
                try:
                    print("=" * 50)
                    print(f"  GENERACIÓN DE TABLAS - AÑO {year}")
                    print("=" * 50)

                    tablas_data = get_tablas_data(conn, year)

                    os.makedirs(OUTPUT_DIR, exist_ok=True)
                    output_path = os.path.join(OUTPUT_DIR, f"Tablas_Datos_{year}.pdf")

                    pdf = FichaEstacionPDF(output_path, start_page=args.start_page)
                    pdf.add_tablas_pages(tablas_data)
                    pdf.save()

                    print(f"\n  [OK] PDF generado: {output_path}")
                finally:
                    conn.close()

            elif args.glosario and not args.estacion:
                # Modo: solo glosario
                os.makedirs(OUTPUT_DIR, exist_ok=True)
                output_path = os.path.join(OUTPUT_DIR, f"Glosario_{year}.pdf")
                print("=" * 50)
                print(f"  GENERACIÓN DE GLOSARIO")
                print("=" * 50)
                pdf = FichaEstacionPDF(output_path, start_page=args.start_page)
                pdf.add_glosario_pages()
                pdf.save()
                print(f"\n  [OK] PDF generado: {output_path}")

            elif args.estacion:
                # Para una sola estación
                from data_queries import get_connection, get_station_info
                conn = get_connection()
                try:
                    station = get_station_info(conn, args.estacion)
                    clean_name = station['NombreCorto'].replace(' ', '_').replace('/', '-') if station else str(args.estacion)
                    os.makedirs(OUTPUT_DIR, exist_ok=True)
                    output_path = os.path.join(OUTPUT_DIR, f"Ficha_{clean_name}_{year}.pdf")

                    pdf = FichaEstacionPDF(output_path, start_page=args.start_page)
                    _add_station_to_pdf(conn, args.estacion, year, pdf)
                    pdf.save()
                    print(f"  [OK] PDF generado: {output_path}")
                finally:
                    conn.close()
            else:
                # Generación masiva: Portada + Índice + Coordenadas + Tablas + Fichas + Glosario
                from data_queries import (
                    get_connection, get_active_stations_ordered,
                    get_coordenadas_estaciones, get_station_info,
                )
                conn = get_connection()
                try:
                    # Estaciones activas en el año solicitado, ordenadas por Provincia y NombreCorto
                    stations = get_active_stations_ordered(conn, year)
                    print("=" * 50)
                    print(f"  GENERACIÓN MASIVA - AÑO {year}")
                    print(f"  Estaciones encontradas: {len(stations)}")
                    print(f"  Página inicial: {args.start_page}")
                    print("=" * 50)

                    os.makedirs(OUTPUT_DIR, exist_ok=True)
                    final_output  = os.path.join(OUTPUT_DIR, f"Anuario_Fichas_{year}.pdf")
                    temp_portada  = os.path.join(OUTPUT_DIR, f"_temp_portada_{year}.pdf")
                    temp_content  = os.path.join(OUTPUT_DIR, f"_temp_content_{year}.pdf")
                    temp_indice   = os.path.join(OUTPUT_DIR, f"_temp_indice_{year}.pdf")

                    # ── 0. Portada ───────────────────────────────────────
                    print("\n[Portada] Xerando...", flush=True)
                    portada_pdf = FichaEstacionPDF(temp_portada, start_page=1)
                    portada_pdf.add_portada_page(year)
                    portada_pdf.save()
                    print("  [OK] Portada xerada")

                    # Contenido empieza en pág 2 (reservamos pág 1 para el índice)
                    INDICE_PAGES = 1
                    content_start = args.start_page + INDICE_PAGES
                    pdf = FichaEstacionPDF(temp_content, start_page=content_start)
                    toc_entries = []

                    # ── 1. Coordenadas ────────────────────────────────────
                    print("\n[Coordenadas] Generando..." , flush=True)
                    coord_data = get_coordenadas_estaciones(conn, year)
                    coord_prov_pages = pdf.add_coordenadas_pages(coord_data)
                    toc_entries.append({'level': 0, 'title': 'Coordenadas das Estacións',
                                        'page': min(coord_prov_pages.values())})
                    for prov, ppage in coord_prov_pages.items():
                        toc_entries.append({'level': 1, 'title': prov, 'page': ppage})
                    print(f"  [OK] págs {content_start}-{pdf.current_page - 1}")

                    # ── 2. Tablas ───────────────────────────────────────
                    from tablas_queries import get_tablas_data
                    print("\n[Tablas] Generando..." , flush=True)
                    tablas_data = get_tablas_data(conn, year)
                    tablas_sec_pages = pdf.add_tablas_pages(tablas_data)
                    tablas_start_pg  = tablas_sec_pages[0][1] if tablas_sec_pages else pdf.current_page
                    toc_entries.append({'level': 0, 'title': 'Datos por Parámetro',
                                        'page': tablas_start_pg})
                    for sec_title, sec_page in tablas_sec_pages:
                        toc_entries.append({'level': 1, 'title': sec_title, 'page': sec_page})
                    print(f"  [OK] {len(tablas_sec_pages)} secciones generadas")

                    # ── 3. Resumos mensuales ─────────────────────────
                    from mensual_data import load_all_mensual
                    from config import DOCS_DIR
                    csv_dir = os.path.join(DOCS_DIR, "csv", str(year))
                    print(f"\n[Mensual] Xerando desde {csv_dir}...", flush=True)
                    all_months = load_all_mensual(csv_dir, year)
                    if all_months:
                        mensual_pages = pdf.add_mensual_pages(all_months)
                        mensual_start = mensual_pages[0][1] if mensual_pages else pdf.current_page
                        toc_entries.append({'level': 0, 'title': 'Resumos Mensuales',
                                            'page': mensual_start})
                        for ml, mp in mensual_pages:
                            toc_entries.append({'level': 1, 'title': ml, 'page': mp})
                        print(f"  [OK] {len(all_months)} meses xerados")
                    else:
                        print("  [WARN] Non se atoparon CSVs mensuales")

                    # ── 4. Fichas ───────────────────────────────────────
                    fichas_start_pg  = pdf.current_page
                    fichas_prov_pages = {}   # {provincia: primera_pagina}
                    total_start_time = time.time()
                    try:
                        for i, st in enumerate(stations, 1):
                            id_estacion = st['idEstacion']
                            prov = st['Provincia']
                            nombre = st['NombreCorto']
                            start_station = time.time()
                            timestamp = datetime.now().strftime("%H:%M:%S")
                            print(f"[{timestamp}] [{i}/{len(stations)}] ID {id_estacion} ({prov} - {nombre})...", flush=True)
                            try:
                                page_before = pdf.current_page
                                _add_station_to_pdf(conn, id_estacion, year, pdf)
                                # Al estar ordenadas, la primera vez que aparece una provincia
                                # es siempre la primera ficha real de esa provincia
                                if prov and prov not in fichas_prov_pages:
                                    fichas_prov_pages[prov] = page_before
                                print(f"\n\t[OK] {time.time()-start_station:.1f}s")
                            except Exception as e:
                                print(f"  [ERROR] ID {id_estacion}: {e}")
                    except KeyboardInterrupt:
                        print("\n[!] Interrupción detectada. Guardando lo procesado...")
                    except Exception as e:
                        print(f"\n[!] Error crítico: {e}")

                    # Añadir fichas al TOC
                    toc_entries.append({'level': 0, 'title': 'Fichas de Estacións',
                                        'page': fichas_start_pg})
                    from config import COORD_PROVINCIAS
                    for prov in COORD_PROVINCIAS:
                        if prov in fichas_prov_pages:
                            toc_entries.append({'level': 1, 'title': prov,
                                                'page': fichas_prov_pages[prov]})

                    # ── 5. Glosario ────────────────────────────────────
                    glosario_start = pdf.current_page
                    print("\n[Glosario] Xerando...", flush=True)
                    pdf.add_glosario_pages()
                    toc_entries.append({'level': 0, 'title': 'Glosario de Termos Meteorolóxicos',
                                        'page': glosario_start})
                    print(f"  [OK] págs {glosario_start}-{pdf.current_page - 1}")

                    # Guardar contenido
                    print(f"\n[{datetime.now().strftime('%H:%M:%S')}] Guardando contenido...",
                          end=" ", flush=True)
                    pdf.save()
                    print("OK")

                    # ── 6. Generar índice (pág. 1) ──────────────────────
                    print("\n[Índice] Generando...", flush=True)
                    indice_pdf = FichaEstacionPDF(temp_indice, start_page=args.start_page)
                    indice_pdf.add_indice_pages(toc_entries, year)
                    indice_pdf.save()

                    # ── 7. Fusionar: portada + índice + contenido ──────────
                    print("\n[Merge] Fusionando PDFs...", flush=True)
                    _merge_pdfs([temp_portada, temp_indice, temp_content], final_output)

                    # Limpiar temporales
                    for tmp in (temp_portada, temp_indice, temp_content):
                        try:
                            os.remove(tmp)
                        except OSError:
                            pass

                    total_duration = time.time() - total_start_time
                    print("\n" + "=" * 50)
                    print(f"  PROCESO FINALIZADO")
                    print(f"  Tiempo total: {total_duration/60:.1f} minutos")
                    print(f"  PDF generado: {final_output}")
                    print("=" * 50)
                finally:
                    conn.close()
        else:
            parser.print_help()
            print("\n  Ejemplos:")
            print("    python generate.py 2023             # PDF completo")
            print("    python generate.py 2023 --estacion 10124")
            print("    python generate.py 2023 --coordenadas   # Solo coordenadas")
            print("    python generate.py 2023 --tablas        # Solo tablas de datos")
            print("    python generate.py 2023 --mensual       # Solo resúmenes mensuales")
            print("    python generate.py 2023 --glosario      # Solo glosario")
            print("    python generate.py 2023 --portada       # Solo portada")
            print("    python generate.py 2023 --start-page 85")
    finally:
        _teardown_logging(tee)


if __name__ == "__main__":
    main()
