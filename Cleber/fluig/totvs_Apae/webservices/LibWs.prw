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
	cMSg := StrTran(cMSg, "á", "a")
	cMSg := StrTran(cMSg, "é", "e")
	cMSg := StrTran(cMSg, "í", "i")
	cMSg := StrTran(cMSg, "ó", "o")
	cMSg := StrTran(cMSg, "ú", "u")
	cMSg := StrTran(cMSg, "Á", "A")
	cMSg := StrTran(cMSg, "É", "E")
	cMSg := StrTran(cMSg, "Í", "I")
	cMSg := StrTran(cMSg, "Ó", "O")
	cMSg := StrTran(cMSg, "Ú", "U")
	cMSg := StrTran(cMSg, "ã", "a")
	cMSg := StrTran(cMSg, "õ", "o")
	cMSg := StrTran(cMSg, "Ã", "A")
	cMSg := StrTran(cMSg, "Õ", "O")
	cMSg := StrTran(cMSg, "â", "a")
	cMSg := StrTran(cMSg, "ê", "e")
	cMSg := StrTran(cMSg, "î", "i")
	cMSg := StrTran(cMSg, "ô", "o")
	cMSg := StrTran(cMSg, "û", "u")
	cMSg := StrTran(cMSg, "Â", "A")
	cMSg := StrTran(cMSg, "Ê", "E")
	cMSg := StrTran(cMSg, "Î", "I")
	cMSg := StrTran(cMSg, "Ô", "O")
	cMSg := StrTran(cMSg, "Û", "U")
	cMSg := StrTran(cMSg, "ç", "c")
	cMSg := StrTran(cMSg, "Ç", "C")
	cMSg := StrTran(cMSg, "à", "a")
	cMSg := StrTran(cMSg, "À", "A")
	cMSg := StrTran(cMSg, "º", ".")
	cMSg := StrTran(cMSg, "ª", ".")
	cMSg := StrTran(cMSg, chr (9), " ") // TAB
	cMSg := StrTran(cMSg, "ª", ".")
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
    cMSg := StrTran(cMSg, '°', '')
    cMSg := StrTran(cMSg, 'ª', '')

Return(cMSg)
