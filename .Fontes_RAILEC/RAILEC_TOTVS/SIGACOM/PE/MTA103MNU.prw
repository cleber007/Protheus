// +-----------+---------------+---------------------------------+---------------------+
// | Programa  | MTA103MNU.PRW | Autor: Luiz Sousa               | Data: 06/07/2017    |
// +-----------+---------------+---------------------------------+---------------------+
// | Descricao | Ponto de entrada utilizado para inserir novas opcoes no array aRotina.|
// +-----------+-------------------------------------------------+---------------------+
// | Uso       | Documento de Entrada - ALUBAR                   | Dt. Atu: 28/07/2017 |
// +-----------+-------------------------------------------------+---------------------+

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'rwmake.ch'
#INCLUDE 'parmtype.ch'


/////////////////////////
user function MTA103MNU()
/////////////////////////
	
aAdd(aRotina,{ "Gera Pedido Venda", "U_GeraPV", 0 , 2, 0, .F. })	
	
return
///////////////////////////////////////////////////////////////////////


//////////////////////
User Function GeraPV()
//////////////////////

Local aArea   := GetArea()

MsgRun("Gerando Pedido de Venda...", "Aguarde...",{|| GPVenda() })

RestArea(aArea)

RETURN
///////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////
Static Function GPVenda()
/////////////////////////

Local aCabec   := {}
Local aItens   := {}
Local cNumSC5  := ""
Local cCliente := "000001"
Local cLojaCli := "01"
Local cCdVende := "000001"
Local cItemPV  := ""
Local cCodProd := "" 
Local cDscProd := ""
Local cTESProd := ""
Local cLocProd := ""
Local nQtVenda := 0
Local nPrecoUn := 0
Local nVlTotal := 0
Local nUdProdV := 0
Local dDtEntrg := CTOD("  /  /    ")

Private dDtEmiss := SF1->F1_EMISSAO
Private cCodNF   := SF1->F1_DOC
Private cSerieNF := SF1->F1_SERIE
Private cFornec  := SF1->F1_FORNECE
Private cLojaFor := SF1->F1_LOJA
Private cCodPag  := SF1->F1_COND
Private nCdMoeda := SF1->F1_MOEDA
Private cUsuario := UPPER(ALLTRIM(CUSERNAME))

Private lMsErroAuto := .F.

cNumSC5 := GetSXENum("SC5","C5_NUM")	//--> Gera numero do pedido de venda
RollBAckSx8()							//--> Retorna numero no semáforo como pendente

aCabec := {}
aItens := {}

//--> Monta cabecalho do PV
//Efetua montagem do aCabec usado para geracao de pedido de venda
aCabec:={	{"C5_NUM"		,	cNumSC5			,Nil},; 	//--> Numero do pedido
			{"C5_TIPO"   	,	"N"				,Nil},; 	//--> Tipo de pedido
			{"C5_CLIENTE"	,	cCliente	    ,Nil},; 	//--> Codigo do cliente
			{"C5_LOJAENT"	,	cLojaCli	    ,Nil},; 	//--> Loja para entrada
			{"C5_LOJACLI"	,	cLojaCli    	,Nil},; 	//--> Loja do cliente
			{"C5_EMISSAO"	,	dDtEmiss	    ,Nil},; 	//--> Data de emissao
			{"C5_CONDPAG"	,	cCodPag         ,Nil},; 	//--> Codigo da condicao de pagamanto
			{"C5_MOEDA"	    ,	nCdMoeda  	    ,Nil},; 	//--> Moeda
			{"C5_VEND1"  	,	cCdVende 	    ,Nil}} 	    //--> Vendedor


dbSelectArea("SD1")
dbSetOrder(1)		//--> D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
If SD1->(dbSeek(xFilial("SD1") + cCodNF + cSerieNF + cFornec + cLojaFor))
	
	While  !EOF() .AND. xFilial("SD1") == SD1->D1_FILIAL .AND. SD1->D1_DOC == cCodNF .AND. SD1->D1_SERIE == cSerieNF .AND. SD1->D1_FORNECE == cFornec .AND. SD1->D1_LOJA == cLojaFor   
			
		cItemPV  := SD1->D1_ITEM
		cCodProd := SD1->D1_COD	
		cDscProd := POSICIONE("SB1", 1, xFilial("SB1") + cCodProd, "B1_DESC")
		nQtVenda := SD1->D1_QUANT
		nPrecoUn := SD1->D1_VUNIT
		nVlTotal := SD1->D1_TOTAL     
		dDtEntrg := dDtEmiss
		nUdProdV := SD1->D1_UM     
		cTESProd := "501"    
		cLocProd := POSICIONE("SB1", 1, xFilial("SB1") + cCodProd, "B1_LOCPAD")
			
		aAdd(aItens,{}) //Gera item do pedido de venda
		aAdd(aTail(aItens)	,{"C6_NUM"		,cNumSC5	,Nil}) //--> Numero do Pedido
		aAdd(aTail(aItens)	,{"C6_ITEM"		,cItemPV    ,Nil}) //--> Numero do Item no Pedido
		aAdd(aTail(aItens)	,{"C6_PRODUTO"	,cCodProd   ,Nil}) //--> Codigo do Produto
		aAdd(aTail(aItens)	,{"C6_DESCRI"	,cDscProd	,NIL}) //--> Descricao do Produto
		aAdd(aTail(aItens)	,{"C6_QTDVEN"	,nQtVenda	,Nil}) //--> Quantidade Vendida
		aAdd(aTail(aItens)	,{"C6_PRUNIT"	,nPrecoUn	,Nil}) //--> Preco Unitario
		aAdd(aTail(aItens)	,{"C6_PRCVEN"	,nPrecoUn	,Nil}) //--> Preco Unitario Liquido
		aAdd(aTail(aItens)	,{"C6_VALOR"	,nVlTotal	,Nil}) //--> Valor Total do Item
		aAdd(aTail(aItens)	,{"C6_ENTREG"	,dDtEntrg	,Nil}) //--> Data da Entrega
		aAdd(aTail(aItens)	,{"C6_UM"		,nUdProdV	,Nil}) //--> Unidade de Medida
		aAdd(aTail(aItens)	,{"C6_CLI"		,cCliente	,Nil}) //--> Cliente
		aAdd(aTail(aItens)	,{"C6_LOJA"		,cLojaCli	,Nil}) //--> Loja do Cliente
		aAdd(aTail(aItens)	,{"C6_TES"		,cTESProd	,Nil}) //--> TES
		aAdd(aTail(aItens)	,{"C6_LOCAL"	,cLocProd	,Nil}) //--> Produto Local
			
		SD1->(dbskip())	
	
	EndDo

EndIf

//--> Gera pedido de venda
BEGIN TRANSACTION

 	MATA410(aCabec,aItens,3)
	
	If lMsErroAuto
		ApMsgStop( "Não foi possivel gerar o Pedido de Venda."  + CHR(13)+CHR(10) + "Segue a Tela de Erro para Conferencia", "ATENÇÃO -> " + cUsuario )
		
		DisarmTransaction()
		break
	EndIf
	
END TRANSACTION

If lMsErroAuto
	/*
	Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros
	passados,mostrar na tela o log informando qual coluna teve a incosistencia.
	*/
	Mostraerro()
	Return .F.
EndIf


ApMsgInfo( "O Pedido de Venda número: "  + cNumSC5 + " Foi Gerado." + CHR(13)+CHR(10) + "Referente a NF: " + cCodNF , "ATENÇÃO -> " + cUsuario )


RETURN
///////////////////////////////////////////////////////////////////////