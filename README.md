# FSM-EXPENDEDORA
Maquina expendedora Verilog para Tinytapeout 
# Máquina Expendedora - TinyTapeout

Este proyecto implementa una máquina expendedora con FSM combinada (Moore + Mealy) que acepta monedas, permite comprar productos de 2 y 3 unidades y da cambio. 

Diseñado para [TinyTapeout](https://tinytapeout.com).

### Entradas (`ui_in`)
- `ui_in[1:0]`: moneda (00=nada, 01=2, 10=3, 11=4)
- `ui_in[2]`: comprar producto A
- `ui_in[3]`: comprar producto B
- `ui_in[4]`: reset
- `rst_n`: reset activo bajo
- `clk`: reloj

### Salidas (`uo_out`)
- `uo_out[0]`: listoA
- `uo_out[1]`: listoB
- `uo_out[5:2]`: total acumulado
- `uo_out[7:6]`: cambio

Autor: Katherine Dayanna Castillo  
