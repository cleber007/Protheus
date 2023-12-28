#Include "rwmake.ch"
#Include "Colors.Ch"
//#Include "Norte.ch"

/*
   Rotina    : BORPAG.prw
   Autor     : Aguiar
   Data      : 03.06.04
   Descricao : Faz com que seja liberado o Bordero atraves de usuario/senha
   Alterado  :
*/


User Function BorPag(_nOpc)  // Vendo do menu financeiro com o parametro 2
***************************

_nValRes  :=  LiberBord(1)

Return()

Static Function LiberBord(_nProg)
*******************************
_lOkb := 0

_nVez := 0

	If _nProg = 1
			
		FINA420()

		CIDCNAB()

	Else
			
		u_FINA300()
		
		CIDCNAB()
	Endif
		
Return()


User Function BorSis()
**********************

_nValRes  :=  LiberBord(2)


Return()

Static Function CIDCNAB()
*************************
_cArea := Alias()
_nReg  := Recno()
_nOrd  := DbSetOrder()

_cBordIni := MV_PAR01
_cBordFim := MV_PAR02  


DbSelectArea("SE2")
DbOrderNickName("SE213")
DbGotop()

If DbSeek(xFilial("SE2")+Alltrim(_cBordIni))
	
	Do While !Eof() .and. SE2->E2_NUMBOR = Alltrim(_cBordFim)
		
		RecLock("SE2",.f.)
		
		SE2->E2_IDCNAB := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
		
		MsUnlock()
		
		DbSkip()
	Enddo
Endif

DbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(_nReg)

Return