# -*- coding: utf-8 -*-
"""
Generación de las 5 gráficas de la ficha de estación con Matplotlib.
Cada función devuelve un BytesIO con la imagen PNG lista para incrustar en el PDF.
"""

import io
import math
import numpy as np
import matplotlib
matplotlib.use('Agg')  # Backend sin GUI
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch
import matplotlib.ticker as ticker

from config import (
    MESES_GL, WIND_SECTORS,
    COLOR_LINE_TMAX, COLOR_LINE_TMIN, COLOR_LINE_TMAXMED, COLOR_LINE_TMINMED,
    COLOR_BAR_HELADA, COLOR_BAR_PP, COLOR_BAR_BH, COLOR_LINE_TMEDIA,
    COLOR_BAR_INS, COLOR_LINE_HRMED, COLOR_LINE_HRMAX, COLOR_LINE_HRMIN,
    COLOR_ROSA_VIENTO, COLOR_ROSA_VELOCIDAD,
)

# Estilo general
plt.rcParams.update({
    'font.family': 'sans-serif',
    'font.size': 8,
    'axes.titlesize': 9,
    'axes.labelsize': 8,
    'xtick.labelsize': 7,
    'ytick.labelsize': 7,
    'legend.fontsize': 6.5,
    'figure.dpi': 150,
})


def _to_bytesio(fig):
    """Convierte figura matplotlib a BytesIO PNG."""
    buf = io.BytesIO()
    fig.savefig(buf, format='png', bbox_inches='tight', pad_inches=0.05)
    plt.close(fig)
    buf.seek(0)
    return buf


def _safe(vals):
    """Reemplaza None por np.nan para matplotlib."""
    return [v if v is not None else np.nan for v in vals]


# ═══════════════════════════════════════════════════════════════════════
# GRÁFICA 1: Temperaturas mensuales + días de helada
# ═══════════════════════════════════════════════════════════════════════
def chart_temperaturas(monthly):
    """
    Líneas: TMax abs, TMin abs, TMaxMed, TMinMed
    Barras (eje derecho): días de helada
    """
    fig, ax1 = plt.subplots(figsize=(4.8, 2.8))
    x = np.arange(12)

    # Líneas de temperatura
    ax1.plot(x, _safe(monthly["tmax_abs"]), 'o-', color=COLOR_LINE_TMAX,
             markersize=4, linewidth=1.2, label='MAX')
    ax1.plot(x, _safe(monthly["tmin_abs"]), 'o-', color=COLOR_LINE_TMIN,
             markersize=4, linewidth=1.2, label='MIN')
    ax1.plot(x, _safe(monthly["tmax_med"]), 'o-', color=COLOR_LINE_TMAXMED,
             markersize=3, linewidth=1.0, label='MAXMED')
    ax1.plot(x, _safe(monthly["tmin_med"]), 'o-', color=COLOR_LINE_TMINMED,
             markersize=3, linewidth=1.0, label='MINMED')

    ax1.set_ylabel('TEMPERATURA (°C)')
    ax1.set_xticks(x)
    ax1.set_xticklabels(MESES_GL)
    ax1.grid(axis='y', alpha=0.3)

    # Barras de helada en eje derecho
    ax2 = ax1.twinx()
    helada = _safe(monthly.get("helada", [0]*12))
    ax2.bar(x, helada, alpha=0.4, color=COLOR_BAR_HELADA, width=0.5, label='XEADA')
    ax2.set_ylabel('DÍAS DE XEADA')
    max_helada = max([h for h in helada if not np.isnan(h)] or [5])
    ax2.set_ylim(0, max(max_helada * 2, 5))

    # Leyenda combinada
    lines1, labels1 = ax1.get_legend_handles_labels()
    lines2, labels2 = ax2.get_legend_handles_labels()
    ax1.legend(lines1 + lines2, labels1 + labels2,
               loc='lower center', ncol=5, bbox_to_anchor=(0.5, -0.28),
               frameon=True, fancybox=True)

    fig.tight_layout(rect=[0, 0, 1, 0.98])
    return _to_bytesio(fig)


# ═══════════════════════════════════════════════════════════════════════
# GRÁFICA 2: Precipitación + Balance hídrico + Tª media
# ═══════════════════════════════════════════════════════════════════════
def chart_precipitacion(monthly):
    """
    Barras lado a lado: PP mensual (azul oscuro) + balance hídrico (azul claro)
    Meses BHC sin dato (-9999 → None) se marcan con barra gris rayada.
    Línea (eje derecho): Tª media mensual.
    """
    fig, ax1 = plt.subplots(figsize=(4.8, 2.8))
    x = np.arange(12)
    width = 0.35

    pp_raw  = monthly.get("pp",  [None]*12)
    bhc_raw = monthly.get("bhc", [None]*12)

    pp  = _safe(pp_raw)
    bhc = _safe(bhc_raw)

    # Barras de Precipitación (siempre azul oscuro)
    ax1.bar(x - width/2, pp, width, color=(0.2, 0.2, 0.55), label='PRECIPITACIÓN TOTAL')

    # Barras de BHC: dato válido → azul claro; sin dato → gris rayado
    bhc_val   = [v if bhc_raw[i] is not None else np.nan for i, v in enumerate(bhc)]
    bhc_nodat = [0 if bhc_raw[i] is None else np.nan for i in range(12)]

    ax1.bar(x + width/2, bhc_val,   width, color=(0.45, 0.7, 0.9), label='BALANCE HÍDRICO')
    ax1.bar(x + width/2, bhc_nodat, width, color='lightgrey', hatch='//', edgecolor='grey',
            linewidth=0.5, label='SIN DATO (BH)')

    ax1.set_ylabel('(mm)')
    ax1.set_xticks(x)
    ax1.set_xticklabels(MESES_GL)
    ax1.grid(axis='y', alpha=0.3)
    ax1.axhline(y=0, color='gray', linewidth=0.5)
    # Ticks mayores cada 100 mm, menores cada 50 mm
    ax1.yaxis.set_major_locator(ticker.MultipleLocator(100))
    ax1.yaxis.set_minor_locator(ticker.MultipleLocator(50))
    ax1.tick_params(axis='y', which='minor', length=3, color='grey')

    # Limitar eje Y para que no colapsen con posibles valores extremos
    pp_valid  = [v for v in pp  if not np.isnan(v)]
    bhc_valid = [v for v in bhc if not np.isnan(v)]
    all_vals  = pp_valid + bhc_valid
    if all_vals:
        y_min = max(min(all_vals), -500)
        y_max = max(max(all_vals) * 1.1, 50)
        ax1.set_ylim(y_min, y_max)

    # Tª media en eje derecho (rojo con círculos)
    ax2 = ax1.twinx()
    ta = _safe(monthly["ta_med"])
    ax2.plot(x, ta, 'o-', color=COLOR_LINE_TMEDIA, markersize=4, linewidth=1.2, label='TªMEDIA')
    ax2.set_ylabel('TEMPERATURA (°C)')
    ta_valid = [v for v in ta if not np.isnan(v)]
    if ta_valid:
        ax2.set_ylim(min(ta_valid) - 3, max(ta_valid) + 5)

    # Leyenda combinada en la parte inferior
    lines1, labels1 = ax1.get_legend_handles_labels()
    lines2, labels2 = ax2.get_legend_handles_labels()
    ax1.legend(lines1 + lines2, labels1 + labels2,
               loc='lower center', ncol=4, bbox_to_anchor=(0.5, -0.32),
               frameon=True, fancybox=True, fontsize=6)

    fig.tight_layout(rect=[0, 0, 1, 0.98])
    return _to_bytesio(fig)



# ═══════════════════════════════════════════════════════════════════════
# GRÁFICA 3: Humedad relativa + Insolación
# ═══════════════════════════════════════════════════════════════════════
def chart_humedad_insolacion(monthly):
    """
    Barras: insolación (%)
    Líneas: humedad relativa media, max abs mensual, min abs mensual
    """
    fig, ax1 = plt.subplots(figsize=(4.8, 2.8))
    x = np.arange(12)

    # Barras de insolación
    ins = _safe(monthly.get("ins", [0]*12))
    ax1.bar(x, ins, color=COLOR_BAR_INS, alpha=0.7, width=0.6, label='INSOLACIÓN')
    ax1.set_ylabel('(%)')
    ax1.set_ylim(0, 100)
    ax1.set_xticks(x)
    ax1.set_xticklabels(MESES_GL)
    ax1.grid(axis='y', alpha=0.3)

    # Humedad relativa en mismo eje (también %)
    ax1.plot(x, _safe(monthly["hr_med"]), 'o-', color=COLOR_LINE_HRMED,
             markersize=3, linewidth=1.2, label='HUM RELATIVA')
    ax1.plot(x, _safe(monthly["hr_max"]), 's-', color=COLOR_LINE_HRMAX,
             markersize=3, linewidth=0.8, label='MAX MED')
    ax1.plot(x, _safe(monthly["hr_min"]), 'd-', color=COLOR_LINE_HRMIN,
             markersize=3, linewidth=0.8, label='MIN MED')

    ax1.legend(loc='lower center', ncol=4, bbox_to_anchor=(0.5, -0.28),
               frameon=True, fancybox=True)

    fig.tight_layout(rect=[0, 0, 1, 0.98])
    return _to_bytesio(fig)


# ═══════════════════════════════════════════════════════════════════════
# GRÁFICA 4: Rosa de vientos (Frecuencia por fuerza en cada dirección)
# ═══════════════════════════════════════════════════════════════════════
def chart_rosa_vientos(monthly):
    """
    Diagrama polar de barras apiladas: % de registros por cada dirección y
    clase de intensidad, calculados desde datos 10-minutales.
    """
    # Aumentamos un poco el tamaño para acomodar la leyenda a la izquierda
    fig = plt.figure(figsize=(4.5, 4.4))
    ax = fig.add_subplot(111, projection='polar')

    wind_rose = monthly.get("wind_rose", {})
    matrix = wind_rose.get("matrix", {})
    calmas = wind_rose.get("calmas_pct", 0)

    force_keys   = ["frouxos", "moderados", "fortes", "moi_fortes"]
    force_labels = ["Frouxo", "Moderado", "Forte", "Moi forte"]
    force_colors = ["#fcf45d", "#76d73f", "#7289da", "#e25c34"]

    n_sectors  = len(WIND_SECTORS)
    angles_deg = [90, 45, 0, 315, 270, 225, 180, 135]
    angles_rad = [math.radians(a) for a in angles_deg]
    width      = 2 * math.pi / n_sectors * 0.7

    bottom = np.zeros(n_sectors)

    for i, force in enumerate(force_keys):
        vals = []
        for sec in WIND_SECTORS:
            vals.append(matrix.get(sec, {}).get(force, 0))

        total_pct = sum(vals)
        lbl = f"{force_labels[i]}: {total_pct:.1f}%"

        ax.bar(angles_rad, vals, width=width, bottom=bottom,
               color=force_colors[i], edgecolor='black', linewidth=0.4,
               label=lbl)

        bottom += np.array(vals)

    ax.set_thetagrids(angles_deg, WIND_SECTORS)
    ax.set_theta_zero_location('E')

    # 1. Escala radial dinámica (próximo múltiplo de 10)
    max_val = max(bottom) if len(bottom) > 0 else 5
    limit = math.ceil(max_val / 10) * 10
    if limit < 10: limit = 10

    ax.set_ylim(0, limit)
    
    # 2. Rejilla: Sólida en decenas, punteada en unidades de 5
    ticks_10 = np.arange(10, limit + 1, 10)
    ticks_5  = np.arange(5, limit + 1, 10)
    
    ax.set_rticks(ticks_10)
    ax.set_yticklabels([f'{t:.0f}%' for t in ticks_10], fontsize=7)
    
    # Dibujar manualmente las líneas de 5, 15... (rejilla dashed)
    ax.grid(True, which='major', axis='y', linestyle='-', color='#dddddd', alpha=0.8)
    for t5 in ticks_5:
        ax.plot(np.linspace(0, 2*np.pi, 100), [t5]*100, color='#eeeeee', 
                linestyle='--', linewidth=0.5, zorder=0)

    # 3. Leyenda a la izquierda (todavía más desplazada)
    ax.legend(loc='upper left', bbox_to_anchor=(-0.55, 1.1),
              fontsize=8, frameon=False)

    # 4. Calmas (Centradas, más grandes, peso normal)
    # Ajustamos la posición horizontal para asegurar centrado visual respecto al círculo
    fig.text(0.48, 0.05, f"Calmas: {calmas:.0f}%",
             ha='center', va='bottom', fontsize=10, fontweight='normal')

    fig.tight_layout(rect=[0, 0.08, 1, 1])
    return _to_bytesio(fig)



# ─── Utilidades ───────────────────────────────────────────────────────

def _nice_step(max_val):
    """Calcula un paso 'bonito' para la escala radial."""
    if max_val <= 0:
        return 1
    raw = max_val / 4
    magnitude = 10 ** math.floor(math.log10(raw))
    residual = raw / magnitude
    if residual <= 1.5:
        return magnitude
    elif residual <= 3:
        return 2 * magnitude
    elif residual <= 7:
        return 5 * magnitude
    else:
        return 10 * magnitude
