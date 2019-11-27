library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
   port ( 
      i_instruction : in   STD_LOGIC_VECTOR (31 downto 0);
      o_instruction : out  STD_LOGIC_VECTOR (63 downto 0)
   );
end decoder;

architecture Behavioral of decoder is
   alias    src1      : std_logic_vector (3 downto 0) is i_instruction(31 downto 28);
   alias    src2      : std_logic_vector (3 downto 0) is i_instruction(27 downto 24);
   alias    rsvd      : std_logic_vector (3 downto 0) is i_instruction(23 downto 20);
   alias    inst      : std_logic_vector (3 downto 0) is i_instruction(19 downto 16);
   alias    const     : std_logic_vector(15 downto 0) is i_instruction(15 downto 00);
   
   constant rsvd4     : std_logic_vector (3 downto 0) := "0000";
   constant rsvd16    : std_logic_vector(15 downto 0) := (others => '0');

   constant OC_LD     : std_logic_vector (3 downto 0) := "0000";
   constant OC_LDC    : std_logic_vector (3 downto 0) := "0001";
   constant OC_AND    : std_logic_vector (3 downto 0) := "0010";
   constant OC_OR     : std_logic_vector (3 downto 0) := "0011";
   constant OC_XOR    : std_logic_vector (3 downto 0) := "0100";
   constant OC_NOT    : std_logic_vector (3 downto 0) := "0101";
   constant OC_SLL    : std_logic_vector (3 downto 0) := "0110";
   constant OC_SRL    : std_logic_vector (3 downto 0) := "0111";
   constant OC_ADD    : std_logic_vector (3 downto 0) := "1000";
   constant OC_ADDC   : std_logic_vector (3 downto 0) := "1001";
   constant OC_SUB    : std_logic_vector (3 downto 0) := "1010";
   constant OC_SUBC   : std_logic_vector (3 downto 0) := "1011";
   constant OC_CMP    : std_logic_vector (3 downto 0) := "1100";
   constant OC_CMPC   : std_logic_vector (3 downto 0) := "1101";
   constant OC_JMP    : std_logic_vector (3 downto 0) := "1110";
   constant OC_JMPC   : std_logic_vector (3 downto 0) := "1111";

   signal   DECO_LD   : std_logic_vector(63 downto 0);
   signal   DECO_LDC  : std_logic_vector(63 downto 0);
   signal   DECO_AND  : std_logic_vector(63 downto 0);
   signal   DECO_OR   : std_logic_vector(63 downto 0);
   signal   DECO_XOR  : std_logic_vector(63 downto 0);
   signal   DECO_NOT  : std_logic_vector(63 downto 0);
   signal   DECO_SLL  : std_logic_vector(63 downto 0);
   signal   DECO_SRL  : std_logic_vector(63 downto 0);
   signal   DECO_ADD  : std_logic_vector(63 downto 0);
   signal   DECO_ADDC : std_logic_vector(63 downto 0);
   signal   DECO_SUB  : std_logic_vector(63 downto 0);
   signal   DECO_SUBC : std_logic_vector(63 downto 0);
   signal   DECO_CMP  : std_logic_vector(63 downto 0);
   signal   DECO_CMPC : std_logic_vector(63 downto 0);
   signal   DECO_JMP  : std_logic_vector(63 downto 0);
   signal   DECO_JMPC : std_logic_vector(63 downto 0);
begin

   with inst select
      o_instruction <= DECO_LD         when OC_LD  ,
                       DECO_LDC        when OC_LDC ,
                       DECO_AND        when OC_AND ,
                       DECO_OR         when OC_OR  ,
                       DECO_XOR        when OC_XOR ,
                       DECO_NOT        when OC_NOT ,
                       DECO_SLL        when OC_SLL ,
                       DECO_SRL        when OC_SRL ,
                       DECO_ADD        when OC_ADD ,
                       DECO_ADDC       when OC_ADDC,
                       DECO_SUB        when OC_SUB ,
                       DECO_SUBC       when OC_SUBC,
                       DECO_CMP        when OC_CMP ,
                       DECO_CMPC       when OC_CMPC,
                       DECO_JMP        when OC_JMP ,
                       DECO_JMPC       when OC_JMPC,
                       (others => '0') when others ;

   DECO_LD   <= rsvd16 & rsvd4 & '0' & inst & "0100000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_LDC  <= rsvd16 & rsvd4 & '0' & inst & "1100000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_AND  <= rsvd16 & rsvd4 & '0' & inst & "0100000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_OR   <= rsvd16 & rsvd4 & '0' & inst & "0100000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_XOR  <= rsvd16 & rsvd4 & '0' & inst & "0100000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_NOT  <= rsvd16 & rsvd4 & '0' & inst & "0100000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_SLL  <= rsvd16 & rsvd4 & '0' & inst & "0100000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_SRL  <= rsvd16 & rsvd4 & '0' & inst & "0100000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_ADD  <= rsvd16 & rsvd4 & '0' & inst & "0110000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_ADDC <= rsvd16 & rsvd4 & '1' & inst & "0110000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_SUB  <= rsvd16 & rsvd4 & '0' & inst & "0110000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_SUBC <= rsvd16 & rsvd4 & '1' & inst & "0110000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_CMP  <= rsvd16 & rsvd4 & '0' & inst & "0010000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_CMPC <= rsvd16 & rsvd4 & '1' & inst & "0010000" & src1 & src2 & src1 & rsvd4 & const;
   DECO_JMP  <= rsvd16 & rsvd4 & '0' & inst & "0010010" & rsvd16 & const;
   DECO_JMPC <= rsvd16 & rsvd4 & '0' & inst & "001" & src1(1 downto 0) & "11" & rsvd16 & const;

end Behavioral;
