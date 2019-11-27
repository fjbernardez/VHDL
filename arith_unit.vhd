library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity arith_unit is
	generic (
		DATA_WIDTH: natural := 16
	);
	port(
		i_op1: 	 in std_logic_vector(DATA_WIDTH-1 downto 0);
		i_op2: 	 in std_logic_vector(DATA_WIDTH-1 downto 0);
		i_opcode: in std_logic_vector(3 downto 0);
		o_result: out std_logic_vector(DATA_WIDTH-1 downto 0);
		o_flags:  out std_logic_vector(3 downto 0)
	);		
end arith_unit;

architecture rtl of arith_unit is  
  
	signal s_op1: 	signed(DATA_WIDTH-1 downto 0);
	signal s_op2: 	signed(DATA_WIDTH-1 downto 0);
	signal s_r:   	signed(DATA_WIDTH-1 downto 0);
	signal s_zero: 	std_logic;
	signal flag_z: 	std_logic;
	signal s_neg: 		std_logic; 
	signal flag_n:		std_logic;
	signal s_eq: 		std_logic;
	signal flag_eq:	std_logic;
	signal ov_ctrl: 	std_logic_vector(2 downto 0); 
	signal s_ov_a: 	std_logic;  -- OV por add
	signal s_ov_s: 	std_logic;	-- OV por sub
	signal s_ov: 		std_logic;
		
begin
   
	s_op1 <= signed(i_op1);  
	s_op2 <= signed(i_op2);
        
	-- Sumas y Restas
	with i_opcode select
		s_r <=  s_op1+s_op2		when "1000",   -- i_op1+i_op2
				s_op1+s_op2			when "1001",   -- i_op1+i_op2
				s_op1-s_op2 		when "1010",   -- i_op1-i_op2
				s_op1-s_op2 		when "1011",   -- i_op1-i_op2
				(others =>'0')  	when others;
				
				
	-- Flag Zero
	flag_z <= '1' when s_r = 0 else '0';
	with i_opcode(3 downto 2) select
		s_zero <=  flag_z 	when "10",  -- Solo en sumas o restas
					'0'			when others;
		
				
	-- Flag Negative 
	flag_n <= s_r(DATA_WIDTH-1);
	with i_opcode (3 downto 2) select  
		s_neg  <= flag_n  when "10", -- Solo en sumas o restas
				 '0'     	when others;  
			   
	-- Flag Equal
	flag_eq <= '1' when (s_op1 = s_op2) else '0';
	with i_opcode select
		s_eq  <=  flag_eq when "1100" | "1101" ,
			   	  '0'	  	when others;
			   	  
	-- Flag de Overflow
	
	-- Armo un vector auxiliar
	ov_ctrl <= s_r(DATA_WIDTH-1) & s_op2(DATA_WIDTH-1) & s_op1(DATA_WIDTH-1);
	
	-- OV por suma	
	with ov_ctrl select
		s_ov_a <= '1'  when "100" | "011",
				  '0' 	when others;
	-- OV por resta	  
	with ov_ctrl select
		s_ov_s <= '1'  when "110" | "001",
				  '0' 	when others; 
				  
	-- Indico OV solo en las operaciones suma y resta
	with i_opcode select
		s_ov <= s_ov_a    when "1000" | "1001",
				  s_ov_s		when "1010" | "1011",
				  '0'	 		when others;  	
	 
	-- Pongo el dato en la salida						
	o_result <= std_logic_vector(s_r);
    -- Armo la salida de o_flags concatenando todos los flags individuales 
	o_flags <= s_ov & s_eq & s_neg & s_zero;
			  
end architecture rtl;