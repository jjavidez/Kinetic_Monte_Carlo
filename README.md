# Monte Carlo Hopping Conduction simulation


## Contenido del Repositorio

El proyecto está estructurado en dos carpetas principales, cada una destinada a una fase distinta del análisis:

* **`Parte_2/`**: Contiene los archivos para la ejecución y análisis de las simulaciones en el rango de temperaturas de 0.05 a 0.5
* **`Parte_3/`**: Contiene los archivos para la ejecución y análisis a temperaturas superiores, destinados al cálculo de la conductividad y la verificación de la Ley de Mott.

---

## Instrucciones de Uso

### Ejecución de la Parte 2 (Bajas Temperaturas)

Abre una terminal, navega hasta el directorio `2_simulations_T_0.05_0.5` y utiliza los siguientes comandos:

1. **Ejecutar las simulaciones:**
   ```bash
   make run_all
   ```
2. **Generar las gráficas:**
   ```bash
   make plot_local
   ```
   *Nota: Este comando procesará los datos y guardará las gráficas correspondientes (energía y polarización) dentro de los directorios generados para cada temperatura. *

3. **Limpiar resultados:**
   Para eliminar los archivos generados y gráficas, ejecuta:
   ```bash
   make clean
   ```

### Ejecución de la Parte 3 (Ley de Mott y Conductividad)

Abre una terminal, navega hasta el directorio `3_Mott_law` y utiliza los siguientes comandos en orden:

1. **Ejecutar las simulaciones:**
   ```bash
   make run_all
   ```
2. **Generar las gráficas locales:**
   ```bash
   make plot_local
   ```
3. **Generar el análisis de Mott:**
   ```bash
   make mott
   ```
   *Nota: Este comando es exclusivo de la Parte 3. Calculará las conductividades, calculará la Temperatura de Mott y generará la gráfica final del ajuste lineal a la Ley de Mott.*

4. **Limpiar resultados:**
   Al igual que en la carpeta anterior, para limpiar los datos generados ejecuta:
   ```bash
   make clean
   ```

## Estructura de Resultados Generados

Al ejecutar los comandos descritos, los scripts crearán automáticamente una estructura de carpetas para organizar los datos de salida:

* **Para la Parte 2 y Parte 3:** Se generarán directorios individuales para cada temperatura simulada (por ejemplo, carpetas nombradas según el valor de T). Dentro de cada una de estas carpetas se guardarán los datos en bruto y las gráficas locales (energía y polarización) de esa temperatura en concreto.

* **Exclusivo de la Parte 3:** Tras ejecutar `make mott`, se generará una carpeta adicional llamada **`results/`**. Esta carpeta de análisis global contiene:
  * Dos gráficas de resumen: el plot de Conductividad vs Temperatura y el plot del ajuste a la Ley de Mott.
  * Un archivo `.txt` que contiene el valor final obtenido para la **Temperatura de Mott** ($T_M$).