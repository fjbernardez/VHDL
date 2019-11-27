library IEEE;
use IEEE.std_logic_1164.all;

entity reg_map is
	generic(
		DATA_WIDTH: natural := 16
	);
	port(
		i_clk		:	in 	std_logic;									-- Clock
		i_rst		:	in 	std_logic;									-- Reset asincornico
		i_en		:	in 	std_logic;									-- Habilitacion
		i_srst	:	in 	std_logic;									-- Reset sincronico
		i_data	:	in 	std_logic_vector(DATA_WIDTH-1 downto 0);	-- Dato de entrada
		i_ld_en	:  in 	std_logic_vector(3 downto 0);				-- Habilitacion de carga
		o_r0		: 	out 	std_logic_vector(DATA_WIDTH-1 downto 0);	-- Regristro de salida 0
		o_r1		: 	out 	std_logic_vector(DATA_WIDTH-1 downto 0);	-- Regristro de salida 1
		o_r2		: 	out 	std_logic_vector(DATA_WIDTH-1 downto 0);	-- Regristro de salida 2
		o_r3		: 	out 	std_logic_vector(DATA_WIDTH-1 downto 0)		-- Regristro de salida 3
	);
end reg_map;

architecture behavioral of reg_map is
	-- Declaro un tipo array, de elementos std_logic_vector(DATA_WIDTH-1 downto 0)
	type reg_array_t is array (3 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
	signal q_reg: reg_array_t;
	
begin
	reg_array:
	for k in 3 downto 0 generate begin
		process (i_clk, i_rst) begin
			if (i_rst = '1') then q_reg(k) <= (others => '0'); -- Reset asincornico
			
			elsif (rising_edge(i_clk)) then				-- Cuando flanco de clock ascendente
				if (i_en = '1') then  						-- Si el circuito esta habilitado...
					if ( i_srst = '1') then 					-- si i_srst=1
						q_reg(k) <= (others => '0');				-- Reset sincronico
					elsif( i_ld_en(k) = '1') then 				-- elsif
						q_reg(k) <= i_data;							-- registro(k)<=i_data
					end if;
				end if;
			end if;
		end process;
	end generate;
	
	o_r0 <= q_reg(0);
	o_r1 <= q_reg(1);
	o_r2 <= q_reg(2);
	o_r3 <= q_reg(3);
	
end architecture behavioral;