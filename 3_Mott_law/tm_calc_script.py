import argparse
import numpy as np
import os



def tm_calc():
    #Configurate the arguments
    parser = argparse.ArgumentParser(description="Tm calculation")
    parser.add_argument('--temps', type=str, required=True)
    args = parser.parse_args()

    temps = float(args.temps.replace('d', 'e'))

    conductivity_lst = []

    for t in temps:
        path = f"T_{t}/conductivity.txt"
        if os.path.exists(path):
            conductivity = np.loadtxt(path)
            conductivity_lst.append(conductivity)

    # Quick validation
    if len(temps) != len(conductivity_lst):
        print("Error: The lists 'temps' and 'conductivity_lst' must have the same length.")
        return

    #Tm calculation

    mean, intercept = np.polyfit (temps, conductivity_lst, 1)

    