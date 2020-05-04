;POWERUPS ARE:
;Red hurts you (lose one heart)
;Green gives you one point (need five to win)
;Blue makes the enemy invisible
;Yellow makes the enemy confused (pressing right makes them go left, pressing left makes them go right)

;LEVEL TWO POWERUPS:
;Star makes you win the game.
;Skull makes you lose the game.
;These two are rarer than others!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SET CURSOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetCursor macro x,y
	mov ah,2 ;set cursor position
	mov dl,x
	mov dh,y ;mov dx,0A0Ah or dl=X dh=Y
	mov bx,0
	int 10h
endm SetCursor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINT MESSAGE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrintMessage macro MessageToPrint, MessageColor
local printmessage1,printmessage2

mov SI,0
printmessage1:

mov ah,9
mov bh,0
mov al,MessageToPrint[SI]

cmp MessageToPrint[SI],'$'
jz printmessage2

mov cx,1
mov bl,MessageColor ;00Ah is green
int 10h
pop cx
;pop dx

mov ah,2
inc dl
int 10h

inc SI
jmp printmessage1

printmessage2:

endm PrintMessage


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INPUT NAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


InputName macro NameToPutIn,NameSize
local check_read_loop, read_loop, continue_read_loop, read_done, cont

mov SI,0
mov cx,0

read_loop:
mov ah,1
int 21h
cmp cx,0
jz check_read_loop
cmp al,13
jz read_done
jmp continue_read_loop

check_read_loop:

cmp al,65 ;ascii for A
jb read_loop ;jump if below 65
cmp al,122 ;ascii for z
ja read_loop ;jump if above

cmp al,90 ;91 is special, 90 is not 
ja cont
jmp continue_read_loop

cont:
cmp al,97
jb read_loop

continue_read_loop:

mov NameToPutIn[SI],al
inc NameSize


inc SI
inc cx
cmp cx,15
jnz read_loop

read_done:
inc NameSize

endm InputName


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW CAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawCar Macro x
local loop1, loop2, color1, color2

	mov cx,x
	mov dx,CarRow

	lea di, CarToDraw

	;mov cx,30
	;mov dx,50
	;mov al,03h ;pixel color          =2
	mov ah,0ch ;draw pixel command
	
	add cx,30
	mov extra,cx
	sub cx,30
	
	add dx,40
	mov extra2,dx
	sub dx,40
	

loop2:
push cx
	loop1:
	mov bl,[di]
	cmp bl,1
	jz color1
	mov al,02h ;green
	jmp color2
	color1:
	mov al,00h ;black
	color2:
	int 10h
	inc cx
	inc di
	cmp cx,extra
	jnz loop1
	inc dx    
    pop cx
    cmp dx,extra2 ;row
	jnz loop2


endm DrawCar


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW BLANK CAR/ ERASE CAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



drawBlankCar macro x
local vertproc, horizproc
    ;mov cx,col ;column            =5 
    ;mov dx,row ;row           =160
	mov al,0 ;pixel color
	mov ah,0ch ;draw pixel command 
	
	mov cx,x
	mov dx,CarRow
	 
	mov extra,dx 
	add extra,40  
	
	mov extra2, cx
	
	mov bx,cx
	add bx,30 
	                        
	                
   vertproc:          
    	horizproc: 
    	int 10h 
    	inc cx ;column 
    	cmp cx,bx ;column
    	jne horizproc
    	inc dx    
    	mov cx,extra2 ;45   
    	cmp dx,extra ;row
    	jnz vertproc    

    
    	

endm DrawBlankCar


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DATA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



    .MODEL SMALL
	.STACK 64
	.DATA
	
	 VALUE db ?
     Exit db ?
     Cur_R_R db ?
     Cur_T_R db ?
     Cur_R_C db ?
     Cur_T_C db ?
    
    CarOnePosition dw 5
	CarTwoPosition dw 165
	CarRow dw 130
		
    extra dw 0      
    extra2 dw 0 

			  P_One_NAME db 'Please enter your name: ','$'
			  
			  Menu1 db 'To start chatting press F1','$'
			  Menu2 db 'To start playing press F2','$'
			  Menu3 db 'To end the program press ESC','$'
			  
			  VictoryMessage1 db ' has won the game!','$' 
			  VictoryMessage2 db 'Congratulations!','$' 
			  VictoryMessage3 db 'Press any key to exit...','$' 
			  
			  SendPlay db 'You sent a request to play. ^^','$' 
			  ReceivePlay db 'You received a request to play! Press Y to accept.','$'
			  
			  SendChatMes db 'You sent a request to chat ^^','$' 
			  ReceiveChatMes db 'You received a request to chat!','$'
			  
			  LevelSelect1 db 'Press 1 for level 1','$'
			  LevelSelect2 db 'Or','$'
			  LevelSelect3 db 'Press 2 for level 2','$'
              
			  NameOne db 16 DUP('$')
              NameTwo db 16 DUP('$')
			  NameOneSize db 0
			  
			  SCORE DB 0,0
			  HEARTS DB 3,3
			  
			  LevelTwo DB 0
				
			  InvisiblePeriod db 0,0
			  
			  ReversePeriod db 0,0
			  
			  GameReadyReceive db 0
			  GameReadySend db 0
			  
			  ChatReady db 0
			  ChatReadySend db 0
	
	CirclesX DW 5,5,5
	
	CirclesY DW 5,5,5
	
	CirclesColor DW ?,?,?
	
	ItemToSend dw ?
	
	CirclesCount dw 0
	


CarToDraw db 1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1
db 1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1
db 1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1
db 1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1
db 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
db 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1
db 1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1
db 1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1
db 1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1
db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
db 1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1
db 1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1
db 1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
db 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
db 1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1
db 1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1
db 1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1

Circle db 1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1
db 1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1
db 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
db 1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1
db 1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1


Star db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0
db 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
db 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
db 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
db 0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
db 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0
db 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0
db 0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0
db 0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0,0,0
db 0,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0
db 0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0
db 0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

Skull db 1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1
db 1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1
db 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0
db 0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0
db 1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1
db 1,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,1,0,0,1
db 1,0,0,1,1,1,1,0,0,1,1,0,0,1,1,1,1,0,0,1
db 1,0,0,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,1
db 1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1
db 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1
db 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1
db 1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1
db 1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1


.CODE
	main proc far
	
	mov ax,@data
	mov ds,ax 
	
	call UART
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW INPUT NAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
	
call ClearScreen ;Clear screen to get rid of old text on screen

SetCursor 5,5 ;Set cursor to specific position
PrintMessage P_One_NAME,00ah ;Draw message character by character starting from cursor position

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GET INPUT NAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

SetCursor 29,5
InputName NameOne, NameOneSize ;Put input in player one's name

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WAIT FOR BOTH PLAYERS TO ENTER THEIR NAMES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


mov bx,10 ;sent item
call SendItem
mov ax,0
mov ItemToSend,ax
ReceiveNameCheck:
call ReceiveItem
cmp ItemToSend,10
jz ReceiveNameCheckDone
jmp ReceiveNameCheck
ReceiveNameCheckDone:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SEND AND GET NAMES (SERIAL)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 




COMMENT @ ;COMMENTED;COMMENTED;COMMENTED;COMMENTED;COMMENTED;COMMENTED vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
mov SI,0
mov DI,0
push SI
;push DI
ReceiveName:
mov bx, '$'
cmp NameOne[DI],bx
jz SendNameDone
mov bx,NameOne[DI]
inc DI
call SendItem
SendNameDone:

mov bx,0
mov ItemToSend,bx
call ReceiveItem
mov bx, ItemToSend
pop SI
mov NameTwo[SI], bx
inc SI
push SI
cmp SI,16
jnz ReceiveName

mov bl,'$'
mov NameTwo[SI],bl

pop SI

@ ;COMMENTED;COMMENTED;COMMENTED;COMMENTED;COMMENTED;COMMENTED ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW MAIN MENU
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

MainMenu:

call ClearScreen ;Clear screen to erase new text and write new text

SetCursor 5,5
PrintMessage Menu1, 00bh ;Print menu message 1

SetCursor 5,10
PrintMessage Menu2, 00bh ;Print menu message 2

SetCursor 5,15
PrintMessage Menu3, 00bh ;print menu message 3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GET MAIN MENU INPUTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

mainmenuloop: ;Gets input in main menu

call ReceiveItem
cmp GameReadyReceive,1
;jz notMAINMENUCHECK
;jmp MAINMENUCHECK
;notMAINMENUCHECK:
JNZ MAINMENUCHECK
SetCursor 5,22
PrintMessage ReceivePlay,04h

call AddDelay

getresponsegame:
mov ah, 1
int 16h ;get key with waiting, put in ah
cmp al,121 ;y 
jnz NotY
;Y:
mov bx,121
call SendItem ;sent y
jmp levelselect ;also send to main
NotY:



notstartgame:
;call ReceiveItem
;cmp ChatReady,1
;jnz MAINMENUCHECK
;SetCursor 5,7
;PrintMessage ReceiveChat,04h
;cmp ChatReadySend,1
;jnz notstartchat
;jmp startchat

;notstartchat:


    
MAINMENUCHECK:
	mov ah,1
	int 16h
	jnz MainMenuInput
	jmp mainmenuloop
	MainMenuInput:
	

mov ah,0
int 16h

cmp GameReadyReceive,1
jz CantRequestGame

cmp ah, 3ch ;if F2, start game
jz startgameinput

CantRequestGame:

cmp ah, 3bh ;if F1, chat ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHAT PHASE 2
jz startchat


cmp ah, 1b ;if Escape, quit game
jnz mainmenuloopcont
	mov ah,4ch ;two lines to quit game
	int 21h ;two lines to quit game
	
startgameinput:
mov bx, 3ch
call SendItem
mov GameReadySend, 1

SetCursor 5,22
PrintMessage SendPlay,04h
jmp mainmenuloop

;startchatinput:
;mov bx, 3bh
;call SendItem
;mov ChatReadySend, 1

;SetCursor 5,2
;PrintMessage SendChat,04h
;jmp mainmenuloop




mainmenuloopcont:
jmp mainmenuloop ;continue if key pressed =/= esc or f1 or f2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; START CHAT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

startchat: 

mov ah,0
mov al,03
int 10h

mov Cur_T_R,0
mov Cur_T_C,0
mov Cur_R_R,13
mov Cur_R_C,0
call splitscreen
gameloop:
call SendChat
call ReceiveChat
cmp Exit,27
jne gameloop
jmp mainmenu


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL SELECT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


	levelselect:
	
	cmp GameReadyReceive,1
	jz GameReadyReceiveCase
	jmp GameReadySendCase
	GameReadyReceiveCase:
	
	mov ah,0   ;set gfx mode
	mov al,13h
	int 10h  
	
	call DrawAllLines ;draws lanes and screen split line and horizontal line to separate stats above from game below
	call PrintInterface ;draw players names
	call PrintHearts ;Draw three hearts at start of game
	DrawCar CarOnePosition
	DrawCar CarTwoPosition
	
	GameReadyReceiveItem:
	call ReceiveItem
	cmp ItemToSend, 10
	jnz NotStartGame1
	jmp StartGame1
	NotStartGame1:
	cmp ItemToSend, 20
	jnz NotStartGame2
	jmp StartGame2
	NotStartGame2:
	jmp GameReadyReceiveItem
	
	GameReadySendCase:
	call ClearScreen
	
	SetCursor 7,5
	PrintMessage LevelSelect1,03h
	SetCursor 7,8
	PrintMessage LevelSelect2,03h
	SetCursor 7,11
	PrintMessage LevelSelect3,03h
	
	LevelSelectInput:
	
	mov ah,0
	int 16h
	
	cmp ah,02h
	jz Level1
	cmp ah,03h
	jz Level2
	jmp LevelSelectInput
	
	Level1:
	mov LevelTwo, 0
	mov bx,10
	call SendItem
	mov ah,0   ;set gfx mode
	mov al,13h
	int 10h  
	jmp StartGame1
	
	Level2:
	mov LevelTwo, 1
	mov bx,20
	call SendItem
	mov ah,0   ;set gfx mode
	mov al,13h
	int 10h  
	jmp StartGame2
	
	
	
	
	
	
	StartGame2:
	mov LevelTwo,1
	
	
	StartGame1:
	
	;mov ah,0   ;set gfx mode
	;mov al,13h
	;int 10h  
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; START OF GAME, DRAW INTERFACE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
	
	
	
	    
	call DrawAllLines ;draws lanes and screen split line and horizontal line to separate stats above from game below
	call PrintInterface ;draw players names
	call PrintHearts ;Draw three hearts at start of game

    ;Draw car positions at start of game
	DrawCar CarOnePosition
	DrawCar CarTwoPosition
	
		


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ADD CIRCLES (INITIALIZE)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
	
	mov SI,0
	call AddCircle
call AddDelay
	mov SI,2
	call AddCircle
call AddDelay
	mov SI,4
	call AddCircle
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; START OF LOOP (MOVE CIRCLES AND COMPARE WITH CAR)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
	
circledrawfun:

call ReceiveItem
call AddDelay
	
mov SI,0
call MoveCircle
call CompareCircleY

call AddDelay

mov SI,2
call MoveCircle
call CompareCircleY

call AddDelay

mov SI,4
call MoveCircle
call CompareCircleY

	call ClearTop
	;call PrintInterface
	call PrintHearts
	
	jmp CHECK
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CHECK INPUT IN-GAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 	
	
CHECK:
	mov ah,1 ;Get key WITHOUT waiting
	int 16h
	jz circledrawfun
	
	mov ah,00h ;Get key WITH waiting
	int 16h
	
    cmp ah, 020h 
    jz MoveRightJump
    cmp ah, 01Eh   
    jz MoveLeftJump
	
    jmp CHECK ;neither right or left
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MOVE AND DRAW CARS INCLUDING SERIAL POSITIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
	
	MoveRightJump: ;to prevent "jump too far"
	jmp MoveRight
	
	MoveLeftJump:
	jmp MoveLeft
    
	MoveRight:
	cmp ReversePeriod[0],0
	jz MoveRightNormally
	dec ReversePeriod[0]
	jmp MoveLeftNormally
	MoveRightNormally:
	DrawBlankCar CarOnePosition
	call MoveCarOneRight
	
	cmp InvisiblePeriod[0],0
	jz DrawCarNormally1
	
	dec InvisiblePeriod[0]
	jmp CHECK
	
	DrawCarNormally1:
	DrawCar CarOnePosition
	mov bx, 020h
	call SendItem
	jmp CHECK
	
	MoveLeft:
	cmp ReversePeriod[0],0
	jz MoveLeftNormally
	dec ReversePeriod[0]
	jmp MoveRightNormally
	MoveLeftNormally:
	DrawBlankCar CarOnePosition
	call MoveCarOneLeft
	
	cmp InvisiblePeriod[0],0
	jz DrawCarNormally2
	
	dec InvisiblePeriod[0]
	jmp CHECK
	
	DrawCarNormally2:
	DrawCar CarOnePosition
	mov bx, 01Eh
	call SendItem
	jmp CHECK
	
	
    
	      
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

	mov ah,4ch
	int 21h    
	      
main endp  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROCEDURES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AFTER MAIN ENDP AND BEFORE END MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MOVING CIRCLE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

MoveCircle PROC

	mov al,0 ;pixel color
	mov ah,0ch ;draw pixel command 

	mov dx,CirclesY[SI]
	mov cx,CirclesX[SI]
	 
	mov extra,dx 
	add extra,20  
	
	mov extra2, cx
	
	mov bx,cx
	add bx,20                         
	                
   vertproccircle2:          
    	horizproccircle2: 
    	int 10h 
    	inc cx ;column 
    	cmp cx,bx ;column
    	jne horizproccircle2
    	inc dx    
    	mov cx,extra2 ;45   
    	cmp dx,extra ;row
    	jnz vertproccircle2    


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CONDITIONS FOR SPECIAL SHAPES
add CirclesY[SI],14

cmp LevelTwo,1
jnz NotLevelTwo1

cmp CirclesColor[SI],0Fh
jnz NotStarDraw

lea di, Star
jmp DrawJmp

NotStarDraw:

cmp CirclesColor[SI],07h
jnz NotSkullDraw

lea di, Skull
jmp DrawJmp

NotSkullDraw:

NotLevelTwo1:

	lea di, Circle
	
	DrawJmp:

	;mov cx,30
	;mov dx,50
	;mov al,03h ;pixel color          =2
	mov ah,0ch ;draw pixel command
	
	mov ax,CirclesColor[SI]
	
		mov ah,0ch ;draw pixel command

	
	mov dx,CirclesY[SI]
	mov cx,CirclesX[SI]
	
	
	add cx,20
	mov extra,cx
	sub cx,20
push dx	
	add dx,20
	mov extra2,dx
	sub dx,20



loop2circ3:
push cx
	loop1circ3:
	mov bl,[di]
	cmp bl,1
	jz color1circ3
	push bx
	mov bh,ah
	mov ax,CirclesColor[SI]
	mov ah,bh
	pop bx
	jmp color2circ3
	color1circ3:
	mov al,00h
	color2circ3:
	int 10h
	inc cx
	inc di
	cmp cx,extra
	jnz loop1circ3
	inc dx    
    pop cx
    cmp dx,extra2 ;row
	jnz loop2circ3

pop dx	

	ret
MoveCircle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ADDING CIRCLE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

AddCircle PROC

cmp LevelTwo,1
jnz NotLevelTwo2
inc CirclesCount
NotLevelTwo2:

   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

	;mov dx,5
   mov  ax, dx
   xor  dx, dx
   mov  cx, 8  
   div  cx       ; here dx contains the remainder of the division - from 0 to 7
 
   cmp dx,0
   jz col10
   cmp dx,1
   JZ col50
   cmp dx,2 
   JZ col90
   cmp dx,3
   JZ col130
   cmp dx,4
   JZ col170
   cmp dx,5
   JZ col210
   cmp dx,6
   JZ col250
   cmp dx,7
   JZ col290
   
   col10:
   mov ax,10
   mov CirclesX[SI],ax
   jmp CheckRows
   col50:
   mov ax,50
   mov CirclesX[SI],ax
   jmp CheckRows
   col90:
   mov ax,90
   mov CirclesX[SI],ax
   jmp CheckRows
   col130:
   mov ax,130
   mov CirclesX[SI],ax
   jmp CheckRows
   col170:
   mov ax,170
   mov CirclesX[SI],ax
   jmp CheckRows
   col210:
   mov ax,210
   mov CirclesX[SI],ax
   jmp CheckRows
   col250:
   mov ax,250
   mov CirclesX[SI],ax
   jmp CheckRows
   col290:
   mov ax,290
   mov CirclesX[SI],ax
   jmp CheckRows
   
   CheckRows:
   mov ax,20 
   mov CirclesY[SI],ax
   
   call ColorRandom ;puts color in CirclesColor
   ret

AddCircle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAWS CIRCLE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

drawCircle PROC

	lea di, Circle

	mov ah,0ch ;draw pixel command
	
	add cx,20
	mov extra,cx
	sub cx,20
push dx	
	add dx,20
	mov extra2,dx
	sub dx,20
	

loop2circ:
push cx
	loop1circ:
	mov bl,[di]
	cmp bl,1
	jz color1circ
	push bx
	mov bh,ah
	mov ax,CirclesColor[SI]
	mov ah,bh
	pop bx
	jmp color2circ
	color1circ:
	mov al,00h
	color2circ:
	int 10h
	inc cx
	inc di
	cmp cx,extra
	jnz loop1circ
	inc dx    
    pop cx
    cmp dx,extra2 ;row
	jnz loop2circ

pop dx	

	ret
drawCircle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAWS BLANK CIRCLE = ERASES CIRCLE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  


drawBlankCircle PROC
	mov al,0 ;pixel color
	mov ah,0ch ;draw pixel command 
	 
	mov extra,dx 
	add extra,20  
	
	mov extra2, cx
	
	mov bx,cx
	add bx,20                        
	                
   vertproccircle:          
    	horizproccircle: 
    	int 10h 
    	inc cx ;column 
    	cmp cx,bx ;column
    	jne horizproccircle
    	inc dx    
    	mov cx,extra2 ;45   
    	cmp dx,extra ;row
    	jnz vertproccircle    

    ret     	
drawBlankCircle ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GIVE COLOR TO CIRCLES (CALLED IN ANOTHER PROC)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HAS SPECIAL CONDITIONS FOR SHAPES SINCE THEIR COLORS ARE NOT RANDOM
		
ColorRandom PROC

cmp LevelTwo,1
jnz NotLevelTwo3

cmp CirclesCount,15 ;change the number here to change the frequency of SKULLS
jnz NotSkull

mov ax,07h
mov CirclesColor[SI],ax
ret

NotSkull:

cmp CirclesCount,20 ;change the number here to change the frequency of STARS
jnz NotStar 

   mov ax, 0Fh
   mov CirclesColor[SI], ax
   ret

NotStar:

NotLevelTwo3:

   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 4  ;Increase this number to add more colors
   div  cx       ; here dx contains the remainder of the division - from 0 to 3
   
   cmp dx,0
   jz LIGHTGREEN
   cmp dx,1
   JZ YELLOW
   cmp dx,2
   JZ BLUE
   cmp dx,3
   JZ RED
   
   LIGHTGREEN:
   mov ax, 0Ah
   mov CirclesColor[SI], ax
   ret
   
  YELLOW:
   mov ax, 0Eh
   mov CirclesColor[SI], ax
   ret
   
  BLUE:
   mov ax, 01h
   mov CirclesColor[SI], ax
   ret
   
  RED:
   mov ax, 04h
   mov CirclesColor[SI], ax
   ret
ColorRandom ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CHECKS IF THE CIRCLE HAS REACHED THE BOTTOM AND REPLACES IT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WITH A NEW CIRCLE

CompareCircleY PROC

cmp CirclesY[SI],104
jnz nextincompare

mov ax, CarOnePosition
call CheckCarAndCircle

mov ax, CarTwoPosition
call CheckCarAndCircle

call drawBlankCircle

call AddCircle

nextincompare:

cmp CirclesColor[SI],0Fh
jnz NotClear

mov ax,0
mov CirclesCount,ax

NotClear:

ret

CompareCircleY ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ADDS DELAY SO CIRCLES DON'T FALL TOO QUICKLY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


AddDelay PROC
mov al, 0
mov ah, 86h
mov cx, 1
mov dx, 2
int 15h
ret
AddDelay ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CHECKS IF THE CAR PICKED UP THE CIRCLE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (IF CAR IS ON THE SAME LANE AS CIRCLE WHEN CIRCLE REACHES BOTTOM)


CheckCarAndCircle PROC

push ax
push bx

mov bx,ax ;CarOnePosition or CarTwoPosition

add ax,5
cmp CirclesX[SI], ax
jnz endcheck

push ax
push SI

mov ax, CirclesColor[SI]
cmp al,0Ah ;green
jz GreenCircle

mov ax, CirclesColor[SI]
cmp al,0Eh ;yellow
jnz NotYellowCircle
jmp YellowCircle
NotYellowCircle:

mov ax, CirclesColor[SI]
cmp al,01h ;blue
jnz NotBlueCircle
jmp BlueCircle
NotBlueCircle:

mov ax, CirclesColor[SI]
cmp al,04h ;red
jnz NotRedCircle
jmp RedCircle ;out of range

NotRedCircle:
mov ax, CirclesColor[SI]
cmp al,0Fh ;white = stars
jz WhiteStar

mov ax,CirclesColor[SI]
cmp al,07h
jz LightGraySkull

done:
pop SI
pop ax

endcheck:
pop bx
pop ax

ret
CheckCarAndCircle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LIGHT GRAY SKULL EFFECT 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (KILLS PLAYER THAT PICKS IT UP)

LightGraySkull PROC

push SI
cmp bx,CarOnePosition
mov SI,0
jnz contLightGraySkull
cmp bx,CarTwoPosition
mov SI,1

contLightGraySkull: 

xor si,si

push ax
MOV al,0
mov Hearts[SI],al
pop ax

call CheckForWinner

jmp done
ret
LightGraySkull ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WHITE STAR EFFECT 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (PLAYER THAT PICKS IT UP WINS)

WhiteStar PROC

push SI
cmp bx,CarOnePosition
mov SI,0
jnz contStar
cmp bx,CarTwoPosition
mov SI,1

contStar: ;above checks which car to affect

push ax
MOV al,5
mov SCORE[SI],al
pop ax

;call PrintSmiley
pop SI

call CheckForWinner

jmp done
ret
WhiteStar ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GREEN CIRCLE EFFECT 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (ADD 1 SCORE, NEED 5 TO WIN)

GreenCircle PROC

push SI
cmp bx,CarOnePosition
mov SI,0
jnz contGreen
cmp bx,CarTwoPosition
mov SI,1

contGreen: ;above checks which car to affect

push ax
MOV al,SCORE[SI]
add al,1
mov SCORE[SI],al
pop ax

call PrintSmiley
pop SI

call CheckForWinner

jmp done
ret
GreenCircle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; YELLOW CIRCLE EFFECT 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (OPPONENT PLAYER MOVES IN OPPOSITE DIRECTION)

YellowCircle PROC

push SI
mov SI,0
cmp bx,CarOnePosition
jnz contYellow

cmp bx,CarTwoPosition
mov SI,1

contYellow:

mov ReversePeriod[SI],5

pop SI

jmp done
ret
YellowCircle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BLUE CIRCLE EFFECT 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (OPPONENT PLAYER BECOMES INVISIBLE SO THEY DON'T KNOW WHERE THEY ARE (NOT DRAWN))

BlueCircle PROC

push SI
mov SI,0
cmp bx,CarOnePosition
jnz contBlue

cmp bx,CarTwoPosition
mov SI,1

contBlue:

mov InvisiblePeriod[SI],5

pop SI

jmp done
ret
BlueCircle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RED CIRCLE EFFECT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (PLAYER THAT PICKS IT UP LOSES 1 HEART, LOSE 3 HEARTS TO LOSE THE GAME)

RedCircle PROC

push ax
push bx
push cx
push dx
push SI

mov dl,16
mov SI,0
cmp bx,CarTwoPosition
jnz contRed

mov SI,1
;cmp bx,CarTwoPosition
mov dl,36

contRed:
dec HEARTS[SI]
call CheckForWinner

pop SI
pop dx
pop cx
pop bx
pop ax

jmp done

ret
RedCircle ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SIMPLY CLEARS THE SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

ClearScreen PROC
	mov ax,0600h
	mov bh,07 ;gray
	mov cx,0
	mov dx,184fh
	int 10h
	ret
ClearScreen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CLEARS INTERFACE ON THE TOP (TO DRAW ON IT AGAIN)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

ClearTop PROC

push ax
push bx
push cx
push dx

	mov al,0 ;pixel color
	mov ah,0ch ;draw pixel command 
	mov cx,0
	mov dx,0	
     
   vertprocTop:          
    	horizprocTop: 
    	int 10h 
    	inc cx ;column 
    	cmp cx,320 ;column
    	jne horizprocTop
    	inc dx    
    	mov cx,0 ;45   
    	cmp dx,8 ;row
    	jnz vertprocTop    
		
pop dx
pop cx
pop bx
pop ax

ClearTop ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINT NAMES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

PrintInterface PROC

SetCursor 0,0

mov ah,9 ;write string in NameOne
mov dx, offset NameOne
int 21h

SetCursor 21,0

mov ah,9
mov dx, offset NameTwo
int 21h

ret
PrintInterface ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINT HEARTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

PrintHearts PROC

mov cl,Hearts[0]
mov dl,16
player1hearts:
inc dl
mov ah,2 ;set cursor position
mov dh,0 ;mov dx,0A0Ah or dl=X dh=Y
int 10h

push dx
mov dl,03 ;03 is heart
int 21h ;display character in dl
pop dx

dec cl
cmp cl,0
jnz player1hearts

mov cl,Hearts[1]
mov dl,36
player2hearts:
inc dl
mov ah,2 ;set cursor position
mov dh,0 ;mov dx,0A0Ah or dl=X dh=Y
int 10h

push dx
mov dl,03 ;03 is heart
int 21h ;display character in dl
pop dx

dec cl
cmp cl,0
jnz player2hearts

ret
PrintHearts ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINT SCORE (SMLEY FACE ASCII)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

PrintSmiley PROC

push ax
push bx
push cx
push dx

cmp SI,0 ;car 1
jz smile1
cmp SI,1 ;car 2
jmp smile2

smile1:
mov ah,2 ;set cursor position
mov dl,score[0]
add dl,21
mov dh,1 ;mov dx,0A0Ah or dl=X dh=Y
int 10h

mov ah,2
mov dl,02h
int 21h
jmp nosmile

smile2:
mov ah,2 ;set cursor position
mov dl,score[1]
mov dh,1 ;mov dx,0A0Ah or dl=X dh=Y
int 10h

mov ah,2
mov dl,02h
int 21h

;jmp nosmile
nosmile:

pop dx
pop cx
pop bx
pop ax

ret
PrintSmiley ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CHECK IF ANY PLAYER WON
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

CheckForWinner PROC

cmp score[1],5
jz Winner1
cmp Hearts[1],0
jbe Winner1

jmp CheckWinner2

Winner1:
mov ax,0600h
mov bh,00h
mov cx,0
mov dx,184Fh
int 10h

mov ax,3 ;change back to text mode
int 16

SetCursor 5,5

mov ah, 9
mov dx, offset NameOne
int 21h

call WinnerMessages

CheckWinner2:
cmp score[0],5
jz Winner2
cmp Hearts[0],0
jbe Winner2

jmp NoWinnerYet

Winner2:
mov ax,0600h
mov bh,00h
mov cx,0
mov dx,184Fh
int 10h

mov ax,3 
int 16

SetCursor 5,5

mov ah, 9
mov dx, offset NameTwo
int 21h

call WinnerMessages
 


NoWinnerYet:
ret

CheckForWinner ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINT CONGRATULATIONS SCREEN AND WINNER NAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

WinnerMessages PROC 

mov ah, 9
mov dx, offset VictoryMessage1
int 21h

SetCursor 5,10

mov ah, 9
mov dx, offset VictoryMessage2
int 21h

SetCursor 5,15

mov ah, 9
mov dx, offset VictoryMessage3
int 21h

mov ah,0
int 16h

mov ah,4ch
int 21h 
	
ret
WinnerMessages ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW ALL LINES 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; (LANES AND SEPARATORS)

DrawAllLines PROC

	mov cx,40
	drawverticallines1:               ;draws all vertical lanes besides middle line
	;mov cx,40 ;column
	mov dx,20 ;row
	mov al,5 ;pixel color
	mov ah,0ch ;draw pixel command
	back2:
	    int 10h
	    inc dx
	    cmp dx,170 ;edit
	    jnz back2
		
	add cx,40
	cmp cx,320
	jz donedrawverticallines
	jmp drawverticallines1
	    
	donedrawverticallines:            ;draws vertical lines
	
		mov cx,160 ;column
	mov dx,0 ;row
	mov al,7 ;pixel color
	mov ah,0ch ;draw pixel command
	back1:
	    int 10h
	    inc dx
	    cmp dx,170 ;edit
	    jnz back1 

	mov cx,0 ;column                 ;draws horizontal line to separate 
	mov dx,19 ;row
	mov al,7 ;pixel color
	mov ah,0ch ;draw pixel command
	backhoriz:
	    int 10h
	    inc cx
	    cmp cx,320 ;edit
	    jnz backhoriz  		
		
		
	mov cx,0 ;column                 ;draws horizontal line to separate 
	mov dx,170 ;row
	mov al,7 ;pixel color
	mov ah,0ch ;draw pixel command
	backhoriz2:
	    int 10h
	    inc cx
	    cmp cx,320 ;edit
	    jnz backhoriz2  	
		
	ret

DrawAllLines ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROCEDURES TO MOVE CARS LEFT AND RIGHT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

	MoveCarOneRight PROC ;note 165 is above maximum
	add CarOnePosition,40
	cmp CarOnePosition,165
	jnz Not165
	mov CarOnePosition,125
	Not165:
	ret
	MoveCarOneRight ENDP
	
	MoveCarOneLeft PROC ;note 165 is above maximum
	sub CarOnePosition,40
	cmp CarOnePosition,-35
	jnz Notneg35
	mov CarOnePosition,5
	Notneg35:
	ret
	MoveCarOneLeft ENDP
	
	MoveCarTwoRight PROC ;note 165 is above maximum
	drawBlankCar CarTwoPosition
	add CarTwoPosition,40
	cmp CarTwoPosition,325
	jnz Not325
	mov CarTwoPosition,285
	Not325:
	DrawCar CarTwoPosition
	ret
	MoveCarTwoRight ENDP
	
	MoveCarTwoLeft PROC ;note 165 is above maximum
	drawBlankCar CarTwoPosition
	sub CarTwoPosition,40
	cmp CarTwoPosition,125
	jnz Not125
	mov CarTwoPosition,165
	Not125:
	DrawCar CarTwoPosition
	ret
	MoveCarTwoLeft ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SERIAL-RELATED FUNCTIONS BELOW:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 	
	
ReceiveItem proc
mov dx,3FDH
in al,dx
test al,1
jnz ContinueReceive; not ready
jmp EndReceive ;jmp too far
ContinueReceive:

mov dx, 03f8h
in ax,dx
mov ItemToSend,ax


cmp ItemToSend,01Eh
jnz skip1
call MoveCarTwoLeft
ret

skip1:

cmp ItemToSend,020h
jnz skip2
call MoveCarTwoRight
ret

skip2:

cmp ItemToSend,3ch
jnz skip3
mov GameReadyReceive,1
ret

skip3:

cmp ItemToSend,3bh
jnz skip4
mov ChatReady,1
ret

skip4:

cmp GameReadySend,1
jnz skip5
cmp ItemToSend,121
jnz skip5
jmp levelselect
ret


skip5:


EndReceive:
RET
ReceiveItem endp


SendItem proc
mov dx,3fdh ;Line status register
in al,dx ;read line status
test al, 00100000b
jz endsend ;not empty

mov ax, bx
mov ItemToSend, ax

mov dx,3f8h
mov ax,bx
out dx,ax

endsend:
ret
SendItem endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INITIALIZE PORT:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

UART proc
mov dx,3fbh ;Line control register
mov al,10000000b ;Set DIvisor Latch Access Bit
out dx,al
mov dx,3f8h
mov al,0ch
out dx,al
mov dx,3f9h
mov al,0
out dx,al
mov dx,3fbh
mov al,00011011b
out dx,al
ret
UART endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CHAT-RELATED FUNCTIONS BELOW:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

SendChat proc
mov ah,01
int 16h
jnz ContinueSendChat
jmp EndSendChat
ContinueSendChat:
mov value,al

cmp value, 13
jz enterpressed

cmp value, 08
jnz Notbackspacepressed
jmp backspacepressed
Notbackspacepressed:


PressedChat:
mov dx,3fdh ;Line status register
in al,dx ;read line status
test al, 00100000b
jnz NotendsendChat ;not empty
jmp endsendchat
NotendsendChat:

SetCursor Cur_T_C, Cur_T_R
MOV ah,9
MOV CX,1 
MOV BH,0
MOV BL,40H ;Attribute 
mov AL, value
int 10h

;;;;;;;;;;;;;;;;;;;;;;;;
INC Cur_T_C
CMP Cur_T_C,79
JLE ContTChat
MOV Cur_T_C,0
INC Cur_T_R
CMP Cur_T_R,12
JLE ContTChat
CALL CheckScreen
MOV Cur_T_R,12
MOV Cur_T_C,0
jmp contTChat

enterpressed:
mov Cur_T_C,0
inc Cur_T_R
cmp Cur_T_R,12
JLE ContTChat
call CheckScreen
mov Cur_T_R,12
jmp ContTChat

backspacepressed:
dec Cur_T_C
cmp Cur_T_C,0
jge NotResetBackspace
mov ah,0
mov Cur_T_C,ah
NotResetBackspace:

MOV ah,9
MOV CX,1 
MOV BH,0
MOV BL,40H ;Attribute 
mov AL,20h
int 10h


ContTChat:
;;;;;;;;;;;;;;;;;;;;;;;;
 


mov dx,3f8h
mov al,value
out dx,al

mov ah,0
int 16h

cmp value,27
jne EndSendChat
mov exit,27
EndSendChat:
RET
SendChat endp
;---------------------------------------------
ReceiveChat proc
mov dx,3FDH
in al,dx
test al,1
jnz NotEndReceiveChat
jmp EndReceiveChat; not ready
NotEndReceiveChat:
mov dx, 03f8h
in al,dx
mov value,al

cmp value,13
jnz ContinueReceiveChat
jmp enterreceivedChat
ContinueReceiveChat:

cmp value, 08
jnz Notbackspacereceived
jmp backspacereceived
Notbackspacereceived:

cmp value,27
jne QChat
mov exit,27
jmp EndReceive
QChat: SetCursor Cur_R_C, Cur_R_R

MOV ah,9
MOV CX,1 
MOV BH,0
MOV BL,10H ;Attribute 
mov AL, value
int 10h

;;;;;;;;;;;;;;;;;;;;;;;;
INC Cur_R_C
CMP Cur_R_C,79
JLE ContRChat
MOV Cur_R_C,0
INC Cur_R_R
CMP Cur_R_R,24
JLE ContRChat
CALL CheckScreen2
MOV Cur_R_R,24
MOV Cur_R_C,0
jmp ContRChat

enterreceivedChat:
mov Cur_R_C,0
inc Cur_R_R
cmp Cur_R_R,24
JLE ContRChat
call CheckScreen2
mov Cur_R_R,24
jmp ContRChat

backspacereceived:
dec Cur_R_C
cmp Cur_R_C,0
jge NotResetBackspace2
mov ah,0
mov Cur_R_C,ah
NotResetBackspace2:

MOV ah,9
MOV CX,1 
MOV BH,0
MOV BL,10H ;Attribute 
mov AL,20h
int 10h

ContRChat:
;;;;;;;;;;;;;;;;;;;;;;;;
EndReceiveChat:
RET
ReceiveChat endp
;---------------------------------------------
CheckScreen PROC
mov ah,6       ; function 6
mov al,1        ; scroll by 1 line    
mov bh,40H       ; normal video attribute         
mov ch,0       ; upper left Y
mov cl,0        ; upper left X
mov dh,12     ; lower right Y
mov dl,79      ; lower right X 
int 10h     
RET
CheckScreen ENDP
;----------------------------------------------
CheckScreen2 PROC
mov ah,6       ; function 6
mov al,1        ; scroll by 1 line    
mov bh,10H       ; normal video attribute         
mov ch,13       ; upper left Y
mov cl,0        ; upper left X
mov dh,24     ; lower right Y
mov dl,79      ; lower right X 
int 10h     
RET
CheckScreen2 ENDP
;--------------------------------------------------
splitscreen proc
mov ah,6       ; function 6
   mov al,0       ; scroll by 1 line    
   mov bh,40h       ; normal video attribute         
   mov ch,0       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,12     ; lower right Y
   mov dl,79      ; lower right X 
   int 10h           
    
	mov ah,6       ; function 6
   mov al,0       ; scroll by 1 line    
   mov bh,10h      ; normal video attribute         
   mov ch,13       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,24     ; lower right Y
   mov dl,79      ; lower right X 
   int 10h  
ret
splitscreen endp




end main 