import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import AutoMinorLocator

def read_dos_file(file_path):
    """Reads a DOS .dat file and returns energy and DOS."""
    data = np.loadtxt(file_path)
    energy = data[:, 0]
    dos = data[:, 1]
    return energy, dos

# Crear diccionario vacío para almacenar la DOS
pdos = {'Bi': {}, 'Fe': {}, 'O': {}}

# Elementos y orbitales (O no tiene orbital d)
elements = {'Bi': ['s', 'p', 'd'], 'Fe': ['s', 'p', 'd'], 'O': ['s', 'p']}

# Inicializamos las energías (asumimos que todas son iguales)
energy = None

# Leer los archivos y almacenar en el diccionario pdos
for element, orbitals in elements.items():
    pdos[element] = {}
    
    for orbital in orbitals:
        # Archivos para cada orbital y spin (up y down)
        file_up = f'{element}_DOS_{orbital}_up.dat'
        file_down = f'{element}_DOS_{orbital}_down.dat'
        
        # Leer los archivos de orbitales
        energy_up, dos_up = read_dos_file(file_up)
        energy_down, dos_down = read_dos_file(file_down)
        
        # Asignamos las energías (se asume que son iguales para todos)
        if energy is None:
            energy = energy_up

        # Guardar en el diccionario pdos
        pdos[element][orbital] = {'up': dos_up, 'down': dos_down}
    
    # Leer los archivos totales (sin orbital)
    file_total_up = f'{element}_DOS_up.dat'
    file_total_down = f'{element}_DOS_down.dat'
    
    energy_total_up, dos_total_up = read_dos_file(file_total_up)
    energy_total_down, dos_total_down = read_dos_file(file_total_down)
    
    # Guardar los totales en el diccionario pdos
    pdos[element]['total'] = {'up': dos_total_up, 'down': dos_total_down}

# Sumar las contribuciones de cada átomo para obtener la DOS total de la molécula
total_dos_up = np.zeros_like(energy)
total_dos_down = np.zeros_like(energy)

for element in pdos:
    total_dos_up += pdos[element]['total']['up']
    total_dos_down += pdos[element]['total']['down']

# Graficar el total de la molécula
plt.figure(figsize=(6, 6))
plt.plot(energy, total_dos_up, label='Total', color='black')
plt.plot(energy, total_dos_down, label='Total', color='black', linestyle='--')
for atomo, color in zip(["Fe","O","Bi"],["r","b","g"]):
    plt.plot(energy, pdos[atomo]["total"]["up"],label=f"{atomo}",color=color)
    plt.plot(energy, pdos[atomo]["total"]["down"],linestyle="--",color=color)
plt.axhline(0, color='black', linewidth=0.5)
plt.xlabel('Energy (eV)')
plt.ylabel('DOS (states/eV)')
plt.title('Total Density of States (DOS) for Molecule')
plt.legend()
plt.tight_layout()
plt.xlim((-8,5))
plt.gca().xaxis.set_minor_locator(AutoMinorLocator(5))  # 5 divisiones menores entre cada tick principal del eje x
plt.gca().yaxis.set_minor_locator(AutoMinorLocator(5))  # 4 divisiones menores entre cada tick principal del eje y
plt.axvline(x=0, color='black', linestyle='--', linewidth=1.5)  # Línea vertical
plt.savefig("Bifeo3.png")
plt.show()

###############Fe#######################
plt.figure(figsize=(6, 6))
for orbital,color in zip(["s","p","d"],["r","orange","b"]):
    plt.plot(energy, pdos["Fe"][orbital]["up"],label=f"Fe-{orbital}",color=color)
    plt.plot(energy, pdos["Fe"][orbital]["down"],linestyle="--",color=color)

plt.axhline(0, color='black', linewidth=0.5)
plt.xlabel('Energy (eV)')
plt.ylabel('DOS (states/eV)')
plt.title('Total Density of States (DOS) for Molecule')
plt.legend()
plt.tight_layout()
plt.xlim((-8,5))
plt.xticks(fontsize=12)  # Cambiar el tamaño, peso y rotación de los ticks en el eje x
plt.yticks(fontsize=12)  # Cambiar el tamaño y peso de los ticks en el eje y
plt.gca().xaxis.set_minor_locator(AutoMinorLocator(5))  # 5 divisiones menores entre cada tick principal del eje x
plt.gca().yaxis.set_minor_locator(AutoMinorLocator(5))  # 4 divisiones menores entre cada tick principal del eje y
plt.axvline(x=0, color='black', linestyle='--', linewidth=1.5)  # Línea vertical
plt.savefig("Fe.png")

plt.show()
##############O####################
plt.figure(figsize=(6, 6))
for orbital,color in zip(["s","p"],["r","b"]):
    plt.plot(energy, pdos["O"][orbital]["up"],label=f"O-{orbital}",color=color)
    plt.plot(energy, pdos["O"][orbital]["down"],linestyle="--",color=color)

plt.axhline(0, color='black', linewidth=0.5)
plt.xlabel('Energy (eV)')
plt.ylabel('DOS (states/eV)')
plt.title('Total Density of States (DOS) for Molecule')
plt.legend()
plt.tight_layout()
plt.xlim((-8,5))
plt.xticks(fontsize=12)  # Cambiar el tamaño, peso y rotación de los ticks en el eje x
plt.yticks(fontsize=12)  # Cambiar el tamaño y peso de los ticks en el eje y
plt.gca().xaxis.set_minor_locator(AutoMinorLocator(5))  # 5 divisiones menores entre cada tick principal del eje x
plt.gca().yaxis.set_minor_locator(AutoMinorLocator(5))  # 4 divisiones menores entre cada tick principal del eje y
plt.axvline(x=0, color='black', linestyle='--', linewidth=1.5)  # Línea vertical
plt.savefig("O.png")

plt.show()
###############Bi##################
plt.figure(figsize=(6, 6))
for orbital,color in zip(["s","p","d"],["r","orange","b"]):
    plt.plot(energy, pdos["Bi"][orbital]["up"],label=f"Bi-{orbital}",color=color)
    plt.plot(energy, pdos["Bi"][orbital]["down"],linestyle="--",color=color)

plt.axhline(0, color='black', linewidth=0.5)
plt.xlabel('Energy (eV)')
plt.ylabel('DOS (states/eV)')
plt.title('Total Density of States (DOS) for Molecule')
plt.legend()
plt.tight_layout()
plt.xlim((-8,5))
plt.xticks(fontsize=12)  # Cambiar el tamaño, peso y rotación de los ticks en el eje x
plt.yticks(fontsize=12)  # Cambiar el tamaño y peso de los ticks en el eje y
plt.gca().xaxis.set_minor_locator(AutoMinorLocator(5))  # 5 divisiones menores entre cada tick principal del eje x
plt.gca().yaxis.set_minor_locator(AutoMinorLocator(5))  # 4 divisiones menores entre cada tick principal del eje y
plt.axvline(x=0, color='black', linestyle='--', linewidth=1.5)  # Línea vertical
plt.savefig("Bi.png")
plt.show()