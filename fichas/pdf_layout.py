# -*- coding: utf-8 -*-
"""
Composición del PDF de ficha de estación con ReportLab.
Layout A4 con posicionamiento absoluto.
"""

import io
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm, cm
from reportlab.lib.colors import HexColor, black, white, Color
from reportlab.pdfgen import canvas
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

from config import (
    PAGE_W, PAGE_H, MARGIN_LEFT, MARGIN_RIGHT, MARGIN_TOP, MARGIN_BOTTOM,
    CONTENT_W, COLOR_TITLE, COLOR_HEADER_BG,
)

# ─── Constantes de layout (en puntos, origen abajo-izquierda) ────────
# Página 1
HEADER_Y = PAGE_H - MARGIN_TOP
HEADER_H = 22

# Zona cabecera: foto + mapa + resumen
PHOTO_X = MARGIN_LEFT
PHOTO_Y = HEADER_Y - HEADER_H - 8 - 120
PHOTO_W = 200
PHOTO_H = 120

MAP_X = PHOTO_X + PHOTO_W + 20
MAP_Y = PHOTO_Y
MAP_W = 140
MAP_H = 120

PROV_X = MAP_X + MAP_W + 10
PROV_Y = MAP_Y + 20
PROV_W = 60

# Resumen anual
SUMMARY_X = MARGIN_LEFT + CONTENT_W * 0.52
SUMMARY_Y = PHOTO_Y - 10
SUMMARY_W = CONTENT_W * 0.48
SUMMARY_H = 200

# Gráfica 1 (temperaturas)
G1_X = MARGIN_LEFT
G1_Y = PHOTO_Y - 15 - 180
G1_W = CONTENT_W * 0.50
G1_H = 180

# Tabla resumen anual al lado de G1
RS_X = MARGIN_LEFT + CONTENT_W * 0.52
RS_Y = G1_Y
RS_W = CONTENT_W * 0.48
RS_H = 180

# Gráficas 2 y 3
G2_X = MARGIN_LEFT
G2_Y = G1_Y - 15 - 175
G2_W = CONTENT_W * 0.50
G2_H = 175

G3_X = MARGIN_LEFT + CONTENT_W * 0.52
G3_Y = G2_Y
G3_W = CONTENT_W * 0.48
G3_H = 175

# Página 2: Rosas de viento
G4_X = MARGIN_LEFT + 20
G4_Y = PAGE_H - MARGIN_TOP - 30 - 280
G4_W = 240
G4_H = 280

G5_X = G4_X + G4_W + 30
G5_Y = G4_Y
G5_W = 240
G5_H = 280


class FichaEstacionPDF:
    """Genera el PDF de ficha de estación."""

    def __init__(self, output_path):
        self.output_path = output_path
        self.c = canvas.Canvas(output_path, pagesize=A4)
        self.c.setTitle("Ficha de Estación Meteorológica")

    def generate(self, station_info, annual_summary, charts_io,
                 station_image_bytes=None, province_images=None):
        """
        Genera el PDF completo.

        Args:
            station_info: dict con nombre, provincia, etc.
            annual_summary: dict con resumen anual
            charts_io: dict con keys 'g1'...'g5', valores BytesIO con PNG
            station_image_bytes: bytes de la foto de la estación (o None)
            province_images: dict con 'ubicacion' y 'provincia' bytes (o None)
        """
        province_images = province_images or {}

        # ═══ PÁGINA 1 ═══
        self._draw_header(station_info)
        self._draw_station_photo(station_image_bytes)
        self._draw_map(province_images)
        self._draw_province_label(station_info)
        self._draw_chart(charts_io['g1'], G1_X, G1_Y, G1_W, G1_H)
        self._draw_summary_table(annual_summary)
        self._draw_chart(charts_io['g2'], G2_X, G2_Y, G2_W, G2_H)
        self._draw_chart(charts_io['g3'], G3_X, G3_Y, G3_W, G3_H)

        # ═══ PÁGINA 2 ═══
        self.c.showPage()
        self._draw_header(station_info, subtitle="(continuación)")
        self._draw_chart(charts_io['g4'], G4_X, G4_Y, G4_W, G4_H)
        self._draw_chart(charts_io['g5'], G5_X, G5_Y, G5_W, G5_H)

        self.c.save()

    # ─── Dibujo de componentes ────────────────────────────────────────

    def _draw_header(self, info, subtitle=None):
        """Barra de título con nombre de estación."""
        c = self.c
        y = HEADER_Y - HEADER_H

        # Fondo gris
        c.setFillColor(Color(*COLOR_HEADER_BG))
        c.rect(MARGIN_LEFT, y, CONTENT_W, HEADER_H, fill=1, stroke=0)

        # Texto
        c.setFillColor(Color(*COLOR_TITLE))
        c.setFont("Helvetica-Bold", 14)
        title = info.get("Estacion", "ESTACIÓN").upper()
        if subtitle:
            title += f"  {subtitle}"
        c.drawCentredString(PAGE_W / 2, y + 6, title)

    def _draw_station_photo(self, image_bytes):
        """Foto de la estación."""
        c = self.c
        if image_bytes:
            img = ImageReader(io.BytesIO(image_bytes))
            c.drawImage(img, PHOTO_X, PHOTO_Y, PHOTO_W, PHOTO_H,
                        preserveAspectRatio=True, anchor='c')
        else:
            # Placeholder
            c.setStrokeColor(Color(0.7, 0.7, 0.7))
            c.setFillColor(Color(0.95, 0.95, 0.95))
            c.rect(PHOTO_X, PHOTO_Y, PHOTO_W, PHOTO_H, fill=1, stroke=1)
            c.setFillColor(Color(0.5, 0.5, 0.5))
            c.setFont("Helvetica", 9)
            c.drawCentredString(PHOTO_X + PHOTO_W/2, PHOTO_Y + PHOTO_H/2,
                                "Fotografía da estación")

    def _draw_map(self, province_images):
        """Mapa de ubicación de la estación."""
        c = self.c
        ubi = province_images.get("ubicacion")
        if ubi:
            img = ImageReader(io.BytesIO(ubi))
            c.drawImage(img, MAP_X, MAP_Y, MAP_W, MAP_H,
                        preserveAspectRatio=True, anchor='c')
        else:
            c.setStrokeColor(Color(0.7, 0.7, 0.7))
            c.setFillColor(Color(0.95, 0.95, 0.95))
            c.rect(MAP_X, MAP_Y, MAP_W, MAP_H, fill=1, stroke=1)
            c.setFillColor(Color(0.5, 0.5, 0.5))
            c.setFont("Helvetica", 9)
            c.drawCentredString(MAP_X + MAP_W/2, MAP_Y + MAP_H/2,
                                "Localización da estación")

    def _draw_province_label(self, info):
        """Nombre de provincia en vertical."""
        c = self.c
        provincia = info.get("Provincia", "")
        if provincia:
            c.saveState()
            c.setFont("Helvetica-Bold", 14)
            c.setFillColor(Color(0.4, 0.4, 0.4))
            c.translate(PROV_X + 15, PROV_Y)
            c.rotate(90)
            # Escribir cada carácter separado verticalmente
            for i, ch in enumerate(provincia):
                c.drawCentredString(i * 14, 0, ch)
            c.restoreState()

    def _draw_chart(self, chart_io, x, y, w, h):
        """Incrusta una gráfica PNG en la posición indicada."""
        c = self.c
        if chart_io:
            chart_io.seek(0)
            img = ImageReader(chart_io)
            c.drawImage(img, x, y, w, h,
                        preserveAspectRatio=True, anchor='c')

    def _draw_summary_table(self, summary):
        """Tabla RESUMO ANUAL con las variables anuales."""
        c = self.c
        x0 = RS_X
        y_top = PHOTO_Y + PHOTO_H - 5  # Alinear con la parte superior de la foto
        w = RS_W

        # Título
        c.setFont("Helvetica-Bold", 9)
        c.setFillColor(Color(*COLOR_TITLE))
        c.drawString(x0, y_top, "RESUMO ANUAL")
        y = y_top - 14

        # Filas de la tabla
        rows = self._get_summary_rows(summary)

        row_h = 12
        col_label_w = w * 0.55
        col_val_w = w * 0.18
        col_unit_w = w * 0.12
        col_date_w = w * 0.15

        c.setFont("Helvetica", 7)

        for label, value, unit, date in rows:
            # Fondo alternado
            idx = rows.index((label, value, unit, date))
            if idx % 2 == 0:
                c.setFillColor(Color(0.95, 0.95, 0.95))
                c.rect(x0, y - 2, w, row_h, fill=1, stroke=0)

            c.setFillColor(Color(*COLOR_TITLE))
            c.setFont("Helvetica", 7)
            c.drawString(x0 + 2, y + 1, label)
            c.drawRightString(x0 + col_label_w + col_val_w, y + 1,
                              str(value) if value is not None else "-")
            c.drawString(x0 + col_label_w + col_val_w + 4, y + 1, unit)
            if date:
                c.setFont("Helvetica", 6)
                c.drawString(x0 + col_label_w + col_val_w + col_unit_w + 4,
                             y + 1, str(date))

            y -= row_h

        # Borde exterior
        total_h = len(rows) * row_h + 4
        c.setStrokeColor(Color(0.5, 0.5, 0.5))
        c.rect(x0, y_top - total_h, w, total_h + 14, fill=0, stroke=1)

    def _get_summary_rows(self, s):
        """Construye las filas de la tabla RESUMO ANUAL."""
        def fmt(v, dec=1):
            if v is None:
                return "-"
            if dec == 0:
                return str(int(round(v)))
            return f"{v:.{dec}f}"

        return [
            ("Tª media:",              fmt(s.get("TA")),       "°C", ""),
            ("Tª máx. media:",         fmt(s.get("TMAXMED")),  "°C", ""),
            ("Tª mín. media:",         fmt(s.get("TMINMED")),  "°C", ""),
            ("Tª máx. absoluta:",      fmt(s.get("TMAX")),     "°C", s.get("FTMAX", "")),
            ("Tª mín. absoluta:",      fmt(s.get("TMIN")),     "°C", s.get("FTMIN", "")),
            ("Humidade relativa:",     fmt(s.get("HRMED"), 0), "%",  ""),
            ("Precipitación total:",   fmt(s.get("PP"), 0),    "mm", ""),
            ("Precipitación máx. diaria:", fmt(s.get("PPMAX"), 0), "mm", s.get("FPPMAX", "")),
            ("Días de choiva:",        fmt(s.get("NDPP"), 0),  "",   ""),
            ("Días de xeada:",         fmt(s.get("NDX"), 0),   "",   ""),
            ("Horas de sol:",          fmt(s.get("HSOL"), 0),  "h",  ""),
            ("Irradiación media diaria:", fmt(s.get("IRD")),   "MJ/m²", ""),
            ("Velocidade media vento:", fmt(s.get("VV")),      "m/s", ""),
            ("Refacho máximo diario:", fmt(s.get("GT")),       "m/s", s.get("FGTMAX", "")),
        ]
