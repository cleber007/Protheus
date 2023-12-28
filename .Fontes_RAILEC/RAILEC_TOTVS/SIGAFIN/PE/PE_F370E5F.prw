#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F370E5F  � Autor � FABIO YOSHIOKA      � Data �  09/10/18   ���
�������������������������������������������������������������������������͹��
���Descricao � ROTINA PARA COMPLEMENTO DE FILTRO NOS DADOS DO SE2 DURANTE ���
���          � A CONTABILIZACAO OFF-LINE DO FINANCEIRO (FINA370.PRX)      ���
�������������������������������������������������������������������������͹��
���Uso       � PROTHEUS12 - SIGAFIN                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

user function F370E5F() //09/10/18 - F�bio Yoshioka - Chamado 19755
	Local _cAntQry:=iif(Type("cQuery")<> "C","",cQuery) 
	Local cFor := ""
	
	if Type("_lCtbGPE") <> "L" 
		Public _lCtbGPE:=IIF(MsgYesNo("Deseja contabilizar somente os titulos da Folha (Prefixo=GPE)?","Atencao"),.T.,.F.)
	endif
	
	If _lCtbGPE 
		cFor := " AND E5_PREFIXO = 'GPE' " //09/10/18
	ENDIF
	
	_cAntQry:=_cAntQry+cFor
	CONOUT(dTOC(DATE())+Time()+ "- F370E5F :"+_cAntQry)

Return (_cAntQry)

