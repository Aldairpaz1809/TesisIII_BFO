#!/bin/bash
output_dat_file="results_from_out_files.dat"  # Archivo donde guardaremos los resultados

# Limpiar el archivo de resultados antes de comenzar
echo "Pseudopotencial    Ecutwfc    Energía Total (Ry)    Tiempo Total (s)    Iteraciones" > $output_dat_file

# Iterar sobre todos los archivos .out en el directorio actual
for output_file in *.out; do

    # Extraer el nombre del pseudopotencial y el valor de ecutwfc desde el nombre del archivo

    ecutwfc=$(grep "kinetic-energy cutoff     =" $output_file | awk '{print $4 }')

    # Extraer la energía total
    energia=$(grep '!' $output_file | awk '{print $5}')

    # Extraer el tiempo de ejecución
tiempo=$(grep 'PWSCF' $output_file | tail -1 | awk -F ': ' '{print substr($0, index($0, ":") + 1, index($0, "CPU") - index($0, ":") - 1)}')




    # Extraer el número de iteraciones
    iteraciones=$(grep 'iteration #' $output_file | wc -l)

    # Guardar los resultados en el archivo .dat
    echo "$output_file    $ecutwfc    $energia    $tiempo    $iteraciones" >> $output_dat_file

    # Mostrar un mensaje en la terminal
    echo "Datos extraídos de $output_file"

done

