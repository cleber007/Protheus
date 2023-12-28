#include "rwmake.ch"           // incluido pelo assistente de conversao do AP5 IDE em 22/03/01
User Function Sf2460i()        // incluido pelo assistente de conversao do AP5 IDE em 22/03/01
//*********************

_cArea := Alias()
_nOrd  := IndexOrd()
nReg   :=RecNo()

SA1->(dbSeek(xFilial("SA1") + sf2->f2_cliente + sf2->f2_loja))
While !RecLock("SF2",.f.)
   loop
End    
Repl f2_nomecli with sa1->a1_nreduz
dbCommit()

IF !(SF2->F2_TIPO$"DB")   // SOMENTE RODAR PARA DEVOLUCAO OU UTILIZA FORNECEDOR
    dbSelectArea(_cArea)
    DbSetOrder(_nOrd)
    DbGoTo(nReg)
	Return
ENDIF

_PICM:=SD2->D2_PICM
@ 1,1 to  300,300 DIALOG oDlg2 TITLE "PERCENTUAL DE ICMS...."
@ 44, 20 GET _PICM PICTURE "999" 
@ 90, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered

IF SD2->D2_PICM # _PICM
	DBSELECTAREA("SD2")
	DBSETORDER(3)
	DBSEEK(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE)   // POSICIONA NO PRIMEIRO REG
	WHILE !EOF() .AND. D2_DOC+D2_SERIE+D2_CLIENTE=SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE
		RECLOCK("SD2",.F.)
		SD2->D2_PICM  :=_PICM
		SD2->D2_VALICM:=(SD2->D2_BASEICM*(_PICM/100))
		MSUNLOCK()
		RECLOCK("SF2",.F.)
		SF2->F2_VALICM:=(SF2->F2_BASEICM*(_PICM/100))
		MSUNLOCK()
		RECLOCK("SF3",.F.)
		SF3->F3_VALICM :=(SF3->F3_BASEICM*(_PICM/100))
		SF3->F3_ALIQICM:=_PICM
		MSUNLOCK()
		DBSELECTAREA("SD2")
		DBSKIP()
	ENDDO
ENDIF

dbSelectArea(_cArea)
DbSetOrder(_nOrd)
DbGoTo(nReg)

RETURN





/*
@ 200,1 TO 400,430 DIALOG oDlg1 TITLE "Informe a Especificacao"

cxwCliente := space(6)
lTodos := .f.

@ 006,020 TO 35,200 TITLE "Cliente"
@ 015,025 GET cxwCliente  PICTURE "@!" VALID iif(empty(cxwCliente),.t.,ExistCpo("SX5","80"+cxwCliente)) F3 "80"
@ 036,021 CHECKBOX "Todos Dispon¡veis" VAR lTodos

@ 070,160 BUTTON "_Ok"       SIZE 30,15 ACTION Seleciona()
@ 080,160 BUTTON "_Cancelar" SIZE 30,15 ACTION Close(oDlg1)
    
ACTIVATE DIALOG oDlg1 CENTERED

Return

Static Function Seleciona()

@ 200,1 TO 500,600 DIALOG oDlg2 TITLE "Selecione as Bobinas"


aTmpCpo := {}
aadd(aTmpCpo , {"SIM"     , "C", 02,0})
aadd(aTmpCpo , {"IDENTIF" , "C", 08,0})
aadd(aTmpCpo , {"BOBINA"  , "C", 04,0})
aadd(aTmpCpo , {"PESOL"   , "N", 17,2})
aadd(aTmpCpo , {"PESOB"   , "N", 17,2})
aadd(aTmpCpo , {"LIGA"    , "C", 15,0})
aadd(aTmpCpo , {"ESPEC"   , "C", 06,0})
aadd(aTmpCpo , {"DOC"     , "C", 06,0})
aadd(aTmpCpo , {"EMISSAO" , "D", 08,0})

cArqTemp := CriaTrab(aTmpCpo,.t.)
dbUseArea(.t.,,cArqTemp,"TMP",.f.)

dbSelectArea("SHZ")
dbSetOrder(4)
dbSeek(xFilial() + cxwCliente,.T.)
If lTodos
   dbSetOrder(3)
   dbSeek(xFilial())
Endif

While !eof() .and. iif(lTodos,empty(hz_nf),cxwCliente == shz->hz_cliente)
   If empty(hz_nf) .and. hz_produzi == "S"
      RecLock("TMP",.t.)
      Repl IDENTIF with shz->hz_identif
      Repl BOBINA  with shz->hz_bobina
      Repl PESOL   with shz->hz_pesol
      Repl PESOB   with shz->hz_pesob
      Repl LIGA    with shz->hz_cod
      Repl ESPEC   with shz->hz_cliente
      Repl DOC     with shz->hz_doc
      Repl EMISSAO with shz->hz_emissao
   Endif
   dbSelectArea("SHZ")
   dbSkip()
End

dbSelectArea("TMP")
dbGotop()

If reccount()<1
   cMsg := "Nenhuma bobina foi encontrada nesta especificacao ! "

   nTentadeNovo := Aviso("Aten‡ao !",cMsg,{"Ok"})
   Fim()
Endif

// Para Utilizacao de um arquivo qualquer sem o SX3 em um browse padrao
aCampos := {}
AADD(aCampos,{"SIM"  ,"X"})
AADD(aCampos,{"IDENTIF","Identificacao","@!"})
AADD(aCampos,{"BOBINA","Bobina"})   // Nao precisa por Picture
AADD(aCampos,{"PESOL","Peso Liquido"})
AADD(aCampos,{"PESOB","Peso Bruto"})
AADD(aCampos,{"LIGA" ,"Liga"})
AADD(aCampos,{"ESPEC","Especificacao"})
AADD(aCampos,{"DOC"  ,"Documento"})
AADD(aCampos,{"EMISSAO","Emissao"})

@ 6,5 TO 115,305 BROWSE "TMP" FIELDS aCampos MARK "SIM"

@ 125,250 BUTTON "_Ok" SIZE 40,15 ACTION Fim()// Substituido pelo assistente de conversao do AP5 IDE em 22/03/01 ==> @ 125,250 BUTTON "_Ok" SIZE 40,15 ACTION Execute(Fim)
ACTIVATE DIALOG oDlg2 CENTERED

Return


// Substituido pelo assistente de conversao do AP5 IDE em 22/03/01 ==> __Return(NIL)
Return(NIL)        // incluido pelo assistente de conversao do AP5 IDE em 22/03/01

// Substituido pelo assistente de conversao do AP5 IDE em 22/03/01 ==> Function Fim
Static Function Fim()

dbSelectArea("SHZ")
dbSetOrder(1)

dbSelectArea("TMP")
dbGotop()

While !eof()
   If empty(tmp->sim)
      dbSelectArea("SHZ")
      dbSeek(xFilial() + tmp->doc + tmp->liga)
      If !eof()
         While !RecLock("SHZ",.f.)
            loop
         End
         Repl hz_nf with sf2->f2_doc
         msUnlock()
      Endif
   Endif
   dbSelectArea("TMP")
   dbSkip()
End

dbSelectArea("TMP")
dbCloseArea()
cArq := cArqTemp + ".dbf"
delete file (cArq)
Close(oDlg1)
Close(oDlg2)
// ---------------------------

SA1->(dbSeek(xFilial("SA1") + sf2->f2_cliente + sf2->f2_loja))
While !RecLock("SF2",.f.)
   loop
End    
Repl f2_nomecli with sa1->a1_nreduz
dbCommit()

Return 
 
