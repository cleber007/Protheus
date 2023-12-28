// +-----------+---------------+------------------------------------+------------------+
// | Programa  | F200VAR.PRW   | Autor: Luiz Sousa                  | Data: 30/09/2016 |
// +-----------+---------------+------------------------------------+------------------+
// | Descricao | PE do CNAB a receber utilizado para alterar os dados recebidos.       |
// +-----------+--------------------------------------------------+--------------------+
// | Uso       | CNAB (Arquivo de Retorno) - ALUBAR               |Dt. Atu: 18/08/2017 |
// +-----------+--------------------------------------------------+--------------------+

#INCLUDE "rwmake.ch"
#include "fileio.ch"

///////////////////////
User Function F200VAR()
///////////////////////

	Local _aArea    := GetArea()
//Local _aValores := ParamIxb[01]
	Local _cLinha   := PARAMIXB[01][16]
	Local _cFuncao  := FunName()
	Local _dDtCredi := MV_PAR18
	Local _cTitulo  := ""
	Local _cBanco   := ""
	Local _lCNABDayc    := GetNewPar("AL_CNBDAYC",.T.)
	Local _cFncCNBDyc   := GetNewPar("AL_DAYCFNC","FINA740/FINA200")
	Local __cBanco      := ALLTRIM(MV_PAR06)
	Local __cAgencia    := ALLTRIM(MV_PAR07)
	Local __cConta      := ALLTRIM(MV_PAR08)
	Local __cClient     := GetAdvFVal("SE1","E1_CLIENTE",xFilial("SE1")+SubStr(PARAMIXB[1][16], 38,3)+SubStr(PARAMIXB[1][16], 41,9)+SubStr(PARAMIXB[1][16], 50,2) ,1)
	Local __cLoja       := GetAdvFVal("SE1","E1_LOJA",xFilial("SE1")+SubStr(PARAMIXB[1][16], 38,3)+SubStr(PARAMIXB[1][16], 41,9)+SubStr(PARAMIXB[1][16], 50,2) ,1)
	Local __cPrfx       := SubStr(PARAMIXB[1][16], 38,3)
	Local __cNum		:= SubStr(PARAMIXB[1][16], 41,9)
	Local __cParc       := SubStr(PARAMIXB[1][16], 50,3)
	Local _nVlrCNB      := PARAMIXB[1][8]
	Local _dDtPagt      := PARAMIXB[1][2]
	Local __cFunCnab    := FunName()
	Local cUpd          := " "
	Public __cIdArq     := ""
	Public __cArq       := ""

	If !(__cBanco $ "104")

		_cBanco := SEE->EE_CODIGO

//--> Verifica Numero do Titulo
		IF (_cBanco != "001")	//--> BRASIL
			_cTitulo := Substr(_cLinha,38,14)
		ELSE
			_cTitulo := Substr(_cLinha,59,14)
		ENDIF

		IF !EMPTY(_cTitulo)
			cNumTit := _cTitulo
		ENDIF

//--> Validar banco
		IF (_cBanco == "422")	//--> SAFRA
			nValRec := nValRec + SA6->A6_TXCOBSI
		ENDIF
		IF (_cBanco == "707")	//--> DAYCOVAL
			nValRec := nValRec + SA6->A6_TXCOBSI
		ENDIF

//--> Verifica data 
		IF _cFuncao $ "FINA740|FINA200|FINR650"
			IF (_cBanco == "707")	//--> DAYCOVAL
				dBaixa := DDATABASE
			ELSE
				IF !EMPTY(_dDtCredi)
					dDataCred := _dDtCredi
					dBaixa    := _dDtCredi
					dCred     := _dDtCredi
				ENDIF
			ENDIF

			nDespes := 0	//--> Remove as Despesas a Pagar
		ENDIF

		If _lCNABDayc
			//Public __lRetCnab := "0" //22/02/18 - Fabio Yoshioka
			If MV_PAR06 == "707"  .And.  __cFunCnab $ _cFncCNBDyc
				If SubStr(PARAMIXB[1][16],108, 1) == "1"
					//Public __lRetCnab := "1"  //variavel nao mais valida o conteudo
					//__lRetCnab := "1" //variavel nao mais valida o conteudo
					__cIdArq     := Str(MsCrc32(uLeTrailler(MV_PAR04) ),10)
					__cArq       := ALLTRIM(SUBSTR( MV_PAR04,RAT("\",MV_PAR04) +1))

					//+-----------------------------------------------------------+
					// Estrutura do Arquivo Temporario
					if Select('CNABE5') > 0 // Existe a tabela

					else
						aStru := {}
						aadd(aStru , {'CB_E5FIL'  ,'C',02,0} )
						aadd(aStru , {'CB_E5CLIE' ,'C',06,0} )
						aadd(aStru , {'CB_E5LOJA' ,'C',02,0} )
						aadd(aStru , {'CB_E5PREF' ,'C',03,0} )
						aadd(aStru , {'CB_E5NUM'  ,'C',09,0} )
						aadd(aStru , {'CB_E5PARC' ,'C',02,0} )
						aadd(aStru , {'CB_E5BANC' ,'C',03,0} )
						aadd(aStru , {'CB_E5AGEN' ,'C',05,0} )
						aadd(aStru , {'CB_E5CONTA','C',10,0} )
						aadd(aStru , {'CB_E5NEWC' ,'C',10,0} )
						aadd(aStru , {'CB_E5IDAR' ,'C',10,0} )
						aadd(aStru , {'CB_E5ARQ'  ,'C',40,0} )
						aadd(aStru , {'CB_E5DTPG' ,'D',08,0} )
						aadd(aStru , {'CB_E5VLR'  ,'N',17,2} )

						//Public _cArqTemp := CriaTrab(aStru , .t.)  //Criando como publica
						//dbUseArea(.T.,,_cArqTemp,'CNABE5',.f.)
						//INDEX ON CB_E5FIL+CB_E5CLIE+CB_E5LOJA+CB_E5PREF+CB_E5NUM+CB_E5PARC TO &_cArqTemp

						oGetTab := FWTemporaryTable():New("CNABE5",)
						oGetTab:SetFields(aStru)
						oGetTab:AddIndex("01", {"CB_E5FIL","CB_E5CLIE","CB_E5LOJA","CB_E5PREF","CB_E5NUM","CB_E5PARC"} )
						oGetTab:Create()
					Endif

					DBSELECTAREA("CNABE5")
					RECLOCK("CNABE5",.T.)
					CB_E5FIL   := "01"
					CB_E5CLIE  := __cClient
					CB_E5LOJA  := __cLoja
					CB_E5PREF  := __cPrfx
					CB_E5NUM   := __cNum
					CB_E5PARC  := __cParc
					CB_E5BANC  := __cBanco
					CB_E5AGEN  := __cAgencia
					CB_E5CONTA := __cConta
					CB_E5NEWC  := "716336"
					CB_E5IDAR  := __cIdArq
					CB_E5ARQ   := __cArq
					CB_E5DTPG  := _dDtPagt
					CB_E5VLR   := _nVlrCNB
					MSUNLOCK()

					cUpd := " "
					cUpd += "UPDATE "+RetSQLName("SE1")+" "
					cUpd += "SET E1_CTCNAB     = '1' "
					cUpd += "WHERE E1_FILIAL  = '"+xFilial("SE1")+"' "
					cUpd += "AND E1_PREFIXO   = '"+__cPrfx+"'   "
					cUpd += "AND E1_NUM       = '"+__cNum+"'    "
					cUpd += "AND E1_PARCELA   = '"+__cParc+"'   "
					cUpd += "AND E1_CLIENTE   = '"+__cClient+"' "
					cUpd += "AND E1_LOJA      = '"+__cLoja+"' "
					cUpd += "AND D_E_L_E_T_   = ''  "
					TcSqlExec(cUpd)



				EndIf
			EndIf
		EndIf
	EndIf

	RestArea(_aArea)

RETURN
//////////////////////////////////////////////////////////////////////////////////////////
// +-----------+---------------+------------------------------------+------------------+
// | Programa  | F200VAR.PRW   | Autor: Rafael Almeida              | Data: 16/04/2018 |
// +-----------+---------------+------------------------------------+------------------+
// | Descricao |  as ultimas linhas do arquivo texto para gerar checksum.              |
// +-----------+--------------------------------------------------+--------------------+
// | Uso       | CNAB (Arquivo de Retorno) - ALUBAR               |Dt. Atu: 18/08/2017 |
// +-----------+--------------------------------------------------+--------------------+

Static Function uLeTrailler(cArqCNAB)
	Local cRet		:= ""
	Local cBuffer	:= Space(402)
	Local nOffSet	:= 0 //fSeek(nHdlBco,0,FS_RELATIVE) // Sera utilizado para retornar o ponteiro do arquivo a posicao original
	Local nTamArq	:= 0 //fSeek(nHdlBco,0,FS_END) // Obtem o tamanho do arquivo
	Local _nHdlBco  := 0
	Local _cArqREM  := cArqCNAB

	_nHdlBco := FOPEN(_cArqREM)
	nOffSet := fSeek(_nHdlBco,0,FS_RELATIVE)
	nTamArq := fSeek(_nHdlBco,0,FS_END)

	fSeek(_nHdlBco,-804,FS_END) // Volta 804 bytes para compor o CheckSum

// Le o arquivo ate final
	While fReadLn(_nHdlBco,@cBuffer,402)
		cRet += cBuffer
	End

	fSeek(_nHdlBco,nOffSet,FS_SET) // Retorna o ponteiro para a posicao original

Return cRet+Transform(nTamArq,"")
