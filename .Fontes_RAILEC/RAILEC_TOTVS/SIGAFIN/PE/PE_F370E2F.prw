#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F370E2F  � Autor � SOLON DE DEUS      � Data �  05/04/18    ���
�������������������������������������������������������������������������͹��
���Descricao � ROTINA PARA COMPLEMENTO DE FILTRO NOS DADOS DO SE2 DURANTE ���
���          � A CONTABILIZACAO OFF-LINE DO FINANCEIRO (FINA370.PRX)      ���
�������������������������������������������������������������������������͹��
���Uso       � PROTHEUS12 - SIGAFIN                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F370E2F()
	Local _cAntQry:=iif(Type("cQuery")<> "C","",cQuery) //09/10/18 - F�bio Yoshioka - Chamado 19755
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

