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
    COORD_TABLE_ROW_H, COORD_FONT_SIZE, COORD_HEADER_FONT_SIZE,
    COORD_TITLE_FONT_SIZE, COORD_COL_WIDTHS, COORD_PROVINCIAS,
    TABLA_COL_EST, TABLA_COL_MES, TABLA_COL_ANUAL,
    TABLA_ROW_H, TABLA_FONT_SIZE, TABLA_HDR_FONT_SIZE, TABLA_TITLE_FONT_SIZE,
)

# ─── Constantes de layout (en puntos, origen abajo-izquierda) ────────
# Página 1 (Todo en una página)
HEADER_Y = PAGE_H - MARGIN_TOP
HEADER_H = 30

# ─── Fila 0 (Header Principal): Logo MeteoGalicia y Consellería ────────
# Coordenadas relativas al borde superior
MAIN_HEADER_Y = PAGE_H - 15
LOGO_W = 140
LOGO_H = 32
# Desplazamiento a la izquierda para que visualmente empiece con el texto
LOGO_X = MARGIN_LEFT - 12
TEXT_XUNTA_FONT_SIZE = 8

# ─── Fila 1 (Fila Superior): 4 columnas de izquierda a derecha ──────
# Anchura disponible: PAGE_W - MARGIN_LEFT - MARGIN_RIGHT = ~539 pts
# Col1 (Foto): 155pts | Col2 (Texto): 165pts | Col3 (Mapa): 120pts | Col4 (Escudo): 75pts
ROW1_TOP_Y = 770  # Techo común para toda la fila
ROW1_H     = 140   # Altura de la fila
ROW1_Y     = ROW1_TOP_Y - ROW1_H 

GAP = 6   # Separación entre columnas

# Col 1: Foto de la estación (Ahora a la izquierda)
PHOTO_W = 155
PHOTO_H = ROW1_H
PHOTO_X = MARGIN_LEFT

# Col 2: Texto con info de la estación
TEXT_COL_W = 165
TEXT_X = PHOTO_X + PHOTO_W + GAP
# Alineamos con el techo (bajando 10pts para que el 'top' de la letra toque la línea)
TEXT_Y = ROW1_TOP_Y - 10

# Col 3: Mapa del concello con punto rojo
MAP_W = 120
MAP_H = ROW1_H
MAP_X = TEXT_X + TEXT_COL_W + GAP

# Col 4: Logo/imagen de provincia (Vertical, ahora al final)
PROV_W = 75   # Lo estrechamos un poco para que quepa bien al final
PROV_H = 150
PROV_X = PAGE_W - MARGIN_RIGHT - PROV_W
PROV_Y = ROW1_TOP_Y - PROV_H

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

# Fila 4: Rosa de viento y tablas auxiliares
ROW4_Y = 110
ROW4_H = 160

G4_X = MARGIN_LEFT - 10
G4_W = 280
G4_H = 170
G4_Y = ROW4_Y

WT_X = G4_X + G4_W + 10
WT_W = PAGE_W - MARGIN_RIGHT - WT_X
WT_Y = G4_Y


class FichaEstacionPDF:
    """Genera el PDF de ficha de estación."""

    def __init__(self, output_path, start_page=1):
        self.output_path = output_path
        self.c = canvas.Canvas(output_path, pagesize=A4)
        self.c.setTitle("Ficha de Estación Meteorológica")
        self.current_page = start_page

    def add_station_page(self, station_info, annual_summary, charts_io,
                         station_image_bytes=None, province_images=None):
        """
        Añade una página de ficha de estación al PDF.

        Args:
            station_info: dict con nombre, provincia, etc.
            annual_summary: dict con resumen anual
            charts_io: dict con keys 'g1'...'g5', valores BytesIO con PNG
            station_image_bytes: bytes de la foto de la estación (o None)
            province_images: dict con 'ubicacion' y 'provincia' bytes (o None)
        """
        province_images = province_images or {}

        # ═══ DIBUJO DE COMPONENTES ═══
        self._draw_main_header()
        
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
        if charts_io.get('g4'):
            self._draw_chart(charts_io['g4'], G4_X, G4_Y, G4_W, G4_H)
            # Dibujar tablas de viento a la derecha de la rosa
            wind_summary = annual_summary.get("wind_summary", {})
            self._draw_wind_tables(wind_summary)

        self._draw_footer()
        
        # Finalizar página y preparar la siguiente
        self.c.showPage()
        self.current_page += 1

    # ─── Páginas de Coordenadas ──────────────────────────────────────

    def add_coordenadas_pages(self, data_by_provincia):
        """
        Genera una página de coordenadas por cada provincia.
        Devuelve {provincia: número_de_página_inicial}.
        """
        prov_pages = {}
        for prov in COORD_PROVINCIAS:
            prov_pages[prov] = self.current_page
            estaciones = data_by_provincia.get(prov, [])
            self._draw_coordenadas_table(prov, estaciones)
        return prov_pages

    # ─── Páginas de Tablas de Datos Anuales ──────────────────────────

    def add_tablas_pages(self, tablas_data):
        """Genera todas las secciones del PDF de tablas anuales.
        Devuelve [(titulo, página_inicial)] para el índice."""
        section_pages = []
        for section in tablas_data.get('sections', []):
            start = self.current_page
            self._draw_tabla_section(section)
            section_pages.append((section['title'], start))
        return section_pages

    # ─── Página de Índice ────────────────────────────────────────────────

    def add_indice_pages(self, toc_entries, year):
        """
        Genera la página(s) de índice con líneas de puntos y número de página.
        toc_entries: lista de {'level': 0|1, 'title': str, 'page': int|None}
          level=0 → cabecera de sección (negrita, sin guiones)
          level=1 → entrada con puntos y número de página
        """
        c = self.c
        self._draw_main_header()

        # Título
        title_y = MAIN_HEADER_Y - LOGO_H - 22
        c.setFont("Helvetica-Bold", 14)
        c.setFillColor(black)
        c.drawCentredString(PAGE_W / 2, title_y, "ÍNDICE")

        # Subtítulo año
        c.setFont("Helvetica", 9)
        c.setFillColor(Color(0.35, 0.35, 0.35))
        c.drawCentredString(PAGE_W / 2, title_y - 14,
                            f"Anuario Meteorolóxico {year}")

        # Línea separadora
        sep_y = title_y - 24
        c.setStrokeColor(HexColor("#0077b6"))
        c.setLineWidth(1)
        c.line(MARGIN_LEFT, sep_y, PAGE_W - MARGIN_RIGHT, sep_y)

        y = sep_y - 10
        table_bottom_y = 75

        def _check_page():
            nonlocal y
            if y < table_bottom_y:
                self._draw_footer()
                c.showPage()
                self.current_page += 1
                self._draw_main_header()
                y = MAIN_HEADER_Y - LOGO_H - 20

        for entry in toc_entries:
            _check_page()
            level  = entry.get('level', 1)
            title  = entry['title']
            page   = entry.get('page')

            if level == 0:
                # Cabecera de sección
                y -= 4
                c.setFont("Helvetica-Bold", 9)
                c.setFillColor(HexColor("#0077b6"))
                c.drawString(MARGIN_LEFT, y, title.upper())
                y -= 13
            else:
                # Entrada con puntos
                indent = MARGIN_LEFT + 12
                font_name, font_size = "Helvetica", 8
                c.setFont(font_name, font_size)
                c.setFillColor(black)

                if page is not None:
                    page_str = str(page)
                    title_w  = c.stringWidth(title, font_name, font_size)
                    page_w   = c.stringWidth(page_str, font_name, font_size)
                    dot_w    = c.stringWidth(".", font_name, font_size)
                    right_x  = PAGE_W - MARGIN_RIGHT
                    page_x   = right_x - page_w
                    dot_end  = page_x - 4
                    dot_start = indent + title_w + 4
                    num_dots = max(0, int((dot_end - dot_start) / dot_w))

                    c.drawString(indent, y, title)
                    c.drawString(dot_start, y, "." * num_dots)
                    c.drawRightString(right_x, y, page_str)
                else:
                    c.drawString(indent, y, title)

                y -= 12

        self._draw_footer()
        c.showPage()
        self.current_page += 1

    def _draw_tabla_section(self, section):
        """
        Dibuja una sección completa (una o más páginas) de la tabla de datos anuales.
        Cada sección = un parámetro (VV, TA, PP, etc.).
        """
        from config import MESES_GL
        c = self.c
        title    = section['title']
        note     = section.get('note')
        decimals = section['decimals']
        data     = section['data']   # OrderedDict {prov: [rows]}

        MONTHS_HDR  = ["XAN","FEB","MAR","ABR","MAI","XUÑ",
                        "XUL","AGO","SET","OUT","NOV","DEC","ANUAL"]
        col_widths  = [TABLA_COL_EST] + [TABLA_COL_MES] * 12 + [TABLA_COL_ANUAL]
        table_bottom_y = 75

        # Calcula Y de inicio de tabla según si hay nota o no
        note_extra = 14 if note else 0
        table_top_y = MAIN_HEADER_Y - LOGO_H - 45 - note_extra

        def _draw_page_headers():
            """Dibuja cabecera de página, título, nota y cabecera de columnas.
            Devuelve Y de inicio de primera fila de datos."""
            self._draw_main_header()

            # Título
            c.setFont("Helvetica-Bold", TABLA_TITLE_FONT_SIZE)
            c.setFillColor(black)
            title_y = MAIN_HEADER_Y - LOGO_H - 25
            c.drawCentredString(PAGE_W / 2, title_y, title)

            # Nota opcional
            if note:
                c.setFont("Helvetica", 8)
                c.drawCentredString(PAGE_W / 2, title_y - 14, note)

            # Cabecera de columnas
            y = table_top_y
            c.setFillColor(HexColor("#bfbfbf"))
            c.rect(MARGIN_LEFT, y - TABLA_ROW_H + 3, CONTENT_W, TABLA_ROW_H, fill=1, stroke=0)
            c.setFillColor(black)
            c.setFont("Helvetica-Bold", TABLA_HDR_FONT_SIZE)
            x = MARGIN_LEFT
            # ESTACIÓN: alineado a la izquierda; meses y ANUAL: centrados
            c.drawString(x + 2, y - TABLA_ROW_H + 4, "ESTACIÓN")
            x += TABLA_COL_EST
            for hdr, cw in zip(MONTHS_HDR, [TABLA_COL_MES]*12 + [TABLA_COL_ANUAL]):
                c.drawCentredString(x + cw / 2, y - TABLA_ROW_H + 4, hdr)
                x += cw
            return y - TABLA_ROW_H

        # ── Iteración ────────────────────────────────────────────────
        y       = _draw_page_headers()
        row_idx = 0

        def _maybe_new_page():
            nonlocal y, row_idx
            if y - TABLA_ROW_H < table_bottom_y:
                self._draw_footer()
                c.showPage()
                self.current_page += 1
                y = _draw_page_headers()
                row_idx = 0

        def _fmt(val):
            if val is None:
                return ""
            if decimals == 0:
                return str(int(round(val)))
            return f"{val:.{decimals}f}"

        for prov, prov_stations in data.items():
            has_data = any(
                any(v is not None for v in s['values']) or s['annual'] is not None
                for s in prov_stations
            )
            if not prov_stations or not has_data:
                continue

            # Subheader de provincia
            _maybe_new_page()
            c.setFillColor(HexColor("#d9d9d9"))
            c.rect(MARGIN_LEFT, y - TABLA_ROW_H + 3, CONTENT_W, TABLA_ROW_H, fill=1, stroke=0)
            c.setFillColor(black)
            c.setFont("Helvetica-Bold", TABLA_HDR_FONT_SIZE)
            c.drawString(MARGIN_LEFT + 2, y - TABLA_ROW_H + 4, prov)
            y -= TABLA_ROW_H
            row_idx = 0

            for st in prov_stations:
                _maybe_new_page()

                text_y = y - TABLA_ROW_H + 4

                # Zebra
                if row_idx % 2 == 0:
                    c.setFillColor(HexColor("#f2f2f2"))
                    c.rect(MARGIN_LEFT, y - TABLA_ROW_H + 3, CONTENT_W, TABLA_ROW_H,
                           fill=1, stroke=0)

                # Nombre de estación
                c.setFillColor(black)
                c.setFont("Helvetica", TABLA_FONT_SIZE)
                c.drawString(MARGIN_LEFT + 2, text_y, st['name'])

                # Valores mensuales + ANUAL
                x   = MARGIN_LEFT + TABLA_COL_EST
                all_vals = st['values'] + [st['annual']]
                all_cws  = [TABLA_COL_MES] * 12 + [TABLA_COL_ANUAL]
                for val, cw in zip(all_vals, all_cws):
                    txt = _fmt(val)
                    if txt:
                        c.drawCentredString(x + cw / 2, text_y, txt)
                    x += cw

                y -= TABLA_ROW_H
                row_idx += 1

        # Cerrar última página de la sección
        self._draw_footer()
        c.showPage()
        self.current_page += 1

    def _draw_coordenadas_table(self, provincia, estaciones):
        """
        Dibuja una (o más) páginas de tabla de coordenadas para una provincia.
        Incluye cabecera MeteoGalicia, título, tabla y pie de página.
        """
        c = self.c
        col_widths = COORD_COL_WIDTHS
        headers = ["ESTACIÓN", "CONCELLO", "DATA DE ALTA", "UTMX_29T", "UTMY_29T", "ALTITUDE"]
        # Alineación por columna: L=izquierda, C=centro, R=derecha
        col_align = ["L", "L", "C", "C", "C", "R"]
        row_h = COORD_TABLE_ROW_H

        # Zona útil para la tabla (entre cabecera y footer)
        table_top_y = MAIN_HEADER_Y - LOGO_H - 55   # Debajo del título
        table_bottom_y = 75                           # Encima del footer

        def start_new_page(first_page_of_prov=False):
            """Dibuja cabecera, título y cabecera de tabla; devuelve Y de primera fila."""
            self._draw_main_header()

            # Título centrado
            c.setFont("Helvetica-Bold", COORD_TITLE_FONT_SIZE)
            c.setFillColor(black)
            title_y = MAIN_HEADER_Y - LOGO_H - 30
            c.drawCentredString(PAGE_W / 2, title_y, "COORDENADAS DAS ESTACIÓNS")

            # Subheader de provincia (fila gris)
            y = table_top_y
            c.setFillColor(HexColor("#d9d9d9"))
            c.rect(MARGIN_LEFT, y - row_h + 3, CONTENT_W, row_h, fill=1, stroke=0)
            c.setFillColor(black)
            c.setFont("Helvetica-Bold", COORD_HEADER_FONT_SIZE)
            c.drawString(MARGIN_LEFT + 4, y - row_h + 6, provincia)
            y -= row_h

            # Cabecera de columnas
            c.setFillColor(HexColor("#bfbfbf"))
            c.rect(MARGIN_LEFT, y - row_h + 3, CONTENT_W, row_h, fill=1, stroke=0)
            c.setFillColor(black)
            c.setFont("Helvetica-Bold", COORD_HEADER_FONT_SIZE)
            x = MARGIN_LEFT
            for i, hdr in enumerate(headers):
                align = col_align[i]
                text_y = y - row_h + 6
                if align == "C":
                    c.drawCentredString(x + col_widths[i] / 2, text_y, hdr)
                elif align == "R":
                    c.drawRightString(x + col_widths[i] - 4, text_y, hdr)
                else:
                    c.drawString(x + 3, text_y, hdr)
                x += col_widths[i]
            y -= row_h

            return y

        # --- Iterar sobre estaciones ---
        y = start_new_page(first_page_of_prov=True)
        row_idx = 0

        for est in estaciones:
            # ¿Necesitamos nueva página?
            if y - row_h < table_bottom_y:
                self._draw_footer()
                c.showPage()
                self.current_page += 1
                y = start_new_page(first_page_of_prov=False)
                row_idx = 0

            # Fondo zebra
            if row_idx % 2 == 0:
                c.setFillColor(HexColor("#f2f2f2"))
                c.rect(MARGIN_LEFT, y - row_h + 3, CONTENT_W, row_h, fill=1, stroke=0)

            # Datos
            c.setFillColor(black)
            c.setFont("Helvetica", COORD_FONT_SIZE)
            x = MARGIN_LEFT
            vals = [
                str(est["estacion"]),
                str(est["concello"]),
                str(est["fecha_alta"]),
                str(est["utmx"]),
                str(est["utmy"]),
                str(est["altitude"]),
            ]
            for i, val in enumerate(vals):
                align = col_align[i]
                text_y = y - row_h + 6
                if align == "C":
                    c.drawCentredString(x + col_widths[i] / 2, text_y, val)
                elif align == "R":
                    c.drawRightString(x + col_widths[i] - 4, text_y, val)
                else:
                    c.drawString(x + 3, text_y, val)
                x += col_widths[i]

            y -= row_h
            row_idx += 1

        # Footer y cierre de la última página de esta provincia
        self._draw_footer()
        c.showPage()
        self.current_page += 1

    def save(self):
        """Guarda el archivo PDF."""
        self.c.save()

    # ─── Dibujo de componentes ────────────────────────────────────────

    def _draw_main_header(self):
        """Dibuja el logo de MeteoGalicia y el texto de la Consellería en el tope."""
        c = self.c
        import os
        from config import BASE_DIR
        
        # Logo MeteoGalicia
        logo_path = os.path.join(BASE_DIR, "logos", "METEOGALICIA_logo.jpg")
        if os.path.exists(logo_path):
            img = ImageReader(logo_path)
            # Dibujamos el logo desplazado a la izquierda.
            c.drawImage(img, LOGO_X, MAIN_HEADER_Y - LOGO_H, LOGO_W, LOGO_H, 
                        mask='auto', preserveAspectRatio=True)
        
        # Texto de la Consellería justo debajo del logo
        c.setFillColor(black)
        c.setFont("Helvetica", TEXT_XUNTA_FONT_SIZE)
        text_y = MAIN_HEADER_Y - LOGO_H - 10
        text_xunta = "Consellería de Medio Ambiente, Territorio e Infraestruturas - Xunta de Galicia"
        c.drawString(MARGIN_LEFT, text_y, text_xunta)
        
        # Línea decorativa opcional o separación
        # c.setStrokeColor(HexColor("#005a9c"))
        # c.line(MARGIN_LEFT, text_y - 4, PAGE_W - MARGIN_RIGHT, text_y - 4)

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
            # Alineamos al top (anchor='n') usando ROW1_TOP_Y
            c.drawImage(img, PHOTO_X, ROW1_TOP_Y - PHOTO_H, PHOTO_W, PHOTO_H,
                        preserveAspectRatio=True, anchor='n')
        else:
            # Placeholder
            c.setStrokeColor(Color(0.7, 0.7, 0.7))
            c.setFillColor(Color(0.95, 0.95, 0.95))
            c.rect(PHOTO_X, ROW1_TOP_Y - PHOTO_H, PHOTO_W, PHOTO_H, fill=1, stroke=1)
            c.setFont("Helvetica-Bold", 8)
            c.drawCentredString(PHOTO_X + PHOTO_W/2, ROW1_TOP_Y - 40,
                                "Fotografía da estación")

    def _draw_map(self, province_images):
        """Mapa de ubicación de la estación."""
        c = self.c
        ubi = province_images.get("ubicacion")
        if ubi:
            img = ImageReader(io.BytesIO(ubi))
            # Alineamos al top (anchor='n') usando ROW1_TOP_Y
            c.drawImage(img, MAP_X, ROW1_TOP_Y - MAP_H, MAP_W, MAP_H,
                        preserveAspectRatio=True, anchor='n')
        
        prov = province_images.get("provincia")
        if prov:
            img = ImageReader(io.BytesIO(prov))
            # El escudo de provincia también alineado al techo
            c.drawImage(img, PROV_X, ROW1_TOP_Y - PROV_H, PROV_W, PROV_H,
                        preserveAspectRatio=True, anchor='n')

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
        
        # Número de página
        c.setFillColor(white)
        c.setFont("Helvetica-Bold", 16)
        c.drawString(MARGIN_LEFT + 15, 47, str(self.current_page))

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

    def _draw_wind_tables(self, ws):
        """Dibuja tablas de velocidades y direcciones a la derecha de la rosa."""
        c = self.c
        if not ws: return
        
        from config import WIND_SECTORS
        
        y_top = WT_Y + ROW4_H - 10
        row_h = 13
        
        # 1. Tabla de Velocidades Promedio (VXX)
        curr_y = y_top
        c.setFont("Helvetica-Bold", 8.5)
        c.setFillColor(black)
        c.drawString(WT_X, curr_y, "VELOCIDADES MEDIAS")
        c.drawString(WT_X, curr_y - 11, "POR SECTOR (km/h)")
        curr_y -= 28
        
        c.setFont("Helvetica", 8)
        speeds = ws.get("velocidades", {})
        for sec in WIND_SECTORS:
            val = speeds.get(sec, 0)
            c.drawString(WT_X + 5, curr_y, f"{sec}:")
            c.drawRightString(WT_X + 75, curr_y, f"{val:.1f}")
            curr_y -= row_h
            
        # 2. Tabla de Direcciones Promedio (DXX)
        curr_y = y_top
        tab2_x = WT_X + 130 # Ajustamos un poco para centrar bajo los dos bloques
        c.setFont("Helvetica-Bold", 8.5)
        c.drawString(tab2_x, curr_y, "DIRECCIÓN MEDIA")
        c.drawString(tab2_x, curr_y - 11, "POR SECTOR (º)")
        curr_y -= 28
        
        c.setFont("Helvetica", 8)
        dirs = ws.get("direcciones", {})
        for sec in WIND_SECTORS:
            val = dirs.get(sec, 0)
            c.drawString(tab2_x + 5, curr_y, f"{sec}:")
            c.drawRightString(tab2_x + 65, curr_y, f"{val:.1f}")
            curr_y -= row_h
