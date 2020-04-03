----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2020 02:16:49 PM
-- Design Name: 
-- Module Name: top - structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    port(
        CLK_P       :   in std_logic;
        CLK_N       :   in std_logic;
        GRST        :   in std_logic;
        LED         :   out std_logic;
        SPY         :   out std_logic
    );
end top;

architecture structural of top is

    signal clk : std_logic := '0';
    signal locked : std_logic := '0';
    signal rst : std_logic := '0';
    
    signal pwm_signal : std_logic := '0';
    
    signal div_q, div_n : natural range 0 to 39063 := 0;
    signal div_tick : std_logic := '0';
    
    signal frc : unsigned(7 downto 0) := (others => '0');
    signal count_dir : std_logic := '0';
    
    signal pwm_tick : std_logic := '0';
    
begin

MMCM:
    entity Work.clk_wiz_0
    port map(
        clk_in1_p   => CLK_P,
        clk_in1_n   => CLK_N,
        clk         => clk,
        locked      => locked
    );
    
    div_q <= div_n when rising_edge(clk);
    div_n <= div_q + 1 when div_tick = '0' else 0;
    div_tick <= '1' when div_q = 39062 else '0';
    
    process
    begin
        wait until rising_edge(CLK);
        if pwm_tick = '1' then
            if count_dir = '0' then
                if frc = 255 then
                    count_dir <= '1';
                else
                    frc <= frc + 1;
                end if;
            else
                if frc = 0 then
                    count_dir <= '0';
                else
                    frc <= frc - 1;
                end if;
            end if;
        end if;
    end process;
    
    rst <= '0' when (locked = '0' or GRST = '0') else '1';

PWM_Inst:
    entity Work.pwm
        generic map(
            INPUT_FREQUENCY_HZ      =>  10000000,
            OUTPUT_FREQUENCY_HZ     =>  200,
            DUTY_CYCLE_RESOLUTION   =>  8
        )
        port map(
            CLK         =>  clk,                    -- Clock at INPUT_FREQUENCY_HZ
            EN          =>  '1',                    -- Enable port (active high)
            CLR         =>  '1',                    -- Clear pwm output (active low)
            DUTY_CYCLE  =>  std_logic_vector(frc),  -- Duty cycle selector
            PWM_OUT     =>  pwm_signal,             -- PWM at OUTPUT_FREQUENCY_HZ      
            TICK_OUT    =>  pwm_tick
        );


    LED <= pwm_signal;
    SPY <= pwm_signal;

end structural;
