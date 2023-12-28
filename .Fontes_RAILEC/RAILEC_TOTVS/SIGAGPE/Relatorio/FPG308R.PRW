#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FPG308R  º Autor ³ SANDRO ULISSES     º Data ³  19/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Resumo - Quadro Analitico Funcional                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Alubar S/A                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FPG308R()
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "QUADRO DE FUNCOES ANALITICO"
Local cPict        := ""
Local titulo       := "QUADRO DE FUNCOES ANALITICO"
Local nLin         := 80

Local Cabec1       := "Matric Nome Funcionario(a)                                 Admissao Funcao                         Formacao"
//                     XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX/XX/XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
//                     0         1         2         3         4         5         6         7         8         9         1         1         2         3
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Local nInd         := 0
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "FPG308R" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FPG308R" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "FPG308"                                                    
Private cKey       := ""
Private nIndex     := 0
Private cIndex     := ""
Private cString    := "SRA"

dbSelectArea("SRA")
dbSetOrder(1) // FILIAL + MATRICULA


If !Pergunte(cPerg,.t.)
   Return
EndIf

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)
Titulo := Trim(Titulo)+" - "+Str(MV_PAR01,4)+" ATE "+Str(MV_PAR02,4)
DbSelectArea("SRA")
DbSetOrder(1)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cCusto := ""
Local lPrim  := .f.
Local aFunc  := {}
Local nPos   := 0  
Local nCont  := 0
Local lImpr  := .F.
Local dAdm   := CtoD("")
Local dHistD := CtoD("")
Local cFunc  := ""         
DbSelectArea("SRJ")
DbSetOrder(1)
DbSelectArea("SI3")
DbSetOrder(1)
DbSelectArea("SR7")
DbSetOrder(1)
DbSelectArea("SRA")
DbSetOrder(8) // FILIAL + CC + Nome
DbGoTop()
SetRegua(RecCount())
While !Eof()
      IncRegua()
      If RA_SITFOLH == "D"
         DbSkip()
         Loop
      EndIf
//      If nLin > 60
//         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
//         lPrim:= .F.
//         nLin += 1
//      EndIf       
      If cCusto <> RA_CC                                           
         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         lPrim:= .F.
         nLin += 1
         SI3->(DbSeek(xfilial("SI3")+SRA->RA_CC))
         @nLin,000 PSAY "Centro de Custo "+Trim(RA_CC)+" - "+SI3->I3_DESC
         cCusto := RA_CC
         lPrim := .T.
         nLin += 2
      EndIf
      nPos:=aScan(aFunc,{|X|X[1]+X[2]==RA_CODFUNC+RA_GRINRAI})
      If nPos == 0
         AADD(aFunc,{RA_CODFUNC,RA_GRINRAI,0})
         nPos := Len(aFunc)
      EndIf
      aFunc[nPos][3]+= 1
      @nLin,000 PSAY RA_MAT
      @nLin,007 PSAY SubStr(RA_NOMECMP,1,50)
      lImpr := .F.
      cFunc := RA_CODFUNC      
      dAdm  := CtoD("") 
      dHistD:= dAdm
      @nLin,059 PSAY DtoC(RA_ADMISSA)
      SX5->(DbSeek(xFilial("SX5")+"26"+SRA->RA_GRINRAI))
      SR7->(DbSeek(xFilial("SR7")+SRA->RA_MAT+DtoS(SRA->RA_ADMISSA)))
      While !SR7->(Eof()) .And. SR7->R7_MAT==SRA->RA_MAT
            If Trim(SR7->R7_FUNCAO) <> Trim(cFunc)
               If nLin > 60
                  nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
                  SI3->(DbSeek(xfilial("SI3")+SRA->RA_CC))
                  @nLin,000 PSAY "Centro de Custo "+Trim(RA_CC)+" - "+SI3->I3_DESC
                  nLin += 1
                  @nLin,000 PSAY RA_MAT
                  @nLin,007 PSAY SubStr(RA_NOMECMP,1,50)
               EndIf       
               SRJ->(DbSeek(xFilial("SRJ")+SR7->R7_FUNCAO))
               If lImpr
                  @nLin,059 PSAY DtoC(SR7->R7_DATA)
                  dHistD := SR7->R7_DATA
               EndIf
               @nLin,068 PSAY SubStr(SRJ->RJ_DESC,1,30)
               If !lImpr
                  @nLin,099 PSAY SX5->X5_DESCRI
               EndIf  
               dAdm  := SR7->R7_DATA   
               lImpr := .T.
               nLin += 1
            EndIf
            cFunc := SR7->R7_FUNCAO
            SR7->(DbSkip())
      EndDo
      If lImpr .And. Empty(dHistD)
         @nlin,059 PSAY DtoC(dAdm)
      EndIf
      If (cFunc <> RA_CODFUNC) .Or. !lImpr
         SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
         @nLin,068 PSAY SubStr(SRJ->RJ_DESC,1,30)
      EndIf
      If !lImpr
         @nLin,099 PSAY SX5->X5_DESCRI
      EndIf
      nLin += 1
      @nLin,000 PSAY Replicate("-",Limite)
      nLin += 1
      DbSkip()
EndDo                      
If Len(aFunc) > 0
   nLin += 3                   
   nCont := 0
   aSort(aFunc,,,{|X,Y| X < Y})
   For nPos := 1 to Len(aFunc)
       If nLin > 60
          nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)
          nLin += 1
       EndIf       
       SRJ->(DbSeek(xFilial("SRJ")+aFunc[nPos][1]))
       SX5->(DbSeek(xFilial("SX5")+"26"+aFunc[nPos][2]))
       @nLin,10 PSAY SubStr(SRj->RJ_DESC,1,30)+" - "+SUBSTR(SX5->X5_DESCRI,1,50)+" "+Transform(aFunc[nPos][3],"@E 9,999")
       nCont += 1
       nLin += 1
   Next nPos
   @nlin,10 PSAY Replicate("-",85)
   nLin += 1
   @nLin,10 PSAY Space(23)+"Total do Resumo por Funcoes"+Space(24)+Transform(nCont,"@E 9,999")
EndIf
SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static FUNCTION AjustaSX1
aArea:=GetArea()                 
i:=0
j:=0
aPerg    := {}                                
Aadd(aPerg,{"Ano de Referencia   " ,"N",4,0})
Aadd(aPerg,{"Ano de Referencia Ate","N",4,0})
RestArea(aArea)
Return
