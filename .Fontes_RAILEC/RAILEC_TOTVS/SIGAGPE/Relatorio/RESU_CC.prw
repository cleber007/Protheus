#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AUDITA   บ Autor ณ JOSE MACEDO        บ Data ณ  06/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ AUDITORIA NA FOLHA                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Alubar S/A                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RESU_CC()    // RESUMO DA FOLHA POR CENTRO DE CUSTO TODAS AS VERBAS

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "COMPARA CENTRO DE CUSTO"
Local cPict          := ""
Local titulo       := "RESUMO DA FOLHA"
Local nLin         := 80


Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RESU_CC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FPG303R" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := ""
Private aSituac    := {"ATIVOS","FERIAS","DEMITIDOS","AFASTADOS","TODOS"}
Private cKey       := ""
Private nIndex     := 0
Private cIndex     := ""
Private cString    := "SRA"

//Pergunte(cPerg,.t.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
Cabec1       := ""
Cabec2       := ""



_PAR06:=STRZERO(year(DDATABASE),4,0)+STRZERO(MONTH(DDATABASE),2,0)
_CCUSTO:=SPACE(9)
_TOTEMP:="N"
_CATFUNC:="M       "
@ 1,1 to  150,300 DIALOG oDlg2A TITLE "Compara ?"
@ 20, 10 SAY "Ano Mes BASE ?"
@ 20, 59 GET _PAR06 PICTURE "999999"   VALID NAOVAZIO()
@ 30, 10 SAY "Categoria ?"
@ 30, 59 GET _CATFUNC PICTURE "!!!!!!" VALID NAOVAZIO()
@ 40, 10 SAY "CCusto ?"
@ 40, 59 GET _CCUSTO SIZE 40,12 F3 "CTT"

@ 60, 90 BmpButton Type 1 Action Close(oDlg2A)
Activate Dialog oDlg2A Centered

_CCUSTO:=ALLTRIM(_CCUSTO)


aStru := {}
aadd(aStru , {'TMP_CCUS'   ,'C', 09,0} )
aadd(aStru , {'TMP_NOME' ,'C', 40,0} )
aadd(aStru , {'TMP_CVER'   ,'C', 03,0} )
aadd(aStru , {'TMP_DVER'   ,'C', 25,0} )
aadd(aStru , {'TMP_PROV'   ,'N', 14,2} )
aadd(aStru , {'TMP_DESC'   ,'N', 14,2} )
aadd(aStru , {'TMP_BASE'   ,'N', 14,2} )
aadd(aStru , {'TMP_REFE'   ,'N', 14,2} )
aadd(aStru , {'TMP_OCOR'   ,'N', 10,0} )
aadd(aStru , {'TMP_LCTPAD'   ,'C', 03,0} )
aadd(aStru , {'TMP_CTADEB'   ,'C',100,0} )
aadd(aStru , {'TMP_CTACRE'   ,'C',100,0} )

cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TMP',.f.)
INDEX ON TMP_CCUS+TMP_CVER TO &cArqTemp

RptStatus({|| RunDetRep(Cabec1,Cabec2,Titulo,nLin) },Titulo)

DbSelectArea("SRA")
DbSetOrder(1)
DBGOTOP()

Return


//**********************************
Static Function RunDetRep(Cabec1,Cabec2,Titulo,nLin)
//**********************************
DbSelectArea("CTT")
DbSetOrder(1)

DbSelectArea("SRC")
DbSetorder(1)
DbSelectArea("SRD")
DbSetorder(1)

dbSelectArea("SRA")
dbSetOrder(2)     // CENTRO DE CUSTO
SetRegua(RecCount())
_FIL:=xFilial("SRA")
DBSEEK(_Fil)

_T1:=_T2:=0
_NFUNC:=0
_A:=ARRAY(999)
FOR I:=1 TO 999
    _A[I]:=0
NEXT I

_B:=ARRAY(399)
FOR I:=1 TO 399     // REFERENCIAS PROVENTOS
    _B[I]:=0
NEXT I
    
WHILE !EOF() .AND. xFilial("SRA")==_Fil
	INCREGUA()
   _CCANTER:=RA_CC
	//*************************************************************** BUSCA VALORES ACUMULADOS NOS MESES EM QUESTAO
    IF !EMPTY(_CCUSTO) .AND. RA_CC#_CCUSTO    // FILTRO DE CENTRO DE CUSTOS
       DBSKIP()
       Loop
    ENDIF   
	IF !(SRA->RA_CATFUNC$_CATFUNC)
	   DBSKIP()
	   Loop
	ENDIF   

   _nFunc++			   
   
	IF _PAR06 < substr(dtos(ddatabase),1,6) //Getmv("MV_FOLMES")
		DBSELECTAREA("SRD")
		DBSEEK(xFilial("SRD")+SRA->RA_MAT+_PAR06)
		WHILE !EOF() .AND. RD_MAT=SRA->RA_MAT .AND. RD_DATARQ=_PAR06
         _CC     :=SRD->RD_CC
			_TIPOCOD:=POSICIONE("SRV",1,XFILIAL("SRV")+SRD->RD_PD,"RV_TIPOCOD")
			DBSELECTAREA("TMP")
			DBSEEK(_CC+SRD->RD_PD)
			IF !FOUND()
				RECLOCK("TMP",.T.)
				TMP_CCUS:=_CC
				TMP_NOME:=IIF(_TOTEMP="N",Posicione("CTT", 1 ,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01"),SM0->M0_NOMECOM)
				TMP_CVER:=SRD->RD_PD
				TMP_DVER:=POSICIONE("SRV",1,XFILIAL("SRV")+SRD->RD_PD,"RV_DESC")
			ELSE
				RECLOCK("TMP",.F.)
			ENDIF
         IF _TIPOCOD="1"
			TMP_PROV:=TMP_PROV+SRD->RD_VALOR
            _T1+=SRD->RD_VALOR
		   ELSEIF _TIPOCOD="2"
			TMP_DESC:=TMP_DESC+SRD->RD_VALOR
            _T2+=SRD->RD_VALOR
		   ELSE
			TMP_BASE:=TMP_BASE+SRD->RD_VALOR
		 ENDIF   
		   TMP_REFE:=TMP_REFE+SRD->RD_HORAS
		   TMP_OCOR:=TMP_OCOR+1
		   MSUNLOCK()

         IF VAL(SRD->RD_PD)>0
            _A[VAL(SRD->RD_PD)]+=SRD->RD_VALOR
            IF _TIPOCOD="1" //VAL(SRD->RD_PD)<400
               _B[VAL(SRD->RD_PD)]+=SRD->RD_HORAS
            ENDIF
         ENDIF   
         
			DBSELECTAREA("SRD")
			DBSKIP()
		ENDDO
		
	ELSE
		DBSELECTAREA("SRC")
		DBSEEK(xFilial("SRC")+SRA->RA_MAT)
		WHILE !EOF() .AND. RC_MAT=SRA->RA_MAT
			_TIPOCOD:=POSICIONE("SRV",1,XFILIAL("SRV")+SRC->RC_PD,"RV_TIPOCOD")
            _CC:=SRA->RA_CC
			DBSELECTAREA("TMP")
			DBSEEK(_CC+SRC->RC_PD)
			IF !FOUND()
				RECLOCK("TMP",.T.)
				TMP_CCUS:=_CC
				TMP_NOME:=IIF(_TOTEMP="N",Posicione("CTT", 1 ,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01"),SM0->M0_NOMECOM)
				TMP_CVER:=SRC->RC_PD
				TMP_DVER:=POSICIONE("SRV",1,XFILIAL("SRV")+SRC->RC_PD,"RV_DESC")
			ELSE
				RECLOCK("TMP",.F.)
			ENDIF

         IF _TIPOCOD="1"
			   TMP_PROV:=TMP_PROV+SRC->RC_VALOR
            _T1+=SRC->RC_VALOR
		   ELSEIF _TIPOCOD="2"
			   TMP_DESC:=TMP_DESC+SRC->RC_VALOR
            _T2+=SRC->RC_VALOR
		   ELSE
			   TMP_BASE:=TMP_BASE+SRC->RC_VALOR
		 ENDIF   
		   TMP_REFE:=TMP_REFE+SRC->RC_HORAS
		   TMP_OCOR:=TMP_OCOR+1
		   MSUNLOCK()
         IF VAL(SRC->RC_PD)>0
            _A[VAL(SRC->RC_PD)]+=SRC->RC_VALOR
            IF _TIPOCOD="1" //VAL(SRC->RC_PD)<400
               _B[VAL(SRC->RC_PD)]+=SRC->RC_HORAS
            ENDIF
         ENDIF   
			DBSELECTAREA("SRC")
			DBSKIP()
		ENDDO
	ENDIF
	
	DBSELECTAREA("SRA")
	DBSKIP()
	IF EOF() .OR. (RA_CC#_CCANTER .AND. _T1+_T2>0)    // TOTALIZA CENTRO DE CUSTO
		RECLOCK("TMP",.T.)
		TMP_CCUS:=_CC
		TMP_NOME:=Posicione("CTT", 1 ,xFilial("CTT")+_CC,"CTT_DESC01")
		TMP_CVER:="TOT"
		TMP_DVER:="PROVENTOS/DESCONTOS/LIQUIDO"
      TMP_PROV:=_T1
      TMP_DESC:=_T2
      TMP_BASE:=_T1-_T2
		MSUNLOCK()

		RECLOCK("TMP",.T.)
		TMP_CCUS:=_CC
		TMP_NOME:=Posicione("CTT", 1 ,xFilial("CTT")+_CC,"CTT_DESC01")
		TMP_CVER:="TOT"
		TMP_DVER:="NUM. FUNCIONARIOS PROCESSAD"
      TMP_BASE:=_nFunc
		MSUNLOCK()

	   DBSELECTAREA("SRA")
      _T1:=_T2:=0        
      _NFUNC:=0
	ENDIF
ENDDO

nLin := 99
//*****************************************************************************************
FOR I:=1 TO 999
	IF _A[I] > 0
      _DVER:=POSICIONE("SRV",1,XFILIAL("SRV")+STRZERO(I,3,0),"RV_DESC")
		_TIPOCOD:=SRV->RV_TIPOCOD
		DBSELECTAREA("TMP")
		RECLOCK("TMP",.T.)
		TMP_CCUS:="TOTGER"
		TMP_NOME:="TOTAL GERAL - "+SM0->M0_NOMECOM
		TMP_CVER:=STRZERO(I,3,0)
		TMP_DVER:=_DVER
      IF _TIPOCOD="1"
		   TMP_PROV:=_A[I]
		  ELSEIF _TIPOCOD="2" 
		   TMP_DESC:=_A[I]
        ELSE
		   TMP_BASE:=_A[I]
		ENDIF   
      IF I<400
         TMP_REFE:=_B[I]
      ENDIF
		MSUNLOCK()
	ENDIF
NEXT I
    
  
//**************************************************** IMPRESSAO
_TTG1:=_TTG2:=_TTG3:=0
DBSELECTAREA("TMP")
DBGOTOP()
WHILE !EOF()
	If nLin > 55
		nLin := Cabec(Titulo+"-"+LEFT(_PAR06,4)+"/"+SUBSTR(_PAR06,5,2),Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin += 1
	Endif
	
	_CC:=TMP_CCUS
	@ nLIN,001 PSAY TMP_CCUS+" - "+TMP_NOME
	_TT1:=_TT2:=_TT3:=0
	@ nLIN,053 PSAY "Cod"
	@ nLIN,057 PSAY "Descricao"
	@ nLIN,100 PSAY " Proventos"
	@ nLIN,111 PSAY " Descontos" 
	@ nLIN,122 PSAY "     Bases"
	@ nLIN,133 PSAY "Referencia  Ocorrenc"
	nLin++
	
	WHILE !EOF() .AND. TMP_CCUS=_CC
		@ nLIN,053 PSAY TMP_CVER
		@ nLIN,057 PSAY TMP_DVER
		@ nLIN,098 PSAY TMP_PROV PICTURE "@E 9,999,999.99"
		@ nLIN,111 PSAY TMP_DESC PICTURE "@E 999,999.99"
		@ nLIN,122 PSAY TMP_BASE PICTURE "@E 999,999.99"
		@ nLIN,133 PSAY TMP_REFE PICTURE "@E 999,999.99"
		@ nLIN,144 PSAY TMP_OCOR PICTURE "@E 99999999"

		_TT1+=TMP_PROV
		_TT2+=TMP_DESC
		_TT3+=TMP_BASE
		
		nLin++
		If nLin > 55
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin += 1
		Endif
		_cLp:=Posicione("SRV",1,xFilial("SRV")+TMP->TMP_CVER,"RV_LCTOP")

        IF !EMPTY(_cLp)
		   _DEB:=POSICIONE("CT5",1,XFILIAL("CT5")+_cLp,"CT5_DEBITO")
		   _CRE:=CT5->CT5_CREDIT
           RECLOCK("TMP",.F.)
           TMP_LCTPAD:=_cLp
           TMP_CTADEB:=_DEB
           TMP_CTACRE:=_CRE
           MSUNLOCK()		   
		ENDIF   

		DBSKIP()
	ENDDO
	_TTG1+=_TT1
	_TTG2+=_TT2
	_TTG3+=_TT3
	_TT1:=_TT2:=0
	_TT3:=0
 	nLin:=99     // SALTA PAGINA POR CENTRO DE CUSTO
ENDDO
IF _TT1+_TT2>0
	_TTG1+=_TT1
	_TTG2+=_TT2
	_TTG3+=_TT3
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

DbSelectArea("SRD")
DBSETORDER(1)
DBGOTOP()
DbSelectArea("SRA")
DBSETORDER(1)
DBGOTOP()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()


//***************************************************************************************************************
_GeraXls:=1
@ 1,1 to  150,300 DIALOG oDlg2 TITLE "Gera Planilha Excel ?"
@ 10, 49 SAY "1 - Nao"
@ 22, 49 SAY "2 - Sim"
@ 44, 49 GET _GeraXls PICTURE "99"
@ 60, 90 BmpButton Type 1 Action Close(oDlg2)
Activate Dialog oDlg2 Centered
If _GeraXls=2 .AND. File(cArqTemp+".DTC")
	DbSelectArea("TMP")
	DBGOTOP()
//	COPY TO RESUMO.CSV
	_cArqRen:="\SYSTEM\TEMPDBF\RESUMO.CSV"
	Copy to &_cArqRen VIA "DBFCDXADS" 
	//Copiando Arquivo criado .DBF para o diretorio especํfico no Cliente
	IF CPYS2T("\SYSTEM\TEMPDBF\RESUMO.CSV","C:\Relato\",.F.)
		MSGINFO("Arquivo gerado com sucesso! C:\Relato\RESUMO.CSV")
	ELSE
		ALERT("ERRO NA COPIA. RESUMO.CSV")
	ENDIF
EndIf

dbSelectArea('TMP')
dbCloseArea()
cArqTemp2 := cArqTemp + '.DTC'
Delete File &cArqTemp2
cArqTemp3 := cArqTemp + '.CDX'
Delete File &cArqTemp3

Return
