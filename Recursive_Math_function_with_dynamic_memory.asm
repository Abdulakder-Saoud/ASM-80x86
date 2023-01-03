SSEG SEGMENT PARA STACK 'STACK'
    DW 1500 DUP(?)
    
SSEG ENDS

DSEG SEGMENT PARA 'DATA'
    N    DW 500
    DRE  DW 3 
    D    DB 0,1,1,500 DUP(?)

DSEG ENDS

CSEG SEGMENT PARA 'CODE'
    ASSUME CS:CSEG,SS:SSEG,DS:DSEG
           
    ANA PROC FAR
        PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX,DSEG
        MOV DS,AX
        
                  
        PUSH N
        
        CALL FAR PTR DNUM ; D(N)     
    
        POP AX    ; SONUC
        CALL PRINTITNT
        RETF
    ANA ENDP
    
    DNUM PROC FAR
        PUSH BP
        PUSH BX ; BXi kaybetmemk icin
        MOV BP,SP
        
        MOV AX,[BP+8]
        CMP AX,[DRE]
        JL  VAR
        
        DEC AX
        PUSH AX
        
        
        CALL FAR PTR DNUM ;D(N-1)
        
        CALL FAR PTR DNUM ;D(D(N-1))
        
        MOV AX,[BP+8]
        SUB AX,2
        PUSH AX
        
        CALL FAR PTR DNUM ;D(N-2)
        
        MOV AX,[BP+8]
        DEC AX
        POP BX
        SUB AX,BX
        PUSH AX
        
        CALL FAR PTR DNUM ;D(N-1-D(N-2))
        POP AX
        POP BX
        ADD AX,BX
        MOV [BP+8],AX
        
        MOV SI,[DRE]
        INC DRE
        MOV D[SI],AL
        JMP SON        
        
        
VAR:    MOV SI,AX
        XOR AX,AX 
        MOV AL,D[SI]
        MOV WORD PTR [BP+8],AX
        JMP SON        


SON:    
        POP BX
        POP BP
        RET 
    DNUM ENDP
    
    PRINTITNT PROC NEAR
        PUSH BX
        PUSH DX
        
        
        MOV BX,10
        PUSH BX
        
AGAIN:        
        XOR DX,DX
        DIV BX
        ADD DX,48  ; 0 ACSI CODE
        PUSH DX
        CMP AX,0
        JNE AGAIN
ILK:        
        POP DX
        CMP DX,10
        JE SONP
        MOV AH,02h
        INT 21H
        JMP ILK
SONP:    
        POP DX
        POP BX
        RET
    
    PRINTITNT ENDP
        
   
CSEG ENDS
    END ANA