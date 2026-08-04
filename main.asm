org 100h

section .data
	val db 0
	
	hour db 0
	minute db 0
	second db 0
	
	topBorder db 0C9h, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0BBh, 13, 10, '$'
	mid db 0BAh, '$'
	newline db 13, 10, '$'
	bottomBorder db 0C8h, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0CDh, 0BCh, 13, 10, '$'
	
	colorFileName db 'COLORS.DAT', 0
	
	errT db 'Could not open file COLORS.DAT', '$'
	
	fileHandle dw 0
	
section .bss
	colors resb 33

section .text
start:
	call loadColors
	
	mov ah, 01h
	mov ch, 00100000b
	xor cl, cl
	int 10h

	mov si, colors
	jmp clockLoop
loadColors:
	mov ah, 3Dh
	xor al, al
	mov dx, colorFileName
	int 21h
	jc noFile
	mov word [fileHandle], ax
	
	mov ah, 3Fh
	mov bx, [fileHandle]
	mov cx, 32
	mov dx, colors
	int 21h
	
	mov ah, 3Eh
	mov bx, [fileHandle]
	int 21h
	ret	
clockLoop:
	mov ah, 02h
	int 1Ah
	
	mov byte [hour], ch
	mov byte [minute], cl
	mov byte [second], dh
	
	call clearScreen
	call drawTui
	
	mov ah, 86h
	mov cx, 000Fh
	mov dx, 4240h
	int 15h
	
	mov ah, 01h
	int 16h
	jz clockLoop
	
	xor ah, ah
	int 16h
	
	cmp al, 27
	je exit
	
	jmp clockLoop
	
drawTui:
	mov ah, 09h
	mov dx, topBorder
	int 21h
	
	mov dx, mid
	int 21h
	
	call printVals
	
	mov ah, 09h
	mov dx, mid
	int 21h
	
	mov dx, newline
	int 21h
	
	mov dx, bottomBorder
	int 21h
	ret
	
clearScreen:
	cmp [si], 00h
	jz resetSi
	mov bh, [si]
	inc si
clearScreen_t:
	mov ah, 06h
	mov al, 0
	xor cx, cx
	mov dx, 184Fh
	int 10h
	
	mov ah, 02h
	xor bh, bh
	xor dx, dx
	int 10h
	
	ret
printVals:	
	mov dl, [hour]
	mov byte [val], dl
	call printVal
	
	mov dl, ':'
	mov ah, 02h
	int 21h
	
	mov dl, [minute]
	mov byte [val], dl
	call printVal
	
	mov dl, ':'
	mov ah, 02h
	int 21h
	
	mov dl, [second]
	mov byte [val], dl
	call printVal
	ret
printVal:
	mov dl, [val]
	shr dl, 4
	add dl, '0'
	
	mov ah, 02h
	int 21h
	
	mov dl, [val]
	and dl, 00001111b
	add dl, '0'
	
	mov ah, 02h
	int 21h
	ret
exit:
	mov ah, 06h
	mov al, 0
	mov bh, 07h
	xor cx, cx
	mov dx, 184Fh
	int 10h
	
	mov ah, 01h
	mov ch, 0Bh
	mov cl, 0Ch
	int 10h

	mov ah, 4Ch
	int 21h
noFile:
	mov ah, 09h
	mov dx, errT
	int 21h
	
	mov ax, 4C01h
	int 21h
resetSi:
	mov si, colors
	mov bh, [si]
	inc si
	jmp clearScreen_t