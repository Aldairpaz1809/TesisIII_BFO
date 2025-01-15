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
   celldm(1)                 = 10.43573394
   celldm(3)                 = 2.45853299
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
Fe2           0.0000000000        0.0000000000        0.7772495689
Fe1           0.3333330000        0.6666670000        0.9438955412
Fe1           0.6666670000        0.3333330000        0.6106147604
Fe2           0.6666670000        0.3333330000        0.1106303246
Fe1          -0.0000000000       -0.0000000000        0.2772682519
Fe2           0.3333330000        0.6666670000        0.4438932836
Bi            0.6666670000        0.3333330000        0.8404339885
Bi            0.3333330000        0.6666670000        0.6735998860
Bi            0.3333330000        0.6666670000        0.1735970766
Bi           -0.0000000000       -0.0000000000        0.0070036121
Bi           -0.0000000000       -0.0000000000        0.5070111491
Bi            0.6666670000        0.3333330000        0.3404372992
O             0.0832213918        0.7676167372        0.8795660106
O             0.2323832628        0.3156036547        0.8795660106
O             0.6843963453        0.9167786082        0.8795660106
O             0.7498970473        0.6489280827        0.7129225878
O             0.3510719173        0.1009699647        0.7129225878
O             0.8990300353        0.2501029527        0.7129225878
O             0.7498872201        0.1009626346        0.2129316419
O             0.8990373654        0.6489255855        0.2129316419
O             0.3510744145        0.2501127799        0.2129316419
O             0.4166234887        0.9823791204        0.0461954964
O             0.0176208796        0.4342443683        0.0461954964
O             0.5657556317        0.5833765113        0.0461954964
O             0.4166179309        0.4342516508        0.5461937639
O             0.5657483492        0.9823662801        0.5461937639
O             0.0176337199        0.5833820691        0.5461937639
O             0.0832079553        0.3155927144        0.3795749188
O             0.6844072856        0.7676142409        0.3795749188
O             0.2323857591        0.9167920447        0.3795749188

K_POINTS automatic
  $kpoints
EOF

echo "Ejecutando cálculo SCF"
mpirun --use-hwthread-cpus -np $n pw.x < $input_file > $output_file
if [ $? -eq 0 ]; then
  echo 0  # Retorna 0 si todo está bien
fi
