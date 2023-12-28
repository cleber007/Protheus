#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
//ฑฑบPrograma  ณ CXNFCliFor บ Autor ณ Cirilo Rocha      บ Data ณ 30/03/2012 บฑฑ
//ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
//ฑฑบDesc.     ณ Funcao para determinar se a NF (saida ou entrada) deve ser บฑฑ
//ฑฑบ          ณ relacionada ao cadastro de cliente ou fornecedor           บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑบ          ณ                                                            บฑฑ
//ฑฑฬออออออออออุอออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบ   DATA   ณ Programador   ณ Manutencao Efetuada                        บฑฑ
//ฑฑฬออออออออออุอออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑบ          ณ               ณ                                            บฑฑ
//ฑฑศออออออออออฯอออออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
User Function CXNFCliFor(lSaida,cTipoNF)

Local lCliente	:= Nil

//NF de Saida
If lSaida
	//Devolucao ou Beneficiamento, usa fornecedor
	If cTipoNF $ 'D*B'
		lCliente	:= .F.
	Else
		lCliente	:= .T.
	EndIf
//NF de Entrada
Else
	//Devolucao ou Beneficiamento, usa cliente
	If cTipoNF $ 'D*B'
		lCliente	:= .T.
	Else
		lCliente	:= .F.
	EndIf
EndIf                  

Return lCliente