Sistema de Controle de Elevadores - VHDL
Sobre o Projeto
Sistema digital em VHDL para controle de 3 elevadores em um edifício de 32 andares, implementando arquitetura de dois níveis com controladores individuais por elevador e escalonamento centralizado.

Características Principais
3 elevadores independentes

32 andares (0 a 31)

Arquitetura de 2 níveis

Máquinas de Estado Finitas (FSM)

Temporizadores realistas

Display 7 segmentos

Escalonamento Round-Robin

Testbench completo

Como Executar

Arquivos do projeto na mesma pasta

Passo 1: Preparar Ambiente
tcl
# No console do ModelSim:
vdel -all
vlib work

Passo 2: Compilação Rápida (Recomendado)

vdel -all; vlib work; vcom -work work -2002 pkg_types.vhd seg7_driver.vhd elevator_controller_simple.vhd elevator_system_simple.vhd tb_elevator_system_simple.vhd; vsim work.tb_elevator_system_simple; add wave *; run 3000 ns

Passo 3: Compilação Manual (Passo a Passo)
tcl
# 1. Compilar na ORDEM CORRETA:
vcom -work work -2002 pkg_types.vhd
vcom -work work -2002 seg7_driver.vhd
vcom -work work -2002 elevator_controller_simple.vhd
vcom -work work -2002 elevator_system_simple.vhd
vcom -work work -2002 tb_elevator_system_simple.vhd

# 2. Simular:
vsim work.tb_elevator_system_simple

# 3. Adicionar ondas principais:
add wave *

# 4. Executar teste básico:
run 2000 ns

Cenários de Teste

Cenário 1: Inicialização e Reset

run 500 ns

Resultado Esperado: Todos elevadores no andar 0, estados IDLE.

Cenário 2: Chamada Externa

run 1000 ns

Resultado Esperado: Um elevador sobe para andar 5 em resposta a call_up(5).

Cenário 3: Concorrência

force -freeze sim:/tb_elevator_system_simple/dest_request1(12) 1 0
force -freeze sim:/tb_elevator_system_simple/dest_request2(15) 1 0
run 3000 ns


Resultado Esperado: Todos os 3 elevadores movendo-se simultaneamente para andares diferentes.

Comandos de Debug
Ver Andares Atuais
tcl
# Adicionar sinais internos dos elevadores:
add wave -position insertpoint \
sim:/tb_elevator_system_simple/uut/elevator0/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator0/state \
sim:/tb_elevator_system_simple/uut/elevator1/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator1/state \
sim:/tb_elevator_system_simple/uut/elevator2/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator2/state

Verificar Valores em Tempo Específico
tcl
# Ver andares atuais em 1500ns:
examine -time 1500 ns /tb_elevator_system_simple/uut/elevator0/current_floor_int
examine -time 1500 ns /tb_elevator_system_simple/uut/elevator1/current_floor_int
examine -time 1500 ns /tb_elevator_system_simple/uut/elevator2/current_floor_int
