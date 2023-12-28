#include 'protheus.ch'
#include 'parmtype.ch'

//***********************
User Function A410CONS()                      // MONTAGEM DOS BOTOES NO PEDIDO DE VENDA
//***********************
Local aUButtons:={}

//Para uso do Portal Alubar
//Denis Haruo
lPortal := .F.
If Alltrim(cUsuario) == ''
	lPortal := .T.
endif
    
if !lPortal 
	aadd(aUButtons,{"DBG06",{||U_ULogZZ4O("2")},"Alubar:Log de Ocorrencias" })
	aadd(aUButtons,{"DBG09",{||U_UNaoConf()},"Alubar:Reg Nao Conformid." })
	aadd(aubuttons,{'Pre-Danfe' ,{|| u_PREDANFE() },"Pre-Danfe Alubar","Pre-Danfe Alubar"} )
endIf

RETURN aUButtons
