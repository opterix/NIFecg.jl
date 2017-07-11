# NI-Fecg  
## Non Invasive - Fetal electrocardiogram
### Monitor Materno-Fetal

A partir de la señal electrocardiográfica abdominal de una materna, NI-Fecg provee las rutinas necesarias en Julia para detectar la señal del feto y de la madre.

#### Instalación

1. En Julia debe ejecutar la siguiente sentencia `Pkg.clone("git://github.com/opterix/NI-Fecg.jl.git")`, la cual le permitirá descargar el paquete en su computador.

2. Para utilizar las funciones  del paquete debe ejecutar `using NI-Fecg`.


#### Ejecutar prueba

1. Los datos para ser procesados debe estar en formato "csv" (`archivo.csv`).

2. La función `MFMTest` aplica las funciones necesarias del paquete para detectar la señal del feto y de la madre. La prueba se ejecuta así:

`(inputVar,motherVar,fetalVar)=MFMTest("archivo",ts,sr)`

	> ts =  el tiempo de la señal a ser procesada en segundos (mínimo 10 segundos)
	> sr =  frecuencia de muestreo (minimo 250 Hz)
	> archivo = ruta del archivo csv (digitar sin la extensión)
			Notas: 	
				- El paquete detecta automaticamente los encabezados del csv.
				- Especificar el directorio del archivo ("directorio/archivo") o buscará en el direcorio actual.
			 	- Sí tiene anotaciones del feto, guardarlas en el mismo directorio con la extensión archivo.fqrs.txt (el csv y el fqrs.txt deben tener el mismo nombre).

