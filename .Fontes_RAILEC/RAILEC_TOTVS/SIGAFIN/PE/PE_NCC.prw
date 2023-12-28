#Include 'Protheus.ch'
#Define CRLF (Chr(13) + Chr(10))


User Function FA040INC()
/*------------------------------------------------------------------+
|Função Padrão	:	FINA040											|
|PE FINA040		:	FA040INC										|
|Autor			:	Wildner Pinto									|
|Empresa		:	Sigacorp Consultoria							|
|Data			:	08.10.2014										|
|Utilização		:	O ponto de entrada FA040INC sera utilizado na	|
|					validacao da TudoOk na inclusao do contas a 	|
|					receber.										|
|					Utilizado para controle de alçada de NCC por	|
|					Work Flow.										|
|					Retorno											|
|					URET(logico) .T. Dados validos para inclusao	|
|					.F. Caso contrario								|
+------------------------------------------------------------------*/
Local _cEmp			:= FWCodEmp()
Local _cEmpPar		:= ""
Local _cFil 		:= FWCodFil()
Local _cFilPar		:= ""
Local _lExec		:= .F.
Local _cEmpFil		:= GETMV("AL_EMPFIL")
Local _lRet		:= .T.
Local lCtrlNcc	:= ""	//GetMv("AL_CTRLNCC")// Parametro que determina se haverá controle das NCC's
Local dDtNcc	:= ""	//GetMv("AL_DTNCC")// Data de Inicio de controle das NCC
Local _cCodSolic:= RetCodUsr() 
Local _cFilial	:= xFilial("SE1")
Local _cCliente := M->E1_CLIENTE
Local _cLoja	:= M->E1_LOJA
Local _cPrefixo	:= M->E1_PREFIXO
Local _cNum		:= M->E1_NUM
Local _cParcela	:= M->E1_PARCELA
Local _cTipo	:= M->E1_TIPO   
Local _dEmissao	:= M->E1_EMISSAO	
Local _nValor	:= M->E1_VALOR  

While len(_cEmpFil)>0 
	_cEmpPar:= SubStr(_cEmpFil,1,2)
	_cFilPar:= SubStr(_cEmpFil,3,2)
	_cEmpFil:= SubStr(_cEmpFil,6,len(_cEmpFil))

	IF _cEmp==_cEmpPar .AND. _cFil==_cFilPar
		_lExec:= .T.
	EndIf
Enddo

IF !_lExec
	lRet		:= .T. 
	Return(lRet)
Else
	lCtrlNcc	:= GetMv("AL_CTRLNCC")// Parametro que determina se haverá controle das NCC's
	dDtNcc		:= GetMv("AL_DTNCC")// Data de Inicio de controle das NCC
EndIf                                                                                       

If	DtoC(dDataBase)>=DtoC(dDtNcc) .AND.;
	DtoC(_dEmissao)>=DtoC(dDtNcc) .AND.;
	lCtrlNcc==.T.
	
	If	_cTipo=="NCC"
		U_Dialog_NCC(_cCodSolic,_cCliente,_cLoja,_cPrefixo,_cNum,_cParcela,_cTipo,_nValor)
		
		M->E1_STATNCC:="E" //Status WF => E=ENVIADO;A=APROVADO;R=REPROVADO
		M->E1_APROV2  := "WFAUTO" 
		M->E1_NAPROV2 := "WF AUTOLIB"
		M->E1_DTAPRO2 := dDataBase
		M->E1_HRAPRO2 := SubStr(Time(),1,5)
		M->E1_APROV3  := "WFAUTO" 
		M->E1_NAPROV3 := "WF AUTOLIB"
		M->E1_DTAPRO3 := dDataBase
		M->E1_HRAPRO3 := SubStr(Time(),1,5)
	END
End
Return(_lRet)

****************************************************************************************************************

/*User Function FA070CHK()

/*------------------------------------------------------+
|O ponto de entrada FA070CHK sera executado na entrada	|
|da funcao antes de carregar a tela de baixa do contas	|
| a receber.											|
+------------------------------------------------------*/

/*------------------------------------------------------+
|Declaração de variaveis								|
+------------------------------------------------------*/
/*
Local _cEmp			:= FWCodEmp()
Local _cEmpPar		:= ""
Local _cFil 		:= FWCodFil()
Local _cFilPar		:= ""
Local _lExec		:= .F.
Local _cEmpFil		:= GETMV("AL_EMPFIL")
Local _cTipo 	:= AllTrim(SE1->E1_TIPO) 
Local _cStatNCC	:= AllTrim(SE1->E1_STATNCC)
LoCAL _cOrigem	:= AllTrim(SE1->E1_ORIGEM)
Local _lRet 	:= .T.
While len(_cEmpFil)>0 
	_cEmpPar:= SubStr(_cEmpFil,1,2)
	_cFilPar:= SubStr(_cEmpFil,3,2)
	_cEmpFil:= SubStr(_cEmpFil,6,len(_cEmpFil))

	IF _cEmp==_cEmpPar .AND. _cFil==_cFilPar
		_lExec:= .T.
	EndIf
Enddo

IF !_lExec
	lRet		:= .T. 
	Return(lRet)
EndIf


If _cTipo=="NCC" .And. _cOrigem=="FINA040"
	If 		_cStatNCC=="E"
		MsgAlert("O Título selecionado está aguardando aprovação via Workflow."+CRLF+" Não é possível realizar a baixa até o termino do processo de aprovação.","Aprovação Workflow")
		_lRet:=.F.
	ElseIf 	_cStatNCC=="R"
		MsgAlert("O Título selecionado teve sua APROVAÇÃO NEGADA via Workflows. Não é possivel realizar a Baixa."+CRLF+"O usuário responsável pela inserção do título recebeu um e-mail informando qual o motivo da rejeição.","Aprovação Workflow")
		_lRet:=.F.
	ElseIf 	_cStatNCC=="A"
		_lRet:=.T.
	EndIf
EndIf

Return(_lRet)
*/
