#include "RwMake.ch"
User Function CENTROC(ccusto)
	local vst_custo:= ccusto

	If left(cNumEmp,2) == "06"
	    // Chamado 19222
	    // Retirado check nas contas 31010

		If len(Trim(vst_custo))>0
//			IF Substr(TMP->CT2_DEBITO,1,5) == "31010" .or. ((Substr(TMP->CT2_DEBITO,1,5)>="31033") .and. (Substr(TMP->CT2_DEBITO,1,5)<="31071") )
			IF ((Substr(TMP->CT2_DEBITO,1,5)>="31033") .and. (Substr(TMP->CT2_DEBITO,1,5)<="31071"))
				msgInfo("Para esta C.Contábil [" +Trim(TMP->CT2_DEBITO)+"] o C.Custo deve ficar em branco",)
				vst_custo := Space(9)
			endif
//			IF Substr(TMP->CT2_CREDIT,1,5) == "31010" .or. ((Substr(TMP->CT2_CREDIT,1,5)>="31033") .and. (Substr(TMP->CT2_CREDIT,1,5)<="31071") )
			IF ((Substr(TMP->CT2_CREDIT,1,5)>="31033") .and. (Substr(TMP->CT2_CREDIT,1,5)<="31071") )
				msgInfo("Para esta C.Contábil [" +Trim(TMP->CT2_CREDIT)+"] o C.Custo deve ficar em branco",)
				vst_custo := Space(9)
			endif
		endif

	else

		If left(cNumEmp,2) == "03"

			If len(Trim(vst_custo))>0

				IF !(Substr(TMP->CT2_DEBITO,1,5) $ "31010/31021/31031/31032/110306001") .and. (TRIM(TMP->CT2_CCD)<>"")
					msgInfo("Para esta C.Contábil [" +Trim(TMP->CT2_DEBITO)+"] o C.Custo deve ficar em branco",)
					vst_custo := Space(9)
				endif


				IF !(Substr(TMP->CT2_CREDIT,1,5) $ "31010/31021/31031/31032/110306001") .and. (TRIM(TMP->CT2_CCC)<>"")
					msgInfo("Para esta C.Contábil [" +Trim(TMP->CT2_CREDIT)+"] o C.Custo deve ficar em branco",)
					vst_custo := Space(9)
				endif
			endif

		endif

	Endif

	Return(vst_custo)

	//***************************************************************************************************
	**************
user Function GPM670VAL()    // PONTO DE ENTRADA NA INTEGRAÇÃO FOLHA X FINANCEIRO  .... ANTES DE INICIAR GRAVAÇÃO DO SE2
	**************               // MACEDO EM 18/02/2016
	_AREA:=ALIAS()
	_lRet:=.T.

	IF !(UPPER(SUBSTR(RC1->RC1_SIGN,1,6)) $ "ADMINI/ANA CA/AMANDA/ANA.CA")
		ALERT("Titulo nao liberado pelo Aprovador!")
		_lRet:=.F.
	ENDIF

	DBSELECTAREA(_Area)
	RETURN _lRET
	//***************************************************************************************************

	**************
user Function GP670CPO()    // PONTO DE ENTRADA NA INTEGRAÇÃO FOLHA X FINANCEIRO (RC1 X SE2)
	**************              // MACEDO EM 30/09/2015
	_AREA:=ALIAS()

	_CTA:=_HIS:=""

	_lPL:=.F.

	ALERT(RC1->RC1_CODTIT)

	IF RC1->RC1_CODTIT $ "PL1/PL2/PL3"
		_CTA:="3103211005"
		_HIS:="PRO-LABORE REF FOLHA: "+DTOC(DDATABASE)

		_lPL:=.T.
		IF RC1->RC1_CODTIT == "PL1"
			_MAT:=alltrim(GetMV("AL_MATPL1")) // "000288" // Parametro a matricula para prolabore PL1  // AL_MATPL1
		ELSEIF RC1->RC1_CODTIT == "PL2"
			_MAT:=alltrim(GetMV("AL_MATPL2")) // "000289" // Parametro a matricula para prolabore PL2  // AL_MATPL2
		ELSEIF RC1->RC1_CODTIT == "PL3"
			_MAT:=alltrim(GetMV("AL_MATPL3")) // "000878" // Parametro a matricula para prolabore PL3  // AL_MATPL3
		ENDIF   
		_PLBRUT:=POSICIONE("SRC",1,xFilial("SRC")+_MAT+"104","RC_VALOR")    //7554.89
		_PLINSS:=POSICIONE("SRC",1,xFilial("SRC")+_MAT+"401","RC_VALOR")//608.44
		_PLIRRF:=POSICIONE("SRC",1,xFilial("SRC")+_MAT+"405","RC_VALOR")//1040.91
		_PLLIQU:=POSICIONE("SRC",1,xFilial("SRC")+_MAT+"799","RC_VALOR")//5905.54
	ENDIF

	IF LEFT(RC1->RC1_CODTIT,2) == "LI"
		_CTA:="210401001"
		_HIS:="FOPAG REF "+DTOC(DDATABASE)
	ENDIF
	IF LEFT(RC1->RC1_CODTIT,3) == "131"
		_CTA:="110502004"
		_HIS:="LIQ ADT 13 SAL "+DTOC(DDATABASE)
	ENDIF
	IF LEFT(RC1->RC1_CODTIT,3) == "132"
		_CTA:="210401003"
		_HIS:="LIQUIDO 13. SAL "+DTOC(DDATABASE)
	ENDIF

//****************************************
	IF LEFT(RC1->RC1_CODTIT,3) == "098"
		_CTA:="210401001"
		_HIS:="PR REF "+DTOC(DDATABASE)
	ENDIF

	IF RC1->RC1_CODTIT $ "002/003/004"
		_CTA:="210402003"
		_HIS:="PENSAO ALIMENTICIA "+IIF(!EMPTY(RC1->RC1_MAT),POSICIONE("SRA",1,XFILIAL("SRA")+RC1->RC1_MAT ,"RA_NOME"),"DESCONTADA EM FOLHA")
	ENDIF

	IF RC1->RC1_CODTIT $ "052/053"
		_CTA:="210402003"
		_HIS:="PENSAO ALIMENTICIA 13. SALARIO "+IIF(!EMPTY(RC1->RC1_MAT),POSICIONE("SRA",1,XFILIAL("SRA")+RC1->RC1_MAT ,"RA_NOME"),"DESCONTADA EM FOLHA")
	ENDIF


	IF RC1->RC1_CODTIT == "020"
		_CTA:="3102141011"
		_HIS:="CABANA CLUBE REF FOLHA: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "012"
		_CTA:="210301003"
		_HIS:="IRRF REF FOLHA: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "PL4"
		_CTA:="210301003"
		_HIS:="IRRF REF PROLABORE "+IIF(!EMPTY(RC1->RC1_MAT),POSICIONE("SRA",1,XFILIAL("SRA")+RC1->RC1_MAT ,"RA_NOME"),"DESCONTADA EM FOLHA")
	ENDIF

	IF RC1->RC1_CODTIT == "051"
		_CTA:="210301003"
		_HIS:="IRRF REF FOLHA 13O SALARIO: "+DTOC(DDATABASE)
	ENDIF

	IF RC1->RC1_CODTIT == "099"
		_CTA:="210301003"
		_HIS:="IRRF REF PR: "+DTOC(DDATABASE)
	ENDIF


	IF RC1->RC1_CODTIT == "021"
		_CTA:="210302004"
		_HIS:="CONTRIB SINDICAL REF FOLHA: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "022"
		_CTA:="210302004"
		_HIS:="CONTRIB ASSISTENCIAL REF FOLHA: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "023"
		_CTA:="210302004"
		_HIS:="MENSALIDADE SINDICAL REF FOLHA: "+DTOC(DDATABASE)
	ENDIF

	IF RC1->RC1_CODTIT == "FER"
		_CTA:="210401002"
		_HIS:="PAG. LIQ DE FERIAS "+IIF(!EMPTY(RC1->RC1_MAT),POSICIONE("SRA",1,XFILIAL("SRA")+RC1->RC1_MAT ,"RA_NOME")," NESTA DATA")
	ENDIF
	IF RC1->RC1_CODTIT == "RES"
		_CTA:="210401004"
		_HIS:="PAG. LIQ DE RESCISAO "+IIF(!EMPTY(RC1->RC1_MAT),POSICIONE("SRA",1,XFILIAL("SRA")+RC1->RC1_MAT ,"RA_NOME")," NESTA DATA")
	ENDIF

	IF RC1->RC1_CODTIT == "013"
		_CTA:="210402001"
		_HIS:="INSS A REC. FOLHA: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "PL5"
		_CTA:="210302003"
		_HIS:="INSS REF PROLABORE "+IIF(!EMPTY(RC1->RC1_MAT),POSICIONE("SRA",1,XFILIAL("SRA")+RC1->RC1_MAT ,"RA_NOME"),"DESCONTADA EM FOLHA")
	ENDIF

	IF RC1->RC1_CODTIT == "050"
		_CTA:="210402001"
		_HIS:="INSS A REC. FOLHA 13 SAL: "+DTOC(DDATABASE)
	ENDIF


	IF RC1->RC1_CODTIT == "014"
		_CTA:="210402002"
		_HIS:="FGTS FOLHA: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "015"
		_CTA:="210402002"
		_HIS:="FGTS 13o FOLHA: "+DTOC(DDATABASE)
	ENDIF

	IF RC1->RC1_CODTIT == "016"
		_CTA:="3102133003"
		_HIS:="SEGURO DE VIDA FOLHA: "+DTOC(DDATABASE)
	ENDIF

	IF RC1->RC1_CODTIT == "017"
		_CTA:="3102133005"
		_HIS:="REEMB ESCOLAR FOLHA: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "018"
		_CTA:="3102133004"
		_HIS:="REEMB MEDICAMENTO FOLHA: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "019"
		_CTA:="3102133009"
		_HIS:="REEMB AJ ACADEMICA FOLHA: "+DTOC(DDATABASE)
	ENDIF

	IF RC1->RC1_CODTIT == "024"
		_CTA:="210302004"
		_HIS:="APORTE FINANCEIRO: "+DTOC(DDATABASE)
	ENDIF


//************************************************************** INICIO: NOVAS INCLUSOES NA FOLHA DE SET/2018 - Macedo 
/*
834 – REEM MATERIAL                        – 3102133005 (CC INDUSTRIAL) / 310.311.3005 (CC VENDAS) / 310.321.3005 (CC ADMINISTRATIVO)
835 – REEM ARMAÇÕES E LENTES               - 3102133004 (CC INDUSTRIAL) / 310.311.3004 (CC VENDAS) / 310.321.3004 (CC ADMINISTRATIVO)
836 – REEM DE APARELHOS ORTOPEDICOS        – 3102133004 (CC INDUSTRIAL) / 310.311.3004 (CC VENDAS) / 310.321.3004 (CC ADMINISTRATIVO)
837 – REEM PROT E IMPLANTES DENTARIOS      – 3102133004 (CC INDUSTRIAL) / 310.311.3004 (CC VENDAS) / 310.321.3004 (CC ADMINISTRATIVO)
838 – REEM DE CURSOS TECNICOS              – 3102133005 (CC INDUSTRIAL) / 310.311.3005 (CC VENDAS) / 310.321.3005 (CC ADMINISTRATIVO)
*/
	IF RC1->RC1_CODTIT == "031"
		_CTA:="3102133005"
		_HIS:="REEMB MATERIAL: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "032"
		_CTA:="3102133004"
		_HIS:="REEMB ARM E LENTES: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "033"
		_CTA:="3102133004"
		_HIS:="REEMB AP ORTOPEDICOS: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "034"
		_CTA:="3102133004"
		_HIS:="REEMB PROTESE IMPL DENT: "+DTOC(DDATABASE)
	ENDIF
	IF RC1->RC1_CODTIT == "035"
		_CTA:="3102133005"
		_HIS:="REEMB CURSOS TECNICOS: "+DTOC(DDATABASE)
	ENDIF

	IF RC1->RC1_CODTIT == "036"
		_CTA:="3102133003"
		_HIS:="ALIANCA SEGUROS: "+DTOC(DDATABASE)
	ENDIF

//************************************************************** END: NOVAS INCLUSOES NA FOLHA DE SET/2018 - Macedo 

	IF RC1->RC1_CODTIT == "ALG"
		IF !EMPTY(RC1->RC1_CC) 
			_cTipoCC := GetAdvFVal("CTT","CTT_CATEG",xFilial("CTT")+RC1->RC1_CC,1)
			if 	_cTipoCC == '1' //Produção
				_CTA:="3102133007"
			Elseif _cTipoCC == '2' //Comercial
				_CTA:="3103113007"
			Elseif _cTipoCC == '3' //Administrativo
				_CTA:="3103213007"
			Endif 
		ENDIF
		_HIS:=alltrim(RC1->RC1_DESCRI)+"-"+DTOC(DDATABASE)
	ENDIF

	IF EMPTY(_HIS)  // Caso o histórico não tenha sido tratado ele carrega da origem
		_HIS:=RC1->RC1_DESCRI
	Endif


	//********************************************** ATUALIZA SE2
	IF !EMPTY(_HIS) //!EMPTY(_CTA)

		DBSELECTAREA("SE2")
		DBSETORDER(1)
		_cParcela := Space(TAMSX3("E2_PARCELA")[1])
		DBSEEK(xFilial("SE2")+RC1->RC1_PREFIX+RC1->RC1_NUMTIT+_cParcela+RC1->RC1_TIPO+RC1->RC1_FORNEC+RC1->RC1_LOJA)
		IF FOUND()

			if RECLOCK("SE2",.F.)
				Replace E2_CTADEBD 	With _CTA
				Replace E2_HIST    	With _HIS

				if RC1->(FieldPos('RC1_CODBAR')) > 0 
					Replace E2_CODBAR  With RC1->RC1_CODBAR 
				Endif

				if RC1->(FieldPos('RC1_LINDIG')) > 0 
					Replace E2_LINDIG  With RC1->RC1_LINDIG 
				Endif

				IF _lPL   // SE FOR PROLABORE COMPLETA DEMAIS CAMPOS
					Replace E2_BASEIRF	With _PLBRUT
					Replace E2_BASEINS	With _PLBRUT
					//SE2->E2_PARCINS:="01"
					Replace E2_ORIGEM With "FINA050"

					Replace E2_INSS  With _PLINSS
					Replace E2_IRRF  With _PLIRRF
					Replace E2_VALOR With _PLLIQU
					Replace E2_VLCRUZ With _PLLIQU
					Replace E2_SALDO With _PLLIQU
					_lPL:=.F.
				ENDIF

				MSUNLOCK()
			Endif
		else
			ALERT('NÃO Achei o titulo')

		ENDIF
	ENDIF
	DBSELECTAREA(_Area)
	RETURN

	//***************************************************************************************************

	**************
user Function PESQ_CEP() 
	**************            
	_AREA:=ALIAS()
	_CEP :=M->RA_CEP

	_Arquivo:="http://pesquisacep.com.br/index.php/api/cep/codigo/"+_Cep+"/format/xml"  //_Arquivo:="http://pesquisacep.com.br/index.php/api/cep/codigo/66833480/format/xml"

	_ARQUIVO:="http://maps.google.com.br/maps?f=q&hl=pt-BR&geocode=&q="+_Cep            //+"&sll=-1.451113,-48.49406&sspn=0.009653,0.014462&ie=UTF8&ll=-1.341175,-48.462431&spn=0.009653,0.014462&z=16&iwloc=addr&om=1"
	ShellExecute("Open", _arquivo, " ", ' ', 1)



RETURN SPACE(50)

