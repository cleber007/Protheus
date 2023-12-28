#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
/*/{Protheus.doc} fImpCsv
Fonte utilizado para importar REGISTROS DE CLIENTES, através do arquivo TXT/CSV
				ATENÇÃO
Neste arquivo, importamos os campos A1_COD, A1_LOJA, A1_NOME, A1_PESSOA, A1_NREDUZ
Vale lembrar que temos que observar os campos obrigatórios que existem dentro do sistema.
@type function
@author SISTEMATIZEI
@since 16/09/2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function fImpCsv() 
Local cDiret
Local cLinha  := ""
Local lPrimlin   := .T.
Local aCampos := {}
Local aDados  := {}
Local i
Local j 
Private aErro := {}
 
cDiret :=  cGetFile( 'Arquito CSV|*.csv| Arquivo TXT|*.txt| Arquivo XML|*.xml',; //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         'C:\TOTVS\',;                            //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)         

FT_FUSE(cDiret)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
 
	IncProc("Lendo arquivo texto...")
 
	cLinha := FT_FREADLN()
 
	If lPrimlin
		aCampos := Separa(cLinha,";",.T.)
		lPrimlin := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
 
	FT_FSKIP()
EndDo
 
Begin Transaction
	ProcRegua(Len(aDados))
	For i:=1 to Len(aDados)
 
		IncProc("Importando Registros...")
 
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbGoTop()
		If !dbSeek(xFilial("SA1")+aDados[i,1]+aDados[i,2])
			Reclock("SA1",.T.)
			SA1->A1_FILIAL := xFilial("SA1")
			For j:=1 to Len(aCampos)
				cCampo  := "SA1->" + aCampos[j] //SA1->A1_COD
				&cCampo := aDados[i,j] //SA1->A1_COD := 000008   SA1->A1_LOJA := 01 SA1->A1_NOME := JOSE
			Next j
			SA1->(MsUnlock())
		EndIf
	Next i
End Transaction
  
ApMsgInfo("Importação concluída com sucesso!","Sucesso!")
 
Return