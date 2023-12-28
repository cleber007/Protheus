#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"

/*/
//|--------------------------------------------------------------|
//| Programa  | CAL_HE0101()                                     |
//| Autor     | Cleber Paiva                                     |
//| Data      | 15/02/2022                                       | 
//|--------------------------------------------------------------|
//| Descricao | Programa Especifico Calcula de Variaveis         |
  |             Desconto de ISS Auronomo                         |
//|--------------------------------------------------------------|
/*/

USER FUNCTION Desc_ISS()

LOCAL i 		:= 0
LOCAL _nPerc    := 0
LOCAL _nVbAur  := 0


For i := 1 to Len(aPd)

    //**** Desconto do ISS****
	If aPd[i,1] $ "121" .AND. SRA->RA_PROCESS ="00003" 
	
        _nPerc      := Posicione("SRV",1,xFilial("SRV")+aPd[i,1], "RV_PERC" )   // Busca o percentual no cadastro de verba (SRV)
        _nPerc 	    := _nPerc / 100 	
        _nVbAur    := fBuscaPD("121")  		                                // Atualiza o Percentual para calculo
    
                 
             
             aPd[i,5]    := Round(((_nVbAur)*_nPerc) ,2 )                  
        
       

	EndIf

   
Next

RETURN
