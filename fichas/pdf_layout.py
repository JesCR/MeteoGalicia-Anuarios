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
# Página 1 (Todo en una página)
HEADER_Y = PAGE_H - MARGIN_TOP
HEADER_H = 30

# ─── Fila 1 (Fila Superior): 4 columnas de izquierda a derecha ──────
# Anchura disponible: PAGE_W - MARGIN_LEFT - MARGIN_RIGHT = ~539 pts
# Col1 (Logo prov): 90pts | Col2 (Foto): 155pts | Col3 (Texto): 155pts | Col4 (Mapa): 125pts
# con 6pts de separación entre columnas.
ROW1_Y    = 640   # Coordenada Y del borde inferior de la fila
ROW1_H    = 140   # Altura de la fila

GAP = 6   # Separación entre columnas

# Col 1: Logo/imagen de provincia (izquierda, pegado al margen)
PROV_W = 90
PROV_H = ROW1_H
PROV_X = MARGIN_LEFT
PROV_Y = ROW1_Y

# Col 2: Foto de la estación
PHOTO_W = 155
PHOTO_H = ROW1_H
PHOTO_X = PROV_X + PROV_W + GAP
PHOTO_Y = ROW1_Y

# Col 3: Texto con info de la estación (+8 pts extra para no cortar texto)
TEXT_COL_W = 163
TEXT_X = PHOTO_X + PHOTO_W + GAP
TEXT_Y = ROW1_Y + ROW1_H  # Texto arranca desde el borde superior de la fila

# Col 4: Mapa del concello con punto rojo (derecha, pegado al margen)
MAP_W = PAGE_W - MARGIN_RIGHT - (TEXT_X + TEXT_COL_W + GAP)
MAP_W = max(MAP_W, 120)
MAP_H = ROW1_H
MAP_X = PAGE_W - MARGIN_RIGHT - MAP_W
MAP_Y = ROW1_Y

# G1 y tabla RESUMO ANUAL alineados verticalmente
G1_X = MARGIN_LEFT - 10
G1_W = 270           # Ligeramente más estrecha para dar air al eje derecho
G1_H = 175
G1_Y = 455   # Borde inferior de la fila 2 (= 460 - 5)

# La tabla empieza 18 pts a la derecha del borde derecho de G1
RS_X = G1_X + G1_W + 18
RS_W = PAGE_W - MARGIN_RIGHT - RS_X
RS_Y = G1_Y          # Mismo Y base que G1
RS_H = G1_H          # Misma altura que G1  → RESUMO ANUAL al nivel del top de G1

# Fila 3: Gráficas G2 (Izquierda) y G3 (Derecha)
# G2 más estrecha + G3 desplazada a la derecha → gap real entre ejes Y
ROW3_Y = 270
ROW3_H = 160

G2_X = MARGIN_LEFT - 10
G2_W = 255          # Reducida para que su eje Y derecho no toque al de G3
G2_H = 170
G2_Y = ROW3_Y

G3_X = PAGE_W / 2 + 15   # Más a la derecha → mayor separación entre gráficas
G3_W = 245                # Más estrecha → misma escala visual que G2
G3_H = 170
G3_Y = ROW3_Y

# Fila 4: Rosas de viento
ROW4_Y = 90
ROW4_H = 170

G4_X = MARGIN_LEFT + 10
G4_W = 250
G4_H = 180
G4_Y = ROW4_Y

G5_X = PAGE_W / 2 + 10
G5_W = 250
G5_H = 180
G5_Y = ROW4_Y


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

        # ═══ PÁGINA ÚNICA ═══
        self._draw_header(station_info)
        self._draw_station_photo(station_image_bytes)
        self._draw_map(province_images)
        
        # Fila 2
        self._draw_chart(charts_io['g1'], G1_X, G1_Y, G1_W, G1_H)
        self._draw_summary_table(annual_summary)
        
        # Fila 3
        self._draw_chart(charts_io['g2'], G2_X, G2_Y, G2_W, G2_H)
        self._draw_chart(charts_io['g3'], G3_X, G3_Y, G3_W, G3_H)

        # Fila 4
        self._draw_chart(charts_io['g4'], G4_X, G4_Y, G4_W, G4_H)
        self._draw_chart(charts_io['g5'], G5_X, G5_Y, G5_W, G5_H)

        self._draw_footer()
        self.c.save()

    # ─── Dibujo de componentes ────────────────────────────────────────

    def _draw_header(self, info):
        """Bloque de texto con nombre de estación y coordenadas (Col 3)."""
        c = self.c

        # Coordenada Y de partida (tope de la fila)
        y = TEXT_Y
        line_gap_big   = 18
        line_gap_small = 15

        # Nombre de estación
        c.setFillColor(Color(0.15, 0.15, 0.15))
        c.setFont("Helvetica-Bold", 11)
        c.drawString(TEXT_X, y, f"Estación {info.get('Estacion', 'ESTACIÓN')}")
        y -= line_gap_big

        # Concello y Provincia
        concello  = info.get("Concello", "").upper()
        provincia = info.get("Provincia", "")
        prov_abbr = provincia[:2].upper() if provincia else ""
        c.setFont("Helvetica-Bold", 10)
        c.drawString(TEXT_X, y, f"{concello} ({prov_abbr})")
        y -= line_gap_big

        # Localización (negrita para la etiqueta, normal para el valor)
        lat = info.get("Lat")
        lon = info.get("Lon")
        lat_str = f"{lat:.5f}" if lat is not None else "N/A"
        lon_str = f"{lon:.6f}" if lon is not None else "N/A"

        c.setFillColor(Color(0.3, 0.3, 0.3))
        c.setFont("Helvetica-Bold", 9)
        c.drawString(TEXT_X, y, "Localización")
        c.setFont("Helvetica", 9)
        c.drawString(TEXT_X + 62, y, f"{lat_str} | {lon_str} WGS84")
        y -= line_gap_small

        c.setFont("Helvetica", 9)
        c.drawString(TEXT_X, y, "(EPSG:4326)")
        y -= line_gap_big

        # Altitud
        alt = info.get("Alt")
        alt_str = f"{int(round(alt))}" if alt is not None else "N/A"
        c.setFont("Helvetica-Bold", 9)
        c.drawString(TEXT_X, y, "Altitude")
        c.setFont("Helvetica", 9)
        c.drawString(TEXT_X + 42, y, f"{alt_str} m")


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
            c.setFont("Helvetica-Bold", 8)
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
        
        prov = province_images.get("provincia")
        if prov:
            img = ImageReader(io.BytesIO(prov))
            c.drawImage(img, PROV_X, PROV_Y, PROV_W, PROV_H,
                        preserveAspectRatio=True, anchor='c')

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
        y_top = RS_Y + RS_H  # Alineado a la derecha de la gráfica G1
        w = RS_W

        # Título
        c.setFont("Helvetica-Bold", 9)
        c.setFillColor(Color(0.2, 0.2, 0.2)) # Casi negro
        c.drawString(x0, y_top + 10, "RESUMO ANUAL")
        y = y_top - 5

        # Filas de la tabla
        rows = self._get_summary_rows(summary)

        row_h = 11
        col_label_w = w * 0.50
        col_val_w = w * 0.20
        col_unit_w = w * 0.12
        col_date_w = w * 0.18

        for label, value, unit, date in rows:
            c.setFillColor(Color(*COLOR_TITLE))
            c.setFont("Helvetica", 8)
            c.drawString(x0 + 2, y + 1, label)
            c.drawRightString(x0 + col_label_w + col_val_w, y + 1,
                              str(value) if value is not None else "-")
            c.drawString(x0 + col_label_w + col_val_w + 4, y + 1, unit)
            if date:
                c.setFont("Helvetica", 7)
                c.drawString(x0 + col_label_w + col_val_w + col_unit_w + 4,
                             y + 1, str(date))

            y -= row_h

    def _draw_footer(self):
        """Pie de página azul."""
        c = self.c
        # Banda azul
        c.setFillColor(HexColor("#0077b6")) # Azul Meteogalicia aprox.
        c.rect(MARGIN_LEFT, 40, PAGE_W - MARGIN_LEFT - MARGIN_RIGHT, 25, fill=1, stroke=0)
        
        # Número de página (ejemplo 85)
        c.setFillColor(white)
        c.setFont("Helvetica-Bold", 16)
        c.drawString(MARGIN_LEFT + 15, 47, "85")

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
            ("Velocidade media vento:", fmt(s.get("VV")),      "km/h", ""),
            ("Refacho máximo diario:", fmt(s.get("GT")),       "km/h", s.get("FGTMAX", "")),
        ]
