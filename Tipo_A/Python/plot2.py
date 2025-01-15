import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rcParams
file="../SCF-ecut-kpoint_convergence/PBE/ECUTWFC/results.dat"
rcParams['figure.figsize'] = 10, 5
data=np.loadtxt(file)
#print(data)
ecut=data[:,0]
etot=data[:,1]


x0=ecut[4:7]
y0=etot[4:7]


fig,ax=plt.subplots()
ax.plot(ecut,etot,"-o")
ax.set_xlabel("Energy cutoff (Ry)")
ax.set_ylabel("Total energy (Ry)")

# Zoom

zm=ax.inset_axes([0.4,0.5,0.5,0.5]) # [x0,y0,width,height]
zm.plot(x0,y0,"-o",lw=1)
zm.set_xticks(x0)
zm.set_yticks(y0,labels=np.round(y0,decimals=3))
zm.grid()
zm.plot([x0[1], x0[1]], [y0[0], y0[1]], color="black", lw=2)  # Line between two points
zm.annotate(r"$\Delta E \approx 0.01 \, Ry$", xy=((x0[1]) , (y0[0] + y0[1]) / 2), xytext=(x0[1] + 1, y0[1] + 0.005),arrowprops=dict(facecolor='black', shrink=0.05))
ax.indicate_inset_zoom(zm,edgecolor='black',lw=7)
#plt.title(r"Ecut convergence for $BiFeO_3$ type G")
ax.grid()
plt.savefig("convergence_ecut_pbe.png")
plt.show()



file="../SCF-ecut-kpoint_convergence/PBE/KPOINTS/results.dat"
data2=np.loadtxt(file)
#print(data)
kpoints=data2[:,0]
etot=data2[:,1]
x0=kpoints[2:5]
y0=etot[2:5]

fig,ax=plt.subplots()

ax.plot(kpoints,etot,"-o")
ax.set_xticks(kpoints)
ax.set_xticklabels(['1x1x1', '2x2x1', '3x3x2', '4x4x3', '5x5x4', '6x6x5'])
zm=ax.inset_axes([0.4,0.1,0.5,0.5]) # [x0,y0,width,height]
zm.plot(x0,y0,"-o",lw=1)
zm.set_xticks(x0)
zm.set_xticklabels(["3x3x2","4x4x3","5x5x4"])
zm.set_yticks(y0,labels=np.round(y0,decimals=3))
zm.grid()
zm.plot([x0[1], x0[1]], [y0[0], y0[1]], color="black", lw=2)  # Line between two points
zm.annotate(r"$\Delta E =< 0.01 \, Ry$", xy=((x0[1]) , (y0[0] + y0[1]) / 2), xytext=(x0[1] + 0.3, y0[1] + -0.01),arrowprops=dict(facecolor='black', shrink=0.05))
ax.indicate_inset_zoom(zm,edgecolor='black',lw=7)

ax.set_xlabel("Number of Kpoints per laticce")
ax.set_ylabel("Total energy (Ry)")
#plt.title(r"Kpoint number convergence for $BiFeO_3$ type G")
ax.grid()

plt.savefig("convergence_kpoints_pbe.png",dpi=100)
plt.show() 


