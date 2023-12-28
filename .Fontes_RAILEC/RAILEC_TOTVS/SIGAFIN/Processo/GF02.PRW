// +-----------+------------+------------------------------------+-----------------------+
// | Programa  |  GF02.PRW  | Autor: Luiz Sousa                  | Data Atu.: 19/10/2016 |
// +-----------+------------+------------------------------------+-----------------------+
// | Descricao | Rotina utilizada para capturar o caminho e o nome do Arquivo no CNAB.   |
// +-----------+-------------------------------------------------------------------------+
// | Uso       | CNAB - Relatorio de Retorno                                             |
// +-----------+-------------------------------------------------------------------------+

#INCLUDE "rwmake.ch" 

////////////////////
User Function GF02()
////////////////////

//Local _cUsuario := UPPER(ALLTRIM(CUSERNAME))
//Local _cTitulo  := _cUsuario + " -> "  + _cUsuario
Public  __cRetorn := ""

Public _cNomeArq := ""

Private _cTitulo := _cTitulo + 'Escolha o arquivo de Entrada'

MV_PAR01 :=  UPPER(cGetFile('Arquivo *|*.*|Arquivo de Entrada|*.*', _cTitulo, 0,'C:\RELATO\',.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.))

_cNomeArq := MV_PAR01
__cRetorn := _cNomeArq
//__cRetorn	
RETURN (.t.)
//////////////////////////////////////////////////////////////////////////////////////////
