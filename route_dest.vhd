library IEEE;
use IEEE. std_logic_1164 .all;

entity route_dest is
	generic (
		DATA_WIDTH: natural := 16
		);
	port(
		i_data: 		in std_logic_vector(DATA_WIDTH-1 downto 0);
		i_const: 	in std_logic_vector(DATA_WIDTH-1 downto 0);
		
		i_sel_dest: in std_logic_vector(1 downto 0);
		i_const_en: in std_logic;
		
		o_data:		out std_logic_vector(DATA_WIDTH-1 downto 0);
		o_ld:			out std_logic_vector(3 downto 0)
		);
		
end route_dest;

architecture Behavioral of route_dest is
begin
	-- Saliada para o_ld
	with i_sel_dest select
		o_ld <=  "0001" when "00",
					"0010" when "01",
					"0100" when "10",
					"1000" when others;
				 
	-- Salida o_data
	--o_data <= i_const when (i_const_en = '1') else i_data;
	
	with i_const_en select
		o_data <= i_const when '1',
					 i_data when others;
				  
end architecture Behavioral;