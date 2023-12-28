#Include "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GaCnab    ºAutor  ³Jose Aguiar         º Data ³  01/03/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilhos diversos do CNAB                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ChecaCB(_cCodBar) // Usado para verificar o tamanho do codigo de barra(Itau/Real)
*******************************

_cCodVer := _cCodBar

If Len(Alltrim(_cCodVer)) > 44
	
	_cPart1 := Space(1)
	
	_cPart2 := Space(1)
	
	_cPart3 := Space(1)
	
	_cPart4 := Space(1)
	
	_cPart1 := Alltrim(_cPart1) + Substr(_cCodVer,1,9)
	
	_cPart2 := Alltrim(_cPart2) + Substr(_cCodVer,11,10)
	
	_cPart3 := Alltrim(_cPart3) + Substr(_cCodVer,22,10)
	
	_cPart4 := Alltrim(_cPart4) + Substr(_cCodVer,33,15)
	
	_cCodVer := _cPart1 + _cPart2 + _cPart3 + _cPart4
Endif

Return(_cCodVer)


User Function CodBarCnab()
***************************

_cRet := Space(40)
_cLivre := _cDig := _cMoeda := _cSpaco := Space(1)

If SEA->EA_MODELO = "31" .Or. SEA->EA_MODELO = "30"
	
	IF !EMPTY(SE2->E2_DIGBARR)
		_cLivre := Substr(SE2->E2_DIGBARR,20,25)
		
		_cDig   := Substr(SE2->E2_DIGBARR,5,1)
		
		_cMoeda := Substr(SE2->E2_DIGBARR,4,1)
		
		_nQtd   := 0
		
		_nQtd   := Len(_cLivre)+Len(_cDig)+Len(_cMoeda)
		
		_cSpaco := Space( 40 -_nQtd)
		
		_cRet   := _cLivre + _cDig + _cMoeda + _cSpaco
	ELSEIF !EMPTY(SE2->E2_LINDIGI)
		_cLivre := Substr(SE2->E2_LINDIGI,5,5)+Substr(SE2->E2_LINDIGI,11,10)+Substr(SE2->E2_LINDIGI,22,10)
		
		_cDig   := Substr(SE2->E2_LINDIGI,33,1)
		
		_cMoeda := Substr(SE2->E2_LINDIGI,4,1)
		
		_nQtd   := 0
		
		_nQtd   := Len(_cLivre)+Len(_cDig)+Len(_cMoeda)
		
		_cSpaco := Space( 40 -_nQtd)
		
		_cRet   := _cLivre + _cDig + _cMoeda + _cSpaco
		
	ENDIF
elseIf SEA->EA_MODELO == "03"
	_cRet   := "C0000000101"
	
Endif

Return(_cRet)


User Function ValidVal(_nTipo)
*******************************
_cRet := Space(1)

Do Case
	
	Case _nTipo = 6
		
		_nQtd := Len(Alltrim(SEE->EE_AGENCIA))
		
		_nDif := 0
		
		_nDif := _nTipo - _nQtd
		
		_cRet := strzero(val(SEE->EE_AGENCIA),_nTipo)
		
		
	Case _nTipo = 13
		
		cConta := strtran(SEE->EE_CONTA,"-","")
		
		_nQtd := Len(Alltrim(cConta))
		
		_nDif := 0
		
		_nDif := _nTipo - _nQtd
		
		_cRet := strzero(val(cConta),_nTipo)
EndCase

Return(_cRet)

User Function SOMABOR(nQtd)
***************************
_cBorIni := Mv_Par01
_cBorFim := Mv_Par02
_nValor  := _nTam   := 0
_cTemp   := _cValor := Space(1)


_cAlias  := Alias()
_nOrder  := IndexOrd()
_nReg    := Recno()

DbSelectArea("SE2")
DbOrderNickName("SE213") // VERIFICAR NA BASE DO CLIENTE

DbGotop()

DbSeek(xFilial("SE2")+_cBorIni,.t.)

Do While !Eof() .And. SE2->E2_NUMBOR <= _cBorFim ;
	.And. xFilial("SE2")  == SE2->E2_FILIAL //Mv_Par11 <= SE2->E2_FILIAL //.And. SE2->E2_NUMBOR <= _cBorFim
	
	
	_nValor := iif(SE2->E2_VALBOL>0,SE2->E2_VALBOL,SE2->E2_SALDO) + _nValor

	// Alert(STR(SE2->E2_VALBOL,17,2))
	DbSkip()
Enddo

//_cTemp  := Str(_nValor,nQtd,2)

//_nTam   := Len(Alltrim(_cTemp))
//Alert(STR(_nValor,17,2))
_cValor := _nValor * 100

//_cValor := Substr(Alltrim(_cTemp),1,_nTam-3) + Substr(Alltrim(_cTemp),_nTam-1,2)

//_cValor := Replicate("0",nQtd-Len(_cValor))+_cValor

dbSelectArea(_cAlias)
dbSetOrder(_nOrder)
DbGoto(_nReg)

Return(_cValor)


User Function DataBB(_cContem)
*************************************
_cRet := Space(1)

_cRet := Substr(Dtos(_cContem),7,2)+Substr(Dtos(_cContem),5,2)+Substr(Dtos(_cContem),1,4)

Return(_cRet)


User Function ValorBB(_cVlr)
****************************

_cValor := _cVlr

// Alterado por Antonio Joaquim em 07/05/2007 motivo teste de boleto preempresso
// If Substr(_cVlr,1,4) = "0000"
If val(_cVlr) <> 0
	
	
	_nVlr   := SE2->E2_VALBOL * 100

	_cValor := StrZero(_nVlr,14) // valor anterior 14 trocado por Antonio Joaquim em 23/04/2007
Else
	//caso venha com valor zero boleto preempresso
	_cValor := StrZero(val(_cVlr),14)
Endif


Return(_cValor)


User Function CCFunc() //Conta do Funcionario para o CNAB da folha
**********************
_nPad := 13
_nTam := Len(Alltrim(SRA->RA_CTDEPSA))
_cRet := Space(1)

If _nPad > _nTam
	
	_nDif := _nPad - _nTam
	
	For x := 1 to _nDif
		
		_cRet := Alltrim(_cRet)+"0"
	Next
Endif

_cRet := Alltrim(_cRet) + Alltrim(SRA->RA_CTDEPSA)

Return(_cRet)
   
