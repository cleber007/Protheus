#Include "rwmake.ch"

User Function MT103NFE(nOpcao)   
cArea := GetArea()
cConta:= ""
cItem := ""
cCusto:= ""
cAno  := ""
nOrdSD1:= SD1->(IndexOrd())
nRegSD1:= SD1->(RecNo())
If nOpcao == 5 // Exclusao de NF
   If SF1->F1_TIPO $ "CTR/CTA/CTF/CA "
      DbSelectArea("SF2")
      DbSetOrder(6)
      If DbSeek(xFilial("SF2")+SF1->F1_DOC+SF1->F1_SERIE)
         RecLock("SF2",.F.)              
         If F2_NFRETE+F2_SFRETE == SF1->F1_DOC+SF1->F1_SERIE
            Replace F2_NFRETE With ""
            Replace F2_SFRETE With ""
         EndIf
         If F2_RDFRETE+F2_RDSERIE == SF1->F1_DOC+SF1->F1_SERIE
            Replace F2_RDFRETE With ""
            Replace F2_RDSERIE With ""
         EndIf
         MsUnLock()
      EndIf
   EndIf
EndIf        
DbSelectArea("SIZ")
DbSetOrder(1)
DbSelectArea("SIA")
DbSetOrder(1)               
DbSelectArea("SC7")
DbSetOrder(1)
DbSelectArea("SD1")
DbSetOrder(1)     
While !Eof() .And. D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
      cAno  := StrZero(Year(D1_EMISSAO),4)
      cMes  := StrZero(Month(D1_EMISSAO),2)
      cCusto:= D1_CC
      cConta:= D1_CONTA
      nValor:= D1_TOTAL
      cItem := D1_ITEMCTA
      DbSelectArea("SIZ")
      If DbSeek(xFilial("SIZ")+cCusto+cAno)
         RecLock("SIZ",.F.)
         Replace IZ_REALANO With IZ_REALANO+nValor
         MsUnLock()
      EndIf        
      DbSelectArea("SIA")
      If DbSeek(xFilial("SIA")+cConta+cItem+cCusto+cAno+'10101')
         RecLock("SIA",.F.)
         Replace IA_VLREA&cMes With IA_VLREA&cMes+nValor
         Replace IA_REALANO With IA_REALANO+nValor
         MsUnLock()                
         If !Empty(SD1->D1_ITEMCTA)
            If DbSeek(xFilial("SIA")+cConta+Space(9)+cCusto+cAno+'10101')
               RecLock("SIA",.F.)          
               Replace IA_VLREA&cMes With IA_VLREA&cMes+nValor
               Replace IA_REALANO With IA_REALANO+nValor
               MsUnLock()                
            EndIf
         EndIf
      EndIf      
      DbSelectArea("SZ7")
      If DbSeek(xFilial("SZ7")+cCusto+cAno)
         RecLock("SZ7",.F.)
         Replace Z7_REA&cMes With Z7_REA&cMes+nValor
         Replace Z7_REALANO With Z7_REALANO+nValor
         MsUnLock()                
      EndIf      
      DbSelectArea("SD1")
      DbSkip()  
EndDo
SD1->(DbSetOrder(nOrdSD1))
SD1->(DbGoTo(nRegSD1))
RestArea(cArea)
Return