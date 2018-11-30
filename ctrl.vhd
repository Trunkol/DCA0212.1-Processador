-- controller
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEe.numeric_std.all;

entity ctrl is
  port ( rst   : in STD_LOGIC;
         start : in STD_LOGIC;
         clk   : in STD_LOGIC; 
         enb_acc : out std_LOGIC;
  			enb_br : out std_LOGIC;
         imm   : out std_logic_vector(3 downto 0);
			atv : out std_logic_vector(3 downto 0);
			out_op : out std_logic_vector( 3 downto 0)
			-- you will need to add more ports here as design grows
       );
end ctrl;

architecture fsm of ctrl is
  type state_type is (s0,s1,s2,s3,s4,s5,s6,done);
  signal state : state_type;  
  
	-- constants declared for ease of reading code
	
	constant mova    : std_logic_vector(3 downto 0) := "0000";
	constant movr    : std_logic_vector(3 downto 0) := "0001";
	constant load    : std_logic_vector(3 downto 0) := "0010";
	constant add	   : std_logic_vector(3 downto 0) := "0011";
   constant sub	   : std_logic_vector(3 downto 0) := "0100";
	constant andr    : std_logic_vector(3 downto 0) := "0101";
   constant orr     : std_logic_vector(3 downto 0) := "0110";
   constant jmp	   : std_logic_vector(3 downto 0) := "0111";
	constant inv     : std_logic_vector(3 downto 0) := "1000";
	constant halt	   : std_logic_vector(3 downto 0) := "1001";


	-- as you add more code for your algorithms make sure to increase the
	-- array size. ie. 2 lines of code here, means array size of 0 to 1.
	type PM_BLOCK is array (0 to 13) of std_logic_vector(7 downto 0);
	constant PM : PM_BLOCK := (	

	-- This algorithm loads an immediate value of 3 and then stops
    "00100100", -- load 4 
    "00010000", -- mvR	 
	 "00100001", -- load 1
	 "00110000", -- add
	 "00010000", -- mvR
	 "00101111", -- load 15
	 "01000000", -- sub
	 "00010000", -- mvR - reg00=1010
	 "00100000", -- load 0000
	 "01100000", -- reg00 or 0
	 "00100111", -- load 0111
	 "01010000", -- reg00 and 0
	 "10000000", -- inv
	 "10011111"  -- halt
    );
  		 
begin
	process (clk)
	-- these variables declared here don't change.
	-- these are the only data allowed inside
	-- our otherwise pure FSM
  
	variable IR : std_logic_vector(7 downto 0);
	variable OPCODE : std_logic_vector( 3 downto 0);
	variable ADDRESS : std_logic_vector (3 downto 0);
	variable PC : integer;
    
	begin
		-- don't forget to take care of rst
    
		if (clk'event and clk = '1') then			
      
      --
      -- steady state
      --
    
      case state is  
        when s0 =>    -- steady state
          PC := 0;
          imm <= "0000";
			 atv <=  "0000";
          if start = '1' then
            state <= s1;
          else 
            state <= s0;
          end if;
          
        when s1 =>				-- fetch instruction
          IR := PM(PC);
          OPCODE := IR(7 downto 4);
          ADDRESS:= IR(3 downto 0);
          state <= s2;
			 atv <=  "0001";
          
        when s2 =>				-- increment PC
          PC := PC + 1;
          state <= s3;
          atv <=  "0010";
          
        when s3 =>				-- decode instruction
          case OPCODE IS
            when load =>                       -- notice we can use
					imm <= address;                                    -- the instruction
					enb_acc <= '1';
					enb_br <= '1';	
					out_op<=OPCODE;
					atv <=  "0011";
					state <= s4; 
					
            when halt =>                      -- and the machine code                                 -- interchangeably
              state <= done;
				  out_op<=OPCODE;
              atv <=  "0011"; 

				when mova =>
					imm <= address;
					enb_acc <= '1';
					enb_br <= '1';
					out_op <= OPCODE;
					atv <=  "0011";
					state <= s4; 
					
				when movr =>
					imm <= address;
					enb_acc <= '0';
					enb_br <= '0';
					out_op<=OPCODE;
					atv <=  "0011";
					state <= s4; 
	  			
				when add =>
					imm <= address;
					enb_acc <= '1';
					enb_br <= '1';
					out_op<=OPCODE;
					atv <=  "0011";
					state <= s4; 
  			
				when sub =>
					imm <= address;
					enb_acc <= '1';
					enb_br <= '1';
					out_op<=OPCODE;
					atv <=  "0011";
					state <= s4; 
  			
				when andr =>
					imm <= address;
					enb_acc <= '1';
					enb_br <= '1';
					out_op<=OPCODE;
					atv <=  "0011";
					state <= s4; 
  			
		      when orr =>
					imm <= address;
					enb_acc <= '1';
					enb_br <= '1'; 
					out_op<=OPCODE;
					atv <=  "0011";
					state <= s4; 
  				
				when jmp =>
					imm <= address;
					enb_acc <= '0';
					enb_br <= '1';
					case address is
						when "0000" =>
						PC:=0;
						when "0001" =>
						PC:=1;
						when "0010" =>
						PC:=2;	
						when "0011" =>
						PC:=3;	
						when "0100" =>
						PC:=4;
						when "0101" =>
						PC:=5;
						when "0110" =>
						PC:=6;
						when "0111" =>
						PC:=7;
						when "1000" =>
						PC:=8;
						when "1001" =>
						PC:=9;
						when "1010" =>
						PC:=10;
						when "1011" =>
						PC:=11;
						when "1100" =>
						PC:=12;
						when "1101" =>
						PC:=13;
						when "1110" =>
						PC:=14;
						when "1111" =>
						PC:=15;
						when others =>
					 end case;
					out_op<=OPCODE;
					atv <=  "0011";
					state <= s4; 
	  			
				when inv =>
					imm <= address;
					enb_acc <= '1';
					enb_br <= '1';
					out_op<=OPCODE;
					atv <=  "0011";
					state <= s4; 
	  
				when others =>
				  state <= s1;
				  out_op <= OPCODE;
          end case;
        
			-- these states are the ones in which you actually
			-- start sending signals across
			-- to the datapath depending on what opcode is decoded.
			-- you add more states here.
          
        when s4 => --- BUSCAR NO REGISTRADOR
				atv <= "0100";
				state <= s5; 
		  when s5 => --- ENTRAR NA ALU
				atv <= "0101";
				state <= s6; 
		  when s6 => --- SALVAR NO ACC
				atv <= "0111";
				state <= s1; 
        when done =>                            -- stay here forever
          state <= done;  
        when others =>
      end case;
    end if;
  end process;	
end fsm;