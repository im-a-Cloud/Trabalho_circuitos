library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_types.ALL;

entity local_controller is
    generic(
        NUM_FLOORS : integer := 4
    );
    port(
        clk           : in  std_logic;
        reset         : in  std_logic;
        request       : in  call_vector_t(NUM_FLOORS-1 downto 0);
        current_floor : out std_logic_vector(1 downto 0);
        move_up       : out std_logic;
        move_down     : out std_logic;
        door_open_sig : out std_logic;
        door_close_sig: out std_logic
    );
end entity;

architecture rtl of local_controller is

    type elevator_state_t is (IDLE, MOVING_UP, MOVING_DOWN, DOOR_OPEN, DOOR_CLOSE);
    signal state          : elevator_state_t := IDLE;
    signal current_floor_s: unsigned(1 downto 0) := "00";
    
    -- Sinal registrado para a saída
    signal current_floor_reg : std_logic_vector(1 downto 0) := "00";

begin

    process(clk, reset)
        variable next_state_var : elevator_state_t := IDLE;
        variable move_up_var    : std_logic := '0';
        variable move_down_var  : std_logic := '0';
        variable door_open_var  : std_logic := '0';
        variable door_close_var : std_logic := '0';
        variable has_above      : boolean := false;
        variable has_below      : boolean := false;
    begin
        if reset='1' then
            state <= IDLE;
            current_floor_s <= "00";
            move_up <= '0';
            move_down <= '0';
            door_open_sig <= '0';
            door_close_sig <= '0';
            current_floor_reg <= "00";
        elsif rising_edge(clk) then
            next_state_var := state;
            move_up_var    := '0';
            move_down_var  := '0';
            door_open_var  := '0';
            door_close_var := '0';
            has_above      := false;
            has_below      := false;

            -- Verifica pedidos acima do andar atual
            for i in 0 to NUM_FLOORS-1 loop
                if i > to_integer(current_floor_s) and request(i) = '1' then
                    has_above := true;
                end if;
                if i < to_integer(current_floor_s) and request(i) = '1' then
                    has_below := true;
                end if;
            end loop;

            case state is
                when IDLE =>
                    if request(to_integer(current_floor_s)) = '1' then
                        next_state_var := DOOR_OPEN;
                    elsif has_above then
                        next_state_var := MOVING_UP;
                    elsif has_below then
                        next_state_var := MOVING_DOWN;
                    end if;

                when MOVING_UP =>
                    move_up_var := '1';
                    if current_floor_s < NUM_FLOORS-1 then
                        current_floor_s <= current_floor_s + 1;
                    end if;
                    next_state_var := IDLE;

                when MOVING_DOWN =>
                    move_down_var := '1';
                    if current_floor_s > 0 then
                        current_floor_s <= current_floor_s - 1;
                    end if;
                    next_state_var := IDLE;

                when DOOR_OPEN =>
                    door_open_var := '1';
                    next_state_var := DOOR_CLOSE;

                when DOOR_CLOSE =>
                    door_close_var := '1';
                    next_state_var := IDLE;
            end case;

            state      <= next_state_var;
            move_up    <= move_up_var;
            move_down  <= move_down_var;
            door_open_sig  <= door_open_var;
            door_close_sig <= door_close_var;
            current_floor_reg <= std_logic_vector(current_floor_s);
        end if;
    end process;
    
    -- Saída direta do registrador
    current_floor <= current_floor_reg;

end architecture;
