User Function MDEMENU()

Local aRotina := {}

aRotina := {{ "Pesquisar" 	, "PesqBrw" 	,0,1,0,.F.},; 
			{ "Wiz.Config."	, "SpedNFeCfg" 	,0,3,0,.F.},; 
			{ "Configurar" 	, "btConfig" 	,0,3,0,.F.},; 
			{ "Sincroniza" 	, "Sincronizar" ,0,3,0,.F.},; 
			{ "Manifestar"	, "Manifest" 	,0,2,0,.F.},; 
			{ "Monitorar"	, "MontaMonitor",0,2,0,.F.},; 
			{ "Exportar"	, "BaixaZip(0)" ,0,2,0,.F.},; 
			{ "Legenda"		, "BtLegenda" 	,0,3,0,.F.},; 
			{ "MD-e manual"	, "MDeInclui" 	,0,3,0,.F.},; 
			{ "Manutenção"	, "U_ManutMan()",0,3,0,.F.}} 
Return aRotina
