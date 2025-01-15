#!/bin/bash
# Script para cálculo de densidad de carga

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
# Densidad de carga
name="charge_density"


echo "Creando carpeta"
mkdir -p $base_dir/charge_density
if [ $? -ne 0 ]; then
	echo "Error al crear carpetas"
	exit 1
fi
# Copiar archivos de SCF a la carpeta de densidad de carga
cp -r $base_dir/scf/* $base_dir/charge_density

input_file="${name}_bifeo3.in"
output_file="${name}_bifeo3.out"


cat > $input_file <<EOF
&inputpp
prefix="bifeo3"
outdir="$base_dir/charge_density"
filplot="bifeo3.rho.dat"
plot_num=0
/
&plot
  title="Densidad de Carga de BiFeO3"
  z=0.0                  ! Proyección en z = 0
  x=0.0, 10.0           ! Rango en x (ejemplo)
  y=0.0, 10.0           ! Rango en y (ejemplo)
  ldos = .true.         ! Usar densidad de estados local
/
EOF


echo "Ejecutando cálculo de densidad de carga"
mpirun -np $n pp.x < $input_file > $output_file


if [ $? -eq 0 ]; then
  echo 0  # Retorna 0 si todo está bien
fi










