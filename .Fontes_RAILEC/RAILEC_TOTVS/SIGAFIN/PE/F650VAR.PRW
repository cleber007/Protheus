// +-----------+---------------+---------------------------------+---------------------+
// | Programa  | F650VAR.PRW   | Autor: Luiz Sousa               | Data: 18/07/2016    |
// +-----------+---------------+---------------------------------+---------------------+
// | Descricao | PE do relatorio FINR650 utilizado para alterar os dados recebidos.    |
// +-----------+-------------------------------------------------+---------------------+
// | Uso       | CNAB (Arquivo de Retorno) - ALUBAR              | Dt. Atu: 18/08/2017 |
// +-----------+-------------------------------------------------+---------------------+

#INCLUDE "rwmake.ch"

///////////////////////
User Function F650VAR()
///////////////////////

Local _aArea    := GetArea()
Local _cLinha   := PARAMIXB[01][14]
Local _cTitulo  := ""
Local _cEspecie := ""
Local _cFuncao  := FunName()
Local _dDtCredi := MV_PAR09
Local _cBanco   := ""

//Adicionado por David - Mconsult 14/02/2019- Retirando alterações nas variaveis para empresa 03 - Energia.
IF 	cEmpAnt !='03'

If !(MV_PAR03 $ "033/104") //Rafael Almeida - SIGACORP (02/10/2018) // foi adiconado o banco 104 para o mesmo não ter acesso essa customização
//aValores := ( { cNumTit, dBaixa, _cEspecie, cNossoNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nValCc, dCred, cOcorr, xBuffer } )
_cBanco := SEE->EE_CODIGO      
//--> Verifica Numero do Titulo
IF (_cBanco != "001")	//--> BRASIL
	_cTitulo := Substr(_cLinha,38,14)
ELSE
	_cTitulo  := Substr(_cLinha,59,14)
	_cEspecie := POSICIONE("SE1", 1, xFilial("SE1") + _cTitulo, "E1_TIPO")	
	cTipo     := _cEspecie
ENDIF	

IF !EMPTY(_cTitulo)
	cNumTit := _cTitulo
ENDIF	

//--> Validar banco
IF (_cBanco == "422")	//--> SAFRA
	nValRec := nValRec + SA6->A6_TXCOBSI
ENDIF
IF (_cBanco == "707")	//--> DAYCOVAL
	nValRec := nValRec + SA6->A6_TXCOBSI
ENDIF

//--> Verifica data 
IF (_cFuncao $ "FINA740|FINA200|FINR650")       
	
	IF !EMPTY(_dDtCredi)
		dDataCred := _dDtCredi
		dBaixa    := _dDtCredi
		dCred     := _dDtCredi   
	ENDIF
	
    nDespes := 0	//--> Remove as Despesas a Pagar 
	
ENDIF	
EndIf
ENDIF 
RestArea(_aArea)

RETURN
//////////////////////////////////////////////////////////////////////////////////////////
