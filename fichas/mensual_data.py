# -*- coding: utf-8 -*-
"""
Lectura de CSVs de resumen mensual y preparación de datos
para el PDF del Boletín Mensual Climatolóxico.
"""

import os
import csv


# Columnas del CSV (orden fijo)
CSV_COLS = [
    "Provincia", "NombreEstacion", "InstanteLectura",
    "TA", "TMAXMED", "TMAX", "FTMAX",
    "TMINmed", "TMIN", "FTMIN",
    "PP", "PPMAX", "FPPMAX", "BHC",
    "HRMED", "HRMAX", "HRMIN",
    "INS", "HSOL", "IRD",
    "VV", "GT", "FGTMAX",
    "PR", "NDPP", "NDX",
]

# Columnas visibles en la tabla del PDF y sus cabeceras
# (key_csv, header_line1, header_line2, width_pts, align, decimals)
TABLE_COLUMNS = [
    # Temperatura
    ("TA",      "TªC",      "Med",   30, "R", 1),
    ("TMAXMED", "Tª Máx ºC","Med",   30, "R", 1),    # era 2 decimales en CSV, 1 en PDF
    ("TMAX",    "",          "Abs",   26, "R", 1),
    ("FTMAX",   "",          "Día",   22, "R", 0),
    ("TMINmed", "Tª Mín ºC","Med",   30, "R", 1),
    ("TMIN",    "",          "Abs",   26, "R", 1),
    ("FTMIN",   "",          "Día",   22, "R", 0),
    # Precipitación
    ("PP",      "Precipitación l/m2","Acu",  32, "R", 0),
    ("PPMAX",   "",          "Max",   32, "R", 1),
    ("FPPMAX",  "",          "Día",   22, "R", 0),
    # BHC
    ("BHC",     "BHC",      "l/m2",  30, "R", 0),
    # Humedad
    ("HRMED",   "Humidade Rel. %","Med", 26, "R", 0),
    ("HRMAX",   "",          "Max",   26, "R", 0),
    ("HRMIN",   "",          "Min",   26, "R", 0),
    # Radiación Solar
    ("INS",     "Radiación Solar", "Insolación\n%", 22, "R", 0),
    ("HSOL",    "",          "Horas\nde sol", 26, "R", 0),
    ("IRD",     "",          "Irradiación\n10kJ/m2", 30, "R", 0),
    # Viento
    ("VV",      "Vento km/h","Veloc.\nmedia", 26, "R", 0),
    ("GT",      "",          "Racha\nmáx",  26, "R", 0),
    ("FGTMAX",  "",          "Día",   22, "R", 0),
    # Presión
    ("PR",      "Presión",  "Med\nhPa",  32, "R", 0),
    # Días
    ("NDPP",    "Nº Días",  "Choiva", 28, "R", 0),
    ("NDX",     "",          "Xeada",  26, "R", 0),
]

# Ancho de la columna Estación (primera columna, tras Provincia)
COL_ESTACION_W = 100

MESES_GL_FULL = [
    "Xaneiro", "Febreiro", "Marzo", "Abril", "Maio", "Xuño",
    "Xullo", "Agosto", "Setembro", "Outubro", "Novembro", "Decembro"
]


def _parse_value(raw, decimals):
    """Convierte un valor crudo del CSV a string para mostrar."""
    raw = raw.strip()
    if raw in ("", "**", "--", "--;"):
        return raw.replace(";", "")
    # Intentar formatear numéricamente
    try:
        v = float(raw)
        if decimals == 0:
            return str(int(round(v)))
        return f"{v:.{decimals}f}"
    except ValueError:
        return raw


def load_mensual_csv(csv_path):
    """
    Lee un CSV de resumen mensual.
    Retorna:
      {
        'year': int, 'month': int,
        'provincias': OrderedDict { provincia: [
            {'name': str, 'starred': bool, 'values': {col_key: str, ...}},
            ...
        ]}
      }
    """
    from collections import OrderedDict

    provincias = OrderedDict()
    year, month = None, None

    with open(csv_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.reader(f, delimiter=';')
        header = next(reader)  # skip header

        for row in reader:
            if len(row) < len(CSV_COLS):
                continue

            prov = row[0].strip()
            name = row[1].strip()
            fecha = row[2].strip()  # "01/01/2025 0:00:00"

            if year is None and fecha:
                parts = fecha.split()[0].split('/')
                if len(parts) == 3:
                    month = int(parts[1])
                    year = int(parts[2])

            # Detectar estaciones con *
            starred = name.startswith('*')

            # Parsear valores para cada columna de la tabla
            values = {}
            for col_key, _, _, _, _, decimals in TABLE_COLUMNS:
                idx = CSV_COLS.index(col_key)
                values[col_key] = _parse_value(row[idx], decimals)

            if prov not in provincias:
                provincias[prov] = []
            provincias[prov].append({
                'name': name,
                'starred': starred,
                'values': values,
            })

    return {'year': year or 0, 'month': month or 0, 'provincias': provincias}


def load_all_mensual(csv_dir, year):
    """
    Carga los 12 CSVs de un año.
    Retorna lista de 12 dicts (uno por mes) en orden Ene-Dic.
    Meses sin CSV se omiten.
    """
    results = []
    for m in range(1, 13):
        fname = f"resumo{year}{m:02d}.csv"
        path = os.path.join(csv_dir, fname)
        if os.path.exists(path):
            data = load_mensual_csv(path)
            results.append(data)
    return results
