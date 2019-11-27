library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity rom_div is
   port (
      i_address  : in  std_logic_vector (7 downto 0);
      o_data     : out std_logic_vector(31 downto 0)
   );
end rom_div;

architecture program_rom of rom_div is

   type rom_type is array (0 to 255) of std_logic_vector(0 to 31);
   signal   u_address : unsigned(7 downto 0);
   constant program   : rom_type := (
      0 => "00000000000100010000000000011111",
      1 => "00010000000100010000000000000000",
      2 => "00100000000100010000000000000101",
      3 => "00010000000110010000000000000001",
      4 => "00000010000010100000000000000000",
      5 => "00010000000111110000000000000111",
      6 => "00000000000111100000000000000011",
      7 => "00000010000010000000000000000000",
      8 => "00010000000110110000000000000001",
      9 => "00000000000111100000000000001001",
      others => (others => '0')
         );

begin

   u_address <= unsigned(i_address);
   o_data    <= program(to_integer(u_address));

end program_rom;