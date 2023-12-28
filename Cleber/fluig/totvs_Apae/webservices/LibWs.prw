#include 'protheus.ch'
#include 'totvs.ch'
#include 'topconn.ch'
#include 'tbiconn.ch'
#INCLUDE 'RWMAKE.CH' 

/*/{Protheus.doc} LibWs
Fonte contendo varios fontes utilizados no processo de integracao.
@author    Adriano Reis
@since     02/04/2022
@version   ${1.0}
/*/

User Function RmvCEsp(cMSg)
	Default cMSg := ""

    cMSg := FWNoAccent(cMSg)
	cMSg := StrTran(cMSg, "�", "a")
	cMSg := StrTran(cMSg, "�", "e")
	cMSg := StrTran(cMSg, "�", "i")
	cMSg := StrTran(cMSg, "�", "o")
	cMSg := StrTran(cMSg, "�", "u")
	cMSg := StrTran(cMSg, "�", "A")
	cMSg := StrTran(cMSg, "�", "E")
	cMSg := StrTran(cMSg, "�", "I")
	cMSg := StrTran(cMSg, "�", "O")
	cMSg := StrTran(cMSg, "�", "U")
	cMSg := StrTran(cMSg, "�", "a")
	cMSg := StrTran(cMSg, "�", "o")
	cMSg := StrTran(cMSg, "�", "A")
	cMSg := StrTran(cMSg, "�", "O")
	cMSg := StrTran(cMSg, "�", "a")
	cMSg := StrTran(cMSg, "�", "e")
	cMSg := StrTran(cMSg, "�", "i")
	cMSg := StrTran(cMSg, "�", "o")
	cMSg := StrTran(cMSg, "�", "u")
	cMSg := StrTran(cMSg, "�", "A")
	cMSg := StrTran(cMSg, "�", "E")
	cMSg := StrTran(cMSg, "�", "I")
	cMSg := StrTran(cMSg, "�", "O")
	cMSg := StrTran(cMSg, "�", "U")
	cMSg := StrTran(cMSg, "�", "c")
	cMSg := StrTran(cMSg, "�", "C")
	cMSg := StrTran(cMSg, "�", "a")
	cMSg := StrTran(cMSg, "�", "A")
	cMSg := StrTran(cMSg, "�", ".")
	cMSg := StrTran(cMSg, "�", ".")
	cMSg := StrTran(cMSg, chr (9), " ") // TAB
	cMSg := StrTran(cMSg, "�", ".")
    cMSg := StrTran(cMSg, "'", "")
    cMSg := StrTran(cMSg, "#", "")
    cMSg := StrTran(cMSg, "%", "")
    cMSg := StrTran(cMSg, "*", "")
    cMSg := StrTran(cMSg, ">", "")
    cMSg := StrTran(cMSg, "<", "")
    cMSg := StrTran(cMSg, "!", "")
    cMSg := StrTran(cMSg, "@", "")
    cMSg := StrTran(cMSg, "$", "")
    cMSg := StrTran(cMSg, "(", "")
    cMSg := StrTran(cMSg, ")", "")
    cMSg := StrTran(cMSg, "_", "")
    cMSg := StrTran(cMSg, "=", "")
    cMSg := StrTran(cMSg, "+", "")
    cMSg := StrTran(cMSg, "{", "")
    cMSg := StrTran(cMSg, "}", "")
    cMSg := StrTran(cMSg, "[", "")
    cMSg := StrTran(cMSg, "]", "")
    cMSg := StrTran(cMSg, "/", "")
    cMSg := StrTran(cMSg, "?", "")
    cMSg := StrTran(cMSg, ".", "")
    cMSg := StrTran(cMSg, "\", "")
    cMSg := StrTran(cMSg, "|", "")
    cMSg := StrTran(cMSg, ":", "")
    cMSg := StrTran(cMSg, ";", "")
    cMSg := StrTran(cMSg, '"', '')
    cMSg := StrTran(cMSg, '�', '')
    cMSg := StrTran(cMSg, '�', '')

Return(cMSg)
