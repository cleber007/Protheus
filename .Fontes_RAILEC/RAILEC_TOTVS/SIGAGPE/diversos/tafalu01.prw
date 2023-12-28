// #########################################################################################
// Projeto: alubar
// Modulo : sigataf
// Fonte  : tafalu01.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 01/04/2019 | erivalton         | 
// -----------+-------------------+---------------------------------------------------------

#include "totvs.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} tafalu01
@author    erivalton
@version   
@since     01/04/2019
/*/
//------------------------------------------------------------------------------------------
user function tafalu01()
	local oreport := nil
	local cnome := "tafalu01_"+dtos(ddatabase)+"_"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)

	oreport := rptdef(cnome)
	oreport:printdialog()

return

static function rptdef(cnome)
	local oreport := nil
	local osection1:= nil
	local osection2:= nil
	local osection3:= nil
	local osection4:= nil
	local osection5:= nil
	local osection6:= nil
	local osection7:= nil

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oreport := treport():new(cnome,"Eventos eSocial",cnome,{ |oreport| reportprint(oreport)},"Eventos eSocial")
	oreport:setportrait()
	oreport:settotalinline(.f.)

	//Monstando a primeira seção
	//Neste exemplo, tambem, je deixarei definido o nome dos campos, mascara e tamanho.
	osection1:= trsection():new(oreport, "Evento S-5001 - Inf. Contrib. Social Contrib.", {"T2M","T2O","C9V"}, , .f., .t.)
	trcell():new(osection1,"T2M_PERAPU"	,'trbtmp1','Periodo'						,pesqpict('T2M','T2M_PERAPU')	,TamSX3('T2M_PERAPU')[1]+1)
	trcell():new(osection1,"C9V_ID"			,'trbtmp1','ID TAF'							,pesqpict('C9V','C9V_ID')			,TamSX3('C9V_ID')[1]+1)
	trcell():new(osection1,"C9V_MATRIC"	,'trbtmp1','Matricula'					,pesqpict('C9V','C9V_MATRIC')	,TamSX3('C9V_MATRIC')[1]+1)
	trcell():new(osection1,"C9V_NOME"		,'trbtmp1','Nome Func.'					,pesqpict('C9V','C9V_NOME')		,TamSX3('C9V_NOME')[1]+1)
	trcell():new(osection1,"T2M_CPFTRB"	,'trbtmp1','CPF Func'						,pesqpict('T2M','T2M_CPFTRB')	,TamSX3('T2M_CPFTRB')[1]+1)
	trcell():new(osection1,"T2O_VRCPSE"	,'trbtmp1','Vlr. Segurado'			,pesqpict('T2O','T2O_VRCPSE')	,TamSX3('T2O_VRCPSE')[1]+1)
	trcell():new(osection1,"T2O_VRDESC"	,'trbtmp1','Vlr. Descontado'		,pesqpict('T2O','T2O_VRDESC')	,TamSX3('T2O_VRDESC')[1]+1)
	trcell():new(osection1,"T2O_DCODRR"	,'trbtmp1','Cod. Receita'				,pesqpict('T2O','T2O_DCODRR')	,TamSX3('T2O_DCODRR')[1]+1)	
	
	osection2:= trsection():new(oreport, "Evento S-5002 - I.R.R.F por contribuinte", {"T2G","T2J","C9V"}, , .f., .t.)
	trcell():new(osection2,"T2G_PERAPU"	,'trbtmp2','Periodo'						,pesqpict('T2G','T2G_PERAPU')	,TamSX3('T2G_PERAPU')[1]+1)
	trcell():new(osection2,"C9V_ID"			,'trbtmp2','ID TAF'							,pesqpict('C9V','C9V_ID')			,TamSX3('C9V_ID')[1]+1)
	trcell():new(osection2,"C9V_MATRIC"	,'trbtmp2','Matricula'					,pesqpict('C9V','C9V_MATRIC')	,TamSX3('C9V_MATRIC')[1]+1)
	trcell():new(osection2,"C9V_NOME"		,'trbtmp2','Nome Func.'					,pesqpict('C9V','C9V_NOME')		,TamSX3('C9V_NOME')[1]+1)
	trcell():new(osection2,"T2G_CPFTRA"	,'trbtmp2','CPF Func'						,pesqpict('T2G','T2G_CPFTRA')	,TamSX3('T2G_CPFTRA')[1]+1)
	trcell():new(osection2,"T2J_VLDESC"	,'trbtmp2','Vlr. IR'						,pesqpict('T2J','T2J_VLDESC')	,TamSX3('T2J_VLDESC')[1]+1)	

	osection3:= trsection():new(oreport, "Evento S-5013 - FGTS por Contribuinte", {"V2P","V2W","C9V"}, , .f., .t.)
	trcell():new(osection3,"V2P_PERAPU"	,'trbtmp3','Periodo'						,pesqpict('V2P','V2P_PERAPU')	,TamSX3('V2P_PERAPU')[1]+1)
	trcell():new(osection3,"C9V_ID"			,'trbtmp3','ID TAF'							,pesqpict('C9V','C9V_ID')			,TamSX3('C9V_ID')[1]+1)
	trcell():new(osection3,"C9V_MATRIC"	,'trbtmp3','Matricula'					,pesqpict('C9V','C9V_MATRIC')	,TamSX3('C9V_MATRIC')[1]+1)
	trcell():new(osection3,"C9V_NOME"		,'trbtmp3','Nome Func.'					,pesqpict('C9V','C9V_NOME')		,TamSX3('C9V_NOME')[1]+1)
	trcell():new(osection3,"V2P_CPF"		,'trbtmp3','CPF Func'						,pesqpict('V2P','V2P_CPF')		,TamSX3('V2P_CPF')[1]+1)
	trcell():new(osection3,"V2W_VLFGTS"	,'trbtmp3','Vlr. FGTS'					,pesqpict('V2W','V2W_VLFGTS')	,TamSX3('V2W_VLFGTS')[1]+1)	
	
	osection4:= trsection():new(oreport, "Verbas - 401_721-402_722-491_723-844", {"SRD","SRA"}, , .f., .t.)
	trcell():new(osection4,"RD_MAT"			,'trbtmp4','Matricula'					,pesqpict('SRA','RD_MAT')			,TamSX3('RD_MAT')[1]+1)
	trcell():new(osection4,"RA_NOME"		,'trbtmp4','Nome Func.'					,pesqpict('SRA','RA_NOME')		,TamSX3('RA_NOME')[1]+1)
	trcell():new(osection4,"RA_CIC"			,'trbtmp4','CPF Func'						,pesqpict('SRA','RA_CIC')			,TamSX3('RA_CIC')[1]+1)
	trcell():new(osection4,"VLRVB401"		,'trbtmp4','Vlr. 401'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection4,"VLRVB402"		,'trbtmp4','Vlr. 402'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection4,"VLRVB491"		,'trbtmp4','Vlr. 491'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection4,"VLRTOTAL"		,'trbtmp4','Vlr. Total'					,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection4,"VLRVB721"		,'trbtmp4','Vlr. 721'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection4,"VLRVB722"		,'trbtmp4','Vlr. 722'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection4,"VLRVB723"		,'trbtmp4','Vlr. 723'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection4,"VLRVB844"		,'trbtmp4','Vlr. 844'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection4,"VLRTOTAG"		,'trbtmp4','Vlr. Total'					,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)

	osection5:= trsection():new(oreport, "Verbas - 731_732-739_740", {"SRD","SRA"}, , .f., .t.)
	trcell():new(osection5,"RD_MAT"			,'trbtmp5','Matricula'					,pesqpict('SRD','RD_MAT')			,TamSX3('RD_MAT')[1]+1)
	trcell():new(osection5,"RA_NOME"		,'trbtmp5','Nome Func.'					,pesqpict('SRA','RA_NOME')		,TamSX3('RA_NOME')[1]+1)
	trcell():new(osection5,"RA_CIC"			,'trbtmp5','CPF Func'						,pesqpict('SRA','RA_CIC')			,TamSX3('RA_CIC')[1]+1)
	trcell():new(osection5,"VLRVB732"		,'trbtmp5','Vlr. 732'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection5,"VLRVB739"		,'trbtmp5','Vlr. 739'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection5,"VLRTOTV"		,'trbtmp5','Vlr. Total'					,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection5,"VLRVB731"		,'trbtmp5','Vlr. 731'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection5,"VLRVB740"		,'trbtmp5','Vlr. 740'						,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection5,"VLRTOTB"		,'trbtmp5','Vlr. Total'					,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)

	osection6:= trsection():new(oreport, "Demitidos periodo", {"SRV","SRA","SRR"}, , .f., .t.)
	trcell():new(osection6,"RR_MAT"						,'trbtmp6','Matricula'					,pesqpict('SRA','RR_MAT')			,TamSX3('RR_MAT')[1]+1)
	trcell():new(osection6,"RA_NOME"					,'trbtmp6','Nome Func.'					,pesqpict('SRA','RA_NOME')		,TamSX3('RA_NOME')[1]+1)
	trcell():new(osection6,"RA_CIC"						,'trbtmp6','CPF Func'						,pesqpict('SRA','RA_CIC')			,TamSX3('RA_CIC')[1]+1)
	trcell():new(osection6,"ADMISSAO"					,'trbtmp6','Admissão'						,pesqpict('SRA','RA_ADMISSA')	,TamSX3('RA_ADMISSA')[1]+1)
	trcell():new(osection6,"DEMISSAO"					,'trbtmp6','Demissão'						,pesqpict('SRA','RA_DEMISSA')	,TamSX3('RA_DEMISSA')[1]+1)
	trcell():new(osection6,"RA_CODFUNC"				,'trbtmp6','Cod. Func.'					,pesqpict('SRA','RA_CODFUNC')	,TamSX3('RA_CODFUNC')[1]+1)
	trcell():new(osection6,"RJ_DESC"					,'trbtmp6','Desc. Função'				,pesqpict('SRJ','RJ_DESC')		,TamSX3('RJ_DESC')[1]+1)
	trcell():new(osection6,"RR_CC"						,'trbtmp6','C. Custo'						,pesqpict('SRR','RR_CC')			,TamSX3('RR_CC')[1]+1)
	trcell():new(osection6,"CTT_DESC01"				,'trbtmp6','Desc. Custo'				,pesqpict('CTT','CTT_DESC01')	,TamSX3('CTT_DESC01')[1]+1)
	trcell():new(osection6,"TIPO_RESCISAO"		,'trbtmp6','Tipo Rescisão'			,"@!",30)
	trcell():new(osection6,"SITUACAO"					,'trbtmp6','Situação'						,pesqpict('SRA','RA_SITFOLH')	,TamSX3('RA_SITFOLH')[1]+1)
	trcell():new(osection6,"PERIODO"					,'trbtmp6','Período'						,pesqpict('SRR','RR_PERIODO')	,TamSX3('RR_PERIODO')[1]+1)
	trcell():new(osection6,"RR_PD"						,'trbtmp6','Cod. Verba'					,pesqpict('SRR','RR_PD')			,TamSX3('RR_PD')[1]+1)
	trcell():new(osection6,"RV_DESC"					,'trbtmp6','Desc. Verba'				,pesqpict('SRV','RV_DESC')		,TamSX3('RV_DESC')[1]+1)
	trcell():new(osection6,"TIPO"							,'trbtmp6','Tipo'								,pesqpict('SRV','RV_TIPOCOD')	,TamSX3('RV_TIPOCOD')[1]+1)
	trcell():new(osection6,"TIPO_REF"					,'trbtmp6','Tipo Ref'						,pesqpict('SRR','RR_TIPO1')		,TamSX3('RR_TIPO1')[1]+1)
	trcell():new(osection6,"RR_HORAS"					,'trbtmp6','Referência'					,pesqpict('SRR','RR_HORAS')		,TamSX3('RR_HORAS')[1]+1)
	trcell():new(osection6,"RR_VALOR"					,'trbtmp6','Valor Ref.'					,pesqpict('SRR','RR_VALOR')		,TamSX3('RR_VALOR')[1]+1)
	trcell():new(osection6,"RV_INSS"					,'trbtmp6','Inc. Inss'					,pesqpict('SRV','RV_INSS')		,TamSX3('RV_INSS')[1]+1)
	trcell():new(osection6,"RV_FGTS"					,'trbtmp6','Inc. Fgts'					,pesqpict('SRV','RV_FGTS')		,TamSX3('RV_FGTS')[1]+1)
	trcell():new(osection6,"RV_NATUREZ"				,'trbtmp6','Natureza'						,pesqpict('SRV','RV_NATUREZ')	,TamSX3('RV_NATUREZ')[1]+1)
	trcell():new(osection6,"RV_INCIRF"				,'trbtmp6','Inc. Irf eSocial'		,pesqpict('SRV','RV_INCIRF')	,TamSX3('RV_INCIRF')[1]+1)
	trcell():new(osection6,"RV_INCCP"					,'trbtmp6','Inc. Inss eSocial'	,pesqpict('SRV','RV_INCCP')		,TamSX3('RV_INCCP')[1]+1)
	trcell():new(osection6,"RV_INCFGTS"				,'trbtmp6','Inc. Fgts eSocial'	,pesqpict('SRV','RV_INCFGTS')	,TamSX3('RV_INCFGTS')[1]+1)

	osection7:= trsection():new(oreport, "Folha Pagto periodo", {"SRV","SRA","SRD"}, , .f., .t.)
	trcell():new(osection7,"RD_MAT"			,'trbtmp7','Matricula'					,pesqpict('SRA','RD_MAT')			,TamSX3('RD_MAT')[1]+1)
	trcell():new(osection7,"RA_NOME"		,'trbtmp7','Nome Func.'					,pesqpict('SRA','RA_NOME')		,TamSX3('RA_NOME')[1]+1)
	trcell():new(osection7,"RA_CIC"			,'trbtmp7','CPF Func'						,pesqpict('SRA','RA_CIC')			,TamSX3('RA_CIC')[1]+1)
	trcell():new(osection7,"ADMISSAO"		,'trbtmp7','Admissão'						,pesqpict('SRA','RA_ADMISSA')	,TamSX3('RA_ADMISSA')[1]+1)
	trcell():new(osection7,"DEMISSAO"		,'trbtmp7','Demissão'						,pesqpict('SRA','RA_DEMISSA')	,TamSX3('RA_DEMISSA')[1]+1)
	trcell():new(osection7,"RA_CODFUNC"	,'trbtmp7','Cod. Func.'					,pesqpict('SRA','RA_CODFUNC')	,TamSX3('RA_CODFUNC')[1]+1)
	trcell():new(osection7,"RJ_DESC"		,'trbtmp7','Desc. Função'				,pesqpict('SRJ','RJ_DESC')		,TamSX3('RJ_DESC')[1]+1)
	trcell():new(osection7,"RD_CC"			,'trbtmp7','C. Custo'						,pesqpict('SRD','RD_CC')			,TamSX3('RD_CC')[1]+1)
	trcell():new(osection7,"CTT_DESC01"	,'trbtmp7','Desc. Custo'				,pesqpict('CTT','CTT_DESC01')	,TamSX3('CTT_DESC01')[1]+1)
	trcell():new(osection7,"SITUACAO"		,'trbtmp7','Situação'						,pesqpict('SRA','RA_SITFOLH')	,TamSX3('RA_SITFOLH')[1]+1)
	trcell():new(osection7,"PERIODO"		,'trbtmp7','Período'						,pesqpict('SRD','RD_PERIODO')	,TamSX3('RD_PERIODO')[1]+1)
	trcell():new(osection7,"RD_PD"			,'trbtmp7','Cod. Verba'					,pesqpict('SRD','RD_PD')			,TamSX3('RD_PD')[1]+1)
	trcell():new(osection7,"RV_DESC"		,'trbtmp7','Desc. Verba'				,pesqpict('SRV','RV_DESC')		,TamSX3('RV_DESC')[1]+1)
	trcell():new(osection7,"TIPO"				,'trbtmp7','Tipo'								,pesqpict('SRV','RV_TIPOCOD')	,TamSX3('RV_TIPOCOD')[1]+1)
	trcell():new(osection7,"TIPO_REF"		,'trbtmp7','Tipo Ref'						,pesqpict('SRD','RD_TIPO1')		,TamSX3('RD_TIPO1')[1]+1)
	trcell():new(osection7,"RD_HORAS"		,'trbtmp7','Referência'					,pesqpict('SRD','RD_HORAS')		,TamSX3('RD_HORAS')[1]+1)
	trcell():new(osection7,"RD_VALOR"		,'trbtmp7','Valor Ref.'					,pesqpict('SRD','RD_VALOR')		,TamSX3('RD_VALOR')[1]+1)
	trcell():new(osection7,"RV_INSS"		,'trbtmp7','Inc. Inss'					,pesqpict('SRV','RV_INSS')		,TamSX3('RV_INSS')[1]+1)
	trcell():new(osection7,"RV_IR"			,'trbtmp7','Inc. Ir'						,pesqpict('SRV','RV_IR')			,TamSX3('RV_INSS')[1]+1)
	trcell():new(osection7,"RV_FGTS"		,'trbtmp7','Inc. Fgts'					,pesqpict('SRV','RV_FGTS')		,TamSX3('RV_FGTS')[1]+1)
	trcell():new(osection7,"RV_NATUREZ"	,'trbtmp7','Natureza'						,pesqpict('SRV','RV_NATUREZ')	,TamSX3('RV_NATUREZ')[1]+1)
	trcell():new(osection7,"RV_INCIRF"	,'trbtmp7','Inc. Irf eSocial'		,pesqpict('SRV','RV_INCIRF')	,TamSX3('RV_INCIRF')[1]+1)
	trcell():new(osection7,"RV_INCFGTS"	,'trbtmp7','Inc. Fgts eSocial'	,pesqpict('SRV','RV_INCFGTS')	,TamSX3('RV_INCFGTS')[1]+1)
	trcell():new(osection7,"RV_INCCP"		,'trbtmp7','Inc. Inss eSocial'	,pesqpict('SRV','RV_INCCP')		,TamSX3('RV_INCCP')[1]+1)

	oreport:settotalinline(.f.)

return(oreport)

static function reportprint(oreport)
	local osection1 := oreport:section(1)
	local osection2 := oreport:section(2)
	local osection3 := oreport:section(3)
	local osection4 := oreport:section(4)
	local osection5 := oreport:section(5)
	local osection6 := oreport:section(6)
	local osection7 := oreport:section(7)

	osection1:beginquery()

	beginsql alias "trbtmp1"
		SELECT 
		T2M.T2M_VERSAO,T2M.T2M_PERAPU,C9V_ID, SUBSTRING(C9V.C9V_MATRIC,5,6) C9V_MATRIC,
		C9V.C9V_NOME,T2M.T2M_CPFTRB,
		T2O.T2O_VRCPSE,T2O.T2O_VRDESC, T2O.T2O_DCODRR
		FROM %table:T2M% T2M 
		INNER JOIN %table:C9V% C9V ON C9V.%notDel% AND C9V.C9V_ATIVO='1' AND C9V.C9V_CPF=T2M.T2M_CPFTRB
		INNER JOIN %table:T2O% T2O ON T2O.%notDel% AND T2O.T2O_ID=T2M_ID
		WHERE
		T2M.%notDel%
		AND T2M.T2M_PERAPU=%exp:anomes(ddatabase)%
		AND T2M.T2M_ATIVO='1'
		ORDER BY C9V.C9V_NOME
	endsql

	osection1:endquery()

	while !oreport:cancel() .and. !trbtmp1->(eof())
	
		osection1:init()

		oreport:SetMsgPrint("Gerando Planilha Evento S-5001")//+alltrim(trbtmp1->(C9V_MATRIC+'-'+C9V_NOME)))
		oreport:IncMeter()

		//imprimo a primeira secao
		osection1:Printline()

		trbtmp1->(dbskip())

	enddo

	//finalizo a primeira secao
	osection1:finish()		


	osection2:beginquery()

	beginsql alias "trbtmp2"
		SELECT 
			T2G_VERSAO,T2G_PERAPU,C9V_ID, SUBSTRING(C9V_MATRIC,5,6) C9V_MATRIC,C9V_NOME,T2G.T2G_CPFTRA,
			T2J.T2J_VLDESC
		FROM %table:T2G% T2G 
		INNER JOIN %table:C9V% C9V ON C9V.%notDel% AND C9V_ATIVO='1' AND C9V.C9V_CPF=T2G.T2G_CPFTRA
		INNER JOIN %table:T2J% T2J ON T2J.%notDel% AND T2J_ID=T2G_ID
		WHERE
			T2G.%notDel%
			AND T2G.T2G_PERAPU=%exp:Year2Str(ddatabase)+Month2Str(ddatabase)%
			AND T2G.T2G_ATIVO='1'
		ORDER BY C9V_NOME
	endsql

	osection2:endquery()

	while !oreport:cancel() .and. !trbtmp2->(eof())

		osection2:init()

		oreport:SetMsgPrint("Gerando Planilha Evento S-5002 ")//+alltrim(trbtmp2->(C9V_MATRIC+'-'+C9V_NOME)))
		oreport:IncMeter()

		//imprimo a segunda secao
		osection2:Printline()
		
		trbtmp2->(dbskip())

	enddo
		
		//finalizo a segunda secao
		osection2:finish()	


	osection3:beginquery()

	beginsql alias "trbtmp3"
		SELECT 
			V2P.V2P_VERSAO,V2P.V2P_PERAPU, C9V.C9V_ID, SUBSTRING(C9V_MATRIC,5,6) C9V_MATRIC, 
			C9V.C9V_NOME,V2P.V2P_CPF,V2W.V2W_VLFGTS 
		FROM V2W060 V2W 
		INNER JOIN %table:V2P% V2P ON V2P.%notDel% AND V2P.V2P_VERSAO=V2W.V2W_VERSAO
		INNER JOIN %table:C9V% C9V ON C9V.%notDel% AND C9V.C9V_ATIVO='1' AND C9V.C9V_CPF=V2P.V2P_CPF
		WHERE
			V2W.%notDel%
			AND V2P.V2P_PERAPU=%exp:Month2Str(ddatabase)+Year2Str(ddatabase)%
			AND V2P.V2P_ATIVO='1'
		ORDER BY C9V.C9V_NOME
	endsql

	osection3:endquery()

	while !oreport:cancel() .and. !trbtmp3->(eof())

		osection3:init()

		oreport:SetMsgPrint("Gerando Planilha Evento S-5013")//+alltrim(trbtmp3->(C9V_MATRIC+'-'+C9V_NOME)))
		oreport:IncMeter()

		//imprimo a segunda secao
		osection3:Printline()
		
		trbtmp3->(dbskip())

	enddo
		
		//finalizo a segunda secao
		osection3:finish()	
	

	osection4:beginquery()

	beginsql alias "trbtmp4"
		SELECT 
			RD_MAT,RA_NOME,RA_CIC,
			SUM(CASE WHEN RD_PD='401' THEN RD_VALOR ELSE 0 END) AS VLRVB401
			,SUM(CASE WHEN RD_PD='402' THEN RD_VALOR ELSE 0 END) AS VLRVB402
			,SUM(CASE WHEN RD_PD='491' THEN RD_VALOR ELSE 0 END) AS VLRVB491

			,SUM(CASE WHEN RD_PD='401' THEN RD_VALOR ELSE 0 END)
			+SUM(CASE WHEN RD_PD='402' THEN RD_VALOR ELSE 0 END)
			+SUM(CASE WHEN RD_PD='491' THEN RD_VALOR ELSE 0 END) AS VLRTOTAL

			,SUM(CASE WHEN RD_PD='721' THEN RD_VALOR ELSE 0 END) AS VLRVB721
			,SUM(CASE WHEN RD_PD='722' THEN RD_VALOR ELSE 0 END) AS VLRVB722
			,SUM(CASE WHEN RD_PD='723' THEN RD_VALOR ELSE 0 END) AS VLRVB723
			,SUM(CASE WHEN RD_PD='844' THEN RD_VALOR ELSE 0 END) AS VLRVB844

			,SUM(CASE WHEN RD_PD='721' THEN RD_VALOR ELSE 0 END)
			+SUM(CASE WHEN RD_PD='722' THEN RD_VALOR ELSE 0 END)
			+SUM(CASE WHEN RD_PD='723' THEN RD_VALOR ELSE 0 END)
			+SUM(CASE WHEN RD_PD='844' THEN RD_VALOR ELSE 0 END) AS VLRVTOTAG
		FROM %table:SRD% SRD
		INNER JOIN %table:SRA% SRA ON SRA.%notDel% AND RA_MAT=RD_MAT
		WHERE
			SRD.%notDel%
			AND RD_PERIODO=%EXP:ANOMES(DDATABASE)%
			AND RD_ROTEIR IN ('FOL','AUT','FER')
			AND RD_PD IN ('401','402','491','721','722','723','844')
		GROUP BY RD_MAT,RA_NOME,RA_CIC,RA_SITFOLH
		ORDER BY RA_NOME
	endsql

	osection4:endquery()

	while !oreport:cancel() .and. !trbtmp4->(eof())

		osection4:init()

		oreport:SetMsgPrint("Gerando Planilha Verbas - 401_721-402_722-491_723-844")//+alltrim(trbtmp4->(RD_MAT+'-'+RA_NOME)))
		oreport:IncMeter()

		//imprimo a segunda secao
		osection4:Printline()
		
		trbtmp4->(dbskip())

	enddo
		
		//finalizo a segunda secao
		osection4:finish()	

	osection5:beginquery()

	beginsql alias "trbtmp5"
		SELECT 
			RD_MAT,RA_NOME,RA_CIC,

			SUM(CASE WHEN RD_PD='732' THEN RD_VALOR ELSE 0 END) VLRVB732
			,SUM(CASE WHEN RD_PD='740' THEN RD_VALOR ELSE 0 END) VLRVB740

			,SUM(CASE WHEN RD_PD='732' THEN RD_VALOR ELSE 0 END)
			+SUM(CASE WHEN RD_PD='740' THEN RD_VALOR ELSE 0 END) VLRTOTV

			,SUM(CASE WHEN RD_PD='731' THEN RD_VALOR ELSE 0 END) VLRVB731
			,SUM(CASE WHEN RD_PD='739' THEN RD_VALOR ELSE 0 END) VLRVB739

			,SUM(CASE WHEN RD_PD='731' THEN RD_VALOR ELSE 0 END)
			+SUM(CASE WHEN RD_PD='739' THEN RD_VALOR ELSE 0 END) VLRTOTB 

			,RD_ROTEIR
		FROM %table:SRD% SRD
		INNER JOIN %table:SRA% SRA ON SRA.%notDel% AND RA_MAT=RD_MAT
		WHERE
			SRD.%notDel%
			AND RD_PERIODO=%exp:anomes(ddatabase)%
			AND RD_ROTEIR IN ('FOL','AUT','FER')
			AND RD_PD IN ('732','731','739','740')
		GROUP BY RD_MAT,RA_NOME,RA_CIC,RA_SITFOLH,RD_ROTEIR
		ORDER BY RA_NOME
	endsql

	osection5:endquery()

	while !oreport:cancel() .and. !trbtmp5->(eof())

		osection5:init()

		oreport:SetMsgPrint("Gerando Planilha Verbas - 731_732-739_740")//+alltrim(trbtmp4->(RD_MAT+'-'+RA_NOME)))
		oreport:IncMeter()

		//imprimo a segunda secao
		osection5:Printline()
		
		trbtmp5->(dbskip())

	enddo
		
		//finalizo a segunda secao
		osection5:finish()	
		
	
	osection6:beginquery()

	beginsql alias "trbtmp6"
		SELECT 
			RR_FILIAL
			,RR_MAT
			,RA_NOME
			,RA_CIC
			,CONVERT(DATE,RA_ADMISSA,105) AS 'ADMISSAO'
			,CONVERT(DATE,RA_DEMISSA,105) AS 'DEMISSAO'
			,RA_CODFUNC
			,RJ_DESC
			,RR_CC
			,CTT_DESC01
			,CASE 
					WHEN RA_SITFOLH = ' ' THEN 'NORMAL'
					WHEN RA_SITFOLH = 'D' THEN 'DEMITIDO'
					WHEN RA_SITFOLH = 'F' THEN 'FÉRIAS'
					WHEN RA_SITFOLH = 'A' THEN 'AFASTADO'
					WHEN RA_SITFOLH = 'T' THEN 'TRANSFERIDO'
			END AS 'SITUACAO'
			,SRG.RG_TIPORES+' - '+SUBSTRING(RCC_CONTEU,3,30) AS 'TIPO_RESCISAO'
			,SUBSTRING(RR_PERIODO,5,2)+'/'+SUBSTRING(RR_PERIODO,1,4) AS 'PERIODO'
			,RR_PD
			,RV_DESC
			,CASE 
					WHEN RV_TIPOCOD = '1' THEN 'PROVENTO'
					WHEN RV_TIPOCOD = '2' THEN 'DESCONTO'
					WHEN RV_TIPOCOD = '3' THEN 'BASE'
			END AS 'TIPO'
			,CASE 
					WHEN RR_TIPO1 = 'D' THEN 'DIAS'
					WHEN RR_TIPO1 = 'V' THEN 'VALOR'
					WHEN RR_TIPO1 = 'H' THEN 'HORAS'
			END AS 'TIPO REF'
			,RR_HORAS
			,RR_VALOR
			,RV_INSS
			,RV_FGTS
			,RV_NATUREZ
			,RV_INCIRF
			,RV_INCCP
			,RV_INCFGTS
			,RR_ROTEIR

		FROM %table:SRR% AS SRR
		
		LEFT JOIN %table:SRA% AS SRA
		ON RA_FILIAL+RA_MAT = RR_FILIAL+RR_MAT AND SRA.%notDel%

		LEFT JOIN %table:SRG% AS SRG
		ON RG_FILIAL+RG_MAT = RA_FILIAL+RA_MAT AND SRG.%notDel%

		LEFT JOIN %table:RCC% AS RCC
		ON RCC_CODIGO='S043' AND LEFT(RCC_CONTEU,2)=SRG.RG_TIPORES AND RCC.%notDel%

		LEFT JOIN %table:SRJ% AS SRJ
		ON RA_CODFUNC = RJ_FUNCAO AND SRJ.%notDel%

		LEFT JOIN %table:CTT% AS CTT
		ON RR_CC = CTT_CUSTO AND CTT.%notDel%

		LEFT JOIN %table:SRV% AS SRV
		ON RR_PD = RV_COD AND SRV.%notDel%

		WHERE SRR.%notDel%
			AND RR_ROTEIR IN ('RES')
			AND RR_PERIODO = %EXP:ANOMES(DDATABASE)%

		ORDER BY RA_NOME
	endsql

	osection6:endquery()

	while !oreport:cancel() .and. !trbtmp6->(eof())

		osection6:init()

		oreport:SetMsgPrint("Gerando Planilha Demitidos periodo")//+alltrim(trbtmp5->(RR_MAT+'-'+RA_NOME)))
		oreport:IncMeter()

		//imprimo a segunda secao
		osection6:Printline()
		
		trbtmp6->(dbskip())

	enddo
		
	//finalizo a segunda secao
	osection6:finish()
	
	osection7:beginquery()

	beginsql alias "trbtmp7"
		SELECT 
			RD_FILIAL
			,RD_MAT
			,RA_NOME
			,RA_CIC
			,CONVERT(DATE,RA_ADMISSA,105) AS 'ADMISSAO'
			,CONVERT(DATE,RA_DEMISSA,105) AS 'DEMISSAO'
			,RA_CODFUNC
			,RJ_DESC
			,RD_CC
			,CTT_DESC01
			,CASE 
					WHEN RA_SITFOLH = ' ' THEN 'NORMAL'
					WHEN RA_SITFOLH = 'D' THEN 'DEMITIDO'
					WHEN RA_SITFOLH = 'F' THEN 'FÉRIAS'
					WHEN RA_SITFOLH = 'A' THEN 'AFASTADO'
					WHEN RA_SITFOLH = 'T' THEN 'TRANSFERIDO'
			END AS 'SITUACAO'
			,SUBSTRING(RD_PERIODO,5,2)+'/'+SUBSTRING(RD_PERIODO,1,4) AS 'PERIODO'
			,RD_PD
			,RV_DESC
			,CASE 
					WHEN RV_TIPOCOD = '1' THEN 'PROVENTO'
					WHEN RV_TIPOCOD = '2' THEN 'DESCONTO'
					WHEN RV_TIPOCOD = '3' THEN 'BASE'
			END AS 'TIPO'
			,CASE 
					WHEN RD_TIPO1 = 'D' THEN 'DIAS'
					WHEN RD_TIPO1 = 'V' THEN 'VALOR'
					WHEN RD_TIPO1 = 'H' THEN 'HORAS'
			END AS 'TIPO REF'
			,RD_HORAS
			,RD_VALOR
			,RV_INSS
			,RV_FGTS
			,RV_NATUREZ
			,RV_INCIRF
			,RV_INCCP
			,RV_INCFGTS
			,RD_ROTEIR

		FROM %table:SRD% AS SRD
		
		LEFT JOIN %table:SRA% AS SRA
		ON RA_FILIAL+RA_MAT = RD_FILIAL+RD_MAT AND SRA.%notDel%

		LEFT JOIN %table:SRJ% AS SRJ
		ON RA_CODFUNC = RJ_FUNCAO AND SRJ.%notDel%

		LEFT JOIN %table:CTT% AS CTT
		ON RD_CC = CTT_CUSTO AND CTT.%notDel%

		LEFT JOIN %table:SRV% AS SRV
		ON RD_PD = RV_COD AND SRV.%notDel%

		WHERE SRD.%notDel%
			AND RD_ROTEIR IN ('FOL','AUT')
			AND RD_PERIODO = %EXP:ANOMES(DDATABASE)%

		ORDER BY RA_NOME
	endsql

	osection7:endquery()

	while !oreport:cancel() .and. !trbtmp7->(eof())

		osection7:init()

		oreport:SetMsgPrint("Gerando Planilha Folha Pagto periodo")//+alltrim(trbtmp6->(RD_MAT+'-'+RA_NOME)))
		oreport:IncMeter()

		//imprimo a segunda secao
		osection7:Printline()
		
		trbtmp7->(dbskip())

	enddo
		
		//finalizo a segunda secao
		osection7:finish()

return

//-------------------------------------------------------------------------------------------
// Gerado pelo assistente de c�digo do TDS tds_version em 01/04/2019 as 8:47:33 AM
//-- fim de arquivo--------------------------------------------------------------------------

