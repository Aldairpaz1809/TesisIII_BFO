#!/bin/bash
# Script para cálculo SCF
name="nscf"
# Valores por defecto
ecutwfc=40       # Ry
kpoints="6 6 4 0 0 0"
base_dir="/home/aldair1809/Documentos/QE/4BFO/temp"
pseudo_dir="/home/aldair1809/Programas/QE/q-e-qe-7.3/pseudo"
pseudo_set="o_pbesol_v1.2.uspp.F.UPF bi_pbesol_v1.uspp.F.UPF fe_pbesol_v1.5.uspp.F.UPF"
U_hubbard=3.092  # Ry
n=4              # Número de cores


# Manejo de opciones
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
echo "Creando carpeta"
mkdir -p $base_dir/nscf
if [ $? -ne 0 ]; then
	echo "Error al crear carpetas"
	exit 1
fi
cp -r $base_dir/scf/* $base_dir/nscf
# Variables del archivo
name="nscf"
# Separar pseudopotenciales específicos
gdir_vals=(1 2 3)
nppstr_vals=(6 6 4)
kpoints_vals=("6 3 2" "3 6 2" "3 3 4")
pseudo_o=$(echo $pseudo_set | awk '{print $1}')
pseudo_bi=$(echo $pseudo_set | awk '{print $2}')
pseudo_fe=$(echo $pseudo_set | awk '{print $3}')

for gdir in "${gdir_vals[@]}"; do


input_file="${name}.bifeo3_$gdir.in"
output_file="${name}.bifeo3_$gdir.out"
nppstr=${nppstr_vals[$((gdir-1))]}
kpoints=${kpoints_vals[$((gdir-1))]}
cat > $input_file <<EOF
&CONTROL
   calculation  = 'nscf'
   outdir       = '$base_dir/nscf'
   prefix       = 'bifeo3'
   pseudo_dir   = '$pseudo_dir'
   restart_mode = 'from_scratch'
   verbosity    = 'high'
   lberry       = .true.
   gdir         = $gdir
   nppstr	= $nppstr
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
   occupations               = 'fixed'
   nosym                     = .true.
   starting_magnetization(3) = -0.8
   starting_magnetization(4) = 0.8
   lda_plus_U                = .true.
   Hubbard_U(3)              = $U_hubbard
   Hubbard_U(4)              = $U_hubbard
 /
 
 &ELECTRONS
   conv_thr         = 1e-7
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
  $kpoints 0 0 0
EOF
done

	echo "Ejecutando cálculo NSCF"
	mpirun -np $n pw.x < $input_file > $output_file
if [ $? -eq 0 ]; then
  echo 0  # Retorna 0 si todo está bien
fi
