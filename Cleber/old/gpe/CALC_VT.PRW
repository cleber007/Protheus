#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"

/*/
//|--------------------------------------------------------------|
//| Programa  | CALC_VT()                                        |
//| Autor     | Cleber Paiva                                     |
//| Data      | 15/02/2022                                       | 
//|--------------------------------------------------------------|
//| Descricao | Programa Especifico CALCULO VT                   |
//|--------------------------------------------------------------|
/*/

USER FUNCTION CALC_VT()

LOCAL i 		 := 0
LOCAL _nPerc     := 0
LOCAL _nVbDesc   := 0
LOCAL _nVbTotPD  := 0
LOCAL _nVbProv1  := 0
LOCAL _nVbProv2  := 0
LOCAL _nVbTotPD2 := 0
LOCAL _nVbTotPD3 := 0


For i := 1 to Len(aPd)

    //**** CRIA O EVENTO B75 VALOR PAGO AO FUNCIONARIO DE VT****
	If aPd[i,1] $ "750" 	
            _nVbProv1    :=  ABS( fBuscaPD("750") )
            _nVbProv2    :=  ABS( fBuscaPD("A96") )
            _nVbProv3    :=  ABS( fBuscaPD("051","H") ) 
            _nVbTotPD2   := _nVbProv2 +_nVbProv1
        //**** GERA A VERBA 750 ****
        FGeraVerba("B75",_nVbTotPD2,1,"01",SRA->RA_CC,"V","I",Nil,Nil,,.F.,)
		
	EndIf

Next

For i := 1 to Len(aPd)

    //**** ATUALIZAR A VERBA 750 CASO EXISTA A VERBA B75 ****
	If aPd[i,1] $ "B75" 
	
        _nPerc          :=Posicione("SRV",1,xFilial("SRV")+"750", "RV_PERC" )   // Busca o percentual no cadastro de sindicato (RCE)
        _valor          := ABS((SRA->RA_SALARIO /30) * _nVbProv3 )
        _nPerc 	        := _nPerc / 100 			                                // Atualiza o Percentual para calculo
        _nVbDesc        := ABS( (fBuscaPD("010")+_valor )  * _nPerc )

        IF ( _nVbDesc >= aPd[i,5] )
            _nVbTotPD   := aPd[i,5]
        Else
            _nVbTotPD   := _nVbDesc
        Endif

        //**** GERA A VERBA 750 ****
        FdelPd("750")
        FGeraVerba("750",_nVbTotPD,1,"01",SRA->RA_CC,"V","I",Nil,Nil,,.F.,)
		
	EndIf

Next

For i := 1 to Len(aPd)

    //**** ATUALIZAR A VERBA A96 CASO EXISTA A VERBA B75 ****
	If aPd[i,1] $ "B75" 
	
            _nVbProv1    :=  ABS( fBuscaPD("750") )
            _nVbProv2    :=  ABS( fBuscaPD("B75") )
            _nVbTotPD2   := _nVbProv2 -_nVbProv1
            
        IF ( _nVbTotPD2 >= 0 )
            _nVbTotPD3   := _nVbTotPD2
        Else
            _nVbTotPD3   := 0
        Endif


        //**** GERA A VERBA 750 ****
        FdelPd("A96")
        FGeraVerba("A96",_nVbTotPD3,1,"01",SRA->RA_CC,"V","I",Nil,Nil,,.F.,)
		
	EndIf

Next

RETURN
