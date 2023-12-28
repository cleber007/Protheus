/*/{Protheus.doc} User Function MT103FIM
    Ponto de entrada criado para que o usuário confirme a operação quando a opção Form Próprio está marcada como Sim
    @type  Function
    @author Jean Rocha
    @since 19/05/2022
    @version Protheus 12
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=6085400
    /*/
User Function MT103FIM()

Local aArea := GetArea()
Local _Opcao := Paramixb[1]
Local nConfirma := Paramixb[2] // Se o usuario confirmou a operação de gravação da NFE

Local cFormProprio  := cFormul //Variavel do Mata103
Local cMensagem     := ""
Local bConfirm
Local bSair
Local oDialog

if nConfirma == 1 .and. _Opcao == 3

    If (cFormProprio == 'S')

        bConfirm := {|| (oDialog:DeActivate()) }

        bSair := {|| Iif(MsgYesNo( 'Você tem certeza que deseja sair da rotina? ',;
        'Sair da rotina'),(oDialog:DeActivate()),NIL) }

        // Método responsável por criar a janela e montar os paineis.
        oDialog := FWDialogModal():New()

        // Métodos para configurar o uso da classe.
        oDialog:SetBackground( .T. )
        oDialog:SetTitle( 'Informe a mensagem ' )
        oDialog:SetSize( 200, 300 )
        oDialog:EnableFormBar( .T. )
        oDialog:SetCloseButton( .F. )
        oDialog:SetEscClose( .F. )
        oDialog:CreateDialog()
        oDialog:CreateFormBar()
        oDialog:AddButton( 'Confirmar', bConfirm, 'Confirmar', , .T., .F., .T., )
        oDialog:AddButton( 'Sair' , bSair , 'Sair' , , .T., .F., .T., )

        // Capturar o objeto do FwDialogModal para alocar outros objetos se necessário.
        oPanel := oDialog:GetPanelMain()
        
        oTMultiget1 := tMultiget():new( 020, 020, {| u | if( pCount() > 0, cMensagem := u, cMensagem ) }, oPanel, 260, 92, , , , , , .T. )

        oDialog:Activate()

        If Len(cMensagem) > 0
            If RecLock("SF1", .F.)
                F1_MSGNF := ALLTRIM(LEFT(cMensagem,220)) 
                MsUnlock()
            ENDIF
        Endif
    Endif
Endif
RestArea(aArea)

Return 
