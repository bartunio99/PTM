ljmp start

P5 equ 0F8H
P7 equ 0DBH
	
// linie klawiatury - sterowanie na port P5
#define LINE_1		0x7f	// 0111 1111
#define LINE_2		0xbf	// 1011 1111
#define	LINE_3		0xdf	// 1101 1111
#define LINE_4		0xef	// 1110 1111



ORG 000BH     ; obsluga przerwania
	CPL P3.2	; ruch membraną brzęczyka
	PUSH ACC	; na wszelki wypadek
	MOV A, R6	; przeładowanie
	MOV TH0, A 	; stalej timera
	MOV A, R7
	MOV TL0, A
	POP ACC      	; odtworzenie akumulatora
	RETI          ; powrót z przerwania


LCDstatus  equ 0FF2EH       ; adres do odczytu gotowosci LCD
LCDcontrol equ 0FF2CH       ; adres do podania bajtu sterujacego LCD
LCDdataWR  equ 0FF2DH       ; adres do podania kodu ASCII na LCD

// bajty sterujace LCD, inne dostepne w opisie LCD na stronie WWW
#define  HOME     0x80     // put cursor to second line  
#define  INITDISP 0x38     // LCD init (8-bit mode)  
#define  HOM2     0xc0     // put cursor to second line  
#define  LCDON    0x0e     // LCD nn, cursor off, blinking off
#define  CLEAR    0x01     // LCD display clear

// linie klawiatury - sterowanie na port P5
#define LINE_1		0x7f	// 0111 1111
#define LINE_2		0xbf	// 1011 1111
#define	LINE_3		0xdf	// 1101 1111
#define LINE_4		0xef	// 1110 1111
#define ALL_LINES	0x0f	// 0000 1111



org 0477h
 ce: db "c1",00
org 057bh
 cis: db "cis1", 00
org 047dh
 de: db "d1", 00
org 67eh
 dis: db "dis1", 00


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

		
// tablica przekodowania klawisze - dźwięki w XRAM

keymuz:		
			mov dptr, #8077H
			mov a, #12H
			movx @dptr, a
			
			mov dptr, #807BH
			mov a, #0E8H
			movx @dptr, a
			
			mov dptr, #807DH
			mov a, #0B4H
			movx @dptr, a

			mov dptr, #807EH
			mov a, #072H
			movx @dptr, a

			mov dptr, #80B7H
			mov a, #0D0H
			movx @dptr, a
			
			mov dptr, #80BBH
			mov a, #0C4H
			movx @dptr, a
			
			mov dptr, #80BDH
			mov a, #0B9H
			movx @dptr, a

			mov dptr, #80BEH
			mov a, #072H
			movx @dptr, a

			mov dptr, #80D7H
			mov a, #098H
			movx @dptr, a

			mov dptr, #80DBH
			mov a, #020H
			movx @dptr, a

			mov dptr, #80DDH
			mov a, #09EH
			movx @dptr, a

			mov dptr, #80DEH
			mov a, #018H
			movx @dptr, a

			mov dptr, #80E7H
			mov a, #08AH
			movx @dptr, a

			mov dptr, #80EBH
			mov a, #0F4H
			movx @dptr, a
			
			mov dptr, #80EDH
			mov a, #05AH
			movx @dptr, a

			mov dptr, #80EEH
			mov a, #0BAH
			movx @dptr, a
			
			mov dptr, #8177H
			mov a, #0F1H
			movx @dptr, a
			
			mov dptr, #817BH
			mov a, #0F1H
			movx @dptr, a
			
			mov dptr, #817DH
			mov a, #0F2H
			movx @dptr, a

			mov dptr, #817EH
			mov a, #0F3H
			movx @dptr, a

			mov dptr, #81B7H
			mov a, #0F3H
			movx @dptr, a
			
			mov dptr, #81BBH
			mov a, #0F4H
			movx @dptr, a
			
			mov dptr, #81BDH
			mov a, #0F4H
			movx @dptr, a

			mov dptr, #81BEH
			mov a, #0F5H
			movx @dptr, a

			mov dptr, #81D7H
			mov a, #0F6H
			movx @dptr, a

			mov dptr, #81DBH
			mov a, #0F6H
			movx @dptr, a

			mov dptr, #81DDH
			mov a, #0F7H
			movx @dptr, a

			mov dptr, #81DEH
			mov a, #0F8H
			movx @dptr, a

			mov dptr, #81E7H
			mov a, #0F8H
			movx @dptr, a

			mov dptr, #81EBH
			mov a, #0F8H
			movx @dptr, a
			
			mov dptr, #81EDH
			mov a, #0F9H
			movx @dptr, a

			mov dptr, #81EEH
			mov a, #0F9H
			movx @dptr, a
					
			ret


 



// program glówny
    start:  		acall keymuz
			MOV TMOD, #01H ; konfiguracja
			MOV IE, #82H  ; przerwania wlacz
	graj:		MOV r4, #00H  ; dotychczasowy klawisz
 			CLR TR0      ; timer stop
		
	key_1:	mov r0, #LINE_1
			mov	a, r0
			mov	P5, a
			mov a, P7
			anl a, r0
			mov r2, a
			clr c
			subb a, r0	; sprawdzenie czy coś naciśnięte
			jz key_2
			mov a, r2
			clr c
			subb a, r4	; sprawdzenie czy ten sam guzik znów naciśnięty
			jz key_1
			mov a, r2
			mov r4,a	; aktualizacja nowego guzika naciśniętego
			mov dph, #81h	; ładowanie wartości TH0 i R6
			mov dpl, a
			movx a,@dptr
			mov R6, a
			mov TH0, a
			mov a, r2
			mov dph, #80h	; ładowanie wartości TL0 i R7
			mov dpl, a
			movx a,@dptr
			mov R7, a
			mov TL0, a
			setb TR0	; włączenie timera - włączenie dźwięku
			jmp key_1
			
	key_2:	mov r0, #LINE_2
			mov	a, r0
			mov	P5, a
			mov a, P7
			anl a, r0
			mov r2, a
			clr c
			subb a, r0
			jz key_3
			mov a, r2
			clr c
			subb a, r4
			jz key_2
			mov a, r2
			mov r4, a
			mov a, r2
			mov dph, #81h
			mov dpl, a
			movx a,@dptr
			mov R6, a
			mov TH0, a
			mov a, r2
			mov dph, #80h
			mov dpl, a
			movx a,@dptr
			mov R7, a
			mov TL0, a
			setb TR0
			jmp key_2
			
	key_3:	mov r0, #LINE_3
			mov	a, r0
			mov	P5, a
			mov a, P7
			anl a, r0
			mov r2, a
			clr c
			subb a, r0
			jz key_4
			mov a, r2
			clr c
			subb a, r4
			jz key_3
			mov a, r2
			mov r4,a
			mov dph, #81h
			mov dpl, a
			movx a,@dptr
			mov R6, a
			mov TH0, a
			mov a, r2
			mov dph, #80h
			mov dpl, a
			movx a,@dptr
			mov R7, a
			mov TL0, a
			setb TR0
			jmp key_3
			
	key_4:	mov r0, #LINE_4
			mov	a, r0
			mov	P5, a
			mov a, P7
			anl a, r0
			mov r2, a
			clr c
			subb a, r0
			jz dalej
			mov a, r2
			clr c
			subb a, r4
			jz key_4
			mov a, r2
			mov r4,a
			mov dph, #81h
			mov dpl, a
			movx a,@dptr
			mov R6, a
			mov TH0, a
			mov a, r2
			mov dph, #80h
			mov dpl, a
			movx a,@dptr
			mov R7, a
			mov TL0, a
			setb TR0
			jmp key_4	
	dalej:		jmp graj    
 
    nop
    nop
    nop
    jmp $
    end start
