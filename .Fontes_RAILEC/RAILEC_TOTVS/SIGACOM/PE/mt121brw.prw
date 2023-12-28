// #########################################################################################
// Projeto: alubar_energia
// Modulo : compras
// Fonte  : mt121brw.prw
// -----------+----------------------+-----------------------------------------------------------
// Data       | Autor                | Descricao
// -----------+----------------------+-----------------------------------------------------------
// 21/07/2017 | wildner pinto 	     | Adiciona opções no menu da rotina
// -----------+----------------------+-----------------------------------------------------------

#include "rwmake.ch"
#include 'protheus.ch'

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} mt121brw
LOCALIZAÇÃO : Function MATA120 - Função do Pedido de Compras e Autorização de Entrega.

EM QUE PONTO : Após a montagem do Filtro da tabela SC7 e antes da execução da Mbrowse do PC, 
utilizado para adicionar mais opções no aRotina.

Este ponto de entrada possui a mesma funcionalidade do ponto MT120BRW com o diferencial de que 
possibilita que a rotina MATA121 seja utilizada no Configurador (SIGACFG) para definir regras 
de Privilégios de acesso ao pedido de compras para usuários incluindo o menu personalizado 
do ponto de entrada.

@author    TOTVS | Developer Studio
@version   1.xx
@since     28/10/2015
/*/
//------------------------------------------------------------------------------------------
user function mt121brw()
    aadd(arotina,{"imp. pedido grafico", "u_pedcomweb(sc7->c7_num,sc7->c7_fornece,sc7->c7_loja)", 0, 7, 0, nil})
    //aadd(arotina,{"alterar fornecedor","u_chgforn()",0,8,0,nil})
return
