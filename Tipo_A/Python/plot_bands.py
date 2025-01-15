#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 12 12:44:02 2024

@author: aldair1809
"""

import matplotlib.pyplot as plt
import numpy as np
def read_fermi_energy(file_path):
    fermi_energy = None
    
    # Open and read the scf.out file
    with open(file_path, 'r') as file:
        for line in file:
            # Look for the line containing the Fermi energy
            if 'the Fermi energy is' in line:
                # Extract the Fermi energy value (in Ry) from the line
                parts = line.split()
                fermi_energy = float(parts[4])  # The Fermi energy value in Ry is the 5th element
                
                # Convert to eV (1 Ry = 13.605698 eV)
                return fermi_energy

    # If the Fermi energy is not found, return None
    return fermi_energy

# Example usage:
file_path = 'scf.bifeo3.out'
EF = read_fermi_energy(file_path)
if EF is not None:
    print(f"The Fermi energy is {EF:.4f} Ry")
else:
    print("Fermi energy not found in the file.")


plt.rcParams["figure.dpi"] = 150
plt.rcParams["figure.facecolor"] = "white"
plt.rcParams["figure.figsize"] = (8, 6)

# Load data
try:
    data = np.loadtxt('bifeo3.bandas.gnu')
except Exception as e:
    print(f"Error loading data: {e}")
    exit()

# Prepare k-point data
k = np.unique(data[:, 0])
bands = np.reshape(data[:, 1], (-1, len(k))) - EF

# Define k-point labels
k_points = [0, 0.5774, 0.9107, 1.5774]
k_labels = ['$\Gamma$', 'M', 'K', '$\Gamma$']
max_band=list()
min_band=list()
# Plotting
for band in bands:
    plt.plot(k, band, linewidth=1, alpha=0.5, color='k')
    max_band.append(max(band))
    min_band.append(min(band))
    
# Set plot limits and labels
plt.ylim(-4, 4)
plt.xlim(min(k), max(k))
plt.axhline(0, color='red', linewidth=1)
plt.text(k[-1]+0.02,0, "EF", fontsize="large")
plt.ylabel("Energy (eV)")
plt.xticks(ticks=k_points, labels=k_labels)

# Add vertical dashed lines at specified k-points
for kp in k_points:
    plt.axvline(x=kp, color='gray', linestyle='--', linewidth=1)
temp=[]
for min_banda in min_band:

    if min_banda>0:
        temp.append(min_banda)
cb=min(temp)
temp=[]
for max_banda in max_band:

    if max_banda<0:
        temp.append(max_banda)
vb=max(temp)
print("Gap energy is: ",cb-vb,"eV" )
#plt.grid(True)  # Add grid
plt.plot(k,np.ones_like(k)*cb,"black")
plt.plot(k,np.ones_like(k)*vb,"black")
plt.savefig("Bifeo3.bandas.U_4.1.png")
plt.show()
