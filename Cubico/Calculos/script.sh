#!/bin/bash
# Script de control

# Parámetros generales:
ecutwfc=35 # Ry
kpoints="3 3 3 0 0 0"  # kpoints para SCF
kpoints_nscf="4 4 2 0 0 0"  # kpoints para NSCF
pseudo_set="o_pbesol_v1.2.uspp.F.UPF bi_pbesol_v1.uspp.F.UPF fe_pbesol_v1.5.uspp.F.UPF"  # pseudo potenciales

# Directorios
base_dir="/home/aldair1809/Documentos/QE/4BFO/temp_cubic"
pseudo_dir="/home/aldair1809/Programas/QE/q-e-qe-7.3/pseudo"


# Cálculo de Hubbard (u_value)
 
U_hubbard=4.1  # Ry (valor por defecto)
n=4                   # Número de cores por defecto

# Funciones para los cálculos
scf() {
  local u_value=$1  # Recibe el valor de u_value como primer argumento
  local n=$2 # Recibe el valor de n como segundo argumento
  echo "Ejecutando cálculo SCF con U_hubbard=$u_value, ecutwfc=$ecutwfc y kpoints=$kpoints"
  
  # Llama al script scf.sh pasando los parámetros correspondientes
    chmod +x scf.sh
result=$(./scf.sh -e "${ecutwfc}" -k "${kpoints}" -b "$base_dir" -p "$pseudo_dir" -s "$pseudo_set" -u "$u_value" -n "$n")
  

}

charge_density() {
  local n=$1 # Recibe el valor de n como segundo argumento
  echo "Ejecutando cálculo de densidad de carga"
  chmod +x pp.sh
  result=$(./pp.sh  -b $base_dir -n $n)
}

nscf_bp() {
  local u_value=$1  # Recibe el valor de u_value como primer argumento
  local n=$2 # Recibe el valor de n como segundo argumento
  echo "Ejecutando cálculo NSCF con U_hubbard=$U_hubbard, ecutwfc=$ecutwfc y kpoints_nscf=$kpoints_nscf"
    chmod +x nscf.sh
result=$(./nscf.sh -e "${ecutwfc}" -k "${kpoints_nscf}" -b "$base_dir" -p "$pseudo_dir" -s "$pseudo_set" -u "$u_value" -n "$n")
}

p-dos() {
  local n=$1 # Recibe el valor de n como segundo argumento
  echo "Ejecutando cálculos de polarización de espin"
    chmod +x p-dos.sh
  result=$(./p-dos.sh  -b $base_dir -n $n)
}

bands() {
  local u_value=$1  # Recibe el valor de u_value como primer argumento
  local n=$2 # Recibe el valor de n como segundo argumento
  echo "Ejecutando cálculo de bandas con U_hubbard=$U_hubbard y ecutwfc=$ecutwfc"
    chmod +x bands.sh
result=$(./bands.sh -e "${ecutwfc}" -b "$base_dir" -p "$pseudo_dir" -s "$pseudo_set" -u "$u_value" -n "$n")
}

pp-bands() {
  local n=$1 # Recibe el valor de n como segundo argumento
  echo "Ejecutando cálculo de post procesamiento de bandas con U_hubbard=$U_hubbard y ecutwfc=$ecutwfc"
    chmod +x pp-bands.sh
  result=$(./pp-bands.sh  -b $base_dir -n $n)
}

# Función de ayuda
show_help() {
  echo "Uso: $0 -c [1,2,3,4,5,6] [-u U_hubbard] [-n num_cores]"
  echo
  echo "Opciones:"
  echo "  -c    Cálculos a ejecutar (1: SCF, 2: Densidad de carga(requiere scf), 3: NSCF(requiere scf), 4: P-DOS(requiere nscf), 5: Bandas(requiere scf), 6: Post-procesamiento de bandas(requiere Bandas))"
  echo "  -u    Valor de U_hubbard (si no se proporciona, se usa el valor por defecto de ${hubbard_defecto} Ry)"
  echo "  -n    Número de núcleos a utilizar (por defecto es $n)"
  echo "  -h    Muestra esta ayuda"
}

# Manejo de opciones
while getopts "c:u:n:h" opt; do
  case $opt in
    c)
      # Separa los cálculos por espacios o comas
      IFS=', ' read -r -a calculos <<< "$OPTARG"
      ;;
    u)
      # Si no se proporciona un valor, usar el valor por defecto de U_hubbard
      if [ -n "$OPTARG" ]; then
        U_hubbard=$OPTARG  # Ry (valor por defecto)
      fi
      ;;
    n)
      # Si se proporciona un valor, úsalo; de lo contrario, usar el valor predeterminado
      if [ -n "$OPTARG" ]; then
        n="$OPTARG"
      fi
      ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      echo "Opción inválida: -$OPTARG"
      show_help
      exit 1
      ;;
  esac
done

# Ejecutar los cálculos indicados en la opción -c
if [ -n "${calculos[*]}" ]; then
#Crear carpeta base
echo "Creando carpetas"
mkdir -p $base_dir
if [ $? -ne 0 ]; then
echo "Error al crear el directorio base"
exit 1
fi
  for calculo in "${calculos[@]}"; do
    case $calculo in
      1)
        scf $U_hubbard $n

        ;;
      2)
        charge_density $n # No se pasa U_hubbard, ya que no se usa en esta función

        ;; 
      3)
        nscf_bp $U_hubbard $n

        ;;
      4)
        p-dos $n # No se pasa U_hubbard, ya que no se usa en esta función

        ;;
      5)
        bands $U_hubbard $n

        ;;
      6)
        pp-bands  $n

        ;;
      *)
        echo "Cálculo no válido: $calculo"
        ;;
    esac
  done
else
  echo "No se especificaron cálculos para ejecutar. Usa la opción -h para más información."
fi

