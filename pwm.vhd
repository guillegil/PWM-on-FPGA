library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


------ Instantiation template ------ 
-- PWM_Inst:
--    entity Work.pwm
--        generic map(
--            INPUT_FREQUENCY_HZ      =>  10000000,
--            OUTPUT_FREQUENCY_HZ     =>  50,
--            DUTY_CYCLE_RESOLUTION   =>  4
--        )
--        port map(
--            CLK         =>  CLK,          -- Clock at INPUT_FREQUENCY_HZ
--            EN          =>  EN,           -- Enable port (active high)
--            CLR         =>  CLR,          -- Clear pwm output (active low)
--            DUTY_CYCLE  =>  DUTY_CYCLE,   -- Duty cycle selector
--            PWM_OUT     =>  PWM_OUT       -- PWM at OUTPUT_FREQUENCY_HZ      
--        );

entity pwm is
    generic(
        INPUT_FREQUENCY_HZ      :   natural := 10000000;
        OUTPUT_FREQUENCY_HZ     :   natural := 50;
        DUTY_CYCLE_RESOLUTION   :   natural := 4
    );
    port(
        CLK         : in std_logic;
        EN          : in std_logic;
        CLR         : in std_logic;
        DUTY_CYCLE  : in std_logic_vector(DUTY_CYCLE_RESOLUTION - 1 downto 0);
        PWM_OUT     : out std_logic;
        TICK_OUT    : out std_logic
    );
end pwm;

architecture rtl of pwm is

     function log2(val : integer) return natural is
         variable res : natural;
     begin
         for i in 0 to 31 loop
            if (val <= (2 ** i)) then
                res := i;
                exit;
            end if;
         end loop;
         
         return res;
     end function log2;


    constant MAX_COUNT  : integer := (INPUT_FREQUENCY_HZ / OUTPUT_FREQUENCY_HZ);
    constant RESOLUTION : integer := (MAX_COUNT / (2**DUTY_CYCLE_RESOLUTION));

    type rom_t is array(0 to 2**DUTY_CYCLE_RESOLUTION - 1) of integer;
    signal rom_mem : rom_t;

    signal frc : unsigned(log2(MAX_COUNT) - 1 downto 0) := (others => '0');     -- Free running counter     
    signal duty_tc, frc_tc : std_logic := '0';
    
begin

    
GENERATE_RES: 
    for idx in 0 to 2**DUTY_CYCLE_RESOLUTION - 1 generate
        rom_mem(idx) <= (idx * RESOLUTION);
    end generate;
    

    process
    begin
        wait until rising_edge(CLK);
        if EN = '1' then
            if frc_tc = '1' then
                frc <= (others => '0');
            else
                frc <= frc + 1;
            end if;
        end if;
    end process;


    frc_tc <= '1' when (frc = MAX_COUNT - 1) else '0';
    duty_tc <= '1' when frc = rom_mem(to_integer(unsigned(DUTY_CYCLE))) else '0';
    

    process
    begin
        wait until rising_edge(CLK);
        if frc_tc = '1' then    
            PWM_OUT <= '0';
        else    
            if duty_tc = '1' then
                PWM_OUT <= '1';
            end if;
        end if;
    end process;   
    
    TICK_OUT <= frc_tc;
    
end rtl;