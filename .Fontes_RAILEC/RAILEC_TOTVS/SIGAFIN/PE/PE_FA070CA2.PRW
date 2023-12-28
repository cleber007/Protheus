#Include 'Protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA070CHK  º Autor ³ Rafael Almeida     º Data ³  21/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao³ O ponto de entrada FA070CHK sera executado na entrada da    º±±
±±º         ³funcao antes de carregar a tela de baixa do contas a receber º±±
±±º         ³Obsjetivo é Solicitar a Aprovação da Baixa.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ATFA030                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/           
User Function FA070CA4()   

Local aArea    := GetArea()
Local _ret := .t.
//Rafael Almeida - SIGACORP (28/07/2015)  ATENDER A PA38_CTFIN33
Local _rdEmiss  	:=  ""
Local _rcPref 		:=  ""
Local _rcNum 		:=  ""
Local _rcParc		:=  ""
Local _rcTip 		:=  ""
Local _rcClie 		:=  ""
Local _rcLoj 		:=  ""
Local _rcNomCli	:=  ""
Local _rnVal  		:=  0
Local _rnJur 		:=  0
Local _rnMult 		:=  0
Local _rnDesc 		:=  0
Local _rnVlAcres	:=  0
Local _rnVlDecres	:=  0
Local _rdVencto 	:=  Space(8)
Local _rdVenRea 	:=  Space(8)
Local _rcHist		:=  ""
Local _rdBaixa		:=  ""
Local _rnRecno		:=  0
Local _rnSeq		:=	 ""
Local _rcHstTmp	:=  ""
Local _rcUser		:=  "" 
Local _rRotina		:=	 ""
Local _rSaldo		:=  0
Local cUpdate		:= ""
Local cNomeUsr    := ""
Local _rcMtDesc   := ""
//FIM - Rafael Almeida - SIGACORP (28/07/2015)
DBSELECTAREA("SB1")
_rcUser := RetCodUsr() 
cNomeUsr := UsrRetName(_rcUser)

//Rafael Almeida - SIGACORP (28/07/2015) PA38_CTFIN33 - Ira alimentar tabela temporaria
_rdEmiss  	:=  SE5->E5_DTDIGIT
_rcPref 		:=  SE5->E5_PREFIXO
_rcNum 		:=  SE5->E5_NUMERO
_rcParc		:=  SE5->E5_PARCELA
_rcTip 		:=  SE5->E5_TIPO
_rcClie 		:=  SE5->E5_CLIFOR
_rcLoj 		:=  SE5->E5_LOJA
_rcNomCli	:=  SE5->E5_BENEF
_rnVal  		:=  SE5->E5_VALOR
_rnJur 		:=  SE5->E5_VLJUROS
_rnMult 		:=  SE5->E5_VLMULTA
_rnDesc 		:=  SE5->E5_VLDESCO
_rnVlAcres	:=  SE5->E5_VLACRES
_rnVlDecres	:=  SE5->E5_VLDECRE
_rdVencto 	:=  SE5->E5_DTDISPO
_rdVenRea 	:=  SE5->E5_DTDISPO
_rcHist		:=  SE5->E5_HISTOR
_rdBaixa		:=  SE5->E5_DATA
_rnRecno		:=	 SE5->(Recno())
_rcHstTmp	:= "INFORMAÇÕES DO TITULO DEPOIS DA CONFIRMAÇÃO DO CANCELAMENTO DA BAIXA"
_rRotina		:=	 "EX" 
_rSaldo		:=  0

//U_HSTFIN070(_rdEmiss, _rcPref, _rcNum, _rcParc, _rcTip, _rcClie, _rcLoj, _rcNomCli, _rnVal, _rnJur, _rnMult, _rnDesc, _rnVlAcres, _rnVlDecres, _rdVencto, _rdVenRea, _rcHist, _rdBaixa, _rnRecno, _rcHstTmp, _rcUser, _rRotina, _rSaldo)


		cUpdate := " "
		cUpdate += " UPDATE "+RetSQLName("ZTC")+" "
		cUpdate += " SET ZTC_STATUS = 'EX' "		
		cUpdate += " , ZTC_DATA    = 	'" + DTOS(dDataBase)	  +"'  "		
		cUpdate += " , ZTC_USER    = 	'" + Alltrim(_rcUser)  +"' "
		cUpdate += " , ZTC_USRNAM  = 	'" + Alltrim(cNomeUsr) +"' "
		cUpdate += " , ZTC_HORA    = 	'" + Alltrim(SubStr(Time(),1,5))	  +"' "						
		cUpdate += " WHERE ZTC_FILIAL          = 	'" + xFilial("ZTC")    +"' AND "
		cUpdate += " RTRIM(LTRIM(ZTC_NUM))     = 	'" + Alltrim(_rcNum)	  +"' AND "
		cUpdate += " RTRIM(LTRIM(ZTC_PREFIX))  = 	'" + Alltrim(_rcPref)  +"' AND "
		cUpdate += " RTRIM(LTRIM(ZTC_TIPO))    = 	'" + Alltrim(_rcTip)	  +"' AND "
		cUpdate += " RTRIM(LTRIM(ZTC_CLIENT))  = 	'" + Alltrim(_rcClie)  +"' AND " 
		cUpdate += " RTRIM(LTRIM(ZTC_LOJA))    = 	'" + Alltrim(_rcLoj)	  +"' AND "
		cUpdate += " RTRIM(LTRIM(ZTC_PARCEL))  = 	'" + Alltrim(_rcParc)  +"' AND "
		cUpdate += " ZTC_VALOR                 = 	'" + Alltrim(STR(_rnVal)) +"' AND "		
		cUpdate += " ZTC_STATUS            = 	'LB' AND  "
		cUpdate += " D_E_L_E_T_ <> '*' "
		TcSqlExec(cUpdate)
		TcSqlExec("COMMIT")

//FIM - Rafael Almeida - SIGACORP (28/07/2015)

RestArea(aArea)
Return(_ret)   