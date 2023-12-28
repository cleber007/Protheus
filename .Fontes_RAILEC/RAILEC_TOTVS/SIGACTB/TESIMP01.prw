#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TESIMP01  � Autor � Rafael Almeida(SIGACORP)�Data� 27/06/16 ���
�������������������������������������������������������������������������͹��
���Descricao �     Rotina para executar a mudanca do parametro MV_TESIMP1 ���
���          � para editar as TES que ser�o utilizadas na contabiliza��o  ���
���          � chamada no lan�amento padrao 650/001                       ���
�������������������������������������������������������������������������͹��
���Uso       � Estoque/U_LP650_001                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TESIMP01()
Local aArea:= GetArea()
Local cTes := Space(250)
Local _cTes := Space(250)

_cTes 	:= Alltrim(GetMv("AL_TESIMP1"))
cTes 	:= Alltrim(GetMv("AL_TESIMP1"))+space(250-len(alltrim(_cTes)))

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("PREENCHER CAMPO")
@ 02,02 TO 90,185
@ 10,018 Say " Esta rotina tem como finalidade informar quais TES P/IMPORTA��O "
@ 18,018 Say " para materias que ser� utilizado na contabiliza��o."
@ 26,018 Say " "
@ 30,018 Say " " + "Conte�do Atual TES:  "
@ 30,075 Get _cTes Picture "@!S36" Size 100,15 when .f.
@ 50,018 Say " " + "Novo Conte�do  TES:  "
@ 50,075 Get  cTes Picture "@!S36" Size 100,15
@ 70,128 BMPBUTTON TYPE 01 ACTION RotExeTes(cTes)
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)
Activate Dialog oDlg Centered

RestArea(aArea)

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RotExeTes � Autor � Rafael Almeida(SIGACORP) �Data � 27/06/16���
�������������������������������������������������������������������������͹��
���Descricao �     Rotina para executar a mudanca do parametro MV_TESIMP1 ���
���          � para editar as TES que ser�o utilizadas na contabiliza��o  ���
���          � chamada no lan�amento padrao 650/001                       ���
�������������������������������������������������������������������������͹��
���Uso       � Estoque/U_LP650_001                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RotExeTes(cTes)

PutMV("AL_TESIMP1",cTes)

Close(oDlg)

Return
