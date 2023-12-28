#Include "RwMake.ch"
#Include "TopConn.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TBICONN.CH"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CSFuncoes
Avisos semanal de aniversariantes

@type 	   Função de usuario
@author    TRIADE-Luciano Camargo
@version   1.00
@since     28-10-2016
@obs 0 ou Branco - Último dia do mês em Pauta;        
@obs 1 - Primeiro dia útil do mês;               
@obs 2 - Último dia útil do mês;                 
@obs 3 - Próximo dia útil após a dat?a informada (Se a data informada for útil, a função retorna a própria data).

/*/
//------------------------------------------------------------------------------------------

User Function CSGPER13( lAuto )
	Local cQuery 	:= ""
	Local cMesAno   := MesExtenso(Month(Date()+5))+' / '+StrZero(Year(Date()+5),4)
	Local cAssunto 	:= "ANIVERSARIANTES "
	Local _aColab   := {}
	Local _cAlias
	Local aArea 	 := GetArea()
	Local _lDia      := .F. // Aniversariantes do DIA
	Local _lMes      := .F. // Aniversariantes do MES
                                    
	lAuto := iIf(lAuto == Nil, .F., lAuto)
	ConOut("[CSGPER13] - Iniciando Scheduler")
	cDataUltimoEnvio := ALLTRIM(SuperGetMv("CS_EAVSRH2",, DtoS(Date()) ))
                                   
	cMes := StrZero( Month(Date()+5), 2 )
		
	_cAlias := "TRBCSFATM01"
	BeginSql Alias _cAlias

		SELECT RA_NOME, RA_NASC, RA_CODFUNC, RJ_DESC FROM SRA010 SRA
		LEFT JOIN SRJ010 ON RA_CODFUNC = RJ_FUNCAO AND SRJ010.%NotDel%
		WHERE RA_SITFOLH <> 'D'
		AND RA_CATFUNC <> 'A'
		AND MONTH(RA_NASC) = %Exp:cMes%
		AND SRA.%NotDel%
		ORDER BY DAY(RA_NASC)

	EndSql

	If (_cAlias)->(Eof())
		ConOut("[CSGPER13] - Não achou Aniversariantes para o Scheduler")
		dbCloseArea(_cAlias)
		Return()

	Else

		While !(_cAlias)->(Eof())

			If ( Date() >= (LastDay( Date(),2)+2) ) .and. cDataUltimoEnvio <> DtoS( Date() ) .or. !lAuto
				_lMes := .T.
			Else
					
				// Verificar se o dia do aniversario caiu no final de semana						
				If StrZero(Day(StoD((_cAlias)->RA_NASC)),2) = StrZero(Day(Date()),2)
					_lDia := .T.
				Endif
			Endif

			If _lDia .or. _lMes
				AADD( _aColab, { " "+ StrZero(Day(StoD((_cAlias)->RA_NASC)),2)+ " - "+(_cAlias)->RA_NOME+" ("+AllTrim((_cAlias)->RJ_DESC)+")" } )
			Endif
			(_cAlias)->(DBSkip())
		Enddo

		If !_lDia .and. !_lMes // Nao achou ninguem
			ConOut("[CSGPER13] - Não achou Aniversariantes para o Scheduler")
			dbCloseArea(_cAlias)
			Return()
		Endif

		If _lMes ; cAssunto += ": "+ cMesAno
		ElseiF _lDia ; cAssunto += " DO DIA "
		Endif

		ConOut("[CSGPER13] - Mandando e-mail´s para o Scheduler")

			// pegar o e-mail do usuario atual
		_cRHMail 	:= SuperGetMV("CS_EMAIL04",,"rh@cafedositio.com") 		// email do recursos humanos
		_cDPMail    := SuperGetMV("CS_EMAIL05",,"aline@cafedositio.com") 	// email do departamento de pessoal
		_cGstMail   := SuperGetMV("CS_EMAIL06",,"marina@cafedositio.com") 	// email dos gestores
		_cDirMail   := SuperGetMV("CS_EMAIL07",,"rodrigo@cafedositio.com") 	// email dos diretores
		_cSuporte 	:= SuperGetMV("CS_WFMonit",,"suporte@cafedositio.com") // email de monitoramento da TI
		_cProcesso 	:= ""
		_cTitulo   	:= cAssunto
		_cTitulo1  	:= "DIA / NOME DO COLABORADOR"
		
		_cTo :=  _cDPMail+IIF(!Empty(_cRHMail),"; "+_cRHMail,"")+IIF(!Empty(_cGstMail),"; "+_cGstMail,"")+IIF(!Empty(_cDirMail),"; "+_cDirMail,"")
		u_CSMsgGen(_cProcesso, _cTitulo, _cTitulo1, _cTo, _cSuporte, _aColab, "" ) // Mensagem Generica: Descricao do processo, Titulo cabecalho, Titulo do bloco de itens, Destinatario, User Monitoramento, array das linhas e informacao complementar

		PutMV( "CS_EAVSRH2", DtoS(Date()) )
		dbCloseArea(_cAlias)
    
	Endif

	ConOut("[CSGPER13] - Fim de Scheduler")
	RestArea(aArea)

Return

//---------------------------
User Function AvAnivJob()      // Chamado por Job
//---------------------------

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "GPE" Tables 'SRA'

	ConOut("[CSGPER13] - Iniciando Programa")

	u_CSGPER13(.T.)

	Reset ENVIRONMENT

Return

//---------------------------
User Function AvAnivMnu()     // Chamado por menu de usuario
//---------------------------
	Local cMesAno   := MesExtenso(Month(Date()+5))+' / '+StrZero(Year(Date()+5),4)
	Local cAssunto 	:= "ANIVERSARIANTES: " + cMesAno

	If MsgYesNo("Confirma o envio do e-mail dos "+cAssunto+"?")
		u_CSGPER13(.F.)
	Endif

Return