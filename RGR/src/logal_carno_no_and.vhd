									library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity logal_carno_no_and is
         generic (
    TZ : time := 1.5ns;
    Lx : integer := 2;
    Ly : integer := 1);
  port (
    X: in std_logic_vector(Lx - 1 downto 0);
    Y: out std_logic_vector(Ly - 1 downto 0));
end logal_carno_no_and;

--}} End of automatically maintained section

architecture logal_carno_no_and_arch of logal_carno_no_and is
signal notR, notS: std_logic_vector(2 downto 0);
signal Q: std_logic_vector(2 downto 0) := "000";
begin
  F1: process begin
    wait on Q, X;
    notR(2) <= not( not( not(X(1)) and not(Q(0)) and not(Q(1)) ) and not( X(0) and not(Q(1)) ) );
    notS(2) <= not( not( not(X(1)) and not(Q(0)) and Q(1)) and not( X(0) and Q(1) ) );
    notR(1) <= not( not( not(X(1)) and not(X(0)) and Q(0) and Q(2) ) and not( X(1) and Q(2) ) );
    notS(1) <= not( not(X(0)) and not(X(1)) and not(Q(2)) and Q(0) );
    notR(0) <= not( X(1) );
    notS(0) <= not( X(0) and not(Q(1)) );
  end process F1;

  Y(0) <= not(Q(1)) and Q(2);

  RS_triggers: process begin
    wait on notR, notS;
    Q(2) <= not(notS(2)) or (notR(2) and Q(2)) after TZ;
    Q(1) <= not(notS(1)) or (notR(1) and Q(1)) after TZ;
    Q(0) <= not(notS(0)) or (notR(0) and Q(0)) after TZ;
  end process RS_triggers;

end logal_carno_no_and_arch;