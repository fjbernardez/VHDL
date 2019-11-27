library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity al_unit is
	
	generic(
		DATA_WIDTH: natural :=16
	);
	
	port(
		i_op1 		: 	in  std_logic_vector(DATA_WIDTH-1 downto 0);
		i_op2 		: 	in  std_logic_vector(DATA_WIDTH-1 downto 0);
		i_opcode 	: 	in  std_logic_vector(3 downto 0);
		o_result		: 	out std_logic_vector(DATA_WIDTH-1 downto 0);
		o_flags 		: 	out std_logic_vector(3 downto 0)
	);

end al_unit;

-------------------------------------

architecture data_flow of al_unit is

	signal logic_result: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal arith_result: std_logic_vector (DATA_WIDTH-1 downto 0);
	
begin

	u_logic_unit: entity work.logic_unit
	generic map (DATA_WIDTH => DATA_WIDTH)
	port map(
		i_op1 	=>	i_op1,
		i_op2 	=>	i_op2,
		i_opcode =>	i_opcode,
		o_result =>	logic_result
	);
	
	u_arith_unit: entity work.arith_unit
	generic map (DATA_WIDTH => DATA_WIDTH)
	port map(
		i_op1 	=>	i_op1,
		i_op2 	=>	i_op2,
		i_opcode =>	i_opcode,
		o_result =>	arith_result,
		o_flags 	=> o_flags
	);
	
	o_result <= logic_result when i_opcode(3) = '0' else
					arith_result;
					
end data_flow;

