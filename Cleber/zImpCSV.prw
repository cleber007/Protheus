//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"
  
//Posi��es do Array
Static nPosCodigo := 1 //Coluna A no Excel
Static nPosLojFor := 2 //Coluna B no Excel
Static nPosRazSoc := 3 //Coluna C no Excel
Static nPosObserv := 4 //Coluna D no Excel
  
/*/{Protheus.doc} zImpCSV
Fun��o para importar informa��es do fornecedor via csv
@author Atilio
@since 07/06/2021
@version 1.0
@type function
/*/
  
User Function zImpCSV()
    Local aArea     := GetArea()
    Private cArqOri := ""
  
    //Mostra o Prompt para selecionar arquivos
    cArqOri := tFileDialog( "CSV files (*.csv) ", 'Sele��o de Arquivos', , , .F., )
      
    //Se tiver o arquivo de origem
    If ! Empty(cArqOri)
          
        //Somente se existir o arquivo e for com a extens�o CSV
        If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
            Processa({|| fImporta() }, "Importando...")
        Else
            MsgStop("Arquivo e/ou extens�o inv�lida!", "Aten��o")
        EndIf
    EndIf
      
    RestArea(aArea)
Return
  
/*-------------------------------------------------------------------------------*
 | Func:  fImporta                                                               |
 | Desc:  Fun��o que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
  
Static Function fImporta()
    Local aArea      := GetArea()
    Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".log"
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local cCodForn   := ""
    Local cLojForn   := ""
    Local cObserv    := ""
    Local cRazaoSoc  := ""
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
      
    //Se a pasta de log n�o existir, cria ela
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)
      
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
  
        //Se n�o for fim do arquivo
        If ! (oArquivo:EoF())
  
            //Definindo o tamanho da r�gua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
              
            //M�todo GoTop n�o funciona (dependendo da vers�o da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()
  
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
  
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")
                  
                //Se n�o for o cabe�alho (encontrar o texto "C�digo" na linha atual)
                If ! "c�digo" $ Lower(cLinAtu)
  
                    //Zera as variaveis
                    cCodForn   := aLinha[nPosCodigo]
                    cLojForn   := aLinha[nPosLojFor]
                    cRazaoSoc  := aLinha[nPosRazSoc]
                    cObserv    := aLinha[nPosObserv]
  
                    DbSelectArea('SA2')
                    SA2->(DbSetOrder(1)) // Filial + C�digo + Loja
  
                    //Se conseguir posicionar no fornecedor
                    If SA2->(DbSeek(FWxFilial('SA2') + cCodForn + cLojForn))
                        cLog += "+ Lin" + cValToChar(nLinhaAtu) + ", fornecedor [" + cCodForn + cLojForn + " - " + Upper(SA2->A2_NREDUZ) + "] " +;
                            "a observa��o foi alterada, antes: [" + Alltrim(SA2->A2_X_OBS) + "], agora: [" + Alltrim(cObserv) + "];" + CRLF
  
                        //Realiza a altera��o do fornecedor
                        RecLock('SA2', .F.)
                            SA2->A2_X_OBS  := cObserv
                        SA2->(MsUnlock())
  
                    Else
                        cLog += "- Lin" + cValToChar(nLinhaAtu) + ", fornecedor e loja [" + cCodForn + cLojForn + "] n�o encontrados no Protheus;" + CRLF
                    EndIf
                      
                Else
                    cLog += "- Lin" + cValToChar(nLinhaAtu) + ", linha n�o processada - cabe�alho;" + CRLF
                EndIf
                  
            EndDo
  
            //Se tiver log, mostra ele
            If ! Empty(cLog)
                cLog := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
                MemoWrite(cDirLog + cArqLog, cLog)
                ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
            EndIf
  
        Else
            MsgStop("Arquivo n�o tem conte�do!", "Aten��o")
        EndIf
  
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo n�o pode ser aberto!", "Aten��o")
    EndIf
  
    RestArea(aArea)
Return
