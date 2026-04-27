set terminal pngcairo size 800,600 font 'sans,10'
set grid
set key top right
set output OUTFILE
set title "Energy Evolution at T=".TEMP
set xlabel "Time(CU)"
set ylabel "Energy (CU)"

plot INFILE u ($1):($2) w l lt 1 lc rgb 'blue' 