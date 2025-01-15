#!/bin/bash
name="lr" #linear response
base_dir="/home/aldair1809/Documentos/QE/4BFO/hubbard_pbe_mp"
# Variables para modificar parámetros
pseudo_dir="/home/aldair1809/Programas/QE/q-e-qe-7.3/pseudo"
kpoints="2 2 1 0 0 0"

# Lista de valores de ecutwfc a probar
ecutwfc=35
U_hubbard_set=(0)
for U_hubbard in ${U_hubbard_set[@]}; do
echo "U_hubbard = $U_hubbard"
output_dat_file="resultados_${U_hubbard}.dat"  # Archivo donde guardaremos los resultados
# Lista de pseudopotenciales a probar
pseudo_set="o_pbe_v1.2.uspp.F.UPF bi_pbe_v1.uspp.F.UPF fe_pbe_v1.5.uspp.F.UPF"

# Separar pseudopotenciales específicos
pseudo_o=$(echo $pseudo_set | awk '{print $1}')
pseudo_bi=$(echo $pseudo_set | awk '{print $2}')
pseudo_fe=$(echo $pseudo_set | awk '{print $3}')

# Valores para el cálculo de U de Hubbard

alpha_hubbard_values=(-0.08 -0.05 -0.02 0.02 0.05 0.08)
alpha_hubbard_0=1.0e-8

# Cálculo del valor de referencia
input_file="${name}.bifeo3.alpha0.in"
output_file="${name}.bifeo3.alpha0.out"
mkdir -p $base_dir
mkdir -p $base_dir/alpha0
cat > $input_file <<EOF
&CONTROL
   calculation  = 'scf'
   outdir       = '$base_dir/alpha0'
   prefix       = 'bifeo3-Uhubbard'
   pseudo_dir   = '$pseudo_dir'
   restart_mode = 'from_scratch'
   verbosity    = 'high'
 /

 &SYSTEM
   degauss                   = 0.01
   ecutwfc                   = $ecutwfc
   ibrav                     = 4
   celldm(1)                 = 10.45310187
   celldm(3)                 = 2.46741507
   nat                       = 30
   nbnd                      = 200
   nspin                     = 2
   ntyp                      = 4
   occupations               = 'smearing'
   smearing                  = 'm-p'
   starting_magnetization(3) = -0.8
   starting_magnetization(4) = 0.8
   lda_plus_U                = .true.
   Hubbard_U(3)              = $U_hubbard
   Hubbard_U(4)              = $U_hubbard
   Hubbard_alpha(3)          = $alpha_hubbard_0
   Hubbard_alpha(4)          = $alpha_hubbard_0
 /

 &ELECTRONS
   conv_thr         = 1e-5
   diagonalization  = "cg"
   electron_maxstep = 300
   mixing_beta      = 0.4
   mixing_mode      = "plain"
   startingpot      = 'random'
   diago_thr_init   = 1D-2
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
echo "Alpha = 0"
mpirun -np 4 pw.x < $input_file > $output_file

# Iniciamos el archivo de resultados
echo "#alpha N_segunda_iteracion N_ultima_iteracion" > $output_dat_file


# Iterar sobre los diferentes valores de alpha_hubbard
for alpha_hubbard in "${alpha_hubbard_values[@]}"; do

    mkdir -p ${base_dir}/${name}_$alpha_hubbard


    # Copiar el archivo save para aplicar la perturbación
    cp -r ${base_dir}/alpha0/* ${base_dir}/${name}_${alpha_hubbard}
done
for alpha_hubbard in "${alpha_hubbard_values[@]}"; do
    # Definir nombre del archivo de entrada y salida
    input_file="${name}_bifeo3_${alpha_hubbard}.in"
    output_file="${name}_bifeo3_${alpha_hubbard}.out"
    # Crear el archivo de entrada modificado
    cat > $input_file << EOF
 &CONTROL
   calculation  = 'scf'
   outdir       = '${base_dir}/${name}_$alpha_hubbard/'
   prefix       = 'bifeo3-Uhubbard'
   pseudo_dir   = '$pseudo_dir'
   restart_mode = 'restart'
   verbosity    = 'high'
 /

 &SYSTEM
   degauss                   = 0.01
   ecutwfc                   = $ecutwfc
   ibrav                     = 4
   celldm(1)                 = 10.45310187
   celldm(3)                 = 2.46741507
   nat                       = 30
   nbnd                      = 200
   nspin                     = 2
   ntyp                      = 4
   occupations               = 'smearing'
   smearing                  = 'm-p'
   starting_magnetization(3) = -0.8
   starting_magnetization(4) = 0.8
   lda_plus_U                = .true.
   Hubbard_U(3)              = $U_hubbard
   Hubbard_U(4)              = $U_hubbard
   Hubbard_alpha(3)          = $alpha_hubbard
   Hubbard_alpha(4)          = $alpha_hubbard
 /

 &ELECTRONS
   conv_thr         = 1e-7
   diagonalization  = "cg"
   electron_maxstep = 300
   mixing_beta      = 0.4
   mixing_mode      = "plain"
   startingpot      = 'file'
   diago_thr_init   = 1D-9
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
echo "Alfa = ${alpha_hubbard}"
    # Ejecutar el cálculo
    mpirun -np 4 pw.x < $input_file > $output_file
    if [[ -f $output_file ]]; then
        # Extraer el número de ocupaciones +U de las iteraciones
        # Guardar la segunda ocurrencia y la última ocurrencia
        N_segunda_iteracion=$(grep "N of occupied +U levels =" $output_file | sed -n '2p' | awk '{print $7}')
        N_ultima_iteracion=$(grep "N of occupied +U levels =" $output_file | tail -1 | awk '{print $7}')
        
        # Verificar si se han encontrado los valores
        if [[ -z "$N_segunda_iteracion" ]]; then
            N_segunda_iteracion="N/A"  # Si no se encuentra, marcarlo como "N/A"
        fi
        if [[ -z "$N_ultima_iteracion" ]]; then
            N_ultima_iteracion="N/A"  # Si no se encuentra, marcarlo como "N/A"
        fi
        
        # Guardar en el archivo de resultados
        echo "$alpha_hubbard $N_segunda_iteracion $N_ultima_iteracion" >> $output_dat_file
    else
        echo "Archivo $output_file no encontrado. Saltando."
    fi
done
done
done
