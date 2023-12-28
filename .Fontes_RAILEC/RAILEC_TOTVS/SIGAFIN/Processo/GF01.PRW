// +-----------+------------+------------------------------------+-----------------------+
// | Programa  |  GF01.PRW  | Autor: Luiz Sousa                  | Data Atu.: 06/10/2016 |
// +-----------+------------+------------------------------------+-----------------------+
// | Descricao | Rotina utilizada para capturar o caminho e o nome do Arquivo no CNAB.   |
// +-----------+-------------------------------------------------------------------------+
// | Uso       | CNAB                                                                    |
// +-----------+-------------------------------------------------------------------------+

#INCLUDE "rwmake.ch" 
#INCLUDE "TOTVS.CH"


////////////////////////////
User Function GF01(nArquivo)
////////////////////////////

Local _nTpArq   := nArquivo   
Local _cUsuario := UPPER(ALLTRIM(CUSERNAME))
Local _cTitulo  := _cUsuario + " -> "  

Private _cArqSai := ""

Public  __cRetorn := ""

IF _nTpArq = 1
                   
	_cTitulo := _cTitulo + 'Informe o nome do arquivo de Saida'
	MV_PAR04 := UPPER( cGetFile( '*.REM' , _cTitulo, 1, 'C:\TEMP\', .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ),.T., .T. ) )+Space(30)



		
ELSEIF _nTpArq = 2
   
	_cTitulo  := _cTitulo + 'Escolha o arquivo de Entrada'
	MV_PAR04  := UPPER( cGetFile('Arquivo *|*.*|Arquivo de Entrada|*.*', _cTitulo, 0,'C:\TEMP\',.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.) )
	
ENDIF

__cRetorn := MV_PAR04 
//__cRetorn
	
RETURN (.T.)
//////////////////////////////////////////////////////////////////////////////////////////
