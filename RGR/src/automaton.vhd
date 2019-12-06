entity automaton is
	generic (TZ: time := 0ns);
	port (
		X: in bit_vector(1 downto 0);
		Y: out bit_vector(0 downto 0)
		);
end	automaton;

architecture automaton_arch of automaton is
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

	type state_table_type is array(0 to 14, 0 to 3) of integer;
	type out_table_type is array(0 to 14) of bit_vector(0 downto 0);
	
	constant FS: integer := 15;
	constant state_table: state_table_type := (
			(0, 1, FS, FS),
			(2, 1, FS, FS),
			(2, 3, FS, FS),
			(4, 3, FS, FS),
			(4, 5, FS, FS),
			(6, 5, FS, FS),
			(6, FS, 7, FS),
			(8, FS, 7, FS),
			(8, 9, FS, FS),
			(10, 9, FS, FS),
			(10, 11, FS, FS),
			(12, 11, FS, FS),
			(12, 13, FS, FS),
			(FS, 13, 14, FS),
			(0, FS, 14, FS)
		);			
	constant out_table: out_table_type := (
		"0", "0", "0", "0", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "1");			  
	
	signal current_state, next_state: integer := 0;
	
	begin
		process begin
			wait on X, current_state;
			if current_state = FS then
				null;
			else
				next_state <= state_table(current_state, vector_to_integer(X));
				Y <= transport out_table(current_state) after TZ;
			end if;
		end process;
		
		current_state <= transport next_state after TZ;
end automaton_arch;
