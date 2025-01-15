#!/bin/bash
name="geom_opt"
output_dat_file="results.dat"  # Archivo donde guardaremos los resultados

# Variables para modificar parámetros
pseudo_dir="/home/aldair1809/Programas/QE/q-e-qe-7.3/pseudo"
kpoints="3 3 2 0 0 0"

# Lista de valores de ecutwfc a probar
ecutwfc=30
ecutrho=240
# Lista de pseudopotenciales a probar
pseudo_set="o_pbe_v1.2.uspp.F.UPF bi_pbe_v1.uspp.F.UPF fe_pbe_v1.5.uspp.F.UPF"


# Separar pseudopotenciales específicos
pseudo_o=$(echo $pseudo_set | awk '{print $1}')
pseudo_bi=$(echo $pseudo_set | awk '{print $2}')
pseudo_fe=$(echo $pseudo_set | awk '{print $3}')

# Iterar sobre los diferentes valores de ecutwfc


        # Definir nombre del archivo de entrada y salida
        input_file="${name}_bifeo3.in"
        output_file="${name}_bifeo3.out"

        # Crear el archivo de entrada modificado
        cat > $input_file << EOF
 &CONTROL
   calculation  = 'vc-relax'
   max_seconds  = 18000
   outdir       = '/home/aldair1809/Documentos/QE/${name}_temp'
   prefix       = 'bifeo3-relax'
   pseudo_dir   = '$pseudo_dir'
   restart_mode = 'restart'
   verbosity    = 'high'
   etot_conv_thr = 1e-4
   forc_conv_thr = 1e-3
 /
 &SYSTEM
   degauss                   = 0.01
   ecutwfc                   = $ecutwfc
   ecutrho                   = $ecutrho
   ibrav                     = 4
   a                         = 5.61559664
   c                         = 14.08162803
   nat                       = 30
   nbnd                      = 200
   nspin                     = 2
   ntyp                      = 4
   occupations               = 'smearing'
   smearing                  = 'm-p'
   starting_magnetization(3) = 0.8
   starting_magnetization(4) = -0.8
   tot_magnetization         = 0.0
 /

 &ELECTRONS
   conv_thr         = 1.0000000000e-5
   diagonalization  = "cg"
   electron_maxstep = 300
   mixing_beta      = 0.2
   mixing_mode      = "plain"
   startingpot      = 'file'
   startingwfc      = "file"
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
  Fe2     -0.000000000000  -0.000000000000   0.776765227400
  Fe1      0.333333000000   0.666667000000   0.946305821900
  Fe1      0.666667000000   0.333333000000   0.609115171000
  Fe2      0.666667000000   0.333333000000   0.109099121600
  Fe1      0.000000000000   0.000000000000   0.276775267000
  Fe2      0.333333000000   0.666667000000   0.446292071700
  Bi       0.666667000000   0.333333000000   0.835211655500
  Bi       0.333333000000   0.666667000000   0.669750761600
  Bi       0.333333000000   0.666667000000   0.169719876400
  Bi       0.000000000000   0.000000000000   0.000113047200
  Bi      -0.000000000000  -0.000000000000   0.500130805700
  Bi       0.666667000000   0.333333000000   0.335190950500
  O        0.067685598300   0.756551964700   0.882021196800
  O        0.243448035300   0.311132633600   0.882021196800
  O        0.688867366400   0.932314401700   0.882021196800
  O        0.731475025000   0.645449343200   0.715131215600
  O        0.354550656800   0.086026681800   0.715131215600
  O        0.913973318200   0.268524975000   0.715131215600
  O        0.731488370800   0.086028171500   0.215112456300
  O        0.913971828500   0.645461199300   0.215112456300
  O        0.354538800700   0.268511629200   0.215112456300
  O        0.407464854700   0.979531709300   0.046730853900
  O        0.020468290700   0.427933145400   0.046730853900
  O        0.572066854600   0.592535145300   0.046730853900
  O        0.407447769500   0.427924616900   0.546749920400
  O        0.572075383100   0.979523152600   0.546749920400
  O        0.020476847400   0.592552230500   0.546749920400
  O        0.067677550000   0.311129159100   0.382027097900
  O        0.688870840900   0.756547390900   0.382027097900
  O        0.243452609100   0.932322450000   0.382027097900

K_POINTS automatic
  $kpoints
EOF
        # Ejecutar el comando
        mpirun --use-hwthread-cpus -np 6 pw.x < $input_file > $output_file





