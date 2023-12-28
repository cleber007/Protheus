// +-----------+--------------+---------------------+--------------------------+
// | Programa  | MA410MNU.PRW | Autor: Luiz Sousa   | Data Criacao: 24/08/2017 |
// +-----------+--------------+---------------------+--------------------------+
// | Descricao | P.E. para Adição de opcao no menu de ações relacionadas do PV |
// +-----------+------------------------------------+--------------------------+
// | Uso       | ALUBAR / COMERCIAL                 | Data Revisao: 05/09/2017 |
// +-----------+------------------------------------+--------------------------+

//-->Bibliotecas
#include "rwmake.ch"


////////////////////////  
User Function MA410MNU()
////////////////////////

Local aArea := GetArea()
Local aRotina2 := {}
     
aADD(aRotina2,{ "Gerar Contrato "     ,"U_GCtrParc"        , 0 , 3, 0 , Nil})	//--> Gera Contrato de Parceria
aADD(aRotina2,{ "Visualizar Contrato ","U_VCtrParc(2,.F.)" , 0 , 2, 0 , Nil})	//--> Visualisa  Contrato de Parceria     

AAdd( aRotina, { "Compl. do Pedido ", "U_ComplPed", 0, 3, 0, Nil } )	//--> Adicionando opcao no menu 
AAdd( aRotina, { "Contrato de Parceria ", aRotina2, 0, 2 } )	//--> Adicionando opcao no menu 
     
RestArea(aArea)

Return
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////  
User Function GCtrParc()
////////////////////////

Local _aArea := GetArea()
Local _cMsg  := "Você deseja gerar um Contrato de Parceria com o pedido "

PRIVATE _cUsuario := UPPER(ALLTRIM(CUSERNAME))
PRIVATE _cMsgTit  := "ATENÇÃO -> " + _cUsuario
PRIVATE _cCodPV   := SC5->C5_NUM 

dbSelectArea("ADA")
dbSetOrder(1) 	//--> ADA_FILIAL+ADA_NUMCTR
If ADA->(dbSeek( xFilial("ADA") + _cCodPV ))
	ApMsgStop("Não vai ser possivel gerar Contrato de Parceria para o PV " + _cCodPV + CHR(13) + CHR(10) + "Por que já existe um Contrato associado ao mesmo.", _cMsgTit)
Else
	If ApMsgNoYes(_cMsg + _cCodPV, _cMsgTit)

	   MsgRun("Gerando Contrato de Parceria...", "Aguarde...",{|| GCPPV() })
		
	EndIf
EndIf

RestArea(_aArea)

Return
////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////
Static Function GCPPV()	//--> Gera Contrato de Parceria com os dados do PV
///////////////////////

Local aCabec   := {}
Local aItens   := {}
Local cCampo   := ""

Local cFilADA  := SC5->C5_FILIAL  
Local cNumOrc  := SC5->C5_NOMORC 	//--> Numero do Orcamento      
Local cNumSC5  := SC5->C5_NUM    	//--> Numero do PV
Local cNumADA  := SC5->C5_NUM    	//--> Numero do Contrato de Parceria
Local dDtEmisC := SC5->C5_EMISSAO
Local cCliente := SC5->C5_CLIENTE
Local cLojaCli := SC5->C5_LOJACLI
Local cNomeCli := SC5->C5_NOMECLI
Local cCodPag  := SC5->C5_CONDPAG
Local cTabela  := SC5->C5_TABELA
Local nVlDesc1 := SC5->C5_DESC1  
Local nVlDesc2 := SC5->C5_DESC2  
Local nVlDesc3 := SC5->C5_DESC3  
Local nVlDesc4 := SC5->C5_DESC4  
Local cCdVend1 := SC5->C5_VEND1
Local cCdVend2 := SC5->C5_VEND2
Local cCdVend3 := SC5->C5_VEND3
Local cCdVend4 := SC5->C5_VEND4 
Local cCdVend5 := SC5->C5_VEND5
Local nVlCVen1 := SC5->C5_COMIS1  
Local nVlCVen2 := SC5->C5_COMIS2
Local nVlCVen3 := SC5->C5_COMIS3
Local nVlCVen4 := SC5->C5_COMIS4
Local nVlCVen5 := SC5->C5_COMIS5
Local nCdMoeda := SC5->C5_MOEDA  
Local cFEntreg := SC5->C5_LOJAENT
Local cTpLiber := SC5->C5_TIPLIB
Local cStatusC := "B"

Local cFilADB  := xFilial("ADB")
Local cItemADB := ""
Local cCodProd := "" 
Local cDscProd := ""
Local cUMADB   := ""
Local nQtContr := 0
Local nPrecoVd := 0
Local nVlTotal := 0
Local cTESADB  := ""
Local cLocalPd := ""
Local cSegUM   := ""
Local nQtSegUM := 0
Local nDescPec := 0
Local nVlDesco := 0
Local nY:= 0


//--> Monta cabecalho do Contrato de Parceria
aCabec:={	{"ADA_FILIAL"	,cFilADA	,Nil},; 	//--> Filial do contrato
			{"ADA_NUMCTR"	,cNumADA	,Nil},; 	//--> Numero do contrato
			{"ADA_NRORCA"	,cNumOrc	,Nil},; 	//--> Numero do Orcamento
			{"ADA_PVENDA"	,cNumSC5	,Nil},; 	//--> Numero do Pedido de Venda        
			{"ADA_EMISSA"  	,dDtEmisC	,Nil},; 	//--> Emissao do contrato      
			{"ADA_CODCLI"	,cCliente	,Nil},; 	//--> Codigo do cliente
			{"ADA_LOJCLI"	,cLojaCli   ,Nil},; 	//--> Loja do cliente
			{"ADA_NOMCLI"	,cNomeCli	,Nil},; 	//--> Nome do cliente          
			{"ADA_CONDPG"	,cCodPag    ,Nil},; 	//--> Codigo da condicao de pagamanto
			{"ADA_TABELA"   ,cTabela  	,Nil},; 	//--> Tabela de Preco    
			{"ADA_DESC1"	,nVlDesc1	,Nil},; 	//--> % Desconto 1             
			{"ADA_DESC2"	,nVlDesc2	,Nil},; 	//--> % Desconto 2
			{"ADA_DESC3"	,nVlDesc3	,Nil},; 	//--> % Desconto 3
			{"ADA_DESC4"	,nVlDesc4	,Nil},; 	//--> % Desconto 4 
			{"ADA_VEND1"	,cCdVend1	,Nil},; 	//--> Codigo do Vendedor 1     
			{"ADA_VEND2"	,cCdVend2	,Nil},; 	//--> Codigo do Vendedor 2
			{"ADA_VEND3"	,cCdVend3	,Nil},; 	//--> Codigo do Vendedor 3
			{"ADA_VEND4"	,cCdVend4	,Nil},; 	//--> Codigo do Vendedor 4
			{"ADA_VEND5"	,cCdVend5	,Nil},; 	//--> Codigo do Vendedor 5
			{"ADA_COMIS1"	,nVlCVen1	,Nil},; 	//--> Comissao do Vendedor 1   
			{"ADA_COMIS2"	,nVlCVen2	,Nil},; 	//--> Comissao do Vendedor 2
			{"ADA_COMIS3"	,nVlCVen3	,Nil},; 	//--> Comissao do Vendedor 3
			{"ADA_COMIS4"	,nVlCVen4	,Nil},; 	//--> Comissao do Vendedor 4
			{"ADA_COMIS5"	,nVlCVen5	,Nil},; 	//--> Comissao do Vendedor 5
			{"ADA_MOEDA"	,nCdMoeda	,Nil},; 	//--> Moeda do Contrato        
			{"ADA_FILENT"	,cFEntreg	,Nil},; 	//--> Filial de Entrega        
			{"ADA_TIPLIB"	,cTpLiber	,Nil},; 	//--> Tipo de liberacao        
			{"ADA_STATUS"  	,cStatusC 	,Nil} }	    //--> Status do Contrato   

//-->  Grava o cabecalho
dbSelectArea("ADA")
dbSetOrder(1)
While !Reclock("ADA",.T.); EndDo
	For nY := 1 TO LEN(aCabec)
	
		cCampo := aCabec[nY,1]
		REPLACE &cCampo WITH aCabec[nY,2] 
 
	Next nY
ADA->(MsUnlock())
		
//--> Grava Itens
dbSelectArea("SC6")
dbSetOrder(1)		//--> C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
If SC6->(dbSeek(cFilADA + cNumSC5 ))
	
	While  !EOF() .AND. SC6->C6_FILIAL == cFilADA .AND. SC6->C6_NUM == cNumSC5   
	
		cFilADB  := cFilADA	
		cItemADB := SC6->C6_ITEM   
		cCodProd := SC6->C6_PRODUTO	
		cDscProd := SC6->C6_DESCRI 
		cUMADB   := SC6->C6_UM     
		nQtContr := SC6->C6_QTDVEN 
		nPrecoVd := SC6->C6_PRCVEN      
		nVlTotal := SC6->C6_VALOR  
		cTESADB  := SC6->C6_TES         
		cLocalPd := SC6->C6_LOCAL     
		cSegUM   := SC6->C6_SEGUM 
		nQtSegUM := SC6->C6_UNSVEN 
		nDescPec := SC6->C6_DESCONT
		nVlDesco := SC6->C6_VALDESC
		
		aAdd(aItens,{})		//--> Monta item do Contrato de Parceria
		aAdd(aTail(aItens)	,{"ADB_FILIAL"	,cFilADB	,Nil}) //--> Filial Item do contrato
		aAdd(aTail(aItens)	,{"ADB_NUMCTR"	,cNumADA	,Nil}) //--> Numero do contrato
		aAdd(aTail(aItens)	,{"ADB_ITEM"	,cItemADB   ,Nil}) //--> Item do Contrato         
		aAdd(aTail(aItens)	,{"ADB_CODPRO"	,cCodProd   ,Nil}) //--> Codigo do Produto
		aAdd(aTail(aItens)	,{"ADB_DESPRO"	,cDscProd	,NIL}) //--> Descricao do Produto
		aAdd(aTail(aItens)	,{"ADB_UM"	    ,cUMADB	    ,Nil}) //--> Unidade de Medida Primaria
		aAdd(aTail(aItens)	,{"ADB_QUANT"	,nQtContr	,Nil}) //--> Quantidade contratada    
		aAdd(aTail(aItens)	,{"ADB_PRCVEN"	,nPrecoVd	,Nil}) //--> Preco de venda           
		aAdd(aTail(aItens)	,{"ADB_TOTAL"	,nVlTotal	,Nil}) //--> Total da venda           
		aAdd(aTail(aItens)	,{"ADB_TES"	    ,cTESADB	,Nil}) //--> Tipo de Entrada e Saida  
		aAdd(aTail(aItens)	,{"ADB_LOCAL"	,cLocalPd	,Nil}) //--> Codigo do armazem        
		aAdd(aTail(aItens)	,{"ADB_SEGUM"	,cSegUM	    ,Nil}) //--> Segunda Unidade de Medida
		aAdd(aTail(aItens)	,{"ADB_UNSVEN"	,nQtSegUM	,Nil}) //--> Qtd. Ctr. na 2nd.Unidade 
		aAdd(aTail(aItens)	,{"ADB_DESC"	,nDescPec	,Nil}) //--> Percentual de desconto   
		aAdd(aTail(aItens)	,{"ADB_VALDES"	,nVlDesco	,Nil}) //--> Valor do desconto        
		aAdd(aTail(aItens)	,{"ADB_CODCLI"	,cCliente	,Nil}) //--> Codigo do cliente        
		aAdd(aTail(aItens)	,{"ADB_LOJCLI"	,cLojaCli	,Nil}) //--> Loja do cliente     

		//--> Grava Item
		dbSelectArea("ADB")
		dbSetOrder(1)
		While !Reclock("ADB",.T.); EndDo
		
			REPLACE ADB->ADB_FILIAL WITH cFilADB
			REPLACE ADB->ADB_NUMCTR WITH cNumADA
			REPLACE ADB->ADB_ITEM   WITH cItemADB
			REPLACE ADB->ADB_CODPRO WITH cCodProd
			REPLACE ADB->ADB_DESPRO WITH cDscProd
			REPLACE ADB->ADB_UM     WITH cUMADB
			REPLACE ADB->ADB_QUANT  WITH nQtContr
			REPLACE ADB->ADB_PRCVEN WITH nPrecoVd
			REPLACE ADB->ADB_TOTAL  WITH nVlTotal
			REPLACE ADB->ADB_TES    WITH cTESADB
			REPLACE ADB->ADB_LOCAL  WITH cLocalPd
			REPLACE ADB->ADB_SEGUM  WITH cSegUM
			REPLACE ADB->ADB_UNSVEN WITH nQtSegUM
			REPLACE ADB->ADB_DESC   WITH nDescPec
			REPLACE ADB->ADB_VALDES WITH nVlDesco
			REPLACE ADB->ADB_CODCLI WITH cCliente
			REPLACE ADB->ADB_LOJCLI WITH cLojaCli
			
		ADB->(MsUnlock())
		
		cItemADB := cCodProd := cDscProd := cUMADB := cTESADB := cLocalPd := cSegUM := ""
		nQtContr := nPrecoVd := nVlTotal := nQtSegUM := nDescPec := nVlDesco := 0
		
		dbSelectArea("SC6")
		SC6->(dbskip())	
	
	EndDo

EndIf

//--> Atualiza SCJ
dbSelectArea("SCJ")
dbSetOrder(1)		//--> CJ_FILIAL+CJ_NUM+CJ_CLIENTE+CJ_LOJA
If SCJ->(dbSeek(xFilial("SCJ")  + cNumOrc ))
	While !Reclock("SCJ",.F.); EndDo
		REPLACE SCJ->CJ_TIPOVEN WITH "V"
	SCJ->(MsUnlock())
EndIf

//--> Atualiza SC5
dbSelectArea("SC5")
dbSetOrder(1)		//--> C5_FILIAL+C5_NUM
If SC5->(dbSeek(xFilial("SC5")  + cNumSC5 ))
	While !Reclock("SC5",.F.); EndDo
		REPLACE SC5->C5_CONTRA  WITH cNumADA
		REPLACE SC5->C5_MDCONTR WITH "CV" + cNumADA
	SCJ->(MsUnlock())
EndIf

//--> Atualiza SC6
dbSelectArea("SC6")
dbSetOrder(1)		//--> C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
If SC6->(dbSeek(xFilial("SC6") + cNumSC5 ))
	While  !EOF() .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == cNumSC5   
		
		While !Reclock("SC6",.F.); EndDo
			REPLACE SC6->C6_CONTRAT WITH cNumADA
			REPLACE SC6->C6_ITEMCON WITH SC6->C6_ITEM
		SCJ->(MsUnlock())
		
		dbSelectArea("SC6")
		SC6->(dbskip())	
		
	EndDo
Endif	

ApMsgInfo( "O Contrato de Parceria número: "  + cNumADA + " Foi Gerado." + CHR(13)+CHR(10) + "Referente ao PV: " + cNumSC5 , _cMsgTit )

	
RETURN
///////////////////////////////////////////////////////////////////////


//////////////////////////////////////////
User Function VCtrParc( nOpc , lAditivo )
//////////////////////////////////////////
Local aArea			:= GetArea()
Local aAreaADA		:= ADA->( GetArea() )
Local aAreaADB		:= ADB->( GetArea() )
//Local cMsgHelp		:= ""
Local cADAFilial	:= xFilial( "ADA" , ADA->ADA_FILIAL ) 
Local cCdContrato	:= SC5->C5_CONTRA
Local cADAKeySeek	:= ( cADAFilial + cCdContrato )	//--> ADA_FILIAL+ADA_NUMCTR
Local lFound		:= .F.
//Local nSC5Recno		:= SC5->( Recno() )
//Local nADAOrder		:= RetOrder( "ADA" , "ADA_FILIAL+ADA_NUMCTR" )
Local cAlias		:= "ADA"
Local uRet
//Local cTypeRet

Private aTela   := {}
Private aGets   := {}
Private nReg    := 0
//Private aRotina	:= StaticCall( FATA400 , MenuDef )

dbSelectArea("ADA")
dbSetOrder(1)
lFound	:= ADA->( dbSeek( cADAKeySeek  , .F. ) )
nReg := ADA->( Recno() )

IF !( lFound ) 
	MSGStop( "Não Existe Contrato Vinculado à esse Pedido. E não é possivel Visualizá-lo" , "ATENÇÃO -> " + UPPER(ALLTRIM(CUSERNAME)) )
	RETURN 
EndIF

IF nOpc = 2
	//aRotina	:= StaticCall( FATA400 , MenuDef )
	uRet	:= Ft400Alter( @cAlias , @nReg , 2 )
EndIF

RestArea( aAreaADA )
RestArea( aAreaADB )
RestArea( aArea )

RETURN
////////////////////////////////////////////////////////////////////////////////////////////////////
			
