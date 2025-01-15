import numpy as np
import matplotlib.pyplot as plt
path = ""
a = [-0.1, -0.08, -0.05, -0.02, 0.02, 0.05, 0.08, 0.1]
x0 = []
x = []
alpha_0 = []

for a_v in a:
    file_path = path + "datos_scf.bifeoA_H_0_alpha_" + str(a_v) + ".out.dat"
    
    try:
        with open(file_path, "r") as file_t:
            lines = file_t.readlines()  # Leer todas las líneas
            if len(lines) > 1:
                t = lines[1]   # Segunda línea
                t_f = lines[-1]  # Última línea

                # Buscar el símbolo '=' y extraer el número después de él
                if '=' in t and '=' in t_f:
                    value_str = t.split('=')[-1].strip().split()[0]
                    value_str_f = t_f.split('=')[-1].strip().split()[0]

                    try:
                        # Convertir los valores extraídos a float
                        value = float(value_str)
                        value_f = float(value_str_f)

                        x0.append(value)
                        x.append(value_f)
                        alpha_0.append(a_v)
                    except ValueError:
                        print(f"Error al convertir a float en el archivo: {file_path}")
            else:
                print(f"El archivo {file_path} no tiene suficientes líneas.")
    except FileNotFoundError:
        print(f"Archivo no encontrado: {file_path}")
#x0=np.array(x0)/6
#x=np.array(x)/6
# Graficar los resultados
f0=np.polynomial.polynomial.Polynomial.fit(alpha_0,x0,1)
y0=[f0(cx) for cx in alpha_0]
f=np.polynomial.polynomial.Polynomial.fit(alpha_0,x,1)
yf=[f(cx) for cx in alpha_0]
plt.scatter(alpha_0, x0, label=r'$x_0$',color="blue",marker='d')
plt.plot(alpha_0,y0,color="c")
plt.scatter(alpha_0,x,label=r'$x$',color="red",marker='o')
plt.plot(alpha_0,yf,color="orange")
plt.xlabel(r'$\alpha$ (eV)')
plt.ylabel('Número de ocupaciones')
plt.legend()
plt.show()
print(f0.convert().coef)  # Coeficientes del ajuste para x0
print(f.convert().coef)   # Coeficientes del ajuste para x
print(f"U = {1/(f0.convert().coef[1])-1/(f.convert().coef[1])}")

