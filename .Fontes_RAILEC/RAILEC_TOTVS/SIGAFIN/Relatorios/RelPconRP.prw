#Include "FIVEWIN.CH"
#include "tbiconn.ch"
#include "TbiCode.ch"    
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#INCLUDE "PROTHEUS.CH"
#Include "Totvs.ch"
#Define CRL Chr(13)+Chr(10)

********************************************************************
User function RelPconRP(_dDtIni,_dDtFim,_nDedIR,_cFilIni,_cFilFim) //3010/18 - Fabio Yoshioka - Solicita豫o feita no chamado  20677 
********************************************************************
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Presta豫o de contas"
//Local cPict          := ""
Local titulo       	:= "Relatorio de Presta豫o de contas"
Local nLin         	:= 80

                     //	           1         2         3         4         5         6         7         8         9         0   	   1         2         3         4         5         6         7         8         9        20
					//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"	
Local Cabec1       	:= "Dt Despesa | Numero      | Fornecedor                         | Despesa                       | Tipo | Valor Total            | Abatimentos            | Vencimento  | Deduz IR | Complemento     " //"Dt Despesa | Numero               | Fornecedor               | Despesa             | Tipo | Valor Total            | Vencimento  | Deduz IR | Complemento     "
Local Cabec2       	:= ""                                                                                                                                             
Local aOrd 				:= {}
Private lEnd         := .F.
Private lAbortPrint	:= .F.
Private CbTxt     	:= ""
Private limite    	:= 220
Private tamanho   	:= "G"
Private nomeprog  	:= "RelPconRP" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo     	:= 15
Private aReturn   	:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey	:= 0
//Private cbtxt     	:= Space(10)
Private cbcont    	:= 00
Private CONTFL    	:= 01
Private m_pag     	:= 01
Private wnrel     	:= "RelPconRP" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	:= "ZV1"
Private aParams		:= {}
Private _dDataIni:=_dDtIni
Private _dDataFim:=_dDtFim
Private _nDeduz:=_nDedIR
Private _cFilialIni:=_cFilIni //01/11/18
Private _cFilialFim:=_cFilFim


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Monta a interface padrao com o usuario...                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔un뇙o    쿝UNREPORT � Autor � AP6 IDE            � Data �  04/09/15   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escri뇙o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS 볍�
굇�          � monta a janela com a regua de processamento.               볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Programa principal                                         볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//Local nOrdem
Local _cQry := ""
           
_cQry:=" SELECT ZV1_COD,ZV1_SEQ,ZV1_CODSOL,ZV1_NSOLIC,ZV1_EMISSA,ZV1_MATRIC,ZV1_NFUNC,ZV1_DTVENC,"
_cQry+=" ZV1_STATUS,ZV1_BANCO,ZV1_AGENCI,ZV1_CONTA,ZV1_TOTRET,ZV1_ABATM,ZV2_DATA,ZV3_COD,ZV3_DESCRI,ZV3_TIPO,"
_cQry+=" ZV2_CONTA,ZV2_VALOR,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), ZV2_COMPLE)),'') as COMPLEMENTO ,ZV2_DEDZIR "
_cQry+=" FROM "+ retsqlname("ZV1")+","+retsqlname("ZV2")+","+retsqlname("ZV3")
_cQry+=" where "+retsqlname("ZV1")+".D_E_L_E_T_=' '"
_cQry+=" AND "+retsqlname("ZV2")+".D_E_L_E_T_=' '"
_cQry+=" AND "+retsqlname("ZV3")+".D_E_L_E_T_=' '"
_cQry+=" AND ZV1_FILIAL=ZV2_FILIAL"
//_cQry+=" AND ZV2_FILIAL='"+xfilial("ZV2")+"'"
_cQry+=" AND ZV3_FILIAL='"+xfilial("ZV3")+"'"
_cQry+=" AND ZV1_COD=ZV2_CODVIA "
_cQry+=" AND ZV3_COD=ZV2_CODIGO "
_cQry+=" AND ZV1_EMISSA>='"+DTOS(_dDataIni)+"'"// Solicita豫o via Chamado 20677
_cQry+=" AND ZV1_EMISSA<='"+DTOS(_dDataFim)+"'"
_cQry+=" AND ZV1_FILIAL>='"+_cFilialIni+"'"
_cQry+=" AND ZV1_FILIAL<='"+_cFilialFim+"'"

IF _nDeduz<>3
	//_cQry+=" AND ZV2_DEDZIR="+IIF(MV_PAR03==1,'S','N')
	if _nDeduz==1
		_cQry+=" AND ZV2_DEDZIR='S' "
	else
		_cQry+=" AND ZV2_DEDZIR='N' "
	endif
ENDIF
_cQry+=" ORDER BY ZV2_DATA "

DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "TZV", .F., .T.)
TCQuery _cQry NEW ALIAS 'REL'   
DBSelectArea("REL")
SetRegua(RecCount())
dbGoTop()
While !EOF()

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
   //� Impressao do cabecalho do relatorio. . .                            �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif     
   
    				//	           1         2         3         4         5         6         7         8         9         0   	   1         2         3         4         5         6         7         8         9        20
					//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"	
//al Cabec1       	:= "Dt Despesa | Numero      | Fornecedor                         | Despesa                       | Tipo | Valor Total            | Abatimentos            | Vencimento  | Deduz IR | Complemento     "
   
   @nLin,000 PSAY dtoc(stod(REL->ZV1_EMISSA))//dtoc(stod(REL->ZV2_DATA))//01/11/18 - Solicita�ao Eunice 
   @nLin,011 PSAY "|"
   @nLin,013 PSAY REL->ZV1_COD+REL->ZV1_SEQ
   @nLin,025 PSAY "|"
   @nLin,027 PSAY SUBSTR(REL->ZV1_MATRIC+"-"+REL->ZV1_NFUNC,1,35)
   @nLin,062 PSAY "|"
   @nLin,064 PSAY SUBSTR(REL->ZV3_COD+"-"+REL->ZV3_DESCRI,1,30)
   @nLin,094 PSAY "|"
   @nLin,096 PSAY REL->ZV3_TIPO
   @nLin,101 PSAY "|" 
   @nLin,103 PSAY Transform(IIF(REL->ZV3_TIPO=='D',REL->ZV2_VALOR,0),"@E 99,999,999.99")
   @nLin,126 PSAY "|"
   @nLin,128 PSAY Transform(IIF(REL->ZV3_TIPO=='A',REL->ZV2_VALOR,0),"@E 99,999,999.99")
   @nLin,151 PSAY "|"
   @nLin,153 PSAY DTOC(STOD(TZV->ZV1_DTVENC))
   @nLin,165 PSAY "|"
   @nLin,167 PSAY IIF(REL->ZV2_DEDZIR=='S','SIM','NAO')
   @nLin,176 PSAY "|"
   @nLin,178 PSAY REL->COMPLEMENTO

   nLin := nLin + 1 // Avanca a linha de impressao
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo
REL->(DBCloseArea())

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Finaliza a execucao do relatorio...                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SET DEVICE TO SCREEN

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return       

