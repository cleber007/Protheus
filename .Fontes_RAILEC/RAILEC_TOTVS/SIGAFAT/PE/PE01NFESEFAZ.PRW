#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE 'rwmake.ch'

/*/{Protheus.doc} user Function PE01NFESEFAZ
    Ponto de Entrada para Tratamento NFESEFAZ XML
    @type  Function
    @author Jean Rocha
    @since 18/05/2022
    @version 1.0
    /*/

USER FUNCTION PE01NFESEFAZ()

Local aArea      := GetArea()
Local aProd      := PARAMIXB[1]
Local cMensCli   := PARAMIXB[2]
Local cMensFis   := PARAMIXB[3]
Local aDest      := PARAMIXB[4]
Local aNota      := PARAMIXB[5]
Local aInfoItem  := PARAMIXB[6]
Local aDupl      := PARAMIXB[7]
Local aTransp    := PARAMIXB[8]
Local aEntrega   := PARAMIXB[9]
Local aRetirada  := PARAMIXB[10]
Local aVeiculo   := PARAMIXB[11]
Local aReboque   := PARAMIXB[12]
Local aNfVincRur := PARAMIXB[13]
Local aEspVol    := PARAMIXB[14]
Local aNfVinc    := PARAMIXB[15]
Local AdetPag    := PARAMIXB[16]
Local aObsCont   := PARAMIXB[17]

//Local aProcRef   := PARAMIXB[18]
//Local aMed      := PARAMIXB[19]
//Local aLote     := PARAMIXB[20]
Local aRetorno   := {}

fMensCli(aNota[04], @cMensCli) //aNota[04] = Tipo da Nota, cMensCli = "Local cMensCli := PARAMIXB[2]"

//O retorno deve ser exatamente nesta ordem e passando o conte�do completo dos arrays
//pois no rdmake nfesefaz � atribuido o retorno completo para as respectivas vari�veis
//Ordem:
//      aRetorno[1] -> aProd
//      aRetorno[2] -> cMensCli
//      aRetorno[3] -> cMensFis
//      aRetorno[4] -> aDest
//      aRetorno[5] -> aNota
//      aRetorno[6] -> aInfoItem
//      aRetorno[7] -> aDupl
//      aRetorno[8] -> aTransp
//      aRetorno[9] -> aEntrega
//      aRetorno[10] -> aRetirada
//      aRetorno[11] -> aVeiculo
//      aRetorno[12] -> aReboque
//      aRetorno[13] -> aNfVincRur
//      aRetorno[14] -> aEspVol
//      aRetorno[15] -> aNfVinc
//      aRetorno[16] -> AdetPag
//      aRetorno[17] -> aObsCont
//      aRetorno[18] -> aProcRef

aadd(aRetorno,aProd)
aadd(aRetorno,cMensCli)
aadd(aRetorno,cMensFis)
aadd(aRetorno,aDest)
aadd(aRetorno,aNota)
aadd(aRetorno,aInfoItem)
aadd(aRetorno,aDupl)
aadd(aRetorno,aTransp)
aadd(aRetorno,aEntrega)
aadd(aRetorno,aRetirada)
aadd(aRetorno,aVeiculo)
aadd(aRetorno,aReboque)
aadd(aRetorno,aNfVincRur)
aadd(aRetorno,aEspVol)
aadd(aRetorno,aNfVinc)
aadd(aRetorno,AdetPag)
aadd(aRetorno,aObsCont)
//aadd(aRetorno,aProcRef)
//aadd(aRetorno,aMed)
//aadd(aRetorno,aLote)
RestArea(aArea)

RETURN aRetorno

//*****************************************************/

Static Function fMensCli(c_TpNota, cMensCli)

IF c_TpNota == "1" //Tipo de Nota � igual a 1, ou seja, NF de Sa�da
    cMensCli += 'PEDIDO: '+SD2->D2_PEDIDO //Receber� o N�mero do Pedido de Venda.
ENDIF

Return Nil

//*****************************************************/ 
