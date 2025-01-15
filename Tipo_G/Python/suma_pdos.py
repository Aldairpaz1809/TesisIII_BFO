# Suma de densidades de estados (DOS) parciales
# --------------------------------- #

import sys
import os
import fnmatch

# Variables por defecto
pwout = ""
selat = "*"
min_x, max_x = -10, 3
min_y, max_y = "", ""
output_file_name = "suma_pdos"
prt = "yes"

# Lee las opciones de la línea de comandos
if len(sys.argv) > 1:
    for i in sys.argv:
        if i.startswith('-'):
            option = i.split('-')[1]
            if option == "o":
                pwout = sys.argv[sys.argv.index('-o') + 1]
            elif option == "s":
                selat = sys.argv[sys.argv.index('-s') + 1]
            elif option == "p":
                prt = "yes"
                if len(sys.argv) > sys.argv.index('-p') + 1 and sys.argv[sys.argv.index('-p') + 1] != "-":
                    dos_out_name = sys.argv[sys.argv.index('-p') + 1]
            elif option == "xr":
                min_x, max_x = float(sys.argv[sys.argv.index('-xr') + 1]), float(sys.argv[sys.argv.index('-xr') + 2])
            elif option == "yr":
                min_y, max_y = float(sys.argv[sys.argv.index('-yr') + 1]), float(sys.argv[sys.argv.index('-yr') + 2])
            elif option == "h":
                ayuda = """
                -o ==> Archivo de salida del SCF, de donde se obtiene la energía de Fermi.
                -s ==> Selecciona los nombres de los archivos que contienen los DOS parciales.
                Ejm: "*(Y)*(d)" selecciona los orbitales d de los ytrios.
                Por defecto selecciona todos los archivos dentro de la carpeta, puede dar error.
                -p ==> Imprime el resultado a un archivo y le da el nombre. (por defecto es suma_pdos_up.dat y suma_pdos_down.dat)
                -xr ==> Define el mínimo y máximo del eje x.
                -yr ==> Define el mínimo y máximo del eje y.
                -h ==> Imprime esta ayuda.
                """
                print(ayuda)
                sys.exit()

# Obtiene la energía de Fermi desde el archivo de salida del SCF
if pwout != "":
    try:
        fermi = float(os.popen("grep -a 'the Fermi energy is' " + pwout).read().split()[4])
        print("Energía de Fermi =", fermi, "a.u.")
    except:
        print("PELIGRO!! : No se encontró energía de Fermi. Se usa 0 eV como reemplazo.")
        fermi = 0
else:
    print("PELIGRO!! : No se encontró archivo de salida del SCF.")
    fermi = 0

# Encuentra todos los archivos DOS, pasados con la opción -s para agregarlos
dosfiles = [dfile for dfile in os.listdir('.') if fnmatch.fnmatch(dfile, selat)]
if len(dosfiles) == 0:
    print("ERROR!! : No se hallaron los archivos.")
    sys.exit()

# Imprime la lista de archivos DOS hallados y que se usarán
for dosfile in dosfiles:
    print(dosfile, "\n")
print("")

# Suma sobre todos los archivos
mat = []
for dosfile in dosfiles:
    mati = []
    for line in open(dosfile, 'r'):
        if len(line) > 10 and line.split()[0] != "#":
            mati.append([float(line.split()[0]), float(line.split()[1]), float(line.split()[2])])
    if not mat:
        mat = mati[:]
    else:
        for j in range(len(mati)):
            mat[j] = [mat[j][0], mat[j][1] + mati[j][1], mat[j][2] + mati[j][2]]

# Obtener el directorio actual
actu = os.getcwd()
print(actu)
sali = actu+"/GRAFICAS/"

# Abre los archivos de salida
if prt == "yes":
    out_up = open(sali + dos_out_name + "_up.dat", "w")
    out_down = open(sali + dos_out_name + "_down.dat", "w")
else:
    out_up = open(sali + output_file_name + "_up.dat", "w")
    out_down = open(sali + output_file_name + "_down.dat", "w")

x, y1, y2 = [], [], []
for i in mat:
    x.append(i[0] - fermi)
    y1.append(i[1])
    y2.append(-i[2])
    out_up.write(f"{i[0] - fermi} {i[1]}\n")
    out_down.write(f"{i[0] - fermi} {-i[2]}\n")

# Cierra los archivos de salida
out_down.close()
out_up.close()
print(sali + dos_out_name + "_up.dat")
