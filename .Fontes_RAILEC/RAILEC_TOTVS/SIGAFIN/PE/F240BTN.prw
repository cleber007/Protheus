#include 'protheus.ch'
#include 'parmtype.ch'


User Function F240BTN() // PE na rotina de Borderôs de Pagamento - Fabio Yoshioka - 26/03/18

Local aButtons:= paramixb

aAdd( aButtons ,{ "FILTRO",{|| ALFIL240()},"Teste"," Filtrar"})

Return aButtons

**************************
Static Function ALFIL240()
**************************
Local _aColunas:={}
Local _cFilSE2:=""
SX3->(dbSetOrder(1))
SX3->(dbSeek("SE2"))

cX3ARQ     := "SX3->X3_ARQUIVO"
cX3CAMPO   := "SX3->X3_CAMPO"
cX3USADO   := "SX3->X3_USADO"
cX3TAMANHO := "SX3->X3_TAMANHO"
cX3DECIMAL := "SX3->X3_DECIMAL"
cX3PICTURE := "SX3->X3_PICTURE"
cX3CBOX    := "SX3->X3_CBOX"
cX3F3      := "SX3->X3_F3"
cX3TIPO    := "SX3->X3_TIPO"
cX3NIVEL   := "SX3->X3_NIVEL"

While !SX3->(EOF()) .And. &(cX3ARQ) == "SE2"
	If (X3Uso(&(cX3USADO)) .And. cNivel >= &(cX3NIVEL)) .Or. AllTrim(&(cX3CAMPO)) == "E2_FILIAL"
		aAdd(_aColunas,{ AllTrim(&(cX3CAMPO)),AllTrim(X3Titulo()),&(cX3TIPO),&(cX3TAMANHO),&(cX3DECIMAL),;
						&(cX3PICTURE),Str2Arr(&(cX3CBOX),";"),&(cX3F3)})
	EndIf                                
	SX3->(dbSkip())
End
	
_oFWFilter := FWFilter():New(GetWndDefault())
_oFWFilter:SetSQLFilter()
_oFWFilter:DisableValid()
_oFWFilter:SetField(_aColunas)
If (lRet := _oFWFilter:FilterBar())		
	//_cFilSE2 += AllTrim(_oFWFilter:GetExprSQL())
	_cFilSE2 += AllTrim(_oFWFilter:GetExprADVPL())
	MsFilter(_cFilSE2)
Endif

oMark:oBrowse:Refresh(.T.)

Return Nil
