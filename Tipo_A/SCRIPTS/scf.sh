#!/bin/bash
# Script para cálculo SCF
name="scf"
# Valores por defecto
ecutwfc=40       # Ry
kpoints="3 3 2 0 0 0"
base_dir="/home/aldair1809/Documentos/QE/4BFO/temp"
pseudo_dir="/home/aldair1809/Programas/QE/q-e-qe-7.3/pseudo"
pseudo_set="o_pbe_v1.2.uspp.F.UPF bi_pbe_v1.uspp.F.UPF fe_pbe_v1.5.uspp.F.UPF"
U_hubbard=3.092  # Ry
n=4              # Número de cores

echo "Creando carpeta"
mkdir -p $base_dir/scf
if [ $? -ne 0 ]; then
	echo "Error al crear carpetas"
	exit 1
fi
# Manejo de opciones
while getopts "e:k:b:p:s:u:n:" opt; do
case $opt in
  e) ecutwfc="$OPTARG";;
  k) kpoints="$OPTARG";;
  b) base_dir="$OPTARG";;
  p) pseudo_dir="$OPTARG";;
  s) pseudo_set="$OPTARG";;
  u) U_hubbard="$OPTARG";;
  n) n="$OPTARG";;
  \?) echo "Opción inválida: -$OPTARG" ;;
esac

done

# Variables del archivo
name="scf"
# Separar pseudopotenciales específicos
pseudo_o=$(echo $pseudo_set | awk '{print $1}')
pseudo_bi=$(echo $pseudo_set | awk '{print $2}')
pseudo_fe=$(echo $pseudo_set | awk '{print $3}')

input_file="${name}.bifeo3.in"
output_file="${name}.bifeo3.out"

cat > $input_file <<EOF
&CONTROL
   calculation  = 'scf'
   outdir       = '$base_dir/scf'
   prefix       = 'bifeo3'
   pseudo_dir   = '$pseudo_dir'
   restart_mode = 'from_scratch'
   verbosity    = 'high'
 /
&SYSTEM
   degauss                   = 0.01
   ecutwfc                   = $ecutwfc
   ecutrho                   = $((ecutwfc*8))
   ibrav                     = 4
   celldm(1)                 = 10.45310187
   celldm(3)                 = 2.46741507
   nat                       = 30
   nspin                     = 2
   ntyp                      = 4
   occupations               = 'smearing'
   smearing                  = 'm-p'
   starting_magnetization(3) = -0.8
   starting_magnetization(4) = 0.8
   lda_plus_U                = .true.
   Hubbard_U(3)              = $U_hubbard
   Hubbard_U(4)              = $U_hubbard
 /
&ELECTRONS
   conv_thr         = 1.0d-7
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
Fe1          -0.0000000000       -0.0000000000        0.7770558675
Fe1           0.3333330000        0.6666670000        0.9486980231
Fe1           0.6666670000        0.3333330000        0.6074233709
Fe2           0.6666670000        0.3333330000        0.1074122376
Fe2          -0.0000000000       -0.0000000000        0.2770666593
Fe2           0.3333330000        0.6666670000        0.4487218049
Bi            0.6666670000        0.3333330000        0.8391173556
Bi            0.3333330000        0.6666670000        0.6761593051
Bi            0.3333330000        0.6666670000        0.1761341014
Bi           -0.0000000000       -0.0000000000        0.0045445543
Bi           -0.0000000000       -0.0000000000        0.5045485054
Bi            0.6666670000        0.3333330000        0.3390973735
O             0.0805536121        0.7641540780        0.8800022704
O             0.2358459220        0.3163985341        0.8800022704
O             0.6836014659        0.9194463879        0.8800022704
O             0.7442022079        0.6492358335        0.7128094568
O             0.3507641665        0.0949673743        0.7128094568
O             0.9050326257        0.2557977921        0.7128094568
O             0.7442113789        0.0949669281        0.2127997945
O             0.9050330719        0.6492454508        0.2127997945
O             0.3507545492        0.2557886211        0.2127997945
O             0.4155694309        0.9826579740        0.0458100536
O             0.0173420260        0.4329114569        0.0458100536
O             0.5670885431        0.5844305691        0.0458100536
O             0.4155546136        0.4328992159        0.5458325815
O             0.5671007841        0.9826553977        0.5458325815
O             0.0173446023        0.5844453864        0.5458325815
O             0.0805338269        0.3163939350        0.3800154571
O             0.6836060650        0.7641388918        0.3800154571
O             0.2358611082        0.9194661731        0.3800154571

K_POINTS automatic
  $kpoints
EOF

echo "Ejecutando cálculo SCF"
mpirun --use-hwthread-cpus -np $n pw.x < $input_file > $output_file
if [ $? -eq 0 ]; then
  echo 0  # Retorna 0 si todo está bien
fi
