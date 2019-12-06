library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity std_logic_carno_automaton is
     generic (
    TZ : time := 1.5ns;
    Lx : integer := 2;
    Ly : integer := 1);
  port (
    X: in std_logic_vector(Lx - 1 downto 0);
    Y: out std_logic_vector(Ly - 1 downto 0));
end std_logic_carno_automaton;

architecture std_logic_carno_automaton_arch of std_logic_carno_automaton is
signal R, S: std_logic_vector(2 downto 0);
signal Q: std_logic_vector(2 downto 0) := "000";
begin
  F1: process begin
    wait on Q, X;
    R(2) <= ( not(X(1)) and not(Q(0)) and not(Q(1)) ) or ( X(0) and not(Q(1)) );
    S(2) <= ( not(X(1)) and not(Q(0)) and Q(1)) or ( X(0) and Q(1) );
    R(1) <= ( not(X(1)) and not(X(0)) and Q(0) and Q(2) ) or ( X(1) and Q(2) ) ;
    S(1) <= not(X(0)) and not(X(1)) and not(Q(2)) and Q(0);
    R(0) <= X(1);
    S(0) <= X(0) and not(Q(1));
  end process F1;

  Y(0) <= not(Q(1)) and Q(2);

  RS_triggers: process begin
    wait on R, S;
    Q(2) <= S(2) or (not(R(2)) and Q(2)) after TZ;
    Q(1) <= S(1) or (not(R(1)) and Q(1)) after TZ;
    Q(0) <= S(0) or (not(R(0)) and Q(0)) after TZ;
  end process RS_triggers;

end std_logic_carno_automaton_arch;