ljmp start

LCDstatus  equ 0FF2EH       ; adres do odczytu gotowosci LCD
LCDcontrol equ 0FF2CH       ; adres do podania bajtu sterujacego LCD
LCDdataWR  equ 0FF2DH       ; adres do podania kodu ASCII na LCD

// bajty sterujace LCD, inne dostepne w opisie LCD na stronie WWW
#define  HOME     0x80     // put cursor to second line  
#define  INITDISP 0x38     // LCD init (8-bit mode)  
#define  HOM2     0xc0     // put cursor to second line  
#define  LCDON    0x0e     // LCD nn, cursor off, blinking off
#define  CLEAR    0x01     // LCD display clear

org 0100H		
// macro do wprowadzenia bajtu sterujacego na LCD
LCDcntrlWR MACRO x          ; x – parametr wywolania macra – bajt sterujacy
           LOCAL loop       ; LOCAL oznacza ze etykieta loop moze sie powtórzyc w programie
loop: MOV  DPTR,#LCDstatus  ; DPTR zaladowany adresem statusu
      MOVX A,@DPTR          ; pobranie bajtu z biezacym statusem LCD
      JB   ACC.7,loop       ; testowanie najstarszego bitu akumulatora
                            ; – wskazuje gotowosc LCD
      MOV  DPTR,#LCDcontrol ; DPTR zaladowany adresem do podania bajtu sterujacego
      MOV  A, x             ; do akumulatora trafia argument wywolania macra–bajt sterujacy
      MOVX @DPTR,A          ; bajt sterujacy podany do LCD – zadana akcja widoczna na LCD
      ENDM
	  
// macro do wypisania znaku ASCII na LCD, znak ASCII przed wywolaniem macra ma byc w A
LCDcharWR MACRO
      LOCAL tutu            ; LOCAL oznacza ze etykieta tutu moze sie powtórzyc w programie
      PUSH ACC              ; odlozenie biezacej zawartosci akumulatora na stos
tutu: MOV  DPTR,#LCDstatus  ; DPTR zaladowany adresem statusu
      MOVX A,@DPTR          ; pobranie bajtu z biezacym statusem LCD
      JB   ACC.7,tutu       ; testowanie najstarszego bitu akumulatora
                            ; – wskazuje gotowosc LCD
      MOV  DPTR,#LCDdataWR  ; DPTR zaladowany adresem do podania bajtu sterujacego
      POP  ACC              ; w akumulatorze ponownie kod ASCII znaku na LCD
      MOVX @DPTR,A          ; kod ASCII podany do LCD – znak widoczny na LCD
      ENDM
	  
// macro do inicjalizacji wyswietlacza – bez parametrów
init_LCD MACRO
         LCDcntrlWR #INITDISP ; wywolanie macra LCDcntrlWR – inicjalizacja LCD
         LCDcntrlWR #CLEAR    ; wywolanie macra LCDcntrlWR – czyszczenie LCD
         LCDcntrlWR #LCDON    ; wywolanie macra LCDcntrlWR – konfiguracja kursora
         ENDM

// funkcja opóznienia
	delay:	mov r0, #15H
	one:	mov r1, #0FFH
	dwa:	mov r2, #0FFH
    trzy:	djnz r2, trzy
			djnz r1, dwa
			djnz r0, one
			ret
			
// funkcja wypisania znaku
putcharLCD:	LCDcharWR
			ret
			
//funkcja wypisania lancucha znaków		
putstrLCD:  clr a
			movc a, @a+dptr
			jz koniec
			push dph
			push dpl
			acall putcharLCD
			pop dpl
			pop dph
			inc dptr
			sjmp putstrLCD
	koniec: ret



; deklaracja tekstu barki, podzielona na frazy - 2 16-bitowe ciagi na fraze
lyrics:  DB "Pan             ",00
		 DB "                ",00
		 DB "kiedys stanal   ",00
		 DB "nad brzegiem    ",00
		 DB "Szukal          ",00
		 DB "ludzi           ",00
		 DB "gotowych pojsc  ",00
		 DB "za Nim          ",00
		 DB "By lowic        ",00
		 DB "serca           ",00
		 DB "slow Bozych     ",00
		 DB "prawda          ",00
		 DB "OOOOOOO         ",00
		 DB "Paaaaanieeeee   ",00
		 DB "to TY na mnie   ",00
		 DB "spojrzales      ",00
		 DB "Twoje           ",00
		 DB "usta            ",00
		 DB "dzis wyrzekly   ",00
		 DB "me imie         ",00
		 DB "Swoja           ",00
		 DB "baaaaaarkeeeee  ",00
		 DB "pozostawiam     ",00
		 DB "na brzegu       ",00
		 DB "Razem z         ",00
		 DB "TOBA            ",00
		 DB "nowy zaczne     ",00
		 DB "dzis low        ",00

num_of_displays equ 14 ; num_of_rows / 2, poniewaz na kazde wyswietlenie przypadaja 2 fragmenty
line_size equ 16

next_line: 
		mov r1, #0
		
		loop:
			inc r1
			inc dptr
			cjne r1, #line_size, loop
		ret

start: 
		mov dptr, #lyrics
		mov r0, #0


; loop będzie wykonywana do końca lyrics - do wyswietlania ostatniej linijki
display:
		inc r0
	
		LCDcntrlWR #HOME
		acall putstrLCD
		acall delay
		
		acall next_line
		
		LCDcntrlWR #HOM2
		acall putstrLCD
		acall delay
		LCDcntrlWR #CLEAR
	
	
		cjne r0, #num_of_displays, display  ; use rows as the second operand of cjne
		acall next_line

	
nop
nop
nop
jmp $
end start