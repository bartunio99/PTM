ljmp start              ;program binds buttons (bit inputs P3.2-P3.5) with prompts (strings 1-4), when certain button is pressed, text appears on screen,
                        ;when 2 utter buttons are pressed, it terminates itself

org 100h
	LCDstatus equ 0FF2EH
	LCDcontrol equ 0FF2CH
	LCDdataWR equ 0FF2DH
		
	#define HOME 0x80
	#define INITDISP 0x38
	#define HOM2 0xc0
	#define LCDON 0x0e
	#define CLEAR 0x01
	
	LCDcntrlWR MACRO x
		LOCAL loop
	loop:
		MOV DPTR,#LCDstatus
		MOVX A,@DPTR
		JB ACC.7,loop 					; check if LCD busy
		
		MOV DPTR,#LCDcontrol 			; write to LCD control
		MOV A, x
		MOVX @DPTR,A
		ENDM
		
		
	LCDcharWR MACRO
		LOCAL loop1,loop2
		PUSH ACC
		
	loop1: 	MOV DPTR,#LCDstatus
			MOVX A,@DPTR
			JB ACC.7,loop1 					; check if LCD busy
		
	loop2:	MOV DPTR,#LCDdataWR 			; write data to LCD
			POP ACC
			MOVX @DPTR,A
		ENDM	
	
	
	init_LCD MACRO
		LCDcntrlWR #INITDISP
		LCDcntrlWR #CLEAR
		LCDcntrlWR #LCDON
		ENDM
	
	putcharLCD:	LCDcharWR
				ret
	
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
	
	
	
	// delay function
	delay:	mov r0, #15H
	one:	mov r1, #0FFH
	two:	mov r2, #0FFH
    three:	djnz r2, three
			djnz r1, two
			djnz r0, one
			ret
	
	string1: db "lubie ptm", 00			
	string2: db "piwo", 00
	string3: db "ciasteczka", 00
	string4: db "asembler", 00
	
	
	start:	init_LCD
			 
	loop: 	LCDcntrlWR #CLEAR
			LCDcntrlWR #HOME
	
			mov a, p3
			subb a, #0dbh		;1101 1011 - exit
			jz exit
			
			mov a, p3
			subb a, #0dfh		;1101 1111 - string 1
			jz s1
			
			mov a, p3
			subb a, #0efh		;1110 1111 - string 2
			jz s2
			
			mov a, p3
			subb a, #0f7h		;1111 01111 - string 3
			jz s3
			
			mov a, p3
			subb a, #0fbh		;1111 1011 - string 4
			jz s4
			jmp loop
		  
	s1:	
		mov dptr, #string1
		acall putstrLCD
		acall delay
		jmp loop
		
	s2:	
		mov dptr, #string2
		acall putstrLCD
		acall delay
		jmp loop
		
	s3:	
		mov dptr, #string3
		acall putstrLCD
		acall delay
		jmp loop
		
	s4:	
		mov dptr, #string4
		acall putstrLCD
		acall delay
		jmp loop
		
				
	exit:
		LCDcntrlWR #CLEAR
		nop
		nop
		nop
		jmp $
		end start
