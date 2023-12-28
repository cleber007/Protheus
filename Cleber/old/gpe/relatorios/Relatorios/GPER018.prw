#include "topconn.ch"
#Include "PROTHEUS.Ch"

User Function GPER018()

Local oReport
Private aGPER18		:= {}


oReport := ReportDef()
oReport:PrintDialog()

Return

//////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////
Static Function ReportDef()
Local oReport
Local oSection1
Local cAliasQry1 := GetNextAlias()
Private cPerg      := "GPER018P"  // Nome do grupo de perguntas
Private oBreak

cDesc	:= "© " + Right(Str(Year(dDataBase)),4) + " Developed By Fábio Pedroza"

oReport := TReport():New("GPER018N","Funcionários x Verbas" + Space(10) + cDesc,"GPER018P",;
{|oReport| ReportPrint(oReport,@cAliasQry1)},"Este programa ira emitir os funcionários x Verbas,"+"imprimindo informacoes sobre os mesmos, em ordem "+;
"Matrícula e Nome")

ValidPerg(@cPerg)

Pergunte(cPerg,.f.)

//oReport := ReportDef(cPerg)

oReport:SetLandscape(.t.)
//oReport:SetPortrait(.t.)

oSection1 := TRSection():New(oReport,"Dados do funcionário",{"SRA","SRC","SRD"},{"Codigo","Alfabetica"},,.T.)  

///// SELECT RA_FILIAL AS C1, RA_MAT AS C2, RA_NOME AS C3, RA_SITFOLH C4, RC_PD AS C5, RC_TIPO1AS C6, RC_HORAS AS C7, RC_VALOR AS C8 , RC_DATA AS C9
                                                             
//TrCell():New(oTar,"FILIAL"    	,	, "Filial"	 			, "@!"       			 , 010                    	,,,"LEFT"	,,"LEFT" 	)

TRCell():New(oSection1,"RA_FILIAL"		,  ,,,,.F.,,"CENTER"	,,"CENTER")
TRCell():New(oSection1,"RA_MAT"     	,  ,,,TamSX3("RA_MAT")[1] + 5,.F.)
TRCell():New(oSection1,"RA_NOME"    	,  ,,,,.F.)
TRCell():New(oSection1,"RA_CODFUNC" 	,  ,,,,.F.,,"CENTER"	,,"CENTER")
TRCell():New(oSection1,"RA_SITFOLH"		,  ,,,,.F.)
TRCell():New(oSection1,"RC_PD"	   		,  ,,,,.F.)  
TRCell():New(oSection1,"RC_TIPO1"		,  ,,,,.F.)
TRCell():New(oSection1,"RC_HORAS"	    ,  ,,,,.F.)
TRCell():New(oSection1,"RC_VALOR"		,  ,,,,.F.)
TRCell():New(oSection1,"RC_DATA"		,  ,,,,.F.,,"CENTER"	,,"CENTER")   
TRCell():New(oSection1,"RA_CC"			,  ,,,,.F.,,"CENTER"	,,"CENTER")
TRCell():New(oSection1,"CCT_DESC01"		,  ,,,,.F.,,"CENTER"	,,"CENTER") 

TRCell():New(oSection1,"RA_CODFUNC" 	,  ,,,,.F.,,"CENTER"	,,"CENTER")
TRCell():New(oSection1,"RJ_DESC"		,  ,,,,.F.)


Return oReport

//////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////
Static Function ReportPrint(oReport,cAliasQry1)
Local oSection1 := oReport:Section(1)
Local cFiltro	:= ""
Local cImp		:= ""
Private nOrdem	:= oSection1:GetOrder()

nTotReg := ReportQry()

oReport:SetMeter(nTotReg)

oSection1:Init()

For s := 1 to Len(aGPER18)
	
	if	oReport:Cancel()
		Exit
	endif
	
	oReport:IncMeter()
	                     
	oSection1:Cell("RA_FILIAL")		:SetValue(aGPER18[s,01])
	oSection1:Cell("RA_MAT") 		:SetValue(aGPER18[s,02])
	oSection1:Cell("RA_NOME") 		:SetValue(aGPER18[s,03])
	oSection1:Cell("RA_SITFOLH") 	:SetValue(aGPER18[s,04])
	oSection1:Cell("RC_PD")	   		:SetValue(aGPER18[s,05])	
	
	oSection1:Cell("RC_TIPO1") 		:SetValue(aGPER18[s,06])
	oSection1:Cell("RC_HORAS")  	:SetValue(aGPER18[s,07])
	oSection1:Cell("RC_VALOR") 		:SetValue(aGPER18[s,08])
	oSection1:Cell("RC_DATA")	 	:SetValue(aGPER18[s,09])
	oSection1:Cell("RA_CC")		 	:SetValue(aGPER18[s,10])
	oSection1:Cell("CCT_DESC01") 	:SetValue(aGPER18[s,11])

	oSection1:Cell("RA_CODFUNC") 	:SetValue(aGPER18[s,12])
	oSection1:Cell("RJ_DESC") 		:SetValue(aGPER18[s,13])
	
	oSection1:PrintLine()
Next s

oSection1:Finish()

TMP1->(dbclosearea())
Return

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da Filial        		  ?","","","mv_ch1","C",02,0,0,"G",""  	 		,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
AADD(aRegs,{cPerg,"02","Até Filial         		  ?","","","mv_ch2","C",02,0,0,"G",""			,"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0"})
AADD(aRegs,{cPerg,"03","Do Funcionário     		  ?","","","mv_ch3","C",06,0,0,"G",""			,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Até o Funcionário  		  ?","","","mv_ch4","C",06,0,0,"G",""			,"mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})

AADD(aRegs,{cPerg,"05","Situações  		   		  ?","","","mv_ch5","C",05,0,0,"G","fSituacao" 	,"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Categorias         		  ?","","","mv_ch6","C",15,0,0,"G","fCategoria"	,"mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})

AADD(aRegs,{cPerg,"07","Verbas (separadas por ;)  ?","","","mv_ch7","C",80,0,0,"G",""		   	,"mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Data   (AAAAMM)			  ?","","","mv_ch8","C",06,0,0,"G",""		   	,"mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ReportQry()
Local cQuery    := ""
Local cOrder    := ""
Local nTotReg	:=	0
Local aCateg	:= {}
Local aCateg	:= {}
Local aSitFol	:= {}

Do Case
	Case nOrdem  == 1  //Por Codigo
		cOrder += " ORDER BY RA_FILIAL, RA_MAT "
	Case nOrdem == 2  //Por Nome
		cOrder += " ORDER BY RA_FILIAL, RA_NOME"
EndCase

//cCatQuery   := "%"
cCatQuery   := ""
cCateg		:= MV_PAR06

For nReg:=1 to Len(cCateg)
	If Subs(cCateg,nReg,1) # "*" .and. Subs(cCateg,nReg,1) # " "
		aadd(acateg,Subs(cCateg,nReg,1))
	Endif
	cCatQuery += "'"+Subs(cCateg,nReg,1)+"'"
	
	If ( nReg+1 ) <= Len(cCateg)
		cCatQuery += ","
	Endif
	
Next nReg
//cCatQuery += "%"


//cSitQuery   := "%"
cSitQuery   := ""
cSitFol		:= MV_PAR05

For nReg:=1 to Len(cSitFol)
	If Subs(cSitFol,nReg,1) # "*" .and. Subs(cSitFol,nReg,1) # " "
		aadd(aSitFol,Subs(cSitFol,nReg,1))
	Endif
	cSitQuery += "'"+Subs(cSitFol,nReg,1)+"'"
	
	If ( nReg+1 ) <= Len(cSitFol)
		cSitQuery += ","
	Endif
	
Next nReg
//cSitQuery += "%"

cVerQuery   := ""
cVerba		:= MV_PAR07
/*
For nReg:=1 to Len(cVerba)
	If Subs(cVerba,nReg,1) # "*" .and. Subs(cVerba,nReg,1) # " "
		aadd(acateg,Subs(cCateg,nReg,1))
	Endif
	cCatQuery += "'"+Subs(cVerba,nReg,1)+"'"
	
	If ( nReg+1 ) <= Len(cVerba)
		cVerQuery += ","
	Endif
	
Next nReg
*/

// Estado
If !Empty(MV_PAR13)
	cPar13  := MV_PAR13
	nPosAt := At(",",cPar13)
	cEst  := Iif(nPosAt !=0,"(","('"+Alltrim(MV_PAR13)+"')")
	Do While nPosAt != 0
		cEst   += "'" + Subst(cPar13,1,nPosAt-1) + "'"
		cPar13 := Subst(cPar13,nPosAt+1,Len(cPar13))
		nPosAt := At(",",cPar13)
		cEst   += Iif(nPosAt !=0,",",",'"+Alltrim(cPar13)+"')")
	Enddo
Endif
        

// Verba
If !Empty(MV_PAR07)
	cVerba  := MV_PAR07
	nPosAt := At(";",cVerba)
	cVerQuery  := Iif(nPosAt !=0,"(","('"+Alltrim(MV_PAR07)+"')")
	Do While nPosAt != 0
		cVerQuery   += "'" + Subst(cVerba,1,nPosAt-1) + "'"
		cPar13 := Subst(cVerba,nPosAt+1,Len(cVerba))
		nPosAt := At(",",cVerba)
		cVerQuery   += Iif(nPosAt !=0,",",",'"+Alltrim(cPar13)+"')")
	Enddo
Endif


cWhere  := " RA_FILIAL  >= '"   + Mv_Par01  + "'  AND "
cWhere  += " RA_FILIAL  <= '"   + Mv_Par02  + "'  AND "
cWhere  += " RA_MAT  >= '"      + Mv_Par03  + "'  AND "
cWhere  += " RA_MAT  <= '"      + Mv_Par04  + "'  AND "
cWhere  += " RA_SITFOLH  IN (" + cSitQuery + ")   AND "
cWhere  += " RA_CATFUNC  IN (" + cCatQuery + ")   "  
//cWhere  += " RC_CATFUNC  IN (" + cVerQuery + ")   "  
//cWhere  += " RA_CODFUNC  >= '"  + Mv_Par05  + "'  AND "
//cWhere  += " RA_CODFUNC  <= '"  + Mv_Par06  + "'  AND " 
//cWhere  += " RA_CODFUNC = RJ_FUNCAO AND "
//cWhere  += " RA_RESCRAI  <> '31' "
                   
//TRCell():New(oSection1,"RA_CODFUNC" 	,  ,,,,.F.,,"CENTER"	,,"CENTER")
//TRCell():New(oSection1,"RJ_DESC"		,  ,,,,.F.)

If Getmv("MV_FOLMES") == MV_PAR08

	cQuery += " SELECT RA_FILIAL AS C1, RA_MAT AS C2, RA_NOME AS C3, RA_SITFOLH C4, RC_PD AS C5, RC_TIPO1 AS C6, RC_HORAS AS C7, RC_VALOR AS C8 , RC_DATA AS C9, RA_CC AS C10, CTT_DESC01 AS C11, RA_CODFUNC AS C12, RJ_DESC AS C13 "
	cQuery += " FROM " + RetSqlName("SRC") + " RC INNER JOIN " + RetSqlName("SRA") + " RA "
	cQuery += " ON RC_FILIAL+RC_MAT = RA_FILIAL+RA_MAT "  
	cQuery += " INNER JOIN " + RetSqlName("CTT") + " CTT "     
	cQuery += " ON RA_CC = CTT_CUSTO  " 
	cQuery += " INNER JOIN " + RetSqlName("SRJ") + " SRJ "     
	cQuery += " ON RA_CODFUNC = RJ_FUNCAO  "
	cQuery += " WHERE RC.D_E_L_E_T_ <> '*' AND RA.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' "
	cQuery += " AND RC_PD IN " + cVerQuery + "  AND " 
//	cQuery += " AND RA_SITFOLH NOT IN ('D','')
	cQuery += cWhere 
	cQuery += cOrder
Else
	cQuery += " SELECT RA_FILIAL AS C1, RA_MAT AS C2, RA_NOME AS C3, RA_SITFOLH C4, RD_PD AS C5, RD_TIPO1 AS C6, RD_HORAS AS C7, RD_VALOR AS C8 , RD_DATARQ AS C9, RA_CC AS C10, CTT_DESC01 AS C11, RA_CODFUNC AS C12, RJ_DESC AS C13 "
	cQuery += " FROM " + RetSqlName("SRD") + " RD INNER JOIN " + RetSqlName("SRA") + " RA "
	cQuery += " ON RD_FILIAL+RD_MAT = RA_FILIAL+RA_MAT  "
	cQuery += " INNER JOIN " + RetSqlName("CTT") + " CTT "     
	cQuery += " ON RA_CC = CTT_CUSTO  "  
	cQuery += " INNER JOIN " + RetSqlName("SRJ") + " SRJ "     
	cQuery += " ON RA_CODFUNC = RJ_FUNCAO  "
	cQuery += " WHERE RD.D_E_L_E_T_ <> '*' AND RA.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' "
	cQuery += " AND RD_PD IN " + cVerQuery 
//	cQuery += " AND RA_SITFOLH NOT IN ('D','')
	cQuery += " AND RD_DATARQ = '" + MV_PAR08 + "' AND "
	cQuery += cWhere
	cQuery += cOrder
Endif
                                                                               
TcQuery ChangeQuery(cQuery) New Alias "TMP1"
                  
DbSelectArea("TMP1")
TMP1->(DbGotop())

Do While !TMP1->(EOF())
	AADD(aGPER18,{C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13 })    
	TMP1->(DbSkip(+1))
Enddo

Count to nTotReg

Return ( nTotReg )