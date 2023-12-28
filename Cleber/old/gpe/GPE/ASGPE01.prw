#INCLUDE "XMLXFUN.CH"
#INCLUDE "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc}ASGPE01

@author    Rafael Bai�o
@version   1.00
@since     31/03/2021
/*/
//------------------------------------------------------------------------------------------
User Function ASGPE01()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aSays := {}
Local aButtons := {}
Local nOpca := 0

Private cCadastro := OemToAnsi(OemtoAnsi("F�CIL-DF"))
Private _cString := "SR0"
Private _cPerg   := "VTFACIL"
Private _oGeraTxt

AjustaSX1()
Pergunte(_cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
AADD(aSays,OemToAnsi( " Este programa ira gerar um arquivo de exportacao de Vale Transporte em XML," ) )
AADD(aSays,OemToAnsi( " para a empresa F�CIL-DF                                                     " ) )
AADD(aSays,OemToAnsi( " " ) )


AADD(aButtons, { 5,.T.,{|| Pergunte(_cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CTBOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

IF nOpca == 1
Processa({|lEnd| OkGeraTrb()})
Endif


Return





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATRB� Autor  � AP5 IDE            � Data �  31/03/21   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OkGeraTrb()

Local  _cEFilMat := ""
Local  _cChave := ""
Local  _cCc := ""
Local  _aRecTrf  := {}
Local  _cFilialD := ""
Local  _cMatD := ""
Local  _cInicio  := ""
Local  _cFim := ""
Local  _cAlias   := ""
Local  _totcli   := 0
Local  _totger   := 0

//������������������������������������������������������������������Ŀ
//� Variaveis utilizadas na pergunte                                 �
//� mv_par01 // Filial de                                         �
//� mv_par02 // Filial ate                                        �
//� mv_par03 // Data de referencia                                �
//� mv_par04 // Tipo de geracao(Carga Inicial\Atualizacao)        �
//� mv_par05 // Path destino geracao                              �
//� mv_par06 // Meio de                                           �
//� mv_par07 // Meio ate                                          �
//��������������������������������������������������������������������
Local cFilDe     :=  mv_par01
Local cFilAte    :=  mv_par02
Local cCcDe      :=  mv_par03
Local cCCAte     :=  mv_par04
Local cMatDe     :=  mv_par05
Local cMatAte    :=  mv_par06
Local dDATREF    :=  mv_par07 //mv_par04
Local nTipGer    :=  "" //mv_par05
Local cPath      :=  "" //mv_par06 //Substr(mv_par05,1,Rat("\",mv_par05))
Local byOrd      :=  0
Local cSituacao  := MV_PAR09
Local cCategoria := MV_PAR10
Local cTipo      := MV_PAR11

Local _cCpo, xRegistro1, xRegistro2, xRegistro3, xRegistro4,xRegistro5 := ""
Local _cRazao := ""
Local _cFilialAnt := "!!"
Local _aInfo := {}
Local cAliasSRA := "SRA"
Local cAliasSR0 := "SR0"
Local cAliasSRN := "SRN"

Local aStruSRA := NIL
Local nX := 0
Local cError   := ""
Local cWarning := ""
Local oScript

Local cFilAnte := xFilial("SRA")


//"NOME", "CPF", "NASCIMENTO", "MATRICULA", "VT BENEFICIO,"
cSQL := "SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CIC, SRA.RA_RG,SRA.RA_RGEXP,SRA.RA_SEXO,SUM(SR0.R0_VALCAL) AS VALCAL, SRA.RA_XFACIL, SR0.R0_CODIGO"
cSQL += " FROM " + RetSqlName(cAliasSRA)+ " AS SRA," + RetSqlName(cAliasSR0)+ " AS SR0," + RetSqlName(cAliasSRN) + " AS SRN"
cSQL += " WHERE "
cSQL += " SRA.RA_FILIAL  between  '" + cFilDe +"' AND '" +cFilAte  +"' AND "
cSQL += " SRA.RA_MAT between  '" + cMatDe +"' AND '" +cMatAte  +"' AND "
cSQL += " SRA.RA_CC  between  '" + cCcDe  +"' AND '" +cCcAte   +"' AND "
cSQL += " R0_PERIOD  = '"+ SubStr(Dtos(dDATREF),1,6) +"' AND "
cSQL += " SRA.RA_SITFOLH <> 'D'     AND "
cSQL += " (SR0.R0_FILIAL = SRA.RA_FILIAL     AND "
cSQL += " SR0.R0_MAT = SRA.RA_MAT            AND "
cSQL += " SR0.R0_VALCAL > 0                  AND "
cSQL += " SR0.R0_TPVALE = '0'                  AND "
cSQL += " SR0.R0_CODIGO = SRN.RN_COD          AND "
cSQL += " SRN.RN_BNFFOR = '1'                 AND "
cSQL += " SR0.R0_FILIAL = SRN.RN_FILIAL)     AND "
cSQL += " SRA.D_E_L_E_T_ <> '*'              AND "
cSQL += " SR0.D_E_L_E_T_ <> '*'                  "
cSQL += " GROUP BY SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CIC, SRA.RA_RG,SRA.RA_RGEXP,SRA.RA_SEXO,SRA.RA_XFACIL,SR0.R0_CODIGO"
//cSQL += " ORDER BY " + SqlOrder(" SRA.RA_FILIAL, SRA.RA_MAT " )

//VERIFIFICAR RESULTADO DA QUERY
MEMOWRITE("C:/TEMP/asgpe01.sql",cSql)


cSQL     := ChangeQuery(cSQL)
aStruSRA := (cAliasSRA)->(dbStruct())
cAliasSRA:= "QSRA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cAliasSRA,.F.,.T.)
For nX := 1 To Len(aStruSRA)
If ( aStruSRA[nX][2] <> "C" )
TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
EndIf
Next nX


//��������������������������������������������������������������Ŀ
//�                                �
//����������������������������������������������������������������
//cScript := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> <DSImpCEValor xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
cScript := ''

cScript += '<?xml version="1.0"?>'

If cTipo == 2
cScript += '<DSImpCEValor>'+chr(13)+chr(10)
Else
cScript += '<DSImpComum xmlns="http://tempuri.org/DSImpComum.xsd">'+chr(13)+chr(10)
Endif

//��������������������������������������������������������������Ŀ
//� Carrega Regua Processamento                                �
//����������������������������������������������������������������
dbSelectArea("QSRA")
dbGoTop()
ProcRegua(QSRA->(RecCount()))
While !Eof( )

//��������������������������������������������������������������Ŀ
//� Move Regua Processamento                                   �
//����������������������������������������������������������������
IncProc("Gerando Vale Transporte F�CIL")



//Script XML a gerar objeto
//registro 3
//>RA_XCARFAC / SRA->RA_XFACIL"+""+"
If cTipo == 2
cScript += "<CE>"+chr(13)+chr(10)
cScript += "    <Nome>"+ALLTRIM(QSRA->RA_NOME)+"</Nome>" +chr(13)+chr(10)
cScript += "    <CPF>"   +ALLTRIM(Transform(QSRA->RA_CIC,"@R 999.999.999-99"))+"</CPF>"+chr(13)+chr(10)
cScript += "    <Cartao>"+ALLTRIM(Transform(QSRA->RA_XFACIL,"@R 9.999.999.999"))+"</Cartao>"+chr(13)+chr(10)
cScript += "    <Valor>" +ALLTRIM(Transform(VALCAL,"@R 999999999.99"))      +"</Valor>"+chr(13)+chr(10)
cScript += "</CE>"
Else
cScript += "<Comuns>"+chr(13)+chr(10)
cScript += "  <Nome>"+ALLTRIM(QSRA->RA_NOME)+"</Nome>"+chr(13)+chr(10)
cScript += "  <Emissor>"+ALLTRIM(QSRA->RA_RGEXP)+"</Emissor>"+chr(13)+chr(10)
cScript += "  <RG>"+ALLTRIM(QSRA->RA_RG)+"</RG>"+chr(13)+chr(10)
cScript += "  <CPF>"+ALLTRIM(Transform(QSRA->RA_CIC,"@R 999.999.999-99"))+"</CPF>"+chr(13)+chr(10)
cScript += "  <Sexo>"+QSRA->RA_SEXO+"</Sexo>"+chr(13)+chr(10)
cScript += "  <Email>*</Email>"+chr(13)+chr(10)
cScript += "  <CEP>*</CEP>"+chr(13)+chr(10)
cScript += "  <Estado>*</Estado>"+chr(13)+chr(10)
cScript += "  <Cidade>*</Cidade>"+chr(13)+chr(10)
cScript += "  <Bairro>*</Bairro>"+chr(13)+chr(10)
cScript += "  <Endereco>*</Endereco>"+chr(13)+chr(10)
cScript += "  <Site/>"+chr(13)+chr(10)
cScript += "  <Celular>*</Celular>"+chr(13)+chr(10)
cScript += "  <Fax>*</Fax>"+chr(13)+chr(10)
cScript += "  <Telefone>*</Telefone>"+chr(13)+chr(10)
cScript += "</Comuns>"+chr(13)+chr(10)
Endif


//Aqui
//Fazer Seek da chave na SRA com o cont�udo posicionado da QSRA e alterar o cont�udo do 
//campo SR0->R0_PEDIDO para 2 - Concl�ido
//

DbSelectArea("SR0")
SR0->(DbSetOrder(1))

If SR0->(DbSeek(QSRA->RA_FILIAL + QSRA->RA_MAT + QSRA->R0_CODIGO + "0"))

    RecLock('SR0', .F.)
        SR0->R0_PEDIDO := "2"
    SR0->(MsUnLock())

EndIf

DbSelectArea("SR0")

dbSelectArea("QSRA")
dbSkip()

Enddo

//registro 10
If cTipo == 2
cScript += "</DSImpCEValor>"+chr(13)+chr(10)
Else
cScript += "</DSImpComum>"+chr(13)+chr(10)
Endif


//Gera o Objeto XML ref. ao script
oScript := XmlParser( cScript, "_", @cError, @cWarning )

If (oScript == NIL )
MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
dbCloseArea("QSRA")
Return
Endif

//Tranforma o Objeto XML em arquivo
SAVE oScript XMLFILE mv_par08                //"C:\TEMP\teste.xml"

//ConOut(cError)

dbCloseArea("QSRA")
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Rafael Baiao      � Data �31.03.2021���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria as perguntas necesarias para o programa                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaSX1()

Local aHelpPor :={}
Local aHelpEng :={}
Local aHelpSpa :={}

//-----------------------MV_PAR01--------------------------
Aadd( aHelpPor, "Filial de  " )
Aadd( aHelpEng, "Filial de  " )
Aadd( aHelpSpa, "Filial de  " )

PutSx1( "VTFACIL","01","Filial de ?","Filial de?","Filial de?","mv_ch1",;
"C",02,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

//-----------------------MV_PAR02--------------------------
Aadd( aHelpPor, "Filial ate  " )
Aadd( aHelpEng, "Filial ate  " )
Aadd( aHelpSpa, "Filial ate  " )

PutSx1( "VTFACIL","02","Filial at� ?","Filial at�?","Filial at�?","mv_ch2",;
"C",02,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)


//-----------------------MV_PAR02--------------------------
Aadd( aHelpPor, "Centro de custo de " )
Aadd( aHelpEng, "Centro de custo de" )
Aadd( aHelpSpa, "Centro de custo de" )

PutSx1("VTFACIL","03","Centro de Custo De ?"  ,"� De Centro de Costo ?" ,"From Cost Center ?"     ,"mv_ch3",;
"C",09,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)


//-----------------------MV_PAR02--------------------------
Aadd( aHelpPor, "Centro de custo ate " )
Aadd( aHelpEng, "Centro de custo ate" )
Aadd( aHelpSpa, "Centro de custo ate" )

PutSx1( "VTFACIL","04","Centro de Custo Ate ?" ,"� A Centro de Costo ?"  ,"To Cost Center ?"       ,"mv_ch4",;
"C",09,0,0,"G","NaoVazio","","","","mv_par04","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

PutSx1("VTFACIL","05","Matricula De ?"        ,"� De Matricula ?"       ,"From Registration ?"    ,"mv_ch5",;
"C",06,0,0,"G","","","","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","")

PutSx1("VTFACIL","06","Matricula Ate ?"       ,"� A Matricula ?"        ,"To Registration ?"      ,"mv_ch6",;
"C",06,0,0,"G","NaoVazio","","","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","")


//-----------------------MV_PAR03--------------------------
Aadd( aHelpPor, "Refer�ncia " )
Aadd( aHelpEng, "Refer�ncia " )
Aadd( aHelpSpa, "Refer�ncia " )

PutSx1( "VTFACIL","07","Referencia?","Referencia?","Referencia?","mv_ch7",;
"D",08,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

//-----------------------MV_PAR04--------------------------
Aadd( aHelpPor, "Caminho?    " )
Aadd( aHelpEng, "Caminho?    " )
Aadd( aHelpSpa, "Caminho?    " )

PutSx1( "VTFACIL","08","Caminho ?","Caminho ?","Caminho?","mv_ch8",;
"C",25,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)


//-----------------------MV_PAR05--------------------------
Aadd( aHelpPor, "Situa��o?" )
Aadd( aHelpEng, "Situa��o?" )
Aadd( aHelpSpa, "Situa��o?" )

PutSx1( "VTFACIL","09","Situacoes ?","Situaciones ?","Situations ?","mv_ch9",;
"C",05,0,0,"G","fSituacao","","","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" )

//-----------------------MV_PAR06--------------------------
Aadd( aHelpPor, "Categoria?" )
Aadd( aHelpEng, "Categoria?" )
Aadd( aHelpSpa, "Categoria?" )

PutSx1( "VTFACIL","10","Categorias ?","Categorias ?","Classes ?","mv_cha",;
"C",15,0,0,"G","fCategoria","","","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","" ,"","","","")

//-----------------------MV_PAR04--------------------------
Aadd( aHelpPor, "Tipo?    " )
Aadd( aHelpEng, "Tipo?    " )
Aadd( aHelpSpa, "Tipo?    " )

PutSx1( "VTFACIL","11","Tipo ?","Tipo ?","Tipo?","mv_chb",;
"N",01,0,0,"C","","","","","mv_par11","Pedido","Pedido","Pedido","","Compra","Compra","Compra","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)


Return
