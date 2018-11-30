library ieee;
use ieee.std_logic_1164.all;

entity DivisorFreq is
	port (clock_in : in std_logic;
			clock_out : out std_logic);
end DivisorFreq;

architecture DivisorFreq of DivisorFreq is
signal contagem : integer range 0 to 2:=1;
signal estado : std_logic:='0';
begin
	process(clock_in,contagem)
	begin
		if(clock_in='1' and clock_in 'EVENT) then
			if contagem = 2 then
				estado <= not estado;
				contagem <= 1;
			else
				contagem <= contagem + 1;
			end if;
		end if;
	end process;
	clock_out <= estado;
end DivisorFreq;