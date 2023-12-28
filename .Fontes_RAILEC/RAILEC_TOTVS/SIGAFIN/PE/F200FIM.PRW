/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun+.o    ?F200FIM ?Autor ?Rafael Almeida(SIGACORP)?Data ?15.01.18 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri+.o ?Ponto de Entrada executado após gravar a linha de lançamento³±?
±±?         ?contábil no arquivo de contra-prova.                        ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ?Especifico .                                                ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F200FIM()
Local _lCNABDayc    := GetNewPar("AL_CNBDAYC",.T.)		// Parametro que indica se a rotina esta ativa
//Local cArqTemp 

If _lCNABDayc
	If	Select('CNABE5') > 0 //__lRetCnab == "1"
		Dbselectarea("CNABE5")
		dbGoTop()
		While CNABE5->(!Eof()) //.AND. ALLTRIM(CNABE5->CB_E5IDAR) == ALLTRIM(__cIdArq) .AND. ALLTRIM(CNABE5->CB_E5ARQ) == ALLTRIM(__cArq)
			cQry := " "
			cQry += "UPDATE "+RetSQLName("SE5")+" "
			cQry += "SET E5_CONTA    = '"+CNABE5->CB_E5NEWC+"' "
			cQry += "WHERE E5_FILIAL = '"+xFilial("SE5")+"' "
			cQry += "AND E5_PREFIXO  = '"+CNABE5->CB_E5PREF+"' "
			cQry += "AND E5_NUMERO   = '"+CNABE5->CB_E5NUM+"' "
			cQry += "AND E5_PARCELA  = '"+CNABE5->CB_E5PARC+"' "
			cQry += "AND E5_CLIFOR   = '"+CNABE5->CB_E5CLIE+"' "
			cQry += "AND E5_LOJA     = '"+CNABE5->CB_E5LOJA+"' "
			cQry += "AND E5_BANCO    = '"+CNABE5->CB_E5BANC+"' "
			cQry += "AND E5_CONTA    = '"+CNABE5->CB_E5CONTA+"' "
			cQry += "AND E5_RECPAG   = 'R' "
			cQry += "AND D_E_L_E_T_  = ''  "
			TcSqlExec(cQry)
			TcSqlExec("COMMIT")
         
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//?Atualiza saldo bancario.      ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			AtuSalBco(CNABE5->CB_E5BANC,CNABE5->CB_E5AGEN,CNABE5->CB_E5CONTA,CNABE5->CB_E5DTPG,CNABE5->CB_E5VLR,"-")
			AtuSalBco(CNABE5->CB_E5BANC,CNABE5->CB_E5AGEN,CNABE5->CB_E5NEWC ,CNABE5->CB_E5DTPG,CNABE5->CB_E5VLR,"+")			

			CNABE5->(DbSkip())
		End
		DbCloseArea()

		cDbf := _cArqTemp + ".dtc"
		cCdx := _cArqTemp + ".cdx"

		If file(cDbf)
			fErase(cDbf)
			fErase(cCdx)
		EndIf		

	EndIf
EndIf

//__lRetCnab := ""
__cIdArq   := ""
__cArq     := ""

Return
