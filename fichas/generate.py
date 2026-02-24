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


def generate_from_db(id_estacion, year):
    """Genera una ficha desde la BD real."""
    from data_queries import (
        get_connection,
        get_station_info,
        get_annual_summary,
        get_monthly_data,
        get_station_image,
        get_province_images,
    )

    print("=" * 50)
    print("  GENERADOR DE FICHAS DE ESTACIÓN")
    print("  Modo: BASE DE DATOS")
    print("=" * 50)

    conn = get_connection()
    try:
        station = get_station_info(conn, id_estacion)
        if not station:
            print(f"\n  ERROR: No se encontró la estación {id_estacion}")
            return None

        summary = get_annual_summary(conn, id_estacion, year)
        if not summary:
            print(f"\n  ERROR: No hay datos anuales para estación {id_estacion}, año {year}")
            return None

        monthly = get_monthly_data(conn, id_estacion, year)
        station_img = get_station_image(conn, id_estacion)
        prov_imgs = get_province_images(conn, id_estacion)

        print(f"\n  Estación: {station['Estacion']}")
        print(f"  Provincia: {station['Provincia']}")
        print(f"  Año: {year}")

        # Generar gráficas
        print("\n  Generando gráficas...")
        g1 = chart_temperaturas(monthly)
        g2 = chart_precipitacion(monthly)
        g3 = chart_humedad_insolacion(monthly)
        g4 = chart_rosa_vientos(monthly)
        g5 = chart_rosa_velocidad(monthly)
        charts = {'g1': g1, 'g2': g2, 'g3': g3, 'g4': g4, 'g5': g5}

        # Generar PDF
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        filename = f"Ficha_{station['NombreCorto'].replace(' ', '_')}_{year}.pdf"
        output_path = os.path.join(OUTPUT_DIR, filename)

        print(f"\n  Componiendo PDF...")
        pdf = FichaEstacionPDF(output_path)
        pdf.generate(
            station_info=station,
            annual_summary=summary,
            charts_io=charts,
            station_image_bytes=station_img,
            province_images=prov_imgs,
        )

        print(f"  [OK] PDF generado: {output_path}")
        return output_path

    finally:
        conn.close()


def main():
    parser = argparse.ArgumentParser(
        description="Generador de Fichas de Estación Meteorológica (PDF)"
    )
    parser.add_argument('--mock', action='store_true',
                        help='Generar ficha con datos ficticios')
    parser.add_argument('--estacion', type=int, default=None,
                        help='ID de la estación')
    parser.add_argument('--year', type=int, default=None,
                        help='Año de los datos')
    parser.add_argument('--all', action='store_true',
                        help='Generar fichas de todas las estaciones activas')

    args = parser.parse_args()

    if args.mock:
        generate_mock()
    elif args.estacion and args.year:
        generate_from_db(args.estacion, args.year)
    elif args.all and args.year:
        print("Modo --all aún no implementado. Use --estacion ID --year AÑO")
    else:
        parser.print_help()
        print("\n  Ejemplo rápido: python generate.py --mock")


if __name__ == "__main__":
    main()
