;_ llmath.asm
; Copyright (C) 1993 by Digital Mars
; All Rights Reserved
; Written by Walter Bright

include	macros.asm

; 64 bit negate
neg64	macro	reg1,reg2
	 neg	reg1
	 neg	reg2
	 sbb	reg1,0
	endm


	begcode	llmath

	public	__LMUL@,__LDIV@,__ULDIV@,__LCMP@

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Multiply:
;	EDX,EAX = EDX,EAX * ECX,EBX
; ECX is destroyed

__LMUL@	proc	near
    if 0
	push	ESI
	mov	ESI,EDX		;ESI = d
	xchg	EAX,ECX		;EAX = c, ECX = a
	tst	EAX
	jz	short M1
	mul	ECX		;EAX = acl
M1:	xchg	EAX,ESI		;ESI = acl, EAX = d
	tst	EAX
	jz	short M2
	mul	EBX		;EAX = bdl
	add	ESI,EAX		;ESI = acl + bdl
M2:	mov	EAX,ECX		;EAX = a
	mul	EBX		;EAX = abl, EDX = abh
	add	EDX,ESI		;EAX = abl, EDX = abh + acl + bdl
	pop	ESI
	ret
    else
	tst	ECX
	jnz	short M1
	tst	EDX
	jnz	short M2
	mul	EBX
	ret

	even
M1:	tst	EDX
	jnz	short M3
	;EDX is 0
	xchg	EAX,ECX
	mul	ECX
	xchg	EAX,ECX
	mul	EBX
	add	EDX,ECX
	ret

	even
M2:	;ECX is 0
	mov	ECX,EAX
	mov	EAX,EDX
	mul	EBX
	xchg	EAX,ECX
	mul	EBX
	add	EDX,ECX
	ret

	even
M3:	push	ESI
	mov	ESI,EDX		;ESI = d
	xchg	EAX,ECX		;EAX = c, ECX = a
	mul	ECX		;EAX = acl
	xchg	EAX,ESI		;ESI = acl, EAX = d
	mul	EBX		;EAX = bdl
	add	ESI,EAX		;ESI = acl + bdl
	mov	EAX,ECX		;EAX = a
	mul	EBX		;EAX = abl, EDX = abh
	add	EDX,ESI		;EAX = abl, EDX = abh + acl + bdl
	pop	ESI
	ret
    endif
__LMUL@	endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Unsigned long divide.
; Input:
;	[EDX,EAX],[ECX,EBX]
; Output:
;	[EDX,EAX] = [EDX,EAX] / [ECX,EBX]
;	[ECX,EBX] = [EDX,EAX] % [ECX,EBX]
;	ESI,EDI	destroyed

	even

uldiv	proc	near
	tst	EDX
	jnz	short D3
	;High words are 0, we can use the DIV instruction
	div	EBX
	mov	EBX,EDX
	mov	EDX,ECX			;EDX = ECX = 0
	ret

	even
D3:	;Divide [EDX,EAX] by EBX
	mov	ECX,EAX
	mov	EAX,EDX
	clr	EDX
	div	EBX
	xchg	ECX,EAX
	div	EBX
	;ECX,EAX = result
	;EDX = remainder
	mov	EBX,EDX
	mov	EDX,ECX
	clr	ECX
	ret
uldiv	endp

	even

__ULDIV@ proc	near
	test	ECX,ECX
	jz	uldiv

	push	EBP

	;left justify [ECX,EBX] and leave count of shifts + 1 in EBP

	mov	EBP,1			;at least 1 shift
	tst	ECX			;left justified?
	js	short L1		;yes
	jnz	short L2
	add	EBP,8
	mov	CH,CL
	mov	CL,BH
	mov	BH,BL
	clr	BL			;[ECX,EBX] <<= 8
	tst	ECX
	js	short L1
	even
L2:	inc	EBP			;another shift
	shl	EBX,1
	rcl	ECX,1			;[ECX,EBX] <<= 1
	jno	short L2		;not left justified yet

L1:	mov	ESI,ECX
	mov	EDI,EBX			;[ESI,EDI] = divisor

	mov	ECX,EDX
	mov	EBX,EAX			;[ECX,EBX] = [EDX,EAX]
	clr	EAX
	cdq				;[EDX,EAX] = 0
	even
L4:	_if	ESI a ECX, L3		;is [ECX,EBX] > [ESI,EDI]?
	jb	L5			;definitely less than
	_if	EDI a EBX, L3		;check low order word
L5:	sub	EBX,EDI
	sbb	ECX,ESI			;[ECX,EBX] -= [ESI,EDI]
	stc				;rotate in a 1
L3:	rcl	EAX,1
	rcl	EDX,1			;[EDX,EAX] = ([EDX,EAX] << 1) + C
	shr	ESI,1
	rcr	EDI,1			;[ESI,EDI] >>= 1
	dec	EBP			;control count
	jne	short L4
	pop	EBP
	ret

div0:	mov	EAX,-1
	cdq				;quotient is -1
	clr	ECX
	mov	EBX,ECX			;remainder is 0 (ECX and EBX already 0)
	pop	EBP
	ret

L10:	tst	ECX			;[ECX,EBX] negative?
	jns	__ULDIV@		;no (all is positive)
	neg64	ECX,EBX
	call	__ULDIV@
	neg64	EDX,EAX			;quotient is negative
	ret
__ULDIV@ endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Signed long divide.
; Input:
;	[EDX,EAX],[ECX,EBX]
; Output:
;	[EDX,EAX] = [EDX,EAX] / [ECX,EBX]
;	[ECX,EBX] = [EDX,EAX] % [ECX,EBX]
;	ESI,EDI	destroyed

	even

__LDIV@	proc	near
	tst	EDX			;[EDX,EAX] negative?
	jns	short L10		;no
	neg64	EDX,EAX			;[EDX,EAX] = -[EDX,EAX]
	tst	ECX			;[ECX,EBX] negative?
	jns	short L11		;no
	neg64	ECX,EBX
	call	__ULDIV@
	neg64	ECX,EBX			;remainder same sign as dividend
	ret

L11:	call	__ULDIV@
	neg64	ECX,EBX			;remainder same sign as dividend
	neg64	EDX,EAX			;quotient is negative
	ret

__LDIV@	endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Compare [EDX,EAX] with [ECX,EBX]
; Signed

	even
__LCMP@	proc	near
	cmp	EDX,ECX
	jne	short C1
	push	EDX
	clr	EDX
	cmp	EAX,EBX
	jz	short C2
	ja	short C3
	dec	EDX
	pop	EDX
	ret

C3:	inc	EDX
C2:	pop	EDX
C1:	ret
__LCMP@	endp

	endcode	lmath

	end
