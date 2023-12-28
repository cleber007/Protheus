
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F340GRV ºAutor  Denis Haruo          º Data ³  09/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada ao final da compesaçao do C Pagar               º±±
±±º          ³para gravar dados adicionais                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F340GRV()

	Local cUpdate := ""
	LOCAL _cCondAtu:=RTRIM(GETMV("AL_CONDFIE")) //13/03/18
	Local _aAreaSE4   :=SE4->(Getarea())
	lOCAL _lCleanCond:=.F.

//Alterando o status da viagem para Finalizada!
	cUpdate := ""
	cUpdate += "UPDATE "+RetSQLName("ZV1")+" "
	cUpdate += "SET ZV1_STATUS = '7' "
	cUpdate += "WHERE ZV1_FILIAL = '"+xFilial("ZV1")+"' AND "
	cUpdate += "		ZV1_PREFIX = '"+E2_PREFIXO+"' AND "
	cUpdate += "		ZV1_NUMPA = '"+E2_NUM+"' AND "
	cUpdate += "		D_E_L_E_T_ <> '*' "
	TcSqlExec(cUpdate)
	TcSqlExec("COMMIT")

//Fabio Yoshioka - 13/03/18 - retorno informação de adiantamento após a compensação manual do titulo
	_cQryComp := " SELECT R_E_C_N_O_ AS RECSE4 FROM "+RETSQLNAME("SE4")
	_cQryComp += " WHERE E4_FILIAL='"+XFILIAL("SE4")+"' "
	_cQryComp += " AND D_E_L_E_T_=' '"
	_cQryComp += " AND E4_CODIGO IN "+FormatIn(_cCondAtu,"/")+"     " //13/03/18
	_cQryComp += " ORDER BY R_E_C_N_O_ "
	DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryComp), "TSE4", .F., .T.)
	
	WHILE !TSE4->(EOF())
		DbSelectArea("SE4")
		SE4->(dbGoto(TSE4->RECSE4))
		
		While !Reclock("SE4");Enddo
			_lCleanCond:=.T.
			SE4->E4_CTRADT:='1'
		SE4->(MsUnlock())
		
		TSE4->(DBSKIP())
	Enddo

	TSE4->(DBCLOSEAREA())


	IF _lCleanCond
		PUTMV("AL_CONDFIE","") //13/03/18 - Fabio Yoshioka
	ENDIF

	// Função para verificar se o título está vinculado ao sistema Flash Expense e atualiza o mesmo
	//U_EXONP08T(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,"Pagamento realizado.","5")

	RestArea(_aAreaSE4)

Return()
