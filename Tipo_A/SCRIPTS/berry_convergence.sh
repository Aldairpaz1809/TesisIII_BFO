#!/bin/bash

# Archivo de referencia
reference_file="nscf.bifeo3_bp.in"

# Valores para nppstr
nppstr_values=(4 5 6 7 8)

# Loop para iterar sobre los valores de nppstr
for nppstr in "${nppstr_values[@]}"; do
    output_file="nscf.bifeo3_bp_3_${nppstr}"
    
    # Modificar el archivo de entrada
    sed -e "s/^\s*nppstr\s*=.*/    nppstr = $nppstr/" "$reference_file" > "${output_file}.in"
    
    # Ejecutar Quantum ESPRESSO
    mpirun -np 4 pw.x -in "${output_file}.in" > "${output_file}.out"
done

