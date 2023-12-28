#INCLUDE "rwmake.ch"

/*/
-------------------------------------------------------------------------------------
| Programa   : BBFPAG.PRW      | Data : 11/06/2018         | Autor : jose macedo  |
-------------------------------------------------------------------------------------
| Descricao  : Exportação Líquidos da Folha - BB ( TXT )                          |
-------------------------------------------------------------------------------------
| Utilizacao : FOLHA DE PAGAMENTO                                                   |
-------------------------------------------------------------------------------------
/*/

User Function BBFPAG()



Private cPerg   := "BBFPAG"
Private oGeraTxt

Private cString := "SRC"


lPerg := Pergunte(cPerg,.T.)

If !lPerg
    Return
EndIf    

dbSelectArea("SRR")    // FERIAS
dbSetOrder(1)

dbSelectArea("SRC")    // MENSAIS
dbSetOrder(1)

// Montagem da tela de processamento.                                  

@ 200,1 TO 380,410 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo BB")
@ 02,10 TO 088,185
@ 10,018 Say " Este programa ira gerar um arquivo BB, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario, com os registros do arquivo de "
@ 26,018 Say " pagamento Mensal.                                            "

@ 60,090 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION _Parametros()

Activate Dialog oGeraTxt Centered

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _Parametros()

Pergunte(cPerg,.T.)          

Return(Nil)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function OkGeraTxt

_cAreaAtu := alias()
_nIndiAtu := indexord()
_nRegiAtu := recno()

Pergunte(cPerg,.f.)

// ACEITA PARAMETROS
_dBase     := mv_par01
_dPgmto    := mv_par02
_cArquivo  := alltrim (upper(mv_par03))
_cAgDeb    := padL(alltrim(mv_par04),5,'0')
_cContrato := padL(alltrim(mv_par05),6,'0')
_nTipo     := mv_par06
_nGera     := mv_par07   // 1 - ADTO 2 - FOLHA 3 - FERIAS 4 - 13 SALARIO
_cMatDe    := mv_par08
_cMatAte   := mv_par09
_cSalario  := mv_par10
_cAdianta  := mv_par11

Processa({|| RunCont(_dBase,_dPgmto,_cArquivo,_cAgDeb,_cContrato,_nTipo,_nGera,_cMatDe,_cMatAte,_cSalario,_cAdianta) },"Processando...")

dbselectarea(_cAreaAtu)
dbsetorder(_nIndiAtu)
dbgoto(_nRegiatu)

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunCont(_dBase,_dPgmto,_cArquivo,_cAgDeb,_cContrato,_nTipo,_nGera,_cMatDe,_cMatAte,_cSalario,_cAdianta)

aStru := {}
aadd(aStru , {'_REGISTRO'   ,'C',240,0} )
cArqTemp := CriaTrab(aStru , .t.)
dbUseArea(.T.,,cArqTemp,'TMP',.f.)

_cLote := 0
_nQtdReg := 0

_CcEmp := "000000005143"     // CHUMBADA A CONTA E DV DA EMPRESA739.689-9
_DgEmp := "8"

//_cContrato:="0000000939711     TS"
_cContrato  :="0009397110126       " // TS=TESTE E DEVE SER RETIRADO POSTERIORMENTE

_cAgDeb   :="033995"         //"030740"   // 5 AGENCIA + 1 DV
// Registro 0

_nQtdReg ++									//								Posição          // HEADER DO ARQUIVO
                                            //								De-Até
_cReg_0 := ''         					    //						        
_cReg_0 += '001'       		 				//01 -Banco                     01-03
_cReg_0 += strzero(_cLote,4) 				//02 -Lote de Servico           04-07
_cReg_0 += '0'         		 				//03 -Reg. Header de Arq        08-08
_cReg_0 += space(9)    		 				//04 -Filler                    09-17
_cReg_0 += '2'         		 				//05 -Tipo de Instricao         18-18
_cReg_0 += "07617805000128"                 //06 -Inscricao da Empresa      19-32   ..  CNPJ DA EMPRESA CONVENIADA
_cReg_0 += _cContrato  		 				//07 -Numero do Contrato        33-52
_cReg_0 += _cAgDeb 							//09 -Agencia da Conta Empresa  53-57 + 58 DV
_cReg_0 += _CcEmp			 				//11 -Numero da Conta Empresa   59-70
_cReg_0 += _DgEmp			 				//12 -Digito Verificador        71-71
_cReg_0 += space(1)          				//13 -Filler                    72-72
_cReg_0 += Left(sm0->m0_nomecom,30)		    //14 -Nome da Empresa           73-102
_cReg_0 += 'BANCO DO BRASIL S.A.'+SPACE(10)	//15 -Nome do Banco             103-132
_cReg_0 += space(10)         				//16 -Filler                    133-142
_cReg_0 += '1'               				//17 -Cod arquivo de remessa    143-143
_cReg_0 += substr(dtos(_dBase),7,2)+;                                       
		   substr(dtos(_dBase),5,2)+;
		   substr(dtos(_dBase),1,4) 		//18 -Data da Geracao           144-151
_cReg_0 += substr(time(),1,2)+;
		   substr(time(),4,2)+;
		   substr(time(),7,2) 				//19 - Hora da Geracao          152-157
_cReg_0 += replicate('0',6)  				//20 - sequencia de arquivo     158-163
_cReg_0 += '020'             				//21 - Layout do arquivo        164-166
_cReg_0 += '01600'           				//22 - Densidade                167-171
_cReg_0 += space(20)         				//26 - Filler                   172-191
_cReg_0 += space(49)         				//27 - Filler                   192-240

dbselectarea('TMP')

if reclock('TMP',.t.)
	TMP->_REGISTRO := _cReg_0
	msunlock()
endif

// Registro 1
           
_cLote ++
_nQtdReg ++
                                                          //				Posição
_cReg_1 := ''                                             //				De-até
_cReg_1 += '001'       		 				//01 -Banco                     01-03
_cReg_1 += strzero(_cLote,4) 				//02 -Lote de Servico           04-07
_cReg_1 += '1'         		 				//03 -Reg. Header de Lote       08-08         // HEADER LOTE ABC
_cReg_1 += 'C'       		 				//04 -Tipo da operacao          09-09
_cReg_1 += '30'        		 				//05 -Tipo do Servico           10-11
_cReg_1 += '01'				 				//06 -Forma de lancamento       12-13
_cReg_1 += '020'    		 				//07 -layout do lote            14-16
_cReg_1 += space(01)   		 				//08 -Filler                    17-17
_cReg_1 += '2'         		 				//09 -Tipo de Instricao         18-18

_cReg_1 += "07617805000128"                 //06 -Inscricao da Empresa      19-32   ..  CNPJ DA EMPRESA CONVENIADA
_cReg_1 += _cContrato  		 				//07 -Numero do Contrato        33-52
_cReg_1 += _cAgDeb 							//09 -Agencia da Conta Empresa  53-57 + 58 DV
_cReg_1 += _CcEmp			 				//11 -Numero da Conta Empresa   59-70
_cReg_1 += _DgEmp			 				//12 -Digito Verificador        71-71
_cReg_1 += space(1)          				//13 -Filler                    72-72
_cReg_1 += Left(sm0->m0_nomecom,30)		    //14 -Nome da Empresa           73-102


_cReg_1 += space(40)         				//19 -Filler                    103-142
_cReg_1 += space(30)         				//20 -Logradouro                143-172
_cReg_1 += space(05)         				//21 -Numero                    173-177
_cReg_1 += space(15)        				//22 -Complemento               178-192
_cReg_1 += space(20)         				//23 -Cidade                    193-212
_cReg_1 += space(05)         				//24 -Cep                       213-217
_cReg_1 += space(03)         				//25 -Comp. Cep                 218-220
_cReg_1 += space(02)         				//26 -Estado                    221-222
_cReg_1 += space(01)         				//27 -Comprv. de pagamento      223-223
_cReg_1 += space(17)         				//28 -Filler                    224-240

dbselectarea('TMP')

If reclock('TMP',.t.)
	TMP->_REGISTRO := _cReg_1
	msunlock()
EndIf

_cVerba   := ''
_cBase    := 'SRC'
_nIndi    := 3
_cChavePd := 'SRC->RC_PD'
_cChaveMt := 'SRC->RC_MAT'    

If  _nGera = 1 .or. _nGera = 2 .or. _nGera = 3 .or. _nGera = 4
	
	_cBase := 'SRC'
	_nIndi := 3
	
	If _nGera = 2 .OR. _nGera = 3 .or. _nGera = 4
		_cVerba := _cSalario
	Else
		_cVerba := _cAdianta
	Endif
	
EndIf

_PGFERDE:=MV_PAR01-5
_PGFERAT:=MV_PAR01

If  _nGera = 3   // PEDE PERIODO DE FERIAS
	@ 1,1 to  150,300 DIALOG oJan3 TITLE "PERIODO DE RECEBIMENTO DE FERIAS"
	@ 20,  20 SAY "Rec Ferias de "
	@ 20,  80 GET _PGFERDE SIZE 45,10 VALID !VAZIO()
	@ 40,  20 SAY "Rec Ferias ate"
	@ 40,  80 GET _PGFERAT SIZE 45,10 VALID !VAZIO()
	
	@ 60, 90 BMPBUTTON TYPE 1 ACTION Close(oJan3)        // CONFIRMA
	ACTIVATE DIALOG oJan3 CENTERED
ENDIF

_FILDE:=_FILAT:=xFilial(_cBase)
@ 1,1 to  150,300 DIALOG oJan3 TITLE "Filiais"
@ 20,  20 SAY "Filial de "
@ 20,  80 GET _FILDE VALID !VAZIO()
@ 40,  20 SAY "Filial ate"
@ 40,  80 GET _FILAT VALID !VAZIO()
@ 60, 90 BMPBUTTON TYPE 1 ACTION Close(oJan3)        // CONFIRMA
ACTIVATE DIALOG oJan3 CENTERED

dbSelectArea("SRI")
dbSetOrder(1)

dbselectarea('SA6')
dbsetorder(1)
dbgotop()

dbselectarea('SRA')
dbsetorder(1)
dbgotop()

_nCtd := 0
_nValTot := 0
_lTemReg := .f.

dbSelectArea(_cBase)   // SRC
dbsetorder(_nIndi)
dbGoTop()

ProcRegua(RecCount()) // Numero de registros a processar

dbseek(_FILDE+_cVerba,.f.)
While !EOF() .and. SRC->RC_FILIAL<=_FILAT

	IncProc()
    IF !(&(_cChavePd) == _cVerba)
        DBSKIP()
        Loop
    ENDIF
	
	// Registro 3
	_cMat := &(_cChaveMt)
	
	If _cMat >= _cMatde .and. _cMat <= _cMatAte
		dbselectarea('SRA')
		dbseek(SRC->RC_FILIAL+_cmat)
		IF FOUND() .AND. LEFT(RA_BCDEPSA,3)=="001" .AND. !Empty(RA_CTDEPSA)  // CHUMBADO BANDO DO BRASIL
     			_cLote ++
				_nCtd  ++
				_nQtdReg ++
				_lTemreg := .t.
		        dbselectarea('SA6')    // BUSCA DV DA AGENCIA DO FUNCIONARIO 
				DBSEEK(xFilial("SA6")+SRA->RA_BCDEPSA)
				IF FOUND()
				   _DVAGE:=A6_DVAGE
				  ELSE
				   _DVAGE:=SPACE(1)
				ENDIF 
		        dbselectarea('SRA')
				 
				//SEGMENTO A                        // 							Posição
				_cReg_3 := ''                       //							De-Até
				_cReg_3 += '001'       		 		//01 -Banco                 01-03
				_cReg_3 += "0001" //strzero(_cLote,4) 		//02 -Lote de Servico       04-07
				_cReg_3 += '3'         		 		//03 -Reg. Detalhe de Lote  08-08      // SEGMENTO A
				_cReg_3 += strzero(_nCtd ,5) 		//04 -Contador de Registros 09-13
				_cReg_3 += 'A'        		 		//05 -Cod. Seg, reg. lote   14-14
				_cReg_3 += '0'				 		//06 -Tipo do movimento     15-15
				_cReg_3 += '00'     		 		//07 -Instrucao do movimento16-17
				_cReg_3 += "000"    		 		//08 -Filler                18-20 ... CREDITO BB
				_cReg_3 += SUBS(SRA->RA_BCDEPSA,1,3)//09 -Banco do Movimento    21-23
				_cReg_3 += "0"+SUBS(SRA->RA_BCDEPSA,4,4)//10 -Agencia               24-28
				_cReg_3 += SUBS(SRA->RA_BCDEPSA,8,1)   		 		//11 -Filler                29-29  DV DA AGENCIA DO FUNCIONARIO
				
				_cConta := "000"+substr(SRA->RA_CTDEPSA,1,10) //STRZERO(VAL(SRA->RA_CTDEPSA),13)    // 12 DA CONTA + 1 DV
				
				if _nTipo == 1 .and. empty(SRA->RA_CTDEPSA)
					_cReg_3 += replicate('0',12)   	//12 -Numero da Conta Funcionario
					_cReg_3 += '0'               	//13 -Numero da Conta Funcionario
				Else
					_cReg_3 += _cConta 				//12 -Numero da Conta Funcionario  30-42
				Endif
				
				_cReg_3 += space(01)      					//14 -Filler 43-43
				_cReg_3 += upper(substr(SRA->RA_NOME,1,30)) //15 -Filler 44-73
				
				if _nGera == 1
					_cDoc := 'AD'
				Elseif _nGera == 2
					_cDoc := 'FP'
				Elseif _nGera == 3
					_cDoc := 'FE'
				Elseif _nGera == 4
					_cDoc := 'D2'
				Endif
				
				_cDoc += dtos(_dBase)+sra->ra_mat
				
				_cReg_3 += _cDoc+SPACE(4)      		//17 -Documento de pgmto  74-93 (20)

				_cReg_3 += substr(dtos(_dPgmto),7,2)+substr(dtos(_dPgmto),5,2)+substr(dtos(_dPgmto),1,4) //19 -Data do Pagmto 94-101
				_cReg_3 += 'BRL'         	//20 - Tipo da Moeda 102-104
				_cReg_3 += "000000000000000"        //21 - ZEROS 105-119
				                                 
				_nValSRC:= SRC->RC_VALOR 
				IF _nGera == 3            // FERIAS BUSCA DA TABELA SRR PARA SOMAR AO LIQUIDO DA FOLHA
                   DBSELECTAREA("SRR")
                   DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT+"F") 
                   WHILE !EOF() .AND. RR_MAT=SRA->RA_MAT .AND. RR_TIPO3="F" 
                         IF (RR_DATA>=_PGFERDE .AND. RR_DATA<=_PGFERAT) .AND. RR_PD="404"     // VERBA DE LIQUIDO DE FERIAS
                            _nValSRC+=RR_VALOR
                            ALERT("SOMADO VALOR DE FERIAS PARA MATRICULA : "+SRA->RA_MAT)
                         ENDIF   
                         DBSKIP()
                   ENDDO      
                   DBSELECTAREA("SRA")
				ENDIF

				IF _nGera == 4            // SRI - SEGUNDA PARCELA DO 13o SALARIO
                   _nValSRC:=0
		           dbSelectArea("SRI")
		           dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"709")
		           IF FOUND()
                      _nValSRC:=RI_VALOR
                   ENDIF
				ENDIF

				_cValor := STRZERO(INT(_nValSRC*100),15.0)
				_nValTot += val(_cValor)
				
				_cReg_3 += _cValor          //22 -Valor    120-134
				_cReg_3 += space(20)        //23 -BRANCOS 135-154 (20)
				_cReg_3 += "00000000"        //24 -ZEROS 155-162
				_cReg_3 += "000000000000000"        //25 -ZEROS 163-177
				_cReg_3 += STRZERO(0,40,0)			//ZEROS 178 - 217 (40)
				_cReg_3 += space(2)			//26 -BRANCO 218-219
				_cReg_3 += space(5) 		//220-224
				_cReg_3 += SPACE(2)      // 225-226
				_cReg_3 += SPACE(3)      // 227-229
				_cReg_3 += "0"    //230-230
				_cReg_3 += space(10)        //231 - 240 BRANCOS
				
				dbselectarea('TMP')
				
				If reclock('TMP',.t.)
					TMP->_REGISTRO := _cReg_3
					msunlock()
				Endif
	                                    
				_nCtd++                                             
				_cInsc := Alltrim(SRA->RA_CIC)                                  
				_cInsc := Replicate("0",14-Len(_cInsc))+_cInsc
				// SEGMENTO B                      					// 							PosiçãO
				_cReg_3 := ''                       				//							De-Até
				_cReg_3 += '001'       		 						//01 -Banco                 01-03
				_cReg_3 += "0001" //strzero(_cLote,4) 						//02 -Lote de Servico       04-07
				_cReg_3 += '3'         		 						//03 -Reg. Detalhe de Lote  08-08              // SEGMENTO B
				_cReg_3 += strzero(_nCtd ,5) 						//04 -Contador de Registros 09-13
				_cReg_3 += 'B'        		 						//05 -Cod. Segmento		    14-14
				_cReg_3 += Space(3)			 						//06 -Tipo do movimento     15-17
				_cReg_3 += '1'				 						//07 -Tipo do Inscriçao     18-18    1-CPF  2-CNPJ
				_cReg_3 += _cInsc									//08 -Numero Inscriçao      19-32
	
				dbselectarea('TMP')
				
				If reclock('TMP',.t.)
					TMP->_REGISTRO := _cReg_3
					msunlock()
				Endif
		Endif
	EndIf
	dbSelectArea(_cBase)  // SRC
	dbSkip()
EndDo

// Registro 5

_cLote ++
_nQtdReg ++

_cReg_5 := ''
_cReg_5 += '001'       		 	//01 -Banco
_cReg_5 += "0001" //strzero(_cLote,4) 	//02 -Lote de Servico
_cReg_5 += '5'         		 	//03 -Reg. Trailler  Lote  08-08    // TRAILLER LOTE ABC
_cReg_5 += space(09)   		 	//04 -Filler               09-17
_cReg_5 += strzero(_nCtd+2,6)	//05 -QTD REG NO LOTE      18-23
_cReg_5 += strzero(_nValTot,18) //07 -Filler               24-41
_cReg_5 += STRZERO(0,24)   		//08 -ZEROS                42-65
_cReg_5 += space(175)   		//09 -Filler               66-240 

dbselectarea('TMP')

if reclock('TMP',.t.)
	TMP->_REGISTRO := _cReg_5
	msunlock()
endif

// Registro 9

_cLote ++
_nQtdReg ++

_cReg_9 := ''
_cReg_9 += '001'       		 	//01 -Banco
_cReg_9 += '9999'            	//02 -Lote de Servico
_cReg_9 += '9'         		 	//03 -Reg. Trailler  Lote              // TRAILLER DO ARQUIVO
_cReg_9 += space(09)   		 	//04 -Filler
_cReg_9 += '000001'           	//05 -Total de lotes
_cReg_9 += strzero(_nCtd+4,6)  //06 -Filler
_cReg_9 += space(211)   		//07 -Filler

dbselectarea('TMP')

if reclock('TMP',.t.)
	TMP->_REGISTRO := _cReg_9
	msunlock()
endif

dbselectarea('TMP')

If _lTemreg
   ALERT("Arquivo remessa gerado com sucesso !!!!")
   copy to &(_cArquivo) SDF
Else
   ALERT("Arquivo Remessa não foi gerado !!!"+chr(10)+chr(10)+"Verifique parametros...")
   dbclosearea()
   If File(cArqTemp + '.DBF')
      FERASE(cArqTemp+'.DBF')
   EndIf
EndIf   

dbclosearea()
cArqTemp2 := cArqTemp + '.DBF'
Delete File &cArqTemp2

Return

