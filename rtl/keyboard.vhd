--//============================================================================
--//  MSX1
--//  Keyboard matrix maping
--//  Copyright (C) 2021 molekula
--//
--//  This program is free software; you can redistribute it and/or modify it
--//  under the terms of the GNU General Public License as published by the Free
--//  Software Foundation; either version 2 of the License, or (at your option)
--//  any later version.
--//
--//  This program is distributed in the hope that it will be useful, but WITHOUT
--//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
--//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
--//  more details.
--//
--//  You should have received a copy of the GNU General Public License along
--//  with this program; if not, write to the Free Software Foundation, Inc.,
--//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
--//
--//============================================================================
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity keyboard is
	port (
		reset_n_i    : in  std_logic;
		clk_i        : in  std_logic;
		ps2_code_i   : in  std_logic_vector(10 downto 0);
		kb_addr_i		: in  std_logic_vector(3 downto 0);
		kb_data_o		: out std_logic_vector(7 downto 0)
	);
end keyboard;


architecture rtl of keyboard is
	type keyMatrixType is array(8 downto 0) of std_logic_vector(7 downto 0);
	signal keyMatrix : keyMatrixType := (others => (others => '1'));
	signal scancode : std_logic_vector(7 downto 0);
	signal changed : std_logic := '0';
	signal release_signal : std_logic := '1';
	signal shift : std_logic_vector(1 downto 0) := (others => '1');
  	
begin
	kb_data_o <= keyMatrix(to_integer(unsigned(kb_addr_i)))(7 downto 0) 
				 when to_integer(unsigned(kb_addr_i)) < 9 
				 else (others => '1');
	 
	change : process (clk_i)
	variable old_code : std_logic_vector(10 downto 0) := (others=>'0');  
	begin
		if clk_i'event and clk_i = '1' then	
			if old_code /= ps2_code_i then
				release_signal <=  NOT ps2_code_i(9);
				scancode <= ps2_code_i(7 downto 0);
				changed <= '1';
			else
				changed <= '0';
			end if;
			old_code := ps2_code_i;
		end if;
	end process;
  
	decode : process (clk_i)
	begin
		if clk_i'event and clk_i = '1' then	
			if changed = '1' then
				if ps2_code_i(8) = '0' then
					case scancode is
						-- 0
						when x"45" => keyMatrix(0)(0) <= release_signal; -- 0
						when x"16" => keyMatrix(0)(1) <= release_signal; -- 1
						when x"1e" => keyMatrix(0)(2) <= release_signal; -- 2
						when x"26" => keyMatrix(0)(3) <= release_signal; -- 3
						when x"25" => keyMatrix(0)(4) <= release_signal; -- 4        
						when x"2e" => keyMatrix(0)(5) <= release_signal; -- 5
						when x"36" => keyMatrix(0)(6) <= release_signal; -- 6
						when x"3d" => keyMatrix(0)(7) <= release_signal; -- 7
						-- 1
						when x"3e" => keyMatrix(1)(0) <= release_signal; -- 8
						when x"46" => keyMatrix(1)(1) <= release_signal; -- 9
						when x"4e" => keyMatrix(1)(2) <= release_signal; -- -
						when x"55" => keyMatrix(1)(3) <= release_signal; -- =
						when x"5d" => keyMatrix(1)(4) <= release_signal; -- \
						when x"54" => keyMatrix(1)(5) <= release_signal; -- [
						when x"5b" => keyMatrix(1)(6) <= release_signal; -- ]
						when x"4c" => keyMatrix(1)(7) <= release_signal; -- ;
						-- 2
						when x"52" => keyMatrix(2)(0) <= release_signal; -- '
						when x"0e" => keyMatrix(2)(1) <= release_signal; -- `
						when x"41" => keyMatrix(2)(2) <= release_signal; -- ,
						when x"49" => keyMatrix(2)(3) <= release_signal; -- .
						when x"4a" => keyMatrix(2)(4) <= release_signal; -- /				  
						when x"01" => keyMatrix(2)(5) <= release_signal; -- F11 (DEAD KEY)
						when x"1c" => keyMatrix(2)(6) <= release_signal; -- A
						when x"32" => keyMatrix(2)(7) <= release_signal; -- B
						-- 3
						when x"21" => keyMatrix(3)(0) <= release_signal; -- C
						when x"23" => keyMatrix(3)(1) <= release_signal; -- D
						when x"24" => keyMatrix(3)(2) <= release_signal; -- E
						when x"2b" => keyMatrix(3)(3) <= release_signal; -- F
						when x"34" => keyMatrix(3)(4) <= release_signal; -- G				  
						when x"33" => keyMatrix(3)(5) <= release_signal; -- H
						when x"43" => keyMatrix(3)(6) <= release_signal; -- I
						when x"3b" => keyMatrix(3)(7) <= release_signal; -- J
						-- 4
						when x"42" => keyMatrix(4)(0) <= release_signal; -- K
						when x"4b" => keyMatrix(4)(1) <= release_signal; -- L
						when x"3a" => keyMatrix(4)(2) <= release_signal; -- M
						when x"31" => keyMatrix(4)(3) <= release_signal; -- N
						when x"44" => keyMatrix(4)(4) <= release_signal; -- O				  
						when x"4d" => keyMatrix(4)(5) <= release_signal; -- P
						when x"15" => keyMatrix(4)(6) <= release_signal; -- Q
						when x"2d" => keyMatrix(4)(7) <= release_signal; -- R
						-- 5
						when x"1b" => keyMatrix(5)(0) <= release_signal; -- S
						when x"2c" => keyMatrix(5)(1) <= release_signal; -- T
						when x"3c" => keyMatrix(5)(2) <= release_signal; -- U
						when x"2a" => keyMatrix(5)(3) <= release_signal; -- V
						when x"1d" => keyMatrix(5)(4) <= release_signal; -- W				  
						when x"22" => keyMatrix(5)(5) <= release_signal; -- X
						when x"35" => keyMatrix(5)(6) <= release_signal; -- Y
						when x"1a" => keyMatrix(5)(7) <= release_signal; -- Z
						-- 6
						when x"12" => shift(0) <= release_signal; -- LEFT SHIFT
						when x"59" => shift(1) <= release_signal; -- RIGHT SHIFT
						when x"14" => keyMatrix(6)(1) <= release_signal; -- LEFT CTRL
						-- when x"11" => keyMatrix(6)(2) <= release_signal; -- RIGHT ALT (GRAPH)
						when x"58" => keyMatrix(6)(3) <= release_signal; -- CAPS LOCK
						when x"09" => keyMatrix(6)(4) <= release_signal; -- F10 (CODE)
						when x"05" => keyMatrix(6)(5) <= release_signal; -- F1
						when x"06" => keyMatrix(6)(6) <= release_signal; -- F2
						when x"04" => keyMatrix(6)(7) <= release_signal; -- F3
						-- 7
						when x"0c" => keyMatrix(7)(0) <= release_signal; -- F4
						when x"03" => keyMatrix(7)(1) <= release_signal; -- F5  
						when x"76" => keyMatrix(7)(2) <= release_signal; -- ESC
						when x"0D" => keyMatrix(7)(3) <= release_signal; -- TAB
						-- when x"E1" => keyMatrix(7)(4) <= release_signal; -- pause/break (STOP)
						when x"66" => keyMatrix(7)(5) <= release_signal; -- BACKSPACE
						when x"78" => keyMatrix(7)(6) <= release_signal; -- F11 (SELECT)
						when x"5a" => keyMatrix(7)(7) <= release_signal; -- ENTER
						-- 8
						when x"29" => keyMatrix(8)(0) <= release_signal; -- SPACE
						-- when x"6c" => keyMatrix(8)(1) <= release_signal; -- HOME
						-- when x"70" => keyMatrix(8)(2) <= release_signal; -- INS
						-- when x"71" => keyMatrix(8)(3) <= release_signal; -- DEL
						-- when x"6B" => keyMatrix(8)(4) <= release_signal; -- LEFT ARROW
						-- when x"75" => keyMatrix(8)(5) <= release_signal; -- UP ARROW
						-- when x"72" => keyMatrix(8)(6) <= release_signal; -- DOWN ARROW
						-- when x"74" => keyMatrix(8)(7) <= release_signal; -- RIGH ARROW
						when others =>null; 
					end case;
				else 
					case scancode is
					   when x"11" => keyMatrix(6)(2) <= release_signal; -- RIGHT ALT (GRAPH)
					   when x"7c" => keyMatrix(7)(4) <= release_signal; -- Print Screen (STOP)
						when x"6c" => keyMatrix(8)(1) <= release_signal; -- HOME
						when x"70" => keyMatrix(8)(2) <= release_signal; -- INS
						when x"71" => keyMatrix(8)(3) <= release_signal; -- DEL
						when x"6B" => keyMatrix(8)(4) <= release_signal; -- LEFT ARROW
						when x"75" => keyMatrix(8)(5) <= release_signal; -- UP ARROW
						when x"72" => keyMatrix(8)(6) <= release_signal; -- DOWN ARROW
						when x"74" => keyMatrix(8)(7) <= release_signal; -- RIGH ARROW
						when others =>null; 
					end case;
				end if;
			end if;
		end if;
		keyMatrix(6)(0) <= shift(0) and shift(1);
	end process;
end; 
