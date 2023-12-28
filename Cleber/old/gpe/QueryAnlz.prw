#include "rwmake.ch"
#include "topconn.ch" 
#include "protheus.ch"   


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  14/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function QUERYANLZ


Local aArea := GetArea() 
Local aSizeAut  := MsAdvSize( .F. )    // Array para redimensionamento da tela
Local aObjects  := {}					// Array para redimensionamento da tela
Local aPosObj   := {}					// Array para redimensionamento da tela
Local nOpc:=0,bOk:={||nOpc:=1,FecharDlg()}
Local bCancel := {||nOpc:=0,FecharDlg()}
Private cResult:=''
Private oMemo,oMemo2
Private aCposTbl:={}  
Private aGrid:={}  
Private aBrw:={} 

aButtons := {;
             {"ALTERA" ,{|| ToOpen(@cQuery,oMemo) } ,"Abrir"  },;
             {"S4WB001N" ,{|| ToSave(cQuery) } ,"Salvar"  },;
             {"DBG07" ,{|| ToExec(cQuery,oBrw) } ,"Executar"  },;
             {"EDIT" ,{|| ToUpd(cQuery,oBrw) } ,"Update"  },;
             {"AUTOM"   ,{|| ToExcel(aCposTbl) } ,"Exp. Excel"  } }

 


cQuery :=space(1000)

ToExec("SELECT 1 FROM "+RetSqlName('SE4'),nil)

DbSelectArea("QRY")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo automatico de dimensoes dos objetos                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( aObjects, { 100, 100, .t., .t. } ) 
AAdd( aObjects, { 080, 100, .f., .t. } ) 

aInfo := { aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3 } 
aObj  := MsObjSize( aInfo, aObjects, , .T. ) 

@ aSizeAut[7]+20,00 TO aSizeAut[6],aSizeAut[5] Dialog owCarga Title OemToAnsi("Query")
@ 33,000 GET oMemo  VAR cQuery MEMO SIZE 250,50 OF owCarga PIXEL 
@ 33,255 GET oMemo2 VAR cResult MEMO SIZE 250,50 OF owCarga PIXEL when .f.

oBrw := TCBrowse():New( 92, 0, 625, 225,,,, owCarga,,,,,,,,,,,, .F.,, .T.,, .F., )

Activate Dialog owCarga ON INIT EnchoiceBar(owCarga,bOk,bCancel,.F.,aButtons) //Centered

QRY->(DbCloseArea())

RestArea(aArea)

Return nil

                                 
//****************************************************************************************
Static Function FecharDlg()
Close(owCarga)
Return nil

//****************************************************************************************

Static Function ToSave(cQuery)

cTipo :=         "Arquivos textos    (*.QRY) | *.qyr | "
cTipo := cTipo + "Todos os Arquivos  (*.*)   | *.*     "
cFile := cGetFile(cTipo,"Selecione arquivo a ser importado")
If cFile<>""
  FErase(cFile)
  MemoWrite(cFile,cQuery)
endif 
if File(cFile)
  Alert('Arquivo '+cFile+' salvo com sucesso!')
endif 
Return()



Static Function Erro(e)
IF e:gencode > 0
	lErro := .T.
	Aviso("Mensagem de Erro: ",e:Description,{"Ok"})
	BREAK
ENDIF
Return 

//****************************************************************************************
Static Function ToExec(cQuery,oBrwQry)
// Salva bloco de código do tratamento de erro
//Local oError := ErrorBlock({|e|;
//      Aviso("Mensagem de Erro: ",e:Description,{"Ok"}),lRet:= .F.})
Local bBlock:=ErrorBlock()
Local bErro := errorBlock( { |e| Erro(e) } )
Local nCpoTbl
Private lErro := .F.


aGrid:={}
aBrw:={}
aFields:={}

If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
Endif 

BEGIN SEQUENCE
  cQuery:=StrTran(cQuery,CHR(13),' ')  
  cQuery:=Alltrim(StrTran(cQuery,CHR(10),' '))
  if !SubStr( cQuery ,1 , 1) =='"' 
    cQuery:='"'+cQuery+'"'
  endif       
  cQuery:=&(cQuery) 
  TCQUERY cQuery NEW ALIAS "QRY"   
  DbSelectArea("QRY") 
END SEQUENCE

ErrorBlock(bBlock)
      
if lErro .or. ("QRY") ->(Eof())
  If Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
  Endif 
  TCQUERY " SELECT 'NULL' " NEW ALIAS "QRY"
  DbSelectArea("QRY")  
endif  
 
aCposTbl := QRY->(dbStruct())

QRY -> ( dbEval(	{ || aEval(aCposTbl, {|e| aadd(aFields, &(("QRY")->(e[1])) ,Nil)}), aAdd( aBrw,  aFields  ),aFields:={} },NIL,NIL      )  )

if oBrwQry<>nil 
  oBrw:ACOLUMNS:={}
  oBrw:Refresh()
endif

SX3->(DbSetOrder(2))

If Len(aCposTbl) > 0								/// SE NAO RETORNOU NADA NA ESTRUTURA NAO MEXE NOS CAMPOS
		For nCpoTbl := 1 to Len(aCposTbl)
			cTitulo:=aCposTbl[nCpoTbl,1] 
			cPict:=nil
			nTama:=aCposTbl[nCpoTbl,3]
            If SX3->(DbSeek(aCposTbl[nCpoTbl,1])) 
                if SX3->X3_TIPO <> "C" .And. SX3->X3_TIPO <> "M"
				  TCSetField("QRY", 	SX3->X3_CAMPO, SX3->X3_TIPO,SX3->X3_TAMANHO, SX3->X3_DECIMAL)
				endif  
				cTitulo:=SX3->X3_TITULO
				cPict  :=SX3->X3_PICTURE
				nTama  :=SX3->X3_TAMANHO
				aCposTbl[nCpoTbl,2]:=SX3->X3_TIPO
			Endif			
            AADD(aGrid,{aCposTbl[nCpoTbl,1],cTitulo		,cPict})
            
            if oBrwQry<>nil
                                                                
		      If aCposTbl[nCpoTbl,2] != "N" .and. aCposTbl[nCpoTbl,2] != "D"
			    oCol := TCColumn():New( cTitulo, {|| aBrw[oBrw:nAt,nCpoTbl] } ,,,, If(!.F.,"LEFT", Upper()), , .F., .F.,,,, .F., )
			  Else  
			    oCol := TCColumn():New( cTitulo, {|| aBrw[oBrw:nAt,nCpoTbl] },cPict,,, If(!.T.,"LEFT", Upper("RIGHT")), , .F., .F.,,,, .F., )
		      Endif
		      If aCposTbl[nCpoTbl,2] = "D"
			     bLin:='{|| Dtoc(sTod(aBrw[oBrw:nAt,'+Alltrim(str(nCpoTbl))+']))}' 
			  Else   
			     bLin:='{|| aBrw[oBrw:nAt,'+Alltrim(str(nCpoTbl))+']}' 
			  Endif   
		      oCol:bdata:=&(blin)
		      oBrw:ADDCOLUMN(oCol)
			endif  
		Next
Endif 

if oBrwQry<>nil
  oBrw:SetArray(aBrw)
endif 

dbSelectArea("QRY")          
DbGotop()

Return 

//****************************************************************************************
Static Function ToUpd(cQuery,oBrwQry)
// Salva bloco de código do tratamento de erro
//Local oError := ErrorBlock({|e|;
//      Aviso("Mensagem de Erro: ",e:Description,{"Ok"}),lRet:= .F.})
Local bBlock:=ErrorBlock()
Local bErro := errorBlock( { |e| Erro(e) } )
Local i
Private lErro := .F.

if !PswAdmin(,,RetCodUsr())=0  
  MsgStop('Rotina apenas para administradores') 
  return
endif

BEGIN SEQUENCE
  
  //aCMD:=u_SplitLine(cQuery,';')
  aCMD:=StrToKarr(cQuery,';')
  for i:=1 to Len(aCMD)
    cQry:=aCMD[i] 
    if Len(Alltrim(cQry))>0
      If (TCSQLExec(cQry) < 0)
        Return MsgStop("TCSQLError() " + TCSQLError())
      else
        if i=Len(aCMD)
          MsgStop('Update executado')  
        endif  
      EndIf
   Endif
  next i  
  
END SEQUENCE

ErrorBlock(bBlock)

dbSelectArea("QRY")          
DbGotop()

Return 


//****************************************************************************************

Static Function ToOpen(cQuery,oMemo)
Private nHandle

cTipo :=         "Arquivos textos    (*.QRY) | *.qry | "
cTipo := cTipo + "Todos os Arquivos  (*.*)   | *.*     "

cFile := cGetFile(cTipo,"Selecione arquivo a ser importado")

FT_FUSE(cFile) // abre o arquivo
cString  := FT_FREADLN() 
cQuery   := cString
while Alltrim(cString) <> ''  
	//Proxima linha
	FT_FSKIP()
	cString  := FT_FREADLN()  
	cQuery   += cString
enddo
cQuery   +=space(1000)
FCLOSE(nHandle)
oMemo:Refresh()
Return

//****************************************************************************************

Static Function ToExcel(aCampos)
Processa( { || ToProcEx(aCampos) } )
Return

Static Function ToProcEx(aCampos)
LOCAL cDirDocs   := MsDocPath() 
Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX,i

if Len(aCampos)=0
  MsgAlert( 'Não há dados para exportar!' )
  Return
endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	IncProc("Aguarde! Gerando arquivo de integração com Excel...") // 
	aEval(aStru, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aCampos), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha
	
	DbSelectArea("QRY")
    DbGoTop()
	for i:=1 to len(aCampos) 
	  nomecampo:=aCampos[i,1]
      If SX3->(DbSeek(nomecampo)) 
		nomecampo:=SX3->X3_TITULO
	  Endif	    
	  fWrite(nHandle, Transform(nomecampo,"") + ";" )
	next i 
	fWrite(nHandle, cCrLf ) // Pula linha   
    Do while !eof()
		IncProc("Aguarde! Gerando arquivo de integração com Excel...")
		for i:=1 to len(aCampos) 
		  nomecampo:=aCampos[i,1]  
		  //alert(nomecampo)
		  //alert(&nomecampo)
		  if aCampos[i,2]<>'N'
		    fWrite(nHandle, Transform(&nomecampo,"") + ";" )
		  else
		    fWrite(nHandle, Transform(&nomecampo,"@e 99,999,999.99") + ";" )
  		  endif
		next i
		fWrite(nHandle, cCrLf ) // Pula linha
	    DbSkip()    
    EndDo
    DbGoTop()
	
	IncProc("Aguarde! Abrindo o arquivo..." ) //
	
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
	If ! ApOleClient( 'MsExcel' ) 
		MsgAlert( 'MsExcel nao instalado' ) //
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert( "Falha na criação do arquivo" ) // 
Endif	

Return

