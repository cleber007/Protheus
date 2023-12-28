#INCLUDE "rwmake.ch"
User Function IDCNAB()
*********************

Processa({|| U_IDCNABR()} )

Return(.t.)

***********************
User Function IDCNABR()

DbSelectArea("SE2")
DbSetOrder(1)  
DbGotop()

x := 0
ProcRegua(RecCount())

Do While !Eof() 
   
   IncProc("Filial "+SE2->E2_FILIAL+" Titulo "+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_PARCELA )  
   
   If Alltrim(SE2->E2_PORTADO) = "001"
      
      x:= x+1
      Reclock("SE2",.f.)
      SE2->E2_IDCNAB := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
      MsUnlock()
   Endif
   
   DbSkip()
Enddo

Alert("O processo terminou e "+StrZero(x,5)+" foram alterados")

Return(.t.)    