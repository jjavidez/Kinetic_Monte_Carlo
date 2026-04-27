import matplotlib.pyplot as plt
import numpy as np
import argparse
import os

def graph_data():
    #Configurate the arguments
    parser = argparse.ArgumentParser(description="Plot Time vs Polarization")
    parser.add_argument("--input", type=str, required=True, help="xpol.txt")
    parser.add_argument("--output", type=str, help="pol_vs_time.png")
    parser.add_argument('--temp', type=str, required=True)
    args = parser.parse_args()

    #Loading data
    data = np.loadtxt(args.input)

    
    time = data[:, 0]
    polarization = data[:, 1]

    #Converting Fortran to Phyton form
    temp_float = float(args.temp.replace('d', 'e'))


    #Plotting
    plt.figure(figsize=(10, 6))
    plt.plot(time, polarization, color='blue', linewidth=1.5, label='X Polarization')

    plt.title('Polarization evolution', fontsize=14)
    plt.xlabel('Time (CU)', fontsize=12)
    plt.ylabel('X Polarization (CU)', fontsize=12)
    plt.grid(True, linestyle='--', alpha=0.7)
    plt.axhline(0, color='black', linewidth=0.8) 
    plt.legend()

    #Conductivity calc
    slope, intercept = np.polyfit (time, polarization, 1)

    #Sigma = (1/(E*N))*mean
    conductivity = slope/((temp_float/10.0)*400.0)

    #Name of .txt to store result
    name_txt = 'conductivity.txt'

    name_png = 'pol_vs_time.png'

    final_path_txt = os.path.join(args.output, name_txt)

    final_path_png = os.path.join(args.output, name_png)

    with open(final_path_txt, 'w') as f:
        f.write(str(conductivity))

    # Save or show
    if args.output:
        plt.savefig(final_path_png, dpi=300)
        print(f"Graph in : {final_path_png}")
    else:
        plt.show()

if __name__ == "__main__":
    graph_data()