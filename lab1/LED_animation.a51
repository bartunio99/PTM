ljmp start                  ;punkt startowy - skok dlugi do etykiety "start"
            
org 050h                    ;ulokowanie sekcji kodu w 050h w pamieci kodu programu      
    delay: mov r0, #0ffh    ;przypisanie duzej liczby (0ffh) do r0
    one: mov r1, #0fah      ;przypisanie duzej liczby (0fah) do r1
    two: djnz r1, two       ;1)r1 -> r1-1  2)skok do "two" wykonywany gdy r1 != 0
         djnz r0, one       ;1)r2 -> r2-1  2)skok do "one" wykonywany gdy r2 != 0
         ret
     
org 0100h                   ;ulokowanie sekcji kodu w 0100h w pamieci kodu programu    
    start:    
        mov a, #1h          ;wpisanie do a wartosci startowej animacji
        mov p1, a           ;wyswietlenie aktualnej zawartosci a na LEDach
        acall delay         ;wywolanie "zastoju"

        mov b, #4h          ;wpisanie do b mnoznika aktualnej wartosci 
        mul ab              ;wykonanie mnozenia
        mov p1, a           
        acall delay

        mov b, #4h
        mul ab
        mov p1, a
        acall delay

        mov b, #4h
        mul ab
        mov p1, a
        acall delay
 
     jmp start              ;skok do start - powtorzenie sekwencji wyswietlania
       
    nop
    nop
    nop
    jmp $
    end start
