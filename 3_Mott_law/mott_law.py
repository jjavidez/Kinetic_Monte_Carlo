import os
import numpy as np
import matplotlib.pyplot as plt
import argparse
from scipy.stats import linregress

def mott_law():
    parser = argparse.ArgumentParser(description="Plot Mott Law")
    parser.add_argument('--temps', type=str, required=True)
    parser.add_argument('--output', type=str, help="Directory to save results")
    args = parser.parse_args()

    temp_strings = args.temps.split()
    conductivity_lst = []

    for s in temp_strings:
        path = f"T_{s}/conductivity.txt"
        if os.path.exists(path):
            conductivity = np.loadtxt(path)
            conductivity_lst.append(float(conductivity))

    
    temps_list = [float(t.replace('d', 'e')) for t in temp_strings]
    temps = np.array(temps_list)
            
    
    # Quick validation
    if len(temps) != len(conductivity_lst):
        print("Error: The lists 'temps' and 'conductivity_lst' must have the same length.")
        return

    
    ln_conductivity = np.log(conductivity_lst)
    temps3 = np.cbrt(temps)
    inv_temps = 1.0 / temps3

    slope, intercept, r_value, p_value, std_err = linregress(inv_temps, ln_conductivity)

    tm = (- slope) ** (3.0)

    tm_err = (- std_err) ** (3.0)

    name_txt = 'tm_calc.txt'

    final_path_txt = os.path.join(args.output, name_txt)

    with open(final_path_txt, 'w') as f:
        f.write(f"Tm: {tm} ± {tm_err}\n. R-squared: {r_value**2}")

    plt.figure(figsize=(10, 6))

    plt.plot(temps, conductivity_lst, 
             marker='o',          # Circular markers
             linestyle='-',       # Solid line
             color='#1f77b4',    # Standard blue color
             linewidth=2,         # Line thickness
             markersize=8,       # Marker size
             label='Conductivity')
    
    plt.title('Electrical Conductivity vs. Temperature', fontsize=16, fontweight='bold')
    plt.xlabel('Temperature (CU)', fontsize=14)
    plt.ylabel('Conductivity (CU)', fontsize=14) # Using LaTeX for Sigma

    plt.grid(True, linestyle='--', alpha=0.7) # Add a dashed grid
    plt.tick_params(axis='both', which='major', labelsize=12) # Adjust tick label size
    plt.autoscale(enable=True, axis='both', tight=None)

    #Saving
    plt.savefig( os.path.join(args.output,"conductivity_vs_temp.png"), dpi=300, bbox_inches='tight')


    #Ploting ln(sigma) vs 1/T^3
    plt.figure(figsize=(10, 6))

    plt.plot(inv_temps, ln_conductivity, 
             marker='o',          # Circular markers
             linestyle='-',       # Solid line
             color='#2ca02c',    # Standard green color
             linewidth=2,         # Line thickness
             markersize=8,       # Marker size
             label='Conductivity')
    
    plt.title('ln(Conductivity) vs 1/T^(1/3)', fontsize=16, fontweight='bold')
    plt.xlabel('1/T^(1/3)', fontsize=14)
    plt.ylabel('ln(Conductivity)', fontsize=14) 

    plt.grid(True, linestyle='--', alpha=0.7) # Add a dashed grid
    plt.tick_params(axis='both', which='major', labelsize=12) # Adjust tick label size
    plt.autoscale(enable=True, axis='both', tight=None)

    #Saving
    plt.savefig(os.path.join(args.output,"mott_law.png"), dpi=300, bbox_inches='tight')
    print("Plots successfully saved ")

if __name__ == "__main__":
    mott_law()