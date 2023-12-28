#Include 'Protheus.ch'
#Include 'PRTOPDEF.ch'


/*/{Protheus.doc} GPA131MN
Ponto de Entrada para criar rotina na tela de beneficios 
@author TOTVS
@since 22/08/2016
@version undefined

@type function
/*/
User function GPA131MN()

	Local aRet := PARAMIXB[1]

	aAdd(aRet,{ "Calcular Roteiro" 	,"U_fCalcBen"		, 	0 , 4 })

Return(aRet)

/*/{Protheus.doc} fCalcBen
Calculo de Folha
@author Felipe Caiado
@since 14/11/2016
@version undefined

@type function
/*/
User Function fCalcBen()

	Local bBotao	:= {|| fCalcLanc(SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_PROCES)}

	MsAguarde( bBotao, "Calculando Roteiro")

Return()


/*/{Protheus.doc} fCalcLanc
Calculo de Folha
@author Felipe Caiado
@since 14/11/2016
@version undefined
@param cFil, characters, descricao
@param cMat, characters, descricao
@param cProcesso, characters, descricao
@type function
/*/
Static Function fCalcLanc(cFil, cMat, cProcesso)
	Local cFiltraWF	:= ""
	Local aSRCCols	:= {}
	Local cRoteiro := "FOL"
	Local nTpVale    := 0

	Dbselectarea('SM7')
	DbsetOrder(3)
	//Elder Totvs 02/02/2021
	while nTpVale <= 2
		If DbSeek( cFil + cMat + alltrim(str(nTpVale)))
			If nTpVale == 0
				cRoteiro := "VTR"
			ElseIf nTpVale == 1
				cRoteiro := "VRF"
			Else
				cRoteiro := "VAL"
			EndIf

			cFiltraWF := "RA_FILIAL == '" + cFil + "' .AND. RA_MAT == '" + cMat + "'"

			Gpem020(.T.,;			//Define Que a Chamada Esta Sendo Efetuada Atraves do WorkFlow
			cProcesso,;	//Define o processo que sera calculado
			cRoteiro,;	//Define o roteiro que sera calculado
			cFiltraWF;	//Filtro executado na rotina
			)	

			MostraErro() //Mostra Log do Calculo

			RstExecCalc() //Restaurar as Static apos o calculo	

		Endif
		nTpVale := (nTpVale + 1)
	Enddo							 	 
	//Elder Totvs fim
Return (Nil)
