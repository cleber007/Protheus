#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEFIBA35   บAutor  ณJaime Wikanski      บ Data ณ  18/04/2001 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para validar os campos de Cod. Barras e Linha     บฑฑ
ฑฑบ          ณ Digitavel nos titulos a pagar com relacao ao fornecedor    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EFIBA35(_nOp)

/////////////////////////////////////////////////////////////////////////////
// Salva a area inicial dos arquivos 
/////////////////////////////////////////////////////////////////////////////
aAlias    := GetArea()
DbSelectArea("SE2")
aAliasSE2 := GetArea()
DbSelectArea("SA2")
aAliasSA2 := GetArea()

////////////////////////////////////////////////////////////////////////////
/// Declaracao de variaveis
////////////////////////////////////////////////////////////////////////////
//Private _cCodBar := M->E2_CBARRA
Private _cDigBar := M->E2_DIGBARR  

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2")+M->E2_FORNECE+M->E2_LOJA,.F.)

If (Empty(M->E2_FORNECE) .or. Empty(M->E2_LOJA) .and.  !Empty(M->E2_DIGBARR))
   MsgInfo("Atencao"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Preencha primeiro os dados do codigo e loja do fornecedor !")
   Return(.F.)
Endif
   
If !Empty(_cDigBar) .and. _nOp == 1
   DbSelectArea("SA2")
   DbSetOrder(1)
   If SA2->A2_BANCO <> Substr(_cDigBar,1,3)
      MsgInfo("Atencao"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Os dados bancarios do fornecedor estao inconsistentes com as informacoes coletadas pelo codigo de barras !")
      AltFor(1)
   Endif
   If SA2->A2_BANCO == "237" .and. (Empty(SA2->A2_AGENCIA) .or. Empty(SA2->A2_DIGAGEN) .or. Empty(SA2->A2_NUMCON) .or. Empty(SA2->A2_DIGCONT))
      MsgInfo("Atencao"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Os dados bancarios do fornecedor estao inconsistentes quanto aos digitos da agencia e conta do Bradesco !")
      AltFor(1)
   Endif      
Endif

If !Empty(_cDigBar) .and. _nOp == 2
   
   If SA2->A2_BANCO <> Substr(_cDigBar,1,3)
      MsgInfo("Atencao"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Os dados bancarios do fornecedor estao inconsistentes com as informacoes da linha digitavel do codigo de barras !")
      AltFor(1)
   Endif
   If SA2->A2_BANCO == "237" .and. (Empty(SA2->A2_AGENCIA) .or. Empty(SA2->A2_DIGAGEN) .or. Empty(SA2->A2_NUMCON) .or. Empty(SA2->A2_DIGCONT))
      MsgInfo("Atencao"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Os dados bancarios do fornecedor estao inconsistentes quanto aos digitos da agencia e conta do Bradesco !")
      AltFor(1)
   Endif
Endif

If Empty(SA2->A2_CGC) .or. Empty(SA2->A2_TIPO)
            
   MsgInfo("Atencao"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"O CGC do fornecedor esta em branco!")
   AltFor(2)
Endif
   
///////////////////////////////////////////////////////////////////////////////
// Restaura as แreas salvas
///////////////////////////////////////////////////////////////////////////////
RestArea(aAliasSE2)    
RestArea(aAliasSA2)    
RestArea(aAlias)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltFor    บAutor  ณJaime Wikanski      บ Data ณ  18/04/2001 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de alteracao dos dados do fornecedor                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlterado  ณ Colocada a op็ao para alterar o CGC qdo o fornecedor nao   บฑฑ
ฑฑบ          ณ tem o CGC cadastrado - Aguiar 10/03/04                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltFor(_nOpcao)
*******************************

SetPrvt("aAltera","aManute","_nRec")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณmatriz que contem campos a serem visualizados na alteracao  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAltera:={}     


If _nOpcao = 2
   
   aAltera:={"A2_COD","A2_LOJA","A2_NOME","A2_NREDUZ","A2_CGC","A2_TIPO"}  
   aManute:={"A2_CGC","A2_TIPO"}
Else
   
   aAltera:={"A2_COD","A2_LOJA","A2_NOME","A2_NREDUZ","A2_BANCO","A2_AGENCIA","A2_DIGAGEN","A2_NUMCON","A2_DIGCONT"}
   aManute:={"A2_BANCO","A2_AGENCIA","A2_DIGAGEN","A2_NUMCON","A2_DIGCONT"}
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณposicao atual do registro a alterar                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SA2")
_nRecSA2    := Recno()
Private _nopc := Axaltera("SA2",_nRecSA2,3,aAltera,aManute)

Return		