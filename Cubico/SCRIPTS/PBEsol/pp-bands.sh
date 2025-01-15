#!/bin/bash
# Script para post-procesamiento de bandas

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


# Función para ejecutar el cálculo de bandas
run_bands() {
    local name="$1"
    local spin="$2"
    local filband="$3"
    
    input_file="${name}.bifeo3.in"
    output_file="${name}.bifeo3.out"

    # Verificar el valor de spin y crear el archivo de entrada
    if [ "$spin" -eq 0 ]; then
        cat > $input_file <<EOF
&bands
    prefix="bifeo3"
    outdir = "$base_dir/bands"
    filband="$filband"
/
EOF
    else
        cat > $input_file <<EOF
&bands
    prefix="bifeo3"
    outdir = "$base_dir/bands"
    filband="$filband"
    nspin=$spin
/
EOF
    fi

    # Ejecutar el cálculo de bandas
    echo "Ejecutando cálculo de bandas con nspin=$spin"
    mpirun -np $n bands.x < $input_file > $output_file
}

# Ejecutar el procesamiento para diferentes configuraciones
run_bands "pp-bands" 0 "bifeo3.bandas"
run_bands "pp-bands_1" 1 "bifeo3.bandas_1"
run_bands "pp-bands_2" 2 "bifeo3.bandas_2"

echo "Cálculo de bandas completado."

if [ $? -eq 0 ]; then
  echo 0  # Retorna 0 si todo está bien
fi
