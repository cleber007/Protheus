#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#Include "Totvs.ch"

// Antonio Carlos
// AL_ATIVADU -- Ativa e Desativa a utilização do Due Diligence
// AL_DUEUSER -- Usuários com permissão de visualizar os LOGs

User Function MA020ROT()   
	Local aRetorno 		:= {}
	Local _lDueEnvio	:= SuperGetMV("AL_ATIVADU",.F.,.F.)

	AAdd(aRetorno,{"Itens Contabeis","U_itemCTB2",0,9,0}) 
	AAdd(aRetorno,{"% Fornecedores","U_EstForne",0,7,0})
	if _lDueEnvio
		AAdd(aRetorno,{"RE-Envio Due Diligence","U_DUEAGAIN",0,7,0})
		/*
		if RetCodUsr() $ SuperGetMv('AL_DUEUSER',.F.,'')
			AAdd(aRetorno,{"Log Due Diligence","U_LOGDUE",0,7,0})
		Endif
		*/
	Endif
	
	//10/05/18- 1.01.05.01.16 - Bloqueio de Pagamento de Títulos e de Fornecedores - FABIO YOSHIOKA
	If nModulo == 6 //somente para modulo Financeiro 
		AAdd(aRetorno,{"Blq/Desblq FIN","U_ALBlqFor",0,7,0})
	endif

Return(aRetorno)

User Function itemCTB2()
	Local nTotIC := 0

	If MsgNoYes("Esta rotina ira atualizar todos os fornecedores que nao tenham cadastro nos Itens Contabeis. Deseja continuar?")
		dbSelectarea("SA2")
		SA2->(dbSetorder(1))
		SA2->(dbGotop())

		While !SA2->(Eof())
			dbSelectarea("CTD")
			CTD->(dbSetorder(1))
			CTD->(dbGotop())

			If !CTD->(dbSeek(xFilial("CTD") + SA2->A2_COD))
				While !RecLock("CTD",.T.);EndDo 		 
				CTD->CTD_FILIAL	:= xFilial("CTD")
				CTD->CTD_ITEM   	:= SA2->A2_COD
				CTD->CTD_DESC01	:= SA2->A2_NOME
				CTD->CTD_DESC02	:= SA2->A2_NREDUZ
				CTD->CTD_CLASSE	:= "2"
				CTD->CTD_BLOQ  	:= "2"
				CTD->(msUnlock())
				CTD->(dbCommitAll())
				nTotIC++
			Endif

			dbSelectarea("SA2")
			SA2->(dbSkip())
		Enddo

		Alert(strZero(nTotIC,6,0)+" FORNECEDOR(S) incluido(s) no Item Contabil!")
	Endif
Return(nil)


//10/05/18- 1.01.05.01.16 - Bloqueio de Pagamento de Títulos e de Fornecedores - FABIO YOSHIOKA
User Function ALBlqFor()
Local cUserBlq := RetCodUsr()
Local _nTpBloq:=0
Local _cInfHist:=space(200)
Local _cTxtMail:=""
Local _cTit:=""
Local _cEmail:=""
Local _cmailCC:=""
Local _cMailBlqFin:=RTRIM(GETMV("AL_MBLQPGT")) //24/05/18 - Enviar Notificação a outros usuarios
	
IF EMPTY(ALLTRIM(SA2->A2_ALUSRBL))
	IF MsgYesNo("Confirma BLOQUEIO do Fornecedor "+RTRIM(SA2->A2_NOME)+" ?")
		
		while empty(alltrim(_cInfHist))
			//Informar motivo para histórico   
			DEFINE MSDIALOG _oDlgExc TITLE "Informe Motivo do Bloqueio" FROM 000, 000  TO 120, 470 COLORS 0, 16777215 PIXEL
			@ 001, 002 MSGET _oGetHist VAR _cInfHist SIZE 200, 012 
			@ 003, 020 BUTTON oButton2 PROMPT "OK" SIZE 050, 012 Action _oDlgExc:End()
			ACTIVATE MSDIALOG _oDlgExc Centered
		enddo
	
		While !RecLock("SA2",.F.); EndDo
			_nTpBloq:=1
			SA2->A2_ALUDTBL:=Dtos(DATE())+Substr(Time(),1,2)+Substr(Time(),4,2)
			SA2->A2_ALUSRBL:=cUserBlq
			SA2->A2_ALHISBL:=_cInfHist
			SA2->(MSUnlock())
			
			_cTxtMail:=" BLOQUEIO DE PAGAMENTOS A FORNECEDOR "+SA2->A2_COD+"-"+RTRIM(SA2->A2_NOME)+ CHR(13) + CHR(10)+ CHR(13) + CHR(10)
			_cTxtMail+=" MOTIVO:"+ CHR(13) + CHR(10) 
			_cTxtMail+=_cInfHist+ CHR(13) + CHR(10) 
			_cTxtMail+=Dtoc(DATE())+" "+Substr(Time(),1,2)+":"+Substr(Time(),4,2)
			
			_cTit:="BLQFOR - BLOQUEIO PAGAMENTO - FORNECEDOR:"+SA2->A2_COD+"-"+RTRIM(SA2->A2_NOME)
			_cEmail:=UsrRetMail(cUserBlq)
			
			if !empty(alltrim(_cMailBlqFin)) //24/05/18
				_cEmail+=";"+_cMailBlqFin
			endif
			
			_cmailCC:=""
			
			U_AL_Mail(_cTxtMail, _cEmail, _cTit, _cmailCC)
	ENDIF
ELSE
	IF MsgYesNo("Confirma DESBLOQUEIO do Fornecedor "+RTRIM(SA2->A2_NOME)+" ?")
	
		_cTxtMail:=" DESBLOQUEIO DE PAGAMENTOS DO FORNECEDOR "+SA2->A2_COD+"-"+RTRIM(SA2->A2_NOME)+ CHR(13) + CHR(10)+ CHR(13) + CHR(10)
		_cTxtMail+=" Usuario: "+UsrFullName(cUserBlq)+ CHR(13) + CHR(10)
		_cTxtMail+=Dtoc(DATE())+" "+Substr(Time(),1,2)+":"+Substr(Time(),4,2)
		
		_cTit:="BLQFOR - DESBLOQUEIO PAGAMENTO - FORNECEDOR:"+SA2->A2_COD+"-"+RTRIM(SA2->A2_NOME)
		_cEmail:=UsrRetMail(SA2->A2_ALUSRBL)
		
		if !empty(alltrim(_cMailBlqFin)) //24/05/18
			_cEmail+=";"+_cMailBlqFin
		endif
		
		_cmailCC:=""
	
		While !RecLock("SA2",.F.); EndDo
			_nTpBloq:=2
			SA2->A2_ALUDTBL:=Dtos(DATE())+Substr(Time(),1,2)+Substr(Time(),4,2)
			SA2->A2_ALUSRBL:=SPACE(6)
			SA2->A2_ALHISBL:=""
			SA2->(MSUnlock())
		
		U_AL_Mail(_cTxtMail, _cEmail, _cTit, _cmailCC)	

	ENDIF
ENDIF
	
if _nTpBloq>0	
	MSGInfo( iif(_nTpBloq==1,"BLOQUEIO","DESBLOQUEIO")+ " do Fornecedor "+rtrim(SA2->A2_NOME) +" foi realizado com sucesso!")
endif

Return