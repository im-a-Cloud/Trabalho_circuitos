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

Como Executar
Programa usado:ModelSim Intel FPGA Edition

Todos os arquivos na mesma pasta

Passo 1: Preparar Ambiente

# No console do ModelSim:
vdel -all
vlib work
Passo 2: Compilação Rápida (Recomendado)
tcl
vdel -all; vlib work; vcom -2002 pkg_types.vhd seg7_driver_32floors.vhd elevator_controller_simple.vhd elevator_system_simple.vhd tb_elevator_system_simple.vhd; vsim work.tb_elevator_system_simple; add wave *; run 3000 ns

Passo 3: Compilação Manual (Passo a Passo)

# 1. Compilar na ORDEM CORRETA:
vcom -2002 pkg_types.vhd
vcom -2002 seg7_driver_32floors.vhd
vcom -2002 elevator_controller_simple.vhd
vcom -2002 elevator_system_simple.vhd
vcom -2002 tb_elevator_system_simple.vhd

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

Cenário 4: Múltiplas Chamadas

force -freeze sim:/tb_elevator_system_simple/call_up(2) 1 0
force -freeze sim:/tb_elevator_system_simple/call_down(8) 1 0
force -freeze sim:/tb_elevator_system_simple/dest_request0(6) 1 0
run 4000 ns

Resultado Esperado: Distribuição balanceada entre os elevadores.

Comandos de Debug

Ver Andares Atuais

Adicionar sinais internos dos elevadores:

add wave -position insertpoint \
sim:/tb_elevator_system_simple/uut/elevator0/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator0/state \
sim:/tb_elevator_system_simple/uut/elevator1/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator1/state \
sim:/tb_elevator_system_simple/uut/elevator2/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator2/state
Grupos Organizados para Debug

Criar grupos para cada elevador

add wave -group "Elevator_0" -position insertpoint \
sim:/tb_elevator_system_simple/uut/elevator0/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator0/state \
sim:/tb_elevator_system_simple/uut/elevator0/door_timer \
sim:/tb_elevator_system_simple/uut/elevator0/move_timer

add wave -group "Elevator_1" -position insertpoint \
sim:/tb_elevator_system_simple/uut/elevator1/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator1/state \
sim:/tb_elevator_system_simple/uut/elevator1/door_timer \
sim:/tb_elevator_system_simple/uut/elevator1/move_timer

add wave -group "Elevator_2" -position insertpoint \
sim:/tb_elevator_system_simple/uut/elevator2/current_floor_int \
sim:/tb_elevator_system_simple/uut/elevator2/state \
sim:/tb_elevator_system_simple/uut/elevator2/door_timer \
sim:/tb_elevator_system_simple/uut/elevator2/move_timer
Verificar Valores em Tempo Específico
tcl
# Ver andares atuais em 1500ns:
examine -time 1500 ns /tb_elevator_system_simple/uut/elevator0/current_floor_int
examine -time 1500 ns /tb_elevator_system_simple/uut/elevator1/current_floor_int
examine -time 1500 ns /tb_elevator_system_simple/uut/elevator2/current_floor_int
Monitorar Requisições
tcl
# Ver distribuição de chamadas
add wave -position insertpoint \
sim:/tb_elevator_system_simple/uut/elevator_requests0 \
sim:/tb_elevator_system_simple/uut/elevator_requests1 \
sim:/tb_elevator_system_simple/uut/elevator_requests2
Especificações Técnicas
Parâmetros Temporais
Tempo de porta aberta: 300 ciclos de clock (3 segundos)

Tempo entre andares: 200 ciclos de clock (2 segundos)

Clock: 100 MHz (período de 10 ns)

Estados da Máquina de Estado
STATE_IDLE: Aguardando comandos

STATE_MOVING_UP: Subindo para andar superior

STATE_MOVING_DOWN: Descendo para andar inferior

STATE_DOOR_OPEN: Porta aberta para embarque/desembarque

Estratégia de Escalonamento
Round-Robin: Distribui chamadas externas sequencialmente entre os elevadores

Chamadas internas: Atendidas pelo elevador específico

Prioridade: Chamadas no andar atual > direção atual > outras direções
