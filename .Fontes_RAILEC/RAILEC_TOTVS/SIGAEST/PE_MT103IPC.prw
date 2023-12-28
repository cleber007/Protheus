#include "RwMake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103IPC �Autor  � SANDRO ULISSES     � Data �  22/03/2005 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na digitacao da Nota Fiscal de Entrada p/ ���
���          � atualizar a descricao do produto do Pedido de Compras      ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo ALUBAR S/A                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT103IPC()
_lin := paramixb[1]
_Ped := aCols[_lin,Ascan(aHeader,{|x| Alltrim(x[2])=="D1_PEDIDO"})]
_Ite := aCols[_lin,Ascan(aHeader,{|x| Alltrim(x[2])=="D1_ITEMPC"})]
_col := Ascan(aHeader,{|x| Alltrim(x[2])=="D1_DESCRI"})
If _ped == SC7->C7_NUM .and. _Ite == SC7->C7_ITEM
   aCols[_lin,_col]:= SC7->C7_DESCRI
Endif
Return