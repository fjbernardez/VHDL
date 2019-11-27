library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity pc_counter is
	generic(
      N_COND   : natural := 4;
      PC_WIDTH : natural := 8
	);
	port(
		i_clk				:	in 	std_logic;		-- Clock
		i_rst				:	in 	std_logic;		-- Reset asincornico
		i_en				:	in 	std_logic;		-- Habilitacion
		i_srst			:	in 	std_logic;		-- Reset sincronico
		
		i_jump_e			: 	in 	std_logic;
		i_cond_e			: 	in 	std_logic;
		i_jump_sel		:	in 	std_logic_vector (1 downto 0);
		i_cond_vec		:	in		std_logic_vector (N_COND-1 downto 0);
		i_const_addr	:	in		std_logic_vector (PC_WIDTH-1 downto 0);
		o_pc_addr		:	out	std_logic_vector (PC_WIDTH-1 downto 0)
	);
end pc_counter;

architecture Behavioral of pc_counter is
	signal pc_reg	  	:	unsigned (PC_WIDTH-1 downto 0);
	signal pc_next	  	:	unsigned (PC_WIDTH-1 downto 0);
	signal const_addr	:	unsigned (PC_WIDTH-1 downto 0);
	signal sel_count 	:	std_logic;
begin

	-- Flip-Flop
	process (i_clk, i_rst) begin
		if (i_rst = '1') then pc_reg <= (others => '0'); 	-- Reset asincornico
		elsif (rising_edge(i_clk)) then		-- Cuando flanco de clock ascendente
			if (i_en = '1') then  					-- Si el circuito esta habilitado...
				if ( i_srst = '1') then 				-- si i_srst=1
					pc_reg <= (others => '0');				-- Reset sincronico
				else											-- else
					pc_reg <= pc_next;						-- Actualizo pc_reg				
				end if;
			end if;
		end if;
	end process;
	
	-- Logica de estado futuro
	process (i_jump_e, i_cond_e, i_jump_sel, i_cond_vec) begin
		if(i_jump_e = '1') then
			if(i_cond_e = '0') then
				sel_count <= '1';
			else
			
				if( i_jump_sel = "00") then
					if(i_cond_vec(0)='1') then
						sel_count <= '1';
					else 
						sel_count <= '0';
					end if;

				elsif( i_jump_sel = "01") then
					if(i_cond_vec(1)='1') then
						sel_count <= '1';
					else 
						sel_count <= '0';
					end if;

				elsif( i_jump_sel = "10") then
					if(i_cond_vec(2)='1') then
						sel_count <= '1';
					else 
						sel_count <= '0';
					end if;
					
				elsif ( i_jump_sel = "11") then
					if(i_cond_vec(3)='1') then
						sel_count <= '1';
					else 
						sel_count <= '0';
					end if;
					
				end if;
				
			end if;
		else
			sel_count <= '0';
		end if;
		
	end process;
	
	const_addr <= unsigned (i_const_addr);
	pc_next <=  pc_reg+1  when sel_count = '0' else const_addr ;
	
	-- Salida
	o_pc_addr <= std_logic_vector(pc_reg);


end Behavioral;








