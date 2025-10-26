library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg7_driver is
    port(
        floor : in  std_logic_vector(1 downto 0);
        seg7  : out std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of seg7_driver is
begin
    process(floor)
    begin
        case floor is
            when "00" => seg7 <= "0000001"; -- 0
            when "01" => seg7 <= "1001111"; -- 1
            when "10" => seg7 <= "0010010"; -- 2
            when "11" => seg7 <= "0000110"; -- 3
            when others => seg7 <= "1111111"; -- off
        end case;
    end process;
end architecture;

