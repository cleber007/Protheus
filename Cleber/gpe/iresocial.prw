#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#DEFINE _EOL	CHR(13)+CHR(10)

/*/
//|--------------------------------------------------------------|
//| Programa  | CCCGPE21()                                        |
//| Autor     | Cleber Paiva                                     |
//| Data      | 27/06/2023                                       | 
//|--------------------------------------------------------------|
//| Descricao | Programa Especifico Calcula IRRF eSocial         |
//|--------------------------------------------------------------|
/*/

USER FUNCTION CCCGPE21() 



  Local aArea           := GetArea()
  Local I,cQry
  Local cFolMes	      	:= cPeriodo /*'202307'SuperGetMv("MV_FOLMES")  */
  Local cMatr           := SRA->RA_MAT
  Local cFilialorg      := SRA->RA_FILIAL
  Local nTotal          := 0


    For i := 1 to Len(aPd)

      //**** ATUALIZAR A VERBA S06 CASO EXISTA A VERBA 449 ****
       If aPd[i,1] $ "010" 

        IF(SELECT("QR") > 0)
          QR->(dbCLOSEAREA())
        ENDIF           

        cQry := " SELECT RR_FILIAL AS FILIAL"
        cQry += " , RR_MAT AS MATRICULA" "
        cQry += " , SUM (RR_VALOR) AS VALOR"
        cQry += " FROM "+RetSqlName("SRR")+" RR"
        cQry += " INNER JOIN "+RetSqlName("SRV")+" RV ON  RR_PD = RV_COD AND RV.D_E_L_E_T_ <> '*' "
        cQry += " WHERE  RV_CODFOL = '0067' AND  SUBSTRING(RR_DATAPAG ,1,6)  BETWEEN '"+ cFolMes+"' AND '"+ cFolMes+"'"
        cQry += " AND RR_MAT = '"+cMatr+"' AND RR_FILIAL = '"+cFilialorg+"'"	
        cQry += " AND	RR.D_E_L_E_T_ <> '*' 	"												
        cQry += " GROUP BY RR_FILIAL, RR_MAT"
        TCQUERY cQry NEW ALIAS "QR"
                
        //dbSelectArea("QRY")

        nTotal :=  QR->VALOR

        IF nTotal > 0   
          FGeraVerba("S06",nTotal,1,"01",SRA->RA_CC,"V","I",Nil,Nil,,.F.,)
        ENDIF

       Endif 
        
    Next

/*     For i := 1 to Len(aPd)

    //**** ATUALIZAR A VERBA A05 CASO EXISTA A VERBA A04 ****
/* 	If aPd[i,1] $ "449" 	
            _nVbProv1    :=  ABS( fBuscaPD("A04") )
            _nVbProv2    :=  ABS( fBuscaPD("449") )
            _nVbTotPD2   := _nVbProv2 -_nVbProv1
            
        IF ( _nVbTotPD2 >= 0 )
            _nVbTotPD3   := _nVbTotPD2
        Else
            _nVbTotPD3   := 0
        Endif


        //**** GERA A VERBA A05 ****
               FGeraVerba("A05",_nVbTotPD3,1,"01",SRA->RA_CC,"V","I",Nil,Nil,,.F.,)
		
	EndIf 

Next */

    RestArea(aArea)
Return
