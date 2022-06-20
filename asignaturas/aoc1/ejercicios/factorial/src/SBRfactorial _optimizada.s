		AREA datos,DATA,READWRITE	; area de datos
n		EQU 5						; variable n es cte durante el programa en main
s		DCD 0						; variable s

    	AREA prog,CODE,READONLY		; area de codigo
    	ENTRY						; primera instruccion a ejecutar

; PROGRAMA PRINCIPAL
		mov r0,#n			; r0 = n
		; invocaci�n a factorial
		sub sp,sp,#4		; reservo espacio para resultado
		PUSH{r0}			; apilo par�metro n por valor
		bl factorial		; invocaci�n a funci�n factorial
		add sp,sp,#4		; libero espacio del par�metro
		; almacenamiento resultado
		POP{r0}				; desapilo en r0 el resultado de factorial
		LDR r1,=s			; r1 tiene la direcci�n de la variable s
		str r0,[r1]			; almaceno resultado asignando valor devuelto por factorial a variable s

fin		b fin				; fin programa principal
; FIN PROGRAMA PRINCIPAL
		
; SBR FACTORIAL
		; gesti�n BA
factorial	PUSH{lr}			; apilo direcci�n de retorno
			PUSH{r11}			; apilo r11
			mov fp,sp			; creaci�n del frame pointer
			PUSH{r0-r1}			; apilo registros que voy a utilizar

			mov r1,#1			; r1 = 1 -> variable r de alto nivel
			ldr r0,[fp,#8]		; r0 = n
			cmp r0,#0			; n == 0 ?
			beq fins			; n == 0 -> fin de if
			; n != 0 => invocaci�n recursiva
			sub r1,r0,#1        ; r1 = n - 1 (solo para preparar la invocación)
			sub sp,sp,#4		; reservo espacio para el resultado
			PUSH{r1}			; apilo par�metro por valor n-1
			bl factorial
			add sp,sp,#4		; libero espacio del par�metro
			POP{r1}				; r1 = factorial(n-1)
			mul r1,r0,r1		; r1 = n * factorial(n-1)
			; fin if

fins		str r1,[fp,#0xC]	; return r => devoluci�n de factorial
			POP{r0-r1}			; desapilo valores iniciales de los registros utilizados
			POP{r11}			; recupero valor de r11
			POP{pc}				; retorno de la SBR
; FIN SBR FACTORIAL
		


		END							; fin de ensamblado