#!/bin/bash
name="ecut"
output_dat_file="results.dat"  # Archivo donde guardaremos los resultados

# Variables para modificar parámetros
pseudo_dir="/home/aldair1809/Programas/QE/q-e-qe-7.3/pseudo"
kpoints_values=(1 2 3 4 5 6 7)

# Lista de valores de ecutwfc a probar
ecutwfc=30

# Lista de pseudopotenciales a probar
pseudo_set="o_pbe_v1.2.uspp.F.UPF bi_pbe_v1.uspp.F.UPF fe_pbe_v1.5.uspp.F.UPF"


# Separar pseudopotenciales específicos
pseudo_o=$(echo $pseudo_set | awk '{print $1}')
pseudo_bi=$(echo $pseudo_set | awk '{print $2}')
pseudo_fe=$(echo $pseudo_set | awk '{print $3}')
echo "#ecutwfc energia_total tiempo N_iteraciones" > $output_dat_file
# Iterar sobre los diferentes valores de ecutwfc
    for kpoints in "${kpoints_values[@]}"; do

        # Definir nombre del archivo de entrada y salida
        input_file="${name}_ecutwfc_${kpoints}.in"
        output_file="${name}_ecutwfc_${kpoints}.out"

        # Crear el archivo de entrada modificado
        cat > $input_file << EOF
 &CONTROL
   calculation  = 'scf'
   outdir       = '/home/aldair1809/Documentos/QE/4BFO/temp/'
   prefix       = 'bifeo3'
   pseudo_dir   = '$pseudo_dir'
   restart_mode = 'from_scratch'
   verbosity    = 'high'
 /

&SYSTEM
   degauss                   = 0.01
   ecutwfc                   = $ecutwfc
   ecutrho                   = $((ecutwfc*8))
   ibrav                     = 1
   a                         = 7.892
   nat                       = 40
   nspin                     = 2
   ntyp                      = 4
   occupations               = 'smearing'
   smearing                  = 'm-p'
   starting_magnetization(3) = -0.8
   starting_magnetization(4) = 0.8
 /
&ELECTRONS
   conv_thr         = 1e-5
   diagonalization  = "cg"
   electron_maxstep = 300
   mixing_beta      = 0.4
   mixing_mode      = "plain"
   startingpot      = 'random'
   startingwfc      = "atomic+random"
 /
ATOMIC_SPECIES
    O    15.9994   $pseudo_o
    Bi   208.9804  $pseudo_bi
    Fe1  55.845    $pseudo_fe
    Fe2  55.845    $pseudo_fe
ATOMIC_POSITIONS (crystal)
Bi   0.000000000000000   0.000000000000000   0.000000000000000 
Bi   0.500000000000000   0.500000000000000   0.000000000000000 
Bi   0.500000000000000   0.000000000000000   0.000000000000000 
Bi   0.000000000000000   0.500000000000000   0.500000000000000 
Bi   0.000000000000000   0.000000000000000   0.500000000000000 
Bi   0.500000000000000   0.500000000000000   0.500000000000000 
Bi   0.500000000000000   0.000000000000000   0.500000000000000 
Bi   0.000000000000000   0.500000000000000   0.000000000000000 
Fe2  0.250000000000000   0.250000000000000   0.250000000000000 
Fe2  0.750000000000000   0.750000000000000   0.250000000000000 
Fe1  0.750000000000000   0.250000000000000   0.250000000000000 
Fe1  0.250000000000000   0.750000000000000   0.750000000000000 
Fe2  0.250000000000000   0.250000000000000   0.750000000000000 
Fe2  0.750000000000000   0.750000000000000   0.750000000000000 
Fe1  0.750000000000000   0.250000000000000   0.750000000000000 
Fe1  0.250000000000000   0.750000000000000   0.250000000000000 
 O   0.250000000000000   0.250000000000000   0.000000000000000 
 O   0.250000000000000   0.000000000000000   0.250000000000000 
 O   0.000000000000000   0.250000000000000   0.250000000000000 
 O   0.750000000000000   0.750000000000000   0.000000000000000 
 O   0.750000000000000   0.250000000000000   0.000000000000000 
 O   0.250000000000000   0.750000000000000   0.500000000000000 
 O   0.250000000000000   0.250000000000000   0.500000000000000 
 O   0.750000000000000   0.750000000000000   0.500000000000000 
 O   0.750000000000000   0.250000000000000   0.500000000000000 
 O   0.250000000000000   0.750000000000000   0.000000000000000 
 O   0.750000000000000   0.500000000000000   0.250000000000000 
 O   0.750000000000000   0.000000000000000   0.250000000000000 
 O   0.250000000000000   0.500000000000000   0.750000000000000 
 O   0.250000000000000   0.000000000000000   0.750000000000000 
 O   0.750000000000000   0.500000000000000   0.750000000000000 
 O   0.750000000000000   0.000000000000000   0.750000000000000 
 O   0.250000000000000   0.500000000000000   0.250000000000000 
 O   0.500000000000000   0.750000000000000   0.250000000000000 
 O   0.500000000000000   0.250000000000000   0.250000000000000 
 O   0.000000000000000   0.750000000000000   0.750000000000000 
 O   0.000000000000000   0.250000000000000   0.750000000000000 
 O   0.500000000000000   0.750000000000000   0.750000000000000 
 O   0.500000000000000   0.250000000000000   0.750000000000000 
 O   0.000000000000000   0.750000000000000   0.250000000000000

K_POINTS automatic
  $kpoints $kpoints $kpoints 0 0 0
EOF
        # Ejecutar el comando
        mpirun -np 4 pw.x < $input_file > $output_file

        # Extraer la energía total
        energia=$(grep '!' $output_file | awk '{print $5}')

        # Extraer el tiempo de ejecución
	tiempo=$(grep 'PWSCF' $output_file | tail -1 | awk -F ': ' '{print substr($0, index($0, ":") + 1, index($0, "CPU") - index($0, ":") - 1)}')


        # Extraer el número de iteraciones
        iteraciones=$(grep 'iteration #' $output_file | wc -l)

        # Guardar los resultados en el archivo .dat
        echo "$kpoints $energia $tiempo $iteraciones" >> $output_dat_file

        grep '!' $output_file

done



