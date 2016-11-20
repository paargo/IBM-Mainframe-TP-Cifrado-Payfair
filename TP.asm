segment datos data
pruebaEsc	db	10,13,'Prueba$'

msgIng	db	'Ingrese un conj de elementos de 2 carac(max 20): ','$'
tituloMenu db 10,13,'Menu:','$'
opcion1 db 10,13,'1) Pertenencia de un elemento a un conjunto$'
opcion2 db 10,13,'2) Igualdad de dos conjuntos$'
opcion3 db 10,13,'3) Inclusion de un conjunto en otro$'
opcion4 db 10,13,'4) Mostrar conjuntos$'
opcion0 db 10,13,'0) Salir del programa$'

msgConj	db 10,13,'Ingrese un numero de conjunto (1-6)','$'


solicElem db 10,13,'Ingrese elemento (2 caracteres)$'
msjNoExis db 10,13,'El elemento NO existe en el conjunto$'
msjExis db 10,13,'El elemento existe en el conjunto$'
msjCont db 10,13,'El conjunto A se encuentra contenido en el conjunto B$'
msjNoCont db 10,13,'El conjunto A NO se encuentra contenido en el conjunto B$'
msjIgual db 10,13,'El conjunto A es igual al conjunto B$'
msjNoIgual db 10,13,'El conjunto A NO es igual al conjunto B$'
msjElemInv db 10,13,'Elemento invalido ingrese nuevamente$'

conjfi1 db '1234567890123456789012345678901234567890$$'
conjfi2 db '341290$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
conjfi3 db '1234567890123456789012345678901234567890$$'
conjfi4 db '1234567890123456789012345678901234567890$$'
conjfi5 db '341290$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
conjfi6 db '1234567890123456789012345678901234567890$$'


conj1 db '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'

existe	db	'N'
esIgual db	'N'
estaCont db	'N'
elemVal db 'N'

dirco1  dw 0
dirco2  dw 0

dirGen  dw 0
conjA  dw 0
conjB  dw 0

cantConj db 1		
vacio 	db 10,13,'$'
prueba	db 2

vector   times 246 db '$'

		db	5
		db	0
elem	times 3 db  '$'
contador	db 2

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
		je 		Igual
		cmp 	al,'3'
		je 		cotenido
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
		
		call	validaElem
		cmp		byte[elemVal],'N'
		je		pertenece
;llamar a caracter valido

		call	elijoConj
		mov		ax,[elem]		
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
cicloBus:				
		cmp ax,word[bx+si]
		jne distinto
		mov byte[existe],'S'
			ret		
distinto:		
		inc	si
		inc si
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
	
;---------------------------------------;

;-------------------1 COJUNTO ESTA CONTENIDO EN OTRO-------------------------;
cotenido:
		call	elijoConj 		;ELIJE EL CONJUNTO A
		mov		[conjA],bx
		call	elijoConj 		;ELIJE EL CONJUNTO B
		mov		[conjB],bx
		call 	funcCont
		cmp		byte[estaCont],'S'
		jne		noCont
		mov 	dx,msjCont
		mov 	ah,9
		int 	21h			
		jmp		menu

noCont:
		mov 	dx,msjNoCont
		mov 	ah,9
		int 	21h			
		jmp		menu

funcCont:
		mov	word[contador],20
		mov byte[estaCont],'N'
		mov	si,0
		
cicloCont:
		mov	byte[existe],'N'
		mov	bx,[conjA]
		mov ax,word[bx+si]
		mov	[elem],ax
		mov	bx,[conjB]
		
		cmp	byte[elem],'$'
		je	finSCont

		call	elemEnConj
		
		cmp	byte[existe],'N'
		je	finNCont
		
		sub	word[contador],1
		inc	si
		inc	si
		cmp	word[contador],0
		jne cicloCont
finSCont:
		mov byte[estaCont],'S'
			ret
finNCont:
		mov byte[estaCont],'N'
			ret
;--------------FIN 1 COJUNTO ESTA CONTENIDO EN OTRO-------------------------------;
;-------------------------1 COJUNTO ES IGUAL A OTRO-------------------------------;
Igual:
		call	elijoConj 		;ELIJE EL CONJUNTO A
		mov		[conjA],bx
		call	elijoConj 		;ELIJE EL CONJUNTO B
		mov		[conjB],bx
		
		call 	funcCont
		cmp		byte[estaCont],'S'
		jne		noEsIgual

		mov		bx,[conjA]
		mov		ax,[conjB]
		mov		[conjB],bx
		mov		[conjA],ax
		call 	funcCont
		cmp		byte[estaCont],'S'
		jne		noEsIgual
		
		mov 	dx,msjIgual
		mov 	ah,9
		int 	21h			
		jmp		menu

noEsIgual:
		mov 	dx,msjNoIgual
		mov 	ah,9
		int 	21h			
		jmp		menu

;-----------------------FIN 1 COJUNTO ES IGUAL A OTRO-----------------------------;
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
;------------------------VALIDA ELEMENTO------------------------------------------;
validaElem:
		mov si,0
cicloVal:
		cmp	byte[elem+si],'A'
		jl	valNum
		cmp	byte[elem+si],'Z'
		jnle elemInval
		jle	proxByte
valNum:		
		cmp	byte[elem+si],'0'
		jl  elemInval
		cmp	byte[elem+si],'9'
		jnle elemInval
proxByte:		
		inc si
		cmp si,2
		jl	cicloVal
elemValido:		
		mov	byte[elemVal],'S'
			ret
elemInval:
		mov 	dx,msjElemInv
		mov 	ah,9
		int 	21h
		mov	byte[elemVal],'N'
			ret
;------------------------FIN VALIDA ELEMENTO--------------------------------------;
;------------------------GUARDAR CONJUNTO EN BX-----------------------------------;
elijoConj:
		mov 	dx,msgConj
		mov 	ah,9
		int 	21h
;		call	impConjuntos
		mov 	dx,vacio
		mov 	ah,9
		int 	21h
		
		call 	leer_caracter
		cmp 	al,'1'
		jne 	opConj2
		mov		bx,conjfi1
			ret
opConj2:
		cmp 	al,'2'
		jne 	opConj3
		mov		bx,conjfi2
			ret
opConj3:
		cmp 	al,'3'
		jne 	opConj4
		mov		bx,conjfi3
			ret
opConj4:
		cmp 	al,'4'
		jne 	opConj5
		mov		bx,conjfi4
			ret
opConj5:
		cmp 	al,'5'
		jne 	opConj6
		mov		bx,conjfi5
			ret
opConj6:
		cmp 	al,'6'
		jne 	elijoConj
		mov		bx,conjfi6
			ret
		jmp 	menu

			ret
;----------------------FIN GUARDAR CONJUNTO EN BX---------------------------------;
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