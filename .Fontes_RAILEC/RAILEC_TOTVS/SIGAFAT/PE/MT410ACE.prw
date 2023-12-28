#Include 'RwMake.ch'
#Include 'Protheus.ch'
 
/*----------------------------------------------------------------------------------------------------------*
 | P.E.:      MT410ACE                                                                                      |
 | Analista:  Rafael ALmeida - SIGACORP (09/11/2017)                                                        |
 | Desc:      Não permite usuário Exclua um pedido de venda                          |
 | Links:     http://tdn.totvs.com/pages/releaseview.action?pageId=6784346                                  |
 *----------------------------------------------------------------------------------------------------------*/
 
User Function MT410ACE()
Local aArea        := GetArea()
Local lContinua    := .T. 
Local nOpc         := PARAMIXB[1]
Local lResiduo     := IsInCallStack('MA410RESID')
     
If (nOpc == 1) .Or. (lResiduo)    
	If !(RetCodUsr()$GetNewPar("AL_EXMT410","000000/000391"))
		MsgAlert("Pedido não pode ser manipulado!", "Atenção")
		lContinua := .F.
	EndIf
EndIf

RestArea(aArea)
Return lContinua