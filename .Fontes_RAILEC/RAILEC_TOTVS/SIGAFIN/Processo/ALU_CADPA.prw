#Include "FIVEWIN.CH"
#include "tbiconn.ch"
#include "TbiCode.ch"    
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#INCLUDE "PROTHEUS.CH"
#Include "Totvs.ch"
#Include "RwMake.ch"
#Define CRL Chr(13)+Chr(10)

***************************
User Function ALU_CADPA()      
***************************

#IFNDEF WINDOWS                                                                       	
	ScreenDraw("SMT050", 3, 0, 0, 0)
#ENDIF

//Local lAlcada := GetMV("AL_FINALCA")
Local _lSemFiltro:=.F. //20/08/17
Private _cAlias:="ZPA"
Private bFiltraBrw := {}//{ || FilBrowse( _cAlias , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro 
Private cCadastro := "Cadastro de Pagamentos Antecipados"
Private aCorZPA := {}   
Private lWap := .T.  
Private lMsg := .T.                 
Private _cIpProd:=GetMV("AL_IPSRVPR")//05/08/16 - Fabio Yoshioka
Private _cIpTest:=GetMV("AL_IPSRVTS")//05/08/16            
Private _cPrcSrvI:=GetMV("AL_PRWFINT")//08/08/16       
Private _cPrcSrvE:=GetMV("AL_PRWFEXT")//08/08/16  
Private _cRootpth:=GetSrvProfString ("ROOTPATH","")  
Private _cModelPA:=GetMV("AL_MODWFPA")//08/08/16     
Private _cCustPA:=GetMV("AL_CCUSTPA")//10/08/16     
Private _cNatuPA:=GetMV("AL_NATURPA")//10/08/16     
Private _lCtrlPA:=GetMV("AL_CTRLEPA")//18/08/16 - Habilita o controle de PA
Private _cGrpCom := Alltrim( GetMV("AL_GRPCOM") ) 
Private _cGrpFin := Alltrim( GetMV("AL_GRPFIN") ) 
Private _lPaFunc := GetMV("AL_PAFUNC") // HABILITA PA DE FUNCIONARIOS
Private aTitulo:={} 
Private cCodApro:=""
Private cCodSol:=""
Private cNomSol:=""
Private cNomApro:=""
Private cMaiApro:=""
Private cMaiSol:="" 
Private _cParcela:="1"
Private _cTipoPA:=""
Private _lSolCom:=.f.   
Private _lSolFin:=.f.
Private	_cUsuar:= RetCodUsr() 
Private _aDadSx1:={}//30/08/16
Private _aCfgSx1:={}//30/08/16  
Private _nLockSx1:=0 //29/08/16        
Private _cTitulo:=""
Private _cModulo:="" //18/08/17
Private _lVisAllReg:= iif(_cUsuar $ GetMV("AL_PAUSFIN"),.T.,.F.) //20/08/17
Private _lIsBoleto:=.F. //10/01/18 - Fabio Yoshioka

//parametros a desabilitar no SX1 - 30/08/16
aadd(_aCfgSx1,{"FIN050","01",2})//Mostra Lancto = Não
aadd(_aCfgSx1,{"FIN050","04",2})//Contabiliza on Line = NAO         
aadd(_aCfgSx1,{"FIN050","05",2})//Gerar Chq.p/Adiant. = NAO                  
aadd(_aCfgSx1,{"FIN050","09",2})//Mov.Banc.sem Cheque = NAO                 


if !_lCtrlPA							
	MsgAlert("Rotina não habilitada para uso! (AL_CTRLEPA)") 	
	Return
EndiF

//DBSELECTAREA("FK3") //16/07/19

aRotina :=RetMenu()	       		          

/*AADD(aCorZPA,{ "ZPA_STATUS == 'B'", "BR_VERMELHO"  })	//Bloqueda  
AADD(aCorZPA,{ "ZPA_STATUS == 'W'", "BR_AMARELO" 	})	//Email Enviado(AGUARDANDO WF)
AADD(aCorZPA,{ "ZPA_STATUS == 'L'", "BR_LARANJA"	})	//LIBERADO COMPRAS 
AADD(aCorZPA,{ "ZPA_STATUS == 'V'", "BR_AZUL" 		}) //VISTADA FINANCEIRO
AADD(aCorZPA,{ "ZPA_STATUS == 'X'", "BR_VERDE" 		}) //Liberada FINANCEIRO							
AADD(aCorZPA,{ "ZPA_STATUS == 'Z'", "BR_BRANCO" 	})	//PA GERADA
AADD(aCorZPA,{ "ZPA_STATUS == 'R'", "BR_PRETO" 		})	//Rejeitada							
AADD(aCorZPA,{ "ZPA_STATUS == 'D'", "BR_MARROM" 	})	//EXCLUIDO FINANCEIRO - 16/05/17 - Fabio Yoshioka*/

//13/03/18 - ajuste na exibição das cores
AADD(aCorZPA,{ "ZPA_STATUS == 'B' .AND. ZPA_TIPO<>'PA '", "BR_VERMELHO"  })	//Bloqueda  
AADD(aCorZPA,{ "ZPA_STATUS == 'W' .AND. ZPA_TIPO<>'PA '", "BR_AMARELO" 	})	//Email Enviado(AGUARDANDO WF)
AADD(aCorZPA,{ "ZPA_STATUS == 'L' .AND. ZPA_TIPO<>'PA '", "BR_LARANJA"	})	//LIBERADO COMPRAS 
AADD(aCorZPA,{ "ZPA_STATUS == 'V' .AND. ZPA_TIPO<>'PA '", "BR_AZUL" 		}) //VISTADA FINANCEIRO
AADD(aCorZPA,{ "ZPA_STATUS == 'X' .AND. ZPA_TIPO<>'PA '", "BR_VERDE" 		}) //Liberada FINANCEIRO							
AADD(aCorZPA,{ "ZPA_STATUS == 'Z' .OR.  ZPA_TIPO='PA ' ", "BR_BRANCO" 	})	//PA GERADA
AADD(aCorZPA,{ "ZPA_STATUS == 'R' .AND. ZPA_TIPO<>'PA '", "BR_PRETO" 		})	//Rejeitada							
AADD(aCorZPA,{ "ZPA_STATUS == 'D' .AND. ZPA_TIPO<>'PA '", "BR_MARROM" 	})	//EXCLUIDO FINANCEIRO - 16/05/17 - Fabio Yoshioka





dbSelectArea(_cAlias)
dbSetorder(1)

_aIndZPA:={}

IF !_lSolFin .AND. !_lSolCom
	_condZPA    := "ZPA->ZPA_TIPOPA ='2' .AND. ZPA->ZPA_SOLICI='"+RTRIM(_cUsuar)+"'"  //somente acesso ao que foi incluido para funcionarios 
ELSEIF _lSolFin .AND. !_lSolCom
	_condZPA    := "ZPA->ZPA_TIPOPA $ '12'" //Caso seja Finaceiro visualiza todos
	_lSemFiltro:=.T. //20/08/17
ELSEIF !_lSolFin .AND. _lSolCom
	//_condZPA    := "ZPA->ZPA_TIPOPA = '1' .or. (ZPA->ZPA_SOLICI='"+RTRIM(_cUsuar)+"' .AND. ZPA->ZPA_TIPOPA ='2')" //Caso seja do compras visualizo Toas de Fornecedor e somente as que inclui de funcionarios
	
	IF ZPA->(FieldPos("ZPA_MODULO")) > 0 //12/09/17 - Fábio Yoshioka
		_condZPA    := "(ZPA->ZPA_TIPOPA = '1' .AND. ZPA->ZPA_MODULO <> 'FIN') .or. (ZPA->ZPA_SOLICI='"+RTRIM(_cUsuar)+"' .AND. ZPA->ZPA_TIPOPA ='2')" //iNCLUIDO FILTRO DE REGISTROS INCLUIDOS DIRETO PELO FINANCEIRO
	ELSE
		_condZPA    := "ZPA->ZPA_TIPOPA = '1' .or. (ZPA->ZPA_SOLICI='"+RTRIM(_cUsuar)+"' .AND. ZPA->ZPA_TIPOPA ='2')" //Caso seja do compras visualizo Toas de Fornecedor e somente as que inclui de funcionarios
	ENDIF
ENDIF

	
IF !_lSemFiltro //20/08/17
	bFiltraBrw := {|| FilBrowse("ZPA",@_aIndZPA,@_condZPA) }
	Eval(bFiltraBrw)
ENDIF

//mBrowse( 6,1,22,75,_cAlias,,,,,,aCorZPA)

//aEval(_aIndZPA,{|x| Ferase(x[1]+OrdBagExt())})
mBrowse( 6,1,22,75,_cAlias,,,,,,aCorZPA,,,,,.F.) //opção filtro - 20/08/17


ENDFILBRW('ZPA',_aIndZPA)



/*
Local aIndex := {} Local cFiltro := "RA_SEXO == 'F'" //Expressao do Filtro 
Private aRotina := {; { "Pesquisar" , "PesqBrw" , 0 , 1 },;
 { "Visualizar" , "AxVisual" , 0 , 2 },;
 { "Incluir" , "AxInclui" , 0 , 3 },;
 { "Alterar" , "AxAltera" , 0 , 4 },;
 { "Excluir" , "AxDeleta" , 0 , 5 }; }

 Private bFiltraBrw := { || FilBrowse( "SRA" , @aIndex , @cFiltro ) }
 //Determina a Expressao do Filtro 
 
 Private cCadastro := "Exemplo de Filtro da mBrowse usando FilBrowse" 
 Eval( bFiltraBrw ) //Efetiva o Filtro antes da Chamada a mBrowse 
 mBrowse( 6 , 1 , 22 , 75 , "SRA" ) 
 
 EndFilBrw( "SRA" , @aIndex ) //Finaliza o Filtro 

Read more: http://www.blacktdn.com.br/2011/04/protheus-opcoes-de-filtro-na-mbrowse.html#ixzz4qLSa66AC

*/

Return


***************************
User Function ZPALegenda()
***************************

Local aLegenda := {}

	AADD(aLegenda,{"BR_VERMELHO","PA bloqueada"	})
	AADD(aLegenda,{"BR_AMARELO" ,"PA Nao Liberada GERENCIA"	})
	AADD(aLegenda,{"BR_LARANJA" ,"PA Liberada GERENCIA"	})	
	AADD(aLegenda,{"BR_AZUL"	 ,"PA Vistada FINANCEIRO"	})
	AADD(aLegenda,{"BR_VERDE"   ,"PA Liberada FINANCEIRO"	})
	AADD(aLegenda,{"BR_BRANCO"  ,"PA Gerada"	})
	AADD(aLegenda,{"BR_PRETO"  ,"PA Rejeitada GERENCIA"	})	
	AADD(aLegenda,{"BR_MARROM"  ,"PA Excluida FINANCEIRO"	})		 //16/05/17 - Fabio Yoshioka

BrwLegenda(cCadastro, "Legenda", aLegenda)
Return Nil

***********************
User Function COKINCPA() //Validação na inclusao da Solicitação de PA	
***********************
Local lRet := .T.                
Local cTipoPA := M->ZPA_TIPOPA
Local cFornece:= M->ZPA_FORNEC
Local _cLoja:= M->ZPA_LOJA
Local cPedido := Alltrim(M->ZPA_PEDIDO)
Local cCPF := Alltrim(Posicione("SA2",1,xFilial("SA2")+M->ZPA_FORNEC+M->ZPA_LOJA,"A2_CGC"))
Local aEmail := {} 
Local _aDadZPA:={}    
Local _dDtVenc:=M->ZPA_VENCTO //19/10/16
Local _dVlVenc:=U_RetDtVPA()
Local _cHist:=M->ZPA_HIST //15/11/16   
Local _lCpoPzNf:=.f. 
Local _dPrazoNf:=stod(space(8))
Local _lPAdoFin:= iif(upper(RTRIM(_cModulo))=='FIN' .AND. _lVisAllReg,.T.,.F.) //20/08/17
Local _nOpWhile:= .T.	
Local _aOp:= {"Normal","Boleto"}
Local _cMsg:= "Selecione a opção de PA: "
Local _nTotalPed:=0 //29/08/18 - Fabio Yoshioka 
 
_lIsBoleto:=.F. //10/01/18

IF ZPA->(FieldPos("ZPA_PZENNF")) > 0 //27/03/17 - Fábio Yoshioka
	_lCpoPzNf:=.T.  
	_dPrazoNf:=M->ZPA_PZENNF
ENDIF

aTitulo := {}

If Altera .and. !Inclui
	MSGStop("Rotina de Alteração não é permitida.","ALU_CADPA")
	Return(.F.)
EndIf


If Inclui
	
	**********************************
	//1- Se uma PA for a Fornecedor...
	**********************************
	If cTipoPA == '1'
	
		if _lPAdoFin //10/01/18 - Fabio Yoshioka
		 	_nOp:= Aviso("Opções de PA",_cMsg,_aOp)
		 	While _nOpWhile 
		 		If _nOp  == 1  .or. _nOp ==2                	    	
		 			Exit	    
		 		Else // Nao ou ESC
		 			ApMsgAlert("Obrigatório a seleção de uma opção!")
		 		Endif	 
		 	EndDo
		 	
		 	IF _nOp==2
		 		_lIsBoleto:=.T.
		 	ENDIF
		 	
		endif
	
		//If _dDtVenc<_dVlVenc //19/10/16
		If _dDtVenc<_dVlVenc .and. !_lPAdoFin //07/12/17 - Fabio Yoshioka
			MSGINFO("Data de vencimento inválida! A Data deve ser maior ou igual ao dia "+Dtoc(_dVlVenc),"ALU_CADPA")
			lRet := .F.
			Return(lRet)
		EndIf
		
		//a- O campo PEDIDO tem que estar preenchido!
		//If cPedido == ''
		If cPedido == '' .AND. !_lPAdoFin //20/08/17
			MSGINFO("Para incluir PA´s a FORNECEDORES é necessário o campo PEDIDO estar preenchido.","ALU_CADPA")
			lRet := .F.
			Return(lRet)
		EndIf     
		
		IF EMPTY(ALLTRIM(_cHist))  //15/11/16
			MSGINFO("O Campo histórico deve ser informado!","ALU_CADPA")
			lRet := .F.
			Return(lRet)
		ENDIF
		
		IF _lCpoPzNf  //27/03/17
			//IF EMPTY(ALLTRIM(DTOS(_dPrazoNf)))
			IF !_lPAdoFin .and. EMPTY(ALLTRIM(DTOS(_dPrazoNf))) //19/01/18
				MSGINFO("O Campo Dt de entrada da NF  deve ser informado!","ALU_CADPA")
				lRet := .F.
				Return(lRet)
		   ENDIF
		   
		   
		   //if _dPrazoNf<M->ZPA_DTEMIS //29/03/17
		   if _dPrazoNf<M->ZPA_DTEMIS .AND. !_lPAdoFin //23/01/18
				MSGINFO("A Data de entrada da NF  deve ser maior ou igual a Emissão!","ALU_CADPA")
				lRet := .F.
				Return(lRet)
			endif
			
			//VERIFICO SE A CONDIÇÃO DE PAGAMENTO DO PEDIDO PERMITE ADIANTAMENTOS (PREPARAÇÃO PARA A ROTINA DE COMPENSAÇÃO NA ENTRADA DA NF) - 04/04/17 - FABIO YOSHIOKA
			IF !_lPAdoFin //20/08/17
				_cCondPed:=Posicione("SC7",1,xFilial("SC7")+cPedido,"C7_COND")
				IF EMPTY(ALLTRIM(_cCondPed))
					MSGINFO("A Condição de pagamento deve ser informadada no Pedido!","ALU_CADPA")
					lRet := .F.
					Return(lRet)
				ELSE
					if !A120UsaAdi(_cCondPed,'0')         
						MsgAlert("A condição de pagamento "+_cCondPed+" não está habilitada para adiantamentos!")
						lRet := .F.
						Return(lRet)
					endif
				ENDIF	
			ENDIF		   
		ENDIF
		
		//b- Validando o Fornecedor:
		If Len(cCPF) = 14 //CNPJ
					
			DBSelectArea("SA2")
			DBSetOrder(1) 
			If !DBSeek(xFilial("SA2")+M->ZPA_FORNEC+M->ZPA_LOJA,.F.)
				MSGINFO("Somente Fornecedores com cadastrados poderão ser usados neste tipo de PA.","ALU_CADPA")
				lRet := .F.
				Return(lRet) 
			ELSE
				//VERIFICO SE POSSUI DADOS BANCARIOS CADASTRADOS - 19/10/16
				IF !_lIsBoleto //10/01/18
					IF EMPTY(SA2->A2_AGENCIA) .OR. EMPTY(SA2->A2_BANCO) .OR. EMPTY(SA2->A2_NUMCON)
						MSGINFO("Dados bancarios do fornecedor não cadastrados ou incompletos!","ALU_CADPA")
						lRet := .F.
						Return(lRet) 
					ENDIF
				ENDIF
				
				IF !_lPAdoFin //20/08/17
					//Comparo o fornecedor do pedido selecionado			
					_cQryPed := " "
	//				_cQryPed += " SELECT C7_FORNECE,C7_LOJA,SUM(C7_TOTAL) AS TOTPED FROM "+RetSQLName("SC7")+" "
//					_cQryPed += " SELECT C7_FORNECE,C7_LOJA,C7_MOEDA,SUM(C7_TOTAL) AS TOTPED,C7_VALIPI+C7_FRETE AS IPI_FRETE FROM "+RetSQLName("SC7")+" "   //24/04/17
					_cQryPed += " SELECT C7_FORNECE,C7_LOJA,C7_MOEDA,SUM(C7_TOTAL) AS TOTPED,SUM(C7_VALIPI+C7_FRETE) AS IPI_FRETE FROM "+RetSQLName("SC7")+" "   //12/09/17
					_cQryPed += " WHERE	C7_FILIAL = '"+xFilial("SC7")+"'"
					_cQryPed += " AND	C7_NUM = '"+RTRIM(cPedido)+"'"
					_cQryPed += " AND	D_E_L_E_T_ <> '*'"
	//				_cQryPed += " GROUP BY C7_FORNECE,C7_LOJA "  
					//_cQryPed += " GROUP BY C7_FORNECE,C7_LOJA,C7_MOEDA,C7_VALIPI+C7_FRETE "
					_cQryPed += " GROUP BY C7_FORNECE,C7_LOJA,C7_MOEDA " //12/09/17	Fabio Yoshioka				
					DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryPed), "TPED", .F., .T.) 
					IF !(rtrim(TPED->C7_FORNECE)==rtrim(M->ZPA_FORNEC) .and.  rtrim(TPED->C7_LOJA)==rtrim(M->ZPA_LOJA))
						MSGINFO("Fornecedor do pedido nao corresponde ao selecionado!","ALU_CADPA")   
						TPED->(dbclosearea())
						lRet := .F.
						Return(lRet)			
					ENDIF	
					
					_nTotalPed:=RetValPed(cPedido) //29/08/18
	
					IF TPED->C7_MOEDA==1  //24/04/17 - MOEDA = REAL
						IF lRet
							//IF M->ZPA_VALOR >TPED->TOTPED 
							//IF M->ZPA_VALOR >TPED->TOTPED+TPED->IPI_FRETE //24/04/17 
							IF M->ZPA_VALOR >(_nTotalPed+TPED->IPI_FRETE) //29/08/18
							  	//MSGINFO("Valor da PA ("+alltrim(str(M->ZPA_VALOR))+") nao pode ser maior que o valor total do pedido ("+alltrim(str(TPED->TOTPED))+")!","ALU_CADPA")   
								//MSGINFO("Valor da PA ("+alltrim(str(M->ZPA_VALOR))+") nao pode ser maior que o valor total do pedido ("+alltrim(str(TPED->TOTPED+TPED->IPI_FRETE))+")!","ALU_CADPA")   						  
								MSGINFO("Valor da PA ("+alltrim(str(M->ZPA_VALOR))+") nao pode ser maior que o valor total do pedido ("+alltrim(str(_nTotalPed+TPED->IPI_FRETE))+")!","ALU_CADPA") //29/08/18
								TPED->(dbclosearea())
								lRet := .F.
								Return(lRet)			
						   ENDIF
						ENDIF
					ELSE          //24/04/17 - MOEDA - ESTRANGEIRA   
						IF lRet    
							_nCotacao:=0
							_cQryMoeda := " "   
							/*_cQryMoeda += " SELECT M2_MOEDA"+ALLTRIM(str(TPED->C7_MOEDA))+" AS MOEDA FROM "+RetSQLName("SM2")+" "   //24/04/17
							_cQryMoeda += " WHERE	M2_DATA = '"+DTOS(dDatabase)+"'"
							_cQryMoeda += " AND	D_E_L_E_T_ <> '*'" */
	
							_cQryMoeda += " SELECT C7_TXMOEDA FROM "+RetSQLName("SC7")+" "   //09/05/17
							_cQryMoeda += " WHERE	C7_FILIAL = '"+xFilial("SC7")+"'"
							_cQryMoeda += " AND	C7_NUM = '"+RTRIM(cPedido)+"'"     
							_cQryMoeda += " AND	C7_TXMOEDA>0 "
							_cQryMoeda += " AND	D_E_L_E_T_ <> '*'"
							DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryMoeda), "TSM2", .F., .T.) 
							IF !TSM2->(EOF()) .AND. !TSM2->(BOF())
								//_nCotacao:=TSM2->MOEDA
								_nCotacao:=TSM2->C7_TXMOEDA
							ENDIF                    
							TSM2->(DBCLOSEAREA())  
							
							
							IF _nCotacao<>0   
								//IF M->ZPA_VALOR >(round(_nCotacao*TPED->TOTPED,2)+TPED->IPI_FRETE)
								IF M->ZPA_VALOR >(round(_nCotacao*_nTotalPed,2)+TPED->IPI_FRETE) //29/08/18
									//MSGINFO("Valor da PA ("+alltrim(str(M->ZPA_VALOR))+") nao pode ser maior que o valor total do pedido ("+alltrim(str(round(_nCotacao*TPED->TOTPED,2)+TPED->IPI_FRETE))+")!","ALU_CADPA")   
									MSGINFO("Valor da PA ("+alltrim(str(M->ZPA_VALOR))+") nao pode ser maior que o valor total do pedido ("+alltrim(str(round(_nCotacao*_nTotalPed,2)+TPED->IPI_FRETE))+")!","ALU_CADPA") //29/08/18
									TPED->(dbclosearea())
									lRet := .F.                                             	
									Return(lRet)			
							   ENDIF
							ELSE
								//MSGINFO("Valor da moeda "+ALLTRIM(str(TPED->C7_MOEDA))+" nao foi cadastrada no dia "+dtoc(dDatabase)+"!","ALU_CADPA")   
								MSGINFO("Valor da moeda "+ALLTRIM(str(TPED->C7_MOEDA))+" nao foi cadastrada no pedido !","ALU_CADPA")   
								TPED->(dbclosearea())							
								lRet := .F.
								Return(lRet)			
							ENDIF
						ENDIF				
					ENDIF
					TPED->(dbclosearea())
				ENDIF
			EndIf

		Else  //CPF    
			
			//Pesquisando no cadstro de funcionários
			DBSelectArea("SRA")
			DBSetOrder(5) //Filial + CIC
			If DBSeek(xFilial("SRA")+cCPF,.F.)
				MSGINFO("Escolha a opção FUNCIONÁRIOS para esta PA","ALU_CADPA") 
				lRet := .F.
				Return(lRet)			
			End If
		
		EndIf
	EndIf
	
    ********************************                       
	//Para Pagamentos a Funcionários 
    ********************************                       
	If M->ZPA_TIPOPA = '2' 
		//Pego o CPF do fornecedor
		cCPF := Alltrim(Posicione("SA2",1,xFilial("SA2")+M->ZPA_FORNEC+M->ZPA_LOJA,"A2_CGC"))
		If Len(cCPF) > 11                                
			//Valido se Pessoa Fisica
			MSGINFO("Somente serão permitidos Passoas Fisicas para esta modalidade de PA","ALU_CADPA")
			Return(lRet)
		Else 
			//Pesquisando no cadstro de funcionários
			DBSelectArea("SRA")
			DBSetOrder(5) //Filial + CIC
			If !DBSeek(xFilial("SRA")+cCPF,.F.)
				MSGINFO("Somente serão permitida PA a colaboradores cadastrados.","ALU_CADPA") 
				lRet := .F.
				Return(lRet)			
			End If
    	EndIf
	EndIf		  
	
	IF lRet  
		cCodSol:=""
		cCodApro:=""
		cNomSol:=""
		cNomApro:=""
		cMaiApro:=""
		cMaiSol:=""
		
		lRet:=ValSolPA(M->ZPA_TIPOPA,.F.)  //VALIDO INFORMAÇÕES DE ALÇADA
		
		if lRet       
			IF _lPAdoFin .and. rtrim(M->ZPA_TIPOPA)=='1' 
				RETURN .T. //20/08/17
			ENDIF		
			
			//Carrego   vetores
			aEmail := {}
			aAdd(aEmail, cCodSol ) 					//01 Cod Solicitante
			aAdd(aEmail, Alltrim(cNomSol) )		//02 Nome Solicitante
			aAdd(aEmail, Alltrim(cMaiSol) )		//03 //Mail do Solicitante
			aAdd(aEmail, cCodApro )					//04 Cod Aprovador
			aAdd(aEmail, Alltrim(cNomApro) )		//05 Nome Aprovador
			aAdd(aEmail, Alltrim(cMaiApro) ) 	//06 Mail do Aprovador
			
			_aDadZPA:={} 
			aAdd(_aDadZPA,M->ZPA_PREFIX)  	//01
			aAdd(_aDadZPA,M->ZPA_NUM)			//02
			aAdd(_aDadZPA,_cParcela)     		//03
			aAdd(_aDadZPA,M->ZPA_TIPO)       //04
			aAdd(_aDadZPA,M->ZPA_FORNEC)     //05
			aAdd(_aDadZPA,M->ZPA_LOJA)       //06
			aAdd(_aDadZPA,M->ZPA_DTEMIS)     //07
			aAdd(_aDadZPA,M->ZPA_VENCTO)     //08
			aAdd(_aDadZPA,M->ZPA_VALOR)      //09
			aAdd(_aDadZPA,M->ZPA_NATURE)     //10
			aAdd(_aDadZPA,M->ZPA_CC)         //11
			aAdd(_aDadZPA,M->ZPA_BANCO)      //12
			aAdd(_aDadZPA,M->ZPA_AGENC)      //13
			aAdd(_aDadZPA,M->ZPA_DIGAGE)     //14
			aAdd(_aDadZPA,M->ZPA_CONTA)      //15
			aAdd(_aDadZPA,M->ZPA_DIGCON)     //16
			aAdd(_aDadZPA,M->ZPA_NUMCHQ)     //17
			aAdd(_aDadZPA,M->ZPA_HISTCH)     //18
			aAdd(_aDadZPA,M->ZPA_BENEF)      //19
			aAdd(_aDadZPA,M->ZPA_HIST)       //20
			
			IF ZPA->(FieldPos("ZPA_PRIORI")) > 0 //10/01/18 - Fábio Yoshioka
				aAdd(_aDadZPA,M->ZPA_PRIORI) //21
			ENDIF

			lRet:=U_WFREnvZPA(aEmail,_aDadZPA,M->ZPA_TIPOPA,.F.)
		
		endif
		
	ENDIF
	
EndIf
                                
Return(lRet)           





*****************************************
Static Function ValSolPA(_cTpPA,_lRenv)
*****************************************
Local lRet := .F. 
//Local cGrpApro := "000006" //Alltrim( GetMV("AL_GRPCOM") )
Local cGrpApro := Alltrim( GetMV("AL_GRPCOM") )
Local lUserSol := lUserApro := lRet := .F.
Local cCargoSOL := ""  
Local _lPAdoFin:= iif(upper(RTRIM(_cModulo))=='FIN' .AND. _lVisAllReg,.T.,.F.) //20/08/17

if _lRenv
	cCodSol:= ZPA->ZPA_SOLICI
	cNomSol:= ZPA->ZPA_NOMESO
	cMaiSol:=UsrRetMail(ZPA->ZPA_SOLICI)
else
	cCodSol:= RetCodUsr()
	cNomSol:=UsrRetName(cCodSol)
	cMaiSol:=UsrRetMail(cCodSol)
endIf

cCodApro 	:= "000000"

if rtrim(_cTpPA)=='1' //Fonecedores
	IF !_lPAdoFin //20/08/17
		***********************
		//Pesquiso pelo usuario
		***********************
		cQuery := " "
		cQuery += "SELECT * FROM "+RetSQLName("SAI")+" "
		cQuery += "WHERE	AI_FILIAL = '"+xFilial("SAI")+"' AND "
		cQuery += "			AI_USER = '"+cCodSol+"' AND "
		cQuery += "			AI_GRPAPRO = '"+cGrpApro+"' AND "
		cQuery += "			D_E_L_E_T_ <> '*' "
		cQuery := ChangeQuery(cQuery)
		DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.) 
		DBSelectArea("QRY")
		If !EOF() 
			lRet := .T.
		Else     
			MSGINFO("Usuário não cadastrado no Grupo de Compras, ou Grupo não encontrado.","ALU_CADPA")	
			lRet := IIF(cCodSol == '000000',.T.,.F.)
		EndIf	
		QRY->(DBCloseArea())                    
		                        
		
		***********************
		//Se achou o usuario...                    
		***********************
		If lRet
			//...Pesquiso pelo Gerente do Compras que irá aprovar a PA
			cQuery := ""
			cQuery += "SELECT * FROM "+RetSQLName("SAL")+" "
			cQuery += "WHERE	AL_FILIAL = '"+xFilial("SAL")+"' AND "
			cQuery += "			AL_CARGO = 'G' AND " //GERENTE QUE FAZ APROVAÇÃO 
			cQuery += "			AL_COD = '"+cGrpApro+"' AND "
			cQuery += "			D_E_L_E_T_ <> '*' AND "
			cQuery += "			AL_STATUS<>'D' 
			cQuery += "			ORDER BY AL_NIVEL "		
			cQuery := ChangeQuery(cQuery)
			DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.) 
			DBSelectArea("QRY") 
			If !EOF()  
				//Encotrei o Aprovador
				cCodApro := QRY->AL_USER
				cNomApro:=UsrRetName(cCodApro)
				cMaiApro:=UsrRetMail(cCodApro)
				lRet := .T.
			Else
				//Não encontrei o Aprovador
				MSGINFO("Gerente não cadastrado para Grupo de Compras.","ALU_CADPA")
				cCodApro := "000000"
				lRet := IIF(cCodSol== '000000',.T.,.F.)
			EndIf
			QRY->(DBCloseArea())
		Endif
	ELSE
		lRet := .T.	//20/08/17	
	EndIf 
else  //Funcionarios

	cCodApro := ""
	lRet := .F. 
	cGrpApro := ""
	lUserSol := lUserApro := lRet := .F.
	cCargoSOL := ""  
	
	//Verificando o grupo de aprovação
	cGrpApro := Posicione("SAI",2,xFilial("SAI")+cCodSol,"AI_GRPAPRO")
	
	//...Pesquiso pelo Gerente do Setor que irá aprovar a PA
	cQuery := ""
	cQuery += "SELECT * FROM "+RetSQLName("SAL")+" "
	cQuery += "WHERE	AL_FILIAL = '"+xFilial("SAL")+"' AND "
	cQuery += "			AL_CARGO = 'G' AND "
	cQuery += "			AL_COD = '"+cGrpApro+"' AND "
	cQuery += "			D_E_L_E_T_ <> '*' AND "
	cQuery += "			AL_STATUS<>'D' 
	cQuery += "			ORDER BY AL_NIVEL "		

	cQuery := ChangeQuery(cQuery)
	DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRY", .F., .T.) 
	DBSelectArea("QRY") 
	If !EOF()  
		//Encotrei o Aprovador
		cCodApro := QRY->AL_USER
		cNomApro:=UsrRetName(cCodApro)
		cMaiApro:=UsrRetMail(cCodApro)
		lRet := .t. 
	Else
		//Não encontrei o Aprovador
		MSGINFO("Aprovador da PA de Funcionarios não encontrado!","ALU_CADPA")
		cCodApro := "000000"
	EndIf
	QRY->(DBCloseArea())

endif
       
Return lRet


**********************************************************
User Function WFREnvZPA(_aDadSol,_aDadTit,_cTipPa,_lReenv)//05/08/16
**********************************************************

Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto 
Local cDadoTit 
//Local lBaseProd := IIf(GetServerIP() == '172.28.1.24', .T.,.F.)
Local lBaseProd := IIf(GetServerIP() == RTRIM(_cIpProd), .T.,.F.)
Local lOk := .F.  
Local _aTitulo:=aClone(_aDadTit)
Local _lPriori:=.f. //10/01/18

IF ZPA->(FieldPos("ZPA_PRIORI")) > 0 //10/01/18 - Fábio Yoshioka
	if len(_aTitulo)>=21
		_lPriori:= iif(rtrim(_aTitulo[21])=='0',.T.,.F.)
	endif
endif 


IF rtrim(_cTipPa)=='1' //14/09/16
	_cTitulo:="TITULO DE PAGAMENTO ANTECIPADO"
Else
	_cTitulo:="ADIANTAMENTO A FUNCIONARIOS"
Endif                                                    

                           
cCodProcesso := "WF_106" 																	
//cHtmlModelo := "\Workflow\WF_HTMLV2\ADM\Alcada_CP\AutorizaPA_Page.html"
cHtmlModelo :=rtrim(_cModelPA)+"AutorizaPA_Page.html"   
//cHtmlModelo :=rtrim(_cModelPA)+"AutorizaPA"+rtrim(_cTipPa)+"_Page.html"   //12/09/16

IF rtrim(_cTipPa)=='1'
	cAssunto := "Aprovação de Pagamento Antecipado a Fornecedores"	
Else
	cAssunto := "Aprovação de Adiantamento a Funcionarios "	
Endif                                                    

oProcess:= TWFProcess():New(cCodProcesso, cAssunto) 										
cTitulo :=  "WF_106" 																		
oProcess:NewTask(cTitulo, cHtmlModelo) 														
oHtml	:= oProcess:oHTML 

cDadoTit := padr(_aTitulo[1],3)+padr(_aTitulo[2],9)+padr(_aTitulo[3],2)+padr(_aTitulo[4],3)+padr(_aTitulo[5],6)+padr(_aTitulo[6],2)
DBSelectArea("ZPA")
DBSetOrder(1)
DBSeek(xFilial("ZPA")+cDadoTit)

//Dados do Cabeçalho
oProcess:oHtml:ValByName( "cTitPA" 	,_cTitulo) //14/09/16
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(_aDadSol[2]))
oProcess:oHtml:ValByName( "cCodSol" 	,_aDadSol[1])
oProcess:oHtml:ValByName( "cAprovador" ,Alltrim(_aDadSol[5]))
oProcess:oHtml:ValByName( "cCodAprov" 	,_aDadSol[4] )
oProcess:oHtml:ValByName( "cTipoFor" 	,IIF(rtrim(_cTipPa) == '1',"Fornecedor","Colaborador"))

oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(Posicione("SA2",1,XFILIAL("SA2")+_aTitulo[5]+_aTitulo[6],"A2_NOME")))
oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(_aTitulo[7]))
oProcess:oHtml:ValByName( "cDtPagto" 	,DTOC(_aTitulo[8]))
oProcess:oHtml:ValByName( "cValor" 		,Transform(_aTitulo[9],"@E 999,999,999.99"))
oProcess:oHtml:ValByName( "cMotivo" 	,Alltrim(_aTitulo[20]))
oProcess:oHtml:ValByName( "cPriori" 	,iif(_lPriori,"URGENTE","Normal") ) 



//Função de retorno a ser executada quando a mensagem de respostas retornar ao Workflow:
oProcess:bReturn :=  "U_RetWFPA()" 				

*********************************************	 					 
//Guardo o ID do Processo para enviar no link
*********************************************	 					 	
cMailID := oProcess:Start()

******************
//Enviando o Link!
******************
oHtml:SaveFile("web\ws\wflow"+"\"+cMailID+".HTM")     		//Salvo HTML do Processo
cRet := WFLoadFile("web\ws\wflow"+"\"+cMailID+".HTM")		//Carrego o link do Processo (será usado no retorno da Aprovação)

IF rtrim(_cTipPa)=='1' //14/09/16
	_cTitulo:="TITULO DE PAGAMENTO ANTECIPADO"
Else
	_cTitulo:="ADIANTAMENTO A FUNCIONARIOS"
Endif                                                    


IF rtrim(_cTipPa)=='1'
	cAssunto := "Aprovação de Pagamento Antecipado a Fornecedores"	
Else
	cAssunto := "Aprovação de Adiantamento a Funcionarios "	
Endif                                                    


//cHtmlModelo := "\workflow\WF_HTMLV2\Adm\Alcada_CP\AutorizaPA_Link.html"
cHtmlModelo :=rtrim(_cModelPA)+"AutorizaPA_Link.html"
//cHtmlModelo :=rtrim(_cModelPA)+"AutorizaPA"+rtrim(_cTipPa)+"_Link.html" //12/09/16

//Inicio nova tarefa do Processo... O Link.
oProcess:NewTask(cAssunto, cHtmlModelo)      

                                           
//Dados do Cabeçalho
oProcess:oHtml:ValByName( "cTitPA" 	,_cTitulo) //14/09/16
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(_aDadSol[2]))
oProcess:oHtml:ValByName( "cCodSol" 	,_aDadSol[1])
oProcess:oHtml:ValByName( "cAprovador" ,Alltrim(_aDadSol[5]))
oProcess:oHtml:ValByName( "cCodAprov" 	,_aDadSol[4] )

oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(Posicione("SA2",1,XFILIAL("SA2")+_aTitulo[5]+_aTitulo[6],"A2_NOME")))
oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(_aTitulo[7]))
oProcess:oHtml:ValByName( "cDtPagto" 	,DTOC(_aTitulo[8]))
oProcess:oHtml:ValByName( "cValor" 		,Transform(_aTitulo[9],"@E 999,999,999.99"))
oProcess:oHtml:ValByName( "cMotivo" 	,Alltrim(_aTitulo[20])) 
oProcess:oHtml:ValByName( "cPriori" 	,iif(_lPriori,"URGENTE","Normal") ) //10/01/18

//Revisao do Workflow
_cIpTest:=SuperGetMV("AL_IPSRVTS",.f.,"172.28.1.20")
lServTeste := IIf(GetServerIP() == RTRIM(_cIpTest), .T.,.F.)

cServerIni := GetAdv97()
cSecao := "SRVWFLOW"
cPadrao := "undefined"
cIPLan := GetPvProfString(cSecao, "IPWFLAN", cPadrao, cServerIni)
cPtLan := GetPvProfString(cSecao, "PTWFLAN", cPadrao, cServerIni)
cIPWeb := GetPvProfString(cSecao, "IPWFWEB", cPadrao, cServerIni)
cPtWeb := GetPvProfString(cSecao, "PTWFWEB", cPadrao, cServerIni)

If !lServTeste //Servidor Produção

	oProcess:ohtml:ValByName("proc_localink",RTRIM(_cPrcSrvI)+cMailID+".htm")
	oProcess:ohtml:ValByName("proc_weblink",RTRIM(_cPrcSrvE)+cMailID+".htm")
	IF _lPriori //10/01/18
		oProcess:cSubject := iif(rtrim(_cTipPa)=='1',"ALUBAR LINK Para Autorização de Pagamento Antecipado.","ALUBAR LINK Para Autorização de Adiantamento a funcionarios.")+DTOC(dDataBase)
	ELSE
		oProcess:cSubject := iif(rtrim(_cTipPa)=='1',"ALUBAR LINK (URGENTE) Para Autorização de Pagamento Antecipado.","ALUBAR LINK Para Autorização de Adiantamento a funcionarios.")+DTOC(dDataBase)	
	ENDIF
	oProcess:cTo := Alltrim(UsrRetMail(cCodApro))+";"+Alltrim(GetMv("AL_MAILADM")) 
	cEndPage := RTRIM(_cPrcSrvI)+cMailID+".htm"
	
Else //Servidor Base_teste   
	oProcess:ohtml:ValByName("proc_localink",RTRIM(_cPrcSrvI)+cMailID+".htm")
	cEndPage := RTRIM(_cPrcSrvI)+cMailID+".htm"    
	
	IF _lPriori //10/01/18
		oProcess:cSubject := iif(rtrim(_cTipPa)=='1',"TESTE ALUBAR LINK (URGENTE) Para Autorização de Pagamento Antecipado.","ALUBAR LINK Para Autorização de Adiantamento a funcionarios.")+DTOC(dDataBase)
	ELSE
		oProcess:cSubject := iif(rtrim(_cTipPa)=='1',"TESTE ALUBAR LINK Para Autorização de Pagamento Antecipado.","ALUBAR LINK Para Autorização de Adiantamento a funcionarios.")+DTOC(dDataBase)
	ENDIF
	oProcess:cTo := Alltrim(GetMv("AL_MAILADM")) 

EndIf	
oProcess:Start()                         

//Cotacões
IF !_lReenv //CASO SEJA REENVIO
	M->ZPA_STATUS := 'W'   //10/08/16
	M->ZPA_PARCEL :=_cParcela
	M->ZPA_TIPO :='PR'//19/08/16	
ENDIF	

//Se rodou até aqui...
lOk := .T.          

if lOk 
	if rtrim(_cTipPa)=='1'
		MSGINFO("E-mail enviado para o aprovador do setor de compras!","ALU_CADPA")
	else
		MSGINFO("E-mail enviado para aprovação pela gerencia do setor!","ALU_CADPA")	
	endif
endif

Return(lOk)          
                


*************************
User Function StartWFPA() //Reenvio de e-mail
*************************

Local cTipoPA := ZPA->ZPA_TIPOPA
Local cCCusto := ZPA->ZPA_CC  
Local aEmail:={}
Local _aDadZPA:={}

if UPPER(RTRIM(ZPA->ZPA_STATUS))<>'W'
	MsgAlert("O status do registro NAO PERMITE o reenvio") 
	RETURN
ENDIF

If MSGYESNO("Esta opção irá reenviar esta PA para aprovação. Deseja continuar?","Reenvia Aprovacao PA")
	cCodSol:=""
	cCodApro:=""
	cNomSol:=""
	cNomApro:=""
	cMaiApro:=""
	cMaiSol:=""
	
	IF ValSolPA(cTipoPA,.T.)

	
		//Carrego   vetores
		aEmail := {}
		aAdd(aEmail, cCodSol ) 						//01 Cod Solicitante
			aAdd(aEmail, Alltrim(cNomSol) )		//02 Nome Solicitante
			aAdd(aEmail, Alltrim(cMaiSol) )		//03 //Mail do Solicitante
			aAdd(aEmail, cCodApro )					//04 Cod Aprovador
			aAdd(aEmail, Alltrim(cNomApro) )		//05 Nome Aprovador
			aAdd(aEmail, Alltrim(cMaiApro) ) 	//06 Mail do Aprovador
			
			
			_aDadZPA:={} 
			aAdd(_aDadZPA,	ZPA->ZPA_PREFIX)  	//01
			aAdd(_aDadZPA,	ZPA->ZPA_NUM)		  	//02
			aAdd(_aDadZPA,	_cParcela)     		//03
			aAdd(_aDadZPA,	ZPA->ZPA_TIPO)       //04
			aAdd(_aDadZPA,	ZPA->ZPA_FORNEC)     //05
			aAdd(_aDadZPA,	ZPA->ZPA_LOJA)       //06
			aAdd(_aDadZPA,	ZPA->ZPA_DTEMIS)     //07
			aAdd(_aDadZPA,	ZPA->ZPA_VENCTO)     //08
			aAdd(_aDadZPA,	ZPA->ZPA_VALOR)      //09
			aAdd(_aDadZPA,	ZPA->ZPA_NATURE)     //10
			aAdd(_aDadZPA,	ZPA->ZPA_CC)         //11
			aAdd(_aDadZPA,	ZPA->ZPA_BANCO)      //12
			aAdd(_aDadZPA,	ZPA->ZPA_AGENC)      //13
			aAdd(_aDadZPA,	ZPA->ZPA_DIGAGE)     //14
			aAdd(_aDadZPA,	ZPA->ZPA_CONTA)      //15
			aAdd(_aDadZPA,	ZPA->ZPA_DIGCON)     //16
			aAdd(_aDadZPA,	ZPA->ZPA_NUMCHQ)     //17
			aAdd(_aDadZPA,	ZPA->ZPA_HISTCH)     //18
			aAdd(_aDadZPA,	ZPA->ZPA_BENEF)      //19
			aAdd(_aDadZPA,	ZPA->ZPA_HIST)       //20

			if U_WFREnvZPA(aEmail,_aDadZPA,ZPA->ZPA_TIPOPA,.T.)
				//Limpando as aprovações
			   //DBSelectArea("ZPA")
			   //Reclock("ZPA",.F.) 
			   cChave:=padr(_aDadZPA[1],3)+padr(_aDadZPA[2],9)+padr(_aDadZPA[3],2)+padr(_aDadZPA[4],3)+padr(_aDadZPA[5],6)+padr(_aDadZPA[6],2)
			   
			   DBSelectArea("ZPA")
				DBSetOrder(1)
				If DBSeek(xFilial("ZPA")+cChave,.F.)
					Reclock("ZPA",.F.) 
					ZPA->ZPA_STATUS := 'W'
					ZPA->ZPA_APROV1 := ''
					ZPA->ZPA_NAPRO1 := ''
					ZPA->ZPA_DTAPR1 := STOD('')
					ZPA->ZPA_HRAPR1 := ''
					ZPA->ZPA_APROV2 := ''
					ZPA->ZPA_NAPRO2 := ''
					ZPA->ZPA_DTAPR2 := STOD('')
					ZPA->ZPA_HRAPR2 := ''
					ZPA->ZPA_APROV3 := ''
					ZPA->ZPA_NAPRO3 := ''
					ZPA->ZPA_DTAPR3 := STOD('')
					ZPA->ZPA_HRAPR3 := ''
					ZPA->(MSUnlock())   
				Endif
			endif		         
				
	ENDIF
	
EndIf

Return   

*********************************
User Function RetWFPA(oProcess) //processo de retorno - apos confirmação ou rejeição pelo aprovador do compras
*********************************

Local oHtml 		:= oProcess:oHtml  
Local cChave 		:= oProcess:oHtml:RetByName("cDadoTit")  
Local lYESNO		:= IIF(oProcess:oHtml:RetByName("RBAPROVA") = "Sim",.T.,.F.)
Local cCodAprov	:= oProcess:oHtml:RetByName("cCodAprov") 
Local cCodSolic	:= oProcess:oHtml:RetByName("cCodSol") 
Local cMotivo		:= oProcess:oHtml:RetByName("LBMOTIVO")  
Local aChave := {}         
Local _lTemSe2:=.F.
Local _LEnvVisto:=.f. //23/05/19
Local _cNSolic:="" //23/05/19
Local _cChvLibFin:="" //31/05/19
Private lMsErroAuto 	:= .F.
Private lMsHelpAuto 	:= .F.  
Private _cCustPA:=GetMV("AL_CCUSTPA")//10/08/16     
Private _cNatuPA:=GetMV("AL_NATURPA")//10/08/16     

cTab:= "SX1->X1_PRESEL"
cCpo:= "X1_PRESEL"

Conout("RetWFPA: " +cChave)
//Posiciono na ZPA	
DBSelectArea("ZPA")
DBSetOrder(1)
If DBSeek(xFilial("ZPA")+cChave,.F.)
		
	//Pegando dados bancarios
	cBancoAdt	:= ZPA->ZPA_BANCO
	cAgenciaAdt	:= ZPA->ZPA_AGENC
	cNumCon	 	:= ZPA->ZPA_CONTA
	cChequeAdt	:= ZPA->ZPA_NUMCHQ
	cHistor		:= ZPA->ZPA_HISTCH
	cBenef		:= ZPA->ZPA_BENEF	
	      
	Conout("ENCONTRADO TITULO ZPA "+ZPA->ZPA_NUM)
	aAdd(aChave, ZPA->ZPA_PREFIX)                                   
	aAdd(aChave, ZPA->ZPA_NUM)                                   
	aAdd(aChave, ZPA->ZPA_PARCEL)                                   
	aAdd(aChave, ZPA->ZPA_TIPO)
	aAdd(aChave, ZPA->ZPA_FORNEC)                                   
	aAdd(aChave, ZPA->ZPA_LOJA)
	
	IF ZPA->(FieldPos("ZPA_PRIORI")) > 0 //10/01/18 - Fábio Yoshioka
		aAdd(aChave,ZPA->ZPA_PRIORI)//P7
	ENDIF
	//Executa o retorno do PA gravando os lançamentos     
	If lYESNO
	
		_cChvLibFin:=ZPA->ZPA_FILIAL+ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+'PR '+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA //31/05/19
	
	  //	cDestinat := Alltrim(UsrRetMail(ZPA->ZPA_SOLICI))+";"+GetNewPar("AL_FINEMAIL","joao.santos@alubar.net")/
	  	cDestinat := Alltrim(UsrRetMail(ZPA->ZPA_SOLICI))+";"+GetMV("AL_FINEMAI") //25/04/17
		
		//Desabilitando a visualização do Lançamento Contab.
		DBSELECTAREA("SX1")
		DBSetOrder(1)
		DBSeek("FIN050    "+"01")
		RecLock("SX1",.F.)
		&(cTab) := 2 //Mostra Lancto = Não
		MSUnlock()	

		DBSeek("FIN050    "+"04")
		RecLock("SX1",.F.)
		&(cTab) := 2 //Contabiliza on Line = NAO         
		MSUnlock()	
		
		DBSeek("FIN050    "+"05")
		RecLock("SX1",.F.)
		&(cTab) := 2 //Gerar Chq.p/Adiant. = NAO                  
		MSUnlock()	

		DBSeek("FIN050    "+"09")
		RecLock("SX1",.F.)
		&(cTab) := 2 //Mov.Banc.sem Cheque = NAO              
		MSUnlock()	
		
		
		//Inclusão do Titulo no SE2 após a liberado
		Conout("Entrando em ZPA")
		DBSelectARea("ZPA")
		
		_cQrySE2 := " "
		_cQrySE2 += "SELECT * FROM "+RetSQLName("SE2")+" "
		_cQrySE2 += "WHERE	E2_FILIAL = '"+xFilial("SE2")+"' AND "
		_cQrySE2 += "			E2_PREFIXO = '"+RTRIM(ZPA->ZPA_PREFIX)+"' AND "
		_cQrySE2 += "			E2_NUM = '"+RTRIM(ZPA->ZPA_NUM)+"' AND "
		_cQrySE2 += "			E2_PARCELA = '"+RTRIM(ZPA->ZPA_PARCEL)+"' AND "		
		_cQrySE2 += "			E2_TIPO = '"+RTRIM(ZPA->ZPA_TIPO)+"' AND "	 // Título provisório
		_cQrySE2 += "			E2_FORNECE = '"+RTRIM(ZPA->ZPA_FORNEC)+"' AND "		
		_cQrySE2 += "			E2_LOJA = '"+RTRIM(ZPA->ZPA_LOJA)+"' AND "		
		_cQrySE2 += "			D_E_L_E_T_ <> '*' "
		DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySE2), "TSE2", .F., .T.) 
		IF !TSE2->(EOF()) .AND. !TSE2->(BOF())
			_lTemSe2:=.T.		
		ENDIF

		IF !_lTemSe2
				
			aTitulo := {}
						
			//INCLUSAO DE TITULO PROVISORIO - 10/08/16
			//18/12/18 - Fabio Yoshioka - Inclusao de Gravação do Campo E2_PZENNF - Chamado 21705
			
			aTitulo :={	{"E2_FILIAL"	,xFilial("ZPA")			 ,Nil},;
						{"E2_PREFIXO"		,ZPA->ZPA_PREFIX	,Nil},;
						{"E2_NUM"      	,ZPA->ZPA_NUM			,Nil},;
			        	{"E2_PARCELA"  	,ZPA->ZPA_PARCEL		,Nil},;
			        	{"E2_TIPO"     	,'PR'					,Nil},;               
			        	{"E2_NATUREZ"  	,_cNatuPA				,Nil},;
			        	{"E2_FORNECE"  	,ZPA->ZPA_FORNEC		,Nil},; 
			        	{"E2_LOJA"     	,ZPA->ZPA_LOJA			,Nil},;      
			        	{"E2_EMISSAO"  	,ZPA->ZPA_DTEMIS		,NIL},;
			        	{"E2_VENCTO"   	,ZPA->ZPA_VENCTO		,NIL},;                          
			    		{"E2_VENCREA"  	,ZPA->ZPA_VENCTO		,NIL},;                                                   
			        	{"E2_VALOR"    	,ZPA->ZPA_VALOR			,Nil},;
			        	{"E2_VLCRUZ"	,ZPA->ZPA_VALOR			,Nil},; 
						{"E2_HIST"		,ZPA->ZPA_HIST			,Nil},; 			       	
			        	{"E2_STATWF"	,"LB"					,Nil},;
			        	{"E2_PZENNF"	,ZPA->ZPA_PZENNF		,Nil},;
			        	{"E2_CC"    	,_cCustPA				,Nil}}
	
			           		
				
			*****************************	
			//Inicio a inclusão do titulo
			*****************************	
			lMsErroAuto := .F.
			Conout("Executando EXECAUTO "+ZPA->ZPA_NUM)
			MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao  
				
			If lMsErroAuto                
				//Caso encontre erro, mostre
				Conout("Erro do EXECAUTO "+ZPA->ZPA_NUM)
			 	//Mostraerro()
			Else    
			 	Conout("Exito na Gravação Atualizando ZPA "+ZPA->ZPA_NUM)  
	 			DBSelectARea("ZPA")  
				
				U_AltStPA(ZPA->ZPA_FILIAL+ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA,'L',cCodAprov,UsrRetName(cCodAprov))    			
				
				ZPAYESNO(aChave,cDestinat,lYesNo)	
				_LEnvVisto:=.T.	
				_cNSolic:=ZPA->ZPA_NOMESO
			Endif
			
		ELSE
		 	Conout("Titulo Provisório existente no SE1 "+ZPA->ZPA_NUM)  			

			U_AltStPA(ZPA->ZPA_FILIAL+ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA,'L',cCodAprov,UsrRetName(cCodAprov))    					 	
			
			ZPAYESNO(aChave,cDestinat,lYesNo)
			_LEnvVisto:=.T.	
			_cNSolic:=ZPA->ZPA_NOMESO
		EndIf
		
	Else	//Se o titulo for rejeitado
		
		cDestinat := Alltrim(UsrRetMail(ZPA->ZPA_SOLICI))   
	    
		Conout("Rejeitando ZPA "+ZPA->ZPA_NUM)
		
		DBSelectARea("ZPA")  
		RecLock("ZPA",.F.)
			ZPA->ZPA_STATUS := 'R'
			ZPA->ZPA_APROV1 := cCodAprov
			ZPA->ZPA_NAPRO1 := UsrRetName(cCodAprov)
			ZPA->ZPA_DTAPR1 := dDataBase
			ZPA->ZPA_HRAPR1 := SUBStr(Time(),1,5)
		ZPA->(MSUnlock())
		ZPAYESNO(aChave,cDestinat,lYesNo)
		
	End If
EndIf
         
//Reabilitando a visualização do Lançamento Contab.
DBSELECTAREA("SX1")
DBSetOrder(1)
DBSeek("FIN050    "+"01")
RecLock("SX1",.F.)
&(cTab) := 1 //Mostra Lancto = SIM
MSUnlock()	
    
DBSeek("FIN050    "+"04")
RecLock("SX1",.F.)
&(cTab) := 1 //Contabiliza on Line = SIM         
MSUnlock()	

DBSeek("FIN050    "+"05")
RecLock("SX1",.F.)
&(cTab) := 1 //Gerar Chq.p/Adiant. = SIM                  
MSUnlock()	

DBSeek("FIN050    "+"09")
RecLock("SX1",.F.)
&(cTab) := 1 //Mov.Banc.sem Cheque = SIM              
MSUnlock()

IF _LEnvVisto 
	Conout("Enviando Titulo "+_cChvLibFin+" para liberação no Financeiro")
	U_EnvVisFin(_cChvLibFin,_cNSolic) //23/05/19 - Melhorias Financeiro 2019 - Fabio Yoshioka - Envio para liberação da Coordenaçao
ENDIF	

Conout("Fim da Rotina RetAutPA")
Return()

*************************************************
Static Function ZPAYESNO(aChave,cDestinat,lYesNo)
*************************************************

Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto 
Local cDadoTit 
Local lBaseProd := IIf(GetServerIP() == '172.28.1.24', .T.,.F.)
Local lOk := .F.
Local _lPriori:=.f. //10/01/18

IF ZPA->(FieldPos("ZPA_PRIORI")) > 0 //10/01/18 - Fábio Yoshioka
	if len(aChave)>=7
		_lPriori:= iif( rtrim(aChave[7])=='0',.T.,.F.)		
	endif
ENDIF


If lYesNo 
	cCabec := "APROVAÇÃO DE "
	cTexto := "Informados que o Pagamento Antecipado (PA) conforme os dados abaixo, foi aprovado e incluído no Contas a Pagar."
Else
	cCabec := "REJEIÇÃO DE "
	cTexto := "Informados que o Pagamento Antecipado (PA) conforme os dados abaixo, foi rejeitado."		
EndIf
                           
cCodProcesso := "WF_106" 																	
cHtmlModelo := "\Workflow\WF_HTMLV2\ADM\Alcada_CP\AutorizaPA_YESNO.html"
//cHtmlModelo := "\Workflow\WF_HTMLV2\ADM\Alcada_CP\AutorizaPA"+rtrim(aChave[1])+"_YESNO.html" //12/09/16
cAssunto := "Notificação de Pagamento Antecipado"	
oProcess:= TWFProcess():New(cCodProcesso, cAssunto) 										
cTitulo :=  "WF_106" 																		
oProcess:NewTask(cTitulo, cHtmlModelo) 														
oHtml	:= oProcess:oHTML

IF substr(aChave[1],3,1)=='1' //14/09/16
	_cTitulo:="TITULO DE PAGAMENTO ANTECIPADO"
Else
	_cTitulo:="ADIANTAMENTO A FUNCIONARIOS"
Endif                                                    


cDadoTit := aChave[1]+aChave[2]+aChave[3]+aChave[4]+aChave[5]+aChave[6]
DBSelectArea("ZPA")
DBSetOrder(1)
DBSeek(xFilial("ZPA")+cDadoTit)

//Dados do Cabeçalho
oProcess:oHtml:ValByName( "cTitPA" 	,_cTitulo) //14/09/16
oProcess:oHtml:ValByName( "cCabec" 		,cCabec)
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(UsrRetName(ZPA->ZPA_SOLICI)))
oProcess:oHtml:ValByName( "cCodSol" 	,ZPA->ZPA_SOLICI)
oProcess:oHtml:ValByName( "cAprovador" ,Alltrim(UsrRetName(ZPA->ZPA_APROV1)))
oProcess:oHtml:ValByName( "cCodAprov" 	,ZPA->ZPA_APROV1 )
oProcess:oHtml:ValByName( "cTexto" 		,cTexto )

oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
//oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(ZPA->ZPA_NOMFOR))
oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(ZPA->ZPA_NOMFOR)+" ("+ZPA->ZPA_FORNEC+")") //Solicitação de inclusao de código (Sheila Siva) - Chamado 17573
oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(ZPA->ZPA_DTEMIS))
oProcess:oHtml:ValByName( "cPedCom" 	,ALLTRIM(ZPA->ZPA_PEDIDO))
oProcess:oHtml:ValByName( "cDtPagto" 	,DTOC(ZPA->ZPA_VENCTO))
oProcess:oHtml:ValByName( "cValor" 		,Transform(ZPA->ZPA_VALOR,"@E 999,999,999.99"))
oProcess:oHtml:ValByName( "cMotivo" 	,Alltrim(ZPA->ZPA_HIST))
oProcess:oHtml:ValByName( "cPriori" 	,IIF(_lPriori,"URGENTE","Normal")) //10/01/18




//Revisao do Workflow
_cIpTest:=SuperGetMV("AL_IPSRVTS",.f.,"172.28.1.20")
lServTeste := IIf(GetServerIP() == RTRIM(_cIpTest), .T.,.F.)

If !lServTeste //Servidor Produção
	if _lPriori
		oProcess:cSubject := "ALUBAR "+cCabec+" de Pagamento Antecipado (URGENTE)."+DTOC(dDataBase)
	else
		oProcess:cSubject := "ALUBAR "+cCabec+" de Pagamento Antecipado."+DTOC(dDataBase)
	endif
	oProcess:cTo := cDestinat+";"+Alltrim(GetMv("AL_MAILADM")) 
Else //Servidor Base_teste
   	if _lPriori
   		oProcess:cSubject := "TESTE ALUBAR "+cCabec+" de Pagamento Antecipado.(URGENTE)"+DTOC(dDataBase)
	ELSE
		oProcess:cSubject := "TESTE ALUBAR "+cCabec+" de Pagamento Antecipado."+DTOC(dDataBase)
	ENDIF
	oProcess:cTo := Alltrim(GetMv("AL_MAILADM"))
EndIf	
oProcess:Start()                         
oProcess:Finish()

Return()          
            
************************
USER FUNCTION TRCPRPA() //TROCA TITULO PROVISÓRIO PARA PA - 10/08/16
************************
LOCAL aTitulo:={} 
Local oDlgBank
Local oButton1
Local oButton2
Local oFont1 := TFont():New("Arial",,018,,.F.,,,,,.F.,.F.)
Local oGetAG
Local cGetAG := SPACE(5)
Local oGetBCO
Local cGetBCO := Space(6)
Local oGetBenef
Local cGetBenef := Space(30)
Local oGetCC
Local cGetCC := Space(10)
Local oGetHist
Local cGetHist := Space(15)
Local oGetNumChq
Local cGetNumChq := Space(9)
Local oGroup1
Local oPanel1
Local oSayObs
Local cObs
Local oSayAG
Local oSayBCO
Local oSayBen
Local oSayCC
Local oSayChq
Local oSayHist
Local lOk := .F.   
Local cCombo := ""
Local _lExcProv:=.f. 
Local _dDataFin := GetMv("MV_DATAFIN")//10/05/19 - Fabio Yoshioka
Local _aNotSupri:={} //15/07/19
Private lMsErroAuto 	:= .F.
Private lMsHelpAuto 	:= .F.  
Private _cCustPA:=GetMV("AL_CCUSTPA")//10/08/16     
Private _cNatuPA:=GetMV("AL_NATURPA")//10/08/16     
Private _cChvZPA:=ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA
Private _cBcoPadPA:=GetMV("AL_BCPADPA")
Private _cAgePadPA:=GetMV("AL_AGPADPA")
Private _cCCoPadPA:=GetMV("AL_CCPADPA")
Private _cVencProv:="" //15/11/16
Private _cVencReal:="" //15/11/16

IF UPPER(RTRIM(ZPA->ZPA_STATUS))=='X' //Somente depois de passar por todos processos de liberação 

	  cGetBenef:=IIF(!EMPTY(ZPA->ZPA_NOMFOR),ZPA->ZPA_NOMFOR,Space(30))  //15/11/16
	  cGetHist :=IIF(!EMPTY(ZPA->ZPA_HIST ) ,ZPA->ZPA_HIST  ,Space(15))

	  cObs := "OBS: Para cadastrar um PA os dados bancários devem ser preenchidos."
	        
	  DEFINE MSDIALOG oDlgBank TITLE "Dados Bancarios" FROM 000, 000  TO 380, 440 COLORS 0, 16777215 PIXEL

	

	    @ 000, 000 MSPANEL oPanel1 SIZE 220, 190 OF oDlgBank COLORS 0, 14215660 RAISED
	    @ 008, 004 GROUP oGroup1 TO 171, 216 PROMPT " Dados Bancarios do P.A. " OF oPanel1 COLOR 0, 16777215 PIXEL
	    
  		 @ 023, 007 SAY oSay23 PROMPT "Mov. 'Bancaria:" SIZE 065, 011 OF oPanel1 COLORS 0, 16777215 PIXEL	    
       @ 023, 052 MSCOMBOBOX cCombo ITEMS {"SIM","NAO(CNAB)"} SIZE 050, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
	    
	    @ 040, 007 SAY oSayBCO PROMPT "Banco:" SIZE 022, 007 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL 
	    @ 038, 052 MSGET oGetBCO VAR cGetBCO SIZE 032, 012 OF oPanel1 COLORS 0, 16777215 FONT oFont1 PIXEL F3 "SA6" WHEN IIF(RTRIM(cCombo)=="SIM",.T.,.F.)
	    
	    @ 057, 007 SAY oSayAG PROMPT "Agência:" SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL
	    @ 055, 052 MSGET oGetAG VAR cGetAG SIZE 032, 012 OF oPanel1 COLORS 0, 16777215 FONT oFont1 PIXEL WHEN IIF(RTRIM(cCombo)=="SIM",.T.,.F.)
	
	    @ 074, 007 SAY oSayCC PROMPT "Conta:" SIZE 025, 007 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL
	    @ 072, 052 MSGET oGetCC VAR cGetCC SIZE 050, 012 OF oPanel1 COLORS 0, 16777215 FONT oFont1 PIXEL WHEN IIF(RTRIM(cCombo)=="SIM",.T.,.F.)
	
	    @ 089, 007 SAY oSayChq PROMPT "Num Cheque:" SIZE 043, 007 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL 
	    @ 086, 052 MSGET oGetNumChq VAR cGetNumChq SIZE 060, 012 OF oPanel1 COLORS 0, 16777215 FONT oFont1 PIXEL WHEN IIF(RTRIM(cCombo)=="SIM",.T.,.F.)
	
	    @ 104, 007 SAY oSayHist PROMPT "Histórico:" SIZE 030, 007 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL
	    @ 102, 052 MSGET oGetHist VAR cGetHist SIZE 140, 012 OF oPanel1 COLORS 0, 16777215 FONT oFont1 PIXEL WHEN IIF(RTRIM(cCombo)=="SIM",.T.,.F.)
	
	    @ 121, 007 SAY oSayBen PROMPT "Beneficiário:" SIZE 042, 007 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL
	    @ 119, 052 MSGET oGetBenef VAR cGetBenef SIZE 140, 012 OF oPanel1 COLORS 0, 16777215 FONT oFont1 PIXEL WHEN IIF(RTRIM(cCombo)=="SIM",.T.,.F.)
	
	    @ 173, 165 BUTTON oButton1 PROMPT "Sair" SIZE 050, 012 OF oPanel1 PIXEL Action oDlgBank:End()
	    @ 173, 098 BUTTON oButton2 PROMPT "OK" SIZE 050, 012 OF oPanel1 PIXEL Action(lOk := .T., oDlgBank:End()) 
	 
	    @ 134, 009 SAY oSayObs PROMPT cObs SIZE 201, 038 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL
	  ACTIVATE MSDIALOG oDlgBank Centered
	                   
		If lOk
			_lMovbanco:=IIF(RTRIM(cCombo)=="SIM",.T.,.F.)
			
		   IF (_lMovbanco .AND. (Empty(cGetBCO) .or. Empty(cGetAG) .or. Empty(cGetCC) .or. Empty(cGetNumChq) )) //.OR. (!_lMovbanco .AND. (Empty(cGetBCO) .or. Empty(cGetAG) .or. Empty(cGetCC) ))
	     		lOk := .F.
	       Else
	       
	       		if _lMovbanco //19/12/17 - valido a existencia do cheque
	       			dbSelectArea("SEF")
	       			dbSetOrder(1)//EF_FILIAL, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM
	       			If dbSeek(xFilial("SEF")+PADR(cGetBCO,TamSX3("EF_BANCO")[1])+PADR(cGetAG,TamSX3("EF_AGENCIA")[1])+PADR(cGetCC,TamSX3("EF_CONTA")[1])+PADR(cGetNumChq,TamSX3("EF_NUM")[1]))
	       				Help(" ",1,"FA050CHEQ")
	       				lOk := .F.
	       			Endif
	       		Endif
	     	
	     	
	       		if lOk
		     		DBSelectArea("ZPA")
		     		DBSetOrder(1)
					If DBSeek(xFilial("ZPA")+_cChvZPA,.F.)//15/12/17
						While !RecLock("ZPA",.F.); EndDo
						
						if _lMovbanco
							ZPA->ZPA_BANCO		:= cGetBCO
							ZPA->ZPA_AGENC		:= cGetAG
							ZPA->ZPA_CONTA		:= cGetCC
							ZPA->ZPA_NUMCHQ		:= cGetNumChq
							ZPA->ZPA_HISTCH		:= cGetHist
							ZPA->ZPA_BENEF		:= cGetBenef  
						else
							ZPA->ZPA_BANCO		:= _cBcoPadPA
							ZPA->ZPA_AGENC		:= _cAgePadPA
							ZPA->ZPA_CONTA		:= _cCCoPadPA
						endif
						IF ZPA->(FieldPos("ZPA_DTPGTO")) > 0 
							ZPA->ZPA_DTPGTO		:= dDatabase // 26/03/18 - Solicitação Financeiro
						endif
													
						ZPA->(MSUnlock())
	 				ENDIF
 				endif	
	  			
				/*DBSelectARea("ZPA") //Atualizo dados bancários 
				RecLock("ZPA",.F.)  
				if _lMovbanco
					ZPA->ZPA_BANCO		:= cGetBCO
					ZPA->ZPA_AGENC		:= cGetAG
					ZPA->ZPA_CONTA		:= cGetCC
					ZPA->ZPA_NUMCHQ		:= cGetNumChq
					ZPA->ZPA_HISTCH		:= cGetHist
					ZPA->ZPA_BENEF		:= cGetBenef  
				else
					ZPA->ZPA_BANCO		:= _cBcoPadPA
					ZPA->ZPA_AGENC		:= _cAgePadPA
					ZPA->ZPA_CONTA		:= _cCCoPadPA
				endif
				ZPA->(MSUnlock())*/
				  
			EndIf
		
		EndIf
	
	If lOk
	
	  	MudaConf(_lMovbanco)//altero a configuração do _aCfgSx1 conforme oção definida pelo usuario		
		
		_aDadSx1:=LeitSX1("FIN050",_aCfgSx1) //Guardo configuração original do SX1 e atualizo SX1

		if _nLockSx1==4 
		
		  	AltPfSx1(_cUsuar,_aDadSx1,_aCfgSx1)//atualizo Profile do usuario		
		  	
		  	
		  	//Consulto título provisório - devido a alteração de data de vencimento - 15/11/16
			_cQrySE2:=" SELECT E2_VENCTO,E2_VENCREA from "+RETSQLNAME("SE2")+" WHERE "
			_cQrySE2+=" E2_FILIAL='"+XFILIAL("SE2")+"'"
			_cQrySE2+=" AND E2_PREFIXO='"+RTRIM(ZPA->ZPA_PREFIX)+"'"
			_cQrySE2+=" AND E2_NUM='"+RTRIM(ZPA->ZPA_NUM)+"'"
			_cQrySE2+=" AND E2_PARCELA='"+ZPA->ZPA_PARCEL+"'"
			_cQrySE2+=" AND E2_FORNECE='"+RTRIM(ZPA->ZPA_FORNEC)+"'"
			_cQrySE2+=" AND E2_TIPO='PR'"
			_cQrySE2+=" AND D_E_L_E_T_<>'*'"		  	
			DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySE2), "TPRV", .F., .T.) 
			IF !TPRV->(EOF()) .AND. !TPRV->(BOF())
				_cVencProv:=TPRV->E2_VENCTO 
				_cVencReal:=TPRV->E2_VENCREA
			ENDIF            
			TPRV->(DBCLOSEAREA())     
			
			IF EMPTY(ALLTRIM(_cVencProv))
				_cVencProv:=DTOS(ZPA->ZPA_VENCTO)
			ENDIF

			IF EMPTY(ALLTRIM(_cVencReal))
				_cVencReal:=DTOC(ZPA->ZPA_VENCTO)						
			ENDIF
			
			
			//Incluido validação de data de fechamento para nao gerar erros  na geração da PA - chamado 25210
			if  stod(_cVencProv) <= _dDataFin
				Alert("Data de vencimento ("+dtoc(stod(_cVencProv))+") do titulo provisório está em periodo financeiro já fechado ("+dtoc(_dDataFin)+")!")
				return
			endif
			
			
			 if stod(_cVencReal) <= _dDataFin
			 	Alert("Data de vencimento real ("+dtoc(stod(_cVencReal))+") do titulo provisório está em periodo financeiro já fechado ("+dtoc(_dDataFin)+") !")
			 	return
			 endif
			
							 
			  	           
			//Excluo o título provisório
			aTitulo:={}
			aTitulo := { { "E2_PREFIXO"  , ZPA->ZPA_PREFIX  , NIL },;
			   	        { "E2_NUM"      , ZPA->ZPA_NUM       , NIL },;
	  	  	  		        { "E2_TIPO"     , "PR"               , NIL },;
	  	  	      		  { "E2_NATUREZ"  , _cNatuPA           , NIL },;
			  	   	     { "E2_FORNECE"  , ZPA->ZPA_FORNEC    , NIL },;
			  	   	     { "E2_LOJA"     , ZPA->ZPA_LOJA      , NIL },;		  	   	     
	  	   		   	  { "E2_EMISSAO"  , ZPA->ZPA_DTEMIS		, NIL },;
				           { "E2_VENCTO"   , stod(_cVencProv)	, NIL },;
	  	         	     { "E2_VENCREA"  , stod(_cVencReal)	, NIL },;
			  	           { "E2_VALOR"    , ZPA->ZPA_VALOR     , NIL } }  
			
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,5) //EXCLUO TITULO PROVISÓRIO
	
			If lMsErroAuto                
			 	ALERT('Problemas para excluir título provisório')
			 	Mostraerro()
			else
				_lExcProv:=.T.
	  		Endif       
	
			if _lExcProv
		
				aTitulo :={}		
			  /*	aTitulo :={	{"E2_FILIAL"	,xFilial("ZPA")		,Nil},;
						{"E2_PREFIXO"		,ZPA->ZPA_PREFIX 		,Nil},;
			   		{"E2_NUM"      	,ZPA->ZPA_NUM			,Nil},;
			        	{"E2_PARCELA"  	,ZPA->ZPA_PARCEL		,Nil},;
			         {"E2_TIPO"     	,'PA'						,Nil},;               
			         {"E2_NATUREZ"  	,_cNatuPA				,Nil},;
			         {"E2_FORNECE"  	,ZPA->ZPA_FORNEC		,Nil},; 
			         {"E2_LOJA"     	,ZPA->ZPA_LOJA			,Nil},;      
			         {"E2_EMISSAO"  	,ZPA->ZPA_DTEMIS		,NIL},;
			         {"E2_VENCTO"   	,STOD(_cVencProv)		,NIL},;                          
			    		{"E2_VENCREA"  	,STOD(_cVencReal)		,NIL},;                                                   
			        	{"E2_VALOR"    	,ZPA->ZPA_VALOR		,Nil},;
			       	{"E2_VLCRUZ"		,ZPA->ZPA_VALOR		,Nil},;
			        	{"E2_CC"     		,_cCustPA				,Nil},;
			        	{"E2_STATWF" 		,"LB"						,Nil},;
			        	{"E2_HIST"   		,"PA Ref. Ped. "+ZPA->ZPA_PEDIDO ,Nil},;
			        	{"E2_INSTRPA"  	,ZPA->ZPA_HIST			,Nil},;
			        	{"AUTBANCO"			,ZPA->ZPA_BANCO		,NIL},;
						{"AUTAGENCIA"		,ZPA->ZPA_AGENC		,NIL},;
						{"AUTCONTA"			,ZPA->ZPA_CONTA		,NIL},;
						{"AUTCHEQUE"		,ZPA->ZPA_NUMCHQ		,NIL}}      */  
						
				//alterada a geração da PA - Data de emissao com a data do vencimento (tabela ZPA) 
				//para evitar problemas de geração titulos de PA com periodo já fechada (ZPA_EMISSAO) - 11/01/17
				//18/12/18 - Fabio Yoshioka - Inclusao de Gravação do Campo E2_PZENNF - Chamado 21705
			  	aTitulo :={	{"E2_FILIAL"	,xFilial("ZPA")		,Nil},;
						{"E2_PREFIXO"	,ZPA->ZPA_PREFIX 		,Nil},;
						{"E2_NUM"      	,ZPA->ZPA_NUM			,Nil},;
			        	{"E2_PARCELA"  	,ZPA->ZPA_PARCEL		,Nil},;
			        	{"E2_TIPO"     	,'PA'					,Nil},;               
			        	{"E2_NATUREZ"  	,_cNatuPA				,Nil},;
			        	{"E2_FORNECE"  	,ZPA->ZPA_FORNEC		,Nil},; 
			        	{"E2_LOJA"     	,ZPA->ZPA_LOJA			,Nil},;      
			        	{"E2_EMISSAO"  	,STOD(_cVencProv)		,NIL},;
			        	{"E2_VENCTO"   	,STOD(_cVencProv)		,NIL},;                          
			    		{"E2_VENCREA"  	,STOD(_cVencReal)		,NIL},;                                                   
			        	{"E2_VALOR"    	,ZPA->ZPA_VALOR			,Nil},;
			        	{"E2_VLCRUZ"	,ZPA->ZPA_VALOR			,Nil},;
			        	{"E2_CC"    	,_cCustPA				,Nil},;
			        	{"E2_STATWF"	,"LB"					,Nil},;
			        	{"E2_HIST"  	,IIF(_lSolFin,ZPA->ZPA_HIST,"PA Ref. Ped. "+ZPA->ZPA_PEDIDO) ,Nil},;
			        	{"E2_INSTRPA"  	,ZPA->ZPA_HIST			,Nil},;
			        	{"E2_DIGBARR" 	,iif(ZPA->(FieldPos("ZPA_DIGBAR"))>0,ZPA->ZPA_DIGBAR,""),Nil},;
			        	{"E2_CODBAR" 	,iif(ZPA->(FieldPos("ZPA_DIGBAR"))>0,ZPA->ZPA_DIGBAR,""),Nil},;
			        	{"E2_PZENNF"	,ZPA->ZPA_PZENNF		,Nil},;
			        	{"AUTBANCO"		,ZPA->ZPA_BANCO			,NIL},;
						{"AUTAGENCIA"	,ZPA->ZPA_AGENC			,NIL},;
						{"AUTCONTA"		,ZPA->ZPA_CONTA			,NIL},;
						{"AUTCHEQUE"	,ZPA->ZPA_NUMCHQ		,NIL}}      
		        	
			           		
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //INCLUO A PA
				
				If lMsErroAuto                
				 	Mostraerro()
				  
				 	// recrio o título provisório
				 	//18/12/18 - Fabio Yoshioka - Inclusao de Gravação do Campo E2_PZENNF - Chamado 21705
					aTitulo := {}
					aTitulo :={	{"E2_FILIAL"	,xFilial("ZPA")			,Nil},;
								{"E2_PREFIXO"	,ZPA->ZPA_PREFIX 		,Nil},;
								{"E2_NUM"      	,ZPA->ZPA_NUM			,Nil},;
					        	{"E2_PARCELA"  	,ZPA->ZPA_PARCEL		,Nil},;
					        	{"E2_TIPO"     	,'PR'					,Nil},;               
					        	{"E2_NATUREZ"  	,ZPA->ZPA_NATURE		,Nil},;
					        	{"E2_FORNECE"  	,ZPA->ZPA_FORNEC		,Nil},; 
					        	{"E2_LOJA"     	,ZPA->ZPA_LOJA			,Nil},;      
					        	{"E2_EMISSAO"  	,ZPA->ZPA_DTEMIS		,NIL},;
					        	{"E2_VENCTO"   	,STOD(_cVencProv)		,NIL},;                          
					    		{"E2_VENCREA"  	,STOD(_cVencReal)		,NIL},;                                                   
					        	{"E2_VALOR"    	,ZPA->ZPA_VALOR			,Nil},;
					        	{"E2_VLCRUZ"	,ZPA->ZPA_VALOR			,Nil},; 
								{"E2_HIST"		,ZPA->ZPA_HIST			,Nil},; 			       	
					        	{"E2_STATWF" 	,"LB"					,Nil},;
					        	{"E2_PZENNF"	,ZPA->ZPA_PZENNF		,Nil},;
					        	{"E2_CC"     	,_cCustPA				,Nil}}
				
					*****************************	
					//Inicio a inclusão do titulo
					*****************************	
					lMsErroAuto := .F.
					Conout("Executando EXECAUTO "+ZPA->ZPA_NUM)
					MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao  
								
					If lMsErroAuto                
						//Caso encontre erro, mostre
					 	Mostraerro()               
					ENDIF
								
								
					DBSelectArea("ZPA")
					DBSetOrder(1)
					If DBSeek(xFilial("ZPA")+_cChvZPA,.F.)
						RecLock("ZPA",.F.)
						IF STOD(_cVencReal)<>ZPA->ZPA_VENCTO //ATUALIZO CASO SEJA ALTERADO O VENCIMENTO DO PROVISÓRIO - 15/11/16
							ZPA->ZPA_VENCTO:=STOD(_cVencReal)							
						ENDIF
													
						ZPA->(MSUnlock())
 					ENDIF
 					
				Else    
			
					DBSelectArea("ZPA")
					DBSetOrder(1)
					If DBSeek(xFilial("ZPA")+_cChvZPA,.F.)
						RecLock("ZPA",.F.)
							ZPA->ZPA_STATUS := 'Z'
							ZPA->ZPA_TIPO := 'PA' //MUDO TIPO PARA PA
							
							IF STOD(_cVencReal)<>ZPA->ZPA_VENCTO //ATUALIZO CASO SEJA ALTERADO O VENCIMENTO DO PROVISÓRIO - 15/11/16
								ZPA->ZPA_VENCTO:=STOD(_cVencReal)							
							ENDIF
													
						ZPA->(MSUnlock())
						
						//_lPaFunc:=IIF(RTRIM(ZPA->ZPA_PREFIX)=='PA2',.T.,.F.)
						_lPaFunc:=IIF(RTRIM(ZPA->ZPA_PREFIX)=='GVI',.T.,.F.) //30/11/16
												
						IF _lPaFunc //19/10/16 
							DBSelectArea("ZV1") //ATUALIZO STATUS DO ZV1
							DBSetOrder(1)
							IF ZV1->(DBSeek(xFilial("ZV1")+STRZERO(VAL(ZPA->ZPA_NUM),6)+'001'))
								Reclock("ZV1",.F.)
								ZV1->ZV1_STATUS := 'B'  
								ZV1_PREFIX      := ZPA->ZPA_PREFIX   //01/12/16
								ZV1_NUMPA       := ZPA->ZPA_NUM
								ZV1_PARCEL      := ZPA->ZPA_PARCEL
								ZV1_EMISPA      := ZPA->ZPA_DTEMIS
								ZV1->(MSUnlock())
							ENDIF
						ELSE //04/04/17 - FABIO YOSHIOKA - GRAVAÇÃO DE RELACIONAMENTO DO PEDIDO X PA 					
						    _aRecnoSE2PA:={}
			             Aadd(_aRecnoSE2PA ,{ZPA->ZPA_PEDIDO,SE2->(Recno()),SE2->E2_VALOR})
							If Len(_aRecnoSE2PA) > 0    
								FPedAdtGrv("P", 1, ZPA->ZPA_PEDIDO, _aRecnoSE2PA)
							EndIf
						ENDIF    
						
					ENDIF
					
					ALERT('PA INCLUIDA COM SUCESSO')

					//15/07/19  Projeto 1.01.03.03 – Notificação de Pagamento Antecipado a Fornecedores - Fabio Yoshioka	

					aAdd(_aNotSupri,ZPA->ZPA_PREFIX)  	//01
					aAdd(_aNotSupri,ZPA->ZPA_NUM)		//02
					aAdd(_aNotSupri,ZPA->ZPA_PARCEL)    //03
					aAdd(_aNotSupri,ZPA->ZPA_TIPO)      //04
					aAdd(_aNotSupri,ZPA->ZPA_FORNEC)    //05
					aAdd(_aNotSupri,ZPA->ZPA_LOJA)      //06					
					aadd(_aNotSupri,ZPA->ZPA_DTEMIS)	
					aadd(_aNotSupri,Alltrim(ZPA->ZPA_NOMESO))
					aadd(_aNotSupri,ZPA->ZPA_SOLICI)				
					aadd(_aNotSupri,Alltrim(ZPA->ZPA_NOMFOR)+" ("+ZPA->ZPA_FORNEC+")")
					aadd(_aNotSupri,ZPA->ZPA_VALOR) 
					aadd(_aNotSupri,ZPA->ZPA_HIST)					
					aadd(_aNotSupri,ZPA->ZPA_PZENNF)
					aadd(_aNotSupri,ZPA->ZPA_PEDIDO)	
					aadd(_aNotSupri,ZPA_PRIORI)
					aadd(_aNotSupri,ZPA->ZPA_VENCTO)
					aadd(_aNotSupri,_cUsuar)
					
					  
					MsgRun("Enviando Notificação ao Suprimentos, Aguarde...",,{|| NotifSup(_aNotSupri)}) 
				
				Endif
			
			EndiF
		
		ELSE                                                                
		
			ALERT('Não foi possivel atualizar o arquivo de perguntas (FIN050)!')		
		
		ENDIF
		
		MudaConf(.T.)//altero a configuração do _aCfgSx1 conforme oção definida pelo usuario		
		
		_aSx1Mod:=LeitSX1("FIN050",_aCfgSx1) //Guardo configuração original do SX1 e atualizo SX1
		
	  	AltPfSx1(_cUsuar,_aDadSx1,{}) //retorno profile original		
		
	ELSE
		MSGALERT(" Dados bancarios incompletos!" )	
	ENDIF
ELSE
	MSGALERT(" Status do registro não permite a geração de PA!" )
ENDIF
RETURN    
              
*********************************************************
User Function AltStPA(_cChvPa,_cNewId,_cCodapv,_cNomApv) //18/08/16
*********************************************************
Local _lAtuSt:=.T. //IMPEDIR ATUALIZAÇÕES DE STATUS CASO PA JÁ TENHA SIDO VISTADA ANTERIORMENTE - FABIO YOSHIOKA - 10/04/18 

/*
	AADD(aCorZPA,{ "ZPA_STATUS == 'B'", "BR_VERMELHO"  })	//Bloqueda  
	AADD(aCorZPA,{ "ZPA_STATUS == 'W'", "BR_AMARELO" 	})	//Email Enviado(AGUARDANDO WF)
	AADD(aCorZPA,{ "ZPA_STATUS == 'L'", "BR_LARANJA"	})	//LIBERADO COMPRAS 
	AADD(aCorZPA,{ "ZPA_STATUS == 'V'", "BR_AZUL" 		}) //VISTADA FINANCEIRO
	AADD(aCorZPA,{ "ZPA_STATUS == 'X'", "BR_VERDE" 		}) //Liberada FINANCEIRO							
	AADD(aCorZPA,{ "ZPA_STATUS == 'Z'", "BR_BRANCO" 	})	//PA GERADA
	AADD(aCorZPA,{ "ZPA_STATUS == 'R'", "BR_PRETO" 		})	//Rejeitada		
	
	
AADD(aCorZV1,{"ZV1_STATUS == '1' ","BR_AMARELO"	})	//ENVIADO PARA APROVAÇÃO DO SETOR (GERENCIA)
AADD(aCorZV1,{"ZV1_STATUS == '2' ","BR_LARANJA"})	//LIBERADO PELO SETOR (GERENCIA)
AADD(aCorZV1,{"ZV1_STATUS == 'A' ","BR_AZUL"})		//VISTADO PELO FINANCEIRO      
AADD(aCorZV1,{"ZV1_STATUS == '3' ","BR_VERDE"})		//APROVADO PELO FINANCEIRO
AADD(aCorZV1,{"ZV1_STATUS == 'B' ","BR_BRANCO"})	//PA GERADA
AADD(aCorZV1,{"ZV1_STATUS == '0' ","BR_PINK"})		//P. Contas Gravada
AADD(aCorZV1,{"ZV1_STATUS == '4' ","BR_VERMELHO"})	//P. Contas em análise nivel 1
AADD(aCorZV1,{"ZV1_STATUS == '5' ","BR_MARROM"})	//P. Contas em análise nivel 2
AADD(aCorZV1,{"ZV1_STATUS == '6' ","BR_VIOLETA"})	//P. Contas aprovada/Tit gerado
AADD(aCorZV1,{"ZV1_STATUS == '7' ","DISABLE"})		//Viagem Encerrada e Compensada
AADD(aCorZV1,{"ZV1_STATUS == '8' ","BR_PRETO"})		//Adiantamento Rejeitado/Viagem Cancelada
AADD(aCorZV1,{"ZV1_STATUS == '9' ","BR_CINZA"})		//P. Contas Rejeitada 
	
	
*/
Local _lPaFunc:=.F.
Local _cNumZPA2:=""
Local _aAreaAnt := GetArea()  
Local _cCpo1:="ZPA->ZPA_APROV"+iif(RTRIM(_cNewId)=='L','1',IIF(RTRIM(_cNewId)=='V','2','3'))
Local _cCpo2:="ZPA->ZPA_NAPRO"+iif(RTRIM(_cNewId)=='L','1',IIF(RTRIM(_cNewId)=='V','2','3')) 
Local _cCpo3:="ZPA->ZPA_DTAPR"+iif(RTRIM(_cNewId)=='L','1',IIF(RTRIM(_cNewId)=='V','2','3')) 
Local _cCpo4:="ZPA->ZPA_HRAPR"+iif(RTRIM(_cNewId)=='L','1',IIF(RTRIM(_cNewId)=='V','2','3')) 
Local _cCpo5:="ZV1_APROV"+iif(RTRIM(_cNewId)=='L','1',IIF(RTRIM(_cNewId)=='V','2','3')) //19/10/16
Local _cCpo6:="ZV1_NAPRO"+iif(RTRIM(_cNewId)=='L','1',IIF(RTRIM(_cNewId)=='V','2','3'))
Local _cCpo7:="ZV1_DTAPR"+iif(RTRIM(_cNewId)=='L','1',IIF(RTRIM(_cNewId)=='V','2','3'))
Local _cCpo8:="ZV1_HRAPR"+iif(RTRIM(_cNewId)=='L','1',IIF(RTRIM(_cNewId)=='V','2','3'))
Local _cStatusZV1:=iif(RTRIM(_cNewId)=='L','2',IIF(RTRIM(_cNewId)=='V','A','3'))

DBSelectArea("ZPA")
DBSetOrder(1)
	If DBSeek(_cChvPa,.F.)  
		IF RTRIM(_cNewId)=='V' .AND. ZPA->ZPA_STATUS $ 'X/Z' //10/04/18 -  FABIO YOSHIOKA - IMPEDIMENTO DE ATUALIZAR PARA VISTO CASO JÁ TENHA SIDO LIBERADO
			_lAtuSt:=.F.
		ENDIF
		
		IF _lAtuSt //10/04/18 -  FABIO YOSHIOKA
			Reclock("ZPA",.F.) 
			ZPA->ZPA_STATUS := _cNewId
			&_cCpo1 := _cCodapv
			&_cCpo2 := _cNomApv
			&_cCpo3 := dDatabase
			&_cCpo4 := SubStr(Time(),1,5)		
			//_lPaFunc:=IIF(RTRIM(ZPA->ZPA_PREFIX)=='PA2',.T.,.F.)
			_lPaFunc:=IIF(RTRIM(ZPA->ZPA_PREFIX)=='GVI',.T.,.F.) //30/11/16
			_cNumZPA2:=ZPA->ZPA_NUM
			ZPA->(MSUnlock())
		ENDIF   
	ENDIF            
	
	IF _lPaFunc //30/09/16 - FAZER LOOP?
		DBSelectArea("ZV1")//ATUALIZAÇÃO DA TABELA DO GERSTAO DE VIAGENS QUANDO HOUVER A APROVAÇÃO PELO FINANCEIRO
		DBSetOrder(1)
		IF ZV1->(DBSeek(xFilial("ZV1")+STRZERO(VAL(_cNumZPA2),6)+'001'))
			Reclock("ZV1",.F.)
			&_cCpo5:=_cCodapv
			&_cCpo6:=_cNomApv
			&_cCpo7:=Date()
			&_cCpo8:=SubStr(Time(),1,5)
			ZV1->ZV1_STATUS := _cStatusZV1
			MSUnlock()       
		ENDIF
	ENDIF
	
	
RestArea(_aAreaAnt)
Return   

**************************
Static Function RetMenu() //Define o menu conforme as opções cadastradas na tabela de ALÇADAS
**************************
Local _aMenu:={}       
Local _ndep:=0
_lSolCom:=.f.   
_lSolFin:=.f.


For _ndep:=1 to 2
	_cQry:=" SELECT AI_USER FROM "+Retsqlname("SAI")+","+Retsqlname("SAL")
	_cQry+=" WHERE "+Retsqlname("SAL")+".D_E_L_E_T_<>'*'"
	_cQry+="  AND "+Retsqlname("SAI")+".D_E_L_E_T_<>'*'"
	_cQry+="  AND AI_FILIAL='"+xFilial("SAI")+"'"
	_cQry+="  AND AL_FILIAL='"+xFilial("SAL")+"'"
	_cQry+="  AND AL_COD=AI_GRPAPRO "
	_cQry+="  AND AL_COD='"+iif(_ndep==1,rtrim(_cGrpCom),rtrim(_cGrpFin))+"'" 
	_cQry+="  AND AI_USER='"+rtrim(_cUsuar)+"'"
	_cQry+="  AND AL_STATUS<>'D'"
	DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "TCOMP", .F., .T.) 
	IF !TCOMP->(EOF()) .AND. !TCOMP->(BOF())
		if _ndep==1
			_lSolCom:=.T. //IDENTIFICA QUE O USUARIO POSSUI CONTROLE DE ALÇADAS DO COMPRAS -> LIBERA ACESSO PARA PARA INCLUIR SOLICITAÇÃO DE INCLUSAO DE PA
		endif
		
		if _ndep==2
			_lSolFin:=.T. //IDENTIFICA QUE O USUARIO POSSUI CONTROLE DE ALÇADAS DO COMPRAS -> LIBERA ACESSO PARA PARA GERAR PA (SETOR FINANCEIRO)
		endif
		
	ENDIF      
	TCOMP->(DBCLOSEAREA())
Next _ndep

if _lSolFin //18/08/17
	_cModulo:="FIN"
else
	IF _lSolCom
		_cModulo:="COM"
	ENDIF
endif
	
      		
AADD(_aMenu,{ "Pesquisar"   		,"AxPesqui" 							  			, 0, 1})
AADD(_aMenu,{ "Visualizar" 		,"AxVisual"                         		  			, 0 ,2})
//AADD(_aMenu,{ "PA Funcionarios"	,"U_AxIncZPA(_cAlias,RecNo(),'2')" 						, 0, 3})  

IF _lSolCom
	AADD(_aMenu,{ "PA Fornecedores"	,"U_AxIncZPA(_cAlias,RecNo(),'1')" 				, 0, 3})
	AADD(_aMenu,{ "Excluir PA"	,"U_AxExcZPA(_cAlias,RecNo(),'1')" 						, 0, 5})	 //13/01/17
	AADD(_aMenu,{ "Imprimir PA"	,"U_RelZPA()" 												, 0, 7})	 //10/05/17  - FABIO YOSHIOKA - IMPRESSAO DA PA
	AADD(_aMenu,{ "Comprovante Pagamento "	,"U_ImpPAPAG()" 												, 0, 7})	 //13/03/18  - FABIO YOSHIOKA - COMPROVANTE SISPAG	
ENDIF                                                                                                                    	

IF _lSolFin  //24/01/18
	AADD(_aMenu,{ "Gera PA"	      	,'ExecBlock("TRCPRPA" ,.F.,.F.)' 			  			, 0, 6})
	
	IF _lVisAllReg    //20/08/17 - INCLUSAO DE OPÇÃO DE INCLUIR PA PELO SETOR FINANCEIRO
		AADD(_aMenu,{ "PA Fornecedores"	,"U_AxIncZPA(_cAlias,RecNo(),'1')" 				, 0, 3})
		AADD(_aMenu,{ "Excluir PA"	,"U_AxExcZPA(_cAlias,RecNo(),'1')" 						, 0, 5})	 //07/12/17
		AADD(_aMenu,{ "Devoluçao PA"	,"U_DevolZPA(_cAlias,RecNo(),'1')" 						, 0, 8})	 //11/12/17
	ENDIF
	AADD(_aMenu,{ "Comprovante Pagamento "	,"U_ImpPAPAG()" 												, 0, 7})	 //13/03/18  - FABIO YOSHIOKA - COMPROVANTE SISPAG
	//AADD(_aMenu,{ "Reenv Apv Fin "	,"U_ENVWFFIPA()" 												, 0, 7})	 //18/05/19  - FABIO YOSHIOKA - APROVAÇÃO FINANCEIRO
	AADD(_aMenu,{ "Reenv Apv Fin "	,"U_EnvVisFin(ZPA->ZPA_FILIAL+ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA,ZPA->ZPA_NOMESO )" 												, 0, 7})	 //23/05/19  - FABIO YOSHIOKA - APROVAÇÃO FINANCEIRO
	
		
ENDIF

AADD(_aMenu,{ "Reenviar WF"	   ,'ExecBlock("StartWFPA" ,.F.,.F.)' 			  			, 0, 7})
AADD(_aMenu,{ "Legenda" 			,'ExecBlock("ZPALegenda",.F.,.F.)' 			  			, 0, 6})     
//AADD(_aMenu,{ "Excluir"     		,"AxDeleta"											  			, 0, 5})

Return _aMenu

***************************************************
User Function AxIncZPA(_cAliaszpa,_nRecZPA,_cIdPA)
*************************************************** 
Local _lPAdoFin:= iif(upper(RTRIM(_cModulo))=='FIN' .AND. _lVisAllReg,.T.,.F.) //20/08/17
Local _lImpFichP:=GetMV("AL_IMPFPGT")//07/12/17 - IMPRIME FICHA DE PAGAMENTO APÓS INLUSAO DO TITULO PA - FABIO YOSHIOKA
Local _cLinDig:= "" //space(TamSX3("ZPA_DIGBAR")[1])//10/01/18
	
	_cTipoPA:=_cIdPA       

	
	IF !_lPaFunc .AND. RTRIM(_cTipoPA)=='2'
		MsgAlert("Inclusao de PA Funcionarios  não habilitado para uso! (AL_PAFUNC)") 	
		RETURN	
	ENDIF
	
	
	IF _lPAdoFin //20/08/17
		If !MSGYESNO("A inclusao deste PA não gerará vinculo com pedidos  de compras "+chr(13)+"nem a geração de workflow para autorização deste setor. Deseja prosseguir?","PA do Financeiro") 	
			RETURN
		EndIf	
	ENDIF
	
	
	//AxInclui(_cAlias,RecNo(),3,,,,'U_COKINCPA()')	         
	
	_nRetInc:=AxInclui(_cAlias,RecNo(),3,,,,'U_COKINCPA()')	

	if _nRetInc	==1
		
		IF ZPA->(FieldPos("ZPA_MODULO")) > 0 //12/09/17 - Fábio Yoshioka
			IF !EMPTY(ALLTRIM(_cModulo))
				RecLock("ZPA",.F.)
				ZPA->ZPA_MODULO := _cModulo //18/08/17                  
				MSUnlock()
			ENDIF
		ENDIF
		
		if _lPAdoFin //20/08/17 - geração de provisório
			//realizo a gravação do código de barras - 10/01/18
			 
			 IF ZPA->(FieldPos("ZPA_DIGBAR")) > 0 //12/09/17 - Fábio Yoshioka
			 	IF _lIsBoleto
				 	_cLinDig:=space(TamSX3("ZPA_DIGBAR")[1])
				 	
			 		DEFINE MSDIALOG _oDlgDigBar TITLE "Informe Linha digitavel" FROM 000, 000  TO 120, 470 COLORS 0, 16777215 PIXEL
			 		@ 001, 002 MSGET _oGetLinDig VAR _cLinDig SIZE 200, 012 
			 		@ 003, 020 BUTTON oButton2 PROMPT "OK" SIZE 050, 012 Action _oDlgDigBar:End()
			 		ACTIVATE MSDIALOG _oDlgDigBar Centered
			 		
			 		if !empty(alltrim(_cLinDig))
			 			RecLock("ZPA",.F.)
			 			ZPA->ZPA_DIGBAR := _cLinDig                
			 			MSUnlock()			 		
			 		endif
				 	
				 ENDIF
			 Endif
		
			MsgRun("Gerando Título Provisorio, Aguarde...",,{|| U_GeraPRFin()})
			
			IF _lImpFichP //07/12/17
				U_FIN301R()
			ENDIF
		
		else //10/01/18 - Fabio Yoshioka
			If MSGYESNO("Deseja imprimir ?(S/N)","Impressão de PA")	
				U_RelZPA()//15/05/17 
			Endif	
		endif

		
	endif
	
Return                        


***************************************************
User Function AxExcZPA(_cAliaszpa,_nRecZPA,_cIdPA) //Criação de opção para exclusão da PA pelo solicitante - 13/01/17
*************************************************** 
	Local _cInfHist:=space(200) 
	Local _aDestExc:={}       
	Local _cNotfExc:=""
	Local _lGerWF:=.T.
	Local _nExc := 0
	Local _nDst := 0
	_cTipoPA:=_cIdPA
	
	if RTRIM(_cTipoPA)=='2' .OR. RTRIM(ZPA->ZPA_STATUS)=='Z'
		MsgAlert("Não é permitido a exclusão desse registro!") 	
		RETURN	
	ENDIF 
	
	//13/03/18 - Fabio Yoshioka
	DBSelectArea("SE2")
	DBSetOrder(1)
	If DBSeek(xFilial("SE2")+ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+padr('PA',3)+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA)
		MsgAlert("Registro de PA já gerado no Contas a Pagar! Exclusao não permitida!") 	
		RETURN	
	ENDIF
	
	
	//Informar motivo para histórico   
  	DEFINE MSDIALOG _oDlgExc TITLE "Informe Motivo da Exclusão" FROM 000, 000  TO 120, 470 COLORS 0, 16777215 PIXEL
   @ 001, 002 MSGET _oGetHist VAR _cInfHist SIZE 200, 012 
   @ 003, 020 BUTTON oButton2 PROMPT "OK" SIZE 050, 012 Action _oDlgExc:End()
	ACTIVATE MSDIALOG _oDlgExc Centered
                                      
	
	if !empty(alltrim(_cInfHist)) 
	
		IF RTRIM(ZPA->ZPA_STATUS) == 'R' //CASO SEJA REJEITADA - NÃO ENVIO WF
			_lGerWF:=.F.
		ENDIF
		
		
		DBSelectARea("ZPA")  
		RecLock("ZPA",.F.)
		ZPA->ZPA_EXHIST := UPPER(_cInfHist)
		ZPA->(MSUnlock())
	
		_nRetDel:=AxDeleta(_cAlias ,RecNo(),5)	
	
		if _nRetDel==2 //confirmação da exclusão
			_aChavExc:={}
			_cNotfExc:=""		
			aAdd(_aChavExc, ZPA->ZPA_PREFIX)                                   
			aAdd(_aChavExc, ZPA->ZPA_NUM)                                   
			aAdd(_aChavExc, ZPA->ZPA_PARCEL)                                   
			aAdd(_aChavExc, ZPA->ZPA_TIPO)
			aAdd(_aChavExc, ZPA->ZPA_FORNEC)                                   
			aAdd(_aChavExc, ZPA->ZPA_LOJA)
			
			//Dados para WorkFlow			
			aAdd(_aChavExc, Alltrim(UsrRetName(ZPA->ZPA_SOLICI)))
			aAdd(_aChavExc, ZPA->ZPA_SOLICI)
			aAdd(_aChavExc, Alltrim(UsrRetName(ZPA->ZPA_APROV1)))
			aAdd(_aChavExc, Alltrim(ZPA->ZPA_NOMFOR))
			aAdd(_aChavExc, DTOC(ZPA->ZPA_DTEMIS))
			aAdd(_aChavExc, DTOC(ZPA->ZPA_VENCTO))
			aAdd(_aChavExc, Transform(ZPA->ZPA_VALOR,"@E 999,999,999.99"))
			aAdd(_aChavExc, Alltrim(ZPA->ZPA_EXHIST))
			
			
			For _nExc:=1 to 3
				_cStrExc:="ZPA->ZPA_APROV"+Alltrim(str(_nExc))
				if Ascan(_aDestExc, rtrim(&_cStrExc))==0
					aadd(_aDestExc,rtrim(&_cStrExc))
				endif
			Next _nExc            
			
			if Ascan(_aDestExc, rtrim(ZPA->ZPA_SOLICI))==0 //18/01/17 - ADCIONO SOLICITANTE
				aadd(_aDestExc,rtrim(ZPA->ZPA_SOLICI))
			endif

                        
			For _nDst:=1 to len(_aDestExc)
				_cNotfExc+=UsrRetMail(_aDestExc[_nDst])+";"			
			Next _nDst

			//enviar WF de  notificação   		
			if len(_aChavExc)>0 .and. !empty(alltrim(_cNotfExc)) .AND. _lGerWF
				ZPANotExc(_aChavExc,_cNotfExc)		
			endif

			//excluir informaçãoes no ctas a pagar 	
			//Excluo o título provisório
			_cSE2Tit := _aChavExc[1]+_aChavExc[2]+_aChavExc[3]+_aChavExc[4]+_aChavExc[5]+_aChavExc[6]
			DBSelectArea("SE2")
			DBSetOrder(1)
			If DBSeek(xFilial("SE2")+_cSE2Tit)
				aTitulo:={}
				aTitulo := { 	{ "E2_PREFIXO"  ,SE2->E2_PREFIXO  	, NIL },;
				   	        	{ "E2_NUM"      ,SE2->E2_NUM      	, NIL },;
		  	  	  		        { "E2_TIPO"     ,SE2->E2_TIPO     	, NIL },;
		  	  	  		        { "E2_NATUREZ"  ,SE2->E2_NATUREZ  	, NIL },;
		  	  	  		        { "E2_FORNECE"  ,SE2->E2_FORNECE  	, NIL },;
		  	  	  		        { "E2_LOJA"     ,SE2->E2_LOJA     	, NIL },;		  	   	     
		  	  	  		        { "E2_EMISSAO"  ,SE2->E2_EMISSAO  	, NIL },;
		  	  	  		        { "E2_VENCTO"   ,SE2->E2_VENCTO		, NIL },;
		  	  	  		        { "E2_VENCREA"  ,SE2->E2_VENCREA	, NIL },;
		  	  	  		        { "E2_VALOR"    ,SE2->E2_VALOR    	, NIL } }  
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,5) //EXCLUO TITULO PROVISÓRIO
		
				If lMsErroAuto                
				 	ALERT('Problemas para excluir título provisório')
				 	Mostraerro()
		  		Endif 
		  		
				//MsgAlert(_cNotfExc) 	
		  		      
	      ENDIF
	      
	  	endif
		
	else
		MsgAlert("Para concluir a exclusão é obrigatório informar o motivo!") 	
	endif
	
Return                        


*************************************
Static Function MudaConf(_lGerbanco)		                  
*************************************
	Local _nCfg:=0
	
	For _nCfg:=1 to len(_aCfgSx1)
		_aCfgSx1[_nCfg,3]:=iif(_lGerbanco,1,2)
	Next _nCfg      
Return

*******************************************
STATIC FUNCTION LeitSX1(_cPegSx1,_aAtuSx1)
*******************************************
Local _aSx1:={}
Local _aAreaSX1		:= GetArea() 
Local _nItSx1:=0
_nLockSx1:=0	
cX1PRESEL := "SX1->X1_PRESEL"
cX1ORDEM := "SX1->X1_ORDEM"
cX1GRUPO := "SX1->X1_GRUPO"

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(padr(_cPegSx1,10))

While !SX1->(Eof()) .And. rtrim(&(cX1GRUPO)) == rtrim(_cPegSx1)
		aadd(_aSx1,{&(cX1GRUPO),&(cX1ORDEM),&(cX1PRESEL)})   
		
		_nItSx1 := aScan(_aAtuSx1,{|x|rtrim(x[1])==rtrim(_cPegSx1) .and. rtrim(x[2])=rtrim(&(cX1ORDEM)) })	//adciono para atualizar profile
		
		if _nItSx1>0     
	      While !RecLock("SX1",.F.); EndDo
				&(cX1PRESEL):=_aAtuSx1[_nItSx1,3] //desabilito os que estão no array de atualização
				_nLockSx1++
			SX1->(MSUnlock())				
		endif
	SX1->(dbSKip())                       
End  

RestArea(_aAreaSX1) 
    
Return _aSx1


******************************************************
Static Function AltPfSx1(_cCodUsu,_aDadProf,_aCfgProf)//29/08/16
******************************************************

Local _aAreaSX		:= GetArea() 
Local _cStrProf:=""
Local _nItPrf:=0
Local _nPf:=0

PswOrder(1)
If PswSeek(_cCodUsu)
	cUserName := cEmpAnt + PswRet(1)[1][2]
	
	
	If FindProfDef(cUserName, "FIN050", "PERGUNTE", "MV_PAR")

		for _nPf:=1 to len(_aDadProf)
			_nItPrf := aScan(_aCfgProf,{|x|rtrim(x[1])==rtrim(_aDadProf[_nPf,1]) .and. rtrim(x[2])=rtrim(_aDadProf[_nPf,2]) })	//adciono para atualizar profile
			if _nItPrf>0
				_cStrProf+="N#G#"+alltrim(str(_aCfgProf[_nItPrf,3]))         + CRLF  								
			else
				_cStrProf+="N#G#"+alltrim(str(_aDadProf[_nPf,3]))            + CRLF  					
			endif
		next _nPf
		
		WriteProfDef(cUserName, "FIN050", "PERGUNTE", "MV_PAR", ; // Chave antiga
 				 cUserName, "FIN050", "PERGUNTE", "MV_PAR",_cStrProf )
		
	EndIf
	
EndIF   
     
RestArea(_aAreaSX)     

Return               
               

********************************
User Function RetFnFun(_nIdRet) //12/09/16 - Retorna informações de fornecedor do funcionário
********************************

Local _aAreaSX		:= GetArea() 
Local _cRetSA2:=""
Local _cCodMat:=""
     
PswOrder(1)
If PswSeek(_cUsuar)
	_cCodMat:=PswRet(1)[1][22]  

	if !empty(alltrim(_cCodMat))
		_cQryFun:=" SELECT A2_COD,A2_LOJA,A2_NOME from "+RETSQLNAME("SA2")+","+RETSQLNAME("SRA")
		_cQryFun+=" WHERE "+RETSQLNAME("SA2")+".D_E_L_E_T_<>'*'"
		_cQryFun+=" AND "+RETSQLNAME("SRA")+".D_E_L_E_T_<>'*'"
		_cQryFun+=" AND A2_CGC=RA_CIC "
		_cQryFun+=" AND A2_FILIAL='"+XFILIAL("SA2")+"'"
		_cQryFun+=" AND RA_FILIAL='"+substr(_cCodMat,3,2)+"'"
		_cQryFun+=" AND RA_MAT='"+substr(_cCodMat,5,6)+"'"	
		DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQryFun), "TFUNC", .F., .T.) 
		IF !TFUNC->(EOF()) .AND. !TFUNC->(BOF())
			_cRetSA2:=iif(_nIdRet==1,TFUNC->A2_COD,iif(_nIdRet==2,TFUNC->A2_LOJA,TFUNC->A2_NOME))	
			//M->ZPA_FORNEC:=TFUNC->A2_COD	
			//M->ZPA_LOJA	 :=TFUNC->A2_LOJA	
			//M->ZPA_NOMFOR:=TFUNC->A2_NOME	
		ELSE      
			if _nIdRet==1
				MsgAlert("Matricula ("+_cCodMat+") do usuario não cadastrado como Fornecedor!") 			
			endif
		ENDIF
		TFUNC->(DBCLOSEAREA())	
	else
		if _nIdRet==1
			MsgAlert("Usuario não cadastrado como Funcionario!") 				
		endif
	endif
EndIF   
     
RestArea(_aAreaSX)     

Return _cRetSA2


************************************************
User Function DelOk(_cAliDel,_nRecDel,_nOpcDel) //Validação na exclusao da PA	
************************************************
Local cTit := ZPA->ZPA_PREFIX + ZPA->ZPA_NUM + _cParcela + ZPA->ZPA_TIPO + ZPA->ZPA_FORNEC + ZPA->ZPA_LOJA
Local lMsErroAuto := .F.   
Local lTemTitulo := .F.
Local lLibPA := IIF(ZPA->ZPA_STATUS = 'L',.T.,.F.) 
Local _lExcTit:=.F. //05/08/16 
Local _nRetDel:=0  
Private lMsErroAuto := .F. 
aTitulo := {}
                   
//MsgAlert("Chamada antes do delete. Verificando se titulo pode ser excluído.") 

//Verifico se há o PA no contas a pagar
DBSelectArea("SE2")
DBSetOrder(1)
If DBSeek(xFilial("SE2")+cTit)
	lTemTitulo := .T.
EndIf

//Se o PA está liberado e tem movimentação finaceira (SE2)
//If lLibPA .and. lTemTitulo
If lLibPA 
	if lTemTitulo
		If MSGYESNO("Este PA foi liberado e gerou movimentação financeira. Deseja excluir mesmo assim?(S/N)","Exclusão de PA")
			_lExcTit:=.T.
			
			/*Begin Transaction
					
				 aVetor :={	{"E2_PREFIXO" ,ZPA->ZPA_PREFIX 	,Nil},;
	   	     		        {"E2_NUM"     ,ZPA->ZPA_NUM 	,Nil},;
	   	        	        {"E2_PARCELA" ,ZPA->ZPA_PARCEL 	,Nil},;
	           	          	{"E2_TIPO"    ,ZPA->ZPA_TIPO	,Nil},;               
	           	          	{"E2_NATUREZ" ,ZPA->ZPA_NATURE	,Nil}}
	
			 	MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,5) //Exclusao
			 	
	 			If lMsErroAuto
	      			Alert("Erro na exclusão. Contate a TI.")
	 			Else
	      			Alert("PA Excluída.") 
	      			_lExcTit:=.T.
	 			Endif     
	 			
	 		End Transaction*/
	 		
		EndIf 
	Else
		_lExcTit:=.T.
	EndIf    
Else
	MsgAlert("Somente PA LIBERADA pode ser Excluida!") 
EndIf

if lLibPA .AND. (!lTemTitulo .or. (lTemTitulo .and. _lExcTit ))//05/08/16

	_nRetDel:=AxDeleta(_cAliDel,_nRecDel,_nOpcDel,,,,) // AxDeleta() //AxDeleta(_cAliDel,_nRecDel,_nOpcDel,,,,)
	
	if _lExcTit

		Begin Transaction
			aVetor :={	{"E2_PREFIXO" ,ZPA->ZPA_PREFIX 	,Nil},;
	   		        {"E2_NUM"     ,ZPA->ZPA_NUM 	,Nil},;
	   	  	        {"E2_PARCELA" ,_cParcela 	,Nil},;
	      	        {"E2_TIPO"    ,ZPA->ZPA_TIPO	,Nil},;               
	           	     {"E2_NATUREZ" ,ZPA->ZPA_NATURE	,Nil}}
		
			 	MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,5) //Exclusao
			 	
	 		If lMsErroAuto
	      	Alert("Erro na exclusão.")
	 		Else
	      	Alert("PA Excluída.") 
	      	_lExcTit:=.T.
	 		Endif     
	 		
	 	End Transaction
	 	
	Endif
		
endif

Return      



*************************
User Function RetDtVPA() //Retorna a proxima data válida para inclusao de Pagamentos antecipados ou Adiantamento de viagens - 19/10/16 - Fabio Yoshioka
*************************                                                                                                                             
Local _dVenc:=Date()
Local _nDiaLimSem:=GetMv("AL_DIALIPA")
Local _nDiasPxPA :=GetMv("AL_DIAPXPA")
Local _dDtPost:=Date()
Local _dDtant:=Date()
Local _nP:=0

_dVenc:=_dVenc+_nDiasPxPA //somo os dias corridos
_dDtPost:=_dVenc
_dDtant :=_dVenc

if _nDiaLimSem<>DOW(_dVenc)
	//Dia eleito anterior
	For _nP:=1 to 7 
		if DOW(_dVenc+_nP)==_nDiaLimSem //ate proximo dia da semana
			_dDtPost:=_dVenc+_nP   	
			exit
		endif
	Next
	
	//Dia eleito anterior
	For _nP:=1 to 7 
		if DOW(_dVenc-_nP)==_nDiaLimSem //até anterior dia da semana
			_dDtant:=_dVenc-_nP   	
			exit
		endif
	Next

	_dVenc:=iif( (_dDtPost-_dVenc)<(_dVenc-_dDtant),_dDtPost,_dDtant)        
	
endif

_dVenc:= DataValida(_dVenc, .T.) //15/11/16 - TRATAR FERIADOS 

Return _dVenc     



*******************************************
Static Function ZPANotExc(aChave,cDestinat)  //Notificação de excluão de P.A. 13/01/17
*******************************************

Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto 
Local cDadoTit 
Local lBaseProd := IIf(GetServerIP() == '172.28.1.24', .T.,.F.)
Local lOk := .F.

cCabec := "EXCLUSAO DE "
cTexto := "Informamos que a solicitação de Pagamento Antecipado (PA) conforme dados abaixo, foi EXCLUIDA."

                           
cCodProcesso := "WF_106" 																	
cHtmlModelo := "\Workflow\WF_HTMLV2\ADM\Alcada_CP\ExcluiPa_page.html"
cAssunto := "Notificação - Exclusão de Pagamento Antecipado"	
oProcess:= TWFProcess():New(cCodProcesso, cAssunto) 										
cTitulo :=  "WF_106" 																		
oProcess:NewTask(cTitulo, cHtmlModelo) 														
oHtml	:= oProcess:oHTML

_cTitulo:="NOTIFICACAO - EXCLUSAO DE PAGAMENTO ANTECIPADO"   

cDadoTit:=aChave[1]+aChave[2]+aChave[3]+aChave[4]+aChave[5]+aChave[6]

//Dados do Cabeçalho
oProcess:oHtml:ValByName( "cTitPA" 	,_cTitulo) //14/09/16
oProcess:oHtml:ValByName( "cCabec" 		,cCabec)
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,aChave[7])
oProcess:oHtml:ValByName( "cCodSol" 	,aChave[8])
//oProcess:oHtml:ValByName( "cAprovador" ,aChave[9])
//oProcess:oHtml:ValByName( "cCodAprov" 	,aChave[10])
oProcess:oHtml:ValByName( "cTexto" 		,cTexto )
oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
oProcess:oHtml:ValByName( "cNomeFor" 	,aChave[10])
oProcess:oHtml:ValByName( "cDtEmiss" 	,aChave[11])
oProcess:oHtml:ValByName( "cDtPagto" 	,aChave[12])
oProcess:oHtml:ValByName( "cValor" 		,aChave[13])
oProcess:oHtml:ValByName( "cMotivo" 	,aChave[14]) 

//Revisao do Workflow
_cIpTest:=SuperGetMV("AL_IPSRVTS",.f.,"172.28.1.20")
lServTeste := IIf(GetServerIP() == RTRIM(_cIpTest), .T.,.F.)
If !lServTeste //Servidor Produção
	oProcess:cSubject := "ALUBAR "+cCabec+" de Pagamento Antecipado."+DTOC(dDataBase)
	oProcess:cTo := cDestinat+";"+Alltrim(GetMv("AL_MAILADM")) 
Else //Servidor Base_teste   
	oProcess:cSubject := "TESTE ALUBAR "+cCabec+" de Pagamento Antecipado."+DTOC(dDataBase)
	oProcess:cTo := Alltrim(GetMv("AL_MAILADM"))
EndIf	
oProcess:Start()                         
oProcess:Finish()

Return()                                                                                                


***************************                        
User Function WfAtrNfe()   // 27/03/17 - WorkFlow para identificar os atrasos no prazo de entrada da NF (compensação) - Fabio Yoshioka - 27/03/17
***************************

Local aArea := GetArea()

RPCSetType(3) //não consome licença.
PREPARE ENVIRONMENT EMPRESA '06' FILIAL '01'
Conout("EXECUTANDO WfAtrNfe - Iniciando rotinas scheduladas em " + dtoc(date()) + " as " + time())

U_NOTFATNF()
                     
Conout("WfAtrNfe  - Finalizando rotinas scheduladas em " + dtoc(date()) + " as " + time())

RESET ENVIRONMENT
RestArea(aArea)

Return()  

************************
User Function NOTFATNF()
************************  
Private _aRetPrzNF:={}
_cQry:=" SELECT ZPA_PREFIX,ZPA_NUM,ZPA_FORNEC,ZPA_LOJA,ZPA_NOMFOR,ZPA_DTEMIS,ZPA_VALOR,ZPA_VENCTO,ZPA_SOLICI,ZPA_NOMESO,ZPA_HIST,ZPA_PEDIDO,ZPA_STATUS,ZPA_PZENNF,"+RETSQLNAME("ZPA")+".R_E_C_N_O_ AS RECZPA,E2_EMISSAO, "
_cQry+=" (SELECT COUNT(*) FROM "+RETSQLNAME("SD1")
_cQry+=" WHERE "+RETSQLNAME("SD1")+".D_E_L_E_T_=' '"
_cQry+=" AND D1_PEDIDO=ZPA_PEDIDO "
_cQry+=" AND D1_FORNECE=ZPA_FORNEC "
_cQry+=" AND D1_LOJA=ZPA_LOJA "
_cQry+=" AND D1_TES<>'   ') AS REGSD1 "  
_cQry+=" from "+RETSQLNAME("ZPA")+","+RETSQLNAME("SE2")
_cQry+=" WHERE "+RETSQLNAME("ZPA")+".D_E_L_E_T_=' '"
_cQry+=" AND "+RETSQLNAME("SE2")+".D_E_L_E_T_=' '"
_cQry+=" AND ZPA_FILIAL='"+XFILIAL("ZPA")+"'"
_cQry+=" AND ZPA_TIPOPA='1'"
//_cQry+=" AND ZPA_STATUS<>'R'"
//_cQry+=" AND ZPA_STATUS='Z'" //SOMENTE AS PA'S GERADAS PELO FINANCEIRO  
_cQry+=" AND E2_FILIAL='"+XFILIAL("SE2")+"'"
_cQry+=" AND E2_NUM=ZPA_NUM "
_cQry+=" AND E2_PREFIXO=ZPA_PREFIX "
_cQry+=" AND E2_TIPO='PA'" //PAS GERADAS
_cQry+=" and E2_FORNECE=ZPA_FORNEC "
_cQry+=" AND E2_LOJA=ZPA_LOJA "
_cQry+=" AND E2_SALDO>0 " //11/08/17 - Considerar apenas não compensados - Fabio Yoshioka
_cQry+=" ORDER BY REGSD1 "
DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "TZPA", .F., .T.) 
While !TZPA->(eof())
	IF TZPA->REGSD1==0
		IF DATE() > STOD(TZPA->ZPA_PZENNF) .AND. !EMPTY(ALLTRIM(TZPA->ZPA_PZENNF))
			AADD(_aRetPrzNF,{TZPA->ZPA_PREFIX,;
				TZPA->ZPA_NUM,;
				TZPA->ZPA_FORNEC,;
				TZPA->ZPA_LOJA,;
				TZPA->ZPA_NOMFOR,;
				TZPA->ZPA_DTEMIS,;
				TZPA->ZPA_VALOR,;
				TZPA->ZPA_VENCTO,;
				TZPA->ZPA_SOLICI,;
				TZPA->ZPA_NOMESO,;
				TZPA->ZPA_HIST,;
				TZPA->ZPA_PEDIDO,;
				TZPA->ZPA_STATUS,;
				TZPA->ZPA_PZENNF,;
				TZPA->E2_EMISSAO})
		ENDIF
		
		   
/*		DBSelectArea("ZPA")
		DBGoTo(TZPA->RECZPA)
		RecLock("ZPA",.F.)
		ZPA->ZPA_PZENNF := ZPA->ZPA_DTEMIS+10
		ZPA->(MSUNLOCK())   */
		
	ENDIF
	TZPA->(DBSKIP())
EndDo               
TZPA->(DBCLOSEAREA()) 


IF LEN(_aRetPrzNF)>0
	U_WFATRPZNF(_aRetPrzNF)     
ENDIF                     

Return

********************************
User Function WFATRPZNF(_aEnvWF) 
********************************
Local _cIpProd:=GetMV("AL_IPSRVPR")
Local _cIpTest:=GetMV("AL_IPSRVTS")
Local oHTML,oProcess
Local lServProd := IIf(GetServerIP() == RTRIM(_cIpProd), .T.,.F.)   
Local _cDestNotf:=GetMV("AL_MAILNPA") //04/04/17 - Destinos para notificação de PA
Local _nIWf:=1

oProcess:= TWFProcess():New("WFATRPCON","Pagamentos Antecipados - Documentos de entrada em atraso") 										
oProcess:NewTask("Montagem do HTML", "\workflow\WF_HTMLV2\Adm\Alcada_CP\WFATRNFE.html") 

oHtml	:= oProcess:oHTML				

if len(_aEnvWF)>0
	oProcess:oHtml:ValByName("cData"  		, DTOC(dDatabase))
	oProcess:oHtml:ValByName("cHora"  		, SubStr(Time(),1,5))
	nTotal := 0                
	_nItens:=0
	
	For _nIWf:=1 to len(_aEnvWF)	
	
		AAdd( ( oHtml:ValByName( "it.pedido"))	, _aEnvWF[_nIWf,12] )		
		AAdd( ( oHtml:ValByName( "it.prefixo")), _aEnvWF[_nIWf,1] )		
		AAdd( ( oHtml:ValByName( "it.numero")) , _aEnvWF[_nIWf,2] )		
		AAdd( ( oHtml:ValByName( "it.forn"))	, _aEnvWF[_nIWf,5] )		
		AAdd( ( oHtml:ValByName( "it.emissao")), DTOC(STOD(_aEnvWF[_nIWf,15])) )		
		AAdd( ( oHtml:ValByName( "it.vencto")) , DTOC(STOD(_aEnvWF[_nIWf,8])) )		 
		AAdd( ( oHtml:ValByName( "it.dtPA"))	, DTOC(STOD(_aEnvWF[_nIWf,8])) )		 
		AAdd( ( oHtml:ValByName( "it.valor"))	, Transform(_aEnvWF[_nIWf,7],'@E 999,999,999.99' ) )		
		AAdd( ( oHtml:ValByName( "it.resp"))	, _aEnvWF[_nIWf,10] )		
		AAdd( ( oHtml:ValByName( "it.hist"))	, _aEnvWF[_nIWf,11] )		
		AAdd( ( oHtml:ValByName( "it.prazo"))	, DTOC(STOD(_aEnvWF[_nIWf,14])) )		
		AAdd( ( oHtml:ValByName( "it.atraso")) , alltrim(str(date()-stod(_aEnvWF[_nIWf,14]))))		
		nTotal += _aEnvWF[_nIWf,7]
		_nItens++               
	Next _nIWf 

	oProcess:oHtml:ValByName("cTotalVlr", Transform(nTotal,'@E 999,999,999.99'))

	oProcess:cSubject := "Pagamentos Antecipados - Documentos de entrada em atraso"
	oProcess:cTo := Alltrim(GetMV("AL_MAILADM")) + IIF(lServProd,+";"+Alltrim(UsrRetMail(_aEnvWF[1,14]))+";"+iif(!empty(alltrim(_cDestNotf)),_cDestNotf,""),"")
	oProcess:start()
	oProcess:Finish()    

ENDIF
	
Return()                                                           



**********************
User Function RelZPA()     // RESUMO DE SOLICITAÇÕES DE PA
**********************

#IFNDEF  WINDOWS
	#Translate PSAY => SAY
#Endif


cString     :="ZPA"
cDesc1      :=OemToAnsi("Este programa tem como objetivo, emitir um relatorio de")
cDesc2      :=OemToAnsi("Pagamentos Antecipados")
cDesc3      :=""
titulo      :="Relatório de Pagamento Antecipado"
tamanho     :="G"
cPerg       :="RELZPA"
aReturn     := { "Zebrado", 1, "Administracao" ,1,1,1,"",1 }
nomeprog    :="RELZPA"
aLinha      := {}
nLastKey    := 0
nLin        := 1
cCancel     :="**** CANCELADO PELO OPERADOR ****"
m_pag       :=  1            // Variavel que acumula numero da pagina.
n_col       :=  220//130
wnrel       := "RELZPA"    // Nome Default deste Relatorio em disco.
cfilteruser :=areturn[7]


/*IF !(Pergunte(cPerg,.T.))
	RETURN Nil
ENDIF    */

If nLastkey == 27
	Set Filter to
	Return
EndIf

Processa({||RptDetail()})
Return

*****************************
STATIC Function RptDetail()
*****************************
lOCAL _aCampos:={}    
Local _nSpaceCab:=0
Local _aRetira:={}   
Local _nPrt:=1

aadd(_aRetira,"ZPA_TIPOPA")

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"G","",.T.)

If nLastkey == 27
	Set Filter to
	Return
EndIf          

//TITULO:=TITULO+" - POSICAO EM "+DTOC(dDatabase)+" Hora: "+TIME()
titulo1     :=""
titulo2     :=""

cabec1      :=""
cabec2      :=""
cabec3      :=""

cX3CAMPO :="SX3->x3_campo"
cX3TIPO :="SX3->x3_TIPO"
cX3USADO :="SX3->x3_USADO"
cX3ARQUIVO :="SX3->x3_ARQUIVO"
cX3TITULO :="SX3->x3_TITULO"
cX3TAMANHO :="SX3->x3_TAMANHO"
cX3PICTURE :="SX3->x3_PICTURE"

_cAlias:="ZPA"  
_nPosLin:=1
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(_cAlias)
While !SX3->(Eof()) .And. (&(cX3ARQUIVO) == _cAlias)
	IF (X3USO(&(cX3USADO)) .AND. RTRIM(&(cX3TIPO))<>'M') 
		if ascan(_aRetira,rtrim(&(cX3CAMPO)))==0
			AADD(_aCampos,{ TRIM(&(cX3TITULO)),;
				&(cX3CAMPO),;
				&(cX3Tamanho),;
				&(cX3TIPO),;
				Len(cabec1),;
				iif(&(cX3TIPO)='N',&(cX3PICTURE),"")} )   
				_nSpaceCab:=iif(&(cX3TAMANHO)>len(ALLTRIM(&(cX3TITULO))),&(cX3TAMANHO)-len(ALLTRIM(&(cX3TITULO))),5)  
				_nPosLin+=_nSpaceCab      
				IF rtrim(&(cX3CAMPO))<>"ZPA_HIST"
					cabec1+=ALLTRIM(&(cX3TITULO))+SPACE(_nSpaceCab)	 
				else
					cabec2+=ALLTRIM(&(cX3TITULO))+SPACE(_nSpaceCab)	 
				ENDIF
		endif
	ENDIF		 
	SX3->(dbSkip())
EndDo                      



SetDefault(aReturn,cString)

If nLastkey == 27
	Set Filter to
	Return
Endif

linha := 90                                                                    

DBSELECTAREA(_cAlias)

Linha:=Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)+1
For _nPrt:=1 to len(_aCampos)  
	if rtrim(_aCampos[_nPrt,2])<>"ZPA_HIST"
		_cstrSub:=_cAlias+"->"+rtrim(_aCampos[_nPrt,2])
 		@ LINHA,_aCampos[_nPrt,5] PSAY IIF(_aCampos[_nPrt,4]='N', LTRIM(TRANSFORM(&_cstrSub,_aCampos[_nPrt,6])), &_cstrSub)
 	ELSE
		_cstrSub:=_cAlias+"->"+rtrim(_aCampos[_nPrt,2])
 		@ LINHA+2,001 PSAY IIF(_aCampos[_nPrt,4]='N', LTRIM(TRANSFORM(&_cstrSub,_aCampos[_nPrt,6])), &_cstrSub)
 	ENDIF
Next _nPrt                                                          


		

Roda(0,"","G")

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool( wnrel )
EndIf

MS_FLUSH()      // Libera fila de relatorios em spool.

DBCLEARFILTER()

Return
               
               
               
************************
User Function GeraPRFin() //Gravação do título provisório em inclusao do financeiro - 20/08/17
************************
Local aChave := {}         
Local _lTemSe2:=.F.
Private _cCustPA:=GetMV("AL_CCUSTPA")//10/08/16     
Private _cNatuPA:=GetMV("AL_NATURPA")//10/08/16
Private lMsErroAuto 	:= .F.
Private lMsHelpAuto 	:= .F.  

DBSelectARea("ZPA")     
		
_cQrySE2 := " "
_cQrySE2 += "SELECT * FROM "+RetSQLName("SE2")+" "
_cQrySE2 += "WHERE	E2_FILIAL = '"+xFilial("SE2")+"' AND "
_cQrySE2 += "			E2_PREFIXO = '"+RTRIM(ZPA->ZPA_PREFIX)+"' AND "
_cQrySE2 += "			E2_NUM = '"+RTRIM(ZPA->ZPA_NUM)+"' AND "
_cQrySE2 += "			E2_PARCELA = '"+RTRIM(ZPA->ZPA_PARCEL)+"' AND "		
_cQrySE2 += "			E2_TIPO = '"+RTRIM(ZPA->ZPA_TIPO)+"' AND "	 // Título provisório
_cQrySE2 += "			E2_FORNECE = '"+RTRIM(ZPA->ZPA_FORNEC)+"' AND "		
_cQrySE2 += "			E2_LOJA = '"+RTRIM(ZPA->ZPA_LOJA)+"' AND "		
_cQrySE2 += "			D_E_L_E_T_ <> '*' "
DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySE2), "TSE2", .F., .T.) 
IF !TSE2->(EOF()) .AND. !TSE2->(BOF())
	_lTemSe2:=.T.		
ENDIF
TSE2->(DBCLOSEAREA())

IF !_lTemSe2
	//18/12/18 - Fabio Yoshioka - Inclusao de Gravação do Campo E2_PZENNF - Chamado 21705
	aTitulo := {}
	aTitulo :={	{"E2_FILIAL"	,xFilial("ZPA")		,Nil},;
				{"E2_PREFIXO"	,ZPA->ZPA_PREFIX 	,Nil},;
				{"E2_NUM"      	,ZPA->ZPA_NUM		,Nil},;
	        	{"E2_PARCELA"  	,ZPA->ZPA_PARCEL	,Nil},;
	        	{"E2_TIPO"     	,'PR'				,Nil},;               
	        	{"E2_NATUREZ"  	,_cNatuPA			,Nil},;
	        	{"E2_FORNECE"  	,ZPA->ZPA_FORNEC	,Nil},; 
	        	{"E2_LOJA"     	,ZPA->ZPA_LOJA		,Nil},;      
	        	{"E2_EMISSAO"  	,ZPA->ZPA_DTEMIS	,NIL},;
	        	{"E2_VENCTO"   	,ZPA->ZPA_VENCTO	,NIL},;                          
	    		{"E2_VENCREA"  	,ZPA->ZPA_VENCTO	,NIL},;                                                   
	        	{"E2_VALOR"    	,ZPA->ZPA_VALOR		,Nil},;
	        	{"E2_VLCRUZ"	,ZPA->ZPA_VALOR		,Nil},; 
				{"E2_HIST"		,ZPA->ZPA_HIST		,Nil},; 			       	
	        	{"E2_STATWF" 	,"LB"				,Nil},;
	        	{"E2_DIGBARR" 	,iif(ZPA->(FieldPos("ZPA_DIGBAR"))>0,ZPA->ZPA_DIGBAR,""),Nil},;
	        	{"E2_CODBAR" 	,iif(ZPA->(FieldPos("ZPA_DIGBAR"))>0,ZPA->ZPA_DIGBAR,""),Nil},;
	        	{"E2_INSTRPA"	,ZPA->ZPA_HIST		,Nil},;
	        	{"E2_PZENNF"	,ZPA->ZPA_PZENNF	,Nil},;
	        	{"E2_CC"     	,_cCustPA			,Nil}}
			           		
				
			*****************************	
			//Inicio a inclusão do titulo
			*****************************	
			lMsErroAuto := .F.
			Conout("Executando EXECAUTO "+ZPA->ZPA_NUM)
			MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,3) //Inclusao  
				
			If lMsErroAuto                
				//Caso encontre erro, mostre
				Conout("Erro do EXECAUTO "+ZPA->ZPA_NUM)
			 	Mostraerro()
			Else    
			 	Msginfo("Titulo provisório "+ZPA->ZPA_NUM +" gerado com sucesso!")  
	 			DBSelectARea("ZPA")  
				U_AltStPA(ZPA->ZPA_FILIAL+ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA,'L',_cUsuar,UsrRetName(_cUsuar))   			
			Endif
			
ELSE
 	Alert("Titulo Provisório existente no contas a pagar "+ZPA->ZPA_NUM+".Favor refazer a operação!")  			
	//U_AltStPA(ZPA->ZPA_FILIAL+ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA,'L',cCodAprov,UsrRetName(cCodAprov))    					 	
EndIf
  

Return()
               
               



***************************************************
User Function DevolZPA(_cAliaszpa,_nRecZPA,_cIdPA) //Criação de opção para Devolução da PA  - 11/12/17 - Fabio Yoshioka - Solicitante : Sheila Silva
*************************************************** 
	Local _cInfHist:=space(200) 
	Local _aDestExc:={}       
	Local _lExcTitPA:=.F.
	Local _lTudoOK:=.F.
	Private _cNatuPA:=GetMV("AL_NATURPA")
	Private _cCustPA:=GetMV("AL_CCUSTPA")
		
	_cTipoPA:=_cIdPA
	
	if RTRIM(_cTipoPA)=='2' .OR. RTRIM(ZPA->ZPA_STATUS)<>'Z'
		MsgAlert("Não é permitido a devolução desse registro!") 	
		RETURN	
	ENDIF 

	If !MSGYESNO("Confirma a Devolução da PA "+ZPA->ZPA_NUM+"?","Devolução de PA")
		RETURN	
	Endif	
	
	
	//Informar motivo para histórico   
  	DEFINE MSDIALOG _oDlgExc TITLE "Informe Motivo da Devolução" FROM 000, 000  TO 120, 470 COLORS 0, 16777215 PIXEL
   @ 001, 002 MSGET _oGetHist VAR _cInfHist SIZE 200, 012 
   @ 003, 020 BUTTON oButton2 PROMPT "OK" SIZE 050, 012 Action _oDlgExc:End()
	ACTIVATE MSDIALOG _oDlgExc Centered
                                      
	
	if !empty(alltrim(_cInfHist)) 
		DBSelectARea("ZPA")  
		RecLock("ZPA",.F.)
		ZPA->ZPA_EXHIST := UPPER(_cInfHist)
		ZPA->(MSUnlock())
	endif
	
	
	//EXCLUO AMARRAÇÕES COM PEDIDO DE COMPRAS - 12/12/17 - FABIO YOSHIOKA
	DBSelectArea("FIE")
	DBSetOrder(3) //FIE_FILIAL, FIE_CART, FIE_FORNEC, FIE_LOJA, FIE_PREFIX, FIE_NUM, FIE_PARCEL, FIE_TIPO, FIE_PEDIDO, R_E_C_N_O_, D_E_L_E_T_
	If DBSeek(xFilial("FIE")+"P"+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA+ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO,.F.)
		Reclock("FIE",.F.)		
		FIE->(dbDelete())
		FIE->(MSUnlock())   
	Endif
	
	
	//excluir informaçãoes no ctas a pagar 	
	//Excluo o título de PA
	_cSE2Tit := ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA
	DBSelectArea("SE2")
	DBSetOrder(1)
	If DBSeek(xFilial("SE2")+_cSE2Tit)
		aTitulo:={}
		aTitulo := { { "E2_PREFIXO"  , SE2->E2_PREFIXO  , NIL },;
		   	        	{ "E2_NUM"      ,SE2->E2_NUM    , NIL },;
		  	  	  		{ "E2_TIPO"     ,SE2->E2_TIPO   , NIL },;
		  	  	      	{ "E2_NATUREZ"  ,SE2->E2_NATUREZ, NIL },;
				  	   	{ "E2_FORNECE"  ,SE2->E2_FORNECE, NIL },;
				  	   	{ "E2_LOJA"     ,SE2->E2_LOJA   , NIL },;		  	   	     
		  	   		   	{ "E2_EMISSAO"  ,SE2->E2_EMISSAO, NIL },;
					    { "E2_VENCTO"   ,SE2->E2_VENCTO	, NIL },;
		  	         	{ "E2_VENCREA"  ,SE2->E2_VENCREA, NIL },;
				  	    { "E2_VALOR"    ,SE2->E2_VALOR  , NIL } }  
				
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,,5) //EXCLUO TITULO PA
		
		If lMsErroAuto                
		 	ALERT('Problemas para excluir título de PA')
		 	Mostraerro()
		else
			_lExcTitPA:=.t.
		Endif 
		
		  		
	    IF _lExcTitPA //Volto o Status e Título da PA para PR
	    //18/12/18 - Fabio Yoshioka - Inclusao de Gravação do Campo E2_PZENNF - Chamado 21705
	    	aTitulPR:={}
	    	aTitulPR :={	{"E2_FILIAL",xFilial("ZPA")		,Nil},;
	    				{"E2_PREFIXO"	,ZPA->ZPA_PREFIX 	,Nil},;
	    				{"E2_NUM"      	,ZPA->ZPA_NUM		,Nil},;
			        	{"E2_PARCELA"  	,ZPA->ZPA_PARCEL	,Nil},;
			        	{"E2_TIPO"     	,'PR'				,Nil},;               
			        	{"E2_NATUREZ"  	,_cNatuPA			,Nil},;
			        	{"E2_FORNECE"  	,ZPA->ZPA_FORNEC	,Nil},; 
			        	{"E2_LOJA"     	,ZPA->ZPA_LOJA		,Nil},;      
			        	{"E2_EMISSAO"  	,ZPA->ZPA_DTEMIS	,NIL},;
			        	{"E2_VENCTO"   	,ZPA->ZPA_VENCTO	,NIL},;                          
			    		{"E2_VENCREA"  	,ZPA->ZPA_VENCTO	,NIL},;                                                   
			        	{"E2_VALOR"    	,ZPA->ZPA_VALOR		,Nil},;
			        	{"E2_VLCRUZ"	,ZPA->ZPA_VALOR		,Nil},; 
						{"E2_HIST"		,ZPA->ZPA_HIST		,Nil},; 			       	
			        	{"E2_STATWF" 	,"LB"				,Nil},;
			        	{"E2_PZENNF"	,ZPA->ZPA_PZENNF	,Nil},;
			        	{"E2_CC"     	,_cCustPA			,Nil}}
	
			 lMsErroAuto := .F.
        	 MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulPR,,3) //Inclusao
	    
        	If lMsErroAuto                
        		ALERT('Problemas para inclui título PR')
        		Mostraerro()
        	else
        		_lTudoOK:=.t.
        	Endif 
	    
        	if _lTudoOK
        		DBSelectARea("ZPA")  
        		While !RecLock("ZPA",.F.);EndDo 	
        		ZPA->ZPA_STATUS := "X"
        		ZPA->ZPA_TIPO := "PR" //VOLTA PARA PROVISORIO
        		IF ZPA->(FieldPos("ZPA_DTPGTO")) > 0 
        			ZPA->ZPA_DTPGTO		:= Stod(space(8)) // 26/03/18 - Solicitação Financeiro
        		Endif
        		ZPA->(MSUnlock())
        	endif
        	
		ENDIF
		
	else
		MsgAlert("Título de PA "+rtrim(_cSE2Tit)+" não encontrado!") 	
	endif
	
Return                        

***************************
User Function ImpPAPAG() //Impressao do comprovante de pagamento Sispag  -  13/03/18                 
***************************

Local cIDCNAB     := ""       
Local cPathSIS    := GetMv("AL_PATHCPY")
Local cHttpFil    := GetMv("AL_COMPRPG")
Local cArquivo    := ""
Local cFornece    := ""    
Local cDestinat   := ""    
Local cArqBrowser := ""
Local cAnexo      := ""    
Local cMsgBody    := ""
Local _aAreaSE2   :=SE2->(Getarea())
Local _aAreaZPA   :=ZPA->(Getarea())
Private nPgVist   := 1 
Private aSize     := MsAdvSize() 
Private oDlg1, oTIBrw 
Private cNavegado := Space(400)                                    
Private lcont     := .F.


_cSE2Tit := ZPA->ZPA_PREFIX+ZPA->ZPA_NUM+ZPA->ZPA_PARCEL+ZPA->ZPA_TIPO+ZPA->ZPA_FORNEC+ZPA->ZPA_LOJA
DBSelectArea("SE2")
DBSetOrder(1)
If !DBSeek(xFilial("SE2")+_cSE2Tit)
	MSGSTOP("Registro não existente no Contas a Pagar - SE2")
	RestArea(_aAreaSE2)
	RestArea(_aAreaZPA)
	Return()
ENDIF
 

//Testo se existe o controle de autenticaçao
If Alltrim(SE2->E2_IDSISPG) == ''
	MSGSTOP("Não existe comprovante de pagamento SISPAG para este título.")
	RestArea(_aAreaSE2)
	RestArea(_aAreaZPA)
	Return()
EndIf

cIDCNAB     := SE2->E2_IDCNAB
cArquivo    := rtrim(cHttpFil)+cIDCNAB+".htm" // "file:///"+Alltrim(cPathSIS)+"\"+cIDCNAB+".htm"
cFornece    := SE2->E2_FORNECE+SE2->E2_LOJA

//Pagina de abertura no navegador
cPage := cArquivo             
cAnexo := Alltrim(cPathSIS)+"\"+cIDCNAB+".htm"

DEFINE MSDIALOG oDlg1 TITLE "SISPAG COMPROVANTE" From 0,0 to 570,1250 of oMainWnd PIXEL 

cNavegado := cPage 
oNav:= TGet():New(10,10,{|u| if(PCount()>0,cNavegado:=u,cNavegado)}, oDlg1,340,5,,,,,,,,.T.,,,,,,,,,,)    
@ 010, 350 Button oBtnEnvia 	PROMPT "Enviar" Size 40,10 Action (oDlg1:End(),lCont := .T.) Of oDlg1 Pixel 
@ 010, 390 Button oBtnImprime PROMPT "Imprimir" Size 40,10 Action (oTIBrw:Print(),oDlg1:End()) Of oDlg1 Pixel
@ 010, 430 Button oBtnSair 	PROMPT "Sair" Size 40,10 Action oDlg1:End() Of oDlg1 Pixel                                     
oTIBrw:= TIBrowser():New( 025,010,610, 250, cPage, oDlg1 )     
Activate MsDialog oDlg1 Centered 

If lCont  
	cDestinat := Alltrim(Posicione("SA2",1,cFornece,"A2_EMAIL"))
	If cDestinat == ''
		If MSGYesNo("Não existe e-mail cadastrado para este fornecedor. Deseja informar um?")
			Do While Alltrim(cDestinat) == ''
				cDestinat := U_GetAddress()
				If Alltrim(cDestinat) == ''
					MSGInfo("Informe um e-mail válido")
				EndIf
			EndDo
			cDestinat += ";"+Alltrim(GetMV("AL_MAILADM"))
			cMsgBody := U_GetMotAlt()
			WFEnviaJa(cDestinat,cAnexo, cMsgBody)
		EndIf
	Else          
		cMsgBody := U_GetMotAlt()
		WFEnviaJa(cDestinat,cAnexo, cMsgBody)
	EndIf	
EndIf

RestArea(_aAreaSE2)
RestArea(_aAreaZPA)

Return       

*********************************************************
Static Function WFEnviaJa(cDestinat,cArqAnexo, cMsgBody)
*********************************************************

//Variaveis do Processo oHTML
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto
Local cEnviron := Upper(GetEnvServer())

******************************** 
conout("Iniciando a WFlowEnvia")                       
******************************** 

cCodProcesso := "WF_106" 																// Código extraído do cadastro de processos.
cHtmlModelo := cArqAnexo											 					// Arquivo html template utilizado para montagem da aprovação
cAssunto := "SISPAG Alubar: Notificação de Pagamento de Contas"			// Assunto da mensagem
oProcess:= TWFProcess():New(cCodProcesso, cAssunto) 							// Criando o processo
cTitulo :=  "WF_106" 																	
oProcess:NewTask(cTitulo, cHtmlModelo) 											// Inicio da criação da tarefa   
oHtml	:= oProcess:oHTML																	// Montagem do HTML!! 
oProcess:cSubject 	:= "NOTIFICACAO DE SISPAG "								


//Revisao do Workflow
_cIpTest:=SuperGetMV("AL_IPSRVTS",.f.,"172.28.1.20")
lServTeste := IIf(GetServerIP() == RTRIM(_cIpTest), .T.,.F.)
If !lServTeste .and. Alltrim(cEnviron) == 'ENVIRONMENT' 
	oProcess:cTo 		:= Alltrim(GetMV("AL_MAILADM"))+";"+cDestinat //12/12/17 - Fabio Yoshioka - Joao Santos Solititou retirada do envio em cópia
ELse
	oProcess:cTo 		:= Alltrim(GetMV("AL_MAILADM"))
EndIf

oProcess:Start() 	//Inicia o processo... 
oProcess:Finish()  //...e em seguida finaliza    

Return(.T.)

************************************
Static Function RetValPed(_cPedSC7) //29/08/18 - fabio Yoshioka - Chamado 19094 - Solicitante : Rena Goes  
************************************
Local _nVlrPed:=0
Local _cQrySC7:=""
Local _nTOTDESC:=_nTotalNF:=_nTotIPI:=_nTotDesp:=_nTotFrete:=0

	_cQrySC7 += " SELECT C7_TOTAL,C7_ICMSRET,C7_ICMCOMP,C7_DESPESA,C7_VALFRE,C7_DESC1,C7_DESC2,C7_DESC3,C7_VLDESC FROM "+RetSQLName("SC7")+" "   //12/09/17
	_cQrySC7 += " WHERE	C7_FILIAL = '"+xFilial("SC7")+"'"
	_cQrySC7 += " AND	C7_NUM = '"+RTRIM(_cPedSC7)+"'"
	_cQrySC7 += " AND	D_E_L_E_T_ = ' '"
	DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySC7), "TSC7", .F., .T.) 
	Do While !TSC7->(eof())
			If TSC7->C7_DESC1 != 0 .or. TSC7->C7_DESC2 != 0 .or. TSC7->C7_DESC3 != 0
				_nTOTDESC+= CalcDesc(TSC7->C7_TOTAL,TSC7->C7_DESC1,TSC7->C7_DESC2,TSC7->C7_DESC3)
			Else
				_nTOTDESC+=TSC7->C7_VLDESC
			Endif
			
			_nTotalNF+=TSC7->C7_TOTAL + TSC7->C7_ICMSRET+TSC7->C7_ICMCOMP //Incluido (C7_ICMCOMP) - 30/08/18 - Fabio Yoshioka
			_nTotDesp+=TSC7->C7_DESPESA
			_nTotFrete+=TSC7->C7_VALFRE        
			
	
		TSC7->(dbskip())
	Enddo
	TSC7->(dbclosearea())
	
	_nVlrPed:=_nTotalNF-_nTOTDESC+_nTotDesp+_nTotFrete
					
Return	_nVlrPed	

********************************************
User Function EnvVisFin(_cChvZPA,_cUserSol ) //Envio de WF direto para Liberação da Coordenação (Visto) - 23/05/19
********************************************
Local _dData:=date()
Local _nRecSE2:=0
Local _cQrySE2:=""

_cQrySE2:=" select R_E_C_N_O_ AS RECSE2 FROM " +RETSQLNAME("SE2")+" (NOLOCK)"
_cQrySE2+=" WHERE E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA='"+_cChvZPA+"'"
_cQrySE2+=" AND D_E_L_E_T_=' '"  
DBUseArea(.T., "TOPCONN", TCGenQry(,,_cQrySE2), "TRSE2", .F., .T.)
IF !TRSE2->(EOF()) .AND. !TRSE2->(BOF())
	_nRecSE2:=TRSE2->RECSE2
ENDIF
TRSE2->(DBCLOSEAREA())

IF _nRecSE2>0
	U_Se2Start(_dData,_cUserSol,_nRecSE2)
ENDIF 

Return			
          

*************************
User Function ENVWFFIPA() //Reenvio de e-mail para aprovação de Visto - 17/05/19
*************************

Local cTipoPA := ZPA->ZPA_TIPOPA
Local cCCusto := ZPA->ZPA_CC  
Local aEmail:={}
Local _aDadZPA:={}
Local _aAreaAnt := GetArea()

if UPPER(RTRIM(ZPA->ZPA_STATUS))<>'L'//somente se tiver status de L (aprovado pelo gestor do Compras)
	MsgAlert("O status do registro NAO PERMITE o reenvio") 
	RETURN
ENDIF

If MSGYESNO("Esta opção irá reenviar esta PA para aprovação Do Setor Financeiro. Deseja continuar?","Reenvia Aprovacao PA")
	cCodSol:=""
	cCodApro:=""
	cNomSol:=""
	cNomApro:=""
	cMaiApro:=""
	cMaiSol:=""
	
	IF ValAPVFin("C")//Carregar informações do aprovador

	
		//Carrego   vetores
		aEmail := {}
		aAdd(aEmail, cCodSol ) 				//01 Cod Solicitante
		aAdd(aEmail, Alltrim(cNomSol) )		//02 Nome Solicitante
		aAdd(aEmail, Alltrim(cMaiSol) )		//03 //Mail do Solicitante
		aAdd(aEmail, cCodApro )				//04 Cod Aprovador
		aAdd(aEmail, Alltrim(cNomApro) )	//05 Nome Aprovador
		aAdd(aEmail, Alltrim(cMaiApro) ) 	//06 Mail do Aprovador
			
			
		_aDadZPA:={} 
		aAdd(_aDadZPA,	ZPA->ZPA_PREFIX)  	//01
		aAdd(_aDadZPA,	ZPA->ZPA_NUM)		//02
		aAdd(_aDadZPA,	_cParcela)     		//03
		aAdd(_aDadZPA,	ZPA->ZPA_TIPO)       //04
		aAdd(_aDadZPA,	ZPA->ZPA_FORNEC)     //05
		aAdd(_aDadZPA,	ZPA->ZPA_LOJA)       //06
		aAdd(_aDadZPA,	ZPA->ZPA_DTEMIS)     //07
		aAdd(_aDadZPA,	ZPA->ZPA_VENCTO)     //08
		aAdd(_aDadZPA,	ZPA->ZPA_VALOR)      //09
		aAdd(_aDadZPA,	ZPA->ZPA_NATURE)     //10
		aAdd(_aDadZPA,	ZPA->ZPA_CC)         //11
		aAdd(_aDadZPA,	ZPA->ZPA_BANCO)      //12
		aAdd(_aDadZPA,	ZPA->ZPA_AGENC)      //13
		aAdd(_aDadZPA,	ZPA->ZPA_DIGAGE)     //14
		aAdd(_aDadZPA,	ZPA->ZPA_CONTA)      //15
		aAdd(_aDadZPA,	ZPA->ZPA_DIGCON)     //16
		aAdd(_aDadZPA,	ZPA->ZPA_NUMCHQ)     //17
		aAdd(_aDadZPA,	ZPA->ZPA_HISTCH)     //18
		aAdd(_aDadZPA,	ZPA->ZPA_BENEF)      //19
		aAdd(_aDadZPA,	ZPA->ZPA_HIST)       //20
		
		if U_WFAPFINPA(aEmail,_aDadZPA,ZPA->ZPA_TIPOPA,.T.)
		   /*cChave:=padr(_aDadZPA[1],3)+padr(_aDadZPA[2],9)+padr(_aDadZPA[3],2)+padr(_aDadZPA[4],3)+padr(_aDadZPA[5],6)+padr(_aDadZPA[6],2)
		   
		   DBSelectArea("ZPA")
			DBSetOrder(1)
			If DBSeek(xFilial("ZPA")+cChave,.F.)
				Reclock("ZPA",.F.) 
				ZPA->ZPA_STATUS := 'W'
				ZPA->ZPA_APROV1 := ''
				ZPA->ZPA_NAPRO1 := ''
				ZPA->ZPA_DTAPR1 := STOD('')
				ZPA->ZPA_HRAPR1 := ''
				ZPA->ZPA_APROV2 := ''
				ZPA->ZPA_NAPRO2 := ''
				ZPA->ZPA_DTAPR2 := STOD('')
				ZPA->ZPA_HRAPR2 := ''
				ZPA->ZPA_APROV3 := ''
				ZPA->ZPA_NAPRO3 := ''
				ZPA->ZPA_DTAPR3 := STOD('')
				ZPA->ZPA_HRAPR3 := ''
				ZPA->(MSUnlock())   
			Endif*/
			MSGINFO("E-mail enviado para cNomApro !","ALU_CADPA")
			
		endif		         
				
	ENDIF
	
EndIf

Restarea(_aAreaAnt)

Return   
          
          
**********************************************************
User Function WFAPFINPA(_aDadSol,_aDadTit,_cTipPa,_lReenv)//17/05/18 - Melhorias Financeiro 2019 - Fabio Yoshioka
**********************************************************
//Rotina criada para envio de WF aos aprovador (coordenador) do setor Financeiro, para não serem mais aprovados pela rotina STARSE2LB.PRW 

Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto 
Local cDadoTit 
Local lBaseProd := IIf(GetServerIP() == RTRIM(_cIpProd), .T.,.F.)
Local lOk := .F.  
Local _aTitulo:=aClone(_aDadTit)
Local _lPriori:=.f. //10/01/18
Local _cChaveSE2 := ""

IF ZPA->(FieldPos("ZPA_PRIORI")) > 0 //10/01/18 - Fábio Yoshioka
	if len(_aTitulo)>=21
		_lPriori:= iif(rtrim(_aTitulo[21])=='0',.T.,.F.)
	endif
endif 


IF rtrim(_cTipPa)=='1' //14/09/16
	_cTitulo:="TITULO DE PAGAMENTO ANTECIPADO"
Else
	_cTitulo:="ADIANTAMENTO A FUNCIONARIOS"
Endif                                                    

                           
cCodProcesso := "WF_106" 																	
cHtmlModelo :=rtrim(_cModelPA)+"AutorFinPA_Page.html"   

IF rtrim(_cTipPa)=='1'
	cAssunto := "Aprovação de Pagamento Antecipado a Fornecedores"	
Else
	cAssunto := "Aprovação de Adiantamento a Funcionarios "	
Endif                                                    

oProcess:= TWFProcess():New(cCodProcesso, cAssunto) 										
cTitulo :=  "WF_106" 																		
oProcess:NewTask(cTitulo, cHtmlModelo) 														
oHtml	:= oProcess:oHTML 

cDadoTit := padr(_aTitulo[1],3)+padr(_aTitulo[2],9)+padr(_aTitulo[3],2)+padr(_aTitulo[4],3)+padr(_aTitulo[5],6)+padr(_aTitulo[6],2)
DBSelectArea("ZPA")
DBSetOrder(1)
DBSeek(xFilial("ZPA")+cDadoTit)

//Dados do Cabeçalho
oProcess:oHtml:ValByName( "cTitPA" 	,_cTitulo) //14/09/16
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(_aDadSol[2]))
oProcess:oHtml:ValByName( "cCodSol" 	,_aDadSol[1])
oProcess:oHtml:ValByName( "cAprovador" ,Alltrim(_aDadSol[5]))
oProcess:oHtml:ValByName( "cCodAprov" 	,_aDadSol[4] )
oProcess:oHtml:ValByName( "cTipoFor" 	,IIF(rtrim(_cTipPa) == '1',"Fornecedor","Colaborador"))

oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(Posicione("SA2",1,XFILIAL("SA2")+_aTitulo[5]+_aTitulo[6],"A2_NOME")))
oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(_aTitulo[7]))
oProcess:oHtml:ValByName( "cDtPagto" 	,DTOC(_aTitulo[8]))
oProcess:oHtml:ValByName( "cValor" 		,Transform(_aTitulo[9],"@E 999,999,999.99"))
oProcess:oHtml:ValByName( "cMotivo" 	,Alltrim(_aTitulo[20]))
oProcess:oHtml:ValByName( "cPriori" 	,iif(_lPriori,"URGENTE","Normal") ) 
oProcess:oHtml:ValByName( "cTpLibera" 	,"VISTO")//18/05/19

DBSelectArea("SE2")//Incluida atualização do STARTSE2LB.PRW  - 18/05/19 - Fabio Yoshioka
DBSetOrder(1)
If DBSeek(xFilial("SE2")+cDadoTit)
	
	_cChaveSE2 := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
	
	//Gravando processo no titulo
	SE2->(Reclock("SE2",.F.))
	SE2->E2_WFID := oProcess:fProcessID
	SE2->(MSUnlock())
	
	//Gravando processo no controle, e populando a tabela
	DBSelectArea("ZE2")
	DBSetOrder(1)
	If DBSeek(xFilial("ZE2")+_cChaveSE2+"000",.F.)
	
		ZE2->(Reclock("ZE2",.F.))
		ZE2->ZE2_WFID := oProcess:fProcessID
		ZE2->ZE2_STATUS := "WF" //Em processo do Workflow
		ZE2->(MSUnlock())

	Else
	
		ZE2->(Reclock("ZE2",.T.))            
		ZE2->ZE2_FILIAL := SE2->E2_FILIAL
		ZE2->ZE2_PREFIX := SE2->E2_PREFIXO
		ZE2->ZE2_NUM 	:= SE2->E2_NUM
		ZE2->ZE2_PARCEL := SE2->E2_PARCELA
		ZE2->ZE2_TIPO 	:= SE2->E2_TIPO
		ZE2->ZE2_FORNEC	:= SE2->E2_FORNECE
		ZE2->ZE2_LOJA	:= SE2->E2_LOJA
		ZE2->ZE2_NOMFOR	:= SE2->E2_NOMFOR
		ZE2->ZE2_SEQ	:= "000"
		ZE2->ZE2_STATUS	:= "WF"
		ZE2->ZE2_USER 	:= "000000"
		ZE2->ZE2_NOMEUS	:= "Administrador"
		ZE2->ZE2_HISTOR	:= "INCLUSAO MANUAL DE TITULO ORIGEM (STARTSE2LB)"
		ZE2->ZE2_TPAPRO	:= "I" //Tipo de Aprovação: Liberação
		ZE2->ZE2_DTDIGI	:= SE2->E2_DIGIREA
		ZE2->ZE2_DTSOL	:= date()//dData
		ZE2->ZE2_HRSOL	:= SubStr(Time(),1,5)
		ZE2->ZE2_WFID := oProcess:fProcessID
		ZE2->(MSUnlock())
	EndIf	
	
EndIf		


//Função de retorno a ser executada quando a mensagem de respostas retornar ao Workflow:
oProcess:bReturn :=  "U_RetFWFPA()" 				

*********************************************	 					 
//Guardo o ID do Processo para enviar no link
*********************************************	 					 	
cMailID := oProcess:Start()

******************
//Enviando o Link!
******************
oHtml:SaveFile("web\ws\wflow"+"\"+cMailID+".HTM")     		//Salvo HTML do Processo
cRet := WFLoadFile("web\ws\wflow"+"\"+cMailID+".HTM")		//Carrego o link do Processo (será usado no retorno da Aprovação)

IF rtrim(_cTipPa)=='1' //14/09/16
	_cTitulo:="TITULO DE PAGAMENTO ANTECIPADO"
Else
	_cTitulo:="ADIANTAMENTO A FUNCIONARIOS"
Endif                                                    


IF rtrim(_cTipPa)=='1'
	cAssunto := "Aprovação de Pagamento Antecipado a Fornecedores"	
Else
	cAssunto := "Aprovação de Adiantamento a Funcionarios "	
Endif                                                    


cHtmlModelo :=rtrim(_cModelPA)+"AutorFinPA_Link.html"

//Inicio nova tarefa do Processo... O Link.
oProcess:NewTask(cAssunto, cHtmlModelo)      

                                           
//Dados do Cabeçalho
oProcess:oHtml:ValByName( "cTitPA" 	,_cTitulo) //14/09/16
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(_aDadSol[2]))
oProcess:oHtml:ValByName( "cCodSol" 	,_aDadSol[1])
oProcess:oHtml:ValByName( "cAprovador" ,Alltrim(_aDadSol[5]))
oProcess:oHtml:ValByName( "cCodAprov" 	,_aDadSol[4] )

oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(Posicione("SA2",1,XFILIAL("SA2")+_aTitulo[5]+_aTitulo[6],"A2_NOME")))
oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(_aTitulo[7]))
oProcess:oHtml:ValByName( "cDtPagto" 	,DTOC(_aTitulo[8]))
oProcess:oHtml:ValByName( "cValor" 		,Transform(_aTitulo[9],"@E 999,999,999.99"))
oProcess:oHtml:ValByName( "cMotivo" 	,Alltrim(_aTitulo[20])) 
oProcess:oHtml:ValByName( "cPriori" 	,iif(_lPriori,"URGENTE","Normal") ) //10/01/18

//Revisao do Workflow
_cIpTest:=SuperGetMV("AL_IPSRVTS",.f.,"172.28.1.20")
lServTeste := IIf(GetServerIP() == RTRIM(_cIpTest), .T.,.F.)

cServerIni := GetAdv97()
cSecao := "SRVWFLOW"
cPadrao := "undefined"
cIPLan := GetPvProfString(cSecao, "IPWFLAN", cPadrao, cServerIni)
cPtLan := GetPvProfString(cSecao, "PTWFLAN", cPadrao, cServerIni)
cIPWeb := GetPvProfString(cSecao, "IPWFWEB", cPadrao, cServerIni)
cPtWeb := GetPvProfString(cSecao, "PTWFWEB", cPadrao, cServerIni)



If !lServTeste //Servidor Produção

	oProcess:ohtml:ValByName("proc_localink",RTRIM(_cPrcSrvI)+cMailID+".htm")
	oProcess:ohtml:ValByName("proc_weblink",RTRIM(_cPrcSrvE)+cMailID+".htm")
	IF _lPriori //10/01/18
		oProcess:cSubject := iif(rtrim(_cTipPa)=='1',"ALUBAR LINK Para Autorização de Pagamento Antecipado.","ALUBAR LINK Para Autorização de Adiantamento a funcionarios.")+DTOC(dDataBase)
	ELSE
		oProcess:cSubject := iif(rtrim(_cTipPa)=='1',"ALUBAR LINK (URGENTE) Para Autorização de Pagamento Antecipado.","ALUBAR LINK Para Autorização de Adiantamento a funcionarios.")+DTOC(dDataBase)	
	ENDIF
	oProcess:cTo := Alltrim(UsrRetMail(cCodApro))+";"+Alltrim(GetMv("AL_MAILADM")) 
	cEndPage := RTRIM(_cPrcSrvI)+cMailID+".htm"
	
Else //Servidor Base_teste   
	oProcess:ohtml:ValByName("proc_localink",RTRIM(_cPrcSrvI)+cMailID+".htm")
	cEndPage := RTRIM(_cPrcSrvI)+cMailID+".htm"    
	
	IF _lPriori //10/01/18
		oProcess:cSubject := iif(rtrim(_cTipPa)=='1',"TESTE ALUBAR LINK (URGENTE) Para Autorização de Pagamento Antecipado.","ALUBAR LINK Para Autorização de Adiantamento a funcionarios.")+DTOC(dDataBase)
	ELSE
		oProcess:cSubject := iif(rtrim(_cTipPa)=='1',"TESTE ALUBAR LINK Para Autorização de Pagamento Antecipado.","ALUBAR LINK Para Autorização de Adiantamento a funcionarios.")+DTOC(dDataBase)
	ENDIF
	oProcess:cTo := Alltrim(GetMv("AL_MAILADM")) 

EndIf	
oProcess:Start()                         


//Se rodou até aqui...
lOk := .T.          

/*if lOk 
	if rtrim(_cTipPa)=='1'
		MSGINFO("E-mail enviado para o aprovador do setor de compras!","ALU_CADPA")
	else
		MSGINFO("E-mail enviado para aprovação pela gerencia do setor!","ALU_CADPA")	
	endif
endif*/

Return(lOk)          
                



**************************************
Static Function ValAPVFin(_cCargoAPV) //18/05/19
**************************************
Local lRet := .F. 

DBSelectArea("ZPB")
DBSetOrder(1)
DBSeek(xFilial("ZPB")+"FINANC")
Do While !EOF() .and. xFilial("ZPB") == ZPB->ZPB_FILIAL .and. ZPB->ZPB_COD == 'FINANC'            
	//Coordenador financeiro é o primeiro que aprova
	If UPPER(RTRIM(ZPB->ZPB_CARGO)) == UPPER(RTRIM(_cCargoAPV))
		cCodApro := ZPB->ZPB_CODUSR
		lRet := .T.
	 	Exit
	End If

	ZPB->(DBSkip())
End Do       

//aTUALIZO VARIAVEIS PRIVADAS
cCodSol:= ZPA->ZPA_SOLICI
cNomSol:= ZPA->ZPA_NOMESO
cMaiSol:=UsrRetMail(ZPA->ZPA_SOLICI)
cNomApro:=UsrRetName(cCodApro)
cMaiApro:=UsrRetMail(cCodApro)
       
Return lRet      


*********************************
User Function RetFWFPA(oProcess) //processo de retorno - apos confirmação ou rejeição pelo aprovador 
*********************************
                       
Local oHtml 		:= oProcess:oHtml  
Local cChave 		:= oProcess:oHtml:RetByName("cDadoTit")  
Local lYESNO		:= IIF(oProcess:oHtml:RetByName("RBAPROVA") = "Sim",.T.,.F.)
Local cCodAprov	:= oProcess:oHtml:RetByName("cCodAprov") 
Local cCodSolic	:= oProcess:oHtml:RetByName("cCodSol") 
Local cMotivo		:= oProcess:oHtml:RetByName("LBMOTIVO")  
Local aChave := {}         
Local _lTemSe2:=.F.
Local cCargoApro := Posicione("ZPB",2,xFilial("ZPB")+"FINANC"+cCodAprov,"ZPB_CARGO")
Private lMsErroAuto 	:= .F.
Private lMsHelpAuto 	:= .F.  
Private _cCustPA:=GetMV("AL_CCUSTPA")//10/08/16     
Private _cNatuPA:=GetMV("AL_NATURPA")//10/08/16     


Conout("RetWFPA: " +cChave)
DBSelectArea("ZPA")
DBSetOrder(1)
If DBSeek(xFilial("ZPA")+cChave,.F.)
		
	DBSelectArea("ZE2")
	DBSetOrder(1)
	If DBseek(xFilial("ZE2")+cChave+"000",.F.)
		Conout("Debug Atualizando SE2 Recno: " + aTitulos[ni] )          
		*********************************
		//Gravação do Histórico do titulo
		*********************************
		cHist := "RETORNO PARA LIBERACAO PAGTO - APROVADO EM "+DTOC(dDataBase)+" AS "+SubStr(Time(),1,5)+" POR "+ UsrRetName(cCodAprov)
	
		//Para gravar histórico do titulo ZPD                   
		aParamSE2 := {}
		aAdd(aParamSE2, SE2->E2_PREFIXO	)                                                                                                              
		aAdd(aParamSE2, SE2->E2_NUM		)
		aAdd(aParamSE2, SE2->E2_PARCELA	)
		aAdd(aParamSE2, SE2->E2_TIPO	)
		aAdd(aParamSE2, SE2->E2_FORNECE	)
		aAdd(aParamSE2, SE2->E2_LOJA	)
		aAdd(aParamSE2, cCodAprov 		)
		aAdd(aParamSE2, cHist			)
		aAdd(aParamSE2, ""				)
		U_GravaHist(aParamSE2)
	
		Do Case                   
			//Caso seja o coordenador aprovo apenas o Nivel 1
			Case cCargoApro == 'C'
				Conout("Aprovado pelo coordenador")					
				RecLock("ZE2",.F.)
				ZE2->ZE2_APROV1 := cCodAprov
				ZE2->ZE2_NAPRO1 := UsrRetName(cCodAprov)
				ZE2->ZE2_DTAPR1 := dDataBase
				ZE2->ZE2_HRAPR1 := SubStr(Time(),1,5)
				MSUnlock()		
	       
				If _lCtrlPA
					U_AltStPA(ZE2->ZE2_FILIAL+ZE2->ZE2_PREFIX+ZE2->ZE2_NUM+ZE2->ZE2_PARCEL+ZE2->ZE2_TIPO+ZE2->ZE2_FORNEC+ZE2->ZE2_LOJA,'V',cCodAprov,UsrRetName(cCodAprov))    
				Endif
				
				//Pegando o próximo Aprovador... O Gerente
				DBSelectArea("ZPB")
				DBSetOrder(1)
				DBSeek(xFilial("ZPB")+"FINANC")
				Do While !EOF() .and. ZPB->ZPB_FILIAL + ZPB->ZPB_COD = xFilial("ZPB") + 'FINANC' 
	
					IF ZPB->ZPB_CARGO == 'G' 
						Conout("Proximo Aprovador "+ZPB->ZPB_CODUSR)
						cNextApro := ZPB->ZPB_CODUSR
						Exit
					EndIf
					DBSkip()
				End Do		
					
			//Caso o aprovador seja o Gerente... Deve-se aprovar os niveis 2 e 3		
		 /*  Case cCargoApro == 'G'
				Conout("Aprovado pelo Gerente")
				RecLock("ZE2",.F.)
				ZE2->ZE2_APROV2 := cCodAprov
				ZE2->ZE2_NAPRO2 := UsrRetName(cCodAprov)
				ZE2->ZE2_DTAPR2 := dDataBase
				ZE2->ZE2_HRAPR2 := SubStr(Time(),1,5)
				ZE2->ZE2_APROV3 := "******"
				ZE2->ZE2_NAPRO3 := "******"
				ZE2->ZE2_DTAPR3 := dDataBase
				ZE2->ZE2_HRAPR3 := SubStr(Time(),1,5)
				ZE2->ZE2_STATUS := "OK"
				MSUnlock()  
				
				
				//Atualizo informações de PA se houver - 18/08/16 - Fabio Yoshioka
				If _lCtrlPA
					U_AltStPA(ZE2->ZE2_FILIAL+ZE2->ZE2_PREFIX+ZE2->ZE2_NUM+ZE2->ZE2_PARCEL+ZE2->ZE2_TIPO+ZE2->ZE2_FORNEC+ZE2->ZE2_LOJA,'X',cCodAprov,UsrRetName(cCodAprov))    
				EndIf
				
				DBSelectArea("SE2")
				DBSetOrder(1)
				If DBSeek(xFilial("SE2")+cChave,.F.)
					Conout("Titulo Liberado "+SE2->E2_NUM)
					SE2->(RecLock("SE2",.F.))
					SE2->E2_STATWF := "LB"
					SE2->(MSUnlock())
				EndIf*/
								
		End Case				
  		    
  	Else
  		Conout("Nao achei ZE2: " + cChave )          
  	EndIf
  	
else
	Conout("Nao achei ZPA: " + cChave )		
End If
        

Return()

//15/07/19  Projeto 1.01.03.03 – Notificação de Pagamento Antecipado a Fornecedores - Fabio Yoshioka
*********************************************
Static Function NotifSup(_aDadSupr,_cSolSupr) 
*********************************************
Local cCodProcesso, cCodStatus, cHtmlModelo, oHtml, oProcess
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto 
Local cDadoTit 
Local lBaseProd := IIf(GetServerIP() == '172.28.1.24', .T.,.F.)
Local lOk := .F.
Local _lPriori:=.f.
Local _cMailSupri:=GetNewPar("AL_EMSUPRI","compras-l@alubar.net") //17/07/19



cCabec := "NOTIFICAÇÃO DE PAGAMENTO ANTECIPADO"
cTexto := "Informados que o Pagamento Antecipado (PA) foi EFETUADO pelo setor Financeiro"		

                           
cCodProcesso := "WF_106" 																	
cHtmlModelo := "\Workflow\WF_HTMLV2\ADM\Alcada_CP\Notifica_PGTO_PA.html"
cAssunto := "Efetivação de Pagamento Antecipado"	
oProcess:= TWFProcess():New(cCodProcesso, cAssunto) 										
cTitulo :=  "WF_106" 																		
oProcess:NewTask(cTitulo, cHtmlModelo) 														
oHtml	:= oProcess:oHTML

_cTitulo:="EFETIVAÇÃO DE TITULO DE PAGAMENTO ANTECIPADO"


/*
					1- aAdd(_aNotSupri,ZPA->ZPA_PREFIX)  	//01
					2- aAdd(_aNotSupri,ZPA->ZPA_NUM)		//02
					3- aAdd(_aNotSupri,ZPA->ZPA_PARCEL)    //03
					4- aAdd(_aNotSupri,ZPA->ZPA_TIPO)      //04
					5- aAdd(_aNotSupri,ZPA->ZPA_FORNEC)    //05
					6- aAdd(_aNotSupri,ZPA->ZPA_LOJA)      //06					
					7- aadd(_aNotSupri,ZPA->ZPA_DTEMIS)	
					8- aadd(_aNotSupri,Alltrim(UsrRetName(ZPA->ZPA_SOLICI)))
					9- aadd(_aNotSupri,ZPA->ZPA_SOLICI)				
					10- aadd(_aNotSupri,Alltrim(ZPA->ZPA_NOMFOR)+" ("+ZPA->ZPA_FORNEC+")")
					11- aadd(_aNotSupri,ZPA->ZPA_VALOR) 
					12- aadd(_aNotSupri,ZPA->ZPA_HIST)					
					13- aadd(_aNotSupri,ZPA->ZPA_PZENNF)
					14- aadd(_aNotSupri,ZPA->ZPA_PEDIDO)	
					15- aadd(_aNotSupri,ZPA_PRIORI)
					16- aadd(_aNotSupri,DTOC(ZPA->ZPA_VENCTO))
					17- aadd(_aNotSupri,_cUsuar)
					
					aAdd(_aNotSupri,ZPA->ZPA_PREFIX)  	//01
					aAdd(_aNotSupri,ZPA->ZPA_NUM)		//02
					aAdd(_aNotSupri,ZPA->ZPA_PARCEL)    //03
					aAdd(_aNotSupri,ZPA->ZPA_TIPO)      //04
					aAdd(_aNotSupri,ZPA->ZPA_FORNEC)    //05
					aAdd(_aNotSupri,ZPA->ZPA_LOJA)      //06					
					aadd(_aNotSupri,ZPA->ZPA_DTEMIS)	
					aadd(_aNotSupri,Alltrim(ZPA->ZPA_NOMESO))
					aadd(_aNotSupri,ZPA->ZPA_SOLICI)				
					aadd(_aNotSupri,Alltrim(ZPA->ZPA_NOMFOR)+" ("+ZPA->ZPA_FORNEC+")")
					aadd(_aNotSupri,ZPA->ZPA_VALOR) 
					aadd(_aNotSupri,ZPA->ZPA_HIST)					
					aadd(_aNotSupri,ZPA->ZPA_PZENNF)
					aadd(_aNotSupri,ZPA->ZPA_PEDIDO)	
					aadd(_aNotSupri,ZPA_PRIORI)
					aadd(_aNotSupri,ZPA->ZPA_VENCTO)
					aadd(_aNotSupri,_cUsuar)

*/
                 
                 
cDadoTit:=_aDadSupr[1]+_aDadSupr[2]+_aDadSupr[3]+_aDadSupr[4]+_aDadSupr[5]+_aDadSupr[6]

//Dados do Cabeçalho
oProcess:oHtml:ValByName( "cTitPA" 	,	_aDadSupr[2]) //14/09/16
oProcess:oHtml:ValByName( "cCabec" 		,cCabec)
oProcess:oHtml:ValByName( "cEmissao" 	,DTOC(dDataBase))
oProcess:oHtml:ValByName( "cHora" 		,SUBSTR(Time(),1,5))
oProcess:oHtml:ValByName( "cSolicit" 	,Alltrim(_aDadSupr[8]))
oProcess:oHtml:ValByName( "cCodSol" 	,_aDadSupr[9])
oProcess:oHtml:ValByName( "cPagador" ,Alltrim(UsrRetName(_aDadSupr[17])))
oProcess:oHtml:ValByName( "cTexto" 		,cTexto )
oProcess:oHtml:ValByName( "cDadoTit" 	,cDadoTit )
oProcess:oHtml:ValByName( "cNomeFor" 	,Alltrim(_aDadSupr[10])) 
oProcess:oHtml:ValByName( "cDtEmiss" 	,DTOC(_aDadSupr[7]))
oProcess:oHtml:ValByName( "cPedCom" 	,ALLTRIM(_aDadSupr[14]))
oProcess:oHtml:ValByName( "cDtPagto" 	,DTOC(_aDadSupr[16]))
oProcess:oHtml:ValByName( "cValor" 		,Transform(_aDadSupr[11],"@E 999,999,999.99"))
oProcess:oHtml:ValByName( "cMotivo" 	,Alltrim(_aDadSupr[12]))
oProcess:oHtml:ValByName( "cPriori" 	,IIF(_aDadSupr[15]=="0","URGENTE","Normal")) //10/01/18


//Revisao do Workflow
_cIpTest:=SuperGetMV("AL_IPSRVTS",.f.,"172.28.1.12")
lServTeste := IIf(GetServerIP() == RTRIM(_cIpTest), .T.,.F.)
If !lServTeste //Servidor Produção
	cDestinat:=UsrRetMail(_aDadSupr[5])
	oProcess:cSubject := "ALUBAR "+cCabec+" de Pagamento Antecipado."+DTOC(dDataBase)
	oProcess:cTo := cDestinat+";"+Alltrim(_cMailSupri)+";"+Alltrim(GetMv("AL_MAILADM")) 
Else //Servidor Base_teste
	oProcess:cSubject := "TESTE ALUBAR "+cCabec+" de Pagamento Antecipado."+DTOC(dDataBase)
	oProcess:cTo := Alltrim(GetMv("AL_MAILADM"))
EndIf	

/*cDestinat:=UsrRetMail(_aDadSupr[5])
oProcess:cSubject := "ALUBAR "+cCabec+" de Pagamento Antecipado."+DTOC(dDataBase)
oProcess:cTo := cDestinat+";"+Alltrim(_cMailSupri)+";"+Alltrim(GetMv("AL_MAILADM"))*/

oProcess:Start()                         
oProcess:Finish()

Return    

