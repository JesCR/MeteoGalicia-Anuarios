import json
import pyodbc
from data_queries import get_connection

def main():
    conn = get_connection()
    cursor = conn.cursor()
    
    print("--- Parametros ---")
    cursor.execute("SELECT idParametro, Parametro, lnTipounidad FROM dbo.SysParametros")
    for row in cursor.fetchall():
        print(row.idParametro, row.Parametro)
        
    print("\n--- Funciones ---")
    cursor.execute("SELECT idFuncion, Funcion FROM dbo.ListaMedidasFunciones")
    for row in cursor.fetchall():
        print(row.idFuncion, row.Funcion)
        
    print("\n--- Intervalos ---")
    cursor.execute("SELECT idTipoIntervalo, TipoIntervalo FROM dbo.TipoIntervalo")
    for row in cursor.fetchall():
        print(row.idTipoIntervalo, row.TipoIntervalo)

    print("\n--- Alturas ---")
    cursor.execute("SELECT idAltura, Altura FROM dbo.ListaMedidasAlturas")
    for row in cursor.fetchall():
        print(row.idAltura, row.Altura)

if __name__ == '__main__':
    main()
