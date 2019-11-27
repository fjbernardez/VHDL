----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:24:11 10/30/2019
-- Design Name:
-- Module Name:    route_src - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity route_src is

	generic(DATA_WIDTH:natural:= 3);

	Port (

	i_r0 : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	i_r1 : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	i_r2 : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	i_r3 : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	i_const : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	i_sel_src1 : in  STD_LOGIC_VECTOR (1 downto 0);
	i_sel_src2 : in  STD_LOGIC_VECTOR (1 downto 0);
	i_const_en : in  STD_LOGIC;
	o_op1 : out  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
	o_op2 : out  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));

end route_src;

architecture Behavioral of route_src is
	--signal
	signal scndMux: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);

	begin
		
		--comienza las condiciones
		with i_sel_src1 select --señal de control
		o_op1 <=	i_r0 when "00",
		i_r1 when "01",
		i_r2 when "10",
		i_r3 when others;

		--prioridad en el enable
		o_op2 <= 	i_const when i_const_en = '1' else
			scndMux;

			--señal scndMux
			with i_sel_src2 select --señal
			scndMux <=	i_r0 when "00",
			i_r1 when "01",
			i_r2 when "10",
			i_r3 when others;

		end Behavioral;
