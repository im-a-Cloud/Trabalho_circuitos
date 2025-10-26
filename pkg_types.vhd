library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package pkg_types is

    -- Tipo de vetor de chamadas (uma posição por andar)
    subtype call_t is std_logic;
    type call_vector_t is array (natural range <>) of call_t;

end package;

