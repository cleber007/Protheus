#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 30/03/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Creceb()        // incluido pelo assistente de conversao do AP5 IDE em 30/03/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CAREA,NREC,CIND,TAMANHO,LIMITE,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,ARETURN,LIMPRANT,ALINHA")
SetPrvt("CPERG,NOMEPROG,NLASTKEY,IMPRIME,CSAVCUR1,CSAVROW1")
SetPrvt("CSAVCOL1,CSAVCOR1,CBTXT,CBCONT,CSTRING,LI")
SetPrvt("M_PAG,AORD,WNREL,TREGS,M_MULT,NTOTREGS")
SetPrvt("NMULT,NPOSANT,NPOSATU,NPOSCNT,CSAV20,CSAV7")
SetPrvt("P_ANT,P_ATU,P_CNT,M_SAV20,MCONTPAG,MCONTLIN")
SetPrvt("MVL_TOT1,MVL_DIA1,MVL_TITU,MVL_MES,MJUR_MES,MQT_MES")
SetPrvt("MMES_ANT,MMES_ATU,MVENCIDOS,MT_VENCID,MT_QTVENC,MVENC_JUR")
SetPrvt("MAVENCER,MT_AVENC,MT_QTAVEN,MJUR_AVEN,MTOTTITU,MQT_VENC")
SetPrvt("MQT_AVEN,MDESDIA,MDESTOT,MDESMES,CTIPO,CNATDE")
SetPrvt("CNATATE,DVENCDE,DVENCATE,DEMISDE,DEMISATE,CPORTDE")
SetPrvt("CPORTATE,CFORNDE,CFORNATE,CVAR_TIPOREL,DBAIXADE,DBAIXAATE")
SetPrvt("CANASIN,NSEDORD,NSA6ORD,NSA1ORD,NSE1ORD,ASTRU")
SetPrvt("CARQTEMP,CORD,LATE,MKEY,CDESCTOT,DPES")
SetPrvt("CONDTIPO,VRELAT,MFILTRO,CARQTEMP2,MTEMREG,CABEC1")
SetPrvt("CABEC2,CCLIENTE,CNOMFOR,CNATUREZ,CNOMNAT,CNUMERO")
SetPrvt("DVENCTO,DBAIXA,CPORTADO,CSITUA,CNOMPORT,DEMISSAO")
SetPrvt("CNOMSIT,MMESATU,MMESANT,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 30/03/01 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CRECEB  ³Autor³ Ionai Morais do Carmo    ³ Data ³ 13.05.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Titulos a receber (80 Colunas)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Interpretador xBase                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/    
SET SOFTSEEK ON

cArea   := Alias()
nRec    := Recno()
cInd    := IndexOrd()
tamanho :=' '
limite  :=132
titulo  :="Emissão de Titulos a Receber/Recebidos/Ambos"
cDesc1  :=' '
cDesc2  :='Titulos a A Receber/Recebidos/Ambos, conforme parametros definidos pelo usuario'
cDesc3  :='Impressao em formulario de 80 colunas.'
aReturn := { 'Zebrado', 1,'Financeiro ', 1, 2, 1,'',1 }
lImprAnt:= .F.
aLinha  := { }
cPerg   := 'CRECEB'
nomeprog:= 'CRECEB'
nLastKey:= 0
imprime := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//cSavCur1 := SetCursor(0)
//cSavRow1 := ROW()
//cSavCol1 := COL()
//cSavCor1 := SetColor('bg+/b,,,')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt    := SPACE(10)
cbcont   := 0
cString  := 'SE1'
li       := 15
m_pag    := 1
aOrd     := {' Por Cliente',' Por Natureza',' Por Vencimento',' Por Portador',' Por Emissao',' Por Baixa'}
wnrel    := 'CRECEB'   // nome default do relatorio em disco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte ('CRECEB',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajuste dos parƒmetros da impress„o via fun‡„o SETPRINT       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

set cursor off
wnrel:= 'CRECEB'
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd)

#IFNDEF WINDOWS
         If LastKey()== 27 .or. nLastKey== 27 .or. nLastKey== 286
		Return
	 Endif
#ENDIF

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aceita parƒmetros e faz ajustes necess rios                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 30/03/01 ==> 	RptStatus({|| Execute(RptDetail)})
	Return
// Substituido pelo assistente de conversao do AP5 IDE em 30/03/01 ==> 	Function RptDetail
Static Function RptDetail()
#ENDIF

#IFNDEF WINDOWS
         If LastKey()== 27 .OR. nLastKey== 27 .or. nLastKey== 286
		Return
	 Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Vari veis utilizadas na barra de status                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea('SE1')
tregs := reccount()
m_mult := 1

nTotregs := 0 //-- Regua.
nMult    := 0
nPosAnt  := 0
nPosAtu  := 0
nPosCnt  := 0
cSav20   := ''
cSav7    := ''

Tamanho := 'P'
Limite  := 80

IF tregs > 0
   m_mult := 70/tregs
ENDIF

p_ant := 4
p_atu := 4
p_cnt := 0
*m_sav20 := dcursor(3)
mContPag := 0
mContLin := 60
mvl_tot1 := 0
mvl_dia1 := 0
mvl_titu := 0
mVl_Mes  := 0
mJur_Mes := 0
mQt_Mes  := 0
mMes_Ant := ''
mMes_Atu := ''
mVencidos:= 0               // Valor Total dos Titulos Vencidos
mT_Vencid:= 0
mT_QtVenc:= 0
mVenc_Jur:= 0               // Valor Total de Juros dos Titulos Vencidos
mAVencer := 0               // Valor Total dos Titulos A Vencer
mT_AVenc := 0
mT_QtAven:= 0
mJur_AVen:= 0               // Valor Total de Juros dos Titulos a Vencer
mTotTitu := 0               // Quant. Total de Titulos Emitidos
mQt_Venc := 0               // Quant. total de titulos Vencidos
mQt_Aven := 0               // Quant. total de titulos a Vencer
mDesDia:=mDesTot:=mDesMes:=0

cTipo       := mv_par01
cNatDe      := mv_par02
cNatAte     := mv_par03
dVencDe     := mv_par04
dVencAte    := mv_par05
dEmisDe     := mv_par06
dEmisAte    := mv_par07
cPortDe     := mv_par08
cPortAte    := mv_par09
cFornDe     := mv_par10
cFornAte    := mv_par11
cVar_TipoRel:= mv_par12
dBaixaDe    := mv_par13
dBaixaAte   := mv_par14
cAnaSin     := iif(cVar_TipoRel=1,'Analitico','Sintetico')

dbSelectArea('SED')
nSEDOrd := IndexOrd()
dbSetOrder(1)
dbSelectArea('SA6')
nSA6Ord := IndexOrd()
dbSetOrder(1)
dbSelectArea('SA1')
nSA1Ord := IndexOrd()
dbSetOrder(1)
dbSelectArea('SE1')
nSE1Ord := IndexOrd()

// Estrutura do Arquivo Temporario

aStru := {}
aadd(aStru , {'Doc','C',6,0} )
aadd(aStru , {'Portado','C',3,0} )  
aadd(aStru , {'Situaca','C',2,0} )
aadd(aStru , {'Naturez','C',10,0} )
aadd(aStru , {'Parcela','C',1,0} )
aadd(aStru , {'Cliente','C',6,0} )
aadd(aStru , {'Emissao','D',8,0} )
aadd(aStru , {'Vencto','D',8,0} )
aadd(aStru , {'Baixa','D',8,0} )
aadd(aStru , {'Valor','N',17,2} )
aadd(aStru , {'Perman','N',4,0} )
aadd(aStru , {'Hist','C',25,0} )

/*
cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TMP',.f.)
*/
oTable := FWTemporaryTable():New("TMP", aStru)
oTable:addIndex("01", {"Doc"})
oTable:create()
TMP:= oTable:GetRealName()


dbSelectArea('SE1')

cOrd := ' '
lAte := '.t.'

DO CASE
   Case aReturn[8] == 1            // Cliente
        dbSetOrder(2)
        dbSeek(xFilial()+cFornDe,.T.)
        mKey := 'cCliente==CLIENTE'
        cDescTot := 'LEFT(cNomFor,27)'
        cOrd := '(por Cliente)'
        lAte := '!eof() .and. SE1->E1_CLIENTE<=cFornAte'
   Case aReturn[8] == 2            // Natureza 
        dbSetOrder(3)
        dbSeek(xFilial()+cNatDe,.T.)
        mKey := 'cNaturez==NATUREZ'
        cDescTot := 'cNaturez + '-'+ cNomNat'
        cOrd := '(por Natureza)'
        lAte := '!eof() .and. SE1->E1_NATUREZ<=cNatAte'
   Case aReturn[8] == 3            // Vencimento
        dbSetOrder(7)
        dPes := dVencDe - 5
        dbSeek(xFilial()+dTos(dPes),.T.)
        mKey := 'dVencto==VENCTO'
        cDescTot := 'DToC(dVencto)'
        cOrd := '(por Vencimento)'
        lAte := '!eof() .and. SE1->E1_VENCTO<=dVencAte+5'
   Case aReturn[8] == 4           // Por Portador
        dbSetOrder(4)
        dbSeek(xFilial()+cPortDe,.T.)
        mKey := 'cPortado==PORTADO'
        cDescTot := 'cPortado + '-' + cNomPort'
        cOrd := '(por Portador)'
        lAte := '!eof() .and. SE1->E1_PORTADO<=cPortAte'
   Case aReturn[8] == 5            // Emissao
        dbSetOrder(6)
        dbSeek(xFilial()+dTos(dEmisDe),.T.)
        mKey := 'dEmissao==EMISSAO'
        cDescTot := 'DToC(dEmissao)'
        cOrd := '(por Emissao)'
        lAte := '!eof() .and. SE1->E1_EMISSAO<=dEmisAte'
   Case aReturn[8] == 6            // Baixa
        dbSetOrder(13)
        dbSeek(xFilial()+dTos(dBaixaDe),.T.)
        mKey := 'dBaixa==BAIXA'
        cDescTot := 'DToC(dBaixa)'
        cOrd := '(por Data de Baixa)'
        lAte := '!eof() .and. SE1->E1_BAIXA<=dBaixaAte'
ENDCASE

DO CASE
   CASE cTipo == 1
        CondTipo := 'Empty(E1_BAIXA)'
        vRelat   := 'A RECEBER'
        dBaixaDe := ctod("  /  /  ")
   CASE cTipo == 2
        CondTipo := '!Empty(E1_BAIXA)'  
        vRelat   := 'RECEBIDOS'
   CASE cTipo == 3
        CondTipo := 'E1_BAIXA >= cTod("  /  /  ")'
        vRelat   := 'GERAL'
        dBaixaDe := ctod("  /  /  ")
ENDCASE  


mFiltro := ;
      'cNatDe <= E1_NATUREZ .and. cNatAte >= E1_NATUREZ .and. ' + ;
      'dVencDe<= E1_VENCTO  .and. dVencAte>= E1_VENCTO .and.  ' + ;
      'cPortDe<= E1_PORTADO .and. cPortAte>= E1_PORTADO .and. ' + ;
      'cFornDe<= E1_Cliente .and. cFornAte>= E1_Cliente .and. ' + ;
      'dEmisDe<= E1_EMISSAO .and. dEmisAte>= E1_EMISSAO .and. ' + ;
      'dBaixaDe<= E1_BAIXA  .and. dBaixaAte>= E1_BAIXA .and. ' + CondTipo

PROCESSA({||ATUALIZA()})// Substituido pelo assistente de conversao do AP5 IDE em 30/03/01 ==> PROCESSA({||EXECUTE(ATUALIZA)})


dbSelectArea('TMP')

DO CASE
   Case aReturn[8] == 1            // Cliente
        Index on Cliente+dtos(Vencto) to (cArqTemp)
   Case aReturn[8] == 2            // Natureza 
        Index on Naturez+Cliente+dtos(Vencto) to (cArqTemp)
   Case aReturn[8] == 3            // Por Numero
        Index on Parcela+dtos(Vencto)+dtos(Emissao) to (cArqTemp)
   Case aReturn[8] == 4            // Vencimento
        Index on dtos(Vencto)+Cliente+Doc to (cArqTemp)
   Case aReturn[8] == 5            // Por Portador
        Index on Portado+dtos(Vencto) to (cArqTemp)
   Case aReturn[8] == 6            // Emissao
        Index on dtos(Emissao)+Cliente+Doc+Parcela to (cArqTemp)
   Case aReturn[8] == 7            // Baixa
        Index on dtos(Baixa)+Cliente+Doc+Parcela to (cArqTemp)
ENDCASE

Set Device to Print
@ 0,0 PSAY Chr(15)
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impress„o dos dados                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nLastKey == 27
   Return Nil
Endif

ImpRel() //-- Chamada do Relatorio.

dbSelectArea('TMP')
dbCloseArea ()
cArqTemp2 := cArqTemp + '.DBF'
Delete File &cArqTemp2
cArqTemp2 := cArqTemp + '.NTX'
Delete File &cArqTemp2

dbSelectArea('SED')
dbSetOrder(nSEDOrd)
dbSelectArea('SA6')
dbSetOrder(nSA6Ord)
dbSelectArea('SA1')
dbSetOrder(nSA1Ord)
dbSelectArea('SE1')
dbSetOrder(nSE1Ord)

dbSelectArea(cArea)
dbSetOrder(cInd)
dbGoto(nRec)

SET SOFTSEEK OFF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impress„o do rodap‚                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF li != 80
   roda(cbcont,cbtxt,'M')
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Tela e Set's                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Set Device To Screen


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impress„o em Disco, chama SPOOL                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5] == 1
   Set Printer TO 
   Commit
   ourspool(wnrel)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relat¢rio para Spool da Rede               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MS_FLUSH()

******************************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 30/03/01 ==> Function ImpRel
Static Function ImpRel()

dbSelectArea('TMP')
dbgotop()

mtemreg := .f.

If cVar_TipoRel == 1
   Cabec1 := 'Titulo/P   Cliente                         Por/Cobranca           Emissao   Vencimen     Baixa       Valor R$   Historico'
  Else
   Cabec1 := 'Totalizadores                                                                Vencidos               A Vencer       Valor Original' 
Endif

*           999999/9 xxxxxXXXXXxxxxxXXXXXxxxxx 999999-xxxxxXXXXXxxxxxXXXXXxxxxx 999-xxxxxXXXXXxxxxxXXXXX 99/99/99 99/99/99 9,999,999.99 9999
*           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                     1         2         3         4         5         6         7         8         9         0         1         2         3  
Cabec2 := ' '

Titulo  :='RELATORIO DE TITULOS '+vRelat
Titulo  := Titulo + ' ' + cOrd + ' - ' + cAnaSin
mtemreg := .t.

SetRegua(RecCount()) //-- Total de elementos da regua.

While !eof()

   IncRegua()  //-- Move a regua.

   cCliente := Cliente
   SA1->(dbSeek(xFilial()+cCliente))
   cNomFor  := LEFT(SA1->A1_NREDUZ,25)
   cNaturez := NATUREZ
   SED->(dbSeek(xFilial()+cNaturez))
   cNomNat  := SED->ED_DESCRIC
   cNumero  := DOC
   dVencto  := VENCTO
   dBaixa   := BAIXA
   cPortado := PORTADO
   cSitua   := SITUACA
   SA6->(dbSeek(xFilial()+cPortado))
   cNomPort := LEFT(SA6->A6_NREDUZ,20)
   dEmissao := EMISSAO
   SX5->(dbSeek(xFilial()+"07"+cSitua))
   cX5DESCRI := "SX5->X5_DESCRI"
   cNomSit  := &(cX5DESCRI)

   While !eof() .and. &mKey 
      cCliente := Cliente
      SA1->(dbSeek(xFilial()+cCliente))
      cNomFor  := LEFT(SA1->A1_NREDUZ,25)
      cNaturez := NATUREZ
      SED->(dbSeek(xFilial()+cNaturez))
      cNomNat  := SED->ED_DESCRIC
      cNumero  := DOC
      dVencto  := VENCTO
      dBaixa   := BAIXA
      cPortado := PORTADO
      cSitua   := SITUACA
      SA6->(dbSeek(xFilial()+cPortado))
      cNomPort := LEFT(SA6->A6_NREDUZ,20)
      dEmissao := EMISSAO
      SX5->(dbSeek(xFilial()+"07"+cSitua))
      cX5DESCRI := "SX5->X5_DESCRI"
      cNomSit  := &(cX5DESCRI)


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Atualiza barra de Status                         ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
      p_cnt := p_cnt + 1
      p_atu := 3 + int(p_cnt*m_mult)
   
      IF p_atu >= p_ant
         p_ant := p_atu
      Endif

      if mContLin > 55
//         ImpCabc()
        Cabec(Titulo,Cabec1,Cabec2,'CRECEB','M',15)
         mContLin := 8
      endif   

      mtemreg := .t.
      If cVar_TipoRel == 1
         @ mContLin,00  PSAY Doc+'/'+Parcela
         @ mContLin,11  PSAY Alltrim(Cliente)+'-'+Substr(cNomFor,1,26)
         @ mContLin,43  PSAY cPortado+"/"+SUBSTR(cNomSit,1,16)
         @ mContLin,65  PSAY Emissao
         @ mContLin,76  PSAY Vencto
         @ mContLin,87  PSAY Baixa
         @ mContLin,96  PSAY Valor  picture '@E 99,999,999.99'
         @ mContLin,112 PSAY Subs(Hist,1,28)
         mContLin := mContLin+1
      Endif
      mVencidos:= mVencidos+ iif(Vencto<dDataBase,VALOR,0) // Valor Vencidos
      mQt_Venc := mQt_Venc + iif(Vencto<dDataBase,1,0)     // Quant Vencidos
      mT_Vencid:= mT_Vencid + iif(Vencto<dDataBase,VALOR,0) // Tot.Vencid.
      mT_QtVenc:= mT_QtVenc+ iif(Vencto<dDataBase,1,0)      // Qt Tot Vencid
      mvl_tot1 := mvl_tot1 + VALOR                         // Tot Vlr Original
      mvl_dia1 := mvl_dia1 + VALOR                         // Vlr Original
      mvl_titu := mvl_titu + 1                             // Qt Titulos
      mVl_Mes  := mVl_Mes  + VALOR                         // Vl Orig. Mes
      mQt_Mes  := mQt_Mes  + 1                             // Qt Titu Mes
      mTotTitu := mTotTitu + 1                             // Qt tot Titulos
      mMesAtu := month(iif(aReturn[8]==4,VENCTO,EMISSAO))
      DbSkip()
   Enddo

   mMesAnt := month(iif(aReturn[8]==4,VENCTO,EMISSAO))

   If mvl_dia1 <> 0
      If cVar_TipoRel == 1
          @ mContLin,000 PSAY repl('.',132)
          mContLin := mContLin + 1       
      Endif
//      IF aReturn[8] == 3
//          @ mContLin,000 PSAY 'Total: ' + Alltrim(vCusto)+' - '+vCC
//      ELSE
          @ mContLin,000 PSAY 'Total: ' + &cDescTot
//      ENDIF
//      @ mContLin,000 PSAY 'Total: ' + IIF(aReturn[8]==3,Alltrim(vCusto)+' - '+vCC,&cDescTot)
      IF cVar_TipoRel == 1
         @ mContLin,096 PSAY Transform(mvl_dia1,'@E 99,999,999.99')
         @ mContlin,112 PSAY '( ' +  Alltrim(Str(mvl_titu)) + ' Titulo'+IF(mvl_titu>1,'s )',' )')
//         @ mContLin,096 PSAY Transform(mvl_dia1,'@E 99,999,999.99')
//         @ mContlin,112 PSAY '( ' +  Alltrim(Str(mvl_titu)) + ' Titulo'+IF(mvl_titu>1,'s )',' )')
       Else
          @ mContLin,116 PSAY Transform(mvl_dia1,'@E 99,999,999.99')
      ENDIF
      mAVencer := mVl_dia1 - mVencidos
      mQt_Aven := mvl_titu - mQt_Venc 
      If cVar_TipoRel == 2
*         mContLin := mContLin + 1
      Endif
  
*      IF cTipo == 1
*         If cVar_TipoRel == 1
*            @ mContLin,047 PSAY tran(mVencidos,'@E 999,999.99')
*            @ mContLin,047 PSAY tran(mVencidos,'@E 999,999.99')
*            @ mContLin,070 PSAY tran(mAVencer ,'@E 999,999.99')
*            @ mContLin,070 PSAY tran(mAVencer ,'@E 999,999.99')
*          Else
*            @ mContLin,076 PSAY tran(mVencidos,'@E 999,999.99')
*            @ mContLin,076 PSAY tran(mVencidos,'@E 999,999.99')
*            @ mContLin,099 PSAY tran(mAVencer ,'@E 999,999.99')
*            @ mContLin,099 PSAY tran(mAVencer ,'@E 999,999.99')
*         Endif
*      ENDIF

*      If cVar_TipoRel == 1 
*         mContLin := mContLin + 1       
*         @ mContLin,000 PSAY repl('.',132)
*      Endif
      mAVencer := 0
      mVencidos:= 0
      mQt_AVen := 0
      mQt_Venc := 0
      mvl_titu := 0
      mvl_dia1 := 0
      mdesdia  :=0
      mContLin := mContLin + 2
   Endif

   If (aReturn[8] == 4 .or. aReturn[8] == 6) .AND. mMesAnt #mMesAtu
      @ mContLin,000 PSAY ' *** Total no Mes ' + strzero(mMesAtu,2)
      @ mContlin,112 PSAY '( ' + Alltrim(Str(mQt_Mes)) + ' Titulos )'
      @ mContLin,000 PSAY ' *** Total no Mes ' + strzero(mMesAtu,2)
      @ mContlin,112 PSAY '( ' + Alltrim(Str(mQt_Mes)) + ' Titulos )'

      If cVar_TipoRel == 1
         @ mContLin,096 PSAY mVl_Mes  picture '@E 99,999,999.99'
       Else
         @ mContLin,116 PSAY mVl_Mes  picture '@E 99,999,999.99'               
      Endif
      
      mVl_Mes  := 0
      mJur_Mes := 0
      mQt_Mes  := 0
      mMesAtu  := month(iif(aReturn[8]==4,VENCTO,EMISSAO))
      mMesAnt  := month(iif(aReturn[8]==4,VENCTO,EMISSAO))
      mContLin := mContLin + 1
      @ mContLin,000 PSAY repl('.',132)
      mContLin := mContLin + 1
   Endif
  
enddo      

if mtemreg 
      mContLin := mContLin + 1      
      @ mContLin,000 PSAY repl('-',132)
      mContLin := mContLin + 1
      @ mContLin,000 PSAY ' *** Total Geral'
      @ mContLin,000 PSAY ' *** Total Geral'
      If cVar_TipoRel == 1
         @ mContLin,096 PSAY Transform(mvl_tot1,'@E 99,999,999.99')
       Else
         @ mContLin,116 PSAY Transform(mvl_tot1,'@E 99,999,999.99')
      Endif      
      mContLin := mContLin + 1
      @ mContLin,000 PSAY repl('-',132)
      mContLin := mContLin + 1
      
      IF cTipo == 1
         @ mContLin,000 PSAY 'Total Geral de Titulos Vencidos ('+strzero(mT_QtVenc,5)+')'
         If cVar_TipoRel == 1
            @ mContLin,96 PSAY mT_Vencid picture '@EZ 99,999,999.99'
           Else
            @ mContLin,116 PSAY mT_Vencid picture '@EZ 99,999,999.99'
         Endif
         mContLin := mContLin + 1
         mT_QtAven:= mTotTitu - mT_QtVenc
         mT_AVenc := mvl_tot1 - mT_Vencid
         @ mContLin,000 PSAY 'Total Geral de Titulos A Vencer ('+strzero(mT_QtAven,5)+')'
         If cVar_TipoRel == 1
            @ mContLin,96 PSAY mT_AVenc picture '@E 99,999,999.99'
         Else
            @ mContLin,116 PSAY mT_AVenc picture '@E 99,999,999.99'    
         Endif
         mContLin := mContLin + 1
         @ mContLin,000 PSAY repl('-',132)

      ENDIF
endif   

***************************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 30/03/01 ==> Function ImpCabc
Static Function ImpCabc()

      @ 01,000 PSAY REPL("*",132)
      @ 02,000 PSAY "* "+SM0->M0_NOME+" - "+SM0->M0_FILIAL
      @ 02,117 PSAY "Folha..: " + strzero(m_pag,6) + "   *"
      @ 03,000 PSAY "* SIGA/CRECEB - " + cVersao
      @ 03,(140-len(titulo))/2 PSAY Titulo
      @ 03,117 PSAY "Dt.Ref.: " + dtoc(dDataBase) + " *"
      @ 04,000 PSAY "* Hora...: " + Time()
      @ 04,117 PSAY "Emissao: " + dtoc(Date()) + " *"
      @ 05,000 PSAY repl("*",132)
      @ 06,000 PSAY cCabec1
      @ 06,000 PSAY cCabec1
      @ 07,000 PSAY repl("-",132)
      m_pag := m_pag + 1
RETURN

// Substituido pelo assistente de conversao do AP5 IDE em 30/03/01 ==> FUNCTION ATUALIZA
Static FUNCTION ATUALIZA()
ProcRegua(RecCount())

While &lAte
   IncProc()
   If &mFiltro
      dbSelectArea('TMP')
      RecLock('TMP',.t.)
      Repl Doc     with SE1->E1_num
      Repl Parcela with SE1->E1_parcela
      Repl Portado with SE1->E1_portado
      Repl Situaca with SE1->E1_situaca      
      Repl Naturez with SE1->E1_naturez
      Repl Cliente with SE1->E1_Cliente
      Repl Emissao with SE1->E1_emissao
      Repl Vencto  with SE1->E1_vencto
      Repl Baixa   with SE1->E1_Baixa
      Repl Valor   with SE1->E1_valor
      Repl Perman  with iif(dDataBase>SE1->E1_vencto,dDataBase-SE1->E1_vencto,0)
      Repl Hist    with SE1->E1_hist
   Endif
   dbSelectArea('SE1')
   dbSkip()
End
RETURN
