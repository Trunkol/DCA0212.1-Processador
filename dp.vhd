-- datapath for microprocessor
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity alu is
  port ( 
	  	atv: in std_logic_vector( 3 downto 0);
		rst   : in STD_LOGIC;
        clk   : in STD_LOGIC;
		input : in std_logic_vector (3 downto 0);
		acc : in std_logic_vector(3 downto 0);
        imm   : in std_logic_vector(3 downto 0); 
		op : in std_logic_vector( 3 downto 0);	
        output: out STD_LOGIC_VECTOR (3 downto 0)
         -- insert ports as need be
       );
end alu;

architecture bhv of alu is

begin
	process (rst, clk)
	begin
	if(rst = '1') then
	output <= "0000";
	else
		case (atv) is
			when "0101" =>
			
			case (op) is
					when "0011" => --ADD
						output <= acc + input;
						
					when "0100" =>
						output <= acc - input; 
						
					when "0101" => 
						output <= acc and input; 
						
					when "0110" =>
						output <= acc or input; 
					
					when "1000" =>
						output <= not acc;
					
					when "0010" =>
						output <= imm;
						
					when others =>
						output <= input;
			end case;
			
			when others =>
		end case;	
end if;	
	end process;
	
end bhv;

-- *************************************************************************
-- The following is code for an accumulator. you need to figure out
-- the interconnections to the datapath
-- *************************************************************************
library IEEE;
use IEEE.std_logic_1164.all;

entity acc is
  port ( atv: in std_logic_vector( 3 downto 0);
			rst   : in STD_LOGIC;
         clk   : in STD_LOGIC;
         input : in STD_LOGIC_VECTOR (3 downto 0);
         enb   : in STD_LOGIC;
         output: out STD_LOGIC_VECTOR (3 downto 0)
       );
end acc;

architecture bhv of acc is
signal temp : STD_LOGIC_VECTOR(3 downto 0);
begin
	process (rst, input, enb, clk)
	begin
		if (rst = '1') then
			output <= "0000";
		elsif (clk'event and clk = '1') then
		case (atv) is
	   when "0111" =>
				if (enb = '1') then 
					output <= input;
					temp <= input;
				else
					output <= temp;
				end if;
		when others =>
      end case; 		
		end if;
	end process;
end bhv;

-- ***********************************************************************
-- the following is code for a register file. you may use your own design.
-- you also need to figure out how to connect this inyour datapath.

-- the way the rf works is: it 1st checks for the enable, then checks to
-- see which register is selected and outputs the input into the file. 
-- otherwise, the output will be whatever is stored in the selected register.
-- ***********************************************************************
library IEEE;
use IEEE.std_logic_1164.all;

entity rf is
  port (atv: in std_logic_vector( 3 downto 0);
			rst    : in STD_LOGIC;
         clk    : in STD_LOGIC;
         input  : in std_logic_vector(3 downto 0);
         sel    : in std_logic_vector(1 downto 0);
         enb    : in std_logic;
         output : out std_logic_vector(3 downto 0)
       );
		
end rf;

architecture bhv of rf is
signal out0, out1, out2, out3 : std_logic_vector(3 downto 0);
begin
	process (rst, clk)
	begin
		-- take care of rst state
		if (rst = '1') then
			out0 <= "0000";
			out1 <= "0000";
			out2 <= "0000";
			out3 <= "0000";

		elsif(clk'event and clk = '1')then
			case (atv) is
				when "0100" =>
					if enb = '0' then
						case (sel) is
							when "00" => 
								out0 <= input;
							when "01" =>
								out1 <= input; 
							when "10" => 
								out2 <= input; 
							when "11" =>
								out3 <= input; 
							when others =>
						end case;
					else
			
						case (sel) is
							when "00" =>
								output <= out0;
							when "01" =>
								output <= out1;
							when "10" =>
								output <= out2;
							when "11" =>
								output <= out3;
							when others =>
						end case;
					end if;
				when others =>
			end case;	
		end if;
	end process;	
end bhv;

library IEEE;
use IEEE.std_logic_1164.all;

entity dp is
  port ( rst     : in STD_LOGIC;
         clk     : in STD_LOGIC;
         imm     : in std_logic_vector(3 downto 0); 
			enb_acc : in std_LOGIC;
  			enb_br : in std_LOGIC;	
			op : in std_logic_vector( 3 downto 0);
			atv: in std_logic_vector( 3 downto 0);
         output_4: out STD_LOGIC_VECTOR (3 downto 0)
         --add ports as required
       );
end dp;

architecture rtl2 of dp is

component alu is
  port ( atv: in std_logic_vector( 3 downto 0);
			rst   : in STD_LOGIC;
         clk   : in STD_LOGIC;
			input : in std_logic_vector (3 downto 0);
			acc : in std_logic_vector(3 downto 0);
         imm   : in std_logic_vector(3 downto 0); 
			op : in std_logic_vector( 3 downto 0);	
         output: out STD_LOGIC_VECTOR (3 downto 0)
         -- add ports as required
    );
end component;
component acc is
  port ( atv: in std_logic_vector( 3 downto 0);
			rst   : in STD_LOGIC;
         clk   : in STD_LOGIC;
         input : in STD_LOGIC_VECTOR (3 downto 0);
         enb   : in STD_LOGIC;
         output: out STD_LOGIC_VECTOR (3 downto 0)
       );
end component;
component rf is
  port ( atv: in std_logic_vector( 3 downto 0);
			rst    : in STD_LOGIC;
         clk    : in STD_LOGIC;
         input  : in std_logic_vector(3 downto 0);
         sel    : in std_logic_vector(1 downto 0);
         enb    : in std_logic;
         output : out std_logic_vector(3 downto 0)
       );
		
end component;

-- maybe we should add the other components here......

signal alu_out: std_logic_vector(3 downto 0);
signal acc_out: std_logic_vector(3 downto 0);
signal br_out: std_logic_vector(3 downto 0);
-- maybe we should add signals for interconnections here.....

begin
   BR: rf port map (atv, rst, clk, acc_out, imm(3 downto 2), enb_br, br_out);
	alu1: alu port map (atv, rst,clk, br_out, acc_out, imm, op, alu_out);
	ACU: acc port map (atv, rst,clk,alu_out,enb_acc, acc_out);
	-- maybe this is were we add the port maps for the other components.....

	process (rst, clk)
		begin

			-- this you should change so the output actually
			-- comes from the accumulator so it follows the
			-- instruction set. since the accumulator is always 
			-- involved we want to be able to see the
			-- results/data changes on the acc.

			-- take care of reset state
		  
			output_4 <= acc_out;
		
   end process;
end rtl2;