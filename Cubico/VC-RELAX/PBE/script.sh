#!/bin/bash
name="geom_opt"
output_dat_file="results.dat"  # Archivo donde guardaremos los resultados

# Variables para modificar parámetros
pseudo_dir="/home/aldair1809/Programas/QE/q-e-qe-7.3/pseudo"
kpoints="2 2 2 0 0 0"
max_time=3600 # Una hora
# Lista de valores de ecutwfc a probar
ecutwfc=30

# Lista de pseudopotenciales a probar
pseudo_set="o_pbe_v1.2.uspp.F.UPF bi_pbe_v1.uspp.F.UPF fe_pbe_v1.5.uspp.F.UPF"


# Separar pseudopotenciales específicos
pseudo_o=$(echo $pseudo_set | awk '{print $1}')
pseudo_bi=$(echo $pseudo_set | awk '{print $2}')
pseudo_fe=$(echo $pseudo_set | awk '{print $3}')

# Iterar sobre los diferentes valores de ecutwfc


        # Definir nombre del archivo de entrada y salida
        input_file="${name}_bifeo3.in"
        output_file="${name}_bifeo3_2.out"

        # Crear el archivo de entrada modificado
        cat > $input_file << EOF
 &CONTROL
   calculation  = 'vc-relax'
   outdir       = '/home/aldair1809/Documentos/QE/4BFO/${name}_cubic'
   prefix       = 'bifeo3-relax'
   max_seconds  = $((max_time*10))
   pseudo_dir   = '$pseudo_dir'
   restart_mode = 'restart'
   etot_conv_thr = 1e-4
   forc_conv_thr = 1e-3
 /
 &SYSTEM
   degauss                   = 0.01
   ecutwfc                   = $ecutwfc
   ecutrho                   = $((4*ecutwfc))
   ibrav                     = 1
   a                         = 7.54
   nat                       = 40
   nbnd                      = 200
   nspin                     = 2
   ntyp                      = 4
   occupations               = 'tetrahedra'
   smearing                  = 'm-p'
   starting_magnetization(3) = -0.8
   starting_magnetization(4) = 0.8
   tot_magnetization         = 0.0
 /

 &ELECTRONS
   conv_thr         = 1e-7
   diagonalization  = "cg"
   electron_maxstep = 300
   mixing_beta      = 0.2
   mixing_mode      = "plain"
 /
 &ions
 /
 &cell
 cell_dofree        = "ibrav"
 press              = 0.0
 press_conv_thr     = 0.5
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
  $kpoints
EOF
        # Ejecutar el comando
        mpirun --use-hwthread-cpus -np 6 pw.x < $input_file > $output_file





