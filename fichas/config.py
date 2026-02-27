# -*- coding: utf-8 -*-
"""
Configuración del proyecto Fichas de Estación.
"""

import os

# ─── Conexión a BD ───────────────────────────────────────────────────
from dotenv import load_dotenv
load_dotenv()

DB_SERVER = os.environ.get("DB_SERVER", r"SERVIDOR\INSTANCIA")
DB_NAME   = os.environ.get("DB_NAME", "MeteoDatos")
DB_USER   = os.environ.get("DB_USER", "usuario")
DB_PASS   = os.environ.get("DB_PASSWORD", "password")
DB_DRIVER = "{ODBC Driver 17 for SQL Server}"
DB_TRUSTED = os.environ.get("DB_TRUSTED", "False").lower() in ("true", "1", "t")

def get_connection_string():
    if DB_TRUSTED:
        return (
            f"DRIVER={DB_DRIVER};"
            f"SERVER={DB_SERVER};"
            f"DATABASE={DB_NAME};"
            f"Trusted_Connection=yes;"
        )
    else:
        return (
            f"DRIVER={DB_DRIVER};"
            f"SERVER={DB_SERVER};"
            f"DATABASE={DB_NAME};"
            f"UID={DB_USER};"
            f"PWD={DB_PASS};"
        )

# ─── Rutas ───────────────────────────────────────────────────────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
OUTPUT_DIR = os.path.join(BASE_DIR, "output")
DOCS_DIR = os.path.join(os.path.dirname(BASE_DIR), "docs")

# ─── Página PDF (A4 en puntos: 1pt = 1/72 pulgada) ──────────────────
PAGE_W = 595.28  # A4 ancho
PAGE_H = 841.89  # A4 alto
MARGIN_LEFT = 28
MARGIN_RIGHT = 28
MARGIN_TOP = 30
MARGIN_BOTTOM = 30
CONTENT_W = PAGE_W - MARGIN_LEFT - MARGIN_RIGHT
CONTENT_H = PAGE_H - MARGIN_TOP - MARGIN_BOTTOM

# ─── Colores (RGB 0-1 para ReportLab) ────────────────────────────────
COLOR_TITLE = (0.1, 0.1, 0.1)
COLOR_HEADER_BG = (0.85, 0.85, 0.85)
COLOR_LINE_TMAX = (1.0, 0.0, 0.0)        # Rojo
COLOR_LINE_TMIN = (0.0, 0.0, 1.0)        # Azul
COLOR_LINE_TMAXMED = (1.0, 0.5, 0.0)     # Naranja
COLOR_LINE_TMINMED = (0.5, 0.0, 1.0)     # Púrpura
COLOR_BAR_HELADA = (0.6, 0.6, 0.6)       # Gris
COLOR_BAR_PP = (0.2, 0.4, 0.8)           # Azul
COLOR_BAR_BH = (0.6, 0.85, 0.6)          # Verde claro
COLOR_LINE_TMEDIA = (1.0, 0.0, 0.0)      # Rojo
COLOR_BAR_INS = (0.9, 0.2, 0.2)          # Rojo barras
COLOR_LINE_HRMED = (0.0, 0.5, 0.0)       # Verde
COLOR_LINE_HRMAX = (0.0, 0.0, 0.8)       # Azul
COLOR_LINE_HRMIN = (0.5, 0.0, 0.5)       # Morado
COLOR_ROSA_VIENTO = (0.3, 0.3, 0.7)      # Azul-morado
COLOR_ROSA_VELOCIDAD = (0.7, 0.3, 0.3)   # Rojo suave

# ─── Meses (gallego) ─────────────────────────────────────────────────
MESES_GL = ["XAN", "FEB", "MAR", "ABR", "MAI", "XUÑ",
            "XUL", "AGO", "SET", "OUT", "NOV", "DEC"]

MESES_COLS = ["XAN", "FEB", "MAR", "ABR", "MAI", "XUÑ",
              "XUL", "AGO", "SET", "OUT", "NOV", "DEC"]

# ─── Sectores de viento ──────────────────────────────────────────────
WIND_SECTORS = ["N", "NE", "E", "SE", "S", "SO", "O", "NO"]
