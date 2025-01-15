# -*- coding: utf-8 -*-
"""
Created on Fri Oct  4 07:06:08 2024

@author: Aldair
"""

import numpy as np
import matplotlib.pyplot as plt
import os
def hubbard(nombre, r="n"):
    datos = np.loadtxt(nombre)
    alpha_0 = datos[:, 0]
    x0 = datos[:, 1] / 6
    x = datos[:, 2] / 6
    
    # Ajuste para x0 y x con matriz de covarianza
    coef_x0, cov_x0 = np.polyfit(alpha_0, x0, 1, cov=True)
    coef_x, cov_x = np.polyfit(alpha_0, x, 1, cov=True)
    
    # Pendientes y errores
    x0_a = coef_x0[0]
    x0_b = coef_x0[1]
    x_a = coef_x[0]
    x_b = coef_x[1]
    sigma_x0_a = np.sqrt(cov_x0[0, 0])  # Error en la pendiente de x0
    sigma_x_a = np.sqrt(cov_x[0, 0])    # Error en la pendiente de x
    
    # Cálculo de U y su error
    U = 1 / x0_a - 1 / x_a
    sigma_U = np.sqrt(((-1 / x0_a**2) * sigma_x0_a)**2 + ((1 / x_a**2) * sigma_x_a)**2)

    # Graficar los resultados
    f0 = np.polynomial.polynomial.Polynomial.fit(alpha_0, x0, 1)
    y0 = [f0(cx) for cx in alpha_0]
    f = np.polynomial.polynomial.Polynomial.fit(alpha_0, x, 1)
    yf = [f(cx) for cx in alpha_0]
    
    plt.scatter(alpha_0, x0, label=r'$x_0$', color="blue", marker='d')
    plt.plot(alpha_0, y0, color="c")
    plt.scatter(alpha_0, x, label=r'$x$', color="red", marker='o')
    plt.plot(alpha_0, yf, color="orange")
    
    plt.text(0.5 * (alpha_0[-1] + alpha_0[0]) - 0.04, 
             0.5 * (x0[-1] + x0[0]) + 0.3 * abs(x0[-1] - x0[0]), 
             r"$\overline{N}_0$" + f"={x0_a:.3f}" + r"$\alpha$ + " + f"{x0_b:.3f}", color="blue")
    
    plt.text(0.5 * (alpha_0[-1] + alpha_0[0]) - 0.06, 
             0.5 * (x[-1] + x[0]) - 0.2 * abs(x[-1] - x[0]), 
             r"$\overline{N}$" + f"={x_a:.3f}" + r"$\alpha$ + " + f"{x_b:.3f}", color="red")
    
    plt.xlabel(r'$\alpha$ (eV)')
    plt.ylabel('Número de ocupaciones promedio')
    plt.legend()
    plt.grid()
    
    plt.savefig(f"{nombre}.png")
    if r == "s":
        plt.show()
    else:
        plt.close()
    
    print(f"U = {U} ± {sigma_U}")
    return U, sigma_U
nombres=os.listdir()
U=list()
archivos=list()
results_file="U_hubbard.dat"
s=input("Plotear? (s/n): \n")
for nombre in nombres:
	if os.path.splitext(nombre)[1] == ".dat" and nombre != results_file:
		try:
			u,_=hubbard(nombre,s)
			U.append(u)
			archivos.append(nombre)
		except:
			print(f"{nombre}: Archivo vacio")
with open(results_file, "w") as documento:
    documento.write("#Data_Set\tU_hubbard_value\n")
    for u, a in zip(U, archivos):
        # Extraer parte del nombre que contiene el valor (se asume que está en la posición -6:-4)
        try:
            a_val = float(a[-6:-4])  # Convertir esa parte en un número flotante
        except ValueError:
            print(f"Error procesando el archivo {a}: valor incorrecto en el nombre")
            continue
        
        documento.write(f"{a_val}\t{u}\n")
datos=np.loadtxt(results_file)
i=np.argsort(datos[:,0])
datos=datos[i]
ecutwfc,u=datos[0:,0],datos[0:,1]
plt.plot(ecutwfc,u,"-d",color=(0.5,0.5,1),linewidth=1,label="Kpoint_grid : 2x2x1")
plt.xlabel("Energía de corte (Ry)")
plt.ylabel("Constante de Hubbard (Ry)")
plt.legend()
plt.grid()
plt.savefig("hubbard_convergence.png")
plt.show()
print(u)

