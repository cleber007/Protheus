#include 'protheus.ch'


user function F370CTBUSR()//09/10/18 - F�bio Yoshioka - Chamado 19755

if Type("_lCtbGPE") == "L"  //Retiro a variavel publica ap�s a execu��o da contabiliza off line - 09/10/2018 - Fabio Yoshioka
	FreeObj(_lCtbGPE)
	_lCtbGPE:= Nil
endif
	
return