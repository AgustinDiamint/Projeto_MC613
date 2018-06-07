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
	
    constant cons_clock_div : integer := 1000000;
    constant HORZ_SIZE : integer := 80;
    constant VERT_SIZE : integer := 60;

    signal slow_clock : std_logic;

    signal clear_video_address	,
        normal_video_address	,
        video_address			: integer range 0 to HORZ_SIZE * VERT_SIZE- 1;

    --definicao da matriz que contem a cor de cada "pixel"
    -- o vetor eh definido em ordem crescente como o video_adress
    TYPE color_matrix is array (2 downto 0) of std_logic_vector;
    signal pos_color(0 to  HORZ_SIZE * VERT_SIZE- 1);
  
    
    -- Interface com a memória de vídeo do controlador

    signal we : std_logic;                        -- write enable ('1' p/ escrita)
    signal addr : integer range 0 to 12287;       -- endereco mem. vga
    signal pixel : std_logic_vector(2 downto 0);  -- valor de cor do pixel
    signal pixel_bit : std_logic;                 -- um bit do vetor acima
    
    -- Sinais dos contadores de linhas e colunas utilizados para percorrer
    -- as posições da memória de vídeo (pixels) no momento de construir um quadro.
    
    signal line : integer range 0 to 95;  -- linha atual
    signal col : integer range 0 to 127;  -- coluna atual

    signal col_rstn : std_logic;          -- reset do contador de colunas
    signal col_enable : std_logic;        -- enable do contador de colunas

    signal line_rstn : std_logic;          -- reset do contador de linhas
    signal line_enable : std_logic;        -- enable do contador de linhas

    signal fim_escrita : std_logic;       -- '1' quando um quadro terminou de ser
                                            -- escrito na memória de vídeo
    
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
        write_enable	=> we,
        write_addr      => video_address,
        vga_clk         => VGA_CLK,
        data_in         => video_word,
        red				=> VGA_R,
        green			=> VGA_G,
        blue			=> VGA_B,
        hsync			=> VGA_HS,
        vsync			=> VGA_VS,
        sync			=> sync,
        blank			=> blank);
    VGA_SYNC_N <= NOT sync;
    VGA_BLANK_N <= NOT blank;
    
    video_word <= normal_video_word when state = NORMAL else clear_video_word;
    
    video_address <= normal_video_address when state = NORMAL else clear_video_address;
    
    clock_divider:
PROCESS (clk50M, rstn)
    VARIABLE i : INTEGER := 0;
BEGIN
    IF (rstn = '0') THEN
        i := 0;
        slow_clock <= '0';
    ELSIF (rising_edge(clk50M)) THEN
        IF (i <= CONS_CLOCK_DIV/2) THEN
            i := i + 1;
            slow_clock <= '0';
        ELSIF (i < CONS_CLOCK_DIV-1) THEN
            i := i + 1;
            slow_clock <= '1';
        ELSE		
            i := 0;
        END IF;	
END IF;
END PROCESS;

clock_divider:
PROCESS (clk50M, rstn)
    VARIABLE i : INTEGER := 0;
BEGIN
    IF (rstn = '0') THEN
        i := 0;
        slow_clock <= '0';
    ELSIF (rising_edge(clk50M)) THEN
        IF (i <= CONS_CLOCK_DIV/2) THEN
            i := i + 1;
            slow_clock <= '0';
        ELSIF (i < CONS_CLOCK_DIV-1) THEN
            i := i + 1;
            slow_clock <= '1';
        ELSE		
            i := 0;
        END IF;	
    END IF;
END PROCESS;
vga_writer:

PROCESS (slow_clock, rstn, normal_video_address)
BEGIN
    IF (rstn = '0') THEN
        normal_video_address <= 0;
        normal_video_word <= "000";
    ELSIF (rising_edge(slow_clock)) THEN
        CASE switch IS
        WHEN '1' =>
            normal_video_address <= normal_video_address + 1;
            normal_video_word <= "111";
        WHEN OTHERS =>
            normal_video_word <= "010";
        END CASE;
    END IF;	
END PROCESS;
END ARCHITECTURE;
