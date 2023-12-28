#include 'protheus.ch'
#include 'parmtype.ch'

user function F300FLT()
Local _l300FLT:=.T.
Local _aAreaSE5 := SE5->(GetArea())

if Type("_aDadPA300") <> "A"
	Public _aDadPA300:={}
endif


If Alltrim(SE2->E2_TIPO) == "PA" //17/09/18 - Fabio Yoshioka - Contabilização de PA no Retorno do SISPAG
	_lBxSISPA:=GetMV("AL_BXSISPA")//17/09/18 - Habilita  a contabilização do PA via retorno SISPAG 
	IF _lBxSISPA
		DBSelectArea("SE5")
		SE5->(DBSETORDER(7)) //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO      
		CONOUT(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA) 
		If !SE5->(DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
			aadd(_aDadPA300,SE2->(RECNO()))
		ENDIF   
	ENDIF
Endif

RestArea(_aAreaSE5)
	
return _l300FLT