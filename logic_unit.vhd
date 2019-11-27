library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_unit is
generic (
		DATA_WIDTH: natural := 16
		);
	port(
		i_op1:in std_logic_vector(DATA_WIDTH-1 downto 0);
		i_op2:in std_logic_vector(DATA_WIDTH-1 downto 0);
		i_opcode:in std_logic_vector(3 downto 0);
		o_result:out std_logic_vector(DATA_WIDTH-1 downto 0)
		);
end logic_unit;

architecture rtl of logic_unit is
 signal s_result: std_logic_vector (DATA_WIDTH-1 downto 0);
begin
	-- Saliada para o_result
	with i_opcode select
		s_result <= i_op1 			   					when "0000",
					i_op1			  								when "0001",
					i_op1 and i_op2 							when "0010",
					i_op1 or  i_op2 							when "0011",
					i_op1 xor i_op2   						when "0100",
						  not (i_op1) 							when "0101",
					i_op1(DATA_WIDTH-2 downto 0) & '0' 	when "0110",  -- shift left
					'0' & i_op1(DATA_WIDTH-1 downto 1) 	when "0111",  -- shitf right
					i_op1 										when others;
						
	o_result <= s_result;
			  
end architecture rtl;