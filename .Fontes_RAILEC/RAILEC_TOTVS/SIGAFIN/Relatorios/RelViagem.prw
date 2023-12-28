*****************************************
//Remark: Computadores nใo cometem erros.
*****************************************
#Include "FIVEWIN.CH"
#include "tbiconn.ch"
#include "TbiCode.ch"    
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#INCLUDE "PROTHEUS.CH"
#Include "Totvs.ch"
#Define CRL Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ AP6 IDE            บ Data ณ  04/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RelViagem()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rela็ใo de Viagens"
//Local cPict          := ""
Local titulo       	:= "Rela็ใo de Viagens"
Local nLin         	:= 80
                     //	           1         2         3         4         5         6         7         8         9         0   	   1         2         3         4         5         6         7         8         9        20
							//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"	
Local Cabec1       	:= "Viagem/Seq | Solicitante               | Colaborador               | Cidade Origem             | UF | Cidade Destino            | UF | Partida    | Retorno    | Vl Adiant     | Tp Viagem    |         "
Local Cabec2       	:= ""                                                                                                                                             
Local aOrd 				:= {}
Private lEnd         := .F.
Private lAbortPrint	:= .F.
Private CbTxt     	:= ""
Private limite    	:= 220
Private tamanho   	:= "G"
Private nomeprog  	:= "RelViagem" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo     	:= 15
Private aReturn   	:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey		:= 0
//Private cbtxt     	:= Space(10)
Private cbcont    	:= 00
Private CONTFL    	:= 01
Private m_pag     	:= 01
Private wnrel     	:= "RelViagem" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "ZV1"
Private aParams		:= {}

dbSelectArea("ZV1")
dbSetOrder(1)  

//Pergunta parametros
ParamZV1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  04/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//Local nOrdem
Local cQuery := ""
           
cQuery := ""
cQuery += "SELECT * FROM "+RetSQLName("ZV1")+" "
cQuery += "WHERE 	ZV1_FILIAL = '"+xFilial("ZV1")+"' AND "
cQuery += "			ZV1_DTINI >= '"+DTOS(aParams[1])+"' AND "
cQuery += "			ZV1_DTFIM <= '"+DTOS(aParams[2])+"' AND "
cQuery += "			ZV1_MATRIC BETWEEN '"+aParams[3]+"' AND '"+aParams[4]+"' AND "
cQuery += "			ZV1_CODSOL BETWEEN '"+aParams[5]+"' AND '"+aParams[6]+"' AND "
cQuery += "			D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY ZV1_COD "
TCQuery cQuery NEW ALIAS 'REL'   
DBSelectArea("REL")
SetRegua(RecCount())
dbGoTop()
While !EOF()

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif     

   @nLin,000 PSAY REL->ZV1_COD+"/"+REL->ZV1_SEQ
   @nLin,011 PSAY "|"
   @nLin,013 PSAY SUBSTR(REL->ZV1_NSOLIC,1,25)
   @nLin,039 PSAY "|"
   @nLin,041 PSAY SUBSTR(REL->ZV1_NFUNC,1,25)
   @nLin,067 PSAY "|"
   @nLin,069 PSAY SUBSTR(REL->ZV1_NCORIG,1,25)
   @nLin,095 PSAY "|"
   @nLin,097 PSAY REL->ZV1_ESTORI
   @nLin,100 PSAY "|" 
   @nLin,102 PSAY SubStr(REL->ZV1_NCDEST,1,25)
   @nLin,128 PSAY "|"
   @nLin,130 PSAY REL->ZV1_ESTDES
   @nLin,133 PSAY "|"
   @nLin,135 PSAY DTOC(STOD(REL->ZV1_DTINI))
   @nLin,146 PSAY "|"
   @nLin,148 PSAY DTOC(STOD(REL->ZV1_DTFIM))
   @nLin,159 PSAY "|"
   @nLin,161 PSAY Transform(REL->ZV1_TOTADI,"@E 99,999,999.99")
   @nLin,175 PSAY "|"
   @nLin,177 PSAY IIF(REL->ZV1_TIPO == 'S',"SERVIวO","TREINAMENTO")
   
   nLin := nLin + 1 // Avanca a linha de impressao
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo
REL->(DBCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELVIAGEM บAutor  ณMicrosiga           บ Data ณ  09/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ParamZV1()      
            
Local oButton2
Local oDataAte
Local oDataDe
Local oGroup1
Local oMatricAte
Local oMatricDe
Local oPanel1
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSolicitAte
Local oSolicitDe
Local oDlg

Local lOk := .F.

Local dDataDe := Date()
Local dDataAte := Date()
Local cMatricDe := Space(6)
Local cMatricAte := "ZZZZZZ"
Local cSolicitDe := Space(6)
Local cSolicitAte := "ZZZZZZ"

  DEFINE MSDIALOG oDlg TITLE "Rela็ใo de Viagens" FROM 000, 000  TO 230, 185 COLORS 0, 16777215 PIXEL

    @ 000, 000 MSPANEL oPanel1 SIZE 095, 117 OF oDlg COLORS 0, 15920613 RAISED
    @ 005, 004 GROUP oGroup1 TO 098, 091 PROMPT " Parโmetros " OF oPanel1 COLOR 0, 15920613 PIXEL
    @ 017, 007 SAY oSay1 PROMPT "Perํodo de: " SIZE 032, 007 OF oPanel1 COLORS 0, 15920613 PIXEL
    @ 016, 052 MSGET oDataDe VAR dDataDe SIZE 035, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
    @ 030, 007 SAY oSay2 PROMPT "Perํodo at้: " SIZE 033, 007 OF oPanel1 COLORS 0, 15920613 PIXEL
    @ 029, 052 MSGET oDataAte VAR dDataAte SIZE 035, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
    @ 042, 007 SAY oSay3 PROMPT "Matrํcula de: " SIZE 042, 007 OF oPanel1 COLORS 0, 15920613 PIXEL
    @ 041, 052 MSGET oMatricDe VAR cMatricDe SIZE 035, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
    @ 055, 007 SAY oSay4 PROMPT "Matrํcula at้: " SIZE 043, 007 OF oPanel1 COLORS 0, 15920613 PIXEL
    @ 054, 052 MSGET oMatricAte VAR cMatricAte SIZE 035, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
    @ 067, 007 SAY oSay5 PROMPT "Solicitante de: " SIZE 036, 007 OF oPanel1 COLORS 0, 15920613 PIXEL
    @ 066, 052 MSGET oSolicitDe VAR cSolicitDe SIZE 035, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
    @ 080, 007 SAY oSay6 PROMPT "Solicitante At้: " SIZE 039, 007 OF oPanel1 COLORS 0, 15920613 PIXEL
    @ 078, 052 MSGET oSolicitAte VAR cSolicitAte SIZE 035, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
    @ 101, 053 BUTTON oButton2 PROMPT "OK" SIZE 037, 012 OF oPanel1 PIXEL Action(lOk:=.T.,oDlg:End())

  ACTIVATE MSDIALOG oDlg CENTERED

If lOk
	aAdd(aParams, dDataDe)  
	aAdd(aParams, dDataAte)  
	aAdd(aParams, cMatricDe)  
	aAdd(aParams, cMatricAte)  
	aAdd(aParams, cSolicitDe)  
	aAdd(aParams, cSolicitAte)  
EndIf  

Return
