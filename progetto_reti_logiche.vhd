----------------------------------------------------------------------------------
 
--     PROGETTO DI RETI LOGICHE 2019/20 - INGEGNERIA INFORMATICA			--
-- 																			--
-- 					Sezione prof. Gianluca Palermo							--	
-- 																			--
-- 		Studenti: Simeoni Raffaele (mat. 867024; cod.pers. 10527107)
--                Vangi Gabriele   (mat. 871543; cod.pers. 10567226)  

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ENTITY PROGETTO
entity project_reti_logiche is
    Port ( i_clk            : in STD_LOGIC;                         
           i_start          : in STD_LOGIC;                         
           i_rst            : in STD_LOGIC;                         
           i_data           : in STD_LOGIC_VECTOR (7 downto 0);     
           o_address        : out STD_LOGIC_VECTOR (15 downto 0);	
           o_done           : out STD_LOGIC;							
           o_en             : out STD_LOGIC;							
           o_we             : out STD_LOGIC;							
           o_data           : out STD_LOGIC_VECTOR (7 downto 0));      
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

       type state_type is (RESET, START, -- pronto a ricevere l'address da codificare da i_address
                           ADDR1, ADDR2, ADDR3, ADDR4, ADDR5, ADDR6, ADDR7,ADDR8, --chiedo alla memoria gli indirizzi delle wz e inizializzo le variabili
                           READMEMORY1, READMEMORY2, READMEMORY3, READMEMORY4,    --leggo e confronto il valore di i_address
                           READMEMORY5, READMEMORY6, READMEMORY7, READMEMORY8,    --con il contenuto delle working zone
                           NO_WZ, SI_WZ,  --casi in cui finisco se non trovo/trovo address in una wz
                           SCRITTURA,    --scrivo in memoria 9 il risultato (NB: rispettando i tempi di clock necessari)
                           DONE, --ho completato l'operazione
                           CONDIZIONI_DONE,  --verifiche prima di riportare DONE = '0'
                           WAIT_STATUS1,WAIT_STATUS2,WAIT_STATUS3,WAIT_STATUS4,
                           WAIT_STATUS5,WAIT_STATUS6,WAIT_STATUS7,WAIT_STATUS0,WAIT_STATUS8
                           ); 
                  
       signal state: state_type;
                           

begin
      process(i_clk,i_rst)
              variable wz_NUM: std_logic_vector(2 downto 0);
              variable wz_OFFSET: std_logic_vector(3 downto 0);
              variable ricevuto: std_logic_vector(7 downto 0);
              variable address: integer range 0 to 255;
              variable addr_wz1: integer range 0 to 255;      
              variable addr_wz2: integer range 0 to 255;
              variable addr_wz3: integer range 0 to 255;
              variable addr_wz4: integer range 0 to 255;
              variable addr_wz5: integer range 0 to 255;
              variable addr_wz6: integer range 0 to 255;
              variable addr_wz7: integer range 0 to 255;
              variable addr_wz8: integer range 0 to 255;
              variable codifica: std_logic_vector(7 downto 0);      --variabile per la codifica finale
              
              begin
                     if (i_rst = '1') then    --in caso di RESET asincrono
                         state <= RESET;
                     
                     
                     elsif(rising_edge(i_clk)) then     --sincronizzo sul fronte di salita del clock
                         case state is
                                
                                 when RESET => 
                                           o_done <= '0';
                                           if (i_start = '1') then     --finchè il segnale start non è a 1 non inizializza le variabili
                                               o_en <= '1';
                                               o_we <= '0';
                                               o_address <= "0000000000001000";
                                               state <= WAIT_STATUS0;                                          
                                           else                      
                                               state <= RESET;
                                           end if;                                            
                                                                            
                                 when WAIT_STATUS0 =>                                           
                                           state <= START;            
                                 when START =>
                                           ricevuto := i_data;
                                           address := to_integer(unsigned(i_data));
                                           o_en <= '0';
                                           state <= ADDR1;          
                                 -- BLOCCO: ADDR[i] + READMEMORY[i] = compara address con l'indirizzo della i-esima wz e degli offset,
                                 --se trova corrispondenza -> SI_WZ, altrimenti passa al blocco della wz successiva
                                 when ADDR1 =>                
                                           o_en <= '1';
                                           o_we <= '0';
                                           o_address <= "0000000000000000" ;                                                                                      
                                           state <= WAIT_STATUS1;
                                 when WAIT_STATUS1 =>                                           
                                           state <= READMEMORY1;
                                 when READMEMORY1 =>                                           
                                           addr_wz1 := to_integer(unsigned(i_data));
                                           o_en <= '0';
                                           if (address = addr_wz1)then
                                                   wz_NUM := "000";
                                                   wz_OFFSET := "0001";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz1+1))then
                                                   wz_NUM := "000";
                                                   wz_OFFSET := "0010";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz1+2))then
                                                   wz_NUM := "000";
                                                   wz_OFFSET := "0100";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz1+3))then
                                                   wz_NUM := "000";
                                                   wz_OFFSET := "1000";
                                                   state <= SI_WZ;
                                           else 
                                                 state <= ADDR2;
                                           end if;
                                                                                   
                                 when ADDR2 =>              
                                           o_en <= '1';                                           
                                           o_we <= '0';
                                           o_address <= "0000000000000001" ;                                                                                     
                                           state <= WAIT_STATUS2;
                                 when WAIT_STATUS2 =>                                           
                                           state <= READMEMORY2;
                                 when READMEMORY2 =>                                           
                                           addr_wz2 := to_integer(unsigned(i_data)); 
                                           o_en <= '0';
                                           if (address = addr_wz2)then
                                                   wz_NUM := "001";
                                                   wz_OFFSET := "0001";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz2+1))then
                                                   wz_NUM := "001";
                                                   wz_OFFSET := "0010";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz2+2))then
                                                   wz_NUM := "001";
                                                   wz_OFFSET := "0100";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz2+3))then
                                                   wz_NUM := "001";
                                                   wz_OFFSET := "1000";
                                                   state <= SI_WZ;
                                           else
                                                  state <= ADDR3;
                                           end if;                                           
                                           
                                 when ADDR3 =>              
                                           o_en <= '1';                                           
                                           o_we <= '0';
                                           o_address <= "0000000000000010" ;                                                                                   
                                           state <= WAIT_STATUS3;
                                 when WAIT_STATUS3 =>                                           
                                           state <= READMEMORY3;
                                 when READMEMORY3 =>                                           
                                           addr_wz3 := to_integer(unsigned(i_data));  
                                           o_en <= '0';
                                           if (address = addr_wz3)then
                                                   wz_NUM := "010";
                                                   wz_OFFSET := "0001";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz3+1))then
                                                   wz_NUM := "010";
                                                   wz_OFFSET := "0010";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz3+2))then
                                                   wz_NUM := "010";
                                                   wz_OFFSET := "0100";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz3+3))then
                                                   wz_NUM := "010";
                                                   wz_OFFSET := "1000";
                                                   state <= SI_WZ;                                           
                                           else
                                                  state <= ADDR4;
                                           end if;                                           
                                           
                                 when ADDR4 =>              
                                           o_en <= '1';                                           
                                           o_we <= '0';
                                           o_address <= "0000000000000011" ;                                                                                  
                                           state <= WAIT_STATUS4;
                                 when WAIT_STATUS4 =>                                           
                                           state <= READMEMORY4;
                                 when READMEMORY4 =>                                           
                                           addr_wz4 := to_integer(unsigned(i_data));
                                           o_en <= '0';
                                           if (addr_wz4 = address)then
                                                   wz_NUM := "011";
                                                   wz_OFFSET := "0001";
                                                   state <= SI_WZ;
                                           elsif ((addr_wz4+1) = address)then
                                                   wz_NUM := "011";
                                                   wz_OFFSET := "0010";
                                                   state <= SI_WZ;
                                           elsif ((addr_wz4+2) = address)then
                                                   wz_NUM := "011";
                                                   wz_OFFSET := "0100";
                                                   state <= SI_WZ;
                                           elsif ((addr_wz4+3) = address)then
                                                   wz_NUM := "011";
                                                   wz_OFFSET := "1000";
                                                   state <= SI_WZ;                                            
                                           else
                                                  state <= ADDR5;
                                           end if;                                           
                                           
                                 when ADDR5 =>              
                                           o_en <= '1';                                           
                                           o_we <= '0';
                                           o_address <= "0000000000000100" ;                                                                                  
                                           state <= WAIT_STATUS5;
                                 when WAIT_STATUS5 =>                                           
                                           state <= READMEMORY5;
                                 when READMEMORY5 =>
                                           addr_wz5 := to_integer(unsigned(i_data)); 
                                           o_en <= '0';
                                           if (address = addr_wz5)then
                                                   wz_NUM := "100";
                                                   wz_OFFSET := "0001";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz5+1))then
                                                   wz_NUM := "100";
                                                   wz_OFFSET := "0010";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz5+2))then
                                                   wz_NUM := "100";
                                                   wz_OFFSET := "0100";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz5+3))then
                                                   wz_NUM := "100";
                                                   wz_OFFSET := "1000";
                                                   state <= SI_WZ;                                                
                                           else
                                                  state <= ADDR6;
                                           end if;                                           
                                           
                                 when ADDR6 =>              
                                           o_en <= '1';
                                           o_we <= '0';
                                           o_address <= "0000000000000101" ;                                                                                  
                                           state <= WAIT_STATUS6;
                                 when WAIT_STATUS6 =>                                           
                                           state <= READMEMORY6;
                                 when READMEMORY6 =>
                                           addr_wz6 := to_integer(unsigned(i_data));
                                           o_en <= '0';
                                           if (address = addr_wz6)then
                                                   wz_NUM := "101";
                                                   wz_OFFSET := "0001";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz6+1))then
                                                   wz_NUM := "101";
                                                   wz_OFFSET := "0010";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz6+2))then
                                                   wz_NUM := "101";
                                                   wz_OFFSET := "0100";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz6+3))then
                                                   wz_NUM := "101";
                                                   wz_OFFSET := "1000";
                                                   state <= SI_WZ;                                                   
                                           else
                                                  state <= ADDR7;
                                           end if;                                           
                                           
                                 when ADDR7 =>              
                                           o_en <= '1';
                                           o_we <= '0';
                                           o_address <= "0000000000000110" ;                                                                               
                                           state <= WAIT_STATUS7;
                                 when WAIT_STATUS7 =>                                           
                                           state <= READMEMORY7;
                                 when READMEMORY7 =>
                                           addr_wz7 := to_integer(unsigned(i_data));
                                           o_en <= '0';
                                           if (address = addr_wz7)then
                                                   wz_NUM := "110";
                                                   wz_OFFSET := "0001";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz7+1))then
                                                   wz_NUM := "110";
                                                   wz_OFFSET := "0010";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz7+2))then
                                                   wz_NUM := "110";
                                                   wz_OFFSET := "0100";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz7+3))then
                                                   wz_NUM := "110";
                                                   wz_OFFSET := "1000";
                                                   state <= SI_WZ;                                             
                                           else 
                                                  state <= ADDR8;
                                           end if;                                           
                                           
                                 when ADDR8 =>              
                                           o_en <= '1';
                                           o_we <= '0';
                                           o_address <= "0000000000000111" ;                                                                                  
                                           state <= WAIT_STATUS8;
                                 when WAIT_STATUS8 =>                                           
                                           state <= READMEMORY8;
                                 when READMEMORY8 =>
                                           addr_wz8 := to_integer(unsigned(i_data));
                                           o_en <= '0';
                                           if (address = addr_wz8)then
                                                   wz_NUM := "111";
                                                   wz_OFFSET := "0001";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz8+1))then
                                                   wz_NUM := "111";
                                                   wz_OFFSET := "0010";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz8+2))then
                                                   wz_NUM := "111";
                                                   wz_OFFSET := "0100";
                                                   state <= SI_WZ;
                                           elsif (address = (addr_wz8+3))then
                                                   wz_NUM := "111";
                                                   wz_OFFSET := "1000";
                                                   state <= SI_WZ;                                        
                                           else
                                                  state <= NO_WZ;
                                           end if;                                           
                                           
                                 when SI_WZ =>                --compone la codifica dell'indirizzo ricevuto e lo invia alla memoria
                                           codifica := '1'&wz_NUM&wz_OFFSET;
                                           o_en <= '1';
                                           o_we <= '1';
                                           o_address <= "0000000000001001";
                                           o_data <= codifica;
                                           state <= SCRITTURA;
                                 when NO_WZ =>
                                           codifica := '0'&ricevuto(6 downto 0);
                                           o_en <= '1';
                                           o_we <= '1';
                                           o_address <= "0000000000001001";
                                           o_data <= codifica;
                                           state <= SCRITTURA;
                                 when SCRITTURA =>              --aspetto il clock affinchè la scrittura sia completata                                      
                                           state <= DONE;
                                 when DONE =>
                                           o_en <= '0';
                                           o_we <= '0';
                                           o_done <= '1';
                                           state <= CONDIZIONI_DONE;
                                 when CONDIZIONI_DONE =>
                                           if (i_start = '0') then
                                               o_done <= '0';
                                               state <= RESET;
                                           else
                                               o_done <= '1';
                                               state <= CONDIZIONI_DONE;
                                           end if;
                                  
                                           
                        end case;
                    end if;        
                                                    
                                         
       end process ;


end Behavioral;

