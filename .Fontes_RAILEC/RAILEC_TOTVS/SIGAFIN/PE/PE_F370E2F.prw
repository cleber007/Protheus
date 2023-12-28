#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF370E2F  บ Autor ณ SOLON DE DEUS      บ Data ณ  05/04/18    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ ROTINA PARA COMPLEMENTO DE FILTRO NOS DADOS DO SE2 DURANTE บฑฑ
ฑฑบ          ณ A CONTABILIZACAO OFF-LINE DO FINANCEIRO (FINA370.PRX)      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PROTHEUS12 - SIGAFIN                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function F370E2F()
	Local _cAntQry:=iif(Type("cQuery")<> "C","",cQuery) //09/10/18 - Fแbio Yoshioka - Chamado 19755
	Local cFor := ""
	
	if Type("_lCtbGPE") <> "L" 
		Public _lCtbGPE:=IIF(MsgYesNo("Deseja contabilizar somente os titulos da Folha (Prefixo=GPE)?","Atencao"),.T.,.F.)
	endif
	
	//If MsgYesNo("Deseja contabilizar somente os titulos da Folha (Prefixo=GPE)?","Atencao")
	
	IF _lCtbGPE
		//cFor := " E2_PREFIXO == 'GPE' "
		cFor := " AND E2_PREFIXO = 'GPE' " //09/10/18
	EndIf
	
	_cAntQry:=_cAntQry+cFor
	
	CONOUT(dTOC(DATE())+Time()+ "- F370E2F :"+_cAntQry)


//Return (cFor)
Return (_cAntQry)

