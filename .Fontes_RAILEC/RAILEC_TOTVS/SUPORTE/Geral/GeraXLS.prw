#include "protheus.ch"

//+--------------------------------------------------------------------+
//| Rotina | GeraXLS |Autor: Evandro Lima (Inovativa)|Data: 28/11/2018 |
//| Descr. | Rotina para gerar planilha em Excel                       |
//+--------------------------------------------------------------------+

User Function GeraXLS(_cVar1,_cVar2,_aCab,_aDados)
	********************************************************************************************************************************
	Local i as numeric
	Local x as numeric

	oExcel 	:= FWMSEXCEL():New()
	_cFile	:=GetTempPath()+alltrim(_cVar2)+"_"+alltrim(_cVar1)+"_"+(Dtos(dDataBase)+SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2))+".xls"
	//Definição de Fonte e Tamanho
	oExcel:SetFontSize(8)			//Fonte da Tabela
	oExcel:SetTitleSizeFont(10) 	//Tamanho da Fonte de Titulo de Cabecalho
	oExcel:SetFont('Calibri')		//Fonte da planilha

	//Geração de Abas
	oExcel:AddworkSheet(alltrim(_cVar1))  				//Nome da Aba
	oExcel:AddTable(alltrim(_cVar1),alltrim(_cVar2))			// Titulo da tabela contendo o nome completo do usuário

	//Criação dos titulos das Colunas
	//={"Contrato","Código","Tipo","Desc. Tipo","Código","Loja","Fornecedor","Situação","Revisão","Dt Início","Dt Término","Vlr Inicial","Vlr Atual","Vlr Saldo","Vlr Medições"}
	for i:=1 to Len(_aCab)
		if i==1 .or. i==2 .or. i==4 .or. i==5 .or. i==8 .or. i==12   
			oExcel:AddColumn(alltrim(_cVar1),alltrim(_cVar2),_aCab[i],2,1,.F.)
		elseif i==9 .or. i==10 .or. i==11   
			oExcel:AddColumn(alltrim(_cVar1),alltrim(_cVar2),_aCab[i],2,4,.F.)
		elseif i==13 .or. i==14 .or. i==15 .or. i==16
			oExcel:AddColumn(alltrim(_cVar1),alltrim(_cVar2),_aCab[i],3,3,.F.)
		else 
			oExcel:AddColumn(alltrim(_cVar1),alltrim(_cVar2),_aCab[i],1,1,.F.)
		Endif
	Next i
	//Gerando as Linhas
	for i:=1 to Len(_aDados)
		_aColLin:={}
		if len(_aCab) > 1
			for x:=1 to len(_aCab)
				aadd(_aColLin,_aDados[i,x])
			Next x
			_cConta:=_aDados[i,1]
		Else
			aadd(_aColLin,_aDados[i])
		Endif
		oExcel:AddRow(alltrim(_cVar1),alltrim(_cVar2),_aColLin)
	Next i

	oExcel:Activate()
	oExcel:GetXMLFile(_cFile)
	ShellExecute("Open",_cFile,"",GetTempPath(),1)
Return(.T.)
