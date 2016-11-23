segment datos data

msgIng	db	10,13,'Ingrese un conj de elementos de 2 carac(max 20) o 2 signos de pesos: ','$'
tituloMenu db 10,13,'Menu:','$'
opcion1 db 10,13,'1) Pertenencia de un elemento a un conjunto$'
opcion2 db 10,13,'2) Igualdad de dos conjuntos$'
opcion3 db 10,13,'3) Inclusion de un conjunto en otro$'
opcion4 db 10,13,'4) Mostrar conjuntos$'
opcion0 db 10,13,'0) Salir del programa$'

msgConj	db 10,13,'Ingrese un numero de conjunto (1-6)','$'
solicElem db 10,13,'Ingrese elemento (2 caracteres) o 2 signo pesos para ir al menu:$'
msjNoExis db 10,13,'El elemento NO existe en el conjunto$'
msjExis db 10,13,'El elemento existe en el conjunto$'
msjCont db 10,13,'El conjunto A se encuentra contenido en el conjunto B$'
msjNoCont db 10,13,'El conjunto A NO se encuentra contenido en el conjunto B$'
msjIgual db 10,13,'El conjunto A es igual al conjunto B$'
msjNoIgual db 10,13,'El conjunto A NO es igual al conjunto B$'
msjElemInv db 10,13,'Elemento invalido ingrese nuevamente$'
msjConjInv db 10,13,'Conjunto invalido ingrese nuevamente$'

conjVacio times 42 db '$'

existe	db	'N'
esIgual db	'N'
estaCont db	'N'
elemVal db 'N'
valConj db 'N'

conjA  dw 0
conjB  dw 0
	
vacio 	db 10,13,'$'

elem	times 3 db  '$'
contador	db 2

		db	41
		db	0
conjfi1 times 41 resb '$'

		db	41
		db	0
conjfi2 times 41 resb '$'

		db	41
		db	0
conjfi3 times 41 resb '$'

		db	41
		db	0
conjfi4 times 41 resb '$'

		db	41
		db	0
conjfi5 times 41 resb '$'

		db	41
		db	0
conjfi6 times 41 resb '$'
;-------------------------FIN SEGMENT DATA---------------------;
segment pila stack
	resb 64
	stacktop:
;-------------------------FIN SEGMENT STACK--------------------;
segment codigo code
..start:
;inicializacion
		mov		ax,datos
		mov		ds,ax
		mov		ax,pila
		mov 	ss,ax
		mov		sp,stacktop
;fin inicializacion
;---------------------SOLICITA CONJUNTOS-------------------;
obtConj1:
		call	obtConj
		lea		dx,[conjfi1-2]
		call	cargaConj
		mov		bx,conjfi1
		call	proceConj
		cmp		byte[valConj],'N'
		je		obtConj1

obtConj2:		
		call	obtConj
		lea		dx,[conjfi2-2]
		call	cargaConj
		mov		bx,conjfi2
		call	proceConj
		cmp		byte[valConj],'N'
		je		obtConj2

obtConj3:
		call	obtConj
		lea		dx,[conjfi3-2]
		call	cargaConj
		mov		bx,conjfi3
		call	proceConj
		cmp		byte[valConj],'N'
		je		obtConj3

obtConj4:
		call	obtConj
		lea		dx,[conjfi4-2]
		call	cargaConj
		mov		bx,conjfi4
		call	proceConj
		cmp		byte[valConj],'N'
		je		obtConj4

obtConj5:
		call	obtConj
		lea		dx,[conjfi5-2]
		call	cargaConj
		mov		bx,conjfi5
		call	proceConj
		cmp		byte[valConj],'N'
		je		obtConj5
		
obtConj6:
		call	obtConj
		lea		dx,[conjfi6-2]
		call	cargaConj
		mov		bx,conjfi6
		call	proceConj
		cmp		byte[valConj],'N'
		je		obtConj6
		jmp		menu

obtConj:
		mov 	dx,msgIng
		call	printMsg
			ret
cargaConj:
		mov		ah,0ah
		int		21h
			ret
proceConj:
		call	insertFin
		call	validaConj
			ret
insertFin:		
		mov 	ax,0
		mov		al,[bx-1]
		mov		si,ax
		mov		byte[bx+si],'$'
			ret
validaConj:
		mov		di,1
		mov		cx,20
cicValConj:		
		mov		byte[valConj],'N'
		mov		ax,word[bx+di]
		mov		word[elem],ax
		call	validaElem
		cmp		byte[elemVal],'O'
		je		finValConj
		cmp		byte[elemVal],'N'
		jne		valConjloop
		mov 	dx,msjConjInv
		call	printMsg
		mov		byte[valConj],'N'
			ret
valConjloop:
		inc		di
		inc		di
		loop	cicValConj
finValConj:
		mov		byte[valConj],'S'
			ret

;---------FIN SOLICITA CONJUNTOS--------;
;------------------MENU-----------------;
menu:
		call limpiaVar
		mov 	dx,tituloMenu
		call	printMsg
		mov 	dx,opcion1
		call	printMsg
		mov 	dx,opcion2
		call	printMsg
		mov 	dx,opcion3
		call	printMsg
		mov 	dx,opcion4
		call	printMsg
		call	printVacio
		mov 	dx,opcion0
		call	printMsg
		call	printVacio
		
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
		call	printMsg
		
		call	leer_caracter
		mov		byte[elem],al
		
		mov 	dx,solicElem
		call	printMsg
			
		call	leer_caracter
		mov		byte[elem+1],al
		mov		byte[elem+2],'$'
		
		call	validaElem
		cmp		byte[elemVal],'N'
		je		pertenece

		call	elijoConj
		mov		ax,[elem]		
		call	elemEnConj	
		
		cmp		byte[existe],'S'
		je		elemExis
		mov 	dx,msjNoExis
		call	printMsg
		jmp		finPert
elemExis:		
		mov 	dx,msjExis
		call	printMsg
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
;-------------------1 COJUNTO ESTA CONTENIDO EN OTRO-------------------------;
cotenido:
		call	elijoConj 		
		mov		[conjA],bx
		call	elijoConj 		
		mov		[conjB],bx
		call 	funcCont
		cmp		byte[estaCont],'S'
		jne		noCont
		mov 	dx,msjCont
		call	printMsg		
		jmp		menu

noCont:
		mov 	dx,msjNoCont
		call	printMsg	
		jmp		menu

funcCont:
		mov		word[contador],20
		mov 	byte[estaCont],'N'
		mov		si,0
		
cicloCont:
		mov		byte[existe],'N'
		mov		bx,[conjA]
		mov 	ax,word[bx+si]
		mov		[elem],ax
		mov		bx,[conjB]
		
		cmp		byte[elem],'$'
		je		finSCont

		call	elemEnConj
		
		cmp		byte[existe],'N'
		je		finNCont
		
		sub		word[contador],1
		inc		si
		inc		si
		cmp		word[contador],0
		jne 	cicloCont
finSCont:
		mov 	byte[estaCont],'S'
			ret
finNCont:
		mov 	byte[estaCont],'N'
			ret
;--------------FIN 1 COJUNTO ESTA CONTENIDO EN OTRO-------------------------------;
;-------------------------1 COJUNTO ES IGUAL A OTRO-------------------------------;
Igual:
		call	elijoConj 		
		mov		[conjA],bx
		call	elijoConj 		
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
		call	printMsg	
		jmp		menu

noEsIgual:
		mov 	dx,msjNoIgual
		call	printMsg		
		jmp		menu

;-----------------------FIN 1 COJUNTO ES IGUAL A OTRO-----------------------------;
;-------------------MOSTRAR CONJUNTOS (OPCION 4)----------------------------------;
impConjuntos:
		call	printVacio	
		mov	    dx,conjfi1
		call	printMsg
		call	printVacio
		mov	    dx,conjfi2
		call	printMsg
		call	printVacio
		mov	    dx,conjfi3
		call	printMsg
		call	printVacio
		mov	    dx,conjfi4
		call	printMsg
		call	printVacio
		mov	    dx,conjfi5
		call	printMsg
		call	printVacio
		mov	    dx,conjfi6
		call	printMsg
		call	printVacio
		jmp 	menu
;-------------------FIN MOSTRAR CONJUNTOS (OPCION 4)------------------------------;		
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
		cmp		byte[elem+si],'$'
		jne		reingrese
		cmp		byte[elem+si+1],'$'
		jne		reingrese
		mov		byte[elemVal],'O'
			ret
reingrese:		
		mov 	dx,msjElemInv
		call	printMsg
		mov	byte[elemVal],'N'
			ret
;------------------------FIN VALIDA ELEMENTO--------------------------------------;
;------------------------GUARDAR CONJUNTO EN BX-----------------------------------;
elijoConj:
		mov 	dx,msgConj
		call	printMsg
		call	printVacio
		
		call 	leer_caracter
		cmp 	al,'1'
		jne 	opConj2
;		mov		bx,word[conjfi1]
		mov		bx,conjfi1
			ret
opConj2:
		cmp 	al,'2'
		jne 	opConj3
;		mov		bx,word[conjfi2]
		mov		bx,conjfi2
			ret
opConj3:
		cmp 	al,'3'
		jne 	opConj4
;		mov		bx,word[conjfi3]
		mov		bx,conjfi3
			ret
opConj4:
		cmp 	al,'4'
		jne 	opConj5
;		mov		bx,word[conjfi4]
		mov		bx,conjfi4
			ret
opConj5:
		cmp 	al,'5'
		jne 	opConj6
;		mov		bx,word[conjfi5]
		mov		bx,conjfi5
			ret
opConj6:
		cmp 	al,'6'
		jne 	elijoConj
;		mov		bx,word[conjfi6]
		mov		bx,conjfi6
			ret

;----------------------FIN GUARDAR CONJUNTO EN BX---------------------------------;
;-----------------------------	
printVacio:
		mov		dx,vacio
		call	printMsg
			ret
printMsg:
		mov		ah,9
		int		21h
			ret
leer_caracter:
		mov	ah,1
		int 21h
			ret
limpiaVar:
		mov		ax,0
		mov		bx,0
		mov		cx,0
		mov		dx,0
		mov		si,0
			ret
;--------------FIN FUNCIONES------------;	
;--------Retorno al sistema operativo-------;
fin		mov		ah,4ch
		int		21h
;------FIN RETORNO AL SISTEMA OPERATIVO-----;