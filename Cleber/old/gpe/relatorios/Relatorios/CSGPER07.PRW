#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#define CRLF Chr(13)+Chr(10)

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSGPER07

Relacao de funcionarios

@author Luciano Pereira Camargo
@since 02/09/2016
@version 1.0
@obs O fonte ja existia, apenas padronizei o nome de GPE001.prw para CSGPER07.prw e coloquei o ProtheusDoc

/*/
//------------------------------------------------------------------------------------------

User Function CSGPER07

Local aOrd := {}
Local cDesc1         := "RELACAO DE FUNCIONARIOS"
Local cDesc2         := ""
Local cDesc3         := "RELACAO DE FUNCIONARIOS"
Local cPict          := ""
Local nLin           := 80
Local Cabec1         := "Matricula  Nome do Funcionario                              Admissao   Demissao  Funcao                      Situacao"
Local Cabec2         := ""
//                       1234567890 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999 999.999 999.999        999.999 999.999 999.999        999.999 999.999 999.999        999.999 999.999 999.999
//                       12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         						  1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
Local imprime        := .T.

Private cString
Private CbTxt        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "CSGPER07" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "CSGPER07"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CSGPER07" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)

ValidPerg()
If !pergunte(cPerg,.T.)
	Return()
Endif

titulo         := "RELACAO DE FUNCIONARIOS "
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

//*****************************************************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cCompara := cCompForn := ""
Local cQry     := ""
Local lImp1    := lImp2    := lImp3    := .F.
Local lFirst   := .T.
Local nPos := 0
Local aPedCom := {}
Local aPedPro := {}
_ntot02 := 0
_ntot03 := 0
_ntot04 := 0
_ntot05 := 0
_ntot06 := 0
_ntot07 := 0
_ntot08 := 0
_ntot09 := 0
_ntot10 := 0
_ntot11 := 0
_ntot12 := 0
_ntot13 := 0
_ntotger := 0
_ntotFor := 0
_xfil1 := ""

SC7->(DbSetOrder(1)) // Filial+Código+Loja

cQry := " SELECT RA_MAT, RA_NOME, RA_ADMISSA, RA_DEMISSA, RA_CODFUNC, RJ_DESC, RA_SITFOLH "
cQry += " FROM "+ RETSQLNAME ("SRA") +"  SRA, "+ RETSQLNAME ("SRJ") +"  SRJ "
cQry += " WHERE SRA.D_E_L_E_T_ = ' ' "
cQry += " AND SRA.RA_ADMISSA BETWEEN '"+Dtos(mv_par03)+"' and '"+Dtos(mv_par04)+"' "
cQry += " AND SRA.RA_CODFUNC BETWEEN '"+mv_par05+"' and '"+mv_par06+"' "
cQry += " AND SRA.RA_CODFUNC = SRJ.RJ_FUNCAO "
cQry += " ORDER BY RA_NOME "

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), 'TMP', .F., .T.)

cQry := " SELECT RA_MAT, RA_NOME, RA_ADMISSA, RA_DEMISSA, RA_CODFUNC, RJ_DESC, RA_SITFOLH "
cQry += " FROM "+ RETSQLNAME ("SRA") +"  SRA, "+ RETSQLNAME ("SRJ") +"  SRJ "
cQry += " WHERE SRA.D_E_L_E_T_ = ' ' "
cQry += " AND SRA.RA_DEMISSA BETWEEN '"+Dtos(mv_par03)+"' and '"+Dtos(mv_par04)+"' "
cQry += " AND SRA.RA_CODFUNC BETWEEN '"+mv_par05+"' and '"+mv_par06+"' "
cQry += " AND SRA.RA_CODFUNC = SRJ.RJ_FUNCAO "
cQry += " ORDER BY RA_NOME "

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), 'TMP2', .F., .T.)

SetRegua(TMP->( LastRec() ) , Titulo )

DbSelectarea("TMP")
TMP->(DbGoTop())
Do While TMP->(!EOF())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,nomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	
	@nLin,000   PSAY TMP->RA_MAT
	@nLin,008	PSAY TMP->RA_NOME
	@nLin,060	PSAY SUBS(TMP->RA_ADMISSA,7,2)+"/"+SUBS(TMP->RA_ADMISSA,5,2)+"/"+SUBS(TMP->RA_ADMISSA,3,2)
	@nLin,070	PSAY SUBS(TMP->RA_DEMISSA,7,2)+"/"+SUBS(TMP->RA_DEMISSA,5,2)+"/"+SUBS(TMP->RA_DEMISSA,3,2)
	@nLin,080	PSAY TMP->RA_CODFUNC+"-"+TMP->RJ_DESC
	IF EMPTY(TMP->RA_SITFOLH)
		@nLin,110	PSAY "NORMAL"
	ELSEIF TMP->RA_SITFOLH == "A"
		@nLin,110	PSAY "AFASTADO"
	ELSEIF TMP->RA_SITFOLH == "D"
		@nLin,110	PSAY "DEMITIDO"
	ELSEIF TMP->RA_SITFOLH == "F"
		@nLin,110	PSAY "FERIAS"
	ELSEIF TMP->RA_SITFOLH == "T"
		@nLin,110	PSAY "TRANSFERIDO"
	ENDIF
		
	
	nLin := nLin+1
	
	TMP->(DbSkip(+1))
Enddo

	nLin := nLin+1

DbSelectarea("TMP2")
TMP2->(DbGoTop())
Do While TMP2->(!EOF())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,nomeProg,Tamanho,nTipo)
		nLin := 08
	Endif

	
	@nLin,000   PSAY TMP2->RA_MAT
	@nLin,008	PSAY TMP2->RA_NOME
	@nLin,060	PSAY SUBS(TMP2->RA_ADMISSA,7,2)+"/"+SUBS(TMP2->RA_ADMISSA,5,2)+"/"+SUBS(TMP2->RA_ADMISSA,3,2)
	@nLin,070	PSAY SUBS(TMP2->RA_DEMISSA,7,2)+"/"+SUBS(TMP2->RA_DEMISSA,5,2)+"/"+SUBS(TMP2->RA_DEMISSA,3,2)
	@nLin,080	PSAY TMP2->RA_CODFUNC+"-"+TMP2->RJ_DESC
	IF EMPTY(TMP2->RA_SITFOLH)
		@nLin,110	PSAY "NORMAL"
	ELSEIF TMP2->RA_SITFOLH == "A"
		@nLin,110	PSAY "AFASTADO"
	ELSEIF TMP2->RA_SITFOLH == "D"
		@nLin,110	PSAY "DEMITIDO"
	ELSEIF TMP2->RA_SITFOLH == "F"
		@nLin,110	PSAY "FERIAS"
	ELSEIF TMP2->RA_SITFOLH == "T"
		@nLin,110	PSAY "TRANSFERIDO"
	ENDIF
	
	nLin := nLin+1
	
	TMP2->(DbSkip(+1))
Enddo

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

TMP->(DbCloseArea())
TMP2->(DbCloseArea())

Return

//********************************************************************************************************
Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Pergunta Espanhol/Pergunta Ingles/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3/GRPSX6
aAdd(aRegs,{cPerg,"01","Da Matricula          ?","            ?","            ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Matricula       ?","            ?","            ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Periodo            ?","            ?","            ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate o Periodo         ?","            ?","            ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Da Funcao             ?","            ?","            ?","mv_ch5","C",05,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate a Funcao          ?","            ?","            ?","mv_ch6","C",05,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
