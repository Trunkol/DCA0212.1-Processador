-- cpu (top level entity)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- these should probably stay the same
entity cpu is
   port (rst     : in STD_LOGIC;
			start   : in STD_LOGIC;
         clock     : in STD_LOGIC;
			output  : out STD_LOGIC_VECTOR (3 downto 0);
      	led1 : out STD_LOGIC_VECTOR (6 downto 0);
			led2 : out STD_LOGIC_VECTOR (6 downto 0);
			op0 : out STD_LOGIC_VECTOR (6 downto 0);
			op1 : out STD_LOGIC_VECTOR (6 downto 0);
			op2 : out STD_LOGIC_VECTOR (6 downto 0);
			op3 : out STD_LOGIC_VECTOR (6 downto 0)
          -- add ports as required
        );
end cpu;

-- these will change as your design grows
architecture struc of cpu is
component ctrl 
   port ( rst   : in STD_LOGIC;
         start : in STD_LOGIC;
         clk   : in STD_LOGIC; 
         enb_acc : out std_LOGIC;
  			enb_br : out std_LOGIC;
         imm   : out std_logic_vector(3 downto 0);
			atv : out std_logic_vector(3 downto 0);
			out_op : out std_logic_vector( 3 downto 0)
          -- add ports as required
        );
end component;

component dp
   port ( rst     : in STD_LOGIC;
         clk     : in STD_LOGIC;
         imm     : in std_logic_vector(3 downto 0); 
			enb_acc : in std_LOGIC;
  			enb_br : in std_LOGIC;	
			op : in std_logic_vector( 3 downto 0);
			atv: in std_logic_vector( 3 downto 0);
         output_4: out STD_LOGIC_VECTOR (3 downto 0)
          -- add ports as required
        );
end component;

component DivisorFreq is
	port (clock_in : in std_logic;
			clock_out : out std_logic);
end component;


signal immediate : std_logic_vector(3 downto 0);
signal cpu_out : std_logic_vector(3 downto 0);
signal out_op : std_logic_vector( 3 downto 0);
signal enb_acc : std_LOGIC;
signal enb_br :  std_LOGIC;
signal atv : std_logic_vector( 3 downto 0);
signal clk : std_logic;
begin

-- notice how the output from the datapath is tied to a signal
-- this output signal is then used as input for a decoder.
-- we can also see the output as "output".
-- the output from the datapath should be coming from the accumulator.
-- this is because all actions take place on the accumulator, including
-- all results of any alu operation. naturally, this is because of the 
-- nature of the instruction set.

  Divfreq: DivisorFreq port map (not clock, clk);
  controller: ctrl port map(rst, start, clk,enb_acc,enb_br,immediate, atv, out_op);
  datapath: dp port map(rst, clk, immediate, enb_acc, enb_br, out_op, atv, cpu_out);

  process(rst, clk, cpu_out)
  begin

    -- take care of rst case here

    if(clk'event and clk='1') then
    output <= cpu_out;
    -- this acts like a BCD to 7-segment decoder,
    -- can see output in waveforms as cpu_out
       case cpu_out is
        when "0000" =>
			led1 <= "0000001";
			led2 <= "0000001";
        when "0001" =>
			led1 <= "1001111";
			led2 <= "0000001";
        when "0010" =>
			led1 <= "0010010";
			led2 <= "0000001";	
        when "0011" =>
			led1 <= "0000110";
			led2 <= "0000001";	
        when "0100" =>
			led1 <= "1001100"; 
			led2 <= "0000001";
        when "0101" =>
			led1 <= "0100100"; 
			led2 <= "0000001";
        when "0110" =>
			led1 <= "0100000";
			led2 <= "0000001";
        when "0111" =>
			led1 <= "0001111";
			led2 <= "0000001";
        when "1000" =>
			led1 <= "0000000"; 
			led2 <= "0000001";
        when "1001" =>
			led1 <= "0000010";
			led2 <= "0000001";
		when "1010" =>
			led1 <= "0000001";
			led2 <= "1001111";
		when "1011" =>
			led1 <= "1001111";
			led2 <= "1001111";
		when "1100" =>
			led1 <= "0010010";
			led2 <= "1001111";
		when "1101" =>
			led1 <= "0000110";
			led2 <= "1001111";
		when "1110" =>
			led1 <= "1001100"; 
			led2 <= "1001111";
		when "1111" =>
			led1 <= "0100100"; 
			led2 <= "1001111";
         when others =>
       end case;
	   
			case out_op(0) is
				when '0' =>
					op0 <= "0000001"; 
				when '1' =>
					op0 <= "1001111";
			end case;
			
			case out_op(1) is
				when '0' =>
					op1 <= "0000001"; 
				when '1' =>
					op1 <= "1001111";
			end case;
		
			case out_op(2) is
				when '0' =>
					op2 <= "0000001"; 
				when '1' =>
					op2 <= "1001111";
			end case;
			
			case out_op(3) is
				when '0' =>
					op3 <= "0000001"; 
				when '1' =>
					op3 <= "1001111";
			end case;
    end if;
  end process;							

end struc;



