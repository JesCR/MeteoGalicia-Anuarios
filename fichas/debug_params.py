from data_queries import get_connection

def check_table(conn, table, date_col, id_estacion, year):
    print(f"\n--- Diagnóstico Tabla {table} ---")
    sql = f"""
    SELECT P.Parametro, F.Funcion, COUNT(*) as NumDatos
    FROM dbo.{table} D
    INNER JOIN dbo.SysMedidas M ON M.idMedida = D.lnMedida
    INNER JOIN dbo.SysSensores S ON S.idSensor = M.lnSensor
    INNER JOIN dbo.ListaMedidasTipo LMT ON LMT.idTipo = M.lnTipo
    INNER JOIN dbo.SysParametros P ON P.idParametro = LMT.lnParametro
    INNER JOIN dbo.ListaMedidasFunciones F ON F.idFuncion = LMT.lnFuncion
    WHERE S.lnEstacion = ? AND YEAR(D.{date_col}) = ?
    GROUP BY P.Parametro, F.Funcion
    ORDER BY P.Parametro, F.Funcion
    """
    rows = conn.execute(sql, id_estacion, year).fetchall()
    if not rows:
        print(f"No hay datos en {table}.")
    for row in rows:
        print(f"Param: {row.Parametro:10} | Func: {row.Funcion:10} | Datos: {row.NumDatos}")

if __name__ == "__main__":
    c = get_connection()
    est, yr = 10124, 2023
    check_table(c, "DatosMensuales", "FechaHora", est, yr)
    check_table(c, "DatosDiarios", "FechaHora", est, yr)
    check_table(c, "Datos10minutales", "InstanteLectura", est, yr)
