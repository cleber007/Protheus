#include 'protheus.ch'
#include 'parmtype.ch'

USER FUNCTION FIN050INC(cNumPC,cCusto)
	LOCAL aArray 	:= {}
	LOcal nValTot 	:= AVALORES[6]
	Local nValPar	:= 0
	Local dEmissao	:= DDATABASE
	Local dDtVencto	:= Ctod("  /  /  ")
	LOcal cNatureza	:= CCODNATU	
	Local cCodFor	:= CA120FORN	
	Local cCond		:= CCONDICAO
	Local aParc 	:= Condicao(nValTot,cCond,,dEmissao)
	Local y:= 0
	PRIVATE lMsErroAuto := .F.

	For y:=1 to len(aParc)

		dDtVencto	:= aParc[y,1]
		nValPar		:= aParc[y,2]

		aArray := { { "E2_PREFIXO"  , "PED"             	, NIL },;
		{ "E2_NUM"      , cNumPC            	, NIL },;
		{ "E2_TIPO"     , "PR"              	, NIL },;
		{ "E2_NATUREZ"  , cNatureza		    	, NIL },;
		{ "E2_CC"  		, cCusto	        	, NIL },;
		{ "E2_FORNECE"  , cCodFor	       		, NIL },;
		{ "E2_EMISSAO"  , DEmissao				, NIL },;
		{ "E2_VENCTO"   , dDtVencto				, NIL },;
		{ "E2_VENCREA"  , dDtVencto				, NIL },;
		{ "E2_PARCELA"  , AllTrim(STR(y,3,0))	, NIL },;
		{ "E2_VALOR"    , nValPar	        	, NIL } }

		FWMsgRun(, {|oSay| Process( oSay ) })

		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

	Next y 

	If lMsErroAuto
		MostraErro()
	Else
		Msgalert("Título incluído com sucesso!","Inclusão")
	Endif

Return

//------------------------------------------------------------------------------------------------------------------------ 

USER FUNCTION FIN050ALT(cNumPC)

	DbSelectArea("SE2")  
	DbSetOrder(6)//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_NUM+E2_PREFIXO+E2_PARCELA+E2_TIPO
	if !DbSeek(xFilial("SE2")+CA120FORN+CA120LOJ+"PED"+cNumPC)
		u_FIN050INC(cNumPC,cCusto)
	else
		u_FIN050EXC(cNumPC)

		u_FIN050INC(cNumPC,cCusto)

	endif
Return

//------------------------------------------------------------------------------------------------------------------------ 

USER FUNCTION FIN050EXC(cNumPC)

	DbSelectArea("SE2")  
	DbSetOrder(6)//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_NUM+E2_PREFIXO+E2_PARCELA+E2_TIPO
	if DbSeek(xFilial("SE2")+CA120FORN+CA120LOJ+"PED"+cNumPC)
		Do While (!Eof() .And. E2_FILIAL==xFilial("SE2") .and. E2_FORNECE==CA120FORN .and. E2_LOJA==CA120LOJ .And. alltrim(E2_NUM)==cNumPC)
			Reclock("SE2",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	EndIf

Return

/*----------------------------------------------------------------------------------------------------------------------*/
Static Function Process( oSay )
	Local nX := 0
	Sleep(2000)
	For nX := 1 to 5
		oSay:cCaption := ('Aguarde, processando a rotina')

		//		oSay:cCaption := ('Contador ' + StrZero(nX, 2))
		ProcessMessages()
		Sleep(1000)
	Next nX
Return
