#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � BBANCO � Autor � Solon Silva SigaCorp�     Data � 11.07.12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca o campo Banco (A2_BANCO) do Favorecido para          ���
���          � a rotina do ITAU CNAB.                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �                                             				  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                         	  ���
���          �                                                      	  ���
���          �                       									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                   									 	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BBANCO(bbCodigo, bbLoja)
Local cBanco    := ""
Local aAreaTRB := GetArea()
Local _cCNABCGC:="" //26/04/18 - Fabio Yoshioka - Tratamento para demanda 1.01.05.01.10 - CNPJ matriz e filial - c/c da matriz
Local _aDad240:={} //26/04/18

//cQry := " SELECT A2_BANCO cBanco "
cQry := " SELECT A2_BANCO cBanco,A2_CGCCNAB " //26/04/18
cQry += " FROM " +RetSqlName("SA2")
cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
cQry += " AND A2_COD  =  '"+bbCodigo+"'"
cQry += " AND A2_LOJA =  '"+bbLoja+"'"

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

cBanco := Qry->cBanco
_cCNABCGC:= Qry->A2_CGCCNAB //26/04/18

DbCloseArea("QRY")

//26/04/18
if !Empty(alltrim(_cCNABCGC))
	_aDad240 := GetAdvFVal("SA2",{"A2_BANCO"},xFilial("SA2")+_cCNABCGC,3)
	
	if len(_aDad240)>0
		cBanco:=_aDad240[1]
	endif
endif


RestArea(aAreaTRB)
Return cBanco


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � BNOME � Autor � Solon Silva SigaCorp�      Data � 11.07.12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca o campo Nome (A2_NOME) do Favorecido para            ���
���          � a rotina do ITAU CNAB.                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �                                             				  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                         	  ���
���          �                                                      	  ���
���          �                       									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                   									 	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BNOME(bnCodigo, bnLoja)
Local cNome    := ""
Local aAreaTRB := GetArea()
Local _cCNABCGC:="" //26/04/18 - Fabio Yoshioka - Tratamento para demanda 1.01.05.01.10 - CNPJ matriz e filial - c/c da matriz
Local _aDad240:={} //26/04/18


//cQry := " SELECT A2_NOME cNome "
cQry := " SELECT A2_NOME cNome,A2_CGCCNAB " //26/04/18
cQry += " FROM " +RetSqlName("SA2")
cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
cQry += " AND A2_COD  =  '"+bnCodigo+"'"
cQry += " AND A2_LOJA =  '"+bnLoja+"'"

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

cNome := SUBSTR(Qry->cNome,1,30)
_cCNABCGC:=Qry->A2_CGCCNAB //26/04/18

DbCloseArea("QRY")

//26/04/18
if !Empty(alltrim(_cCNABCGC))
	_aDad240 := GetAdvFVal("SA2",{"A2_NOME"},xFilial("SA2")+_cCNABCGC,3)
	
	if len(_aDad240)>0
		cNome:= SUBSTR(_aDad240[1],1,30)
	endif
endif

RestArea(aAreaTRB)
Return cNome

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � BINSC � Autor � Solon Silva SigaCorp�      Data � 11.07.12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca o campo CNPJ/CPF (A2_CGC) do Favorecido para         ���
���          � a rotina do ITAU CNAB.                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �                                             				  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                         	  ���
���          �                                                      	  ���
���          �                       									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                   									 	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BINSC(biCodigo, biLoja)
Local cInsc    := ""
Local aAreaTRB := GetArea()
Local _cCNABCGC:="" //26/04/18 - Fabio Yoshioka - Tratamento para demanda 1.01.05.01.10 - CNPJ matriz e filial - c/c da matriz
Local _aDad240:={} //26/04/18


//cQry := " SELECT A2_CGC cInsc "
cQry := " SELECT A2_CGC cInsc,A2_CGCCNAB " //26/04/18
cQry += " FROM " +RetSqlName("SA2")
cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
cQry += " AND A2_COD  =  '"+biCodigo+"'"
cQry += " AND A2_LOJA =  '"+biLoja+"'"

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

cInsc := Qry->cInsc
_cCNABCGC:=Qry->A2_CGCCNAB

DbCloseArea("QRY")

//26/04/18
if !Empty(alltrim(_cCNABCGC))
	_aDad240 := GetAdvFVal("SA2",{"A2_CGC"},xFilial("SA2")+_cCNABCGC,3)
	
	if len(_aDad240)>0
		cInsc:= _aDad240[1]
	endif
endif


RestArea(aAreaTRB)
Return cInsc    


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  SISPAG_01 �Autor  Denis Tsuchiya       � Data �  09/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Para o preenchimento de Agencia e Conta para o pagamento    ���
���          � de Fornecedores pelo SISPAG                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SISPAG_01()
   
//Para preenchimento do arquivo de transmissao SISPAG
//com a Agencia + Conta + Dig Conta de acordo com o layout do SISPAG ITAU   
//Posi��o de 24 a 43 no layout SISPAG
                  

Local _cBanco	:= SA2->A2_BANCO
Local _cAgencia	:= SA2->A2_AGENCIA
Local _cConta	:= SA2->A2_NUMCON
Local _cDigCon	:= SA2->A2_DIGCONT
Local _cAGCC 	:= ""
Local __aArea 	:= GetArea()


DbselectArea("SA2")
_cBanco		:= SA2->A2_BANCO
_cAgencia	:= SA2->A2_AGENCIA
_cConta		:= SA2->A2_NUMCON
_cDigCon	:= SA2->A2_DIGCONT
_cAGCC 		:= ""

//        AAAAA+" "+"00"+"AAAAAAAAAA"+" "+D
		  	
//

/*
Implementa��o adcional - Fabio Yoshioka - chamado 17459 (analise do problema)
a) Quando o banco favorecido for 341 (Banco Ita�) ou 409 (Unibanco) este campo dever� ser preenchido da
seguinte forma:
Nome do Campo 	Significado 					Posi��o 	Picture 	Conte�do
ZEROS 			COMPLEMENTO DE REGISTRO	 		024 024 	9(01)
AG�NCIA 		N�MERO AG�NCIA CREDITADA 		025 028 	9(04)
BRANCOS 		COMPLEMENTO DE REGISTRO 		029 029 	x(01)
ZEROS 			COMPLEMENTO DE REGISTRO 		030 035 	9(06)
CONTA 			N�MERO DE C/C CREDITADA 		036 041 	9(06)
BRANCOS 		COMPLEMENTO DE REGISTRO 		042 042 	X(01)
DAC 			DAC DA AG�NCIA/CONTA CREDITADA 	043 043 	9(01)

Os campos Conta e DAC devem ser preenchidos com zeros quando a forma de pagamento for 02 ou 10
(cheque ou Ordem de Pagamento), porque neste caso a OP ou o cheque ficar�o � disposi��o do favorecido
na ag�ncia indicada.


b)Quando o banco favorecido n�o for 341 ou 409 (portanto as formas de pagamento s�o 03-DOC C, 07-
DOC D, 41-TED/outro titular e 43-TED/mesmo titular) os campos dever�o ser preenchidos da seguinte forma:
Nome do Campo Significado 						Posi��o 	Picture 	Conte�do
Ag�ncia 		N�mero ag�ncia CREDITADA 		024 028 	9(05)
brancos 		Complemento de registro 		029 029 	X(01)
Conta 			N�mero de C/C CREDITADA 		030 041 	9(12)
brancos 		Complemento de registro 		042 042 	X(01)
DAC 			DAC DA AG�NCIA/Conta CREDITADA 	043 043 	X(01)

Observa��es:
Preencher os campos com zeros � esquerda;
N�o coloque o DAC da ag�ncia no campo "AG�NCIA". Isto poder� acarretar envio do DOC ou da TED
para local indevido;
Se o DAC tiver dois caracteres, coloque o primeiro na posi��o 042 e o segundo na posi��o 043.

*/

_cAGCC := strzero(val(_cAgencia),5)+ space(1)+strzero(val(_cConta),12)+ space(1)+substr(_cDigCon,1,1) //20/07/18 - Fabio Yoshioka


//_cAGCC := SUBSTR(_cAgencia,1,5)+" "+"00"+_cConta+" "+_cDigCon

if _cBanco $ '341/409' //19/07/18 - Fabio Yoshioka
	if RTRIM(SEA->EA_TIPOPAG) $'02/10'
		_cDigCon:='0'
		_cConta :='0'
	ENDIF
	_cAGCC := '0'+STRZERO(VAL(_cAgencia),4)+SPACE(1)+'000000'+STRZERO(VAL(_cConta),6)+SPACE(1)+ substr(_cDigCon,1,1)	
endif
RestArea(__aArea)


Return(_cAGCC)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ITAUCNAB  �Autor  �Microsiga           � Data �  08/03/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NUMBene()


Return()