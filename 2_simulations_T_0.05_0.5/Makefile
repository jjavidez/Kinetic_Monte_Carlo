# --- Configuración del Compilador ---
FC = gfortran

# FLAGS DE DEPURE (DEBUG)
# -g: información para GDB (líneas de código)
# -fcheck=all: comprueba índices de arrays, punteros, etc. en tiempo de ejecución
# -fbacktrace: imprime la línea del error si el programa muere
# -ffpe-trap=invalid,zero,overflow: para el programa si hay errores matemáticos (dividir por cero, etc.)
DBFLAGS = -g -fcheck=all -fbacktrace -ffpe-trap=invalid,zero,overflow

# FLAGS DE OPTIMIZACIÓN (PRODUCCIÓN)
PRODFLAGS = -O2

#Flags de profiling
PROFFLAGS = -pg

# Por defecto usamos producción, a menos que se diga lo contrario
FFLAGS = $(PRODFLAGS) -Wall -I/usr/local/include/fgsl
LDFLAGS = `pkg-config --libs fgsl`

# 'make DEBUG=1'
ifeq ($(DEBUG), 1)
    FFLAGS = $(DBFLAGS) -Wall -I/usr/local/include/fgsl
endif

# 'make PROF=1'
ifeq ($(PROF), 1)
    FFLAGS += $(PROFFLAGS)
    LDFLAGS += $(PROFFLAGS)
endif

# ... (resto del Makefile igual: TARGET, OBJ, reglas de dependencia) ...

TARGET = programa_mc.exe
OBJ = m_constants.o m_latt_gen.o m_tower.o magnitudes.o \
    	m_ran_gen.o m_MC_step.o main.o

run: $(TARGET)

$(TARGET): $(OBJ)
	$(FC) $(FFLAGS) -o $(TARGET) $(OBJ) $(LDFLAGS)

%.o: %.f90
	$(FC) $(FFLAGS) -c $<

m_constants.o: m_constants.f90
m_latt_gen.o: m_latt_gen.f90 m_constants.o m_ran_gen.o
m_tower.o: m_tower.f90 m_constants.o m_latt_gen.o
magnitudes.o: magnitudes.f90 m_constants.o m_latt_gen.o m_tower.o
m_ran_gen.o: m_ran_gen.f90
	$(FC) $(FFLAGS) `pkg-config --cflags fgsl` -c m_ran_gen.f90
m_MC_step.o: m_MC_step.f90 m_constants.o m_tower.o magnitudes.o m_ran_gen.o
main.o: main.f90 m_MC_step.o m_ran_gen.o magnitudes.o m_tower.o m_latt_gen.o m_constants.o


.PHONY: run

# --- Configuration of the simulation ---
TEMPS = 5.0d-2 1.0d-1 1.5d-1 2.0d-1 2.5d-1 3.0d-1 3.5d-1 4.0d-1 4.5d-1 5.0d-1

.PHONY: run_all
run_all: $(TARGET)
	@echo "Inicializing temperature loop..."
	@for t in $(TEMPS); do \
        	mkdir -p T_$$t; \
        	echo "Running T=$$t..."; \
        	./$(TARGET) $$t > T_$$t/log.txt; \
        	mv energy.txt xpol.txt ypol.txt T_$$t/ 2>/dev/null || true; \
	done
	@echo "Simulations finished."

#Local plots for each temperature

ALL_PNGS = $(foreach t, $(TEMPS), T_$(t)/xpol.png T_$(t)/energy.png T_$(t)/ypol.png)

.PHONY: plot_local

plot_local: $(ALL_PNGS)
	@echo "Local plots generated."

T_%/xpol.png: T_%/xpol.txt
	@echo "Generating x polarization plot for T=$*..."
	gnuplot -e "INFILE='$<'; OUTFILE='$@'; TEMP='$*'" xpol.gnu


T_%/energy.png: T_%/energy.txt
	@echo "Generating energy plot for T=$*..."
	gnuplot -e "INFILE='$<'; OUTFILE='$@'; TEMP='$*'" energy.gnu


T_%/ypol.png: T_%/ypol.txt
	@echo "Generating y polarization plot for T=$*..."
	gnuplot -e "INFILE='$<'; OUTFILE='$@'; TEMP='$*'" ypol.gnu

#Clean configuration for simulation outputs
DIRS = $(patsubst %, T_%, $(TEMPS))

# 'make clean' or 'make clean_results' to clean results of the simulations
.PHONY: clean clean_results

# Total clean: remove all generated files, including executables and object files
clean: clean_results
	@echo "Cleaning compilation files..."
	rm -f $(OBJ) *.mod $(TARGET) 

# 'Make clean_results' only to cleaning directories of simulation
clean_results:
	@echo "Cleaning analysis files and directories..."
	rm -rf $(DIRS)
	rm -f *.pngç

#--- Part 3 analysis ----

.PHONY: mott

RESULTS = tm_calc.txt conductivity_vs_temp.png mott_law.png

RESULTS_LOCAL = $(foreach r, $(RESULTS), results/$(r))

GEN_SCRIPT = mott_law.py

LOC_SCRIPT = cond_script.py


#Y see linear polarization starting at T=1.5
TEMP_MOTT = 1.5d0 2.0d0 2.5d0 3.0d0 3.5d0 4.0d0 4.5d0 5.0d0

MOTT_COND = $(foreach t, $(TEMP_MOTT), T_$(t)/conductivity.txt)

XPOL = $(foreach t, $(TEMP_MOTT), T_$(t)/xpol.txt)

mott: $(RESULTS_LOCAL)
	@echo "Mott law analysis completed. Results saved in 'results/' directory."

$(RESULTS_LOCAL): $(MOTT_COND) 
	@echo "Running general scripts for temperature $(TEMP_MOTT)."	
	mkdir  results
	python3 $(GEN_SCRIPT) --temps "$(TEMP_MOTT)" --output results/
	@echo "Results obtained"


$(MOTT_COND): $(XPOL)
	@echo "Calculating conductivity for each temperature and ploting x polarization vs time"
	@for t in $(TEMP_MOTT); do \
			echo "Running T=$$t..."; \
			python3 $(LOC_SCRIPT) --temp $$t --output T_$$t --input T_$$t/xpol.txt; \
	done

