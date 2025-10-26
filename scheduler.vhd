library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_types.ALL;

entity scheduler is
    generic(
        NUM_FLOORS : integer := 4;
        NUM_ELEV   : integer := 3
    );
    port(
        req_from_panel : in  call_vector_t(NUM_FLOORS-1 downto 0);
        req_to_elevator: out call_vector_t(NUM_FLOORS-1 downto 0)
    );
end entity;

architecture rtl of scheduler is
    signal pending_requests : call_vector_t(NUM_FLOORS-1 downto 0);
begin

    process(req_from_panel)
    begin
        -- Atualiza manualmente cada bit
        for i in 0 to NUM_FLOORS-1 loop
            if req_from_panel(i)='1' then
                pending_requests(i) <= '1';
            end if;
        end loop;
        req_to_elevator <= pending_requests;
    end process;

end architecture;

