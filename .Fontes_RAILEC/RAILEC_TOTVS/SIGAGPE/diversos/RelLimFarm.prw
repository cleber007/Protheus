//#include "totvs.ch"


/*

Programa: RelLimFarm

Autor   : Elmo Teixeiraº 

Data    : Out-2019

Objetivo: Relatório de Valores do ICMS-ST de um período


Atualizações:

*/

User Function RelLimFarm()

	local oreport := nil
	local cnome := "LIMFARM_"+dtos(ddatabase)+"_"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)
	Private cPerg := Padr("LIMFARM" ,10,"") 	

	aSX1   := {}
	Aadd(aSx1,{"GRUPO","ORDEM","PERGUNT"           ,"VARIAVL","TIPO","TAMANHO","DECIMAL","GSC","VALID","VAR01"   ,"F3"  ,"GRPSXG","DEF01"         ,"DEF02"          ,"DEF03"    ,"DEF04","DEF05"})
	Aadd(aSx1,{ cPerg ,"01"   ,"Da Filial ?"       ,"mv_ch1" ,"C"   ,02       ,0        ,"G"  ,""     ,"mv_par01","SM0"    ,""      ,""              ,""               ,""         ,""     ,""     })
	Aadd(aSx1,{ cPerg ,"02"   ,"Ate a Filial ?"    ,"mv_ch2" ,"C"   ,02       ,0        ,"G"  ,""     ,"mv_par02","SM0"    ,""      ,""              ,""               ,""         ,""     ,""     })
	Aadd(aSx1,{ cPerg ,"03"   ,"Da Matricula ?"    ,"mv_ch3" ,"C"   ,06       ,0        ,"G"  ,""     ,"mv_par03","SRA"    ,""      ,""              ,""               ,""         ,""     ,""     })
	Aadd(aSx1,{ cPerg ,"04"   ,"Ate a Matricula ?" ,"mv_ch4" ,"C"   ,06       ,0        ,"G"  ,""     ,"mv_par04","SRA"    ,""      ,""              ,""               ,""         ,""     ,""     })
	Aadd(aSx1,{ cPerg ,"05"   ,"Somente Ativos ?"  ,"mv_ch5" ,"C"   ,01       ,0        ,"C"  ,""     ,"mv_par05",""    ,""      ,"Sim"           ,"Não"            ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"05"   ,"Filial de    ?" ,"mv_ch6" ,"C"   ,02       ,0        ,"G"  ,""     ,"mv_par06","SM0" ,""      ,""              ,""               ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"06"   ,"Filial Ate   ?" ,"mv_ch7" ,"C"   ,02       ,0        ,"G"  ,""     ,"mv_par07","SM0" ,""      ,""              ,""               ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"01"   ,"Dt.Entrada De ?"  ,"mv_ch1" ,"D"   ,08       ,0        ,"G"  ,""     ,"mv_par01",""    ,""      ,""              ,""               ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"08"   ,"Tipo Prod de ?" ,"mv_ch8" ,"C"   ,02       ,0        ,"G"  ,""     ,"mv_par08","02 " ,""      ,""              ,""               ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"09"   ,"Tipo Prod Ate?" ,"mv_ch9" ,"C"   ,02       ,0        ,"G"  ,""     ,"mv_par09","02 " ,""      ,""              ,""               ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"10"   ,"Grupo de     ?" ,"mv_cha" ,"C"   ,04       ,0        ,"G"  ,""     ,"mv_par10","SBM" ,""      ,""              ,""               ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"11"   ,"Grupo Ate    ?" ,"mv_chb" ,"C"   ,04       ,0        ,"G"  ,""     ,"mv_par11","SBM" ,""      ,""              ,""               ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"12"   ,"Tipo Detalhe ?" ,"mv_chc" ,"C"   ,01       ,0        ,"C"  ,""     ,"mv_par12",""    ,""      ,"Arquivo"       ,"Usuario"        ,""         ,""     ,""     })
	//Aadd(aSx1,{ cPerg ,"13"   ,"Mostra Armaz. ?","mv_chd" ,"C"   ,01       ,0        ,"C"  ,""     ,"mv_par13",""    ,""      ,"Sim"       		,"Nao"        		,""         ,""     ,""     })
	//Valid para pergunta Situação: fSituacao
	fCriaSX1(cPerg,aSX1)
	pergunte(cPerg,.t.)

	oreport := rptdef(cnome)
	oreport:printdialog()

return

static function rptdef(cnome)
	local oreport := nil
	local osection1:= nil
	//local osection2:= nil
	//local osection3:= nil
	//local osection4:= nil
	//local osection5:= nil
	//local osection6:= nil
	//local osection7:= nil

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oreport := treport():new(cnome,"Relação de Limites - FARMACIA",cPerg,{ |oreport| reportprint(oreport)},"Limites de Farmácia")
	oreport:setportrait()
	oreport:settotalinline(.f.)

	//Monstando a primeira seÃ§Ã£o
	//Neste exemplo, tambem, je deixarei definido o nome dos campos, mascara e tamanho.
	osection1:= trsection():new(oreport, "Limites Farmácia", {"SRA"}, , .f., .t.)
	trcell():new(osection1,"RA_FILIAL"	,'trbtmp1','Filial'		,pesqpict('SRA','RA_FILIAL') ,TamSX3('RA_FILIAL')[1]+1)
	trcell():new(osection1,"RA_MAT"	   ,'trbtmp1','Matricula'	,pesqpict('SRA','RA_MAT')	  ,TamSX3('RA_MAT')[1]+1)
	trcell():new(osection1,"RA_NOME"    ,'trbtmp1','Nome'			,pesqpict('SRA','RA_NOME')	  ,TamSX3('RA_NOME')[1]+1)
	trcell():new(osection1,"RA_VLESC3"  ,'trbtmp1','%'			   ,pesqpict('SRA','RA_VLESC3') ,TamSX3('RA_VLESC3')[1]+1)
	trcell():new(osection1,"RA_LIMFARM"  ,'trbtmp1','Limite'		,pesqpict('SRA','RA_SALARIO'),TamSX3('RA_SALARIO')[1]+1)

/*
	osection2:= trsection():new(oreport, "ICMS-ST - Resumo", {"SD1","SF1","SA2"}, , .f., .t.)
	trcell():new(osection2,"D1_ANOMES"	,'trbtmp2','Periodo'				,pesqpict('SRD','RD_DATARQ')	,TamSX3('RD_DATARQ')[1]+1)
	trcell():new(osection2,"D1_FILIAL"	,'trbtmp2','Filial'					,pesqpict('SD1','D1_FILIAL')	,TamSX3('C9V_ID')[1]+1)
	trcell():new(osection2,"D1_TOTAL"  	,'trbtmp2','Vlr. Produto'			,pesqpict('SD1','D1_TOTAL')		,TamSX3('D1_TOTAL')[1]+1)
	trcell():new(osection2,"D1_VALIPI"	,'trbtmp2','Vlr.IPI'				,pesqpict('SD1','D1_VALIPI')	,TamSX3('D1_VALIPI')[1]+1)	
	trcell():new(osection2,"D1_VALIMP5"	,'trbtmp2','Vlr.PIS e COFINS'		,pesqpict('SD1','D1_VALIMP5')	,TamSX3('D1_VALIMP5')[1]+1)	
	trcell():new(osection2,"D1_VALICM"	,'trbtmp2','ICMS - Crédito'   		,pesqpict('SD1','D1_VALICM')	,TamSX3('D1_VALICM')[1]+1)	
	trcell():new(osection2,"D1_BRICMS"	,'trbtmp2','Base ICMS-ST'     		,pesqpict('SD1','D1_BRICMS')	,TamSX3('D1_BRICMS')[1]+1)	
	trcell():new(osection2,"D1_ICMSRET" ,'trbtmp2','Vlr. ICMS-ST'     		,pesqpict('SD1','D1_ICMSRET')	,TamSX3('D1_ICMSRET')[1]+1)	
*/

	/*
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
	*/
	
	oreport:settotalinline(.f.)

return(oreport)

static function reportprint(oreport)
	local osection1 := oreport:section(1)
	//local osection2 := oreport:section(2)
	//local osection3 := oreport:section(3)
	//local osection4 := oreport:section(4)
	//local osection5 := oreport:section(5)
	//local osection6 := oreport:section(6)
	//local osection7 := oreport:section(7)
	If mv_par05 == 1	
		cNaoLista := "D"
	Else
		cNaoLista := "_"
	Endif
	
	osection1:beginquery()
	beginsql alias "trbtmp1"
			SELECT           
			RA_FILIAL, RA_MAT,RA_NOME, RA_VLESC3, (RA_SALARIO*RA_VLESC3)/100 RA_LIMFARM
			FROM %table:SRA% SRA 
			WHERE
			SRA.%notDel%
			AND RA_FILIAL BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
			AND RA_MAT BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%
			AND RA_SITFOLH <> %EXP:cNaoLista%
			AND RA_VLESC3 >0
			ORDER BY RA_FILIAL,RA_MAT
	endsql

	osection1:endquery()

	while !oreport:cancel() .and. !trbtmp1->(eof())
	
		osection1:init()

		oreport:SetMsgPrint("Gerando Relatório")//+alltrim(trbtmp1->(C9V_MATRIC+'-'+C9V_NOME)))
		oreport:IncMeter()

		//imprimo a primeira secao
		osection1:Printline()

		trbtmp1->(dbskip())

	enddo

	//finalizo a primeira secao
	osection1:finish()		

/*
	osection2:beginquery()

	beginsql alias "trbtmp2"
			SELECT 
			left(D1_DTDIGIT,6) D1_ANOMES, D1_FILIAL, SUM(D1_TOTAL) D1_TOTAL, SUM(D1_VALIPI) D1_VALIPI, SUM(D1_VALIMP5+D1_VALIMP6) AS D1_VALIMP5, 
			SUM(D1_VALICM) D1_VALICM, SUM(D1_BRICMS) D1_BRICMS, SUM(D1_ICMSRET) D1_ICMSRET
			FROM %table:SD1% SD1 
			WHERE
			SD1.%notDel%
			AND D1_DOC BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%
			AND D1_FILIAL BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
			AND D1_DTDIGIT BETWEEN %EXP:dtos(MV_PAR01)% AND %EXP:dtos(MV_PAR02)%
			AND D1_ICMSRET>0
			GROUP BY left(D1_DTDIGIT,6),D1_FILIAL
			ORDER BY left(D1_DTDIGIT,6),D1_FILIAL
	endsql

	osection2:endquery()

	while !oreport:cancel() .and. !trbtmp2->(eof())

		osection2:init()

		oreport:SetMsgPrint("Gerando Planilha Resumo - ICMS ST")//+alltrim(trbtmp2->(C9V_MATRIC+'-'+C9V_NOME)))
		oreport:IncMeter()

		//imprimo a segunda secao
		osection2:Printline()
		
		trbtmp2->(dbskip())

	enddo
		
		//finalizo a segunda secao
		osection2:finish()	
*/

/*
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
	
*/


return

//-------------------------------------------------------------------------------------------
// Gerado pelo assistente de cï¿½digo do TDS tds_version em 01/04/2019 as 8:47:33 AM
//-- fim de arquivo--------------------------------------------------------------------------



***************************************
Static Function fCriaSx1(cPerg,aSx1,lAdd)
***************************************
Local nLin,nCol,cCampo
SX1->(DbSetOrder(1))

If SX1->(DbSeek(cPerg+aSx1[Len(aSx1)-1,2]))
	Return
EndIf

cX3GRUPO := "SX1->X1_GRUPO"
SX1->(DbSeek(cPerg))
While !SX1->(Eof()) .And. Alltrim(&cX3GRUPO) == cPerg
	SX1->(RecLock("SX1",.F.,.F.))
	SX1->(DbDelete())
	SX1->(MsUnLock())
	SX1->(DbSkip())
End
For nLin := 2 To Len(aSX1)
	SX1->(RecLock("SX1",.T.))
	For nCol := 1 To Len(aSX1[1])
		cCampo := "X1_"+aSX1[1,nCol]
		SX1->(FieldPut(SX1->(FieldPos(cCampo)),aSx1[nLin,nCol] ))
	Next nCol
	SX1->(MsUnLock())
Next nLin

Return
