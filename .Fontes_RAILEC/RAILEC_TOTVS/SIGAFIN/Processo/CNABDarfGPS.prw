#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CNABCNPJ ³ Autor ³ Solon Silva SigaCorp³    Data ³ 25.11.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Busca o cnpj do parametro titulo pai para a rotina do      ³±±
±±³          ³ CNAB Darf - GPS                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³                                             				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                         	  ³±±
±±³          ³                                                      	  ³±±
±±³          ³                       									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                   									 	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CNABNOMESA2(ccTituloPai)
Local nNome    := ""
Local aAreaTRB := GetArea()


cQry := " SELECT A2_NOME nNome "
cQry += " FROM " +RetSqlName("SA2")
cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
cQry += " AND A2_COD =  '"+ccTituloPai+"'"

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

nNome := Qry->nNome

DbCloseArea("QRY")

RestArea(aAreaTRB)
//Alert(nNome)
Return nNome

User Function CNOMESA2(cnTituloPai,cnA2_COD)
Local cNome    := ""
Local aAreaTRB := GetArea()

if AllTrim(cnTituloPai)==""               
  cQry := " SELECT A2_NOME cNome "
  cQry += " FROM " +RetSqlName("SA2")
  cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
  cQry += " AND A2_COD =  '"+cnA2_COD+"'
else
  cQry := " SELECT A2_NOME cNome "
  cQry += " FROM " +RetSqlName("SA2")
  cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
  cQry += " AND A2_COD =  '"+cnTituloPai+"'"
endif

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

cNome := Qry->cNome

DbCloseArea("QRY")

RestArea(aAreaTRB)

Return cNome


User Function CNABCNPJA2(ccTituloPai)
Local nCNPJ    := ""
Local aAreaTRB := GetArea()


cQry := " SELECT A2_CGC nCNPJ "
cQry += " FROM " +RetSqlName("SA2")
cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
cQry += " AND A2_COD =  '"+ccTituloPai+"'"

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

nCNPJ := StrZero(Val(AllTrim(Qry->nCNPJ)),14)

DbCloseArea("QRY")

RestArea(aAreaTRB)
//Alert(nCNPJ)           
Return nCNPJ

User Function CCNPJSA2(ccTituloPai,ccA2_COD)
Local cCNPJ    := ""
Local aAreaTRB := GetArea()

if AllTrim(ccTituloPai)==""
  cQry := " SELECT A2_CGC cCNPJ "
  cQry += " FROM " +RetSqlName("SA2")
  cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
  cQry += " AND A2_COD =  '"+ccA2_COD+"'"
else
  cQry := " SELECT A2_CGC cCNPJ "
  cQry += " FROM " +RetSqlName("SA2")
  cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
  cQry += " AND A2_COD =  '"+ccTituloPai+"'"
endif

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

cCNPJ := StrZero(Val(AllTrim(Qry->cCNPJ)),14)

DbCloseArea("QRY")

RestArea(aAreaTRB)

Return cCNPJ


User Function CNABCODIRECA2(ccTituloPai)
Local cCodiRec := ""
Local aAreaTRB := GetArea()
                                               

cQry := " SELECT A2_CODIREC cCodiRec "
cQry += " FROM " +RetSqlName("SA2")
cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
cQry += " AND A2_COD =  '"+ccTituloPai+"'"

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

cCodiRec := StrZero(Val(AllTrim(Qry->cCodiRec)),4)

DbCloseArea("QRY")
RestArea(aAreaTRB)

//Alert(cCodiRec)

Return cCodiRec

User Function CCDSA2(ccTituloPai,ccA2_COD)
Local cCodiRec := ""
Local aAreaTRB := GetArea()
                                               
if AllTrim(ccTituloPai)==""
  cQry := " SELECT A2_CODIREC cCodiRec "
  cQry += " FROM " +RetSqlName("SA2")
  cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
  cQry += " AND A2_COD =  '"+ccTituloPai+"'"
else
  cQry := " SELECT A2_CODIREC cCodiRec "
  cQry += " FROM " +RetSqlName("SA2")
  cQry += " WHERE A2_FILIAL  = '"+xFilial("SA2")+"'  "
  cQry += " AND A2_COD =  '"+ccA2_COD+"'"
endif

TcQuery cQry NEW ALIAS "QRY"
DBSelectArea("QRY")

cCodiRec := StrZero(Val(AllTrim(Qry->cCodiRec)),4)

DbCloseArea("QRY")
RestArea(aAreaTRB)

Return cCodiRec

