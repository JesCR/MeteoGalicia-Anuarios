# -*- coding: utf-8 -*-
"""
Datos ficticios realistas para desarrollo sin conexión a BD.
Simulan una estación costera gallega típica (CIS Ferrol).
"""

import random
import math

random.seed(42)


def get_station_info_mock():
    """Información de la estación."""
    return {
        "idEstacion": 10045,
        "Estacion": "CIS FERROL",
        "NombreCorto": "CIS Ferrol",
        "Provincia": "A CORUÑA",
        "Concello": "Ferrol",
        "Alt": 38.0,
        "Lat": 43.48330,
        "Lon": -8.23330,
    }


def get_annual_summary_mock(year=2023):
    """Resumen anual (tabla RESUMO ANUAL de la ficha)."""
    return {
        "year": year,
        "TA": 14.6,           # Tª media
        "TMAXMED": 18.4,      # Tª máx media
        "TMINMED": 11.2,      # Tª mín media
        "TMAX": 29.4,         # Tª máx absoluta
        "FTMAX": f"22/07/{year}",
        "TMIN": 1.9,          # Tª mín absoluta
        "FTMIN": f"07/03/{year}",
        "HRMED": 79,          # Humedad relativa media %
        "PP": 2893,           # Precipitación total mm
        "PPMAX": 35,          # Precipitación máx diaria mm
        "FPPMAX": f"11/01/{year}",
        "NDPP": 194,          # Días de lluvia
        "NDX": None,          # Días de helada (None = no disponible)
        "HSOL": 2099,         # Horas de sol
        "IRD": 12.8,          # Irradiación media diaria MJ/m2
        "INS": None,          # Insolación %
        "VV": 3.0,            # Velocidad media viento m/s
        "GT": 25.5,           # Racha máxima m/s
        "FGTMAX": f"15/02/{year}",
        "BHC": None,          # Balance hídrico
        "PR": None,           # Presión
    }


def get_monthly_data_mock(year=2023):
    """
    Datos mensuales para las gráficas.
    Devuelve dict con arrays de 12 valores (uno por mes).
    """
    # Temperaturas: patrón sinusoidal realista para Galicia costera
    tmax_med = [13.2, 13.8, 15.5, 16.1, 18.5, 21.3, 23.1, 23.8, 22.0, 18.9, 15.5, 13.5]
    tmin_med = [7.1, 7.0, 8.2, 8.9, 11.0, 13.5, 15.2, 15.5, 14.1, 11.8, 9.2, 7.8]
    tmax_abs = [18.5, 19.2, 22.1, 23.5, 26.8, 29.0, 29.4, 30.2, 28.5, 24.1, 20.3, 17.8]
    tmin_abs = [2.1, 1.9, 3.5, 5.2, 7.8, 10.5, 12.8, 13.1, 11.2, 8.5, 4.8, 3.2]
    ta_med = [(mx + mn) / 2 for mx, mn in zip(tmax_med, tmin_med)]

    # Días de helada por mes
    helada = [3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 1, 2]

    # Precipitación mensual (mm)
    pp = [320, 250, 180, 150, 120, 60, 35, 45, 90, 210, 280, 350]
    # Balance hídrico (PP - ETP estimada)
    bhc = [290, 220, 130, 80, 30, -60, -100, -80, -10, 150, 240, 320]

    # Humedad relativa %
    hr_med = [82, 80, 78, 76, 75, 74, 73, 74, 76, 80, 82, 83]
    hr_max = [95, 94, 93, 92, 91, 90, 88, 89, 91, 94, 95, 96]
    hr_min = [55, 52, 48, 45, 42, 38, 35, 37, 42, 50, 55, 58]

    # Insolación (% de horas posibles)
    ins = [30, 35, 45, 50, 55, 60, 65, 62, 55, 42, 32, 28]

    # Viento: frecuencia por dirección (% de registros 10-minutales)
    # Sectores: N, NE, E, SE, S, SO, O, NO
    wind_freq = [8.5, 12.3, 5.2, 7.8, 10.1, 18.5, 15.2, 22.4]  # Suma < 100 (resto = calmas)
    calmas_pct = 100.0 - sum(wind_freq)

    # Velocidad media por dirección (m/s)
    wind_speed = [3.2, 2.8, 2.1, 2.5, 3.5, 4.2, 3.8, 4.5]

    return {
        "tmax_med": tmax_med,
        "tmin_med": tmin_med,
        "tmax_abs": tmax_abs,
        "tmin_abs": tmin_abs,
        "ta_med": ta_med,
        "helada": helada,
        "pp": pp,
        "bhc": bhc,
        "hr_med": hr_med,
        "hr_max": hr_max,
        "hr_min": hr_min,
        "ins": ins,
        "wind_freq": wind_freq,
        "wind_speed": wind_speed,
        "calmas_pct": calmas_pct,
    }


def get_station_image_mock():
    """Devuelve None (sin imagen en modo mock)."""
    return None


def get_province_images_mock():
    """Devuelve None (sin imagen de provincia en modo mock)."""
    return {"ubicacion": None, "provincia": None}
