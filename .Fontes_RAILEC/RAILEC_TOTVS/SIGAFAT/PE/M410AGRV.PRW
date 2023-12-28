#include 'protheus.ch'

User Function M410AGRV()
Local nyx as numeric
	// aqui eu preciso excluir o empenho

	if isInCallStack("MATA311") .OR. isInCallStack("MATA310")

		aLinProd := aCols

		for nyx := 1 To Len(aLinProd)

			nPosLote := aScan( aHeader, { |x| Alltrim(x[2])=="C6_LOTECTL" } )
			nPosProd   := aScan( aHeader, { |x| Alltrim(x[2])=="C6_PRODUTO" } )
			nPosQtd := aScan( aHeader, { |x| Alltrim(x[2])=="C6_QTDVEN" } )

			cMyPrd := aLinProd[nyx][nPosProd]
			cMyLt := aLinProd[nyx][nPosLote]

			if AllTrim(cMyLt) == "ROLINHOS" .OR. AllTrim(cMyLt) == ""
				loop
			endIf

			If Select("B8USAGE") > 0
				B8USAGE->(DbCloseArea())
			endIf

			BEGINSQL ALIAS 'B8USAGE'
			SELECT C0_NUM,C0_TIPO, C0_QUANT,C0_LOCAL FROM %Table:SC0% 
			WHERE C0_FILIAL=%xfilial:SC0% AND %notdel% AND C0_PRODUTO=%Exp:cMyPrd% AND C0_LOTECTL=%exp:cMyLt%
			ENDSQL

			While B8USAGE->(!Eof())


				aOPERACAO := {3,"PD",B8USAGE->C0_NUM ,CUSERNAME,xFilial("SC0"),"AUTO - PV.: " + B8USAGE->C0_NUM } 
				cNUMERO   := B8USAGE->C0_NUM 
				cPRODUTO := cMyPrd
				cLOCAL    := B8USAGE->C0_LOCAL
				nQUANT    := B8USAGE->C0_QUANT
				aLOTE     := {"",cMyLt,"",""}                                           

				//Alert('Reserva para o produto: ' + cProduto + ' e o lote: ' + TMP1->CK_LOTE)

				lRet := A430Reserv(aOPERACAO,cNUMERO,cPRODUTO,cLOCAL,nQUANT,aLOTE)        
				//Alert('Deveria ter excluido ! ' + IIF(lRet,"Excluiu", "Não fez porra nnehuma") )
				B8USAGE->(DbSkip())
			endDo

		Next

	endIf

Return
