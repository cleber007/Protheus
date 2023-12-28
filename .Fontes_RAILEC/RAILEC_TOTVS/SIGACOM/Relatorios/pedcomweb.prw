#Include "topconn.ch"
#Include "SHELL.CH"
#Include "rwmake.ch"
#Include "Protheus.ch"                                

#Define CRLF ( chr(13)+chr(10) )
#Define cPath   "C:\RELATO\"
#Define lDrive  "C"

User Function PedComWeb(cNumPC,cFornece,cLoja)

	U_CriaDir()
	CriaCSS()
	CriaHtml(cNumPC,cFornece,cLoja)
	
Return
///////////////////////////////////////////////////////////////////////////
Static Function CriaHtml(cNumPC,cFornece,cLoja)
	
Local cArq    	:= cNumPC+".Html"
Local lMSg	  	:= .T.
Local nHandle 	:= FCreate(cPath+cArq)
Local nCount 	:= nDesc:= nFrete := nIPI := nICMS:= nBruto := nValLiq := 0

/*--------------------------------------------------------------+
|Informações da Empresa											|
+--------------------------------------------------------------*/
cEmpNome	:= Trim(SM0->M0_NOMECOM)
cEmpEnd		:= Trim(SM0->M0_ENDENT)
cEmpBairro	:= Trim(SM0->M0_BAIRENT)
cEmpCEP		:= Transform(SM0->M0_CEPENT,"@R 99999-999")
cEmpCid		:= Rtrim(SM0->M0_CIDENT)
cEmpEst		:= Trim(SM0->M0_ESTENT)
cEmpTel		:= Trim(SM0->M0_TEL)
cEmpFaX		:= Trim(SM0->M0_FAX)
cEmpCNPJ	:= Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
cEmpIEST	:= Rtrim(SM0->M0_INSC)

/*--------------------------------------------------------------+
|Informações do Pedido											|
+--------------------------------------------------------------*/
cQrySC7:=" Select * From "+RetSqlName("SC7")
cQrySC7+=" Where D_E_L_E_T_<>'*'"
cQrySC7+=" and C7_FILIAL='"+XFILIAL("SC7")+"' "
cQrySC7+=" and C7_NUM = '" + cNumPC + "' "
cQrySC7+="  AND C7_FORNECE = '"+cFornece+"'"
cQrySC7+="  AND C7_LOJA = '"+cLoja+"'"
 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySC7), 'TMPSC7', .T., .T.)
dbSelectArea("TMPSC7")
dbGoTop()

EMISSAO		:= TMPSC7->C7_EMISSAO
CODFORN		:= TMPSC7->C7_FORNECE
CONTATO		:= TMPSC7->C7_CONTATO
CODCF		:= TMPSC7->C7_CLIFIM
LOJACF		:= TMPSC7->C7_LOJACF
NOMCF		:= TMPSC7->C7_NOMCLI
cPCCotFor	:= TMPSC7->C7_COTAFOR
CONTA		:= TMPSC7->C7_CONTA
SC			:= TMPSC7->C7_NUMSC
CPTICMS		:= Iif(empty(TMPSC7->C7_ENICMS),PerIcms(cNumPC,cFornece,cLoja),TMPSC7->C7_ENICMS)
CPTIPI		:= Iif(empty(TMPSC7->C7_ENIPI),PerIpi(cNumPC,cFornece,cLoja),TMPSC7->C7_ENIPI)
CPTPISCO	:= TMPSC7->C7_ENPISCO
CPTATO		:= TMPSC7->C7_ATODEC
CPTLOCAL	:= TMPSC7->C7_ENTREGA
CPTPGTO		:= TMPSC7->C7_CONDPAG
CPTFAT		:= TMPSC7->C7_FATURA	
CPTCOBRA	:= TMPSC7->C7_COBRANC
COTAFOR  	:= TMPSC7->C7_COTAFOR
PRAZOENT	:= If(CtoD(TMPSC7->C7_DATPRF) > CtoD(TMPSC7->C7_EMISSAO),Strzero(CtoD(TMPSC7->C7_DATPRF)-CtoD(TMPSC7->C7_EMISSAO),3)+" dia(s)  -  ","")+TMPSC7->C7_DATPRF
PedPICMS	:= TMPSC7->C7_PICM
PedForPag	:= Posicione("SX5",1,xFilial("SX5")+"24"+ TMPSC7->C7_FORPAG,"X5_DESCRI")
PedConPag	:= POSICIONE("SE4", 1, xFilial("SE4") + TMPSC7->C7_COND,"E4_DESCRI")
PedTPFret	:= RetTipoFrete(TMPSC7->C7_TPFRETE)


/*--------------------------------------------------------------+
|Informações do Formecedor										|
+--------------------------------------------------------------*/
cQrySA2:= " SELECT * "
cQrySA2+= " From "+RetSqlName("SA2") "
cQrySA2+= " Where D_E_L_E_T_<>'*' "
cQrySA2+= " AND A2_FILIAL='"+XFILIAL("SA2")+"' "
cQrySA2+= " AND A2_COD = '"+cFornece+"'"
cQrySA2+= " AND A2_LOJA = '"+cLoja+"'"
 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySA2), 'TMPSA2', .T., .T.)
dbSelectArea("TMPSA2")
dbGoTop()

cForNome	:= TMPSA2->A2_NOME
cForTel		:= TMPSA2->A2_TEL
cForFaX		:= TMPSA2->A2_FAX
cForEnd		:= Rtrim(TMPSA2->A2_END)+If(!Empty(TMPSA2->A2_NR_END),", "+TMPSA2->A2_NR_END,"")
cForBair	:= TMPSA2->A2_BAIRRO
cForCid		:= TMPSA2->A2_MUN
cForCep		:= Transform(TMPSA2->A2_CEP,"@R 99999-999")
cForEst		:= TMPSA2->A2_EST
cForCNPJ	:= Transform(TMPSA2->A2_CGC,If(Len(Rtrim(TMPSA2->A2_CGC))=14,"@R 99.999.999/9999-99","@R 999.999.999-99"))
cForIEST	:= TMPSA2->A2_INSCR
cForBanco	:= TMPSA2->A2_BANCO
cForAgen	:= TMPSA2->A2_AGENCIA
cForCont	:= TMPSA2->A2_NUMCON
cForCnto	:= TMPSA2->A2_CONTATO
CForEmail	:= TMPSA2->A2_EMAIL


/*--------------------------------------------------------------+
|Informações do Cliente											|
+--------------------------------------------------------------*/
cQrySA1:= " SELECT * "
cQrySA1+= " From "+RetSqlName("SA1") "
cQrySA1+= " Where D_E_L_E_T_<>'*' "
cQrySA1+= " AND A1_FILIAL='"+XFILIAL("SA1")+"' "
cQrySA1+= " AND A1_COD = '"+CODCF+"'"
cQrySA1+= " AND A1_LOJA = '"+LOJACF+"'"
 
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySA1), 'TMPSA1', .T., .T.)
dbSelectArea("TMPSA1")
dbGoTop()

cCliTel		:= TMPSA1->A1_TEL
cCliEnd		:= Rtrim(TMPSA1->A1_END)
cCliBair	:= TMPSA1->A1_BAIRRO
cCliCid		:= TMPSA1->A1_MUN
cCliCEP		:= Transform(TMPSA1->A1_CEP,"@R 99999-999")
cCliEst		:= TMPSA1->A1_EST
cCliCNPJ	:= Transform(TMPSA1->A1_CGC,If(Len(Rtrim(TMPSA1->A1_CGC))=14,"@R 99.999.999/9999-99","@R 999.999.999-99"))
cCliIEST	:= TMPSA1->A1_INSCR
cCliEMAIL	:= Alltrim(TMPSA1->A1_EMAIL)
//cCliEMAIL2 	:= AllTrim(TMPSA1->A1_EMAIL2)
cCliContact := Rtrim(TMPSA1->A1_CONTATO)

If nHandle < 0
	MsgAlert("Erro durante criação do arquivo.")
Else
  cHtml := '  <!DOCTYPE html> <html lang="pt"> <head> <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '  <meta charset="ISO-8859-1" />																											'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' <html>																																	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' <head>																																	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' <title>'+cNumPC+'</title>																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' <link href="C:\RELATO\pedcomweb.css" rel="stylesheet" type="text/css">																	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' </head>																																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '   <body>																																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 	  <header>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))   
  cHtml := ' 		    <table style="text-align: left; width: 100%" cellpadding="2" cellspacing="2">												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		      <tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		        <tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		          <td style="width: auto"><img src="http://sigacorp.com.br/alubar/Energia_Log.png" alt="Logo Alubar Energia"></td>		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml)) 
  cHtml := ' 		          <td style="width: 100%; background-color: rgb(44, 176, 220)"><span class="trel" >ORDEM DE COMPRA Nº: '+cNumPC+'</td>	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		        </tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		      </tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		    </table>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		    <table style="text-align: left; width: 100%" cellpadding="2" cellspacing="2">												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))					
  cHtml := ' 		      <tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		        <tr align="center">																										'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		          <td style="width: 70%" class="ttab">Controle e Aplicação</td>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		       </tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		      <tr>																														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		       	<td>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))						
  cHtml := ' 							REFERÊCIA:<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 							NÚMERO:'+cNumPC+'<br>  																						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 							EMISSÃO:'+EMISSAO+'																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		 		    </td>																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		      </tr>																														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))		
  cHtml := ' 		      </tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		    </table>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		    <table style="text-align: left; width: 100%" cellpadding="2" cellspacing="2">												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))													
  cHtml := ' 		      <tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		      	<tr align="center">																										'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 							<td style="width: 100%" class="ttab" colspan="2" rowspan="1">Dados de Cliente Final</td>					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))														
  cHtml := ' 				  	</tr>																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		      	<tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		        	<td style="width: 50%">																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))					
  IF	empty(CODCF)
    cHtml :='						EMPRESA: '+Trim(SM0->M0_NOMECOM)+'<br>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						ENDEREÇO: '+Trim(SM0->M0_ENDENT)+" - "+Trim(SM0->M0_BAIRENT)+'<br>												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CEP.: '+Transform(SM0->M0_CEPENT,"@R 99999-999")+'<br>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CIDADE: '+Rtrim(SM0->M0_CIDENT)+'<br>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						ESTADO: '+SM0->M0_ESTENT+'<br>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CONTATO: '+UsrFullName (RetCodUsr())+' 																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='			  		</td>																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='            		<td style="width: 50%";><br>																						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))				
    cHtml :='						CNPJ: '+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+'<br>													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						INSC. EST.: '+Rtrim(SM0->M0_INSC)+'<br>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						TEL.: '+Trim(SM0->M0_TEL)+'<br>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CEL.: '+Trim(SM0->M0_FAX)+'<br>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						E-MAIL: '+UsrRetMail(RetCodUsr())+'																				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))  
  Else 
    cHtml :='						EMPRESA: '+NOMCF+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))																				
    cHtml :='						ENDEREÇO: '+cCliEnd+" - "+cCliBair+'<br>																		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CEP.: '+cCliCEP+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CIDADE: '+cCliCid+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						ESTADO: '+cCliEst+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CONTATO: '+cCliContact+' 																						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='			  		</td>																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='            		<td style="width: 50%";><br>																						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CNPJ: '+cCliCNPJ+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						INSC. EST.: '+cCliIEST+'<br>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						TEL.: '+cCliTel+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						CEL.: '+cCliTel+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml :='						E-MAIL: '+cCliEMAIL+'																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  EndIF                                                             								
  cHtml := ' 					</td>																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 				  </tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		    	</tbody>																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		    </table>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		    <table style="text-align: left; width: 100%" cellpadding="2" cellspacing="2">												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))				
  cHtml := ' 		      <tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		        <tr align="center">																										'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		          <td style="width: 100%"; colspan="2" rowspan="1"; class="ttab">														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		          Dados do Fornecedor																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		          </td>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		        </tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		        <tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml)) 
  cHtml := ' 		          <td style="width: 50%">																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            RAZÃO SOCIAL:'+cForNome+'<br>																						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            ENDEREÇO:'+cForEnd+" - "+cForBair+' <br>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '		            CEP.:'+cForCep+' <br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            CIDADE:'+cForCid+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            ESTADO:'+cForEst+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            CONTATO:'+cForCnto+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		          </td>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		          <td style="width: 50%">																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            CNPJ:'+cForCNPJ+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            INSC. EST.:'+cForIEST+' <br>																						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            TEL.:'+cForTel+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            CEL.:'+cForFaX+' <br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            E-MAIL:'+CForEmail+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		            <b>COTAÇÃO:'+cPCCotFor+'</b>																						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		          </td>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		        </tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		      </tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		    </table>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 	</header>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '   <table style="text-align: left; width: 100%" cellpadding="2" cellspacing="2">														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '     <tbody>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '       <tr class="pg-break" align="center">																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style="width: 100%" colspan="9" rowspan="1"; class="ttab">Descrições de Materiais</td></tr>								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 02%" class="tneg">Item</td>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 04%" class="tneg">Produto</td>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 02%" class="tneg">Unid.</td>																				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 04%" class="tneg">Qtd.</td>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 38%" class="tneg">Descrição</td>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 15%" class="tneg">Observação</td>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 15%" class="tneg">Cent.Cust.</td>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 10%" class="tneg">Uniário R$</td>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td style=" width: 10%" class="tneg">Total R$</td>																				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '       </tr>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  
  dbSelectArea("TMPSC7")
  dbGoTop()
  While !Eof()	
  	IT			:= StrZero(Val(TMPSC7->C7_ITEM),3)	
  	CODPROD		:= TMPSC7->C7_PRODUTO
  	NCM			:= POSICIONE("SB1",1,xFilial("SB1")+CODPROD,"B1_POSIPI")
  	UM			:= TMPSC7->C7_UM
  	QUANT		:= TMPSC7->C7_QUANT
  	DESPROD		:= TMPSC7->C7_DESCRI
  	OBS			:= TMPSC7->C7_OBS
  	CC			:= Rtrim(TMPSC7->C7_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+TMPSC7->C7_CC,"CTT_DESC01")
  	UNIT		:= TMPSC7->C7_PRECO
  	IPI			:= TMPSC7->C7_IPI
  	VALOR		:= TMPSC7->C7_TOTAL
  	VALDESC		:= TMPSC7->C7_VLDESC
  	VALIPI		:= TMPSC7->C7_VALIPI
  	VALFRET		:= TMPSC7->(C7_VALFRE+C7_DESPESA)
  	PedVICMS	:= TMPSC7->C7_VALICM
  	
  	  																													
    cHtml := '       <tr  class="pg-break" align="center">																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '   	   <td style=" width: 02%">'+Rtrim(IT)+'</td>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '         <td style=" width: 04%">'+CODPROD+'</td>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '         <td style=" width: 02%">'+UM+'</td>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '         <td style=" width: 04%">'+Transform(QUANT,"@E 999,999.99")+'</td>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '         <td style=" width: 38%;text-align:left">'+Rtrim(DESPROD)+'</td>																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '         <td style=" width: 15%">'+OBS+'</td>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '         <td style=" width: 15%">'+Rtrim(CC)+'</td>																					'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '         <td style=" width: 10%">'+Transform(UNIT,"@E 9,999,999.9999")+'</td>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '         <td style=" width: 10%">'+Transform(VALOR,"@E 99,999,999.99")+'</td>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
    cHtml := '       </tr>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
   	
   	nDesc   += VALDESC
	nFrete  += VALFRET
	nIPI    += VALIPI
	nBruto  += VALOR
	nICMS	+= PedVICMS
	nValLiq := nBruto+nFrete+nIPI-nDesc
	//nValLiq := nBruto-nIPI-nDesc-nICMS 05/10/2023
	dbSkip()
  End   
  cHtml := '       <tr align="center">																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 		 <td class="ttotal" colspan="2" rowspan="1"><b>Desconto:<br/>		'+Transform(nDesc,  "@E 999,999.99")+'</b></td>				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td class="ttotal" colspan="2" rowspan="1"><b>Frete:<br/>			'+Transform(nFrete, "@E 999,999.99")+'</b></td>				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td class="ttotal" colspan="1" rowspan="1"><b>ICMS:<br/>			'+Transform(nICMS,  "@E 999,999.99")+'</b></td>				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td class="ttotal" colspan="1" rowspan="1"><b>IPI:<br/>			'+Transform(nIPI,   "@E 999,999.99")+'</b></td>				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td class="ttotal" colspan="2" rowspan="1"><b>Valor Bruto:<br/>	'+Transform(nBruto, "@E 999,999,999.99")+'</b></td>				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td class="ttotal" colspan="3" rowspan="1"><b>Valor Líquido:<br/>	'+Transform(nValLiq,"@E 999,999,999.99")+'</b></td>				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '       </tr>   																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '     </tbody>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '   </table>																																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  
  cHtml := '   <table style="text-align: left; width: 100%" cellpadding="2" cellspacing="2"; class="pg-break">										'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))		
  cHtml := '     <tbody>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))	
  cHtml := ' 	   <tr align="center">																												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))	
  cHtml := '    	  <td style="width: 100%"; colspan="2" rowspan="1"; class="ttab">																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))	
  cHtml := '    		  Dados do Financeiros																										'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))	
  cHtml := '    	  </td>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))	
  cHtml := '       </tr>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))	
  cHtml := '       <tr>																																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))	
  cHtml := ' 	     <td style="width: 30%"; class="tfin">																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))				
  cHtml := '   			 Forma Pag.: '+PedForPag+'<br>																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '   			 Condição Pag.: '+PedConPag+' 																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))		
  cHtml := '         </td>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))	
  cHtml := '      	 <td style="width: auto"; class="tfin">																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))					
  If empty(CODCF)	
  	if Upper(alltrim(PedConPag))<>'ORCAMENTO'
  		cHtml := PedSE2(cNumPC,cFornece,cLoja)																											+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
   	endif   	
  EndIF
  cHtml := '         </td>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))															
  cHtml := '   	   </tr>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '     </tbody>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '  </table>																																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))			 
  
  cHtml := '   <div id="info" class="pg-break">																										'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '     <table style="width: 100%" cellpadding="2" cellspacing="2">																		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '       <tbody>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <tr>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '           <td style=" width: 100%; " class="tavs">																						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '             FAVOR COLOCAR O NÚMERO DESSA ORDEM DE COMPRA NA NOTA FISCAL<br>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '             NOTAS FISCAIS NÃO DEVEM SER EMITIDAS ENTRE OS DIAS 25 e 31 DE CADA MÊS														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '           </td>																														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         </tr>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '      </tbody>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '     </table>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '     <table style=" width: 100%" cellpadding="2" cellspacing="2">																		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '       <tbody>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '           <td>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '             <table style=" width: 100%"  cellpadding="2" cellspacing="2">																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%; text-align: center" class="ttab">CONDIÇÕES COMERCIAIS</td></tr>							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">ICMS:'+CPTICMS+'</td></tr>																		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">IPI:'+CPTIPI+'</td></tr>																			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml)) 
  cHtml := '                 <tr><td style="width: 100%">PIS/COFINS:'+CPTPISCO+'</td></tr>																	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">LOCAL DE ENTREGA:'+CPTLOCAL+'</td></tr>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">EMBALAGEM:Inclusa</td></tr>																	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">FRETE:>'+PedTPFret+'</td></tr>																		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">CONDIÇÕES DE PGTO:'+CPTPGTO+'</td></tr>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">PRAZO DE ENTREGA:'+PRAZOENT+'</td></tr>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">FINANCEIRO:</td></tr>																				'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">FATURAMENTO:'+CPTFAT+'</td></tr>																	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">COBRANÇA:'+CPTCOBRA+'</td></tr>																	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">BANCO:'+cForBanco+'</td></tr>																		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">AGÊNCIA:'+cForAgen+'CONTA:'+cForCont+'</td></tr>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">MATERIAIS:a descrição dos materiais na nota fiscal deverá ser conforme ordem de compra.</td></tr>'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%">COMPRADOR:'+Trim(SM0->M0_NOMECOM)+'</td></tr>												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%"><strong>Mensagem:'+CPTATO+'</strong></td></tr>												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '                 <tr><td style="width: 100%" class="tavs">ENVIAR O PICQ NO MOMENTO DO RECEBIMENTO DESSA ORDEM DE COMPRA</td></tr>		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               </tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '             </table>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         </td>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         <td>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '           <table style=" width: 100%"  cellpadding="2" cellspacing="2">																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '             <tbody>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr><td style="width: 100%" class="ttab">CONTATOS ALUBAR ENERGIA S.A</td></tr>											'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr><td style="width: 100%" class="tneg">Suprimento / Logística</td></tr>												'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr><td style="width: 100%">'+GetNewPar("EN_SUPNAME","Bruna Lima")+'<br>Tel.: '+GetNewPar("EN_SUPFONE","(51) 3328-7230")+'<br>E-mail: '+GetNewPar("EN_SUPMAIL","bruna.lima@alubar.net")+'</td></tr>'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr><td style="width: 100%" class="tneg">Faturamento</td></tr>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr><td style="width: 100%">'+GetNewPar("EN_FATNAME","Bruno Melos")+'<br>Tel.: '+GetNewPar("EN_FATFONE","(85) 3244-3110")+'<br>E-mail: '+GetNewPar("EN_FATMAIL","bruno.melos@alubar.net")+'</td></tr>			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr><td style="width: 100%" class="tneg">Financeiro</td></tr>															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr><td style="width: 100%">'+GetNewPar("EN_FINNAME","Willyeida Nascimento")+'<br>Tel.: '+GetNewPar("EN_FINFONE","(85) 3244-3110/0545/9269")+'<br>E-mail: '+GetNewPar("EN_FINMAIL","willy.nascimento@alubar.net")+'</td></tr>'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr><td style="width: 100%" class="tneg">DADOS CLIENTE FINAL</td></tr>													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '               <tr>																														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 			     <td style="width: 100%">																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))										
  If empty(CODCF)	
  	cHtml := ' 				 Razão Social:'+cEmpNome+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))								
  	cHtml := ' 				 Endereço:'+cEmpEnd+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Bairro:'+cEmpBairro+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Cidade:'+cEmpCid+'<br>																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Cep:'+cEmpCEP+'<br>																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Contato:'+UsrFullName (RetCodUsr())+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Tel.:'+cEmpTel+'"/"'+cEmpFaX+'<br>																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 E-mail:'+UsrRetMail(RetCodUsr())+'                                                            						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))					  
  Else
  	cHtml := ' 				 Razão Social:'+NOMCF+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))								
  	cHtml := ' 				 Endereço:'+cCliEnd+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Bairro:'+cCliBair+'<br>																								'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Cidade:'+cCliCid+'<br>																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Cep:'+cCliCEP+'<br>																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Contato:'+cCliContact+'<br>																							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 Tel.:'+cCliTel+'<br>																									'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  	cHtml := ' 				 E-mail:'+cCliEMAIL+'                                                            						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))					
  EndIF 
  cHtml := ' 			   </td>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 			  </tr>																														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))															
  cHtml := '           </tbody>																														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))			
  cHtml := '          </table>																														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '         </td>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '       </tbody>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '     </table>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '   </div>																																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := '   <footer class="pg-break"> 																											'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))																					
  cHtml := '     <table style=" width: 100%; " cellpadding="2" cellspacing="2">																		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))								
  cHtml := '       <tbody> 																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 				<tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 					<td style=" width: 50%; font:15px; font-weight: bold; text-align:right;">CLIENTE FINAL</td> 						'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  IF empty(CODCF)
  	cHtml := '         	<td style=" width: 50%; font:15px; font-weight: bold; text-align:left;" font:15px>'+cEmpNome+'</td>							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  Else
  	cHtml := '         	<td style=" width: 50%; font:15px; font-weight: bold; text-align:left;" font:15px>'+NOMCF+'</td>							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  EndIF
  cHtml := ' 				</tr> 																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))																									
  cHtml := '         <tr>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))													
  cHtml := ' 					<td style=" width: 50%; font:15px; font-weight: bold; text-align:right;">RESPONSÁVEL</td>							'+CRLF;FWrite(nHandle,cHtml,Len(cHtml)) 					
  cHtml := ' 					<td style=" width: 50%; font:15px; font-weight: bold; text-align:left;" font:15px>ALUBAR ENERGIA S/A</td> 			'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 				</tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 				<tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 					<td style=" width: 50%; text-align:center"><img width="235" height="113" src="http://sigacorp.com.br/alubar/Energia_comprador.png" alt="Comprador"></td> 	'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  //cHtml := ' 					<td style=" width: 50%; text-align:center"><img width="235" height="113" src="http://sigacorp.com.br/alubar/Energia_gerente.png" alt="Gerente"></td> 		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 					<td style=" width: 50%; font-weight: bold; font-size: 12px; text-align:center">_________________________________________ <br/>Gerente</td> 		'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 				</tr>																													'+CRLF;FWrite(nHandle,cHtml,Len(cHtml)) 																											
  cHtml := '       </tbody> 																														'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))																
  cHtml := '     </table> 																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
  cHtml := ' 	</footer>																															'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))															
  cHtml := ' </body>																																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))							
  cHtml := ' </html> 																																'+CRLF;FWrite(nHandle,cHtml,Len(cHtml))
	
  FClose(nHandle)
ShellExecute("open", cArq, "", cPath, 1)
EndIf
/*--------------------------------------------------------------+
|Fechando areas de trabalho temporárias							|
+--------------------------------------------------------------*/
If Select("TMPSC7")>0
	DBSelectAREA("TMPSC7")
	DBCLOSEarea("TMPSC7")
EndIf
If Select("TMPSA2")>0
	DBSelectAREA("TMPSA2")
	DBCLOSEarea("TMPSA2")
EndIf
If Select("TMPSA1")>0
	DBSelectAREA("TMPSA1")
	DBCLOSEarea("TMPSA1")
EndIf

Return
////////////////////////////////////////////////////////////////////////////////////////

Static Function CriaCSS()

Local cCss 	  := ""
Local cArq    := "PedComWeb.css"
Local lMSg	  := .T.
Local nHandle := FCreate(cPath+cArq)
Local nCount  := 0

If nHandle < 0
	MsgAlert("Erro durante criação do arquivo.")
Else
	cCss := " td { "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "     border:1px solid #000; "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "     font:10px arial, helvetica, sans-serif; "		+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := " } "												+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := " .tneg{ "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       font:10px arial, helvetica, sans-serif; "	+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       font-weight: bold; "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       text-align: center; "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       color: #000; "								+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "      } "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := " .trel{ "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       font:16px arial, helvetica, sans-serif; "	+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       font-weight: bold; "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       color: #000; "								+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "      } "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := " .ttab{ "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       font:12px arial, helvetica, sans-serif; "	+CRLF;FWrite(nHandle,cCss,Len(cCss)) 
	cCss := "       font-weight: bold; "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       text-align: center; "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       color: #000; "								+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "      } "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := " .tavs{ "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       font:10px arial, helvetica, sans-serif; "	+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       font-weight: bold; "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       text-align: center; "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       color: #ff0000; "							+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "      } "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := " body { "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "       background: rgb(255,255,255); "				+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "      } "											+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := " .pg-break { "										+CRLF;FWrite(nHandle,cCss,Len(cCss)) 
	cCss := "               page-break-inside: avoid; "			+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "               width: auto;  "						+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := "              } "									+CRLF;FWrite(nHandle,cCss,Len(cCss))
	cCss := " .ttotal{ 											"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    cCss := "   font:14px arial, helvetica, sans-serif; 		"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    cCss := "   font-weight: bold; 								"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    cCss := "   width: 20%;										"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    cCss := "   color: #000; 									"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    cCss := "  }												"+CRLF;FWrite(nHandle,cCss,Len(cCss))    											
    cCss := "  .tfin{ 											"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    cCss := "    font:12px arial, helvetica, sans-serif; 		"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    cCss := "    font-weight: bold; 							"+CRLF;FWrite(nHandle,cCss,Len(cCss))											
    cCss := "    color: #000; 									"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    cCss := "   }												"+CRLF;FWrite(nHandle,cCss,Len(cCss))
    
	

	FClose(nHandle)

EndIf

Return
////////////////////////////////////////////////////////////////////////////////////////

User Function CriaDir()

Local cPasta  :="C:\relato\" 
Local lchkDir := ExistDir(cPasta)

If !lchkDir
	If MsgYesNo("Diretório - "+cPasta+" - não encontrado, deseja criá-lo" )
		nRet    := MakeDir(cPasta)
		If nRet != 0
			MsgAlert( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
		EndIf
	EndIf
Endif
   
Return
///////////////////////////////////////////////////////////////////////////////////////////////
Static Function PerIcms(cNumPC,cFornece,cLoja)

  Local cPerICMS 	:= ""
/*--------------------------------------------------------------+
|Informações do ICMS										|
+--------------------------------------------------------------*/
  cQryICM:= " SELECT C7_NUM,C7_ICM,SUM(C7_VALICM) VALICM "
  cQryICM+= " From "+RetSqlName("SC7") "
  cQryICM+= " Where D_E_L_E_T_<>'*' "
  cQryICM+= " AND C7_FILIAL='"+XFILIAL("SC7")+"' "
  cQryICM+= " AND C7_NUM = '" + cNumPC + "' "
  cQryICM+= " AND C7_FORNECE = '"+cFornece+"'"
  cQryICM+= " AND C7_LOJA = '"+cLoja+"'"
  cQryICM+= " GROUP BY C7_NUM,C7_ICM "
 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQryICM), 'TMPICM', .T., .T.)
  dbSelectArea("TMPICM")
  dbGoTop()
 
  While !Eof()	
    cPerICMS += Transform(TMPICM->C7_ICM,"@E 99.99")+"%: "+ Transform(TMPICM->VALICM,  "@E 999,999.99")+" | " 
    dbSkip()
  End
    
  If Select("TMPICM")>0
	DBSelectAREA("TMPICM")
	DBCLOSEarea("TMPICM")
  EndIf
  
  Return(cPerICMS)
  /////////////////////////////////////////////////////////////////////////////////////////////
 
  Static Function PerIpi(cNumPC,cFornece,cLoja)

  Local cPerIpi 	:= ""
  
/*--------------------------------------------------------------+
|Informações do IPI											|
+--------------------------------------------------------------*/
  cQryIPI:= " SELECT C7_NUM,C7_IPI,SUM(C7_VALIPI) VALIPI "
  cQryIPI+= " From "+RetSqlName("SC7") "
  cQryIPI+= " Where D_E_L_E_T_<>'*' "
  cQryIPI+= " AND C7_FILIAL='"+XFILIAL("SC7")+"' "
  cQryIPI+= " AND C7_NUM = '" + cNumPC + "' "
  cQryIPI+= " AND C7_FORNECE = '"+cFornece+"'"
  cQryIPI+= " AND C7_LOJA = '"+cLoja+"'"
  cQryIPI+= " GROUP BY C7_NUM,C7_IPI "
 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQryIPI), 'TMPIPI', .T., .T.)
  dbSelectArea("TMPIPI")
  dbGoTop()
 
  While !Eof()	
    cPerIPI += Transform(TMPIPI->C7_IPI,"@E 99.99")+"%: "+ Transform(TMPIPI->VALIPI,  "@E 999,999.99")+" | " 
    dbSkip()
  End

  If Select("TMPIPI")>0
	DBSelectAREA("TMPIPI")
	DBCLOSEarea("TMPIPI")
  EndIf
  
  Return(cPerIpi)
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function PedSE2(cNumPC,cFornece,cLoja)

  Local nParc		:= 0
  Local cSaySE2 	:= ""
  
  
/*--------------------------------------------------------------+
|Informações das parcelas tabela SE2							|
+--------------------------------------------------------------*/
  cQrySE2:= " SELECT * "
  cQrySE2+= " FROM " + RetSqlName("SE2") "
  cQrySE2+= " WHERE D_E_L_E_T_<>'*' "
  cQrySE2+= " AND E2_FILIAL='" + XFILIAL("SE2")+ "' "
  cQrySE2+= " AND E2_NUM = '" + cNumPC + "' "
  cQrySE2+= " AND E2_FORNECE = '" + cFornece + "'"
  cQrySE2+= " AND E2_LOJA = '" + cLoja + "'"
  cQrySE2+= " AND E2_PREFIXO='PED' "
  cQrySE2+= " AND E2_TIPO='PR' "
  cQrySE2+= " ORDER BY E2_PARCELA "
 
  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySE2), 'TMPSE2', .T., .T.)
  dbSelectArea("TMPSE2")
  dbGoTop()
 
  While !Eof()
    cSaySE2 += "Parcela "+TMPSE2->E2_PARCELA+" Valor: "+AllTrim(Transform(TMPSE2->E2_VALOR,  "@E 999,999,999.99"))+" Venc.: "+dtoc(stod(TMPSE2->E2_VENCREA))+" | "		 
    dbSkip()
  End

  If Select("TMPSE2")>0
	DBSelectAREA("TMPSE2")
	DBCLOSEarea("TMPSE2")
  EndIf
  
  Return(cSaySE2)
  