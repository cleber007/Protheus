#Include "rwmake.ch"
#Include "AP5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT106CQ  ºAutor  ³ SANDRO ULISSES     º Data ³  11/28/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera e-mail para o almoxarifado notificando sobre a requi- º±±
±±º          ³ sicao de material                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GRUPO ALUBAR                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT106CQ() 

RETURN


/*
Local oHtml
Local eMailRM:=""
Local cGrupo:=""
Local nVez  := 0   
Local cFecha:= ""                            
Local cObs  := ""        
Local nQtdSld:= 0
Local cArea := GetArea()
Local cDoc  := SCP->CP_NUM 
Local nRegCP:= SCP->(RecNo())
Local cAplic:= ""
Local aEmail:= {}
Local cEmailTmp := ""
Local nInd:=nPos := 0
Local nCodUsr := RetCodUsr() // Funcao que retorna o numero do usuario corrente

DbSelectArea("SCQ")
DBSEEK(xFilial("SCQ")+SCP->CP_NUM+SCP->CP_ITEM)
RecLock("SCQ",.F.)
Replace CQ_DATPRF With IF(SCP->CP_DATPRF<dDataBase,dDataBase,SCP->CP_DATPRF)
Replace CQ_NUMREQ With SCP->CP_NUM 
SB1->(DbSeek(xFilial("SB1")+SCP->CP_PRODUTO))               
SI3->(DbSeek(xFilial("SI3")+SCP->CP_CC))
Replace CQ_CONTA With If(Empty(SB1->B1_ITEM),SB1->B1_CONTAD,SI3->I3_GRUPO+SB1->B1_ITEM)
SCQ->(MsUnLock())

eMailRM := "jose.macedo@alubar.net" //GetMv("MV_RESPALM")              
DbSelectArea("SCP")
DbSetOrder(1)
DbSeek(xFilial("SCP")+cDoc,.T.)
While !EOF() .And. CP_NUM == cDoc .And. xFilial("SCP") == CP_FILIAL

//      If CP_ENVIADO == "S"
//         DbSkip()
//         Loop
//      EndIf

      If SubStr(CP_PRODUTO,2,4) $ "4101/4102"
         DbSkip()
         Loop
      EndIf

      If nVez == 0
         oProc:=TWFProcess():New("REQALM","Requisicao de Material")
         oProc:NewTask("ALMOX01","\WorkFlow\REQALMOX.HTM")
         oProc:cSubject:= " Requisicao de Material Nr."+cDoc
         oProc:cTo:= eMailRM
         oHtml:=oProc:oHTML
         oHtml:ValByName("empresa",SM0->M0_NOME)
         oHtml:ValByName("numreq",cDoc)
         oHtml:ValByName("nomesol",SCP->CP_SOLICIT)
         oHtml:ValByName("datasol",DtoC(dDatabase))
         oHtml:ValByName("horasol",Time())        
         nVez := 1
      EndIf

      aadd((oHtml:ValByName("tb.prod")),Trim(SCP->CP_PRODUTO))
      aadd((oHtml:ValByName("tb.descri")),SubStr(SCP->CP_DESCRI,1,40))
      aadd((oHtml:ValByName("tb.um")),Trim(SCP->CP_UM))
      aadd((oHtml:ValByName("tb.qtde")),Alltrim(Trans(SCP->CP_QUANT,"@E 999,999.9999")))
      aadd((oHtml:ValByName("tb.dtneces")),If(scp->CP_DATPRF < dDataBase,DtoC(dDataBase),DtoC(SCP->CP_DATPRF)))

      DBSELECTAREA("SCP")
      If !Empty(CP_OBS)
         cObs += CP_NUM+CP_ITEM+" - "+CP_OBS+cFecha
      EndIf     

      RecLock("SCP",.F.)
      Replace CP_ENVIADO With "S"
      SB1->(DbSeek(xFilial("SB1")+SCP->CP_PRODUTO))               
      SI3->(DbSeek(xFilial("SI3")+SCP->CP_CC))
      Replace CP_CONTA With If(Empty(SB1->B1_ITEM),SB1->B1_CONTAD,SI3->I3_GRUPO+SB1->B1_ITEM)
      
      Replace CP_EMAIL With UsrRetMail(nCodUsr) // Funcao que retorna o e-mail do usuario corrente

      MsUnLock()
      DbSkip()                

      If !EOF()
         If CP_NUM == cDoc .And. !Empty(CP_OBS)
            cObs += '<tr><td colspan="5">'
            cFecha = "</td></tr>"
         EndIf
      EndIf

EndDo             

If nVez == 1               
   cObs += cFecha
   oHtml:ValByName("observ",cObs)
   oProc:UserSiga:= __cUserID
   oProc:Start()
   oProc:Finish()
   MsgInfo("Notificacao da Requisicao de Material Nr "+cDoc+" foi enviado para o Almoxarifado ...")
EndIf

nVez := 0
cObs := "" 

DbSelectArea("SB1")
DbSetOrder(1)
DbSelectArea("SB2")
DbSetOrder(1)
DbSelectArea("SBM")
DbSetOrder(1)
DbSelectArea("SCP")

DbSeek(xFilial("SCP")+cDoc,.T.)

While !EOF() .And. CP_NUM == cDoc .And. xFilial("SCP") == CP_FILIAL

      If CP_ENVCOM == "S"
         DbSkip()
         Loop
      EndIf                           

      If !SB2->(DbSeek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_LOCAL))
         DbSkip()
         Loop
      EndIf

      If SB2->B2_QATU < 0
         DbSkip()
         Loop
      EndIf

      If SCP->CP_QUANT < SB2->B2_QATU
         DbSkip()
         Loop
      EndIf
      
      nQtdSld := SB2->B2_QATU - SCP->CP_QUANT // Calcula o saldo que ficara apos a requisicao

      SB1->(DbSeek(xFilial("SB1")+SCP->CP_PRODUTO,.T.))
      SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO,.T.))
    
      If nQtdSld > SB1->B1_EMIN // Verifica se atingiu o ponto de pedido
         DbSkip()
         Loop
      EndIf
      
      eMailRM := ""
      cEmailTMP := AllTrim(SBM->BM_GRUREL)+";"
      
      If cEmailTmp # ";"
         For nInd := 1 to Len(cEmailTmp)
             If SubStr(cEmailTMP,nInd,1) # ";"
                eMailRM += SubStr(cEmailTMP,nInd,1)
             Else
                eMailRM += "@alubar.net"
                nPos := aScan(aEmail,eMailRM)
                If nPos == 0
                   AADD(aEmail,eMailRM)
                EndIf
             EndIf
         Next nInd
      EndIf
      
      nQtdSld:=IF(nQtdSld<0,nQtdSld*(-1),nQtdSld) // Verifica se saldo e negativo e inverte

      If nVez == 0
         oProc1:=TWFProcess():New("SOLCOMP","Solicitacao de Compras")
         oProc1:NewTask("ALMOX02","\WorkFlow\SOLCOMP.HTM")
         oProc1:cSubject:= " Solicitacao de Compras (RA) - "+SC1->C1_NUM //SCP->CP_SOLICIT
         oHtml1:=oProc1:oHTML
         oHtml1:ValByName("empresa",SM0->M0_NOME)
         oHtml1:ValByName("numsol",SC1->C1_NUM)
         oHtml1:ValByName("nomesol",SCP->CP_SOLICIT)
         oHtml1:ValByName("datasol",DtoC(dDatabase))
         oHtml1:ValByName("horasol",Time())        
         nVez := 1
      EndIf

      cAplic := IIf(SCP->CP_ONDEAPL=="D","Direta  ",IIf(SCP->CP_ONDEAPL=="E","Estoque   ","Investim."))

      aadd((oHtml1:ValByName("tb.prod")),Trim(SCP->CP_PRODUTO))
      aadd((oHtml1:ValByName("tb.descri")),SubStr(SCP->CP_DESCRI,1,40))
      aadd((oHtml1:ValByName("tb.um")),Trim(SCP->CP_UM))
      aadd((oHtml1:ValByName("tb.qtde")),Alltrim(Trans(nQtdSld,"@E 999,999.9999")))
      aadd((oHtml1:ValByName("tb.dtneces")),If(SCP->CP_DATPRF < dDataBase,dDataBase,DtoC(SCP->CP_DATPRF)))
      aadd((oHtml1:ValByName("tb.itcompr")),SCP->CP_NUMSC+"-"+SCP->CP_ITEMSC)
      aadd((oHtml1:ValByName("tb.aplicac")),cAplic)

      DBSELECTAREA("SCP")
      If !Empty(CP_OBS)
         cObs += CP_NUM+CP_ITEM+" - "+CP_OBS+cFecha
      EndIf     

      RecLock("SCP",.F.)
      Replace CP_ENVCOM With "S"
      Replace CP_NUMSC With SC1->C1_NUM
      Replace CP_ITEMSC With SC1->C1_ITEM
      MsUnLock()

      DbSkip()                
      
      If !EOF()
         If CP_NUM == cDoc .And. !Empty(CP_OBS)
            cObs += '<tr><td colspan="5">'
            cFecha = "</td></tr>"
         EndIf
      EndIf

EndDo             

If Len(aEmail) > 0
   eMailRM := ""
   For nInd := 1 to Len(aEmail)
       eMailRM += aEmail[nInd]+If(nInd<Len(aEmail),";","")
   Next nInd
   cObs += cFecha
   oHtml1:ValByName("observ",cObs)
   oProc1:cTo:= eMailRM
   oProc1:UserSiga:= __cUserID
   oProc1:Start()
   oProc1:Finish()
   MsgInfo("Notificacao da Solicitacao de Compras foi enviada para o Compras ...")
EndIf

SCP->(DbGoto(nRegCP))

RestArea(cArea)

Return()
