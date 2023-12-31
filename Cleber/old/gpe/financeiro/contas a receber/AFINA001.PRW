#include "rwmake.ch"
#include "protheus.ch"
#include "Topconn.ch"
#include "tbiconn.ch"
#include "MSGRAPHI.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AFINA001  �Autor  �Sangelles           � Data �  07/08/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Selecao de Carteira		                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Acelerador Totvs Goias                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���	Dados Adicionais de Alteracao/Ajustes do Fonte                        ���  
�������������������������������������������������������������������������ͻ��
���Data      � Descricao:                                                 ���
�������������������������������������������������������������������������͹��
���07/08/2013�                                                            ���
��� 		 � 					                                          ���
�������������������������������������������������������������������������ͼ��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
���			 �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������  
*/

User Function AFINA001()

//Criar parametro MV_XSEE sem ele n�o funciona

    Local oBTCancela
    Local oBTOk
    Local oFont09Arial := TFont():New("Arial",,017,,.T.,,,,,.F.,.F.)
    Local oFont10Arial := TFont():New("Arial Narrow",,018,,.T.,,,,,.F.,.F.)
    Local oGroup1
    Local oGroup2
    Local oGroup3
    Local oSay1
    Local oSay2
    Local oSay3
    Local oSay4
    Local oSay5
    Local oSay6
    Local oSay7

    Private oCarteira
    Private oContaCorrente
    Private oNossoNumero
    Private oNrConvenio
    Private oAgencia
    Private oBanco
    Private oOperacao
    Private oSubCta


//�������������������������������������������������������������������Ŀ
//�Preparo o ambiente na qual sera executada a rotina de negocio      �
//���������������������������������������������������������������������
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "SB1","SB2","SB5","SA6","SEE"

    Private cAgencia := ""
    Private cCarteira := ""
    Private cBanco := ""
    Private cContaCorrente := ""
    Private cNossoNumero := ""
    Private cNrConvenio := ""
    Private cSubCta := space( Len(SEE->EE_SUBCTA) )
    Private _nRecno	:= 0 	// Nova Variavel para Tratamento do Recno na Hora de Gravar
    Private _aPreencher := {}
    Private cOperacao := 1
    Private _nxOperacao := 0	// Recno

    Static oDlg

    DEFINE MSDIALOG oDlg TITLE " Sele��o Carteira Ativa " FROM 000, 000  TO 290, 500 COLORS 0, 16777215 PIXEL

    @ 004, 007 SAY oSay2 PROMPT "Informe abaixo as informa��es de Banco/Agencia/Conta e carteira cadastrada na rotina (Parametros Bancarios):" SIZE 232, 020 OF oDlg FONT oFont10Arial COLORS 0, 16777215 PIXEL
    @ 063, 010 SAY oSay1 PROMPT "Banco:" SIZE 022, 007 OF oDlg FONT oFont09Arial COLORS 0, 16777215 PIXEL
    @ 080, 072 SAY oSay3 PROMPT "Conta:" SIZE 024, 007 OF oDlg FONT oFont09Arial COLORS 0, 16777215 PIXEL
    @ 081, 010 SAY oSay4 PROMPT "Ag�ncia:" SIZE 028, 007 OF oDlg FONT oFont09Arial COLORS 0, 16777215 PIXEL
    @ 081, 147 SAY oSay5 PROMPT "Carteira:" SIZE 029, 007 OF oDlg FONT oFont09Arial COLORS 0, 16777215 PIXEL
    @ 097, 010 SAY oSay6 PROMPT "Nr. Conv�nio:" SIZE 048, 007 OF oDlg FONT oFont09Arial COLORS 0, 16777215 PIXEL
    @ 097, 104 SAY oSay7 PROMPT "Nosso N�mero Atual:" SIZE 050, 008 OF oDlg FONT oFont09Arial COLORS 0, 16777215 PIXEL

    @ 062, 039 MSGET oBanco VAR cBanco SIZE 185, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 079, 098 MSGET oContaCorrente VAR cContaCorrente SIZE 044, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 079, 039 MSGET oAgencia VAR cAgencia SIZE 026, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 079, 177 MSGET oCarteira VAR cCarteira SIZE 014, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 095, 059 MSGET oNrConvenio VAR cNrConvenio SIZE 036, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 095, 158 MSGET oNossoNumero VAR cNossoNumero SIZE 065, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

    _aPreencher	:= xPreencher()		// Deve ser criado

    @ 042, 009 MSCOMBOBOX oOperacao VAR cOperacao ITEMS _aPreencher SIZE 228, 010 OF oDlg COLORS 0, 16777215 ON CHANGE ( xAtuCmp() ) PIXEL

    _nRecno := xLeMV() 			// Deve ser Criado

    xAtuCmp()

    @ 055, 004 GROUP oGroup1 TO 116, 244 OF oDlg COLOR 0, 16777215 PIXEL
    @ 032, 004 GROUP oGroup2 TO 058, 244 PROMPT " Parametro de Configura��o (Ativo)  " OF oDlg COLOR 0, 16777215 PIXEL
    @ 023, 006 GROUP oGroup3 TO 027, 244 OF oDlg COLOR 0, 16777215 PIXEL

    DEFINE SBUTTON oBTCancela 	FROM 132, 190 TYPE 02 OF oDlg ONSTOP "Cancela Opera��o" 		ENABLE ACTION oDlg:End()
    DEFINE SBUTTON oBTOk 		FROM 132, 218 TYPE 01 OF oDlg ONSTOP "Confirma as altera��es" 	ENABLE ACTION {|| xAtuMV(), oDlg:End() }

    ACTIVATE MSDIALOG oDlg CENTERED

Return


// 
// Atualiza parametro com o Recno
//
Static Function xAtuMV()

//	_nPos := aScan(_aPreencher,{|x| StrZero(_nRecno,4) $ x} )
    PutMv("MV_XSEE",_nRecno)
Return

//
// Preenche vetor da combobox
// 
    Static Procedure xPreencher()
    Local _aRegistros := {}

    cEOL := CHR(10)
    if type("SEE->EE_XCART") == 'U'
        AVISO("Aten��o", "Para este processo funcionar � necess�rio aplicar o compatibilizador U_UPDBOLET!"+cEOL+ "O campo EE_XCART n�o existe!"  , {"Ok"})
        return
    endif
    SEE->(dbsetorder(1))  //Criado pelo Athos Data 11/10/2013
    SEE->(dbseek(xFilial("SEE")))
    SEE->(DbGoTop())
    while !SEE->(EOF())
        if SEE->EE_FILIAL == xFilial("SEE")
            aadd(_aRegistros, StrZero(SEE->(RecNo()),4)+" / "+AllTrim(SEE->EE_OPER)+" AG:"+AllTrim(SEE->EE_AGENCIA)+" C/C:"+AllTrim(SEE->EE_CONTA)+" CART:"+SEE->EE_XCART+" / SUB CTA: "+ SEE->EE_SUBCTA )
        endif
        SEE->(dbskip())
    enddo
    //SEE->( DbEval( {|| aadd(_aRegistros, StrZero(RecNo(),4)+" / "+AllTrim(SEE->EE_OPER)+" AG:"+AllTrim(SEE->EE_AGENCIA)+" C/C:"+AllTrim(SEE->EE_CONTA)+" CART:"+SEE->EE_XCART )   } ) )

    if len(_aRegistros) == 0
        aadd(_aRegistros, "000"+" / "+"000"+" AG:"+"000"+" C/C:"+"000"+" CART:"+"000" )
        AVISO("Aten��o", "N�o existe nenhum par�metro de banco cadastrado (Tabela SEE)!"+cEOL+ "Favor fa�a o cadastramento conforme Banco/Boleto."  , {"Ok"})
    endif

Return _aRegistros


//
// Le o parametros Gravados
//
Static Function xLeMV()
    Local _nPos := 0

    _nRecno := SuperGetMv ( "MV_XSEE", .F., SEE->( Recno() ) )
    SEE->( DbGoTo( _nRecno ) )

    _nPos := aScan(_aPreencher,{|x| StrZero(_nRecno,4) $ x} )

    if _nPos > 0
        oOperacao:Nat := _nPos
        oOperacao:Select(_nPos)
    else
        oOperacao:Nat := 1
    endif

    oOperacao:Refresh()
Return _nRecno


// 
// Atualiza Campos da oDlg
//
Static Function xAtuCmp()

    _nRecno := Val( Left(_aPreencher[oOperacao:Nat],4) )
    SEE->( DbGoTo( _nRecno ) )

    M->cAgencia			:= SEE->EE_AGENCIA
    M->cCarteira		:= SEE->EE_XCART
    M->cBanco			:= SEE->EE_CODIGO
    M->cContaCorrente 	:= SEE->EE_CONTA
    M->cNossoNumero		:= SEE->EE_FAXATU
    M->cNrConvenio		:= SEE->EE_CODEMP
    M->cOperacao		:= SEE->EE_CODIGO + " - " + AllTrim(SEE->EE_OPER)

    oCarteira:Refresh()
    oContaCorrente:Refresh()
    oNossoNumero:Refresh()
    oNrConvenio:Refresh()
    oAgencia:Refresh()
    oBanco:Refresh()
    oOperacao:Refresh()

    oDlg:Refresh()

Return .T.
