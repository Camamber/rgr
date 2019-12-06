entity automaton2 is
	generic (TZ: time := 0ns);
	port (
		X: in bit_vector(1 downto 0);
		Y: out bit_vector(0 downto 0)
		);
end	automaton2;

architecture automaton2_arch of automaton2 is
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

	type state_table_type is array(0 to 7, 0 to 3) of integer;
	type out_table_type is array(0 to 7) of bit_vector(0 downto 0);
	
	constant FS: integer := 15;
	constant state_table: state_table_type := (
		(0, 3, FS, FS),
		(1, 4, 5, FS),
		(2, 2, 7, FS),
		(1, 3, FS, FS),
		(6, 4, FS, FS),
		(2, FS, 5, FS),
		(6, 3, FS, FS),
		(0, FS, 7, FS)
	);			
	constant out_table: out_table_type := (
		"0", "0", "0", "0", "0", "0", "1", "1"
	);			  
	
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
end automaton2_arch;
