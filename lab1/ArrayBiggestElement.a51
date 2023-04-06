ljmp start

org 50h
	dodaj:								;adds content of accumulator into a slot in XRAM memory
		movx @dptr, a
		inc dptr
		ret
org 100h								;program searches for biggest element in 16-element array
	start:	mov dptr, #8000h			;array initialization and fill
	mov a, #12h
	acall dodaj

	mov a, #65h
	acall dodaj
	
	mov a, #4fh
	acall dodaj
	
	mov a, #2ah
	acall dodaj
	
	mov a, #0ffh
	acall dodaj
	
	mov a, #0aah
	acall dodaj
	
	mov a, #76h
	acall dodaj
	
	mov a, #0c6h
	acall dodaj
	
	mov a, #0edh
	acall dodaj
	
	mov a, #99h
	acall dodaj
	
	mov a, #9ah
	acall dodaj
	
	mov a, #0a8h
	acall dodaj
	
	mov a, #0fdh
	acall dodaj
	
	mov a, #15h
	acall dodaj
	
	mov a, #7eh
	acall dodaj
	
	mov a, #34h
	acall dodaj
		
	mov dptr, #7fffh				;sets dptr to one less than array address
	mov b, #00h;
	petla:							;biggest element will be held in b register
		inc dptr
		clr c						;clears C flag
		movx a, @dptr
		jz koniec
		cjne a, b, warunek1			;if a<b set CY flag to 1, else it sets if to 0 and jumps to the first condition
		jmp petla					;in case numbers were equal
		
	warunek1:						;if a<b then it's true and b stays the same
		jnc warunek2
		jmp petla
		
	warunek2:						;if b<a, moves value from a to b
		mov b, a
		jmp petla		
		
	koniec:
	nop
	nop
	nop
	jmp $
	end start
	
