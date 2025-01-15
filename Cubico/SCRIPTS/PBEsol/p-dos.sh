#!/bin/bash
# Script para cálculo de P-DOS

# Valores por defecto
base_dir="/home/aldair1809/Documentos/QE/4BFO/temp"
n=4  # Número de cores

# Manejo de opciones
while getopts "b:n:" opt; do
  case $opt in
    b) base_dir="$OPTARG" ;;
    n) n="$OPTARG" ;;
    \?) echo "Opción inválida: -$OPTARG" ;;
  esac
done

# P-DOS
name="p-dos"

echo "Creando carpeta para P-DOS"
mkdir -p $base_dir/p-dos
if [ $? -ne 0 ]; then
	echo "Error al crear carpetas"
	exit 1
fi

# Copiar archivos de NSCF a la carpeta de P-DOS
cp -r $base_dir/nscf/* $base_dir/p-dos

# Cálculo del valor de referencia
input_file="${name}_bifeo3.in"
output_file="${name}_bifeo3.out"

# Generar el archivo de entrada
cat > $input_file <<EOF
&PROJWFC
    prefix="bifeo3"
    outdir='$base_dir/p-dos'
    filpdos="bifeo3_dat.dat"
    filproj="bifeo3.proy.dos"
    Emin=-10
    DeltaE=0.01
    Emax=32
    degauss=0.01
    ngauss=0
/
EOF

# Ejecutar el cálculo de P-DOS
echo "Ejecutando cálculo de P-DOS"
mpirun -np $n projwfc.x < $input_file > $output_file

echo "Cálculo de P-DOS completado. Salida en $output_file."

if [ $? -eq 0 ]; then
  echo 0  # Retorna 0 si todo está bien
fi
