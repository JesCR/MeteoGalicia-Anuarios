# -*- coding: utf-8 -*-
"""
CLI para generar fichas de estación en PDF.

Uso:
    python generate.py --mock                    # Genera ficha con datos ficticios
    python generate.py --estacion 123 --year 2024  # Genera ficha desde BD
    python generate.py --all --year 2024          # Genera todas las estaciones
"""

import os
import sys
import argparse

from config import USE_MOCK_DATA, OUTPUT_DIR
from charts import (
    chart_temperaturas,
    chart_precipitacion,
    chart_humedad_insolacion,
    chart_rosa_vientos,
    chart_rosa_velocidad,
)
from pdf_layout import FichaEstacionPDF


def generate_mock():
    """Genera una ficha de ejemplo con datos ficticios."""
    from mock_data import (
        get_station_info_mock,
        get_annual_summary_mock,
        get_monthly_data_mock,
        get_station_image_mock,
        get_province_images_mock,
    )

    print("=" * 50)
    print("  GENERADOR DE FICHAS DE ESTACIÓN")
    print("  Modo: DATOS FICTICIOS (mock)")
    print("=" * 50)

    station = get_station_info_mock()
    summary = get_annual_summary_mock()
    monthly = get_monthly_data_mock()

    print(f"\n  Estación: {station['Estacion']}")
    print(f"  Año: {summary['year']}")

    # Generar las 5 gráficas
    print("\n  Generando gráficas...")
    print("    [1/5] Temperaturas...", end=" ")
    g1 = chart_temperaturas(monthly)
    print("OK")

    print("    [2/5] Precipitación...", end=" ")
    g2 = chart_precipitacion(monthly)
    print("OK")

    print("    [3/5] Humedad/Insolación...", end=" ")
    g3 = chart_humedad_insolacion(monthly)
    print("OK")

    print("    [4/5] Rosa de vientos...", end=" ")
    g4 = chart_rosa_vientos(monthly)
    print("OK")

    print("    [5/5] Rosa de velocidad...", end=" ")
    g5 = chart_rosa_velocidad(monthly)
    print("OK")

    charts = {'g1': g1, 'g2': g2, 'g3': g3, 'g4': g4, 'g5': g5}

    # Generar PDF
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    filename = f"Ficha_{station['NombreCorto'].replace(' ', '_')}_{summary['year']}.pdf"
    output_path = os.path.join(OUTPUT_DIR, filename)

    print(f"\n  Componiendo PDF...")
    pdf = FichaEstacionPDF(output_path)
    pdf.generate(
        station_info=station,
        annual_summary=summary,
        charts_io=charts,
        station_image_bytes=get_station_image_mock(),
        province_images=get_province_images_mock(),
    )

    print(f"  [OK] PDF generado: {output_path}")
    print(f"  Tamaño: {os.path.getsize(output_path) / 1024:.1f} KB")
    return output_path


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

        for i, id_estacion in enumerate(stations, 1):
            print(f"\n[{i}/{len(stations)}] Procesando ID {id_estacion}...")
            try:
                # Reutilizamos la lógica de generación desde BD
                # (Pequeño refactor: extraemos la lógica interna de generate_from_db)
                _generate_single_from_conn(conn, id_estacion, year)
            except Exception as e:
                print(f"  [ERROR] Falló ID {id_estacion}: {e}")
        
        print("\n" + "=" * 50)
        print(f"  PROCESO FINALIZADO")
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
        _generate_single_from_conn(conn, id_estacion, year)
    finally:
        conn.close()


def _generate_single_from_conn(conn, id_estacion, year):
    """Lógica interna para generar un PDF compartiendo conexión."""
    from data_queries import (
        get_station_info,
        get_annual_summary,
        get_monthly_data,
        get_station_image,
        get_province_images,
    )
    
    station = get_station_info(conn, id_estacion)
    if not station:
        print(f"  [SKIP] No se encontró info de estación.")
        return

    summary = get_annual_summary(conn, id_estacion, year)
    if not summary:
        print(f"  [SKIP] Sin datos para el año {year}.")
        return

    monthly = get_monthly_data(conn, id_estacion, year)
    station_img = get_station_image(conn, id_estacion)
    prov_imgs = get_province_images(conn, id_estacion)

    # Generar gráficas
    g1 = chart_temperaturas(monthly)
    g2 = chart_precipitacion(monthly)
    g3 = chart_humedad_insolacion(monthly)
    
    # Solo generamos gráficas de viento si hay datos (frecuencias sum > 0 o calas > 0)
    has_wind = any(f > 0 for f in monthly.get("wind_freq", [])) or monthly.get("calmas_pct", 0) > 0
    if has_wind:
        g4 = chart_rosa_vientos(monthly)
        g5 = chart_rosa_velocidad(monthly)
    else:
        g4 = None
        g5 = None
        
    charts = {'g1': g1, 'g2': g2, 'g3': g3, 'g4': g4, 'g5': g5}

    # Generar PDF
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    clean_name = station['NombreCorto'].replace(' ', '_').replace('/', '-')
    filename = f"Ficha_{clean_name}_{year}.pdf"
    output_path = os.path.join(OUTPUT_DIR, filename)

    pdf = FichaEstacionPDF(output_path)
    pdf.generate(
        station_info=station,
        annual_summary=summary,
        charts_io=charts,
        station_image_bytes=station_img,
        province_images=prov_imgs,
    )
    print(f"  [OK] -> {filename}")


def main():
    parser = argparse.ArgumentParser(
        description="Generador de Fichas de Estación Meteorológica (PDF)"
    )
    parser.add_argument('year_pos', type=int, nargs='?', default=None,
                        help='Año de los datos (opcional si se usa --mock)')
    parser.add_argument('--mock', action='store_true',
                        help='Generar ficha con datos ficticios')
    parser.add_argument('--estacion', type=int, default=None,
                        help='ID de la estación (si se omite, genera todas)')
    parser.add_argument('--year', type=int, default=None,
                        help='Año de los datos (vía flag)')

    args = parser.parse_args()

    # Prioridad al año posicional o vía flag
    year = args.year_pos if args.year_pos else args.year

    if args.mock:
        generate_mock()
    elif year:
        if args.estacion:
            generate_from_db(args.estacion, year)
        else:
            generate_all(year)
    else:
        parser.print_help()
        print("\n  Ejemplos:")
        print("    python generate.py 2023             # Todas las estaciones del 2023")
        print("    python generate.py 2023 --estacion 10124")
        print("    python generate.py --mock")


if __name__ == "__main__":
    main()
