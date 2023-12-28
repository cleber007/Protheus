#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/09/02

User Function ConfBar()        // incluido pelo assistente de conversao do AP5 IDE em 26/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt("_CCODBAR,_CBLOCO,_CDV1,_CDV2,_CDV3,_CFIXO")
	SetPrvt("NSOMA1,NSOMA2,NSOMA3,NI,_NRES,CSOMA1")
	SetPrvt("CSOMA2,CSOMA3,_VOLTA,_SEMDVGER,CCONFER,CDVGER")
	SetPrvt("NSOMAGER,CCALCDV,")

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Rotina    ³ CONFBAR.PRW                                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri+.o ³ Execblock para confer^ncia do c¢digo de barras quando este ³±±
	±±³          ³ for digitado e nÆo lido via caneta ¢tica (scaner).        ³±±
	±±³          ³ Utilizado pelo gatilho do campo E2_CODBAR.                 ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Desenvolvi³ Roberto Oliveira                                           ³±±
	±±³mento     ³ 09/10/2002                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³                                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
	*
	*
	_cCodBar := AllTrim(M->E2_CODBAR)
	_cBloco := Left(_cCodBar,9)+Substr(_cCodBar,11,10)+Substr(_cCodBar,22,10)
	_cDv1    := Substr(_cCodBar,10,1)
	_cDv2    := Substr(_cCodBar,21,1)
	_cDv3    := Substr(_cCodBar,32,1)
	_cFixo   := "21212121212121212121212121212"
	nSoma1 := 0
	nSoma2 := 0
	nSoma3 := 0

	For nI := 1 to 9
		_nRes := Val(Substr(_cBloco,nI,1))*Val(Substr(_cFixo,nI,1))
		If _nRes > 9
			_nRes := 1 + (_nRes-10)
		Endif
		nSoma1 := nSoma1 + _nRes
	Next

	For nI := 10 to 19
		_nRes := Val(Substr(_cBloco,nI,1))*Val(Substr(_cFixo,nI,1))
		If _nRes > 9
			_nRes := 1 + (_nRes-10)
		Endif
		nSoma2 := nSoma2 + _nRes
	Next

	For nI := 20 to 29
		_nRes := Val(Substr(_cBloco,nI,1))*Val(Substr(_cFixo,nI,1))
		If _nRes > 9
			_nRes := 1 + (_nRes-10)
		Endif
		nSoma3 := nSoma3 + _nRes
	Next

	cSoma1 := If((nSoma1%10) == 0,"0",Str(10-(nSoma1%10),1))
	cSoma2 := If((nSoma2%10) == 0,"0",Str(10-(nSoma2%10),1))
	cSoma3 := If((nSoma3%10) == 0,"0",Str(10-(nSoma3%10),1))

	_Volta := _cCodBar
	_SemDvGer := 0
	If _cDv1 == cSoma1 .and. _cDv2 == cSoma2 .and. _cDv3 == cSoma3
		* Se os DV's baterem - Entao foi digitado
		* Monto o C¢digo de barras correto.

		_cCodBar := Left(_cCodBar,4) + Substr(_cCodBar,33,1) +;
			StrZero(Val(Substr(_cCodBar,34,Len(_cCodBar)-33)),14) +;
			Substr(_cCodBar,5,5) + Substr(_cCodBar,11,10) + Substr(_cCodBar,22,10)
		_SemDvGer := 1
	ElseIf Len(_cCodBar) < 44
		* Os DV's nao bateram e os dados foram digitados
		* entao recuso porque esta errado
		_Volta := Space(Len(M->E2_CODBAR))
	Endif

	If _Volta #Space(Len(M->E2_CODBAR))
		* Vamos agora conferir o DV Geral
		cConfer := Left(_cCodBar,4)+Right(_cCodBar,39)
		cDvGer   := Substr(_cCodBar,5,1)
		If cDvGer == "0" .and. _SemDvGer == 1
			* Se eu calculei os dv's e o dv geral for 0,
			* Significa que ' um boleto antigo que nao tem dv
			* Conforme orienta+ao, coloca-se 0 no dv regal.

			_Volta := _cCodBar
		Else
			_cFixo   := "4329876543298765432987654329876543298765432"

			nSomaGer := 0
			For nI := 1 to 43
				nSomaGer := nSomaGer + (Val(Substr(cConfer,nI,1))*Val(Substr(_cFixo,nI,1)))
			Next
			If (11-(nSomaGer%11)) > 9
				cCalcDv := "1"
			Else
				cCalcDv := Str(11-(nSomaGer%11),1)
			Endif
			_Volta := If(cCalcDv #cDvGer,Space(Len(SE2->E2_CODBAR)),_cCodBar)
		Endif
	Endif
// Substituido pelo assistente de conversao do AP5 IDE em 26/09/02 ==> __Return(_Volta)
	_Volta := Left(_Volta + Space(Len(SE2->E2_CODBAR)),Len(SE2->E2_CODBAR))
   
Return(_Volta)        // incluido pelo assistente de conversao do AP5 IDE em 26/09/02
