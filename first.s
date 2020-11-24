    PRESERVE8
    AREA appcode,CODE,READONLY
	 AREA     factorial, CODE, READONLY
     IMPORT printMsg
	 IMPORT printComma
	 IMPORT printNextl
     IMPORT printMessage	 
	 EXPORT __main
	 EXPORT __COSINE
	 EXPORT __SINE
	 EXPORT __DRAWCIRC
		ENTRY 
;---------------------------------------------------------------------------------------------------------------------------------------------------

__SINE FUNCTION			;(INPUT S9=X | OUTPUT S5=SIN(X))
     				;x=0-360(in degrees)
					;PUSH {LR}
        VLDR.F32 S1,=90.0

        VMOV.F32 S0,S9

        VCMP.F32 S9,S1

		VMRS APSR_nzcv, FPSCR

		BLT START

        VLDR.F32 S1,=180.0		

		VSUB.F32 S0,S1,S9

        VLDR.F32 S1,=270.0

		VCMP.F32 S9,S1

		VMRS APSR_nzcv, FPSCR

        BLT START

		VLDR.F32 S1,=360.0

        VSUB.F32 S0,S9,S1

											;S0 stores angle in range -PI/2 to PI/2


START   VLDR.F32 S7,=3.141592654

		VLDR.F32 S8,=180.0

		VLDR.F32 S6,=1.0

		MOV R1,#20         					;NUMBER OF TERMS IN COMPUTATION

		

		VMUL.F32 S1,S0,S7

		VDIV.F32 S1,S1,S8					;x=PI*(theta)/180

		VMUL.F32 S2,S1,S1					;x^2

		VNEG.F32 S2,S2						;-x^2

		VMOV.F32 S3,S1						;S3 stores the current term in the series

		VLDR.F32 S4,=2.0

		VMOV.F32 S5,S1		                ;SINX=X

		

LOOP	VMUL.F32 S3,S3,S2					;S3*(-x^2)

		VDIV.F32 S3,S3,S4					;S3/(2n)

		VADD.F32 S4,S4,S6					

		VDIV.F32 S3,S3,S4					;S3/(2n+1)

		VADD.F32 S4,S4,S6
		
		VADD.F32 S5,S5,S3					;S5 stores SIN(X)

		SUB R1,R1,#1						;R1-- 

		CMP R1,#0

		BNE LOOP							;Branch for next Term

		                                    ;S5 = SIN(X) 
		VMOV.F32 R0,S5
		;POP {LR}
		BX lr

		
	ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------
__COSINE FUNCTION							;(INPUT S9=X | OUTPUT S5=COS(X))
	;PUSH {LR}
START2	VLDR.F32 S7,=3.141592654

		VLDR.F32 S8,=180.0

		VLDR.F32 S6,=1.0

		MOV R1,#20         					;NUMBER OF TERMS IN COMPUTATION

		

		VMUL.F32 S1,S9,S7

		VDIV.F32 S1,S1,S8					;x=PI*(theta)/180

		VMUL.F32 S2,S1,S1					;x^2

		VNEG.F32 S2,S2						;-x^2
		
		VLDR.F32 S1,=1.0

		VMOV.F32 S3,S1						;S3 stores the current term in the series

		VLDR.F32 S4,=1.0

		VMOV.F32 S5,S1		                ;COSX=1

		

LOOP2	VMUL.F32 S3,S3,S2					;S3*(-x^2)

		VDIV.F32 S3,S3,S4					;S3/(2n-1)

		VADD.F32 S4,S4,S6					

		VDIV.F32 S3,S3,S4					;S3/(2n)

		VADD.F32 S4,S4,S6					

		VADD.F32 S5,S5,S3					;S5 stores cos(X)

		
		SUB R1,R1,#1						;R1-- 

		CMP R1,#0

		BNE LOOP2							;Branch for next Term

		                                    ;S5 = COS(X) 
	; POP {LR}
		
		BX lr

		
	ENDFUNC	
;---------------------------------------------------------------------------------------------------------------------------------------------------	
__DRAWCIRC FUNCTION							;(DRAWS CIRCLE takes S22=radius S26=CENTRE X COORDINATE ,S27 = CENTER Y COORDINATE )
		VMOV.F32 S17,LR
		VLDR.F32 S20,=1.0	
		VLDR.F32 S21,=90.0
		VLDR.F32 S9,=0.0 					;ITERATES FROM 0->359 DEGREES
		VADD.F32 S9,S9,S28
		VADD.F32 S21,S21,S28
ANLOP	;VMOV.F32 R0,S9
		;BL printMsg		
		;BL printComma
		BL __SINE							;ANGLE IS READ FROM S9 AND SIN (S9) IS STORED IN S5 AFTER THE OPERATION
		VMUL.F32 S5,S5,S22					;S5=RADIUS*SIN (ANGLE)
		VADD.F32 S5,S5,S27					;S5= CENTER_Y(S27) + RADIUS*SIN (ANGLE)
		VMOV.F32 R0,S5
		BL printMsg		
		BL printComma
		BL __COSINE							;ANGLE IS READ FROM S9 AND COSIN (S9) IS STORED IN S5 AFTER THE OPERATION
		VMUL.F32 S5,S5,S22					;S5=  RADIUS* COS(ANGLE)
		VADD.F32 S5,S5,S26					;S5= CENTER_Y(S27) + RADIUS* COS(ANGLE)
		VMOV.F32 R0,S5
		BL printMsg
		BL printNextl
		VADD.F32 S9,S9,S20
		VCMP.F32 S9,S21						;COMPARE AND REPEAT THE OPERATION TILL ANGLE REACHES 360 DEGREES
		VMRS APSR_nzcv, FPSCR
		BNE ANLOP
		
		VMOV.F32 LR,S17
		BX lr
		
		ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------
		
__main  FUNCTION

		
		VLDR.F32 s22,=10.0				;radius
		;VMOV.F32 R0,S22
		VLDR.F32 S26,=20.0				;X
		;VMOV.F32 R1,S26
		VLDR.F32 S27,=30.0				;Y
		;VMOV.F32 R2,S27
		VLDR.F32 S28,=0					;OFFSET
		;VMOV.F32 R3,S28
		VLDR.F32 S29,=5
		;BL printMessage
		BL __DRAWCIRC					;DRAWINF CIRCLE OF RADIUS 100 AND CENTERED AR (320,240)
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				;DRAWINF CIRCLE OF RADIUS 100 AND CENTERED AR (320,240)
		BL __DRAWCIRC					;DRAWINF CIRCLE OF RADIUS 100 AND CENTERED AR (320,240)
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWCIRC					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWCIRC					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		;------------------
		VLDR.F32 S28,=0					;second circle
		VADD.F32 S22,S22,S29	
		VLDR.F32 s22,=5.0				;radius
		;VMOV.F32 R0,S22
		VLDR.F32 S26,=100.0				;X
		;VMOV.F32 R1,S26
		VLDR.F32 S27,=157.0				;Y
		;VMOV.F32 R2,S27
		VLDR.F32 S28,=0					;OFFSET
		;VMOV.F32 R3,S28
		VLDR.F32 S29,=2.5
		;BL printMessage	
		BL __DRAWCIRC					;first circle
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWCIRC					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWCIRC					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWCIRC
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWCIRC					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		
		BL __DRAWCIRC		
stop    B stop                              ; stop program

     ENDFUNC
	 END
	