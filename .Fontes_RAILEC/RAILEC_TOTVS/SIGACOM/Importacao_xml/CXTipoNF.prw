#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ CXTipoNF º Autor ³ Cirilo Rocha       º Data ³  29/03/2012 º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³ Funcao para retornar a descricao do tipo da NF             º±±
//±±º          ³                                                            º±±
//±±º          ³ Existem 3 retornos possiveis:                              º±±
//±±º          ³  1 = Descricao do tipo (segundo parametro obrigatorio)     º±±
//±±º          ³  2 = Array com as descricoes dos tipos para NF             º±±
//±±º          ³  3 = Array com os tipos de NF validos                      º±±
//±±º          ³                                                            º±±
//±±º          ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±º   DATA   ³ Programador   ³ Manutencao Efetuada                        º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±º          ³               ³                                            º±±
//±±º          ³               ³                                            º±±
//±±º          ³               ³                                            º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function CXTipoNF(nRetorno,cTipoNF)
                  
Local nPos			:= 0
Local xRetorno		:= NIL
Local aDescTipos	:= {	"Normal"					,;
								"Devolução"				,;
								"Beneficiamento"		,;
								"Compl. ICMS"			,;
								"Compl. IPI"			,;
								"Compl. Preço/Frete"	}
Local aTipos		:= {"N","D","B","I","P","C"}

//Retorna a descricao do tipo passado como parametro
If nRetorno == 1
	nPos	:= aScan(aTipos,{ |X| X == cTipoNF })
	If nPos > 0
		xRetorno	:= aDescTipos[nPos]
	EndIf
//Retorna o array com as descricoes dos tipos
ElseIf nRetorno == 2
	xRetorno	:= aClone(aDescTipos)
//Retorna o array com os tipos validos
ElseIf nRetorno == 3
	xRetorno	:= aClone(aTipos)
EndIf

Return xRetorno