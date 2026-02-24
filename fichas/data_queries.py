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
        P.Provincia, C.Concello
    FROM dbo.SysEstaciones E
    LEFT JOIN dbo.AuxConcellos C ON C.idConcello = E.lnConcello
    LEFT JOIN dbo.AuxProvincias P ON P.idProvincia = C.lnProvincia
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
    }


def get_annual_summary(conn, id_estacion, year):
    """
    Resumen anual calculando agregados directamente desde DatosMensuales,
    DatosDiarios y Datos10minutales (Rosa de Vientos / Rachas).
    """
    
    # 1. Función de ayuda para ejecutar métricas individuales:
    def get_metric(parametro, funcion, tabla="DatosMensuales", aggr="AVG", extra_where=""):
        # Mapeo de aggr a función SQL real (AVG, MAX, MIN, SUM)
        sql = f"""
        SELECT {aggr}(D.Valor) as Val
        FROM dbo.{tabla} D
        INNER JOIN dbo.SysMedidas M ON M.idMedida = D.lnMedida
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE M.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.Parametro = ?
          AND F.Funcion = ?
          {extra_where}
        """
        row = conn.execute(sql, id_estacion, year, parametro, funcion).fetchone()
        return row.Val if row and row.Val is not None else None

    # 2. Función para obtener un valor extremo y su fecha (TMAX, TMIN, PPMAX, GTMAX)
    def get_extreme_with_date(parametro, funcion, tabla="DatosDiarios", order="DESC"):
        sql = f"""
        SELECT TOP 1 D.Valor, D.FechaHora
        FROM dbo.{tabla} D
        INNER JOIN dbo.SysMedidas M ON M.idMedida = D.lnMedida
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE M.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.Parametro = ?
          AND F.Funcion = ?
        ORDER BY D.Valor {order}
        """
        row = conn.execute(sql, id_estacion, year, parametro, funcion).fetchone()
        if row and row.Valor is not None:
            return round(row.Valor, 1), row.FechaHora.strftime('%d/%m/%Y')
        return None, None
        
    # 3. Función para contar días que cumplen una condición (Helada, Lluvia)
    def count_days(parametro, funcion, operator, threshold):
        sql = f"""
        SELECT COUNT(*) as Dias
        FROM dbo.DatosDiarios D
        INNER JOIN dbo.SysMedidas M ON M.idMedida = D.lnMedida
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE M.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.Parametro = ?
          AND F.Funcion = ?
          AND D.Valor {operator} {threshold}
        """
        row = conn.execute(sql, id_estacion, year, parametro, funcion).fetchone()
        return row.Dias if row else 0

    # Ejecutar métricas
    # Temperaturas
    ta = get_metric('TA', 'Med', aggr="AVG")
    tmaxmed = get_metric('TA', 'Max', aggr="AVG")
    tminmed = get_metric('TA', 'Min', aggr="AVG")
    
    tmax, ftmax = get_extreme_with_date('TA', 'Max', order="DESC")
    tmin, ftmin = get_extreme_with_date('TA', 'Min', order="ASC")
    
    # Humedad
    hrmed = get_metric('HR', 'Med', aggr="AVG")
    
    # Precipitación
    pp = get_metric('PP', 'Suma', tabla="DatosMensuales", aggr="SUM")
    ppmax, fppmax = get_extreme_with_date('PP', 'Suma', tabla="DatosDiarios", order="DESC")
    
    # Días de Lluvia y Helada
    ndpp = count_days('PP', 'Suma', '>=', 0.1)
    ndx = count_days('TA', 'Min', '<', 0)
    
    # Radiación / Sol
    hsol = get_metric('HSOL', 'Suma', tabla="DatosMensuales", aggr="SUM")
    ird = get_metric('RD', 'Med', aggr="AVG") # Suponiendo Parametro RD o IRD
    
    # Viento
    vv = get_metric('VV', 'Med', tabla="DatosMensuales", aggr="AVG")
    gtmax, fgtmax = get_extreme_with_date('VV', 'Max', tabla="Datos10minutales", order="DESC")

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


def get_monthly_data(conn, id_estacion, year):
    """
    Datos mensuales para gráficas extrayendo la serie de 12 meses
    directamente de DatosMensuales (o agrupando DatosDiarios para Heladas).
    """
    
    def get_12_months(parametro, funcion, tabla="DatosMensuales", aggr="AVG"):
        # Serie de 12 meses, llenando con None si no hay dato
        sql = f"""
        SELECT MONTH(D.FechaHora) as Mes, {aggr}(D.Valor) as Val
        FROM dbo.{tabla} D
        INNER JOIN dbo.SysMedidas M ON M.idMedida = D.lnMedida
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE M.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.Parametro = ?
          AND F.Funcion = ?
        GROUP BY MONTH(D.FechaHora)
        ORDER BY MONTH(D.FechaHora)
        """
        rows = conn.execute(sql, id_estacion, year, parametro, funcion).fetchall()
        
        arr = [None] * 12
        for r in rows:
            if 1 <= r.Mes <= 12 and r.Val is not None:
                arr[r.Mes - 1] = float(r.Val)
        return arr

    def get_frost_days():
        sql = """
        SELECT MONTH(D.FechaHora) as Mes, COUNT(*) as Dias
        FROM dbo.DatosDiarios D
        INNER JOIN dbo.SysMedidas M ON M.idMedida = D.lnMedida
        INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
        INNER JOIN dbo.SysParametros P ON P.idParametro = LMT.lnParametro
        INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
        WHERE M.lnEstacion = ?
          AND YEAR(D.FechaHora) = ?
          AND P.Parametro = 'TA'
          AND F.Funcion = 'Min'
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

    def get_wind_rose():
        # Consultamos pares de datos Viento/Dirección cruzando Datos10minutales por FechaHora
        # y filtrando por los IDs que usa MeteoDatos (81=Velocidad, 82=Dirección).
        sql = """
        SELECT VV.Valor as vv, DV.Valor as dv
        FROM dbo.Datos10minutales VV
        INNER JOIN dbo.Datos10minutales DV ON VV.FechaHora = DV.FechaHora
        INNER JOIN dbo.SysMedidas M_VV ON M_VV.idMedida = VV.lnMedida
        INNER JOIN dbo.ListaMedidasTipo T_VV ON T_VV.idTipo = M_VV.lnTipo
        INNER JOIN dbo.SysMedidas M_DV ON M_DV.idMedida = DV.lnMedida
        INNER JOIN dbo.ListaMedidasTipo T_DV ON T_DV.idTipo = M_DV.lnTipo
        WHERE M_VV.lnEstacion = ? AND M_DV.lnEstacion = ?
          AND YEAR(VV.FechaHora) = ? AND YEAR(DV.FechaHora) = ?
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
        "tmax_med": get_12_months('TA', 'Max', aggr="AVG"),
        "tmin_med": get_12_months('TA', 'Min', aggr="AVG"),
        "tmax_abs": get_12_months('TA', 'Max', aggr="MAX"),
        "tmin_abs": get_12_months('TA', 'Min', aggr="MIN"),
        "ta_med": get_12_months('TA', 'Med', aggr="AVG"),
        "helada": get_frost_days(),
        "pp": get_12_months('PP', 'Suma', aggr="SUM"),
        "bhc": get_12_months('BHC', 'Suma', aggr="SUM"),
        "hr_med": get_12_months('HR', 'Med', aggr="AVG"),
        "hr_max": get_12_months('HR', 'Max', aggr="MAX"),
        "hr_min": get_12_months('HR', 'Min', aggr="MIN"),
        "ins": get_12_months('INS', 'Med', aggr="AVG"),
        
        "wind_freq": wind_freq,
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
