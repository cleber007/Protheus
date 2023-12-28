#include "rwmake.ch"

/*/
Atualiza o campo de relacionamento da nota de conhecimento de transporte (frete)
na nota fiscal de venda (sf2) para emissao do relatorio das notas pendentes de
lancamento dos fretes
/*/

/*
SOLON DE DEUS - SIGACORP - 30/08/2017
ATENÇÃO: VOLTEI COM O FONTE ORIGINAL DO DIA 05/07/17 POIS NESTE CONTEM A RETIRADA DA OBRIGATORIEDADE DE TODA A ALUBAR ENERGIA JÁ VALIDADO PELO SR. ARIO CAVALCANTE.
PARA MAIORES DETALHES VER O EMAIL DO SR. ARIO CAVALCANTE DO DIA 30/08/2017 AS 12:44HS COM O TITULO RES:RES:OBRIGATORIEDADE TELA CTE.
*/

User Function SF1100I()
Local cNotaIni,cNotaFim,cSerIni,cSerFim,cVariav,cFornIni,cFornFim,cLojaIni,cLojaFim,cNomArq,lExiste,cNotaFiscal,cSerieNota,cFornece
Local cArea:=GetArea()

//Alert(cEmpAnt)

//IF (cEmpAnt $ '01/03' .AND. cFilAnt <> '04') //SOLON.SIGACORP EM 05/07/2017 OBJETIVO: RETIRAR OBRIGATORIEDADE PARA ALUBAR ENERGIA BAHIA
IF (cEmpAnt $ '06' ) //SOLON.SIGACORP EM 05/07/2017 OBJETIVO: RETIRAR OBRIGATORIEDADE PARA TODA A ALUBAR ENERGIA
//If (cEmpAnt = '03' .AND. cFilAnt = '02')       //CLAUDIO.SIGACORP EM 02/04/15

//	ALERT("A NOTA/SERIE não necessita ser informada para ESTA FILIAL - MEDIDA TEMPORARIA !")//CLAUDIO.SIGACORP EM 02/04/15

//ELSE
//Sólon SigaCorp - 25.05.12 - Inclusão da string CTE dentro da condicional.
	If ALLTrim(SF1->F1_ESPECIE)$"CTR/CTF/CTA/CA/CTE" .AND. SF1->F1_TIPO="N"
		cNotaFiscal := SD1->D1_DOC
		cSerieNota  := SD1->D1_SERIE
		cFornece    := SD1->D1_FORNECE
		
		_PEDENOTA:=.T.
		WHILE _PEDENOTA
			_NOTA:=SPACE(9)
			_SERI:=SPACE(3)
			@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Nota de Saida"
			@ 10, 20 SAY "Nota/Serie de Saida que Originou o Frete....(Obrigat)"
			@ 25, 49 GET _NOTA  SIZE 25,12 VALID NAOVAZIO() //F3 "SF2"
			@ 40, 49 GET _SERI  SIZE 15,12 VALID NAOVAZIO()
			@ 60, 95 BmpButton Type 1 Action Close(oDlg2)
			Activate Dialog oDlg2 Centered
			
			DBSELECTAREA("SF2")
			DBSETORDER(1)
			DBSEEK(xFilial("SF2")+_NOTA+_SERI)
			IF FOUND()
				RECLOCK("SF2",.F.)
				Replace F2_NFRETE With cNotaFiscal
				Replace F2_SFRETE wITH cSerieNota
				Replace F2_TRANSP With cFornece
				MSUNLOCK()
				_PEDENOTA:=.F.
			ELSE
				ALERT("NOTA/SERIE DE SAIDA NAO ENCONTRADA !!!")
			ENDIF
		ENDDO
	EndIf
//Endif
endif
RestArea(cArea)
Return




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CAD_SB2()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Cadastro DE EMPENHOS
// AUTOR : JOSE NORBERTO MACEDO
// DATA  : 22/08/2012
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
_cArea := Alias()
_nOrd  := IndexOrd()
nReg   := RecNo()

DbSelectArea("SB2")
SB2->(DbSetOrder(1))
SB2->(DbGotop())
cCadastro :="SB2 - Cadastro de Empenhos"
aRotina   := {{ "Pesquisa ",  'AxPesqui' , 0, 1 },;
{ "Visualiza",  'AxVisual' , 0, 2 },;
{ "Manutenc.",  'U_MANUT2' , 0, 3 }}
MBrowse(16,00,280,350,"SB2",,)
DbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(nReg)
Return Nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MANUT2()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//novo codigo
Local cUsuarioLoga, cUsuarioAuto 

cUsuarioLoga    := __cUSERID
cUsuarioAuto := GetMV("AL_ESTINDS")

If  cUsuarioLoga $ cUsuarioAuto
    MSGINFO("Usuário Autorizado !!!")                                          
  Else
   MSGSTOP("Você NÃO está autorizado a realizar esta operação." +chr(13)+chr(10)+"Suporte: Verificar o Parâmetro AL_ESTINDS") 
 RETURN Nil
EndIf
//até aqui

/* Retirada codigo abaixo pois não contempla usuarios do tipo Fabio Junior. Trecho substituido pelo codigo acima. Conforme
 //pedido do Sr. Marcus Platão e autorizado pelo Sr. Ewerton Carreira (TIC-Alubar)
 
_USU:=UPPER(SUBSTR(CUSUARIO,7,15))
IF LEFT(_USU,6)<>"MACEDO" .AND. LEFT(_USU,6)<>"JOSE.T" .AND. LEFT(_USU,6)<>"ADMINI" .AND. LEFT(_USU,6)<>"VALDOI"
	ALERT(ALLTRIM(_USU)+" nao possui acesso a esta opcao...")
	RETURN Nil
ENDIF
*/

_SALDO:=B2_QEMPPRJ
_DESCPR:=POSICIONE("SB1",1,XFILIAL("SB1")+SB2->B2_COD,"B1_DESC")
_ANTER:=B2_QATU

@ 1,1 to  200,600 DIALOG oJan2 TITLE "Empenhado"
@  15,  20 SAY "Data Base : "+DTOC(DDATABASE)
@  25,  20 SAY "Produto   : "+_DESCPR
@  35,  20 SAY "Saldo     : "
@  35,  75 GET _ANTER PICTURE "@E 999,999,999.99" SIZE 55,12 WHEN .F.
@  45,  20 SAY ". Indisp  "
@  45,  75 GET _SALDO PICTURE "@E 999,999,999.99" SIZE 55,12

@ 85, 218 BMPBUTTON TYPE 1 ACTION  Close(oJan2)   // CONFIRMA
ACTIVATE DIALOG oJan2

IF _SALDO # B2_QEMPPRJ
	RECLOCK("SB2",.F.)
	SB2->B2_QEMPPRJ:=_SALDO
	MSUNLOCK()
ENDIF
DBSELECTAREA("SB2")
RETURN




/*
lExiste := .F.
cNomArq := Upper(SubStr(cUserName,1,3))+SM0->M0_CODIGO+SM0->M0_CODFIL
If !File(cNomArq+".DBF")
Return
EndIf
Use &cNomArq Alias TRB New
DbSelectArea("TRB")
DbGoTop()
While !EoF()
If TB_MARCA == "XX"
DbSelectArea("SF2")
DbSetOrder(1)
DbSeek(xFilial("SF2")+TRB->TB_NOTA+TRB->TB_SERIE+TRB->TB_FORNECE+TRB->TB_LOJA,.t.)
RecLock("SF2",.F.)
If Empty(F2_NFRETE+F2_SFRETE)
Replace F2_NFRETE With cNotaFiscal
Replace F2_SFRETE wITH cSerieNota
Replace F2_TRANSP With cFornece
Else
Replace F2_RDFRETE With cNotaFiscal
Replace F2_RDSERIE With cSerieNota
Replace F2_REDESP  With cFornece
EndIF
MsUnLock()
EndIf
DbSelectArea("TRB")
DbSkip()
EndDo
DbCloseArea()
EndIf
RestArea(cArea)
Return
