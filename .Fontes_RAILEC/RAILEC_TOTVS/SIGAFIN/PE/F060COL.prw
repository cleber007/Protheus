#include 'protheus.ch'

User Function F060COL()

Local aCpo     := paramixb[1]
Local aRet     := {}
Local aLista   := {}
Local nPosData
           
aAdd(aLista, {"E1_OK","E1_FILIAL","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO","E1_NATUREZ","E1_CLIENTE","E1_LOJA","E1_NOMCLI","E1_EMISSAO","E1_VENCTO","E1_VENCREA","E1_VALOR","E1_TPCOB","E1_PEDIDO"})

For nx:=1 to Len(aLista[1]) step 1
	nPosData := aScan(aCpo,{|x| AllTrim(x[1])==aLista[1][nx]})
	aadd(aRet, aCpo[nPosData])
Next

Return aRet
