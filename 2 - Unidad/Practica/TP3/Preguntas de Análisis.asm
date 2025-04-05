# -- Almacenamiento y manipulacion en registros:
# Los valores se almacenan directamente en los 32 registros de
# 32 bits (x0-x31). Se manipulan con instrucciones como add, sub, li, mv, etc. 
# El registro x0 siempre vale 0 y es de solo lectura.

# -- Diferencias entre li, la y mv:

# li: Carga un valor inmediato (ej: li x1, 5 → x1=5)

# la: Carga una direccion de memoria (ej: la x1, etiqueta)

# mv: Copia entre registros (ej: mv x1, x2 → x1=x2)

# -- Sin ecall al final:
# El programa continuaria ejecutando instrucciones posteriores en memoria 
# (posiblemente basura), lo que podria causar comportamientos erraticos o crashes. 
# ecall con codigo 10 termina el programa limpiamente.