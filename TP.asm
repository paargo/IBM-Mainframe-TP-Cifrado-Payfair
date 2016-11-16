segment datos data
pruebaEsc	db	10,13,'Prueba$'

msgIng	db	'Ingrese un conj de elementos de 2 carac(max 20): ','$'
tituloMenu db 10,13,'Menu:','$'
opcion1 db 10,13,'1) Pertenencia de un elemento a un conjunto$'
opcion2 db 10,13,'2) Igualdad de dos conjuntos$'
opcion3 db 10,13,'3) Inclusion de un conjunto en otro$'
opcion4 db 10,13,'4) Mostrar conjuntos$'
opcion0 db 10,13,'0) Salir del programa$'

solicElem db 10,13,'Ingrese elemento (2 caracteres)$'
msjNoExis db 10,13,'El elemento no existe en el conjunto$'
msjExis db 10,13,'El elemento existe en el conjunto$'

conjfi1 db '1234567890123456789012345678901234567890$'
conjfi2 db '1234567890$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'

existe	db	'N'
dirco1  dw 0
dirco2  dw 0

dirGen  dw 0

		db	41
		db	0
conj1	times 40 resb 1
		db	41
		db	0
conj6	times 40 resb 1

cantConj db 1		
vacio 	db 10,13,'$'
prueba	db 2

vector   times 246 db '$'

		db	5
		db	0
elem	times 3 db  '$'

segment pila stack
	resb 64
	stacktop:

segment codigo code
..start:

;inicializacion
		mov		ax,datos
		mov		ds,ax
		mov		ax,pila
		mov 	ss,ax
		mov		sp,stacktop

		mov		ax,word[conjfi1]
		mov		[dirco1],ax
		mov		ax,word[conjfi2]
		mov		[dirco2],ax

		
;		lea		ax,[conjfi1]
;		mov	 	[dirco1],ax
;		lea		ax,[conjfi2]
;		mov	 	[dirco2],ax
;fin inicializacion

;-----------SOLICITA CONJUNTOS----------;
;		call	obtConj
;		mov		bx,0
;		mov		bx,[conj6]
;		mov		[conj1],bx

;		jmp		menu
;SE COMENTA PARA USAR LA APLICACION CON LOS CONJUNTOS FIJOS
;---------FIN SOLICITA CONJUNTOS--------;
;------------------MENU-----------------;
menu:
		call limpiaVar
		mov 	dx,tituloMenu
		mov 	ah,9
		int 	21h
		mov 	dx,opcion1
		mov 	ah,9
		int 	21h
		mov 	dx,opcion2
		mov 	ah,9
		int 	21h
		mov 	dx,opcion3
		mov 	ah,9
		int 	21h
		mov 	dx,opcion4
		mov 	ah,9
		int 	21h
		mov 	dx,vacio
		mov 	ah,9
		int 	21h
		mov 	dx,opcion0
		mov 	ah,9
		int 	21h	
		mov 	dx,vacio
		mov 	ah,9
		int 	21h
		
		call 	leer_caracter
		cmp 	al,'1'
		je 		pertenece
		cmp 	al,'2'
		je 		menu
		cmp 	al,'3'
		je 		menu
		cmp 	al,'4'
		je 		impConjuntos
		cmp 	al,'0'
		je 		fin
		jmp 	menu
;----------------FIN MENU---------------;
;----------------FUNCIONES--------------;	
;------PIDO ELEMENTO PARA BUSCAR--------;	
pertenece:
		mov 	dx,solicElem
		mov 	ah,9
		int 	21h
		
		call	leer_caracter
		mov		byte[elem],al
;llamar a caracter valido		
		
		mov 	dx,solicElem
		mov 	ah,9
		int 	21h
			
		call	leer_caracter
		mov		byte[elem+1],al
		mov		byte[elem+2],'$'
;llamar a caracter valido

		mov		bx,[dirco1]
		mov		[dirGen],bx
		call	elemEnConj	
		
		cmp		byte[existe],'S'
		je		elemExis
		mov 	dx,msjNoExis
		mov 	ah,9
		int 	21h
		jmp		finPert
elemExis:		
		mov 	dx,msjExis
		mov 	ah,9
		int 	21h
finPert:
		jmp		menu

;----FIN PIDO ELEMENTO PARA BUSCAR------;
;--------BUSCO ELEM EN CONJUNTO---------;
elemEnConj:
		mov cx,20
		mov si,0
		mov	bx,[elem]		

cicloBus:				
		cmp bx,word[dirGen]
		jne distinto
		mov byte[existe],'S'
		ret
		
distinto:		
		inc	si
		loop cicloBus
		mov byte[existe],'N'
		ret

;------FIN BUSCO ELEM EN CONJUNTO-------;
;----------------FUNCIONES--------------;	
;---------------------------------------;	
obtConj:
		lea		dx,[msgIng]
		call	printMsg
		
		lea		dx,[vector]
		mov		ah,0ah
		int		21h
		
		mov 	dx,vacio
		mov 	ah,9
		int 	21h		
			ret

leer_caracter:
		mov	ah,1
		int 21h
		ret

converADec:
		sub 	ax,48
		ret
	
;---------------------------------------;
;-------------------MOSTRAR CONJUNTOS (OPCION 2)----------------------------------;
impConjuntos:
			
		mov 	dx,vacio
		mov 	ah,9
		int 	21h
		
		mov 	dx,[dirco1]
		mov 	ah,9h
		int 	21h
	
		mov 	dx,vacio
		mov 	ah,9
		int 	21h
		
		mov 	dx,[dirco2]
		mov 	ah,9h
		int 	21h
		
;	mov	si,0					; puntero al elemento corriente del vector
;impOtro:
;	mov	cx,20					; contador para loop
;cargoOtro:
;	mov	dl,[vector + si]	  	; copio en 'dl' el elemento del vector a imprimir
;	mov	ah,2					; imprimo el elemento del vec
;	int	21h

;	inc	si						; me adelanto al prox elemento
;	loop cargoOtro				; resta 1 a cx y si es <> 0 bifurca a 'otro'
	
;	lea	dx,[vacio]				
;	mov	ah,9
;	int	21h
	
;	dec byte[cantConj]
;	cmp byte[cantConj],0
;	jne impOtro
	jmp menu
;SE COMENTA POR BACKUP PARA USAR SIN CARGA DE VECTORES
;-------------------FIN MOSTRAR CONJUNTOS (OPCION 2)------------------------------;		
;-----------------------------	
printMsg:
		mov		ah,9
		int		21h
			ret
		
limpiaVar:
		mov		ax,0
		mov		bx,0
		mov		cx,0
		mov		dx,0
		mov		si,0
		mov		byte[cantConj],1
			ret
;--------------FIN FUNCIONES------------;	

;--------Retorno al sistema operativo-------;
fin		mov		ah,4ch
		int		21h
;------FIN RETORNO AL SISTEMA OPERATIVO-----;


;ROMPE CUANDO LLAMAS 2 VECES SEGUIDAS AL MOSTRAR