library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity rom_mult is
   port (
      i_address  : in  std_logic_vector (7 downto 0);
      o_data     : out std_logic_vector(31 downto 0)
   );
end rom_mult;

architecture program_rom of rom_mult is

   type rom_type is array (0 to 255) of std_logic_vector(0 to 31);
   signal   u_address : unsigned(7 downto 0);
   constant program   : rom_type := (
      0 => "00000000000100010000000000000000",
      1 => "00010000000100010000000000000110",
      2 => "00100000000100010000000000000101",
      3 => "00000001000010000000000000000000",
      4 => "00100000000110110000000000000001",
      5 => "00100000000111010000000000000000",
      6 => "00100000000111110000000000001000",
      7 => "00000000000111100000000000000011",
      8 => "00000000000111100000000000001000",
      others => (others => '0')
         );

begin

   u_address <= unsigned(i_address);
   o_data    <= program(to_integer(u_address));

end program_rom;