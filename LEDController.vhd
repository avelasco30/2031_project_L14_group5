-- LEDController.VHD
-- 2025.03.09
--
-- This SCOMP peripheral drives ten outputs high or low based on
-- a value from SCOMP.

library ieee;
library lpm;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use lpm.lpm_components.all;

entity ledcontroller is
port(
    clock       : in  std_logic;
    cs          : in  std_logic;
    write_en    : in  std_logic;
    resetn      : in  std_logic;
    leds        : out std_logic_vector(9 downto 0);
    io_data     : in  std_logic_vector(15 downto 0)
    );
end ledcontroller;

architecture a of ledcontroller is
    component singleledcontroller
        Port (
            latch       : in  std_logic;
            input_cycles : in  integer;
            total_cycles: in  integer;
            clock       : in  std_logic;
            led_out     : out std_logic
        );
    end component;

    signal latch_signals : std_logic_vector(9 downto 0) := "0000000000";
    signal on_cycles : integer := 0;
    signal total_cycles : integer := 31;

begin

    gen_led_controllers: for i in 0 to 9 generate
        LED_controller : singleledcontroller
            Port map (
                latch       => latch_signals(i),  -- Each instance gets its own latch signal
                input_cycles => on_cycles,
                total_cycles => total_cycles,
                clock       => clock,
                led_out     => leds(i)
            );
    end generate gen_led_controllers;

    process (resetn, cs)
    begin
        if (resetn = '0') then
            -- Turn off LEDs at reset (a nice usability feature)
				latch_signals <="0000000000";
				on_cycles <= 0;
            latch_signals <= "1111111111";
        elsif (rising_edge(cs)) then
            if write_en = '1' then
                -- If SCOMP is sending data to this peripheral,
                if (io_data(15) = '0') then
                    latch_signals <="0000000000";
                    on_cycles <= to_integer(unsigned(io_data(14 downto 10)));
                    latch_signals <= io_data(9 downto 0);
                else
                    -- For gamma correction on. May have to change later and remove this overarching if statement
						  latch_signals <= io_data(9 downto 0); --PLACEHOLDER CHANGE
                end if;
            end if;
        end if;
    end process;
end a;
