library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
   generic (
      DATA_WIDTH: natural := 16;
      ROM       : natural := 0
   );
   port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      en      : in  std_logic;
      srst    : in  std_logic;
      o_flags : out std_logic_vector(3 downto 0);
      o_r0    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      o_r1    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      o_r2    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      o_r3    : out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end top;

architecture structural of top is

   signal r0_q                : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal r1_q                : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal r2_q                : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal r3_q                : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal op1                 : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal op2                 : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal result              : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal flags_al            : std_logic_vector           (3 downto 0);
   signal flags_reg           : std_logic_vector           (3 downto 0);
   signal ld_data             : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal ld_en_data          : std_logic_vector           (3 downto 0);
   signal pc_addr             : std_logic_vector           (7 downto 0);
   signal instruction         : std_logic_vector          (31 downto 0);
   signal deco_inst           : std_logic_vector          (63 downto 0);
   
   alias  route_src_const_en  : std_logic                      is deco_inst(43);
   alias  alu_opcode          : std_logic_vector (3 downto 0)  is deco_inst(42 downto 39);
   alias  route_dest_const_en : std_logic                      is deco_inst(38);
   alias  regmap_en           : std_logic                      is deco_inst(37);
   alias  ld_en_flags         : std_logic                      is deco_inst(36);
   alias  pc_jump_sel         : std_logic_vector (1 downto 0)  is deco_inst(35 downto 34);
   alias  pc_jump_e           : std_logic                      is deco_inst(33);
   alias  pc_cond_e           : std_logic                      is deco_inst(32);
   alias  dest                : std_logic_vector (1 downto 0)  is deco_inst(29 downto 28);
   alias  src2                : std_logic_vector (1 downto 0)  is deco_inst(25 downto 24);
   alias  src1                : std_logic_vector (1 downto 0)  is deco_inst(21 downto 20);
   alias  const               : std_logic_vector(15 downto 0)  is deco_inst(15 downto 00);
   
begin

   u_route_src: entity work.route_src
   generic map(
      DATA_WIDTH => DATA_WIDTH
   )
   port map(
      i_r0       => r0_q              ,
      i_r1       => r1_q              ,
      i_r2       => r2_q              ,
      i_r3       => r3_q              ,
      i_const    => const             ,
      i_sel_src1 => src1              ,
      i_sel_src2 => src2              ,
      i_const_en => route_src_const_en,
      o_op1      => op1               ,
      o_op2      => op2
   );

   u_al_unit: entity work.al_unit
   generic map(
      DATA_WIDTH => DATA_WIDTH
   )
   port map(
      i_op1    => op1       ,
      i_op2    => op2       ,
      i_opcode => alu_opcode,
      o_result => result    ,
      o_flags  => flags_al
   );
   
   u_reg_flags: entity work.reg_flags
   generic map(
      DATA_WIDTH => DATA_WIDTH
   )
   port map(
      i_clk   => clk        ,
      i_rst   => rst        ,
      i_en    => en         ,
      i_srst  => srst       ,
      i_flags => flags_al   ,
      i_ld_en => ld_en_flags,
      o_flags => flags_reg
   );

   u_route_dest: entity work.route_dest
   generic map(
      DATA_WIDTH => DATA_WIDTH
   )
   port map(
      i_data     => result    ,
      i_const    => const     ,
      i_sel_dest => src1      ,
      i_const_en => route_dest_const_en  ,
      o_data     => ld_data   ,
      o_ld       => ld_en_data
   );
   
   GEN_ROM_0:
   if ROM = 0 generate begin
      u_rom: entity work.rom_mult
      port map(
         i_address => pc_addr    ,
         o_data    => instruction 
      );
   end generate;
   
   GEN_ROM_1:
   if ROM = 1 generate begin
      u_rom: entity work.rom_div
      port map(
         i_address => pc_addr    ,
         o_data    => instruction 
      );
   end generate;
   
   u_deco: entity work.decoder
   port map(
      i_instruction => instruction,
      o_instruction => deco_inst 
   );
   
   u_reg_map: entity work.reg_map
   generic map(
      DATA_WIDTH => DATA_WIDTH
   )
   port map(
      i_clk   => clk       ,
      i_rst   => rst       ,
      i_en    => regmap_en ,
      i_srst  => srst      ,
      i_data  => ld_data   ,
      i_ld_en => ld_en_data,
      o_r0    => r0_q      ,
      o_r1    => r1_q      ,
      o_r2    => r2_q      ,
      o_r3    => r3_q
   );

   u_pc: entity work.pc_counter
   generic map(
      N_COND   => 4,
      PC_WIDTH => 8
   )
   port map(
      i_clk        => clk        ,
      i_rst        => rst        ,
      i_en         => en         ,
      i_srst       => srst       ,
      i_jump_e     => pc_jump_e  ,
      i_cond_e     => pc_cond_e  ,
      i_jump_sel   => pc_jump_sel,
      i_cond_vec   => flags_reg  ,
      i_const_addr => const(7 downto 0),
      o_pc_addr    => pc_addr
   );
   
   o_flags <= flags_reg;
   o_r0    <= r0_q;
   o_r1    <= r1_q;
   o_r2    <= r2_q;
   o_r3    <= r3_q;  

end structural;
