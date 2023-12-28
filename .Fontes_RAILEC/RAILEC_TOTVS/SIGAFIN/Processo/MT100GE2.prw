#Include "rwmake.ch"

User Function MT100GE2()
Local aAreaSD1 := GetArea("SD1")//RAFAEL ALMEIDA - SIGACORP (22/05/2016)
Local _lVldAtvCC := .F.
Local _lAtuDtPgto:= IIF(UPPER(RTRIM(GETMV("AL_ATDTPGT")))=='S',.T.,.F.) //Fabio Yoshioka - atendimento da Demanda - 1.01.05.01.15 - Ajuste da data de pagamento (CNAB) E2_DTPGSIS 

_cArea := Alias()
_nOrd  := IndexOrd()
nReg   :=RecNo()

cPrefix := SE2->E2_PREFIXO
cNumero := SE2->E2_NUM
cParcel := SE2->E2_PARCELA
cTipo := SE2->E2_TIPO 
cFornece := SE2->E2_FORNECE
cLoja := SE2->E2_LOJA     

cNome   := SE2->E2_NOMFOR
_INSS   := SE2->E2_INSS
cparcir := se2->e2_parcir
cparccof:= se2->e2_parccof
cparcpis:= se2->e2_parcpis
cparcsll:= se2->e2_parcsll
cparcins:= se2->e2_parcins

//alteração SIGACORP(Solon Silva) 19.07.11 - 15:09hs.
dE2_Vencto := SE2->E2_VENCREA
if _lAtuDtPgto //03/05/18 - Fabio Yoshioka
	REPLACE SE2->E2_DTPGSIS WITH dE2_Vencto
endif

//Comando inserido por Denis Haruo 11/02/2014
//Para gravar a data real da digitação caso o usuario mude a data base do sistema.
//Solicitado por Adriana para o controle de alçadas
REPLACE SE2->E2_DIGIREA WITH DaTe()

//até aqui
//alteração SIGACORP(Solon Silva) 07.06.11 - 15:21hs.
//dE2_Vencto := DataValida(SE2->E2_VENCTO,.T.)
//REPLACE SE2->E2_DTPGSIS WITH dE2_Vencto
//até aqui
DBSELECTAREA("SE2")
DBSETORDER(1)
dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCIR+"TX")
IF FOUND()
      RecLock("SE2",.F.)
      SE2->E2_HIST := 'IRRF - '+cNome
      MsUnLock()
      DbSkip()
ENDIF
dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCCOF+"TX")
IF FOUND()
      RecLock("SE2",.F.)
      SE2->E2_HIST := 'COFINS - '+cNome
      MsUnLock()
      DbSkip()
ENDIF
dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCPIS+"TX")
IF FOUND()
      RecLock("SE2",.F.)
      SE2->E2_HIST := 'PIS - '+cNome
      MsUnLock()
      DbSkip()
ENDIF
dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCSLL+"TX")
IF FOUND()
      RecLock("SE2",.F.)
      SE2->E2_HIST := 'CSLL - '+cNome
      MsUnLock()
      DbSkip()
ENDIF
dbseek(xFilial("SE2")+cPrefix+cNumero+cPARCINS+"INS")
IF FOUND() .AND. E2_VALOR=_INSS
      RecLock("SE2",.F.)
      SE2->E2_HIST := 'INSS - '+cNome
      MsUnLock()
      DbSkip()
ENDIF


DBSELECTAREA(_cArea)
DBSETORDER(_nOrd)
DbGoTo(nReg)

If SM0->M0_CODIGO="03"      // SOMENTE SE EMPRESA ATUAL FOR ALUBAR ENERGIA (03)
	_lVldAtvCC := GETMV("AL_SE2CC")
	If _lVldAtvCC
		SD1->(DbSelectArea("SD1"))
		SD1->(DbSetOrder(1))
		SD1->(DbGotop())
		SD1->(DbSeek(xFilial("SD1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)) )
		
		SE2->(DbSelectArea("SE2"))
		SE2->(dbSetOrder(1))
		SE2->(dbGotop())
		SE2->(dbSeek(xFilial("SE2")+cPrefix+cNumero+cParcel+cTipo+cFornece+cLoja))
		
		SE2->(RecLock("SE2",.F.))
		SE2->E2_CC := SD1->D1_CC // Centro de Custo de Débito
		SE2->(MsUnLock())
		RestArea(aAreaSD1)
	EndIf
EndIf

Return