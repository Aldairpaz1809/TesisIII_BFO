import matplotlib.pyplot as plt

# Datos (puedes cargar estos datos desde un archivo si lo prefieres)
ecutwfc = [10, 12, 15, 18, 20, 25, 30, 35, 40]  # Valores de ecutwfc comunes

# Energías para PBESOL y PBE (en Ry)
energy_pbesol = [
    -2971.94339933, -3070.98894222, -3141.17566822, -3171.53521545,
    -3180.09566410, -3189.24979755, -3190.99774580, -3191.23793334, -3191.26520092
]

energy_pbe = [
    -2976.23881150, -3075.21973315, -3145.25580913, -3175.45574621,
    -3183.98278403, -3193.08700718, -3194.82719187, -3195.06440186, -3195.09042044
]

# Tiempos (convertidos a segundos)
time_pbesol = [2*60+38.84, 3*60+28.99, 6*60+55.30, 6*60+50.94, 7*60+44.85, 9*60+17.39, 9*60+16.52, 12*60+24.78, 14*60+32.43]
time_pbe = [2*60+27.11, 3*60+38.96, 7*60+12.80, 7*60+21.98, 8*60+33.08, 7*60+17.35, 10*60+8.41, 12*60+29.37, 15*60+51.40]

# Iteraciones
iterations_pbesol = [17, 18, 27, 20, 20, 16, 12, 13, 12]
iterations_pbe = [19, 20, 27, 21, 22, 14, 13, 13, 13]

# Crear figura con subplots
fig, axs = plt.subplots(3, 1, figsize=(10, 15))

# Graficar Energía Total
axs[0].plot(ecutwfc, energy_pbesol, label='PBESOL', marker='o', linestyle='-', color='b')
axs[0].plot(ecutwfc, energy_pbe, label='PBE', marker='s', linestyle='--', color='r')
axs[0].set_xlabel('Ecutwfc (Ry)')
axs[0].set_ylabel('Energía Total (Ry)')
axs[0].set_title('Comparación de Energía Total')
axs[0].legend()
axs[0].grid(True)

# Graficar Tiempo Total
axs[1].plot(ecutwfc, time_pbesol, label='PBESOL', marker='o', linestyle='-', color='b')
axs[1].plot(ecutwfc, time_pbe, label='PBE', marker='s', linestyle='--', color='r')
axs[1].set_xlabel('Ecutwfc (Ry)')
axs[1].set_ylabel('Tiempo Total (s)')
axs[1].set_title('Comparación de Tiempo Total')
axs[1].legend()
axs[1].grid(True)

# Graficar Número de Iteraciones
axs[2].plot(ecutwfc, iterations_pbesol, label='PBESOL', marker='o', linestyle='-', color='b')
axs[2].plot(ecutwfc, iterations_pbe, label='PBE', marker='s', linestyle='--', color='r')
axs[2].set_xlabel('Ecutwfc (Ry)')
axs[2].set_ylabel('Número de Iteraciones')
axs[2].set_title('Comparación de Iteraciones')
axs[2].legend()
axs[2].grid(True)

# Ajustar espaciado entre subplots
plt.tight_layout()

# Mostrar la gráfica
plt.show()

