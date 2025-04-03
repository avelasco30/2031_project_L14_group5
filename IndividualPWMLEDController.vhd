-- IndividualPWMLEDController.vhd
-- 2025.04.03
--
-- Takes in PWM cycle data and controls an LED's brightness
-- TODO: find a better file and entity name
-- TODO: potentially add state selector so "set brightness", "increase brightness", etc.
-- Maybe implement gamma correction in this component if increment options are added

library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use lpm.lpm_components.all;

entity singleledcontroller is
port(
    latch       : in  std_logic; -- Latches cycle data to saved state when 1
    input_cycles : in  integer;   -- Number of clock ticks you want the led to be on
    total_cycles: in  integer;   -- Total number of clock ticks total for a PWM period so total_cycles <= 63 when you have 64 total brightness levels, 0-63
    clock       : in  std_logic; -- Referenced for PWM brightness
    led_out     : out std_logic  -- Physical output for a singular LED
    );
end singleledcontroller; 

-- Example: input_cycles: 3, total_cycles: 7 so then positive duty cycle is 3/7
--    
-- high:  ______        ______        ______    
-- low:         ________      ________      ________ ...  Duty Cycle 3/7
-- tick:  1 2 3 4 5 6 7 1 2 3 4 5 6 7 1 2 3 4 5 6 7

architecture a of singleledcontroller is
begin
    process (latch, clock)
        variable total_count  : integer := 0; -- Saved total amount of clock cycles in one PWM period
        variable on_count     : integer := 0; -- Saved amount of clock cycles where LED is on
        variable ticks        : integer := 1; -- Counter for clock ticks to determine LED state if counter <= on_count, LED is on, else LED is off
    begin
        if (latch = '1') then -- latch necessary values
            total_count := total_cycles; 
            on_count := input_cycles;
            ticks := 1; -- Reset the tick counter when latching new values
        end if;

        if (rising_edge(clock)) then
            -- Increment tick counter
            if (ticks < total_count) then
                ticks := ticks + 1;
            else
                ticks := 1;  -- Reset ticks when we exceed total count
            end if;

            -- turn LED on or off based on on_count
            if (ticks <= on_count) then
                led_out <= '1';  -- LED is on
            else
                led_out <= '0';  -- LED is off
            end if;
        end if;
    end process;
end a;
