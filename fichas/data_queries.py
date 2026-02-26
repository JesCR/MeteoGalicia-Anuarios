# -*- coding: utf-8 -*-
"""
Consultas SQL contra MeteoDatos para obtener datos de fichas de estación.
"""

import pyodbc
from config import get_connection_string


def get_connection():
    """Abre conexión a la BD."""
    return pyodbc.connect(get_connection_string())


def get_station_info(conn, id_estacion):
    """Información básica de la estación."""
    sql = """
    SELECT
        E.idEstacion, E.Estacion, E.NombreCorto,
        P.NOME as Provincia, C.NOME as Concello,
        V.Lat, V.Lon, V.Alt
    FROM dbo.SysEstaciones E
    LEFT JOIN dbo.AuxConcellos C ON C.idConcello = E.lnConcello
    LEFT JOIN dbo.AuxProvincias P ON P.IdPROV = C.lnPROV
    LEFT JOIN dbo.Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt_WGS84 V ON V.lnEstacion = E.idEstacion
    WHERE E.idEstacion = ?
    """
    row = conn.execute(sql, id_estacion).fetchone()
    if not row:
        return None
    return {
        "idEstacion": row.idEstacion,
        "Estacion": row.Estacion.strip(),
        "NombreCorto": row.NombreCorto.strip() if row.NombreCorto else row.Estacion.strip(),
        "Provincia": row.Provincia.strip() if row.Provincia else "",
        "Concello": row.Concello.strip() if row.Concello else "",
        "Lat": row.Lat,
        "Lon": row.Lon,
        "Alt": row.Alt,
    }


def get_annual_summary(conn, id_estacion, year):
    """
    Resumen anual calculando agregados directamente desde DatosMensuales,
    DatosDiarios y Datos10minutales (Rosa de Vientos / Rachas).
    """
    
    # ─── Alturas estándar ───────────────────────────────────────────────
    # lnAltura=6  → 1.5 m  (TA, HR, PP, HSOL, IRD, INS, PR, etc.)
    # lnAltura=9  → 10 m   (VV, DV)
    H_STD  = 6   # altura estándar
    H_VIENTO = 9  # altura viento

    # 1. get_metric: agrega una métrica anual desde una tabla
    def get_metric(parametro, funcion, tabla="DatosMensuales", aggr="AVG",
                   extra_where="", altura=H_STD):
        date_col = "InstanteLectura" if tabla == "Datos10minutales" else "FechaHora"
        sql = f"""
        SELECT {aggr}(D.Valor) as Val
        FROM dbo.{tabla} D
        INNER JOIN dbo.SysMedidas M  ON M.idMedida  = D.lnMedida
        INNER JOIN dbo.SysSensores S ON S.idSensor  = M.lnSensor
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P   ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE S.lnEstacion = ?
          AND YEAR(D.{date_col}) = ?
          AND P.Parametro = ?
          AND F.Funcion   = ?
          AND LMT.lnAltura = ?
          AND M.lnUso = 1
          AND D.Valor <> -9999
          {extra_where}
        """
        row = conn.execute(sql, id_estacion, year, parametro, funcion, altura).fetchone()
        return row.Val if row and row.Val is not None else None

    # 2. get_extreme_with_date: top-1 extremo + fecha
    def get_extreme_with_date(parametro, funcion, tabla="DatosDiarios",
                              order="DESC", altura=H_STD):
        date_col = "InstanteLectura" if tabla == "Datos10minutales" else "FechaHora"
        sql = f"""
        SELECT TOP 1 D.Valor, D.{date_col} as FechaHora
        FROM dbo.{tabla} D
        INNER JOIN dbo.SysMedidas M  ON M.idMedida  = D.lnMedida
        INNER JOIN dbo.SysSensores S ON S.idSensor  = M.lnSensor
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P   ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE S.lnEstacion = ?
          AND YEAR(D.{date_col}) = ?
          AND P.Parametro = ?
          AND F.Funcion   = ?
          AND LMT.lnAltura = ?
          AND M.lnUso = 1
          AND D.Valor <> -9999
        ORDER BY D.Valor {order}
        """
        row = conn.execute(sql, id_estacion, year, parametro, funcion, altura).fetchone()
        if row and row.Valor is not None:
            return round(row.Valor, 1), row.FechaHora.strftime('%d/%m/%Y')
        return None, None

    # 3. count_days: cuenta días que cumplen una condición
    def count_days(parametro, funcion, operator, threshold, altura=H_STD):
        sql = f"""
        SELECT COUNT(*) as Dias
        FROM dbo.DatosDiarios D
        INNER JOIN dbo.SysMedidas M  ON M.idMedida  = D.lnMedida
        INNER JOIN dbo.SysSensores S ON S.idSensor  = M.lnSensor
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P   ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE S.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.Parametro = ?
          AND F.Funcion   = ?
          AND LMT.lnAltura = ?
          AND M.lnUso = 1
          AND D.Valor <> -9999
          AND D.Valor {operator} {threshold}
        """
        row = conn.execute(sql, id_estacion, year, parametro, funcion, altura).fetchone()
        return row.Dias if row else 0

    # Ejecutar métricas — usando Parametro (texto) + Funcion (texto) + Altura
    # Alturas: H_STD=6 (1.5m) para TA, HR, PP, HSOL, IRD, INS; H_VIENTO=9 (10m) para VV

    # Temperaturas (altura=6, 1.5m)
    ta     = get_metric('TA', 'AVG',    aggr="AVG",   altura=H_STD)
    tmaxmed = get_metric('TA', 'AVGMAX', aggr="AVG",  altura=H_STD)
    tminmed = get_metric('TA', 'AVGMIN', aggr="AVG",  altura=H_STD)
    tmax, ftmax = get_extreme_with_date('TA', 'MAX', order="DESC",  altura=H_STD)
    tmin, ftmin = get_extreme_with_date('TA', 'MIN', order="ASC",   altura=H_STD)

    # Humedad (altura=6)
    hrmed   = get_metric('HR', 'AVG',   aggr="AVG",  altura=H_STD)

    # Precipitación (altura=6, PP acumulada mensual)
    pp      = get_metric('PP', 'SUM', tabla="DatosMensuales", aggr="SUM", altura=H_STD)
    ppmax, fppmax = get_extreme_with_date('PP', 'SUM', tabla="DatosDiarios", order="DESC", altura=H_STD)

    # Días de Lluvia (PP >= 0.1 mm) y Helada (TA_MIN < 0)
    ndpp = count_days('PP', 'SUM',  '>=', 0.1, altura=H_STD)
    ndx  = count_days('TA', 'MIN',  '<',  0,   altura=H_STD)

    # Radiación / Sol (altura=6)
    hsol = get_metric('HSOL', 'SUM', tabla="DatosMensuales", aggr="SUM", altura=H_STD)
    ird  = get_metric('IRD',  'AVG', aggr="AVG",              altura=H_STD)

    # Viento (altura=9, 10m) → convertir m/s a km/h (* 3.6)
    vv_ms           = get_metric('VV', 'AVG',   tabla="DatosMensuales", aggr="AVG", altura=H_VIENTO)
    gtmax_ms, fgtmax = get_extreme_with_date('VV', 'RACHA', tabla="Datos10minutales",
                                             order="DESC", altura=H_VIENTO)
    vv    = round(vv_ms    * 3.6, 1) if vv_ms    is not None else None
    gtmax = round(gtmax_ms * 3.6, 1) if gtmax_ms is not None else None

    def rnd(val, decimals=1):
        if val is None: return None
        return round(float(val), decimals)

    return {
        "year": year,
        "TA": rnd(ta),
        "TMAXMED": rnd(tmaxmed),
        "TMINMED": rnd(tminmed),
        "TMAX": rnd(tmax),
        "FTMAX": ftmax,
        "TMIN": rnd(tmin),
        "FTMIN": ftmin,
        "HRMED": rnd(hrmed, 0),
        "PP": rnd(pp, 0),
        "PPMAX": rnd(ppmax, 0),
        "FPPMAX": fppmax,
        "NDPP": ndpp,
        "NDX": ndx,
        "HSOL": rnd(hsol, 0),
        "IRD": rnd(ird, 1),
        "INS": None, # Faltaría mapear INS
        "VV": rnd(vv, 1),
        "GT": rnd(gtmax, 1),
        "FGTMAX": fgtmax,
        "BHC": None, # Pendiente Balance Hídrico
        "PR": None,
    }


def _compute_bhc(pp_list, etp_list):
    """
    Calcula el Balance Hídrico Climático mensual = PP - ETP.
    Si ETP no está disponible (todos None), devuelve array de None.
    """
    if all(v is None for v in etp_list):
        return [None] * 12
    result = []
    for pp, etp in zip(pp_list, etp_list):
        if pp is None or etp is None:
            result.append(None)
        else:
            result.append(round(pp - etp, 1))
    return result


def get_monthly_data(conn, id_estacion, year):
    """
    Datos mensuales para gráficas extrayendo la serie de 12 meses
    directamente de DatosMensuales (o agrupando DatosDiarios para Heladas).
    """
    H_STD    = 6   # 1.5m: TA, HR, PP, HSOL, IRD, INS
    H_VIENTO = 9   # 10m:  VV, DV

    def get_12_months(parametro, funcion, tabla="DatosMensuales", aggr="AVG", altura=H_STD):
        """Serie de 12 meses con filtro -9999 y lnAltura. Devuelve None por mes sin dato."""
        sql = f"""
        SELECT MONTH(D.FechaHora) as Mes, {aggr}(D.Valor) as Val
        FROM dbo.{tabla} D
        INNER JOIN dbo.SysMedidas M  ON M.idMedida  = D.lnMedida
        INNER JOIN dbo.SysSensores S ON S.idSensor  = M.lnSensor
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P   ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE S.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.Parametro  = ?
          AND F.Funcion    = ?
          AND LMT.lnAltura = ?
          AND M.lnUso = 1
          AND D.Valor <> -9999
        GROUP BY MONTH(D.FechaHora)
        ORDER BY MONTH(D.FechaHora)
        """
        rows = conn.execute(sql, id_estacion, year, parametro, funcion, altura).fetchall()
        arr = [None] * 12
        for r in rows:
            if 1 <= r.Mes <= 12 and r.Val is not None:
                arr[r.Mes - 1] = float(r.Val)
        return arr


    def get_frost_days():
        """Días de helada (TA_MIN < 0) por mes. Excluye -9999."""
        sql = """
        SELECT MONTH(D.FechaHora) as Mes, COUNT(*) as Dias
        FROM dbo.DatosDiarios D
        INNER JOIN dbo.SysMedidas M  ON M.idMedida  = D.lnMedida
        INNER JOIN dbo.SysSensores S ON S.idSensor  = M.lnSensor
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P   ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE S.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.Parametro  = 'TA'
          AND F.Funcion    = 'MIN'
          AND LMT.lnAltura = 6
          AND M.lnUso = 1
          AND D.Valor <> -9999
          AND D.Valor < 0
        GROUP BY MONTH(D.FechaHora)
        ORDER BY MONTH(D.FechaHora)
        """
        rows = conn.execute(sql, id_estacion, year).fetchall()
        arr = [0] * 12
        for r in rows:
            if 1 <= r.Mes <= 12:
                arr[r.Mes - 1] = int(r.Dias)
        return arr

    def get_bhc_monthly():
        """
        Balance Hídrico Climático mensual (idParametro=10117 / Parametro='BH').
        -9999 se trata como 'sin dato' → None en el array.
        """
        sql = """
        SELECT MONTH(D.FechaHora) as Mes, AVG(D.Valor) as Val
        FROM dbo.DatosMensuales D
        INNER JOIN dbo.SysMedidas M  ON M.idMedida  = D.lnMedida
        INNER JOIN dbo.SysSensores S ON S.idSensor  = M.lnSensor
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P ON P.idParametro = LMT.lnParametro
        WHERE S.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.idParametro = 10117
          AND D.Valor <> -9999
          AND M.lnUso = 1
        GROUP BY MONTH(D.FechaHora)
        ORDER BY MONTH(D.FechaHora)
        """
        rows = conn.execute(sql, id_estacion, year).fetchall()
        arr = [None] * 12
        for r in rows:
            if 1 <= r.Mes <= 12 and r.Val is not None:
                arr[r.Mes - 1] = round(float(r.Val), 1)
        return arr

    def get_wind_rose():
        # Consultamos pares de datos Viento/Dirección cruzando Datos10minutales por FechaHora
        # y filtrando por los IDs que usa MeteoDatos (81=Velocidad, 82=Dirección).
        sql = """
        SELECT VV.Valor as vv, DV.Valor as dv
        FROM dbo.Datos10minutales VV
        INNER JOIN dbo.Datos10minutales DV ON VV.InstanteLectura = DV.InstanteLectura
        INNER JOIN dbo.SysMedidas M_VV ON M_VV.idMedida = VV.lnMedida
        INNER JOIN dbo.SysSensores S_VV ON S_VV.idSensor = M_VV.lnSensor
        INNER JOIN dbo.ListaMedidasTipo T_VV ON T_VV.idTipo = M_VV.lnTipo
        INNER JOIN dbo.SysMedidas M_DV ON M_DV.idMedida = DV.lnMedida
        INNER JOIN dbo.SysSensores S_DV ON S_DV.idSensor = M_DV.lnSensor
        INNER JOIN dbo.ListaMedidasTipo T_DV ON T_DV.idTipo = M_DV.lnTipo
        WHERE S_VV.lnEstacion = ? AND S_DV.lnEstacion = ?
          AND YEAR(VV.InstanteLectura) = ? AND YEAR(DV.InstanteLectura) = ?
          AND T_VV.lnParametro = 81 AND T_VV.lnFuncion = 1 AND T_VV.lnTipoIntervalo = 1 AND M_VV.lnUso = 1
          AND T_DV.lnParametro = 82 AND T_DV.lnFuncion = 1 AND T_DV.lnTipoIntervalo = 1 AND M_DV.lnUso = 1
          AND VV.lnCodigoValidacion <> 3 AND DV.lnCodigoValidacion <> 3
          AND T_VV.lnAltura = T_DV.lnAltura
        """
        rows = conn.execute(sql, id_estacion, id_estacion, year, year).fetchall()
        
        # Array inicial de 8 sectores (N, NE, E, SE, S, SO, O, NO)
        freq = [0] * 8
        speed = [0] * 8
        calmas_pct = 0
        
        if not rows:
            return freq, speed, calmas_pct
            
        # Filtrar valores válidos
        valid_rows = [r for r in rows if r.vv is not None and r.dv is not None and r.vv != -9999 and r.dv != -9999]
        total_datos = len(valid_rows)
        
        if total_datos == 0:
            return freq, speed, calmas_pct
            
        # Contar calmas (viento <= 1.5 m/s)
        calmas_list = [r for r in valid_rows if r.vv <= 1.5]
        viento_list = [r for r in valid_rows if r.vv > 1.5]
        
        calmas_pct = round((len(calmas_list) / total_datos) * 100, 1)
        
        sectores_count = [0] * 8
        sectores_vv_sum = [0] * 8
        
        for r in viento_list:
            dv = float(r.dv)
            vv = float(r.vv)
            
            # Clasificación de la dirección en 8 sectores (45º cada uno)
            if dv >= 338 or dv < 23: idx = 0      # N
            elif 23 <= dv < 68:      idx = 1      # NE
            elif 68 <= dv < 113:     idx = 2      # E
            elif 113 <= dv < 158:    idx = 3      # SE
            elif 158 <= dv < 203:    idx = 4      # S
            elif 203 <= dv < 248:    idx = 5      # SO
            elif 248 <= dv < 293:    idx = 6      # O
            elif 293 <= dv < 338:    idx = 7      # NO
            else: continue
            
            sectores_count[idx] += 1
            sectores_vv_sum[idx] += vv
            
        total_viento = len(viento_list)
        
        for i in range(8):
            if total_viento > 0:
                freq[i] = round((sectores_count[i] / total_viento) * 100, 1)
            if sectores_count[i] > 0:
                speed[i] = round(sectores_vv_sum[i] / sectores_count[i], 1)
                
        return freq, speed, calmas_pct

    wind_freq, wind_speed, calmas = get_wind_rose()

    # Mapear los nombres de arrays que espera `charts.py`
    data = {
        # Temperaturas: altura 6 (1.5m)
        "tmax_med": get_12_months('TA', 'AVGMAX', aggr="AVG", altura=H_STD),
        "tmin_med": get_12_months('TA', 'AVGMIN', aggr="AVG", altura=H_STD),
        "tmax_abs": get_12_months('TA', 'MAX',    aggr="MAX", altura=H_STD),
        "tmin_abs": get_12_months('TA', 'MIN',    aggr="MIN", altura=H_STD),
        "ta_med":   get_12_months('TA', 'AVG',    aggr="AVG", altura=H_STD),
        "helada":   get_frost_days(),
        # Precipitación: altura 6
        "pp":  get_12_months('PP', 'SUM', aggr="SUM", altura=H_STD),
        # Balance Hídrico (consulta dedicada, idParametro=10117)
        "bhc": get_bhc_monthly(),
        # Humedad: altura 6
        "hr_med": get_12_months('HR', 'AVG',    aggr="AVG", altura=H_STD),
        "hr_max": get_12_months('HR', 'AVGMAX', aggr="MAX", altura=H_STD),
        "hr_min": get_12_months('HR', 'AVGMIN', aggr="MIN", altura=H_STD),
        # Insolación: altura 6
        "ins":  get_12_months('INS', 'AVG', aggr="AVG", altura=H_STD),
        # Viento: altura 9 (10m)
        "wind_freq":  wind_freq,
        "wind_speed": wind_speed,
        "calmas_pct": calmas,
    }
    
    return data


def get_station_image(conn, id_estacion):
    """Obtiene la foto de la estación desde la tabla Imagenes."""
    sql = """
    SELECT Imagen
    FROM dbo.Imagenes
    WHERE DescripcionEs = CAST(? AS VARCHAR)
      AND lnTipoImagen = 1
    """
    row = conn.execute(sql, str(id_estacion)).fetchone()
    if row and row.Imagen:
        return bytes(row.Imagen)
    return None


def get_province_images(conn, id_estacion):
    """Obtiene mapas de ubicación y provincia."""
    sql = """
    SELECT ImagenUbicacion, ImagenProvincia
    FROM dbo.TemporalAnuarioImagenEstacionEnProvincia
    WHERE LnEstacion = ?
    """
    row = conn.execute(sql, id_estacion).fetchone()
    if row:
        return {
            "ubicacion": bytes(row.ImagenUbicacion) if row.ImagenUbicacion else None,
            "provincia": bytes(row.ImagenProvincia) if row.ImagenProvincia else None,
        }
    return {"ubicacion": None, "provincia": None}
