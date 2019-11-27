library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_flags is
generic (
		DATA_WIDTH: natural := 16
		);
		
	port(
		i_clk		:	in 	std_logic;		-- Clock
		i_rst		:	in 	std_logic;		-- Reset asincornico
		i_en		:	in 	std_logic;		-- Habilitacion
		i_srst	:	in 	std_logic;		-- Reset sincronico
		i_ld_en	:	in		std_logic;		-- Habilitacion de carga
		i_flags	:	in		std_logic_vector(3 downto 0);
		o_flags	:	out	std_logic_vector(3 downto 0)
	);
	
end reg_flags;

architecture Behavioral of reg_flags is
	signal q_reg: std_logic_vector (3 downto 0);
begin

	process (i_clk, i_rst) begin
		if (i_rst = '1') then q_reg <= (others => '0'); -- Reset asincornico
		elsif (rising_edge(i_clk)) then				-- Cuando flanco de clock ascendente
			if (i_en = '1') then  						-- Si el circuito esta habilitado...
				if ( i_srst = '1') then 					-- si i_srst=1
					q_reg <= (others => '0');				-- Reset sincronico
				elsif( i_ld_en = '1') then 				-- elsif
					q_reg <= i_flags;							-- registro(k)<=i_data
				end if;
			end if;
		end if;
	end process;
	
	o_flags(0) <= q_reg(0);
	o_flags(1) <= q_reg(1);
	o_flags(2) <= q_reg(2);
	o_flags(3) <= q_reg(3);


end Behavioral;

