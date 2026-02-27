# -*- coding: utf-8 -*-
"""
CLI para generar fichas de estación en PDF.

Usage:
    python generate.py 2024                      # Generar todas las estaciones de un año
    python generate.py 2024 --estacion 123       # Generar una sola estación
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

    args = parser.parse_args()

    # Prioridad al año posicional o vía flag
    year = args.year_pos if args.year_pos else args.year

    if year:
        if args.estacion:
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
            # Para todas las estaciones (Generación masiva en un solo PDF)
            from data_queries import get_connection, get_active_stations
            conn = get_connection()
            try:
                stations = get_active_stations(conn)
                print("=" * 50)
                print(f"  GENERACIÓN MASIVA - AÑO {year}")
                print(f"  Estaciones encontradas: {len(stations)}")
                print(f"  Página inicial: {args.start_page}")
                print("=" * 50)

                os.makedirs(OUTPUT_DIR, exist_ok=True)
                filename = f"Anuario_Fichas_{year}.pdf"
                output_path = os.path.join(OUTPUT_DIR, filename)
                
                pdf = FichaEstacionPDF(output_path, start_page=args.start_page)

                total_start_time = time.time()
                try:
                    for i, id_estacion in enumerate(stations, 1):
                        start_station = time.time()
                        timestamp = datetime.now().strftime("%H:%M:%S")
                        print(f"[{timestamp}] [{i}/{len(stations)}] Procesando ID {id_estacion}...", flush=True)
                        
                        try:
                            _add_station_to_pdf(conn, id_estacion, year, pdf)
                            duration = time.time() - start_station
                            print(f"\n\t[OK] Finalizado en {duration:.1f}s")
                        except Exception as e:
                            print(f"  [ERROR] Falló ID {id_estacion}: {e}")
                except KeyboardInterrupt:
                    print(f"\n\n[!] Interrupción detectada. Intentando guardar lo procesado hasta ahora...")
                except Exception as e:
                    print(f"\n\n[!] Error crítico durante el proceso: {e}")
                    print("Intentando guardar el PDF con las estaciones procesadas...")
                
                print(f"\n[{datetime.now().strftime('%H:%M:%S')}] Guardando PDF final (esto puede tardar unos segundos)...", end=" ", flush=True)
                pdf.save()
                total_duration = time.time() - total_start_time
                print("OK")

                print("\n" + "=" * 50)
                print(f"  PROCESO FINALIZADO")
                print(f"  Tiempo total: {total_duration/60:.1f} minutos")
                print(f"  PDF unificado generado: {output_path}")
                print("=" * 50)
            finally:
                conn.close()
    else:
        parser.print_help()
        print("\n  Ejemplos:")
        print("    python generate.py 2023             # Todas las estaciones del 2023")
        print("    python generate.py 2023 --estacion 10124")
        print("    python generate.py 2023 --start-page 85")


if __name__ == "__main__":
    main()
