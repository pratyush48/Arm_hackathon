    PRESERVE8
    AREA appcode,CODE,READONLY
	 AREA     factorial, CODE, READONLY
     IMPORT printMsg
	 IMPORT printNextl
     IMPORT printMessage
	 IMPORT printComma	 
	 EXPORT __main
	 EXPORT __SINTHETA
	 EXPORT __DRAWSPIRAL
	 EXPORT __COSTHETA
		ENTRY 
;---------------------------------------------------------------------------------------------------------------------------------------------------

__SINTHETA FUNCTION			
        VLDR.F32 S1,=90.0
        VMOV.F32 S0,S9
        VCMP.F32 S9,S1
		VMRS APSR_nzcv, FPSCR
		BLT LOOP
        VLDR.F32 S1,=180.0		
		VSUB.F32 S0,S1,S9
        VLDR.F32 S1,=270.0
		VCMP.F32 S9,S1
		VMRS APSR_nzcv, FPSCR
        BLT LOOP
		VLDR.F32 S1,=360.0
        VSUB.F32 S0,S9,S1
LOOP    VLDR.F32 S7,=3.141592654
		VLDR.F32 S8,=180.0
		VLDR.F32 S6,=1.0
		MOV R1,#20         			
		VMUL.F32 S1,S0,S7
		VDIV.F32 S1,S1,S8					
		VMUL.F32 S2,S1,S1					
		VNEG.F32 S2,S2						
		VMOV.F32 S3,S1						
		VLDR.F32 S4,=2.0
		VMOV.F32 S5,S1		                
LOOP1	VMUL.F32 S3,S3,S2					
		VDIV.F32 S3,S3,S4					
		VADD.F32 S4,S4,S6					
		VDIV.F32 S3,S3,S4					
		VADD.F32 S4,S4,S6
		VADD.F32 S5,S5,S3					
		SUB R1,R1,#1						
		CMP R1,#0
		BNE LOOP1									                                
		VMOV.F32 R0,S5
		BX lr
	ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------
__COSTHETA FUNCTION	
LOOP2	VLDR.F32 S8,=3.141592654
		VLDR.F32 S7,=180.0	
		VLDR.F32 S6,=1.0
		MOV R1,#20         					
		VMUL.F32 S2,S9,S8	
		VDIV.F32 S2,S2,S7				
		VMUL.F32 S1,S2,S2				
		VNEG.F32 S1,S1				
		VLDR.F32 S2,=1.0;S1
		VMOV.F32 S3,S2				
		VLDR.F32 S4,=1.0
		VMOV.F32 S5,S2		               
LOOP3	VMUL.F32 S3,S3,S1				
		VDIV.F32 S3,S3,S4				
		VADD.F32 S4,S4,S6					
		VDIV.F32 S3,S3,S4				
		VADD.F32 S4,S4,S6					
		VADD.F32 S5,S5,S3						
		SUB R1,R1,#1						
		CMP R1,#0
		BNE LOOP3							                            		
		BX lr
	ENDFUNC	
;---------------------------------------------------------------------------------------------------------------------------------------------------	
__DRAWSPIRAL FUNCTION							;(DRAWS CIRCLE takes radius,X,Y,OFFSET)
		VMOV.F32 S17,LR						;PUSH{LR}
		VLDR.F32 S20,=1.0	
		VLDR.F32 S21,=90.0
		VLDR.F32 S9,=0.0 					;ITERATES FROM 0->90
		VADD.F32 S9,S9,S28
		VADD.F32 S21,S21,S28
LOOP4	BL __SINTHETA							
		VMUL.F32 S5,S5,S22					;RADIUS*SIN (ANGLE)
		VADD.F32 S5,S5,S27					;Y + RADIUS*SIN (ANGLE)
		VMOV.F32 R0,S5
		BL printMsg		
		BL printComma
		BL __COSTHETA						
		VMUL.F32 S5,S5,S22					;RADIUS* COS(ANGLE)
		VADD.F32 S5,S5,S26					;X + RADIUS* COS(ANGLE)
		VMOV.F32 R0,S5
		BL printMsg
		BL printNextl
		VADD.F32 S9,S9,S20
		VCMP.F32 S9,S21						;COMPARE AND REPEAT THE OPERATION TILL ANGLE REACHES 90 DEGREES
		VMRS APSR_nzcv, FPSCR
		BNE LOOP4
		VMOV.F32 LR,S17						;POP {LR}
		BX lr
		ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------
		
__main  FUNCTION
										;fiest spiral
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
		BL __DRAWSPIRAL				;DRAW SPIRAL
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWSPIRAL					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWSPIRAL					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWSPIRAL					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		;------------------
		VLDR.F32 S28,=0					;second spiral
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
		BL __DRAWSPIRAL					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWSPIRAL					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWSPIRAL					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S26,S26,S29
		VLDR.F32 S28,=180
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VADD.F32 S27,S27,S29
		VLDR.F32 S28,=270
		VADD.F32 S22,S22,S29
		BL __DRAWSPIRAL
		VSUB.F32 S26,S26,S29
		VLDR.F32 S28,=0
		VADD.F32 S22,S22,S29				
		BL __DRAWSPIRAL					
		VSUB.F32 S27,S27,S29
		VLDR.F32 S28,=90
		VADD.F32 S22,S22,S29
		
		BL __DRAWSPIRAL		
stop    B stop                              ; stop program

     ENDFUNC
	 END
	