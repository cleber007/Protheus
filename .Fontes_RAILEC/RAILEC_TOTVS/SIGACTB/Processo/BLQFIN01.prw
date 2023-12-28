#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BLQFIN01  � Autor � Solon Silva (SIGACORP) �Data � 12/06/13 ���
�������������������������������������������������������������������������͹��
���Descricao �     Rotina para executar a mudanca do parametro MV_DATAFIN ���
���          � para evitar inclusao, alteracao e exclusao no financeiro.  ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BLQFIN01()
Local aArea:= GetArea()
Local cData := GetMv("MV_DATAFIN")

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("PREENCHER CAMPO")
@ 02,02 TO 90,190
@ 10,018 Say " Esta rotina  tem  como finalidade preencher a data de  BLOQUEIO DO "
@ 18,018 Say " FINANCEIRO, impedindo inclus�o, altera��o e exclus�o at� a data in- "
@ 26,018 Say " formada.                                                         "
@ 50,018 Say " " + "DT.BLOQ.:  "
@ 50,058 Get cData Size 35,15
@ 70,128 BMPBUTTON TYPE 01 ACTION Rot_Exec(cData)
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)
Activate Dialog oDlg Centered

RestArea(aArea)

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ROT_EXEC  � Autor � Solon Silva (SIGACORP) �Data � 13/08/12 ���
�������������������������������������������������������������������������͹��
���Descricao �     Rotina para executar a mudanca do parametro MV_DBLQMOV ���
���          � para evitar inclusao, alteracao e    ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Rot_Exec(cData)

PutMV("MV_DATAFIN",cData)

Close(oDlg)

Return
