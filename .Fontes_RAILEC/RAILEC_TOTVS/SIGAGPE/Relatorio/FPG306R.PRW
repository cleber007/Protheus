#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FPG306R  º Autor ³ SANDRO ULISSES     º Data ³  19/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Resumo - Quadro Estatistico Anual                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Alubar S/A                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FPG306R()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "QUADRO DE FUNCOES"
Local cPict          := ""
Local titulo       := "QUADRO DE FUNCOES"
Local nLin         := 80

Local Cabec1       := "Cod. Funcao                           "
//                     XXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
//                     0         1         2         3         4         5         6         7         8         9         1         1         2         3
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Local Cabec2       := ""

Local imprime      := .T.
Local aOrd := {}
Local nInd := 0
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "FPG306R" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FPG306R" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "FPG306"                                                    
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
For nInd := MV_PAR01 to MV_PAR02
    Cabec1+=Str(nInd,4)+"  "
Next nInd
Cabec1+="Total"
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local _aFunc:= {}
Local _aCodF:= {}
Local nInd  := 0
Local nCont := 0
Local nx    := 0 
Local nVez  := MV_PAR02 - MV_PAR01 + 1
Local aTot  := Array(nVez+1) 
Local aMat  := Array(nVez+1)
Local nTam  := Len(SRJ->RJ_FUNCAO)
Local aStru := {}
Local cFile := ""
Local cCpo  := ""
AADD(aStru,{"TB_CODF","C",nTam,0})
AADD(aStru,{"TB_DESC","C",30,0})
For nx := 1 to nVez+1           
    AADD(aStru,{"TB_FUN"+StrZero(nx,2),"N",4,0})
    aTot[nx]:=0
Next nx
cFile := CriaTrab(aStru,.t.)
DbUseArea(.T.,,cFile,"TRB",.F.)
Index On TB_CODF to &cFile
DbSelectArea("SRA")
DbGoTop()
SetRegua(RecCount())
While !Eof()
      IncRegua()
      If Year(RA_ADMISSA) < MV_PAR01 .Or. Year(RA_ADMISSA) > MV_PAR02
         DbSkip()
         Loop
      EndIf                   
      DbSelectArea("TRB")
      If !DbSeek(SRA->RA_CODFUNC)
         SRJ->(DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC))
         RecLock("TRB",.T.)
         Replace TB_CODF With SRA->RA_CODFUNC
         Replace TB_DESC With SubStr(SRJ->RJ_DESC,1,30)
         For nx := 1 to nVez+1
             cCpo := "TB_FUN"+StrZero(nx,2)
             Replace &cCpo With 0
         Next nx
         MsUnLock()
      EndIf
      nPos := YEAR(SRA->RA_ADMISSA) - MV_PAR01 + 1
      RecLock("TRB",.F.)
      cCpo := "TB_FUN"+StrZero(nPos,2)
      Replace &cCpo With &cCpo+1   
      cCpo := "TB_FUN"+StrZero(nVez+1,2)
      Replace &cCpo With &cCpo+1
      MsUnLock()
      DbSelectArea("SRA")
      DbSkip()
EndDo
DbSelectArea("TRB")
DbGoTop()
If EOF() .AND. BOF()
   Alert("Não existem registros de acordo com os parametros do relatório!!!")
   DbCloseArea()
   fErase(cFile+".DBF")
   fErase(cFile+OrdBagExt())
   Return
EndIf           
aFill(aTot,0)
While !Eof()
    If nLin > 55
       nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin += 1
    EndIf                        
    nPos := 37
    @nLin,000 PSAY TB_CODF+"-"+TB_DESC
    For nx := 1 to nVez+1         
        cCpo := "TB_FUN"+StrZero(nx,2)
        If &cCpo <> 0
           @nLin,nPos PSAY Transform(&cCpo,"@E 9,999")
        Else
           @nLin,nPos PSAY "  ---"
        EndIf
        aTot[nx] += &cCpo
        nPos := PCol()+1
    Next nx             
    DbSkip()
    nLin+=1
EndDo
DbCloseArea()
fErase(cFile+".DBF")
fErase(cFile+OrdBagExt())
@nLin,000 PSAY Replicate("-",Limite)
nLin += 1
@nLin,000 PSAY "     Total Funcionários cadastrados"
nPos := 37
For nx := 1 to nVez+1
    If aTot[nx] <> 0
       @nLin,nPos PSAY Transform(aTot[nx],"@E 9,999")    
    Else         
       @nLin,nPos PSAY "  ---"
    EndIf
    nPos := pCol()+1
Next nx

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
