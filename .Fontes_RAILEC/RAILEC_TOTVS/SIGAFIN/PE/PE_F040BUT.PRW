#Include "Protheus.ch" 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AluFINxFUN     Autor  �Denis Haruo       � Data �  11/11/13     ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��es Genericas da Al�ada Financeira e Pontos de Entrada     ���
���          �O objetivo deste fonte � reunir todos os PEs do mod Financeiro ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//*************************
User Function F040BUT()
//*************************


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local _aOpcMenu:={}

//aAdd( _aOpcMenu,	{ "Boleto Banc�rio" ,"U_BLTCDBAR"        , 0 , 6 })
aAdd( _aOpcMenu ,   { "BUDGETY" , {|| U_BLTCDBAR() } , "Boleto Banc�rio" } )

Return _aOpcMenu      
