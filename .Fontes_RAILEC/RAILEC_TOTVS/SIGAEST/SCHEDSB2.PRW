#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*/                              
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SCHEDSB2� Autor � S�lon Silva (SigaCorp) � Data �  04/05/11 ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para executar processo especial ON-LINE para execu- ���
���          � tar automaticamente a rotina ATUSB2060.PRW.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function SCHEDSB2()
Conout("Empresa: 06 Filial: 01")
RPCSetType(3) //n�o consome licen�a.
PREPARE ENVIRONMENT EMPRESA '06' FILIAL '01' MODULO 'FAT'
Conout("SCHEDSB2 - Iniciando   rotinas scheduladas em " + dtoc(date()) + " as " + time())
U_ATUSB2()
Conout("SCHEDSB2 - Finalizando rotinas scheduladas em " + dtoc(date()) + " as " + time())
RESET ENVIRONMENT
Return(.T.)
