import numpy as np
import matplotlib.pyplot as plt

# Lectura de datos
datos = np.loadtxt("datos.dat")

# Formateo de datos
energia=datos[:-1]
iteraciones = np.arange(1,len(energia)+1,1)

# Gráfica
plt.plot(iteraciones,energia,"-o")
plt.xlabel("Iteración")
plt.ylabel("Energía total (Ry)")
plt.title("Optimización Estructural del "+ r"$BiFeO_3$")
plt.grid()
plt.savefig("relax_convergence.png")
plt.show()
