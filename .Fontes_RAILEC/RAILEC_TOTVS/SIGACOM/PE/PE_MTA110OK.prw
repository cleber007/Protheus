#INCLUDE 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA110OK ºAutor  ³ SANDRO ULISSES     º Data ³  07/19/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GERA NOTIFICACAO POR E-MAIL PARA O RESPONSAVEL PELO COMPRASº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GRUPO ALUBAR S/A                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA110OK()
Local oHtml,oProc,x,cObs,cFecha,cNome,eMailSC,nInd,aEmail,cEmailTmp,nPos
cNome:=Upper(Trim(GetMv("MV_EMAILSC")))
If !Upper(Trim(cUserName))$cNome
   Return(.T.)
EndIf  
caEmailSC:=""                                              
aEmail:={}
oProc:=TWFProcess():New("SOLCOMP","Solicitacao de Compras")
oProc:NewTask("ALMOX03","\WorkFlow\SOLCOMP.HTM")
oProc:cSubject:= " Solicitacao de Compras - "+CA110NUM
oProc:cTo:= GetMv("MV_RESPCOM")                          
oHtml:=oProc:oHTML
oHtml:ValByName("empresa",SM0->M0_NOME)
oHtml:ValByName("numsol",CA110NUM)
oHtml:ValByName("nomesol",cUserName)
oHtml:ValByName("datasol",DtoC(dDataBase))
oHtml:ValByName("horasol",Time())        
cObs := cFecha := ""
For x:=1 to Len(aCols)
    SB1->(DbSeek(xFilial("SB1")+aCols[x][2]))
    SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO))
    eMailSC := ""
    cEmailTmp := AllTrim(SBM->BM_GRUREL)+";"
    If cEmailTmp # ";"
       For nInd := 1 to Len(cEmailTmp)
           If SubStr(cEmailTmp,nInd,1) # ";"
              eMailSC += SubStr(cEmailTmp,nInd,1)
           Else
              eMailSC += "@alubar.net"
              nPos := aScan(aEmail,eMailSC)
              If nPos == 0
                 AADD(aEmail,eMailSC)
              EndIf
           EndIf
       Next nInd
    EndIf
    aadd((oHtml:ValByName("tb.prod")),Trim(aCols[x][2]))
    aadd((oHtml:ValByName("tb.descri")),SubStr(aCols[x][14],1,40))
    aadd((oHtml:ValByName("tb.um")),Trim(aCols[x][3]))
    aadd((oHtml:ValByName("tb.qtde")),Alltrim(Trans(aCols[x][4],"@E 999,999.9999")))
    aadd((oHtml:ValByName("tb.dtneces")),DtoC(aCols[x][7]))
    aadd((oHtml:ValByName("tb.itcompr")),CA110NUM+"-"+Trim(aCols[x][1]))
    aadd((oHtml:ValByName("tb.aplicac")),"")
    If !Empty(aCols[x][9])
       cObs += CA110NUM+aCols[x][1]+" - "+aCols[x][9]+cFecha
    EndIf     
    If x < Len(aCols)
       cObs += '<tr><td colspan="5">'
       cFecha = "</td></tr>"
    EndIf
Next x 
If Len(aEmail) > 0
   eMailSC := ""
   For nInd := 1 to Len(aEmail)
       eMailSC += aEmail[nInd]+If(nInd<Len(aEmail),";","")
   Next nInd
   cObs+=cFecha
   oHtml:ValByName("Observ",cObs)
   oProc:cTo:= eMailSC
   oProc:UserSiga:= __cUserID
   oProc:Start()
   oProc:Finish()
   MsgInfo("Notificacao da Solicitacao de Compras foi enviada para o Compras ...",)
EndIf

Return(.t.)
