# -*- coding: utf-8 -*-
"""
Script de diagnóstico de datos de viento.

Usage:
    python debug_wind.py 19071 2025

Pasos:
  1. Verifica si la vista VIDX_AyudaMedidas_NOEXPAND devuelve filas para VV/DV
  2. Si no hay filas: prueba la vista sin filtro para ver qué hay disponible
  3. Si hay filas: verifica que Datos10minutales tiene registros en el año
  4. Cuántos registros hay y qué códigos de validación tienen
  5. Datos de DatosMensuales para parámetros de viento (30000+)
  6. TEST CLAVE: ¿Tienen VV y DV el mismo InstanteLectura exacto (hasta ms)?
  7. Simula la query exacta de get_wind_rose_10min con GROUP BY
"""

import sys
from data_queries import get_connection

def run(id_estacion, year):
    conn = get_connection()
    print(f"\n{'='*60}")
    print(f"  DIAGNÓSTICO VIENTO  —  Estación {id_estacion}, Año {year}")
    print(f"{'='*60}\n")

    # ─── 1. ¿Qué devuelve la vista con los filtros actuales? ────────────────
    print("[1] idMedidas VV/DV — filtro idParametro IN (81,82), idUso=1, idTipoIntervalo=1, idFuncion=1\n")
    sql1 = """
    SELECT idMedida, Parametro
    FROM dbo.VIDX_AyudaMedidas_NOEXPAND
    WHERE idEstacion = ?
      AND idParametro IN (81, 82)
      AND idUso = 1
      AND idTipoIntervalo = 1
      AND idFuncion = 1
    """
    try:
        rows1 = conn.execute(sql1, (id_estacion,)).fetchall()
        id_vv, id_dv = None, None
        for r in rows1:
            p = r.Parametro.strip()
            print(f"  idMedida={r.idMedida}  Parametro={p}")
            if p == 'VV': id_vv = r.idMedida
            elif p == 'DV': id_dv = r.idMedida
        if not rows1:
            print("  *** Sin resultados ***")
    except Exception as e:
        print(f"  ERROR: {e}")
        id_vv, id_dv = None, None

    if not id_vv or not id_dv:
        print("\n  *** No se encontraron VV/DV. Diagnóstico detenido. ***")
        conn.close()
        return

    print(f"\n  -> id_vv={id_vv}, id_dv={id_dv}")

    # ─── 6. TEST CLAVE: ¿Coinciden exactamente los InstanteLectura? ──────────
    print(f"\n[6] TEST TIMESTAMP: ¿Coinciden VV/DV en InstanteLectura?\n")
    sql6 = """
    SELECT TOP 5
        VV.InstanteLectura AS ts_vv,
        DV.InstanteLectura AS ts_dv,
        DATEDIFF(millisecond, VV.InstanteLectura, DV.InstanteLectura) AS diff_ms,
        VV.Valor AS vv, DV.Valor AS dv
    FROM dbo.Datos10minutales VV
    INNER JOIN dbo.Datos10minutales DV
        ON CAST(VV.InstanteLectura AS DATE) = CAST(DV.InstanteLectura AS DATE)
        AND DATEPART(hour, VV.InstanteLectura) = DATEPART(hour, DV.InstanteLectura)
        AND DATEPART(minute, VV.InstanteLectura) = DATEPART(minute, DV.InstanteLectura)
    WHERE VV.lnMedida = ? AND DV.lnMedida = ?
      AND VV.InstanteLectura >= ? AND VV.InstanteLectura < ?
    """
    try:
        rows6 = conn.execute(sql6, (id_vv, id_dv, f"{year}-01-01", f"{year+1}-01-01")).fetchall()
        if rows6:
            for r in rows6:
                print(f"  VV={r.ts_vv}  DV={r.ts_dv}  diff_ms={r.diff_ms}  vv={r.vv:.2f}  dv={r.dv:.1f}")
        else:
            print("  *** JOIN por fecha+hora+minuto tampoco da resultados — problema grave ***")
    except Exception as e:
        print(f"  ERROR: {e}")

    # ─── 6b. TEST SIMPLE: ¿Join exacto por = en InstanteLectura? ─────────────
    print(f"\n[6b] JOIN exacto (=) en InstanteLectura — primeros 5 registros:\n")
    sql6b = """
    SELECT TOP 5
        VV.InstanteLectura, VV.Valor AS vv, DV.Valor AS dv
    FROM dbo.Datos10minutales VV
    INNER JOIN dbo.Datos10minutales DV
        ON VV.InstanteLectura = DV.InstanteLectura
    WHERE VV.lnMedida = ? AND DV.lnMedida = ?
      AND VV.InstanteLectura >= ? AND VV.InstanteLectura < ?
      AND VV.lnCodigoValidacion IN (1, 5)
      AND DV.lnCodigoValidacion IN (1, 5)
    """
    try:
        rows6b = conn.execute(sql6b, (id_vv, id_dv, f"{year}-01-01", f"{year+1}-01-01")).fetchall()
        if rows6b:
            for r in rows6b:
                print(f"  ts={r.InstanteLectura}  vv={r.vv:.4f}  dv={r.dv:.1f}")
            print(f"\n  -> JOIN exacto funciona. El problema era en otro lado.")
        else:
            print("  *** JOIN exacto devuelve 0 filas — los timestamps NO coinciden exactamente ***")
    except Exception as e:
        print(f"  ERROR: {e}")

    # ─── 7. Simular la query exacta del get_wind_rose_10min ──────────────────
    print(f"\n[7] Simulación exacta de get_wind_rose_10min GROUP BY:\n")
    sql7 = """
    SELECT
        CASE
            WHEN VV.Valor < 1.5   THEN 'CALMA'
            WHEN VV.Valor <= 5.5  THEN 'frouxos'
            WHEN VV.Valor <= 11.5 THEN 'moderados'
            WHEN VV.Valor <= 19.5 THEN 'fortes'
            ELSE 'moi_fortes'
        END AS clase,
        CASE
            WHEN VV.Valor < 1.5                                      THEN 'CALMA'
            WHEN DV.Valor >= 338 OR DV.Valor < 23 OR DV.Valor = 360 THEN 'N'
            WHEN DV.Valor >= 23  AND DV.Valor < 68                   THEN 'NE'
            WHEN DV.Valor >= 68  AND DV.Valor < 113                  THEN 'E'
            WHEN DV.Valor >= 113 AND DV.Valor < 158                  THEN 'SE'
            WHEN DV.Valor >= 158 AND DV.Valor < 203                  THEN 'S'
            WHEN DV.Valor >= 203 AND DV.Valor < 248                  THEN 'SO'
            WHEN DV.Valor >= 248 AND DV.Valor < 293                  THEN 'O'
            WHEN DV.Valor >= 293 AND DV.Valor < 338                  THEN 'NO'
            ELSE 'CALMA'
        END AS sector,
        COUNT(*) AS n
    FROM dbo.Datos10minutales VV
    INNER JOIN dbo.Datos10minutales DV
        ON VV.InstanteLectura = DV.InstanteLectura
    WHERE VV.lnMedida = ? AND DV.lnMedida = ?
      AND VV.InstanteLectura >= ? AND VV.InstanteLectura < ?
      AND VV.lnCodigoValidacion IN (1, 5)
      AND DV.lnCodigoValidacion IN (1, 5)
      AND VV.Valor >= 0
      AND VV.Valor <> -9999
      AND DV.Valor <> -9999
    GROUP BY
        CASE
            WHEN VV.Valor < 1.5   THEN 'CALMA'
            WHEN VV.Valor <= 5.5  THEN 'frouxos'
            WHEN VV.Valor <= 11.5 THEN 'moderados'
            WHEN VV.Valor <= 19.5 THEN 'fortes'
            ELSE 'moi_fortes'
        END,
        CASE
            WHEN VV.Valor < 1.5                                      THEN 'CALMA'
            WHEN DV.Valor >= 338 OR DV.Valor < 23 OR DV.Valor = 360 THEN 'N'
            WHEN DV.Valor >= 23  AND DV.Valor < 68                   THEN 'NE'
            WHEN DV.Valor >= 68  AND DV.Valor < 113                  THEN 'E'
            WHEN DV.Valor >= 113 AND DV.Valor < 158                  THEN 'SE'
            WHEN DV.Valor >= 158 AND DV.Valor < 203                  THEN 'S'
            WHEN DV.Valor >= 203 AND DV.Valor < 248                  THEN 'SO'
            WHEN DV.Valor >= 248 AND DV.Valor < 293                  THEN 'O'
            WHEN DV.Valor >= 293 AND DV.Valor < 338                  THEN 'NO'
            ELSE 'CALMA'
        END
    """
    try:
        rows7 = conn.execute(sql7, (id_vv, id_dv, f"{year}-01-01", f"{year+1}-01-01")).fetchall()
        if rows7:
            total = sum(r.n for r in rows7)
            print(f"  Total registros: {total}")
            for r in rows7:
                print(f"  sector={r.sector}  clase={r.clase}  n={r.n}")
        else:
            print("  *** Query GROUP BY devuelve 0 filas — confirma el problema del JOIN ***")
    except Exception as e:
        print(f"  ERROR: {e}")

    print(f"\n{'='*60}\n")
    conn.close()


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python debug_wind.py <id_estacion> <year>")
        print("  Ej: python debug_wind.py 19071 2025")
        sys.exit(1)
    run(int(sys.argv[1]), int(sys.argv[2]))
