Sistema de Controle de Elevadores - VHDL
Sobre o Projeto
Sistema digital em VHDL para controle de 3 elevadores em um edifício de 32 andares, implementando arquitetura de dois níveis com controladores individuais por elevador e escalonamento centralizado.

##Características Principais
3 elevadores independentes

32 andares (0 a 31)

Arquitetura de 2 níveis

Máquinas de Estado Finitas (FSM)

Temporizadores realistas

Display 7 segmentos

Escalonamento Round-Robin

Testbench completo

Como Executar
Programa usado: ModelSim Intel FPGA Edition
Requisito: Todos os arquivos na mesma pasta

Passo 1: Preparar Ambiente

vdel -all
vlib work

Passo 2: Compilação Rápida (Recomendado)


vdel -all; vlib work; vcom -2002 pkg_types.vhd seg7_driver_32floors.vhd elevator_controller_simple.vhd elevator_system_simple.vhd tb_elevator_system_simple.vhd; vsim work.tb_elevator_system_simple; add wave *; run 3000 ns


Passo 3: Compilação Manual (Passo a Passo)

vcom -2002 pkg_types.vhd

vcom -2002 seg7_driver_32floors.vhd

vcom -2002 elevator_controller_simple.vhd

vcom -2002 elevator_system_simple.vhd

vcom -2002 tb_elevator_system_simple.vhd

vsim work.tb_elevator_system_simple

add wave *

run 2000 ns


Demonstração Completa no ModelSim

Teste 1 - Comportamentos Independentes

restart -f

run 100 ns

force -freeze sim:/tb_elevator_system_simple/call_up(0) 1 0 ns

run 200 ns

force -freeze sim:/tb_elevator_system_simple/dest_request0(5) 1 0 ns

run 800 ns

force -freeze sim:/tb_elevator_system_simple/dest_request1(12) 1 0 ns

run 1000 ns

force -freeze sim:/tb_elevator_system_simple/dest_request2(20) 1 0 ns

run 1500 ns

force -freeze sim:/tb_elevator_system_simple/call_down(8) 1 0 ns

run 500 ns

force -freeze sim:/tb_elevator_system_simple/call_up(15) 1 0 ns

run 500 ns

force -freeze sim:/tb_elevator_system_simple/call_down(25) 1 0 ns

run 1000 ns

force -freeze sim:/tb_elevator_system_simple/dest_request0(10) 1 0 ns

run 500 ns

force -freeze sim:/tb_elevator_system_simple/dest_request1(3) 1 0 ns

run 500 ns

force -freeze sim:/tb_elevator_system_simple/dest_request2(18) 1 0 ns

run 2000 ns

Teste 2 - Cenário Realista

restart -f

run 100 ns

force -freeze sim:/tb_elevator_system_simple/dest_request0(3) 1 0 ns

run 800 ns

force -freeze sim:/tb_elevator_system_simple/dest_request0(6) 1 0 ns

run 800 ns

force -freeze sim:/tb_elevator_system_simple/dest_request0(2) 1 0 ns

force -freeze sim:/tb_elevator_system_simple/dest_request1(10) 1 0 ns

run 600 ns

force -freeze sim:/tb_elevator_system_simple/dest_request1(15) 1 0 ns

run 600 ns

force -freeze sim:/tb_elevator_system_simple/dest_request1(8) 1 0 ns

force -freeze sim:/tb_elevator_system_simple/dest_request2(25) 1 0 ns

run 400 ns

force -freeze sim:/tb_elevator_system_simple/dest_request2(30) 1 0 ns

run 400 ns

force -freeze sim:/tb_elevator_system_simple/dest_request2(22) 1 0 ns

run 2000 ns


Teste 4 - Verificação Round-Robin


restart -f

run 100 ns

force -freeze sim:/tb_elevator_system_simple/call_up(3) 1 0 ns

run 100 ns

force -freeze sim:/tb_elevator_system_simple/call_up(7) 1 0 ns

run 100 ns

force -freeze sim:/tb_elevator_system_simple/call_up(11) 1 0 ns

run 100 ns

force -freeze sim:/tb_elevator_system_simple/call_up(15) 1 0 ns

run 2000 ns


Cenários de Teste

Cenário 1: Inicialização e Reset

run 500 ns

Resultado Esperado: Todos elevadores no andar 0, estados IDLE.

Cenário 2: Chamada Externa


run 1000 ns


Resultado Esperado: Um elevador sobe para andar 5 em resposta a call_up(5).

Cenário 3: Concorrência


force -freeze sim:/tb_elevator_system_simple/dest_request1(12) 1 0 ns
force -freeze sim:/tb_elevator_system_simple/dest_request2(15) 1 0 ns
run 3000 ns


Resultado Esperado: Todos os 3 elevadores movendo-se simultaneamente para andares diferentes.

Cenário 4: Múltiplas Chamadas


force -freeze sim:/tb_elevator_system_simple/call_up(2) 1 0 ns

force -freeze sim:/tb_elevator_system_simple/call_down(8) 1 0 ns

force -freeze sim:/tb_elevator_system_simple/dest_request0(6) 1 0 ns

run 4000 ns

Resultado Esperado: Distribuição balanceada entre os elevadores.

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

Funcionalidades Validadas

Inicialização e reset

Comportamento independente dos elevadores

Movimento em direções opostas

Escalonamento round-robin

Temporização realista

Operação estável em cenários complexos

Sincronização entre andares e displays
