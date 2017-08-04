# NIFecg.jl
# Non Invasive - Fetal electrocardiogram
## Monitor Materno-Fetal

A partir de la señal electrocardiográfica abdominal de una materna, NIFecg provee las rutinas necesarias en Julia para detectar la señal del feto y de la madre.

Para evaluar el desempeño del paquete se usó la base de datos del "Noninvasive Fetal ECG: the PhysioNet/Computing in Cardiology Challenge 2013". Para mas información, ver: [https://physionet.org/challenge/2013/](https://physionet.org/challenge/2013/)


### Instalación

1. En Julia debe ejecutar `Pkg.clone("git://github.com/opterix/NIFecg.jl.git")`, la cual le permitirá descargar el paquete.

2. Para utilizar las funciones  del paquete debe ejecutar `using NIFecg`.


### Ejecutar prueba

1. Los datos para ser procesados deben estar en formato "csv" (`archivo.csv`). Estos deben ser grabaciones de al menos cuatro canales.

2. La función `MFMTest` aplica las funciones necesarias del paquete para detectar la señal del feto y de la madre. La prueba se ejecuta así:

`(inputVar,motherVar,fetalVar)=MFMTest("archivo",ts,sr);`:

#### Entradas
- `ts` =  el tiempo de la señal a ser procesada en segundos (mínimo 10 segundos)
- `sr` =  frecuencia de muestreo (mínimo 250 Hz)
- `archivo` = ruta del archivo csv (digitar sin la extensión)
	- El paquete detecta automáticamente los encabezados del csv.
	- Especificar el directorio del archivo ("directorio/archivo") o buscará en el directorio actual.
	- Sí tiene anotaciones del feto, guardarlas en el mismo directorio con el mismo nombre del archivo.csv pero con la extensión archivo.fqrs.txt.

#### Salidas

Estos datos son estructuras que contiene varias variables que se necesitan almacenar a lo largo del proceso.

- `inputVar` = Contiene las variables con la información para ser procesada después un análisis de errores y eliminación de información innecesaria
- `motherVar` = Contiene las variables con la información después del preprocesamiento y la extracción de la señal materna.
- `fetalVar` = Contiene las variables de la señal del feto extraída.

Ejemplo: En el directorio del paquete contiene `../data/`, este tiene el archivo `a01.csv` y `a01.fqrs.txt`. Entonces, para utilizar esta grabación de cuatro canales con 10 segundos de procesamiento a 1000 Hz, se ejecuta así `(inputVar,motherVar,fetalVar)=MFMTest("a01",10,1000);`


### Visualización

Por medio de la función `plotData` se puede visualizar el procesamiento de las señales en diferentes momentos de la siguiente manera:

`plotData(inputVar,motherVar,fetalVar,[número(s)de gráfica(s)])`

1. Señales de entrada
2. Preprocesamiento
3. Componentes independientes después de aplicar ICA
4. Señales residuales después de aplicar SVD
5. Ordenamiento de las señales según indicadores
6. N/A
7. Señal materna y fetal

Ejemplo: Para visualizar la gráfica 2,3 y 7 debe ejecutarse de esta manera: `plotData(inputVar,motherVar,fetalVar,[2,3,7])`





