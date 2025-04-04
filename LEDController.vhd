-- LEDController.VHD
-- 2025.03.09
--
-- This SCOMP peripheral controls 10 LEDs for 64 gamma-corrected brightness levels
-- This uses a gamma value of 2 for a balance between accuracy and ease of computation

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
    signal total_cycles : integer := 3969; -- 63^2 clock ticks is our total duty cycle period so that gamma correction can be implemented

begin

    gen_led_controllers: for i in 0 to 9 generate
        LED_controller : singleledcontroller
            Port map (
                latch       => latch_signals(i),  -- Each instance gets its own latch signal
                input_cycles => on_cycles, -- Shared bus for on_cycles
                total_cycles => total_cycles, -- Shared bus for total_cycles
                clock       => clock, -- Shared clock signal for all 10 submodules
                led_out     => leds(i) -- Each submodule outputs to a singular LED
            );
    end generate gen_led_controllers;

    process (resetn, cs)
        variable brightness : integer;  -- Brightness value. Note: Max brightness is 63
    begin
        if (resetn = '0') then
            -- Turn off LEDs at reset (a nice usability feature)
            on_cycles <= 0;
            latch_signals <= "1111111111";
        elsif (rising_edge(cs)) then
            if write_en = '1' then
                -- If SCOMP is sending data to this peripheral,
                brightness := to_integer(unsigned(io_data(15 downto 10))); -- Determine desired brightness level
                on_cycles <= brightness * brightness; -- Assign squared brightness value so that gamma value is 2
                latch_signals <= io_data(9 downto 0); -- Latch the brightness onto selected LEDs
            else
                latch_signals <="0000000000";
            end if;
        end if;
    end process;
end a;
