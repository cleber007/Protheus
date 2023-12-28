#include 'protheus.ch'

//PE na rotina de geração de arquivo de envio CNAB a PAGAr (Fina420)
//O ponto de entrada FIN420_1 será chamado durante o looping do processamento (após o posicionamento SA2) - Cadastro de Fornecedores.
//Fabio Yoshioka - Tratamento para Fornecedores cujo pagamento será feito pelo CNPJ da Matriz - A2_CGCCNAB
*************************
User function FIN420_1() 
*************************
Local _aDad420:={}

	if !Empty(alltrim(SA2->A2_CGCCNAB))
		_aDad420	:= GetAdvFVal("SA2",{"A2_COD","A2_LOJA"},xFilial("SA2")+SA2->A2_CGCCNAB,3)
		IF LEN(_aDad420)>0
			dbSelectArea("SA2")
			dbSetorder(1)
			dbSeek(xFilial("SA2")+_aDad420[1]+_aDad420[2])
		ENDIF
	endif
	
return