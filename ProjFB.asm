[org 0x100]

jmp start


; New data for beautification
borderHorizontal:  db '============================================================       '
borderVertical:    db '||                                                        ||       '
titleArt1:         db '  ______ _                               ____  _         __     '
titleArt2:         db ' |  ____| |                             |  _ \(_)       |  |     '
titleArt3:         db ' | |__  | | __ _ _ __  _ __   __ __     | |_) | |_ _    |  |     '
titleArt4:         db ' |  __| | |/ _` | `_ \| `_ \ | | | |    |  _ <| | `_ \__|_ |     '
titleArt5:         db ' | |    | | (_| | |_) | |_) || |_| |    | |_) | | | |_| |_)|     '
titleArt6:         db ' |_|    |_|\__,_| .__/| .__/  \__, |    |____/|_|_|   \____|     '
titleArt7:         db '                | |   | |      __/ |                               ' 
titleArt8:         db '                |_|   |_|     |___/                                '


borderHorizontal1:  db '================================================'
borderVertical1:    db '||                                            ||'


gameOverMsg:   db 'GAME OVER'
scoreMsg:      db 'YOUR SCORE:'
restartMsg:    db 'Press Any Key to Return To Menu'

; data:                 dw        0x98EE
UpKeyReleased		  dw		0
birdSize:             dw        6
BirdXPostion:         dw        100
BirdYPostion:         dw        81
BirdFlyFlag:          dw        0
exitMessage:          db        'Exiting Game   ?'

instructionmsg:       db        'INSTRUCTIONS'
members:              db        'MEMBERS'
yesMsg:               db        '(Y) to Exit'
noMsg:                db        '(N) to Resume'
escapeFlag:           db        0
mainScreen:			  dw		0xA000
bufferAddress:        dw        0x49F0
backGroundYPosition:  dw        180
oldTimerISR:		  dd		0
tickCountFlyFlag:	  dw		0
oldKbISR:             dd        0
buffer2:              dw        0x39F0
BackgroundColor:      dw        0x004B
buffer3:              dw        0x29F5
counter:              dw        160
flag:                 dw        1
collisionFlag:		  db		0
score:				  dw		0
correctDSvalue		  dw		0
blockSize:			  dw		15
delayFlag:			  dw		1

startMsg:    db '->Press Any Key To Continue<-'
startMsg1:   db 'Hope You Enjoy Playing The Game!'
startMsg2:   db 'GOOD LUCK :)'
startMenuMsg1:    db 'FLAPPY BIRD'
menuNewGame:      db '1.Play Game'
menuInfo:         db '2.Information'
menuExit:         db '4.Exit Game'
menudev:          db '3.Project Group'

instruction1: db '1.Use Arrow Up Key to Move Bird Up'
instruction2: db '2.Release Arrow Up Key To Move Bird Down'
instruction3: db '3.Press ESC to Pause the Game'
instruction4: db '4.Press Y/N to Exit or Continue the Game'


Name1:    	db '1.Umer Mujahid'
Name2:      db '2.M.Basim Irfan'
Roll1:      db '23L-0774'
Roll2:      db '23L-0846'
Batch:      db 'BCS-3J-23'

menuChoice:       db 0
startBackground:  db 0x0b

;PCB layout:
; ax,bx,cx,dx,si,di,bp,sp,ip,cs,ds,ss,es,flags,next,dummy
; 0, 2, 4, 6, 8,10,12,14,16,18,20,22,24, 26 , 28 , 30
pcb: times 3*16 dw 0 ; space for 3 PCBs
stack: times 3*512 dw 0 ; space for 3 1024 byte stacks
nextpcb: dw 1 ; index of next free pcb
current: dw 0 ; index of current pcb
lineno: dw 0 ; line number for next thread

reInitializeVariables:
					
						mov word [UpKeyReleased], 0
						mov word [birdSize], 6
						mov word [BirdXPostion], 100
						mov word [BirdYPostion], 81
						mov word [BirdFlyFlag], 0
						mov byte [escapeFlag], 0
						mov word [mainScreen], 0xA000
						mov word [bufferAddress], 0xC800
						mov word [backGroundYPosition], 180
					
						;mov word [oldTimerISR], 0
						;mov word [oldTimerISR+2], 0
					
						mov word [tickCountFlyFlag], 0
					
						mov word [oldKbISR], 0
						mov word [oldKbISR+2], 0
					
						mov word [buffer2], 0xD800
						mov word [BackgroundColor], 0x004B
						mov word [buffer3], 0x29FC
						mov word [counter], 160
						mov word [flag], 1
						mov byte [collisionFlag], 0
						mov word [score], 0
						mov word [correctDSvalue], 0
					
				ret
					
delay:      
		push cx
		mov cx, 0xFFFF
		
		delayL1:	
				loop delayL1
			
		mov cx, 0xFFFF
		
		
		delayL2:		
				loop delayL2
				
				
		pop cx
		
	ret
; New procedures for start screen

printNumInTextMode:
					push bp
					mov bp, sp
					
					pushA
					push es
					
					;[bp+4] has the num to be printed
					;[bp+6] has the column number
					;[bp+8] has the row number
					
					
					push 0xB800
					pop es
					
					mov ax, 80
					mov bx, [bp+8]
					mul bx
					add ax, [bp+6]
					shl ax, 1
					
					mov di, ax
					
					mov bx, 10 ; using decimal base
					mov ax, [bp+4]
					mov cx, 4
					
					nextDigit:
								mov dx, 0
								div bx
								add dl, 0x30
								mov dh, 0x07
								mov [es:di], dx
								
								sub di, 2
								
								loop nextDigit
					
					pop es
					popA
					pop bp
						
			ret 6
				
displayStartMsg:
    push bp
    mov bp, sp
    pushA
	
    ;Display start message
    mov ah, 0x13
    mov al, 1           ; Write mode 1
    mov bh, 0           ; Page number
    mov bl, 0x0b        ; Blue color
    mov cx, 29          ; String length
    mov dh, 10          ; Row
    mov dl, 5           ; Column
    push cs
    pop es
    mov bp, startMsg
    int 0x10
    
	;Display start message
    mov ah, 0x13
    mov al, 1           ; Write mode 1
    mov bh, 0           ; Page number
    mov bl, 0x09        ; Blue color
    mov cx, 32          ; String length
    mov dh, 5          ; Row
    mov dl, 4           ; Column
    push cs
    pop es
    mov bp, startMsg1
    int 0x10
	
	;Display start message
    mov ah, 0x13
    mov al, 1           ; Write mode 1
    mov bh, 0           ; Page number
    mov bl, 0x9        ; Blue color
    mov cx, 12         ; String length
    mov dh, 15          ; Row
    mov dl, 13           ; Column
    push cs
    pop es
    mov bp, startMsg2
    int 0x10
	
	call clear_keystream
    ;Wait for key press without clearing the screen
    xor ah, ah
    int 0x16
    
    popA
    pop bp
	
    ret
	
	

	
; set_background:
    ; pusha
    ; mov ax, 0xA000       ; VGA segment
    ; mov es, ax
    ; xor di, di           ; Start at offset 0
    ; mov al, 0x0E         ; Cyan color
    ; mov cx, 64000        ; 320x200 screen size
    ; rep stosb            ; Fill the screen
    ; popa
    ; ret
set_background:
    pusha
    ; mov ax, 0xb800      
    ; mov es, ax
    ; xor di, di           ; Start at offset 0
	; mov al,' '
    ; mov ah, 0x8        ; Cyan color
    ; mov cx, 2000        ; 320x200 screen size
    ; loop_next:            ; Fill the screen
	; mov word [es:di],ax
	; add di,2
	; loop loop_next
	 ;Set background color to blue
    mov ah, 0Bh         ; Set background color
    mov bh, 0           ; Page 0
    mov bl, 0x09        ; Blue color
    int 10h
    popa
    ret


; displayStartMenu:
        ; push bp
        ; mov bp, sp
        ; pushA
        
		
        ; ; Display game title
        ; mov ah, 0x13
        ; mov al, 1           ; Write mode 1
        ; mov bh, 0          ; Page number
        ; mov bl, 0x0c      ; Blue color
        ; mov cx, 11        ; String length
        ; mov dh, 11          ; Row
        ; mov dl, 33         ; Column
        ; push cs
        ; pop es
        ; mov bp, startMenuMsg1
        ; int 0x10
		
        ; ; Display "New Game" option
        ; mov ah, 0x13
		; mov al, 1           ; Write mode 1
        ; mov bh, 0          ; Page number
        ; mov bl, 0xf       ; Red color
        ; mov cx, 11         ; String length
        ; mov dh, 15         ; Row
        ; mov dl, 33         ; Column
        ; mov bp, menuNewGame
        ; int 0x10
        
        ; ; Display "Information" option
        ; mov ah, 0x13
        ; mov cx, 13         ; String length
        ; mov dh, 17         ; Row
        ; mov dl, 33         ; Column
        ; mov bp, menuInfo
        ; int 0x10
        
        ; ; Display "Exit" option
        ; mov ah, 0x13
        ; mov cx, 11         ; String length
        ; mov dh, 19         ; Row
        ; mov dl, 33         ; Column
        ; mov bp, menuExit
        ; int 0x10
		
		; ; Display Name1
		
        ; mov ah, 0x13
        ; mov al, 1           ; Write mode 1
        ; mov bh, 0          ; Page number
        ; mov bl, 0xE      ; Blue color
        ; mov cx, 12        ; String length
        ; mov dh, 1          ; Row
        ; mov dl, 1         ; Column
        ; push cs
        ; pop es
        ; mov bp, Name1
        ; int 0x10
		; ; Display Roll1
		
        ; mov ah, 0x13
        ; mov al, 1           ; Write mode 1
        ; mov bh, 0          ; Page number
        ; mov bl, 0xE      ; Blue color
        ; mov cx, 8        ; String length
        ; mov dh, 3          ; Row
        ; mov dl, 3         ; Column
        ; push cs
        ; pop es
        ; mov bp, Roll1
        ; int 0x10
		
		; ; Display Batch
		
        ; mov ah, 0x13
        ; mov al, 1           ; Write mode 1
        ; mov bh, 0          ; Page number
        ; mov bl, 0xE      ; Blue color
        ; mov cx, 9        ; String length
        ; mov dh, 5          ; Row
        ; mov dl, 3         ; Column
        ; push cs
        ; pop es
        ; mov bp, Batch
        ; int 0x10
		
		
		; ; Display Name2
		
        ; mov ah, 0x13
        ; mov al, 1           ; Write mode 1
        ; mov bh, 0          ; Page number
        ; mov bl, 0xE      ; Blue color
        ; mov cx, 13        ; String length
        ; mov dh, 1          ; Row
        ; mov dl, 65         ; Column
        ; push cs
        ; pop es
        ; mov bp, Name2
        ; int 0x10
		; ; Display Roll2
		
        ; mov ah, 0x13
        ; mov al, 1           ; Write mode 1
        ; mov bh, 0          ; Page number
        ; mov bl, 0xE      ; Blue color
        ; mov cx, 8        ; String length
        ; mov dh, 3          ; Row
        ; mov dl, 67         ; Column
        ; push cs
        ; pop es
        ; mov bp, Roll2
        ; int 0x10
		
		; ; Display Batch
		
        ; mov ah, 0x13
        ; mov al, 1           ; Write mode 1
        ; mov bh, 0          ; Page number
        ; mov bl, 0xE      ; Blue color
        ; mov cx, 9        ; String length
        ; mov dh, 5          ; Row
        ; mov dl, 67         ; Column
        ; push cs
        ; pop es
        ; mov bp, Batch
        ; int 0x10
		
        ; popA
        ; pop bp
        ; ret
		; Enhanced displayStartMenu procedure
displayStartMenu:
    ; Clear screen
    mov ax, 0x0003      ; Text mode
    int 0x10
    
    ; Set background color to green
    mov ah, 0Bh
    mov bh, 0
    mov bl, 0x02        ; Green background
    int 10h
    
    ; Display Border Top
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 62
    mov dh, 2
    mov dl, 11
    push cs
    pop es
    mov bp, borderHorizontal

    int 0x10
    
    ; ; Display Border Sides
    ; mov cx, 1
    ; mov dh, 4
    ; borderLoop:
        ; push cx
        ; mov ah, 0x13
        ; mov al, 1
        ; mov bh, 0
        ; mov bl, 0x0E    ; Yellow color
        ; mov cx, 60
        ; mov dl, 11
        ; push cs
        ; pop es
        ; mov bp, borderVertical
        ; int 0x10
        
        ; inc dh
        ; pop cx
        ; inc cx
        ; cmp cx, 15
        ; jle borderLoop
    
    ; Display Border Bottom
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 62
    mov dh, 22
    mov dl, 11
    push cs
    pop es
    mov bp, borderHorizontal
    int 0x10
    
   ; Display ASCII Art Title
mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x0C        ; Red color

; Display each line of title art
mov cx, 63
mov dh, 4           ; Adjust vertical position if needed
mov dl, 11         ; Center the title
mov bp, titleArt1
int 0x10

inc dh
mov bp, titleArt2
int 0x10

inc dh
mov bp, titleArt3
int 0x10

inc dh
mov bp, titleArt4
int 0x10

inc dh
mov bp, titleArt5
int 0x10

inc dh
mov bp, titleArt6
int 0x10

inc dh
mov bp, titleArt7
int 0x10

inc dh
mov bp, titleArt8
int 0x10
    
    ; Rest of the existing displayStartMenu code remains the same
    ; Display "New Game" option
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0F        ; White color
    mov cx, 11
    mov dh, 14
    mov dl, 33
    mov bp, menuNewGame
    int 0x10
    
    ; Display "Information" option
    mov ah, 0x13
    mov cx, 13
    mov dh, 16
    mov dl, 33
    mov bp, menuInfo
    int 0x10
    
    ; Display "Exit" option
    mov ah, 0x13
    mov cx, 11
    mov dh, 20
    mov dl, 33
    mov bp, menuExit
    int 0x10
	
	; Display "Exit" option
    mov ah, 0x13
    mov cx, 15
    mov dh, 18
    mov dl, 33
    mov bp, menudev
    int 0x10
    
    ret

handleStartMenu:
        push bp
        mov bp, sp
        push ax
        
        waitForInput:
            ; Wait for keypress
            xor ah, ah
            int 0x16
            
            ; Compare with options
            cmp al, '1'
            je startNewGame
            cmp al, '2'
            je showInfo
			cmp al, '3'
            je showdev1
			cmp al, '4'
            je exitGame1
            jmp waitForInput
            
        startNewGame:
            mov byte [menuChoice], 1
            jmp MenuEnd
            
        showInfo:
            mov byte [menuChoice], 2
            jmp MenuEnd
		
		showdev1:
		    mov byte [menuChoice], 3
			jmp MenuEnd
            
        exitGame1:
            mov byte [menuChoice], 4
		
            
        MenuEnd:
            pop ax
            pop bp
            ret


showInstructions:
    ; Clear screen
    mov ax, 0x0003      ; Text mode
    int 0x10



    ; Display Border Top
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 48         ; Border width
    mov dh, 3           ; Row position
    mov dl, 15          ; Column position
    push cs
    pop es
    mov bp, borderHorizontal1
    int 0x10
    
    ; Display Border Sides (10 rows)
    mov cx, 1
    mov dh, 4
    borderLoop3:
        push cx
        mov ah, 0x13
        mov al, 1
        mov bh, 0
        mov bl, 0x0E    ; Yellow color
        mov cx, 48     ; Border width
        mov dl, 15      ; Column position
        push cs
        pop es
        mov bp, borderVertical1
        int 0x10
        
        inc dh
        pop cx
        inc cx
        cmp cx, 15
        jle borderLoop3
    
    ; Display Border Bottom
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 48          ; Border width
    mov dh, 19
    mov dl, 15          ; Column position
    push cs
    pop es
    mov bp, borderHorizontal
    int 0x10




    mov ah, 0x13
    mov al, 1           ; Write mode 1
    mov bh, 0           ; Page number
    mov bl, 0x9        ; Blue color
    mov cx, 12         ; String length
    mov dh, 5          ; Row
    mov dl, 32          ; Column
    push cs
    pop es
    mov bp, instructionmsg
    int 0x10





    ; Display instructions
    mov ah, 0x13
    mov al, 1           ; Write mode
    mov bh, 0           ; Page number
    mov bl, 0x5        ; Yellow color
    
    ; First instruction
    mov cx, 34
    mov dh, 8           ; Row
    mov dl, 19           ; Column
    push cs
    pop es
    mov bp, instruction1
    int 0x10

    ; Second instruction
    mov cx, 40
    mov dh, 10
    mov bp, instruction2
    int 0x10

    ; Third instruction
    mov cx, 29
    mov dh, 12
    mov bp, instruction3
    int 0x10

    ; Fourth instruction
    mov cx, 40
    mov dh, 14
    mov bp, instruction4
    int 0x10

    ; Wait for key press
    xor ah, ah
    int 0x16

    ; Return to start menu
    mov ax, 0x0003      ; Graphics mode
    int 0x10
    ret



showdevs:
    ; Clear screen
    mov ax, 0x0003      ; Text mode
    int 0x10


 ; Display Border Top
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 48         ; Border width
    mov dh, 3           ; Row position
    mov dl, 15          ; Column position
    push cs
    pop es
    mov bp, borderHorizontal1
    int 0x10
    
    ; Display Border Sides (10 rows)
    mov cx, 1
    mov dh, 4
    borderLoop4:
        push cx
        mov ah, 0x13
        mov al, 1
        mov bh, 0
        mov bl, 0x0E    ; Yellow color
        mov cx, 48     ; Border width
        mov dl, 15      ; Column position
        push cs
        pop es
        mov bp, borderVertical1
        int 0x10
        
        inc dh
        pop cx
        inc cx
        cmp cx, 15
        jle borderLoop4
    
    ; Display Border Bottom
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 48          ; Border width
    mov dh, 19
    mov dl, 15          ; Column position
    push cs
    pop es
    mov bp, borderHorizontal
    int 0x10




    mov ah, 0x13
    mov al, 1           ; Write mode 1
    mov bh, 0           ; Page number
    mov bl, 0x7        ; Blue color
    mov cx, 7         ; String length
    mov dh, 5          ; Row
    mov dl, 35          ; Column
    push cs
    pop es
    mov bp, members
    int 0x10










   ; Display Name1
		
        mov ah, 0x13
        mov al, 1           ; Write mode 1
        mov bh, 0          ; Page number
        mov bl, 0x06      ; Blue color
        mov cx, 14        ; String length
        mov dh, 9          ; Row
        mov dl, 22        ; Column
        push cs
        pop es
        mov bp, Name1
        int 0x10
		; Display Roll1
		
        mov ah, 0x13
        mov al, 1           ; Write mode 1
        mov bh, 0          ; Page number
        mov bl, 0x06      ; Blue color
        mov cx, 8        ; String length
        mov dh, 11          ; Row
        mov dl, 24         ; Column
        push cs
        pop es
        mov bp, Roll1
        int 0x10
		
		; Display Batch1
		
        mov ah, 0x13
        mov al, 1           ; Write mode 1
        mov bh, 0          ; Page number
        mov bl, 0x06      ; Blue color
        mov cx, 9        ; String length
        mov dh, 13          ; Row
        mov dl, 24         ; Column
        push cs
        pop es
        mov bp, Batch
        int 0x10
		
		
		; Display Name2
		
        mov ah, 0x13
        mov al, 1           ; Write mode 1
        mov bh, 0          ; Page number
        mov bl, 0x06      ; Blue color
        mov cx, 15        ; String length
        mov dh, 9          ; Row
        mov dl, 40         ; Column
        push cs
        pop es
        mov bp, Name2
        int 0x10
		; Display Roll2
		
        mov ah, 0x13
        mov al, 1           ; Write mode 1
        mov bh, 0          ; Page number
        mov bl, 0x06      ; Blue color
        mov cx, 8        ; String length
        mov dh, 11          ; Row
        mov dl, 42         ; Column
        push cs
        pop es
        mov bp, Roll2
        int 0x10
		
		; Display Batch2
		
        mov ah, 0x13
        mov al, 1           ; Write mode 1
        mov bh, 0          ; Page number
        mov bl, 0x06      ; Blue color
        mov cx, 9        ; String length
        mov dh, 13          ; Row
        mov dl, 42         ; Column
        push cs
        pop es
        mov bp, Batch
        int 0x10
		
		 ; Wait for key press
    xor ah, ah
    int 0x16
        
		mov ax, 0x0003      ; Graphics mode
        int 0x10
        ret


clrScr:
        push ax
        push cx
        push es
        push di

        push  word 0xA000
        pop es
        mov di, 0
        mov al, 3
        mov cx, 64000

        rep stosb

        pop di
        pop es
        pop cx
        pop ax

    ret
	
printBlock:
			push bp
			mov bp, sp
			sub sp, 2
			
			pushA
			push es
			
			mov ax, 320
			mov bx, [bp+6]
			mul bx
			add ax, [bp+8]
			
			mov [bp-2], ax
			
			push word [bp+10]
			pop es
			
			mov cx, [cs:blockSize]
			printBlockL1:
							mov di, [bp-2]
							mov ax, [bp+4]
							
							push cx
							mov cx, [cs:blockSize]
							cld
							printBlockL2:
											stosb
											;inc ax
											loop printBlockL2
							
							add word [bp-2], 320
							pop cx
							
							loop printBlockL1
			
			pop es
			popA
			add sp, 2
			pop bp
			
		ret 8

makeClouds:
			
			;First Cloud
			push word [bp+4]
			push word 100
			push word 100
			push word 15
			call printBlock
		
			push word [bp+4]
			push word 110
			push word 90
			push word 15
			call printBlock
			
			
			push word [bp+4]
			push word 110
			push word 100
			push word 15
			call printBlock
			
			push word [bp+4]
			push word 120
			push word 100
			push word 15
			call printBlock
			
			
			;Second Cloud
			push word [bp+4]
			push word 230
			push word 30
			push word 15
			call printBlock
		
			push word [bp+4]
			push word 240
			push word 20
			push word 15
			call printBlock
			
			
			push word [bp+4]
			push word 240
			push word 30
			push word 15
			call printBlock
			
			push word [bp+4]
			push word 250
			push word 30
			push word 15
			call printBlock	
			
		ret
			

clrSCR:
        push bp
        mov bp, sp

        pushA
        push es

        mov ah, [bp+6]
        mov al, [bp+6]
        mov cx, 32000
        xor di, di

        push word [bp+4]
        pop es

        rep stosw
		
		call makeClouds

        pop es
        popA
        pop bp

    ret 4



setBackground:
                push bp
                mov bp, sp
                
                push ax
                push es
                push di

                push  word [bufferAddress]
                pop es
                xor di, di
                mov ah, [bp+4]
                mov al, [bp+4]
                mov cx, 28800
                rep stosw

                pop di
                pop es
                pop ax

                pop bp

         ret 2

setGround:
            push bp
            mov bp, sp
            sub sp, 2

            push ax
            push bx
            push cx
            push es
            push di

            mov ax, 320
            mov bx, 180
            mul bx

            mov di, ax
            mov cx, 64000
            sub cx, ax
            shr cx, 1

            push word [bufferAddress]
            pop es
            mov ax, 0x0606

            mov word [bp-2], 1
            mov bx, 20

            setGroundL1:
                        
                        inc word [bp-2]

                        cmp [bp-2], bx
                        jne Nothing

                        mov word [bp-2], 1
                        push ax
                        add bx, 1

                        mov ax, 0x0708
                        stosw
                        pop ax

                        loop setGroundL1
                        jmp setGroundL1E

                        Nothing:
                        stosw
                        loop setGroundL1

                        setGroundL1E:
                        

            pop di
            pop es
            pop cx
            pop bx
            pop ax

            add sp, 2
            pop bp

        ret

setScreen:
            push bp
            mov bp, sp

            push word [bp+4]
            call setBackground

            
            pop bp

        ret 2

makeTail:
            push bp
            mov bp, sp
            sub sp, 4 ;creating a local variables
            ;[bp-2] stores the initial di
            ;[bp-4] acts as a flag
            ;[bp+4] is the bird size
            ;[bp+6] is the column where bird will be
            ;[bp+8] is the row where bird will be
			
			pushA
			push es

            mov ax, 320
            mov bx, [bp+8]
            mul bx
            add ax, [bp+6]

            mov [bp-2], ax ; storing initial value of di 

            mov ax, [bp+4]
            shl ax, 1

           ; test ax,0x0001 ; check if the least significant bit is 1 or 0. if 1 the ax is odd otherwise zero
              ; if zero flag sets then ax is even

            dec ax

            mov cx, ax

            push word [bufferAddress]
            pop es
            
            mov word [bp-4], 1
            mov dx, 1
            drawTriangleL1:
                            cmp cx, 0
                            jz drawTriangleL1E

                            mov di, [bp-2]
                            mov bx, 1
                            drawTriangleL2:
                                            cmp bx, dx
                                            ja drawTriangleL2E

                                            mov ax, [bp+10]
                                            mov byte [es:di], al

                                            inc bx
                                            inc di

                                            jmp drawTriangleL2
                                        drawTriangleL2E:
                                            
                            cmp word [bp-4], 1
                            jnz decDX

                            inc dx
                            cmp dx, [bp+4]
                            jle sameFlag
                            
                            mov word [bp-4], 0
                            sub dx, 2

                            sameFlag:              
                            dec cx
                            add word  [bp-2], 320
                            jmp drawTriangleL1

                            decDX:
                            dec dx
                            dec cx
                            add word  [bp-2], 320
                            jmp drawTriangleL1

                        drawTriangleL1E:
			
			pop es
			popA
			
            add sp, 4
            pop bp

      ret 8

makeMainBody:

            push bp
            mov bp, sp
            sub sp, 2 ;creating local variables
            ;[bp-2] stores the value for di
            ;[bp+4] is the bird size
            ;[bp+6] is the column where bird will be
            ;[bp+8] is the row where bird will be
			
			pushA
			push es

            push word [bufferAddress]
            pop es

            mov ax, 320
            mov bx, [bp+8]
            mul bx
            add ax, [bp+6]

            add ax, [bp+4]  ; adding bird size here becuse the body will be infront of tail
            mov [bp-2], ax

            mov cx, [bp+4]
            shl cx, 1
            dec cx
            
            mov dx, [bp+4]
            add dx, 3 ; just want to make the body a bit larger than tail

            drawBodyL1:
                        mov bx, 1
                        mov di, [bp-2]
                        drawBodyL2:
                                    cmp bx, dx
                                    ja drawBodyL2E

                                    mov byte [es:di], 4

                                    inc bx
                                    inc di
                                    jmp drawBodyL2
                                    drawBodyL2E:
                        add word [bp-2], 320

                        loop drawBodyL1

			pop es
			popA
            add sp, 2
            pop bp
        ret 6

makeWing:
        push bp
        mov bp, sp
        sub sp, 2 ; creating local variable

        ;[bp+4] is the bird size
        ;[bp+6] is the column where bird will be
        ;[bp+8] is the row where bird will be
		
		pushA
		push es
        
        mov ax, 320
        mov bx, [bp+8]
        
        add bx, [bp+4] ; the wing will be inside main body thus adding 4 rows
        mul bx
        add ax, [bp+6]

        add ax, [bp+4]  ; adding the tail size
        add ax, 1       ; remember! we made the body 2 pixels larger than tail, so adding 2
        mov [bp-2], ax

        mov cx, [bp+4]
        shr cx, 1

        mov dx, [bp+4]
        dec dx

        push word [bufferAddress]
        pop es

        drawWingL1:
                    mov di, [bp-2]
                    mov bx, 1

                    drawWingL2:
                                cmp bx, dx
                                ja drawWingL2E
                                
                                mov byte [es:di], 0x0

                                inc bx
                                inc di

                                jmp drawWingL2
                                drawWingL2E:

                    add word [bp-2], 320
                    loop drawWingL1
        
		pop es
		popA
        add sp, 2
        pop bp

    ret 6

makeEye:
        push bp
        mov bp, sp
        sub sp, 2   ; creating local variable
        ;[bp+4] is the bird size    
        ;[bp+6] is the column where bird will be
        ;[bp+8] is the row where bird will be
		
		pushA
		push es

        mov ax, 320
        mov bx, [bp+8]
        add bx, 1
        mul bx
        add ax, [bp+6]

        add ax, [bp+4]  ;adding the size of tail
        add ax, [bp+4]

        mov [bp-2], ax

        mov cx, [bp+4]
        shr cx, 1

        mov dx, cx
        shr dx, 1

        push word [bufferAddress]
        pop es

        drawEyeL1:
                    mov di, [bp-2]
                    mov bx, 1
                    drawEyeL2:
                                cmp bx, dx
                                ja drawEyeL2E
                                
                                mov byte [es:di], 15

                                inc bx
                                inc di
                                jmp drawEyeL2
                                drawEyeL2E:
                    add word [bp-2], 320
                    loop drawEyeL1

		pop es
		popA
		
        add sp, 2
        pop bp

    ret 6

makeBody:
        push bp
        mov bp, sp

        push word [bp+8]
        push word [bp+6]
        push word [bp+4]
        call makeMainBody

        push word [bp+8]
        push word [bp+6]
        push word [bp+4]
        call makeWing

        push word [bp+8]
        push word [bp+6]
        push word [bp+4]
        call makeEye

        pop bp
    ret 6

makeBeek:
            push bp
            mov bp, sp
            pushA
			push es
            ;[bp+4] is the bird size
            ;[bp+6] is the column where bird will be
            ;[bp+8] is the row where bird will be

            push  word [bufferAddress]
            pop es
            
            mov ax, [bp+8]
            add ax, 2

            mov bx, [bp+6]
            add bx, [bp+4] ; adding the width of tail
            add bx, [bp+4]  ;adding the width of main body
            add bx, 3 ; remember! I made the main body 3 pixels wider

            mov cx, [bp+4]
            shr cx, 1

            push word 41
            push ax
            push bx
            push cx

            call  makeTail

			pop es
            popA
            
            pop bp
    ret 6

setBird:
        push bp
        mov bp, sp

        push word 0
        push word [bp+8]
        push word [bp+6]
        push word [bp+4]
        call makeTail

        push word [bp+8]
        push word [bp+6]
        push word [bp+4]
        call makeBody

        push word [bp+8]
        push word [bp+6]
        push word [bp+4]
        call makeBeek

        pop bp
    ret 6

Delay:
        pusha

        mov ah, 86h          ; function for bios delay
        mov cx, 15          ; high part of delay (in microseconds)
        mov dx, 10000        ; delay 10,000 microseconds (10 milliseconds)
        int 15h              ; bios interrupt for delay

        popa
    ret

generateRandomNum:
                    push bp
                    mov bp, sp
                    pushA

                    mov word [bp+4], 0

                    ; mov ah, 86h          ; Function for BIOS delay
                    ; mov cx, 0        ; High part of delay (in microseconds)
                    ; mov dx, 10000        ; Delay 10,000 microseconds (10 milliseconds)
                    ; int 15h              ; BIOS interrupt for delay

                    
                    mov ah, 00h       ; Function 00h - Get system clock ticks
                    int 1Ah           ; Call BIOS interrupt
                    xor dl, 127
                    rol dl, 4
                    mov [bp+4], dl        ; Use lower byte of DX (faster changing bits)

                   
                    popA
                    pop bp
            ret

makeNumberInRange:

                    push bp
                    mov bp, sp
                    sub sp, 4
                    pushA

                    mov word [bp+8], 0

                    mov ax, [bp+6]
                    add ax, 5
                    mov [bp-2], ax

                    mov ax, 180
                    sub ax, 5
                    ;sub ax, [bp-6]
                    mov [bp-4], ax

                  
                    mov bx, [bp-4]
                    sub bx, [bp-2]
                    inc bx

                    mov ax, [bp+4]
                    div bl

                    add ah, [bp-2]

                    mov [bp+8], ah

                    popA
                    add sp, 4
                    pop bp
            ret 4

makeColumns:
            push bp
            mov bp, sp
            sub sp, 8

            pushA
            push es

            sub sp, 2
            call generateRandomNum
            pop word [bp-2]

            mov word [bp-4], 0
            mov word [bp-6], 0

            mov ax, [birdSize]
            shl ax, 3
            mov [bp-8], ax

            sub sp, 2
            push word [bp-8]
            push word [bp-2]
            call makeNumberInRange
            pop word [bp-2]

            ; mov ax, [bp-2]
            ; mov [data], ax

            ;[bp-2] has the random gap of pillar
            ;[bp-4] stores the value for di (x-cordinate where the pillar will be printed)
            ;[bp-6] acts kind of like a flag since each row of pillar contains five shades of green


            push  word [bp+6]
            pop es

            mov cx, 180
            mov ax, [bp+4]
            mov [bp-4], ax

            
            cld

            makeColumnsL1:
                            mov bx, 1
                            mov di, [bp-4]
                            mov ax, 44 ;Look for 44=2Dh in VGA palette. Its a shade of green
                            mov word [bp-6], 1

                            push cx
                            mov cx, 15
                            makeColumnsL2:
                                            stosb

                                            inc word [bp-6]
                                            cmp word [bp-6], 3
                                            jbe sameColor

                                            inc ax
                                            mov word [bp-6], 1

                                            sameColor:
                                            loop makeColumnsL2
                            
                            pop cx
                            
                            add word [bp-4], 320 ; move to next row
                            add word [bp-8], 0

                            cmp cx, [bp-2]
                            jne noGap

                            sub cx, [bp-8]
                            ;inc cx

                            mov ax, 320
                            mov bx, [bp-8]
                            ;dec bx
                            mul bx

                            add [bp-4], ax

                            noGap:
                            loop makeColumnsL1

            pop es
            popA
            add sp, 8
            pop bp

        ret 4

moveGround:
            push bp
            mov bp, sp
            sub sp, 4

            pushA
            push es
            push ds

            mov ax, 320
            mov bx, 180
            mul bx
            mov [bp-2], ax

            push word [bufferAddress]
            pop es
            push word [bufferAddress]
            pop ds

            mov cx, 20

            moveGroundL1:

                        push cx
                        mov cx, 159

                        mov di, [bp-2]

                        mov ax, [es:di]
                        mov [bp-4], ax
                        mov si, di
                        add si, 2

                        moveGroundL2:

                                    lodsw
                                    stosw

                                    loop moveGroundL2

                        mov ax, [bp-4]
                        stosw

                        add word [bp-2], 320

                        pop cx
                        loop moveGroundL1

            pop ds
            pop es
            popA
            add sp, 4
            pop bp

        ret

updateBirdFlyFlag:
                    push ax
                    
                    mov ax, [cs:BirdYPostion]
                    cmp ax, 0
                    jg checkIfUp

                    add word [cs:BirdYPostion], 3
                    

                    checkIfUp:
                    
                    mov bx, [cs:birdSize]
                    shl bx, 1
                    dec bx

                    add ax, bx
                   ; add ax, 3

                    cmp ax, 178
                    jl movingDown

                    sub word [cs:BirdYPostion], 1

                    movingDown:
                    
                    pop ax

                ret

moveBird:
            call updateBirdFlyFlag

            cmp word [cs:BirdFlyFlag], 1
            jne checkIfZero
            sub word [cs:BirdYPostion], 3

            jmp moveBirdE

            checkIfZero:
			
			cmp word [UpKeyReleased], 1
			je moveBirdE
			
            add word [cs:BirdYPostion], 2

            moveBirdE:
        ret

printLine:
            mov cx, 180
            mov di,  135
            mov ax, 0
            
            printLineL1:
                        stosw
                        sub di, 2
                        add di, 320
                        loop printLineL1

            mov cx, 320
            mov ax, 0
            mov di, 33280

            rep stosw

            ret

copyfromBuffer:

                pushA
                push es
                push ds

                push 0xA000
                pop es
                push word [cs:bufferAddress]
                pop ds

                xor di, di
                xor si, si

                mov cx, 32000

                rep movsw

                

                pop ds
                pop es
				popA
				
            ret

displayYesMsg:
                pushA
                ; push es
		        ; push ds
                
                mov ah, 0x13
		        mov al, 5
		        mov bh, 0
		        ;mov bl,01001011b
		        ;mov bl,0x1E
		        mov bl,0x43
                mov cx,11
		        mov dh,9
		        mov dl,15
		        push cs
		        pop es
		        mov bp,yesMsg
		        INT 0x10

		        ; pop ds
		        ; pop es
		        popA
		ret

displayNoMsg:
                pushA
                ; push es
		        ; push ds
                mov ah,0x13
		        mov al,5
		        mov bh,0x54
		        ;mov bl,01001011b
		        ;mov bl,0x1E
		        mov bl,0x43
                mov cx,13
	    	    mov dh,11
		        mov dl,14
        		push cs
        		pop es
        		mov bp,noMsg
        		INT 0x10
        		; pop ds
        		; pop es
		        popA
		    ret

displayExitMsg:
                    pushA

                    mov ah,0x13
            		mov al,5
            		mov bh,0
            		;mov bl,01001011b
            		;mov bl,0x1E
            		mov bl,0x1E
                    mov cx,16
            		mov dh,7
            		mov dl,12
            		push cs
            		pop es
            		mov bp,exitMessage
            		INT 0x10

            		popA
	        	ret

displayRectangle:

                    pushA

            		mov ah, 0x0C
            		;mov al,0x43
            		mov al, 11000011b
            		mov bh, 0
            		mov cx, 90
            		mov dx, 40
            		mov di, 140
		            mov si, 80
            		add di, 90
            		add si, 40
            		add di, 1
            		add si, 1
		
                    Drawtop:
                            int 10h
                            inc dx
                            cmp dx,si
                            jne Drawtop
                            mov dx,40

                    Drawright:
                                int 10h
                                inc cx
                                cmp cx,di
                                jne Drawright

                                mov dx,40
                                add dx,80
                                mov cx,90
                                add cx,140
                                mov si,40
                                mov di,90
                                sub si,1
                                sub di,1


                    Drawbottom:
                                int 10h
                                dec dx
                                cmp dx,si
                                jne Drawbottom

                                mov dx,40
                                add dx,80


                                Drawup:
                                int 10h
                                dec cx
                                cmp cx,di
                                jne Drawup

                    popA
                ret

setToDefaultISR:
					push bp
					mov bp, sp
					
					pushA
					push es
					
					push 0x0000
					pop es
					
					mov bx, [bp+6]
					shl bx, 2
					
					mov si, [bp+4]
					
					cli
					mov ax, [si]
					mov [es:bx], ax
					mov ax, [si+2]
					mov [es:bx+2], ax
					sti
					
					pop es
					popA
					pop bp
				
				ret 4
					
					
kbISR:
        pushA
        push es

        push 0x0000
        pop es

       ; mov word [BirdFlyFlag], 0

        in al, 0x60

        cmp al, 0xC8
        jne checkIfUpKey
		
		mov word [cs:UpKeyReleased], 1
		mov word [cs:BirdFlyFlag], 0

        jmp controlToOldISR

        checkIfUpKey:
        cmp al, 0x48
        jne checkIfESC

        mov word [cs:BirdFlyFlag], 1
		mov word [cs:UpKeyReleased], 0
        jmp controlToOldISR

        checkIfESC:
		
        cmp al, 0x81        ; ESC scan code for release
        jne controlToOldISR

        mov byte [cs:escapeFlag], 1
		
        call displayRectangle
		call displayExitMsg
		call displayYesMsg
		call displayNoMsg
		
		mov al, 0x20
        out 0x20, al
		
		pop es
		popA
		
		call checkEscapeResponse
		
		iret

        jmp kbISRE

        controlToOldISR:
        pop es
        popA
        jmp far [cs:oldKbISR]

        kbISRE:
        mov al, 0x20
        out 0x20, al

        pop es
        popA

    iret

checkEscapeResponse:
		
		push bp
		mov bp, sp
		
        push ax
		
		againEnterKey:
		sti
		
		xor ah, ah
		int 0x16
		
		
        ; mov ah, 1
        ; int 0x16        ; Check if key available
        ; jz noKey
        
        ; mov ah, 0
        ; int 0x16        ; Get key
        
        cmp al, 'Y'
        je exitGame
		
        cmp al, 'y'
        je exitGame
        
        cmp al, 'N'
        je continueGame
        cmp al, 'n'
        je continueGame
		
		jmp againEnterKey
        
        jmp checkEscapeDone
        
        exitGame:
		
        mov word [bp+4], gameOver
		push word [cs:correctDSvalue]
		pop ds
		jmp checkEscapeDone
        
        continueGame:
        mov byte [cs:escapeFlag], 0
        
        noKey:
        checkEscapeDone:
        pop ax
		pop bp
		
       ret

setDefaultKbISR:
                push ax
                push es

                push 0x0000
                pop es

				cli
                mov ax, [oldKbISR]
                mov [es:9*4], ax
                mov ax, [oldKbISR+2]
                mov [es:9*4+2], ax
				sti
				
                pop es
                pop ax
            ret


; ;moveColumns:
                ; push bp
                ; mov bp, sp
                ; sub sp, 4

                ; pushA
                ; push es
                ; push ds

                ; mov ax, [bufferAddress]
                ; mov es, ax
                ; mov ds, ax

                ; xor di, di
                ; xor si, si

                ; mov word [bp-2], 0

                ; mov cx, [backGroundYPosition]
                ; cld

                ; moveColumnsL1:
                                ; mov di, [bp-2]
                                ; lodsw
                                ; mov [bp-4], ax
                                ; mov si, di
                                ; inc si

                                ; push cx
                                ; mov cx, 159

                                ; moveColumnsL2:
												; movsw
												; movsw
                                                ; loop moveColumnsL2
                                ; pop cx
                                ; mov ax, [bp-4]
                                ; stosw
                                ; add word [bp-2], 320
                                ; loop moveColumnsL1
                ; pop ds
                ; pop es
                ; popA
                ; add sp, 4
                ; pop bp

            ; ret


moveFromBufferToMainScreen:
                            push bp
                            mov bp, sp

                            pushA
                            push es
                            push ds

                            xor di, di
                            xor si, si

                            mov ax, [bp+6]
                            mov ds, ax

                            mov ax, [bp+4]
                            mov es, ax

                            mov cx, 28800

                            rep movsw

                            pop ds
                            pop es
                            popA
                            pop bp

                        ret 4


shiftFromBuffer3ToBuffer2:
                            push bp
                            mov bp, sp
                            sub sp, 4

                            pushA
                            push es
                            push ds

                            mov word [bp-2], 0
                            mov cx, 180
                            cld
                            shiftFromBuffer3ToBuffer2L1:
                                                        push word [cs:buffer3]
                                                        pop es
                                                        push word [cs:buffer3]
                                                        pop ds

                                                        mov di, [bp-2]
                                                        xor ax, ax
                                                        mov ax, [es:di] ; storing the current byte at [es:di]
                                                        mov [bp-4], ax   ;storing in local variable for later use
                                                        mov si, di
                                                        add si, 2

                                                        push cx

                                                        mov cx, 53
                                                        shitingBuffer3:
                                                                        movsw
                                                                        movsw
                                                                        movsw
                                                                        loop shitingBuffer3
                                                        
                                                        mov ax, 0
                                                        stosw
                                                        
                                                        push word [cs:buffer2]
                                                        pop es
                                                        push word [cs:buffer2]
                                                        pop ds
                                                        mov di, [bp-2]
                                                        mov si, di
                                                        add si, 2

                                                        mov cx, 53
                                                        shitingBuffer2:
                                                                        movsw
                                                                        movsw
                                                                        movsw
                                                                        loop shitingBuffer2

                                                        mov ax, [bp-4]
                                                        stosw
                                                        add word [bp-2], 320

                                                        pop cx
                                                        loop shiftFromBuffer3ToBuffer2L1
                            pop ds
                            pop es
                            popA
                            add sp, 4
                            pop bp

                        ret

checkBirdColumnOverlap:
						push bp
						mov bp, sp
						sub sp, 2
						
						pushA
						push es
						
						push word [bufferAddress]
						pop es
						
						mov ax, 320
						mov bx, [BirdYPostion]
						mul bx
						add ax, [BirdXPostion]
						
						mov [bp-2], ax
						
						mov cx, 11
						checkBirdColumnOverlapL1:
													mov di, [bp-2]
													mov ax, [bp+4]
													
													push cx
													mov cx, 14
													
													checkBirdColumnOverlapL2:	
																				cmp al, [es:di]
																				jne noOverlap
																				
																				mov byte [collisionFlag], 1
																				pop cx
																				jmp checkBirdColumnOverlapE
																				
																				noOverlap:
																				inc di
																				
																				loop checkBirdColumnOverlapL2
													pop cx
													add word [bp-2], 320
													
													loop checkBirdColumnOverlapL1
						
						checkBirdColumnOverlapE:
						
						pop es
						popA
						add sp, 2
						pop bp
													
				ret 2

checkBeekCollision:
					
					push bp
					mov bp, sp
					sub sp, 4 ;creating a local variables
					;[bp-2] stores the initial di
					;[bp-4] acts as a flag
					;[bp+4] is the bird size
					;[bp+6] is the column where bird will be
					;[bp+8] is the row where bird will be
			
					pushA

					mov ax, 320
					mov bx, [bp+8]
					mul bx
					add ax, [bp+6]

					mov [bp-2], ax ; storing initial value of di 

					mov ax, [bp+4]
					shl ax, 1

					; test ax,0x0001 ; check if the least significant bit is 1 or 0. if 1 the ax is odd otherwise zero
					; if zero flag sets then ax is even

					dec ax

            		mov cx, ax

            		push word [bufferAddress]
            		pop es
            
            		mov word [bp-4], 1
            		mov dx, 1
					
            		checkBeekCollisionL1:
                            				cmp cx, 0
                            				jz checkBeekCollisionL1E

                            				mov di, [bp-2]
											mov ax, [bp+10]
                            				mov bx, 1
                            				checkBeekCollisionL2:
                                            						cmp bx, dx
                                            						ja checkBeekCollisionL2E

                                            
                                            						cmp byte al, [es:di]
																	jne noOverlap2
											
																	mov byte [collisionFlag], 1
																	jmp checkBeekCollisionE
											
																	noOverlap2:

                                            						inc bx
                                            						inc di

                                            						jmp checkBeekCollisionL2
                                        							checkBeekCollisionL2E:
                                            
                            				cmp word [bp-4], 1
                            				jnz decDX2

                            				inc dx
                            				cmp dx, [bp+4]
                            				jle sameFlag2
                            
                            				mov word [bp-4], 0
                            				sub dx, 2

                            				sameFlag2:              
                            				dec cx
                            				add word  [bp-2], 320
                            				jmp checkBeekCollisionL1

                            				decDX2:
                            				dec dx
                            				dec cx
                            				add word  [bp-2], 320
                            				jmp checkBeekCollisionL1

                        					checkBeekCollisionL1E:
						
					checkBeekCollisionE:
					popA
					add sp, 4
					pop bp

				ret 8

checkBeek:
			push bp
			mov bp, sp
			
			pushA
			
			mov ax, [BirdYPostion]
            add ax, 2

            mov bx, [BirdXPostion]
            add bx, [birdSize] ; adding the width of tail
            add bx, [birdSize]  ;adding the width of main body
            add bx, 3 ; remember! I made the main body 3 pixels wider

            mov cx, [birdSize]
            shr cx, 1
			
			push word [bp+4]
			push ax
			push bx
			push cx
			call checkBeekCollision
			
			popA
			pop bp
			
		ret 2
			
			

checkCollision:
				pushA
				
				
				mov ax, 180
				mov bx, [birdSize]
				shl bx, 1
				dec bx
				
				sub ax, bx
				cmp word [BirdYPostion], ax
				jne checkRoofCollision
				
				mov byte [collisionFlag], 1
				jmp checkCollisionE
				
				checkRoofCollision:
				
				cmp word [BirdYPostion], 0
				jne checkColumnCollision
				
				mov byte [collisionFlag], 1
				jmp checkCollisionE
				
				checkColumnCollision:
				
				
				mov cx, 5
				mov ax, 44
				
				checkCollisionL1:
									push ax
									call checkBirdColumnOverlap
									
									push ax
									call checkBeek
									
									cmp byte [collisionFlag], 1
									je checkCollisionE
									
									inc ax
									
									loop checkCollisionL1
									
				checkCollisionE:
				popA
				
			ret
			
calculateScore:
				push es
				push di
				
				mov di, [BirdXPostion]
				
				cmp byte [es:di], 47
				jne noIncInScore
				
				inc word [score]
				
				noIncInScore:
				
				pop di
				pop es
			
			ret
			
			
blinkBirdAfterCollision:
						push bp
						mov bp, sp
						sub sp, 2
						
						pushA
						
						mov word [bp-2], 0
						mov cx, 10
						blinkBirdAfterCollisionL1:
													push word [buffer2]
													push word [bufferAddress]
													call moveFromBufferToMainScreen
													
													
													cmp word [bp-2], 0
													je noBird
													
													call setBirdOnScreen
													
													noBird:
													
													call copyfromBuffer
													call delay
													
													not word [bp-2]
													loop blinkBirdAfterCollisionL1
													
						call setBirdOnScreen
						
						popA
						add sp, 2
						pop bp
						
					ret
			
			
moveBirdToGround:
					call blinkBirdAfterCollision
					
					moveBirdToGroundL1:
										
										cmp word [BirdYPostion], 170
										je moveBirdToGroundL1E
					
										push word [buffer2]
										push word [bufferAddress]
										call moveFromBufferToMainScreen
		
										call checkCollision
		

										push word [BirdYPostion]
										push word [BirdXPostion]
										push word [birdSize]
										call setBird
		
										call copyfromBuffer
										call moveBird
					
										jmp moveBirdToGroundL1
										moveBirdToGroundL1E:
					
					call Delay
					
				ret
				

startScreen:
				push ds
				pop word [correctDSvalue]
				
				mov ax, 0x0003
				int 0x10
				; Display start menu
				;call set_background
				call displayStartMenu
				call handleStartMenu
    
				; Check menu choice
				cmp byte [menuChoice], 1
				je startGame
				cmp byte [menuChoice], 2
				je showInformation
				cmp byte [menuChoice], 3
				je showdev
				cmp byte [menuChoice], 4
				je exitFromMenu
    
	
				showInformation:
				call showInstructions
				jmp newGame
				
				showdev:
				call showdevs
				jmp newGame
        
				exitFromMenu:
				
				push word 8
				push word oldTimerISR
				call setToDefaultISR
				
				in al, 61h          ; Read current value from port 61h
				and al, 0xFC   ; Reset bits 1 and 0
				out 61h, al         ; Send updated value to port 61h
				
				push word 8
				push word oldTimerISR
				call setToDefaultISR
					
				mov ax, 0x0003    ; Return to text mode
				int 0x10
				mov ax, 0x4c00    ; Exit program
				int 0x21
		
				startGame:
				
				mov ax, 0x0013
				int 0x10
			
		
				call displayStartMsg

		 ret
		 
initializeBuffersForColumnMotion:
										push word 0x004B
										push word [buffer2]
										call clrSCR

										push word [buffer2]
										push word 300
										call makeColumns

										push word [buffer2]
										push word 200
										call makeColumns


										push word 0x004B
										push word [buffer3]
										call clrSCR


										push word [buffer3]
										push word 300
										call makeColumns

										push word [buffer3]
										push word 200
										call makeColumns

										push word [buffer3]
										push word 80
										call makeColumns
									
									
								ret

saveAndSetKbISR:
						
						push ax
						push es
						
						xor ax, ax
						mov es, ax

						mov ax, [es:9*4]
						mov [oldKbISR], ax
						mov ax, [es:9*4+2]
						mov [oldKbISR+2], ax
	

						cli
						mov word [es:9*4], kbISR
						mov [es:9*4+2], cs
	
						sti
						
						pop es
						pop ax
						
					ret
							
makeNewColumnsInBuffer:
						cmp word [counter], 0
						jg makeNewColumnsInBufferE

						mov word [counter], 160

						push word 0x004B
						push word [buffer3]
						call clrSCR


						push word [buffer3]
						push word 200
						call makeColumns

						push word [buffer3]
						push word 300
						call makeColumns

       
		
						push word [buffer3]
						push word 100
						call makeColumns

						makeNewColumnsInBufferE:
						
					ret


setBirdOnScreen:
				
				push word [BirdYPostion]
				push word [BirdXPostion]
				push word [birdSize]
				call setBird
			ret
			
clear_keystream:
				mov ah, 01h          ; Check if a key is in the buffer
				int 16h
				jz done              ; Exit if no keys are in the buffer
				mov ah, 00h          ; Read and discard the key
				int 16h
				jmp clear_keystream  ; Repeat until the buffer is empty
				
				done:
				
			ret
			

play_note:
			; Prepare the speaker for the note
			mov al, 182         ; Prepare the speaker
   			out 43h, al         ; Send control byte to port 43h

   			; Send the frequency value (divisor) to port 42h
   			out 42h, al         ; Output low byte
   			mov al, ah          ; Output high byte
   			out 42h, al         ; Output high byte

   			; Turn the speaker on (set bits 1 and 0 of port 61h)
   			in al, 61h          ; Read current value from port 61h
   			or al, 00000011b    ; Set bits 1 and 0 (turn on speaker)
   			out 61h, al         ; Send updated value to port 61h

   			call delay          ; Wait for duration of the note

   			; Turn the speaker off (reset bits 1 and 0 of port 61h)
   			in al, 61h          ; Read current value from port 61h
   			and al, 0xFC   ; Reset bits 1 and 0
   			out 61h, al         ; Send updated value to port 61h
		
		ret

playNoteMainLoop:
					; Ice cream truck jingle with calming notes and smooth rhythm

    				; G4 (392.00 Hz)
    				mov ax, 3043        ; G4
   					call play_note
   					call delay          ; Longer pause

   					; G4 (392.00 Hz)
   					mov ax, 3043        ; G4
   					call play_note
   					call delay

   					; E4 (329.63 Hz) - Calming, smooth note
   					mov ax, 3619        ; E4
   					call play_note
   					call delay

   					; C4 (261.63 Hz) - Lower tone for relaxation
   					mov ax, 4560        ; C4
   					call play_note
   					call delay

   					; G4 (392.00 Hz) - Returning note for continuity
   					mov ax, 3043        ; G4
   					call play_note
   					call delay

   					; G4 (392.00 Hz)
   					mov ax, 3043        ; G4
   					call play_note
   					call delay

   					; C5 (523.25 Hz) - A higher but smooth note
   					mov ax, 2280        ; C5
   					call play_note
   					call delay

   					; E4 (329.63 Hz) - Soft ending before repeating
   					mov ax, 3619        ; E4
   					call play_note
   					call delay

   					; C4 (261.63 Hz) - Lower tone for calm closure
   					mov ax, 4560        ; C4
   					call play_note
   					call delay

   					; Longer pause before repeating or ending
   					;call delay

   					; Repeat simple melody to maintain calmness
   					; G4 (392.00 Hz)
   					mov ax, 3043        ; G4
   					call play_note
   					call delay

   					; G4 (392.00 Hz)
   					mov ax, 3043        ; G4
   					call play_note
   					call delay

   					; E4 (329.63 Hz)
   					mov ax, 3619        ; E4
   					call play_note
   					call delay

   					; C4 (261.63 Hz)
   					mov ax, 4560        ; C4
   					call play_note
   					call delay

   					; G4 (392.00 Hz) - Soft transition note
   					mov ax, 3043        ; G4
   					call play_note
   					call delay

   					; C5 (523.25 Hz) - Higher smooth note
   					mov ax, 2280        ; C5
   					call play_note
   					call delay

   					; End of melody
   					;call delay
	
					jmp playNoteMainLoop
				
				ret

			
; subroutine to register a new thread
; takes the segment, offset, of the thread routine
; for the target thread subroutine
initpcb: 	
			push bp
			mov bp, sp
			push ax
			push bx
			push cx
			push si
			
			mov bx, [nextpcb] ; read next available pcb index
			cmp bx, 3 ; are all PCBs used
			je exit ; yes, exit
			
			;mov cl, 5
			shl bx, 5 ; multiply by 32 for pcb start ix2^5 
			
			mov ax, [bp+6] ; read segment parameter
			mov [pcb+bx+18], ax ; save in pcb space for cs
			mov ax, [bp+4] ; read offset parameter
			mov [pcb+bx+16], ax ; save in pcb space for ip
			mov [pcb+bx+22], ds ; set stack to our segment
			
			mov si, [nextpcb] ; read this pcb index
			mov cl, 10
			shl si, cl ; multiply by 1024...ix2^10 (1024)
			add si, 512*2+stack ; end of stack for this thread
			
			
			sub si, 2 ; space for return address
			mov [pcb+bx+14], si ; save si in pcb space for sp
			
			mov word [pcb+bx+26], 0x0200 ; initialize thread flags
			mov ax, [pcb+28] ; read next of 0th thread in ax
			mov [pcb+bx+28], ax ; set as next of new thread
			
			mov ax, [nextpcb] ; read new thread index
			mov [pcb+28], ax ; set as next of 0th thread
			
			inc word [nextpcb] ; this pcb is now used
			
			exit: pop si
			pop cx
			pop bx
			pop ax
			pop bp
			
		ret 4
		

TimerISR:
			
			cmp word [cs:UpKeyReleased], 1
			jne controlToContextSwitch
			
			add word [cs:tickCountFlyFlag], 1
			
			cmp word [cs:tickCountFlyFlag], 100
			jne controlToContextSwitch
			
			mov word [cs:tickCountFlyFlag], 0
			mov word [cs:BirdFlyFlag], 0
			mov word [cs:UpKeyReleased], 0
			
			controlToContextSwitch:

			
			push ds
			push bx
			
			push cs
			pop ds ; initialize ds to data segment
			
			mov bx, [current] ; read index of current in bx

			shl bx, 5 ; multiply by 32 for pcb start
			
			mov [pcb+bx+0], ax ; save ax in current pcb
			mov [pcb+bx+4], cx ; save cx in current pcb
			mov [pcb+bx+6], dx ; save dx in current pcb
			mov [pcb+bx+8], si ; save si in current pcb
			mov [pcb+bx+10], di ; save di in current pcb
			mov [pcb+bx+12], bp ; save bp in current pcb
			mov [pcb+bx+24], es ; save es in current pcb
			pop ax ; read original bx from stack
			mov [pcb+bx+2], ax ; save bx in current pcb
			pop ax ; read original ds from stack
			mov [pcb+bx+20], ax ; save ds in current pcb
			pop ax ; read original ip from stack
			mov [pcb+bx+16], ax ; save ip in current pcb
			pop ax ; read original cs from stack
			mov [pcb+bx+18], ax ; save cs in current pcb
			pop ax ; read original flags from stack
			mov [pcb+bx+26], ax ; save cs in current pcb
			mov [pcb+bx+22], ss ; save ss in current pcb
			mov [pcb+bx+14], sp ; save sp in current pcb
			
			mov bx, [pcb+bx+28] ; read next pcb of this pcb
			mov [current], bx ; update current to new pcb
			mov cl, 5
			shl bx, cl ; multiply by 32 for pcb start
			
			mov cx, [pcb+bx+4] ; read cx of new process
			mov dx, [pcb+bx+6] ; read dx of new process
			mov si, [pcb+bx+8] ; read si of new process
			mov di, [pcb+bx+10] ; read diof new process
			mov bp, [pcb+bx+12] ; read bp of new process
			mov es, [pcb+bx+24] ; read es of new process
			mov ss, [pcb+bx+22] ; read ss of new process
			mov sp, [pcb+bx+14] ; read sp of new process
			push word [pcb+bx+26] ; push flags of new process
			push word [pcb+bx+18] ; push cs of new process
			push word [pcb+bx+16] ; push ip of new process
			push word [pcb+bx+20] ; push ds of new process
			
			mov al, 0x20
			out 0x20, al ; send EOI to PIC
			
			mov ax, [pcb+bx+0] ; read ax of new process
			mov bx, [pcb+bx+2] ; read bx of new process
			pop ds ; read ds of new process
			
			jmp far [cs:oldTimerISR]
			
		iret ; return to new process
			
			
										 
start:
    ; Set video mode
	
mov ax, 500       ; Set a smaller divisor (e.g., 500 for faster ticks)
out 0x40, al        ; Send the low byte of the divisor to port 0x40
mov al, ah          ; Move the high byte of the divisor to AL
out 0x40, al        ; Send the high byte to port 0x40

	
	push 0x0000
	pop es
	
	mov ax, [es:8*4]
	mov [oldTimerISR], ax
	mov ax, [es:8*4+2]
	mov [oldTimerISR+2], ax
	
	cli
	mov word [es:8*4], TimerISR
	mov [es:8*4+2], cs
	sti
	
	push cs
	mov bx, playNoteMainLoop
	push bx
	call initpcb
	
	newGame:
	
	call reInitializeVariables
	
	push ds
	pop word [correctDSvalue] ;saving for later use
		
	call startScreen
	call saveAndSetKbISR
	call initializeBuffersForColumnMotion


	push word [buffer2]
	push word 0xA000
	call moveFromBufferToMainScreen

	call setGround


	gameLoop:
	
				;mov word [delayFlag], 1
				
				cli
				call makeNewColumnsInBuffer
				call shiftFromBuffer3ToBuffer2

				push word [buffer2]
				push word [bufferAddress]
				call moveFromBufferToMainScreen
				
				
				call checkCollision
				call setBirdOnScreen
				call copyfromBuffer
				sti
				
				;mov word [delayFlag], 0
		
				cmp byte [collisionFlag], 1
				jne noCollision
		
					push word 9
					push word oldKbISR
					call setToDefaultISR
		
					mov word [BirdFlyFlag], 0
		
					call moveBirdToGround
					jmp gameOver
		
				noCollision:
		
				call calculateScore

				dec word [counter]

				cmp word [flag], 1
				jne notFirstTime

				xor ah, ah
				int 0x16

				mov word [flag], 0
				
				
				
				notFirstTime:

				call moveGround
				call moveBird
		
				jmp gameLoop
gameOver:
   ; Return to text mode
    mov ax, 0x0003    
    int 0x10
	
	
    ; Set background color to green
    mov ah, 0Bh
    mov bh, 0
    mov bl, 0x02        ; Green background
    int 10h
    
    ; Display Border Top
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 48         ; Border width
    mov dh, 3           ; Row position
    mov dl, 13          ; Column position
    push cs
    pop es
    mov bp, borderHorizontal1
    int 0x10
    
    ; Display Border Sides (10 rows)
    mov cx, 1
    mov dh, 4
    borderLoop2:
        push cx
        mov ah, 0x13
        mov al, 1
        mov bh, 0
        mov bl, 0x0E    ; Yellow color
        mov cx, 48     ; Border width
        mov dl, 13      ; Column position
        push cs
        pop es
        mov bp, borderVertical1
        int 0x10
        
        inc dh
        pop cx
        inc cx
        cmp cx, 15
        jle borderLoop2
    
    ; Display Border Bottom
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 48          ; Border width
    mov dh, 19
    mov dl, 13          ; Column position
    push cs
    pop es
    mov bp, borderHorizontal
    int 0x10
    
    ; Game Over Message
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0C        ; Red color
    mov cx, 9           ; Length of "GAME OVER"
    mov dh, 7           ; Row
    mov dl, 32          ; Column (centered)
    push cs
    pop es
    mov bp, gameOverMsg
    int 0x10
    
    ; Score Message
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0B        ; Cyan color
    mov cx, 11          ; Length of "YOUR SCORE:"
    mov dh, 10          ; Row
    mov dl, 29          ; Column (centered)
    push cs
    pop es
    mov bp, scoreMsg
    int 0x10
    
    ; Print Score
    push word 10        ; Column
    push word 44        ; Row
    push word [score]   ; Score value
    call printNumInTextMode
    
    ; Restart/Exit Message
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0E        ; Yellow color
    mov cx, 31          ; Length of restart message
    mov dh, 15          ; Row
    mov dl, 21          ; Column
    push cs
    pop es
    mov bp, restartMsg
    int 0x10
    
	
	push word 9
	push word oldKbISR
	call setToDefaultISR
	
	; push word 8
	; push word oldTimerISR
	; call setToDefaultISR
	

	
	;call Delay
	
	call clear_keystream
	
	
	xor ah, ah         ; Wait for key press
	int 0x16
	
	call delay
    jmp newGame

	
	
mov ax, 0x4c00
int 0x21