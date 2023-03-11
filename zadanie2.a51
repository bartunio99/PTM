ljmp start

org 50h
	dodaj:								;dodaje zawartosc akumulatora do w dane miejsce pamieci XRAM
		movx @dptr, a
		inc dptr
		ret
org 100h								;program wybiera najwiekszy element tablicy
	start:	mov dptr, #8000h			;inicjalizacja tablicy
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
		
	mov dptr, #7fffh				;przywraca dptr na 1 przed poczatkiem tablicy
	mov b, #00h;
	petla:							;najwiekszy element bedzie przechowywany w rejestrze b
		inc dptr
		clr c						;czysci flage C
		movx a, @dptr
		jz koniec
		cjne a, b, warunek1			;jesli a<b ustawia flage CY na 1, w przeciwnym wypadku na 0 i skacze do warunku 1
		jmp petla					;wentyl bezpieczenstwa, jakby byly rowne
		
	warunek1:						;jesli a<b to jest spelniony i b zostaje bez zmian
		jnc warunek2
		jmp petla
		
	warunek2:						;jesli b<a to ustawia a na b
		mov b, a
		jmp petla		
		
	koniec:
	nop
	nop
	nop
	jmp $
	end start
	