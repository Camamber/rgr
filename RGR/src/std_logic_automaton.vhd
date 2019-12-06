library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity std_logic_automaton is
	generic (TZ: time := 0ns);
	port (
		X: in bit_vector(1 downto 0);
		Y: out std_logic_vector(0 downto 0)
		);
end std_logic_automaton;

architecture automaton_binary_coded_arch of std_logic_automaton is
	function vector_to_integer(vector: bit_vector) return integer is
		variable value: integer := 0;
		begin
			for i in vector'length - 1 downto 0 loop
				if (vector(i) = '1') then
					value := value * 2 + 1;
				else
					value := value * 2;
				end if;
			end loop;
		return value;
	end vector_to_integer;
	
	type state_table_type is array(0 to 15, 0 to 3) of bit_vector(3 downto 0);
	type out_table_type is array(0 to 15) of std_logic_vector(0 downto 0);
	
	constant FS: bit_vector(3 downto 0) := "1100"; 
	constant state_table: state_table_type := (
		("0000","0001",FS,FS),		-- 000 0
		("0011","0001",FS,FS),     	-- 001 3	
		("0110",FS,"0010",FS),	   	-- 010 5	
		("0011","0111","0010",FS),	-- 011 1
		("0000",FS,"0100",FS),	   	-- 100 7 
		("0101","0001",FS,FS), 	   	-- 101 6
		("0110","0110","0100",FS),	-- 110 2
		("0101","0111",FS,FS),	   	-- 111 4
		(FS,FS,FS,FS), 
		(FS,FS,FS,FS), 
		(FS,FS,FS,FS), 
		(FS,FS,FS,FS), 
		(FS,FS,FS,FS), 
		(FS,FS,FS,FS), 
		(FS,FS,FS,FS), 
		(FS,FS,FS,FS) 
	);			   				   
								   
	constant out_table: out_table_type := (
		"0","0","0","0","1","1","0","0","0","0","0","0","0","0","0","0");			  
	
	signal current_state, next_state: bit_vector(3 downto 0) := "0000";
	
	begin
		process begin
			if current_state = FS then
				Y <= transport "X" after TZ;
			else
				next_state <= state_table(vector_to_integer(current_state), vector_to_integer(X));
				Y <= transport out_table(vector_to_integer(current_state)) after TZ;
			end if;	
			wait on X, current_state;
		end process;
		
		current_state <= transport next_state after TZ;
end automaton_binary_coded_arch;
