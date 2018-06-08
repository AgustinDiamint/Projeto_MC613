library ieee;
use ieee.std_logic_1164.all;


entity game_board IS
	port(
		SW                      : in std_logic_vector(0 downto 0);
		CLOCK_50                : in std_logic;
		KEY				        : in std_logic_vector(0 downto 0);
		VGA_R, VGA_G, VGA_B	    : out std_logic_vector(7 DOWNTO 0);
		VGA_HS, VGA_VS		    : out std_logic;
		VGA_BLANK_N, VGA_SYNC_N : out std_logic;
		VGA_CLK                 : out std_logic
	);
end entity;

architecture behavior OF game_board IS
	component vgacon IS
		generic (
			NUM_HORZ_PIXELS : NATURAL := 128;	-- Number of horizontal pixels
			NUM_VERT_PIXELS : NATURAL := 96		-- Number of vertical pixels
		);
		port (
			clk50M, rstn              : in std_logic;
			write_clk, write_enable   : in std_logic;
			write_addr                : in INTEGER range 0 TO NUM_HORZ_PIXELS * NUM_VERT_PIXELS - 1;
			data_in                   : in std_logic_vector (2 DOWNTO 0);
			vga_clk                   : buffer std_logic;
			red, green, blue          : out std_logic_vector (7 DOWNTO 0);
			hsync, vsync              : out std_logic;
			sync, blank               : out std_logic
		);
	end component;
	
	 
    component clock_div is
        port (
            clock : in std_logic;
            clock_hz : out std_logic;
            clock_half : out std_logic
        );
    end component;

    constant cons_clock_div : integer := 1000000;
    constant HORZ_SIZE : integer := 50;
    constant VERT_SIZE : integer := 22;

    signal slow_clock : std_logic;
	 signal video_word : std_logic_vector( 2 downto 0);
    signal clear_video_address	,
        normal_video_address	,
        video_address			: integer range 0 to HORZ_SIZE * VERT_SIZE- 1;

    --definicao da matriz que contem a cor de cada "pixel"
    -- o vetor eh definido em ordem crescente como o video_adress
    TYPE color_matrix is array (0 to HORZ_SIZE * VERT_SIZE- 1) of std_logic_vector(2 downto 0);
    signal pos_color: color_matrix;
  
    
    -- Interface com a memória de vídeo do controlador

    signal we : std_logic;                        -- write enable ('1' p/ escrita)
    signal addr : integer range 0 to 12287;       -- endereco mem. vga
    signal pixel : std_logic_vector(2 downto 0);  -- valor de cor do pixel
    signal pixel_bit : std_logic;                 -- um bit do vetor acima
    
    -- Sinais dos contadores de linhas e colunas utilizados para percorrer
    -- as posições da memória de vídeo (pixels) no momento de construir um quadro.
    
    signal line : integer range 0 to HORZ_SIZE-1;  -- linha atual
    signal col : integer range 0 to VERT_SIZE-1;  -- coluna atual

    signal col_rstn : std_logic;          -- reset do contador de colunas
    signal col_enable : std_logic;        -- enable do contador de colunas

    signal line_rstn : std_logic;          -- reset do contador de linhas
    signal line_enable : std_logic;        -- enable do contador de linhas

    signal fim_escrita : std_logic;       -- '1' quando um quadro terminou de ser
                                            -- escrito na memória de vídeo
    --
    signal piece_x : integer range 0 to HORZ_SIZE-1;  -- coluna atual da peca
    signal piece_y : integer range 0 to VERT_SIZE-1;   -- linha atual da peca
    
    signal atualiza_piece_x : std_logic;    -- se '1' = peca muda sua pos. no eixo x
    signal atualiza_piece_y : std_logic;    -- se '1' = peca muda sua pos. no eixo y
    
    --acho que aqui um dos estados que pode ser definido eh o menu...
    TYPE VGA_STATES IS (NORMAL, CLEAR); 
    signal state : VGA_STATES;

    signal switch, rstn, clk50m, sync, blank : std_logic;
BEGIN
    rstn <= KEY(0);
    clk50M <= CLOCK_50;
    
    vga_component: vgacon generic map (
        NUM_HORZ_PIXELS => HORZ_SIZE,
        NUM_VERT_PIXELS => VERT_SIZE
    ) port map (
        clk50M          => clk50M,
        rstn            => rstn,
        write_clk		=> clk50M,
        write_enable	=> '1',
        write_addr      => video_address,
        vga_clk         => VGA_CLK,
        data_in         => pixel,
        red				=> VGA_R,
        green			=> VGA_G,
        blue			=> VGA_B,
        hsync			=> VGA_HS,
        vsync			=> VGA_VS,
        sync			=> sync,
        blank			=> blank);
    VGA_SYNC_N <= NOT sync;
    VGA_BLANK_N <= NOT blank;
    
    -- precisamos de funcoes para atualizar cada um dos dois signals
   -- video_address <= normal_video_address when state = NORMAL else clear_video_address;
    
--precisamos dos processos de conta_coluna e conta_linha para 
-- mandar todas as posicoes da tela ao vgacon. 
conta_coluna: process (CLOCK_50, col_rstn)
begin  -- process conta_coluna
    if col_rstn = '0' then                  -- asynchronous reset (active low)
    col <= 0;
    elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
    if col_enable = '1' then
        if col = HORZ_SIZE-1 then               -- conta de 0 ate HORZ_SIZE-1
        col <= 0;
        else
        col <= col + 1;  
        end if;
    end if;
    end if;
end process conta_coluna;

conta_linha: process (CLOCK_50, line_rstn)
begin  -- process conta_linha
    if line_rstn = '0' then                  -- asynchronous reset (active low)
        line <= 0;
    elsif CLOCK_50'event and CLOCK_50 = '1' then  -- rising clock edge
    -- o contador de linha só incrementa quando o contador de colunas
    -- chegou ao fim (valor 127)
        if line_enable = '1' and col = HORZ_SIZE -1 then
        if line = VERT_SIZE-1 then               -- conta de 0 a 95 (96 linhas)
            line <= 0;
        else
            line <= line + 1;  
        end if;        
    end if;
end if;
end process conta_linha;

-- manda o endereco atual e a cor desse endereco para o vgacon. 
video_address  <= col + (VERT_SIZE * line);
pixel <= pos_color(col + (VERT_SIZE*line)); 

--desenha uma linha branca ao redor do tabuleiro
draw_edge: process(CLOCK_50)
begin
        for i in 0 to 21 loop
                for j in 20 to 29 loop
                    if (i = 0 or i = 21) then
                        pos_color(i+(j*VERT_SIZE)) <= "111";
                    else
                        if(j=19 or j = 29) then
                            pos_color(i+(j*VERT_SIZE)) <= "111";
                        end if;
                    end if;
                end loop; 
        end loop; 
end process;

END ARCHITECTURE;
  
