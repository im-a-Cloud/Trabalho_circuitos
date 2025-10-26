library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_types.ALL;

entity top_level is
    generic(
        NUM_FLOORS : integer := 4;
        NUM_ELEV   : integer := 3
    );
    port(
        clk       : in  std_logic;
        reset     : in  std_logic;
        request_panel : in  call_vector_t(NUM_FLOORS-1 downto 0);
        seg7      : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of top_level is

    -- Sinais internos
    signal request_elevator : call_vector_t(NUM_FLOORS-1 downto 0);
    signal current_floor     : std_logic_vector(1 downto 0);
    signal move_up           : std_logic;
    signal move_down         : std_logic;
    signal door_open_sig     : std_logic;
    signal door_close_sig    : std_logic;

begin

    -- Scheduler: decide quais pedidos vão para o elevador
    u_scheduler: entity work.scheduler
        generic map (
            NUM_FLOORS => NUM_FLOORS,
            NUM_ELEV   => NUM_ELEV
        )
        port map (
            req_from_panel  => request_panel,
            req_to_elevator => request_elevator
        );

    -- Controlador local do elevador
    u_local_controller: entity work.local_controller
        generic map (
            NUM_FLOORS => NUM_FLOORS
        )
        port map (
            clk           => clk,
            reset         => reset,
            request       => request_elevator,
            current_floor => current_floor,
            move_up       => move_up,
            move_down     => move_down,
            door_open_sig => door_open_sig,
            door_close_sig=> door_close_sig
        );

    -- Driver do display 7 segmentos
    u_seg7: entity work.seg7_driver
        port map (
            floor => current_floor,
            seg7  => seg7
        );

end architecture;

