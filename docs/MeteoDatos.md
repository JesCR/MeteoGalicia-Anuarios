# Guía Rápida: Estructura de MeteoDatos

Este documento es una referencia rápida de las principales tablas y vistas de la base de datos `MeteoDatos` para consultar información sobre las estaciones meteorológicas.

## 1. Información Básica de las Estaciones

**Tabla Principal:** `dbo.SysEstaciones`
- Contiene los campos básicos de identificación.
- Campos clave: `idEstacion`, `Estacion` (Nombre largo), `NombreCorto`, `EnServicio`.
- Claves Foráneas: `lnConcello`, `lnPropietario`, `lnSubred`.

**Tablas Geográficas y Administrativas Asociadas:**
- `dbo.AuxConcellos`: Información de Concellos (`idConcello`, `NOME`, `lnPROV`).
- `dbo.AuxProvincias`: Información de Provincias (`IdPROV`, `NOME`).

**Vista Recomendada:** `dbo.Vista_Estaciones_Provincia_Concello`
- Ideal para extraer los nombres de los ayuntamientos y provincias asociados a una estación.
- Retorna: `Estacion`, `idEstacion`, `lnProvincia`, `Provincia`, `lnConcello`, `Concello`.

## 2. Coordenadas y Altitud

La base de datos almacena diferentes proyecciones y tipos de coordenadas en la tabla de relaciones `dbo.CruceEstacionesListaEstacionesCoordenadas`, que mapea las estaciones a diccionarios de coordenadas en `dbo.ListaEstacionesCoordenadas`.

**Tipos de Coordenadas (`idTipoCoordenadas`):**
1. UTM_ETRS89
2. GEOG_ETRS89 (Lat/Lon)
3. GEOG_WGS84 (Lat/Lon)
4. UTM_ETRS89_MDT250

**Vista Recomendada para Lat/Lon y Altitud (EPSG:4326):** `dbo.Vista_CruceEstacionesListaEstacionesCoordenadas_LatLonAlt_WGS84`
- Esta vista proporciona directamente la Latitud, Longitud y Altitud en formato WGS84 para rellenar los metadatos de las fichas.
- Retorna: `lnEstacion`, `Lat`, `Lon`, `Alt`, `FechaInicio`, `FechaFin`.

**Vista Recomendada para UTM:** `dbo.Vista_CruceEstacionesListaEstacionesCoordenadas_UTM_ETRS89`
- Retorna: `lnEstacion`, `UTMX`, `UTMY`, `Alt`, `geomUTM`.

## 3. Sensores y Medidas

**Tablas Principales:**
- `dbo.SysSensores`: Define los sensores instalados en una `lnEstacion`.
- `dbo.SysMedidas`: Define los tipos de medidas que registra un `lnSensor`.

**Vista Recomendada:** `dbo.VIDX_AyudaMedidas`
- Útil para explorar la jerarquía Estación -> Sensor -> Medida -> Parámetro.
- Retorna: `idEstacion`, `Estacion`, `idSensor`, `Sensor`, `idMedida`, `Medida`, `idParametro`, `Parametro` (ej: 'TA' para temperatura, 'PP' para lluvia).

## 4. Datos Históricos

Dependiendo de la resolución temporal, consultar:
- `dbo.Datos10minutales` (Para métricas precisas como rafagas de viento "GT" o rosas de vientos).
- `dbo.DatosHorarios`
- `dbo.DatosDiarios` (Para cálculos de días de lluvia "NDPP" o días de helada "NDX").
- `dbo.DatosMensuales` (Para agregados mensuales como Pluviometría total mensual "PP").

## 5. Referencia de IDs: Parámetros, Funciones y Alturas

Estas son las three dimensiones que identifican unívocamente una `idMedida`.

### Parámetros (`SysParametros.idParametro`)
| idParametro | Parametro | Descripción |
|-------------|-----------|-------------|
| 81 | VV | Velocidad del viento |
| 82 | DV | Dirección del viento |
| 83 | TA | Temperatura del aire |
| 86 | HR | Humedad relativa |
| 88 | RS | Radiación solar |
| 10001 | PP | Precipitación |
| 10002 | PR | Presión atmosférica |
| 10006 | HSOL | Horas de sol |
| 10013 | IRD | Irradiación |
| 10106 | INS | Insolación (%) |
| 10117 | BH | Balance Hídrico |
| 10129 | ET0 | Evapotranspiración potencial |
| 10119 | NDX | Nº días de xeada |
| 10120 | NDPP | Nº días de precipitación |

### Funciones (`ListaMedidasFunciones.idFuncion`)
| idFuncion | Funcion |
|-----------|---------|
| 1 | AVG |
| 2 | MAX |
| 3 | MIN |
| 4 | SUM |
| 12 | AVGMAX |
| 13 | AVGMIN |
| 14 | RACHA |

### Alturas (`ListaMedidasAlturas.idAltura`)
| idAltura | Altura (m) | Uso habitual |
|----------|-----------|---------------|
| 6 | 1.5 | TA, HR, PP, HSOL, IRD, INS, PR |
| 9 | 10 | VV (velocidad viento), DV (dirección) |
| 18 | -0.1 | Temperatura del suelo superficial |
| 20 | 0.1 | Vegetación baja |

> [!TIP]
> En el código Python se usan las constantes `H_STD = 6` y `H_VIENTO = 9` para asegurar la selección correcta de sensores.
