#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FPG305R  º Autor ³ SANDRO ULISSES     º Data ³  13/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ HISTORICO DE FUNCAO                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GRUPO ALUBAR S/A                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FPG305R()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "HISTORICO DE FUNCOES"
Local cPict        := ""
Local titulo       := "HISTORICO DE FUNCOES"
Local nLin         := 80

Local Cabec1       := "Codigo NOME                                     ADMISSAO DATA FUN        SALARIO "
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {"C.Custo+Funcao+Nome","Funcao+C.Custo+Nome"}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "FPG305R" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "FPG305"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := NomeProg // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString    := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)
                 
pergunte(cPerg,.T.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  13/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem,cFile,cKey,cFiltro,nIndex,cQuebra,lExiste
DbSelectArea("SR7")
DbSetorder(1)
dbSelectArea(cString)
cFile := CriaTrab(nil,.f.)
If aReturn[8] == 1
   cKey  := "RA_FILIAL+RA_CC+RA_CODFUNC+RA_NOME"
   Cabec1+= "FUNCAO"
Else
   cKey  := "RA_FILIAL+RA_CODFUNC+RA_CC+RA_NOME"
   Cabec1+= "C.CUSTO"
EndIf
cFiltro  := "RA_FILIAL == '"+xFilial("SRA")+"'.And. RA_CODFUNC >='"+MV_PAR01+"'.And. RA_CODFUNC <='"+MV_PAR02+"'"
cFiltro  += ".And. RA_CC >='"+MV_PAR03+"'.And. RA_CC <='"+MV_PAR04+"'.And. RA_NOME >='"+MV_PAR05+"'"
cFiltro  += ".And. RA_NOME <='"+MV_PAR06+"'.And. DtoS(RA_ADMISSA) >='"+DtoS(MV_PAR07)+"'"
cFiltro  += ".And. DtoS(RA_ADMISSA) <='"+DtoS(MV_PAR08)+"'.And. RA_SITFOLH $'"+MV_PAR09+"'"
cFiltro  += ".And. RA_CATFUNC $'"+MV_PAR10+"'"
IndRegua("SRA",cFile,ckey,,cFiltro,"Selecionado Registros ...")
nIndex   := RetIndex("SRA")+1
DbSetIndex(cFile+OrdBagExt())
DbSetorder(nIndex)
DbGoTop()
SetRegua(RecCount())
cQuebra := ""
While !EOF()

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif                    
   
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin += 1
   Endif

   lExiste := .F.          
   SR7->(DbSeek(xFilial("SR7")+SRA->RA_MAT,.T.))
   While !SR7->(Eof()) .And. SR7->R7_MAT == SRA->RA_MAT
         If SR7->R7_FUNCAO == SRA->RA_CODFUNC
            lExiste := .T.
            Exit
         EndIf
         SR7->(DbSkip())
   EndDo
   Do Case 
      Case aReturn[8] == 1
        If RA_CC <> cQuebra
           nLin += 1                         
           SI3->(DbSeek(xFilial("SI3")+SRA->RA_CC,.T.))
           @nLin,000 PSAY "C. Custo : "+Trim(RA_CC)+" - "+SI3->I3_DESC
           cQuebra := RA_CC
           nLin += 2
        EndIf
      OtherWise
        If RA_CODFUNC <> cQuebra
           nLin += 1
           SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC,.T.))
           @nLin,000 PSAY "C. Custo : "+Trim(RA_CODFUNC)+" - "+SRJ->RJ_DESC
           cQuebra := RA_CODFUNC                                      
           nLin += 2
        EndIf
   EndCase
   @nLin,000 PSAY RA_MAT
   @nLin,007 PSAY SUBSTR(RA_NOMECMP,1,50) // ALTERADO 18-01-2018 MARINALDO SA
   @nLin,068 PSAY DtoC(RA_ADMISSA)// 48
   @nLin,077 PSAY If(!lExiste,DtoC(RA_ADMISSA),DtoC(SR7->R7_DATA)) // 57
   @nLin,086 PSAY Transform(RA_SALARIO,"@E 999,999,999.99") // 66
   Do Case
      Case aReturn[8] == 1
           SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC,.T.))
           @nLin,PCol()+1 PSAY Trim(RA_CODFUNC)+" - "+SRJ->RJ_DESC
      OtherWise
           SI3->(DbSeek(xFilial("SI3")+SRA->RA_CC,.T.))
           @nLin,PCol()+1 PSAY Trim(RA_CC)+" - "+SI3->I3_DESC
   EndCase
   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo
RetIndex("SRA")
Set Filter to
fErase(cFile+".DBF")
fErase(cFile+OrdBagExt())

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

