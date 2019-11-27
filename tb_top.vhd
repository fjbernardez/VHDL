LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_top IS
   GENERIC (
      DATA_WIDTH: natural:= 16;
      ROM       : natural:= 1
   );    
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 

   --Inputs
   signal clk     : std_logic := '0';
   signal rst     : std_logic := '0';
   signal en      : std_logic := '0';
   signal srst    : std_logic := '0';

 	--Outputs
   signal o_flags : std_logic_vector           (3 downto 0);
   signal o_r0    : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal o_r1    : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal o_r2    : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal o_r3    : std_logic_vector(DATA_WIDTH-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.top GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH,
      ROM        => ROM       
   )
   PORT MAP (
      clk      => clk,
      rst      => rst,
      en       => en,
      srst     => srst,
      o_flags  => o_flags,
      o_r0     => o_r0,
      o_r1     => o_r1,
      o_r2     => o_r2,
      o_r3     => o_r3
   );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
      rst <= '1';
      wait for 100 ns;	
      rst <= '0';
      en  <= '1';
      wait for 50*clk_period;
      assert false
      severity failure;
   end process;

END;