# -*- coding: utf-8 -*-
"""
Consultas para las tablas de datos anuales de estaciones (16 secciones).
Todas las métricas se obtienen de DatosMensuales (idTipoIntervalo=5).
"""

from collections import OrderedDict
from config import COORD_PROVINCIAS

# ─── Definición de secciones ─────────────────────────────────────────────────
# id_altura: int|None para altura fija, list para viento (7=2m preferente, 9=10m)
# annual: método para calcular ANUAL desde los 12 valores mensuales
TABLAS_SECTIONS = [
    {
        'key': 'vv_avg',
        'title': 'VELOCIDADE DO VENTO (km/h)',
        'note': '(* Vento medido a 2m)',
        'id_parametro': 81, 'id_funcion': 1, 'id_altura': [7, 9],
        'decimals': 2, 'annual': 'AVG', 'is_viento': True, 'scale': 3.6,
    },
    {
        'key': 'vv_max',
        'title': 'REFACHO MÁXIMO (km/h)',
        'note': '(* Refacho medido a 2m)',
        'id_parametro': 81, 'id_funcion': 2, 'id_altura': [7, 9],
        'decimals': 2, 'annual': 'MAX', 'is_viento': True, 'scale': 3.6,
    },
    {
        'key': 'ta_avg',
        'title': 'TEMPERATURA MEDIA DO AIRE (°C)',
        'note': None,
        'id_parametro': 83, 'id_funcion': 1, 'id_altura': 6,
        'decimals': 1, 'annual': 'AVG',
    },
    {
        'key': 'ta_max',
        'title': 'TEMPERATURA MÁXIMA DO AIRE (°C)',
        'note': None,
        'id_parametro': 83, 'id_funcion': 2, 'id_altura': 6,
        'decimals': 1, 'annual': 'MAX',
    },
    {
        'key': 'ta_min',
        'title': 'TEMPERATURA MÍNIMA DO AIRE (°C)',
        'note': None,
        'id_parametro': 83, 'id_funcion': 3, 'id_altura': 6,
        'decimals': 1, 'annual': 'MIN',
    },
    {
        'key': 'ta_avgmax',
        'title': 'MEDIA DAS TEMPERATURAS MÁXIMAS (°C)',
        'note': None,
        'id_parametro': 83, 'id_funcion': 12, 'id_altura': 6,
        'decimals': 1, 'annual': 'AVG',
    },
    {
        'key': 'ta_avgmin',
        'title': 'MEDIA DAS TEMPERATURAS MÍNIMAS (°C)',
        'note': None,
        'id_parametro': 83, 'id_funcion': 13, 'id_altura': 6,
        'decimals': 1, 'annual': 'AVG',
    },
    {
        'key': 'hfrio',
        'title': 'HORAS DE FRÍO (h)',
        'note': None,
        'id_parametro': 10063, 'id_funcion': 4, 'id_altura': 6,
        'decimals': 1, 'annual': 'SUM', 'is_acumulado': True,
    },
    {
        'key': 'ndx',
        'title': 'DÍAS DE XEADA',
        'note': None,
        'id_parametro': 10119, 'id_funcion': 9, 'id_altura': 6,
        'decimals': 0, 'annual': 'SUM', 'is_acumulado': True,
    },
    {
        'key': 'hr_avg',
        'title': 'HUMIDADE RELATIVA MEDIA (%)',
        'note': None,
        'id_parametro': 86, 'id_funcion': 1, 'id_altura': 6,
        'decimals': 1, 'annual': 'AVG',
    },
    {
        'key': 'hf',
        'title': 'HORAS DE HUMIDADE FOLIAR (h)',
        'note': None,
        'id_parametro': 9991, 'id_funcion': 4, 'id_altura': 7,
        'decimals': 1, 'annual': 'SUM', 'is_acumulado': True,
    },
    {
        'key': 'pp_sum',
        'title': 'PRECIPITACIÓN (mm)',
        'note': None,
        'id_parametro': 10001, 'id_funcion': 4, 'id_altura': 6,
        'decimals': 1, 'annual': 'SUM', 'is_acumulado': True,
    },
    {
        'key': 'ndpp',
        'title': 'DÍAS DE PRECIPITACIÓN',
        'note': None,
        'id_parametro': 10120, 'id_funcion': 9, 'id_altura': 6,
        'decimals': 0, 'annual': 'SUM', 'is_acumulado': True,
    },
    {
        'key': 'pp_max',
        'title': 'PRECIPITACIÓN MÁXIMA DIARIA (mm)',
        'note': None,
        'id_parametro': 10001, 'id_funcion': 2, 'id_altura': 6,
        'decimals': 1, 'annual': 'MAX',
    },
    {
        'key': 'hsol',
        'title': 'HORAS DE SOL (h)',
        'note': None,
        'id_parametro': 10006, 'id_funcion': 4, 'id_altura': 6,
        'decimals': 1, 'annual': 'SUM', 'is_acumulado': True,
    },
    {
        'key': 'ins',
        'title': 'INSOLACIÓN (%)',
        'note': None,
        'id_parametro': 10106, 'id_funcion': 1, 'id_altura': 6,
        'decimals': 1, 'annual': 'AVG',
    },
    {
        'key': 'ird',
        'title': 'IRRADIACIÓN GLOBAL DIARIA (MJ/m²)',
        'note': None,
        'id_parametro': 10013, 'id_funcion': 1, 'id_altura': 6,
        'decimals': 1, 'annual': 'AVG',
    },
    {
        'key': 'bh',
        'title': 'BALANCE HÍDRICO (mm)',
        'note': None,
        'id_parametro': 10117, 'id_funcion': 4, 'id_altura': None,
        'decimals': 1, 'annual': 'SUM', 'is_acumulado': True,
    },
]


# ─── Consulta de estaciones activas durante el año ────────────────────────────

def get_tablas_stations(conn, year):
    """
    Devuelve (stations_by_prov, ids_2m):
      - stations_by_prov: OrderedDict {prov: [{'id': int, 'name': str}]}
        Subredes 102+202, alta antes del fin del año, no dadas de baja antes
        del inicio del año.
      - ids_2m: set de idEstacion con anemómetro a 2m (idAltura=7).
    """
    cutoff_end   = f"{year + 1}-01-01"
    cutoff_start = f"{year}-01-01"

    sql_stations = """
    SELECT DISTINCT u.Provincia, u.idEstacion, u.estacion
    FROM   Vista_CruceEstacionesAuxConcellosCoordenadas_UTM_ETRS89 u
    INNER JOIN AuxEstacionesIncidencias i ON i.lnEstacion = u.idEstacion
    WHERE  i.lnTipoIncidencia = 7
      AND  (u.lnSubred = 102 OR u.lnSubred = 202)
      AND  i.FechaInicio < ?
      AND  (i.FechaFin IS NULL OR i.FechaFin >= ?)
    ORDER BY u.Provincia, u.estacion
    """
    rows = conn.execute(sql_stations, cutoff_end, cutoff_start).fetchall()

    data = OrderedDict()
    for prov in COORD_PROVINCIAS:
        data[prov] = []

    for r in rows:
        prov = r.Provincia.strip() if r.Provincia else ""
        entry = {
            'id':   r.idEstacion,
            'name': r.estacion.strip() if r.estacion else "",
        }
        if prov not in data:
            data[prov] = []
        # Avoid duplicates (DISTINCT in SQL, but safety net)
        if not any(s['id'] == entry['id'] for s in data[prov]):
            data[prov].append(entry)

    # Stations with 2m anemometer (idAltura=7, idTipoIntervalo=5)
    sql_2m = """
    SELECT DISTINCT idEstacion
    FROM   dbo.VIDX_AyudaMedidas_NOEXPAND
    WHERE  idParametro = 81
      AND  idAltura = 7
      AND  idTipoIntervalo = 5
    """
    rows_2m = conn.execute(sql_2m).fetchall()
    ids_2m = {r.idEstacion for r in rows_2m}

    return data, ids_2m


# ─── Consulta mensual masiva (todos los parámetros) ───────────────────────────

def _query_monthly(conn, year, id_parametro, id_funcion, id_altura, ids_list):
    """
    Devuelve {id_estacion: {mes(1-12): valor}} para todos los ids_list.
    id_altura puede ser int, None (sin filtro) o list (múltiples alturas).
    """
    if not ids_list:
        return {}

    ids_str = ",".join(str(i) for i in ids_list)

    if isinstance(id_altura, list):
        altura_clause = f"AND LMT.lnAltura IN ({','.join(str(a) for a in id_altura)})"
        extra_select  = ", LMT.lnAltura"
        extra_group   = ", LMT.lnAltura"
    elif id_altura is None:
        altura_clause = ""
        extra_select  = ""
        extra_group   = ""
    else:
        altura_clause = f"AND LMT.lnAltura = {int(id_altura)}"
        extra_select  = ""
        extra_group   = ""

    sql = f"""
    SELECT
        S.lnEstacion{extra_select},
        MONTH(D.FechaHora) AS Mes,
        AVG(D.Valor) AS Val
    FROM  dbo.DatosMensuales D
    INNER JOIN dbo.SysMedidas     M   ON M.idMedida  = D.lnMedida
    INNER JOIN dbo.SysSensores    S   ON S.idSensor  = M.lnSensor
    INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
    WHERE YEAR(D.FechaHora) = ?
      AND LMT.lnParametro = ?
      AND LMT.lnFuncion   = ?
      {altura_clause}
      AND M.lnUso = 1
      AND D.Valor <> -9999
      AND D.lnCodigoValidacion IN (1, 5)
      AND S.lnEstacion IN ({ids_str})
    GROUP BY S.lnEstacion{extra_select}, MONTH(D.FechaHora)
    ORDER BY S.lnEstacion{extra_group}, MONTH(D.FechaHora)
    """
    rows = conn.execute(sql, year, id_parametro, id_funcion).fetchall()

    if not isinstance(id_altura, list):
        result = {}
        for r in rows:
            eid = r.lnEstacion
            if eid not in result:
                result[eid] = {}
            if r.Val is not None:
                result[eid][r.Mes] = float(r.Val)
        return result

    # Multi-altura: prefer lower idAltura value (7 before 9)
    priority = sorted(id_altura)       # [7, 9]
    raw = {}                           # {eid: {altura: {mes: val}}}
    for r in rows:
        eid  = r.lnEstacion
        alt  = r.lnAltura
        mes  = r.Mes
        val  = float(r.Val) if r.Val is not None else None
        raw.setdefault(eid, {}).setdefault(alt, {})[mes] = val

    result = {}
    for eid, alt_data in raw.items():
        chosen = None
        for pref in priority:
            if pref in alt_data:
                chosen = alt_data[pref]
                break
        if chosen is None:
            chosen = next(iter(alt_data.values()))
        result[eid] = chosen
    return result


def _compute_annual(monthly_dict, method, is_acumulado=False):
    """
    Calcula valor anual desde {mes: valor}.

    Reglas de mínimo de meses válidos para la columna Anual:
      - Acumulados (SUM: Precipitación, Horas de sol, Balance hídrico,
        Días de xeada, Días de precipitación): necesitan los 12 meses
        con dato válido; de lo contrario devuelve None (→ "--").
      - Resto de variables (AVG, MAX, MIN): necesitan al menos 10 de
        los 12 meses con dato válido; de lo contrario devuelve None.
    """
    vals = [v for v in monthly_dict.values() if v is not None]
    n_valid = len(vals)
    if n_valid == 0:
        return None
    # Aplicar umbral mínimo de meses
    min_months = 12 if is_acumulado else 10
    if n_valid < min_months:
        return None
    if method == 'SUM':
        return round(sum(vals), 2)
    if method == 'MAX':
        return round(max(vals), 2)
    if method == 'MIN':
        return round(min(vals), 2)
    return round(sum(vals) / n_valid, 2)   # AVG


# ─── Función principal ────────────────────────────────────────────────────────

def get_tablas_data(conn, year):
    """
    Devuelve la estructura completa para el PDF de tablas:
    {
        'sections': [
            {
                'title':    str,
                'note':     str|None,
                'decimals': int,
                'data': OrderedDict {prov: [{'name': str, 'values': [12], 'annual': val}]}
            },
            ...
        ]
    }
    """
    print("  [Tablas] Obteniendo lista de estaciones...", flush=True)
    stations_by_prov, ids_2m = get_tablas_stations(conn, year)

    all_ids = [s['id'] for plist in stations_by_prov.values() for s in plist]
    print(f"  [Tablas] {len(all_ids)} estaciones activas.", flush=True)

    if not all_ids:
        return {'sections': []}

    result_sections = []

    for sec in TABLAS_SECTIONS:
        print(f"    · {sec['key']}: {sec['title'][:50]}...", flush=True, end=" ")

        monthly_data = _query_monthly(
            conn, year,
            sec['id_parametro'],
            sec['id_funcion'],
            sec['id_altura'],
            all_ids,
        )

        # Factor de escala (ej: m/s → km/h para viento)
        scale = sec.get('scale', 1.0)

        is_viento = sec.get('is_viento', False)
        section_prov_data = OrderedDict()

        for prov, prov_stations in stations_by_prov.items():
            rows = []
            for st in prov_stations:
                eid  = st['id']
                name = st['name']

                # Marca * para viento medido a 2m
                if is_viento and eid in ids_2m:
                    name = f"*{name}"

                station_monthly = monthly_data.get(eid, {})
                # Aplicar escala si procede (p.ej. m/s → km/h)
                if scale != 1.0:
                    station_monthly = {
                        m: round(v * scale, 4) if v is not None else None
                        for m, v in station_monthly.items()
                    }
                values  = [station_monthly.get(m) for m in range(1, 13)]
                # Omitir estaciones sin ningún dato para este parámetro
                if all(v is None for v in values):
                    continue
                annual  = _compute_annual(
                    station_monthly, sec['annual'],
                    is_acumulado=sec.get('is_acumulado', False),
                )

                rows.append({'name': name, 'values': values, 'annual': annual})
            section_prov_data[prov] = rows

        print("OK", flush=True)
        result_sections.append({
            'title':    sec['title'],
            'note':     sec.get('note'),
            'decimals': sec['decimals'],
            'data':     section_prov_data,
        })

    return {'sections': result_sections}
