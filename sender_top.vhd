library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sender_top is
  Port (btn : in std_logic_vector(1 downto 0);
        TXD, clk : in std_logic;
        CTS, RTS, RXD : out std_logic);
end sender_top;

architecture Behavioral of sender_top is

component uart 
    port(
    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)
);
end component;

component debounce 
        Port (clk       : in std_logic;
        btn             : in std_logic;
        deb_out         : out std_logic);
end component;

component clock_div
    port (
    clk     : in std_logic;
    div     : out std_logic);
end component;

component sender
  Port ( rst, clk, en, btn, ready       : in std_logic;
         send                           : out std_logic;
         char                           : out std_logic_vector(7 downto 0));
end component;

signal u1_out, u2_out, u3_out, u4_send, u5_ready : std_logic;
signal u4_char : std_logic_vector(7 downto 0);

begin

RTS <= '0';
CTS <= '0';

u1: debounce port map(btn => btn(0),
                      clk => clk,
                      deb_out => u1_out);
                      
u2: debounce port map(btn => btn(1),
                      clk => clk,
                      deb_out => u2_out);
                      
u3: clock_div port map(clk => clk,
                     div => u3_out);
                     
u4: sender port map(rst => u1_out,
                    btn => u2_out,
                    en => u3_out,
                    char => u4_char,
                    send => u4_send,
                    ready => u5_ready,
                    clk => clk);
                    
u5: uart port map(rst => u1_out,
                  en => u3_out,
                  charSend => u4_char,
                  send => u4_send,
                  ready => u5_ready,
                  clk => clk,
                  rx => TXD,
                  tx => RXD);


end Behavioral;