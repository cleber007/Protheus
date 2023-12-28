#INCLUDE 'PROTHEUS.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"
/*/
Formula desativada Ucargarc
Conforme alinhado, será necessário fazer um fonte, para disponibilizar nos roteiros de VT/VR/VA do cliente,
pois a rotina de benefícios passou por uma atualização, e a fórmula que realizava o cálculo, não é mais aderente.
Para o cálculo desses benefícios, o sistema deve sempre considerar os dias de pagamento do benefício,
os dias do próximo mês. Por exemplo, ao calcular os benefícios na competência 02/2020, que possuem 18 dias úteis,
deve se considerar para o calculo, os dias da competência 03/2020, que no exemplo, são 22 dias.


/*/
user function DiasBenf()
    Local cPeriodoBk    := GetPeriodCalc()
    Public cTipoRot     := SRY->RY_TIPO
    //------------------------------------------------
    //Abaixo regra usada na formula Ucargarc
    //ATUALIZA CPERIODO
    if Type('aPeriodo')  == 'U'
        Public aPeriodo := {}
    EndIf
    if Type('nPosSem') == 'U'
        Public nPosSem := 0
    Endif
    If Type('cPeriodo')  == 'U'
        Public cPeriodo := GetPeriodCalc()
    else
        cPeriodo := GetPeriodCalc()
    EndIf
    If Type('APERIODO2') == 'U'
        Public APERIODO2 := GetValType('A')
    EndIf
    If Type('LULTSEM2')  == 'U'
        Public LULTSEM2 := GetValType('L')
    EndIf
    If Type('NPOSSEM2')  == 'U'
        Public NPOSSEM2 := GetValType('N')
    EndIf
    If Type('ADIASMES')  == 'U'
        Public ADIASMES :=GetValType('A')
    EndIf

    cPeriodo    := IIf(Val(SubStr(cPeriodo,5,2)) == 12, StrZero(Val(SubStr(cPeriodo,1,4)) + 1,4)+"01", SubStr(cPeriodo,1,4)+StrZero(Val(SubStr(cPeriodo,5,2))+1,2))
    cSemana     := cNumPag := If(Empty(cNumPag),GetNumPgCalc(),cNumPag)
    cProcesso   := SRA->RA_PROCES
    cRot        := If(Empty(cRot),GetRotExec(),cRot)
    cRot        := If(cRot=="INC",If(SRA->RA_CATFUNC $ "P*A",fGetCalcRot("9"),fGetRotOrdinar()),cRot)
    
    fCarPeriodo( cPeriodo , cRot , @aPeriodo, @lUltSemana, @nPosSem)

    P_DIASRES   := If(Type('P_DIASRES') <> 'U', P_DIASRES, 0)
    P_LDSRHRSP  := Type("P_LDSRHRSP") # "U" .And. P_LDSRHRSP

    lPropAdm := If(cTipoRot == "8",aPergunte[2,3] == 1, aPergunte[1,3] == 1)
    fCarDiasMes(@ADIASMES,lPropAdm)

    cPeriodo  := cPeriodoBk
    //fCarPeriodo( cPeriodo , cRot , @aPeriodo, @lUltSemana, @nPosSem)

Return

   /*/ IF LEN(aPeriodo) > 0
        dDataDe     := aPeriodo[nPosSem,3]
        dDataAte    := aPeriodo[nPosSem,4]
        cComp13     := If( ( P_CCOMP13 == "S" .And. cRot == fGetCalcRot("1") ) .And.  Month(dDataAte) == 12, "S", "N")
        dTarIni     := If(Empty(aPeriodo[nPosSem,22]),DdataDe,aPeriodo[nPosSem,22])
        dTarFim     := If(Empty(aPeriodo[nPosSem,23]),dDataAte,aPeriodo[nPosSem,23])
        cAnoMes     := aPeriodo[nPosSem,15] + aPeriodo[nPosSem,16]
        dData_Pgto  := aPeriodo[nPosSem,17]
        dDataRef    := CTOD("01/" + aPeriodo[nPosSem,16] + "/" + aPeriodo[nPosSem,15])
        cSitFolh    := fBuscaSituacao( SRA->RA_FILIAL , SRA->RA_MAT , dDataDe)
        NDIASC      := IF(aPeriodo[NPOSSEM,16]=="02" .AND. !P_PGSALFEV .AND. (!EMPTY(CSITFOLH) .OR. (DAY(SRA->RA_ADMISSA) > 01 .AND. (MONTH(SRA->RA_ADMISSA)==2 .AND. YEAR(SRA->RA_ADMISSA) == VAL(aPeriodo[NPOSSEM,15])))),aPeriodo[NPOSSEM,18], aPeriodo[NPOSSEM,20])

        IF cRot == "RES"   //.END.
            NDIASC := IF( ((aPeriodo[NPOSSEM,18] == 31 .Or. aPeriodo[NPOSSEM,16] == "02") .And. P_DIASRES = 1), aPeriodo[NPOSSEM,18], aPeriodo[NPOSSEM,20])
            IF cCompl == "S" .And. LPROXMES .AND. P_DIASRES == 1
                aPeriodo2   := {}
                lUltSem2    := .F.
                nPosSem2    := 0
                fCarPeriodo( AnoMes(dDataDem) , cRot , @aPeriodo2, @lUltSem2, @nPosSem2)
                NDIASC      := IF( ((APERIODO2[NPOSSEM2,18] == 31 .Or. APERIODO2[NPOSSEM2,16] == "02") .And. P_DIASRES = 1), APERIODO2[NPOSSEM2,18], APERIODO2[NPOSSEM2,20])
            EndIf
        EndIf
        IF ISINCALLSTACK("GPEM070") .AND. SRA->RA_CATFUNC == "H"
            NDIASC := 30
            lCalcCompl := aPeriodo[nPosSem,25] == "1"
            NSVNORMAL := NORMAL     := aPeriodo[nPosSem,24] * SRA->RA_HRSDIA
            NSVDESCAN := DESCANSO   := aPeriodo[nPosSem,07] * SRA->RA_HRSDIA
        EndIf
        IF NDIASC > 0 .AND. SRA->RA_HRSDIA > 0
            nHrsCal := Round((SRA->RA_HRSDIA * nDiasC),2)
        EndIf
        IF P_LDSRHRSP   //.END.
            fHTrabCalen( dDataDe, dDataAte )
            nHrsCal := Round( (nPonTrab + nPonDesc), 2)
            IF nHrsCal == 0   //.END.
                nHrsCal     := Round((SRA->RA_HRSDIA * nDiasC),2)
                nPonTrab    := NORMAL   := NSVNORMAL
                nPonDesc    := DESCANSO := NSVDESCAN
            EndIf
        EndIf
        IF LCALCCOMPL
            IF !FVERCOMPL()
                FINALCALC()
            EndIf
            nDiasP := aPeriodo[nPosSem,18]
            P_nTotDias := If(P_nTotDias == 0, 7, P_nTotDias)
            fPosReg("SRY", 1, FwxFilial("SRY") + cRot)
            cTipoRot := SRY->RY_TIPO
        EndIf
    EndIf
    IF (CTIPOROT = '1') .AND. MONTH(DDATAATE) == 12 .AND. !FCOMP13F
        CMSGLOG := FMSGFORM({}) + "O PERIODO '" + CPERIODO + "' NÃO ESTÁ FECHADO PARA 13 SALÁRIO. FECHE O PERIODO PARA QUE SEJA POSSIVEL CALCULAR O COMPLEMENTO PARA 13 SALÁRIO."
        ADDLOGEXECROT( CMSGLOG )
        CFILCALC := "#####"
        IF FwxFilial("RCH") <> FwxFilial("RCJ")
            NoPrcReg()
        EndIf
        IF FwxFilial("RCH") == FwxFilial("RCJ")
            FINALCALC()
        EndIf
    EndIf
    IF LEN(aPeriodo) <= 0 .OR. EMPTY(DDATAREF) .OR. EMPTY(CANOMES)
        IF CFILCALC <> SRA->RA_FILIAL .AND. CFILCALC <> "#####"
            CMSGLOG := FMSGFORM({}) + "A configuração dos periodos está incorreta ou não existem dados válidos no período que está sendo calculado. Verifique o cadastro de períodos. Processo -> " + cProcesso + ". Filial -> " + SRA->RA_FILIAL
            AddLogExecRot( cMsgLog )
            cFilCalc := "#####"
        EndIf
        IF FwxFilial("RCH") <> FwxFilial("RCJ")
            NoPrcReg()
        EndIf
        IF FwxFilial("RCH") == FwxFilial("RCJ")
            FINALCALC()
        EndIf
    EndIf
    IF CTIPOROT <> "3" .AND. LEN(aPeriodo) > 0 .AND. aPeriodo[NPOSSEM,26] <> "1" .AND. !LDISSIDIO .AND. !LRESCDIS .AND. ( CTIPOROT <> '4' .OR. M->RG_EFETIVA = 'S') .AND. CTIPOROT <> 'C' .AND. !(ISINCALLSTACK("GPEM070"))
        IF (!(CTIPOROT = '6') .AND. P_CCOMP13 = 'N')
            IF CFILCALC <> SRA->RA_FILIAL .AND. CFILCALC <> "#####"
                CMSGLOG := FMSGFORM({}) + "O periodo '" + cPeriodo + "' não está ativo. Selecione um periodo ativo para o cálculo. Processo -> " + cProcesso + ". Filial -> " + SRA->RA_FILIAL
                AddLogExecRot( cMsgLog )
                cFilCalc := "#####"
            EndIf
            IF FwxFilial("RCH") <> FwxFilial("RCJ")
                NoPrcReg()
            EndIf
            IF FwxFilial("RCH") == FwxFilial("RCJ")
                FINALCALC()
            EndIf
        EndIf
    EndIf
/*/
