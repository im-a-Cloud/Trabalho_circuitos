library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_types.ALL;

entity tb_top_level is
end entity;

architecture tb of tb_top_level is

    constant NUM_FLOORS : integer := 4;

    -- Sinais de teste
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal request_panel: call_vector_t(NUM_FLOORS-1 downto 0) := (others => '0');
    signal seg7         : std_logic_vector(6 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Instancia o top_level
    uut: entity work.top_level
        generic map (
            NUM_FLOORS => NUM_FLOORS
        )
        port map (
            clk           => clk,
            reset         => reset,
            request_panel => request_panel,
            seg7          => seg7
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Test sequence
    stim_proc: process
    begin
        -- Inicialmente reset ativo
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Pedido no andar 2
        request_panel(1) <= '1';
        wait for 50 ns;
        request_panel(1) <= '0';

        -- Pedido no andar 4
        request_panel(3) <= '1';
        wait for 100 ns;
        request_panel(3) <= '0';

        wait for 200 ns;

        -- Fim do teste
        wait;
    end process;

end architecture;

