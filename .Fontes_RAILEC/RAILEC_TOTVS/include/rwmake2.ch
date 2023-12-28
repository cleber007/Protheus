#include 'std.ch'

#Translate User Function <cNome> => Function U_<cNome>
#Translate HTML Function <cNome> => Function H_<cNome>
							  
#Command @ <nTop>, <nLeft> TO <nBottom>,<nRight> DIALOG <oDlg> [TITLE <cTitle>] ;
	=> <oDlg> := MSDialog():New(<nTop>, <nLeft>, <nBottom>, <nRight>, OemToAnsi(<cTitle>),,,,,,,,,.t.,,,)
	
#Command ACTIVATE DIALOG <oDlg> [<center: CENTERED,CENTER>] [ ON INIT <bInit> ] [ VALID <bValid> ] ;
	=> <oDlg>:Activate(,,, <.center.>, [{|Self|<bValid>}], , [{|Self|<bInit>}])
	
#Command @ <nRow>, <nCol> BITMAP [<oBmp>] SIZE <nWidth>,<nHeight> FILE <cFile> ;
    => AllwaysTrue() // [ <oBmp> := ] TBitMap():New(<nRow>, <nCol>, <nWidth>, <nHeight>,, <cFile>, .t., , , , , , , , , , .t.)

#xcommand Debug <Flds,...> => MsgDbg(\{ <Flds> \}
#xcommand @ <nRow>, <nCol> PSAY <cText> [ PICTURE <cPict> ] => PrintOut(<nRow>,<nCol>,<cText>,<cPict>)

#Translate PROW( => _PROW(
#Translate PCOL( => _PCOL(
#TransLate DEVPOS( => _DEVPOS(

#Translate PLAYWAVE( => SndPlaySound(

#Translate CLOSE(<oObj>) => <oObj>:End()

#Translate MSGBOX( => IW_MsgBox(

#Command @ <nRow>, <nCol> BUTTON <cCaption> [SIZE <nWidth>,<nHeight>] ACTION <cAction> [ OBJECT <oBtn>] ;
    => [ <oBtn> := ] TButton():New( <nRow>, <nCol>, OemToAnsi(StrTran(<cCaption>, '_', '&')) , , [{|Self|<cAction>}], <nWidth>, <nHeight>,,,,.t.)

#Command @ <nRow>,<nCol> SAY <cSay> [PICTURE <cPicture>] [<color: COLOR,COLORS> <nCor> [,<nCorBack>] ] [SIZE <nWidth> [,<nHeight>] ] [OBJECT <oSay>] ;
    => [ <oSay> := ] IW_Say(<nRow>,<nCol>,<cSay>,[<cPicture>],[<nCor>],[<nCorBack>],[<nWidth>],[<nHeight>] ) // ,<{cSay}>) // removido code-block para combitibilizacao dos rdmakes antigos no Protheus

#Command @ <nRow>,<nCol> GET <cVar> [PICTURE <cPicture>] [VALID <bValid>] [WHEN <bWhen>] [F3 <cF3>] [SIZE <nW>,<nH>] [OBJECT <oGet>] [<lMemo: MEMO>] [<lPass: PASSWORD>];
	=> [ <oGet> := ] IW_Edit(<nRow>,<nCol>,<(cVar)>,[<cPicture>],<nW>,<nH>,[\{||<bValid>\}],[\{||<bWhen>\}],[<cF3>],[<.lMemo.>],[<.lPass.>],[{|x| iif(PCount()>0,<cVar> := x,<cVar>) }])

#Command @ <nRow>,<nCol> LISTBOX <nList> ITEMS <aList> SIZE <nWidth>,<nHeight> [<sort: SORTED>] [OBJECT <oLbx>] ;
    => [ <oLbx> := ] TListBox():New(<nRow>,<nCol>, [{|x| iif(PCount()>0,<nList> := x,<nList>) }] ,<aList>,<nWidth>,<nHeight>,,,,,,.t.,,,,,,,,,,[<.sort.>])

#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> [TITLE <cTitle>] [OBJECT <oGrp>] ;
    => [ <oGrp> := ] TGroup():New(<nRow>,<nCol>,<nToRow>,<nToCol>,OemToAnsi(<cTitle>),, , ,.t.)

#Command @ <nRow>,<nCol> CHECKBOX <cCaption> VAR <lCheck> [OBJECT <oCbx>];
    => [ <oCbx> := ] IW_CheckBox(<nRow>,<nCol>,<cCaption>,<(lCheck)>)

#Command @ <nRow>,<nCol> RADIO <aRadio> VAR <nSelect> [OBJECT <oRdx>] ;
    => [ <oRdx> := ] IW_Radio(<nRow>,<nCol>,<(nSelect)>,<aRadio>)

#Command @ <nRow>,<nCol> COMBOBOX <cVar> ITEMS <aCombo> SIZE <nWidth>,<nHeight> [OBJECT <oCox>] ;
    => [ <oCox> := ] TComboBox():New(<nRow>,<nCol>,[{ |x| If(x<>nil,<cVar> := x,nil) , <cVar> }],<aCombo>,<nWidth>,<nHeight>,, , , , , ,.t.)

#Command @ <nRow>, <nCol> BMPBUTTON TYPE <nType> ACTION <cAction> [OBJECT <oBmt>] [<lEnable:ENABLE>] ;
    => [ <oBmt> := ] SButton():New(<nRow>, <nCol>, <nType>, [{|| <cAction>}],,<lEnable>)

#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> BROWSE <cAlias> [MARK <cMark>] [ENABLE <cEnable>] [ OBJECT <oBrw> ] [ FIELDS <aFields> ];
	=> [ <oBrw> := ] IW_Browse(<nRow>,<nCol>,<nToRow>,<nToCol>,<cAlias>,<cMark>,<cEnable> [,<aFields>])

#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> MULTILINE [<lModi: MODIFY>] [<lDel: DELETE>] [VALID <bLineOk>] [FREEZE <nFreeze>] [OBJECT <oMtl>] ;
	=> [ <oMtl> := ] IW_MultiLine(<nRow>,<nCol>,<nToRow>,<nToCol>,<.lModi.>,<.lDel.>,[\{||<bLineOk>\}],<nFreeze>)
	
#xcommand DEFINE TIMER [ <oTimer> ] [ INTERVAL <nInterval> ] [ ACTION <uAction,...> ] ;
    => [ <oTimer> := ] TTimer():New( <nInterval>, [\{||<uAction>\}],  )

#xCommand Debug <Flds,...> => MsgDbg(\{ <Flds> \})


#XCOMMAND @ <nRow>, <nCol> PSAY <cText> [FONT <oFont> ][ PICTURE <cPict> ] => PrintOut(<nRow>,<nCol>,<cText>,<cPict>,<oFont>)

#Translate User Function <cNome> => Function U_<cNome>
#Translate Project Function <cNome> => Function P_<cNome>
#Translate Web Function <cNome> => Function W_<cNome>
#Translate HTML Function <cNome> => Function H_<cNome>

#Translate PROW( => _PROW(
#Translate PCOL( => _PCOL(
#TransLate DEVPOS( => _DEVPOS(

#xcommand ACTIVATE TIMER <oTimer> => <oTimer>:Activate()

#xtranslate oSend( <o>,<m> [,<param,...>] ) => OSEND <o> METHOD <m> [ PARAM \{<param>\} ]
#xtranslate OSEND <o> METHOD <m> [PARAM <param>] => PT_oSend( <(o)>,<m>,<o> [,<param> ] )
#xtranslate OSEND <o>() METHOD <m> [PARAM <param>] => PT_oSend( <(o)>+"()",<m>, [,<param>] )

#define CRLF Chr(13)+Chr(10)

/*----------------------------------------------------------------------------//
!short: Running multiple instances of a FiveWin EXE */

#xcommand SET MULTIPLE <on:ON,OFF> => SetMultiple( Upper(<(on)>) == "ON" )

/*----------------------------------------------------------------------------//
!short: ACCESSING / SETTING Variables */

#xtranslate bSETGET(<uVar>) => ;
				{ | u | If( PCount() == 0, <uVar>, <uVar> := u ) }

/*----------------------------------------------------------------------------//
!short: Default parameters management */

#xcommand DEFAULT <uVar1> := <uVal1> ;
					[, <uVarN> := <uValN> ] => ;
						<uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
					 [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

/*----------------------------------------------------------------------------//
!short: DO ... UNTIL support */

#xcommand DO				=> while .t.
#xcommand UNTIL <uExpr> => if <uExpr>; exit; end; end

/*----------------------------------------------------------------------------//
!short: Idle periods management */

#xcommand SET IDLEACTION TO <uIdleAction> => SetIdleAction( <{uIdleAction}> )

/*----------------------------------------------------------------------------//
!short: DataBase Objects */

#xcommand DATABASE <oDbf> => <oDbf> := TDataBase():New()

/*----------------------------------------------------------------------------//
!short: General release command */

#xcommand RELEASE <ClassName> <oObj1> [,<oObjN>] ;
		 => ;
			 Iif( <oObj1> <> NIL , ( <oObj1>:End(),<oObj1> := NIL),) ;
		  [ ; Iif ( <oObjN> <> NIL, ( <oObjN>:End(),<oObjN> := NIL),) ]

/*----------------------------------------------------------------------------//
!short: Brushes */

#xcommand DEFINE BRUSH [ <oBrush> ] ;
				 [ STYLE <cStyle> ] ;
				 [ COLOR <nRGBColor> ] ;
				 [ <file:FILE,FILENAME,DISK> <cBmpFile> ] ;
				 [ <resource:RESOURCE,NAME,RESNAME> <cBmpRes> ] ;
		 => ;
			 [ <oBrush> := ] TBrush():New( [ Upper(<(cStyle)>) ], <nRGBColor>,;
				 <cBmpFile>, <cBmpRes> )

#xcommand SET BRUSH ;
				 [ OF <oWnd> ] ;
				 [ TO <oBrush> ] ;
		 => ;
			 <oWnd>:SetBrush( <oBrush> )


#xcommand REDEFINE SAY [<oSay>] ;
				 [ <label: PROMPT, VAR> <cText> ] ;
				 [ PICTURE <cPict> ] ;
				 [ ID <nId> ] ;
				 [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
				 [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
				 [ <update: UPDATE > ] ;
				 [ FONT <oFont> ] ;
		 => ;
			 [ <oSay> := ] TSay():ReDefine( <nId>, <{cText}>, <oWnd>, ;
								<cPict>, <nClrText>, <nClrBack>, <.update.>, <oFont> )

#xcommand @ <nRow>, <nCol> SAY [ <oSay> <label: PROMPT,VAR > ] <cText> ;
				 [ PICTURE <cPict> ] ;
				 [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
				 [ FONT <oFont> ]  ;
				 [ <lCenter: CENTERED, CENTER > ] ;
				 [ <lRight:  RIGHT > 	] ;
				 [ <lBorder: BORDER >	] ;
				 [ <lPixel: PIXEL, PIXELS > ] ;
				 [ <color: COLOR,COLORS > <nClrText> [,<nClrBack> ] ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <design: DESIGN >  ] ;
				 [ <update: UPDATE >  ] ;
				 [ <lShaded: SHADED, SHADOW > ] ;
				 [ <lBox:	 BOX	 >  ] ;
				 [ <lRaised: RAISED > ] ;
		=> ;
			 [ <oSay> := ] TSay():New( <nRow>, <nCol>, <{cText}>,;
				 [<oWnd>], [<cPict>], <oFont>, <.lCenter.>, <.lRight.>, <.lBorder.>,;
				 <.lPixel.>, <nClrText>, <nClrBack>, <nWidth>, <nHeight>,;
				 <.design.>, <.update.>, <.lShaded.>, <.lBox.>, <.lRaised.> )

#xcommand @ <nTop>, <nLeft> [ GROUP <oGroup> ] TO <nBottom>, <nRight > ;
				 [ <label:LABEL,PROMPT> <cLabel> ] ;
				 [ OF <oWnd> ] ;
				 [ COLOR <nClrFore> [,<nClrBack>] ] ;
				 [ <lPixel: PIXEL> ] ;
				 [ <lDesign: DESIGN> ] ;
		 => ;
			 [ <oGroup> := ] TGroup():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
				 <cLabel>, <oWnd>, <nClrFore>, <nClrBack>, <.lPixel.>,;
				 [<.lDesign.>] )




#xcommand @ <nRow>, <nCol> BUTTON [<oBtn>] RESOURCE [ <cResName1> [,<cResName2>] ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>] ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ ACTION <uAction,...> ] ;
				 [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ <adjust: ADJUST> ] ;
				 [ UPDATE <lUpdate> ] ;
				 [ <pixel: PIXEL> ] ;
		=> ;
			[ <oBtn> := ] TBtnBmp():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
				<cResName1>, <cResName2>, <cBmpFile1>, <cBmpFile2>,;
				[{|Self|<uAction>}], <oWnd>, <cMsg>, <{uWhen}>, <.adjust.>,;
				<lUpdate> )

#xcommand DEFINE MSDIALOG <oDlg> ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
				 [ TITLE <cTitle> ] ;
				 [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
				 [ <lib: LIBRARY, DLL> <hResources> ] ;
				 [ <vbx: VBX> ] ;
				 [ STYLE <nStyle> ] ;
				 [ <color: COLOR, COLORS> <nClrText> [,<nClrBack> ] ] ;
				 [ BRUSH <oBrush> ] ;
				 [ <of: WINDOW, DIALOG, OF> <oWnd> ] ;
				 [ <pixel: PIXEL> ] ;
				 [ ICON <oIco> ] ;
				 [ FONT <oFont> ] ;
				 [ <status: STATUS> ] ;
		 => ;
			 <oDlg> = MsDialog():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
					  <cTitle>, <cResName>, <hResources>, <.vbx.>, <nStyle>,;
					  <nClrText>, <nClrBack>, <oBrush>, <oWnd>, <.pixel.>,;
					  <oIco>, <oFont> , <.status.> )

#xcommand ACTIVATE MSDIALOG <oDlg> ;
				 [ <center: CENTER, CENTERED> ] ;
				 [ <NonModal: NOWAIT, NOMODAL> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ ON [ LEFT ] CLICK <uClick> ] ;
				 [ ON INIT <uInit> ] ;
				 [ ON MOVE <uMoved> ] ;
				 [ ON PAINT <uPaint> ] ;
				 [ ON RIGHT CLICK <uRClicked> ] ;
		  => ;
			 <oDlg>:Activate( <oDlg>:bLClicked [ := <{uClick}> ], ;
									<oDlg>:bMoved	  [ := <{uMoved}> ], ;
									<oDlg>:bPainted  [ := <{uPaint}> ], ;
									<.center.>, [{|Self|<uValid>}],;
									[ ! <.NonModal.> ], [{|Self|<uInit>}],;
									<oDlg>:bRClicked [ := <{uRClicked}> ],;
									[{|Self|<uWhen>}] )

//----------------------------------------------------------------------------//
#command @ <nRow>, <nCol> MSGETS [ <oGet> VAR ] <uVar> ;
				[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
				[ PICTURE <cPict> ] ;
				[ VALID <ValidFunc> ] ;
				[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
				[ SIZE <nWidth>, <nHeight> ]	;
				[ FONT <oFont> ] ;
				[ <design: DESIGN> ] ;
				[ CURSOR <oCursor> ] ;
				[ <pixel: PIXEL> ] ;
				[ MESSAGE <cMsg> ] ;
				[ <update: UPDATE> ] ;
				[ WHEN <uWhen> ] ;
				[ <lCenter: CENTER, CENTERED> ] ;
				[ <lRight: RIGHT> ] ;
				[ ON CHANGE <uChange> ] ;
				 [ <readonly: READONLY, NO MODIFY> ] ;
		 => ;
			 [ <oGet> := ] MsGets():New( <nRow>, <nCol>, bSETGET(<uVar>),;
				 [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
				 <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
				 <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
				 <.lCenter.>, <.lRight.>,;
				 [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.> ,<(uVar)>)

#command @ <nRow>, <nCol> MSGET [ <oGet> VAR ] <uVar> ;
				[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
				[ PICTURE <cPict> ] ;
				[ VALID <ValidFunc> ] ;
				[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
				[ SIZE <nWidth>, <nHeight> ]	;
				[ FONT <oFont> ] ;
				[ <design: DESIGN> ] ;
				[ CURSOR <oCursor> ] ;
				[ <pixel: PIXEL> ] ;
				[ MESSAGE <cMsg> ] ;
				[ <update: UPDATE> ] ;
				[ WHEN <uWhen> ] ;
				[ <lCenter: CENTER, CENTERED> ] ;
				[ <lRight: RIGHT> ] ;
				[ ON CHANGE <uChange> ] ;
				[ <readonly: READONLY, NO MODIFY> ] ;
				[ <pass: PASSWORD> ] ;
				[ F3 <cAlias> ];
				[ <lNoBorder: NO BORDER, NOBORDER> ] ;
				[ <help:HELPID, HELP ID> <nHelpId> ] ;
				[ <lHasButton: HASBUTTON> ] ;
		 => ;
			 [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
				 [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
				 <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
				 <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
				 <.lCenter.>, <.lRight.>,;
				 [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
				 <.pass.> ,<cAlias>,<(uVar)>,,[<.lNoBorder.>], [<nHelpId>], [<.lHasButton.>] )

#xcommand REDEFINE MSGET [ <oGet> VAR ] <uVar> ;
				 [ ID <nId> ] ;
				 [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ VALID   <ValidFunc> ]		 ;
				 [ PICTURE <cPict> ] ;
				 [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
				 [ FONT <oFont> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ <readonly: READONLY, NO MODIFY> ] ;
				 [ F3 <cF3> ] ;
		 => ;
			 [ <oGet> := ] TGet():ReDefine( <nId>, bSETGET(<uVar>), <oDlg>,;
				 <nHelpId>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
				 <oFont>, <oCursor>, <cMsg>, <.update.>, <{uWhen}>,;
				 [ \{|nKey,nFlags,Self| <uChange> \}], <.readonly.> ,<cF3>,<(uVar)>)


#xcommand REDEFINE LISTBOX [ <oLbx> ] FIELDS [<Flds,...>] ;
				 [ ALIAS <cAlias> ] ;
				 [ ID <nId> ] ;
				 [ <dlg:OF,DIALOG> <oDlg> ] ;
				 [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
				 [ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
				 [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ ON [ LEFT ] CLICK <uLClick> ] ;
				 [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
				 [ ON RIGHT CLICK <uRClick> ] ;
				 [ FONT <oFont> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ <hScroll: NOSCROLL> ];
		 => ;
				  [ <oLbx> := ] TWBrowse():ReDefine( <nId>, ;
				  [\{|| \{ <Flds> \} \}], <oDlg>,;
				  [ \{<aHeaders>\}], [\{<aColSizes>\}],;
				  <(cField)>, <uValue1>, <uValue2>,;
				  [<{uChange}>],;
				  [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
				  [<{uRClick}>], <oFont>,;
				  <oCursor>, <nClrFore>, <nClrBack>, <cMsg>, <.update.>,;
				  <cAlias>, <{uWhen}>, <{uValid}>, <{uLClick}>, !<.hScroll.> )

#xcommand @ <nRow>, <nCol> LISTBOX [ <oBrw> ] FIELDS [<Flds,...>] ;
					[ ALIAS <cAlias> ] ;
					[ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
					[ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
					[ SIZE <nWidth>, <nHeigth> ] ;
					[ <dlg:OF,DIALOG> <oDlg> ] ;
					[ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
					[ ON CHANGE <uChange> ] ;
					[ ON [ LEFT ] CLICK <uLClick> ] ;
					[ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
					[ ON RIGHT CLICK <uRClick> ] ;
					[ FONT <oFont> ] ;
					[ CURSOR <oCursor> ] ;
					[ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
					[ MESSAGE <cMsg> ] ;
					[ <update: UPDATE> ] ;
					[ <pixel: PIXEL> ] ;
					[ WHEN <uWhen> ] ;
					[ <design: DESIGN> ] ;
					[ VALID <uValid> ] ;
					[ <hScroll: NOSCROLL> ];
		=> ;
			 [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeigth>,;
									[\{|| \{<Flds> \} \}], ;
									[\{<aHeaders>\}], [\{<aColSizes>\}], ;
									<oDlg>, <(cField)>, <uValue1>, <uValue2>,;
									[<{uChange}>],;
									[\{|nRow,nCol,nFlags|<uLDblClick>\}],;
									[\{|nRow,nCol,nFlags|<uRClick>\}],;
									<oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>,;
									<.update.>, <cAlias>, <.pixel.>, <{uWhen}>,;
									<.design.>, <{uValid}>, !<.hScroll.>,!<.hScroll.> )


#xcommand @ <nRow>, <nCol> REPOSITORY [ <oBmp> ] ;
				 [ <resource: ENTRY, RESOURCE> <cResName> ] ;
				 [ <NoBorder:NOBORDER, NO BORDER> ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
				 [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
				 [ <scroll: SCROLL> ] ;
				 [ <adjust: ADJUST> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ <pixel: PIXEL>   ] ;
				 [ MESSAGE <cMsg>   ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ <lDesign: DESIGN> ] ;
				 [ <filename: FROM FILE> <cFileName> ] ;
		 => ;
			 [ <oBmp> := ] TBmpRep():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
				 <cResName>, <.NoBorder.>, <oWnd>,;
				 [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
				 [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
				 <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
				 <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.>, <cFileName> )

#xcommand REDEFINE REPOSITORY [ <oBmp> ] ;
				 [ ID <nId> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ <resource: ENTRY, RESOURCE> <cResName> ] ;
				 [ <lClick: ON ClICK, ON LEFT CLICK> <uLClick> ] ;
				 [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
				 [ <scroll: SCROLL> ] ;
				 [ <adjust: ADJUST> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ MESSAGE <cMsg>   ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
		 => ;
			 [ <oBmp> := ] TBmpRep():ReDefine( <nId>, <cResName>,;
				 <oWnd>, [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
							[\{ |nRow,nCol,nKeyFlags| <uRClick> \}],;
				 <.scroll.>, <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
				 <{uWhen}>, <{uValid}> )

#xcommand DEFINE REPOSITORY [<oBmp>] ;
				 [ <resource: ENTRY, RESOURCE> <cResName> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
		 => ;
			 [ <oBmp> := ] TBmpRep():Define( <cResName>, <oWnd> )

#xcommand DEFINE TOOLBAR [ <oBar> ] ;
				 [ <size: SIZE, BUTTONSIZE, SIZEBUTTON > <nWidth>, <nHeight> ] ;
				 [ <_3d: 3D, 3DLOOK> ] ;
				 [ <mode: TOP, LEFT, RIGHT, BOTTOM, FLOAT> ] ;
				 [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ <file:FILE,FILENAME,DISK> <cBmpFile> ] ;
				 [ <resource:RESOURCE,NAME,RESNAME> <cBmpRes> ] ;
		=> ;
			[ <oBar> := ] TToolBar():New( <oWnd>, <nWidth>, <nHeight>, <._3d.>,;
				 [ Upper(<(mode)>) ], <oCursor> , <cBmpFile>, <cBmpRes>)

#xcommand DEFINE IEBUTTON [ <oBtn> ] ;
				 [ <bar: OF, BUTTONBAR > <oBar> ] ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
					 [,<cResName2>[,<cResName3>] ] ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
					 [,<cBmpFile2>[,<cBmpFile3>] ] ] ;
				 [ <action:ACTION,EXEC> <uAction,...> ] ;
				 [ <group: GROUP > ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ <adjust: ADJUST > ] ;
				 [ WHEN <WhenFunc> ] ;
				 [ TOOLTIP <cToolTip> ] ;
				 [ <lPressed: PRESSED> ] ;
				 [ ON DROP <bDrop> ] ;
				 [ AT <nPos> ] ;
				 [ PROMPT <cPrompt> ] ;
				 [ FONT <oFont> ] ;
				 [ <lNoBorder: NOBORDER> ] ;
		=> ;
			[ <oBtn> := ] TIeButton():NewBar( <cResName1>, <cResName2>,;
				<cBmpFile1>, <cBmpFile2>, <cMsg>, [{|This|<uAction>}],;
				<.group.>, <oBar>, <.adjust.>, <{WhenFunc}>,;
				<cToolTip>, <.lPressed.>, [\{||<bDrop>\}], [\"<uAction>\"], <nPos>,;
				<cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>], [!<.lNoBorder.>] )
#xcommand @ <nRow>, <nCol> ANIMATION [ <oBmp> ] ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
				 [ <NoBorder:NOBORDER, NO BORDER> ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ <lClick: ON CLICK,  ON LEFT CLICK> <uLClick> ] ;
				 [ <rClick: ON RCLICK, ON RIGHT CLICK> <uRClick> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ <pixel: PIXEL>   ] ;
				 [ MESSAGE <cMsg>   ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ <lDesign: DESIGN> ] ;
				 [ FRAMES <nFrames>	];
				 [ INTERVAL <nInterval> ];
				 [ STOPFRAME <nStop> ];
				 [ <lup: UPDOWN> ];
		 => ;
			 [ <oBmp> := ] TAnimation():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
				 <cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
				 [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
				 [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], ;
				 <oCursor>, <cMsg>, <.update.>,;
				 <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.>, <nFrames>, <nInterval>,<nStop>,<.lup.>)

#xcommand REDEFINE ANIMATION [ <oBmp> ] ;
				 [ ID <nId> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
				 [ <lClick: ON ClICK, ON LEFT CLICK> <uLClick> ] ;
				 [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ MESSAGE <cMsg>   ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ FRAMES <nFrames>	];
				 [ INTERVAL <nInterval> ];
				 [ STOPFRAME <nStop> ];
				 [ <lup: UPDOWN> ];
		 => ;
			 [ <oBmp> := ] TAnimation():ReDefine( <nId>, <cResName>, <cBmpFile>,;
				 <oWnd>, [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
							[\{ |nRow,nCol,nKeyFlags| <uRClick> \}],;
				 <oCursor>, <cMsg>, <.update.>,;
				 <{uWhen}>, <{uValid}> , <nFrames>, <nInterval>, <nStop>, <.lup.> )

#xcommand @ <nRow>, <nCol> MSCOMBOBOX [ <oCbx> VAR ] <cVar> ;
				 [ <items: ITEMS, PROMPTS> <aItems> ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ VALID <uValid> ] ;
				 [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
				 [ <pixel: PIXEL> ] ;
				 [ FONT <oFont> ] ;
				 [ <update: UPDATE> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ <design: DESIGN> ] ;
				 [ BITMAPS <acBitmaps> ] ;
				 [ ON DRAWITEM <uBmpSelect> ] ;
		 => ;
			 [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, bSETGET(<cVar>),;
				 <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
				 [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
				 <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
				 <.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}], ,<(cVar)> )

#xcommand REDEFINE MSCOMBOBOX [ <oCbx> VAR ] <cVar> ;
				 [ <items: ITEMS, PROMPTS> <aItems> ] ;
				 [ ID <nId> ] ;
				 [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ VALID   <uValid> ] ;
				 [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
				 [ <update: UPDATE> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ BITMAPS <acBitmaps> ] ;
				 [ ON DRAWITEM <uBmpSelect> ] ;
				 [ STYLE <nStyle> ] ;
				 [ PICTURE <cPicture> ];
				 [ ON EDIT CHANGE <uEChange> ] ;
		 => ;
			 [ <oCbx> := ] TComboBox():ReDefine( <nId>, bSETGET(<cVar>),;
				 <aItems>, <oWnd>, <nHelpId>, <{uValid}>, [{|Self|<uChange>}],;
				 <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
				 <acBitmaps>, [{|nItem|<uBmpSelect>}], <nStyle>, <cPicture>,;
				 [<{uEChange}>], ,<(cVar)> )


#xcommand @ <nRow>, <nCol> SHORTCUT [ <oShort> ] ;
			[ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
			[ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
			[ SIZE <nWidth>, <nHeight> ] ;
			[ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
			[ MESSAGE <cMsg>	 ] ;
			[ PROMPT <cPrompt> ];
			[ FONT <oFont> ];
			[ <pixel: PIXEL>	 ] ;
			[ <action:ACTION,EXEC> <uAction,...> ] ;
		 => ;
		[ <oShort> := ] TShortCut():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <cResName>, <cBmpFile>, <oWnd>, <cMsg>, <cPrompt>, <oFont>, <.pixel.>, [{|This| <uAction>}] )

#xcommand DEFINE SHORTCUTLIST <oShortList> MENU <cMenu> <of: OF, WINDOW, DIALOG> <oWnd>;
		=>;
		<oShortList> := TShortList():New(<oWnd>,<cMenu>)


#xcommand @ <nRow>, <nCol> BUTTON [<oBtn>] RESOURCE [ <cResName1> [,<cResName2>] ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>] ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ ACTION <uAction,...> ] ;
				 [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ <adjust: ADJUST> ] ;
				 [ UPDATE <lUpdate> ] ;
				 [ <pixel: PIXEL> ] ;
		=> ;
			[ <oBtn> := ] TBtnBmp():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
				<cResName1>, <cResName2>, <cBmpFile1>, <cBmpFile2>,;
				[{|Self|<uAction>}], <oWnd>, <cMsg>, <{uWhen}>, <.adjust.>,;
				<lUpdate> )

#xcommand DEFINE SBUTTON [ <oBtn> ] ;
				 [ FROM <nTop>,<nLeft> ] ;
				 [ TYPE <nType> ] ;
				 [ <action:ACTION,EXEC> <uAction> ] ;
				 [ OF <oWnd> ] ;
				 [ <mode: ENABLE > ] ;
				 [ ONSTOP <cMsg> ] ;
				 [ WHEN	 <uWhen>] ;
		=> ;
			[ <oBtn> := ] SButton():New( <nTop>, <nLeft>,<nType>, <{ uAction }>,;
													  <oWnd>, <.mode.>, <cMsg>,<{ uWhen}>)

#xcommand REDEFINE SBUTTON [<oBtn>] ;
				 [ ID <nId> ] ;
				 [ TYPE <nType> ] ;
				 [ <action:ACTION,EXEC> <uAction> ] ;
				 [ OF <oWnd> ] ;
				 [ <mode: ENABLE > ] ;
				 [ ONSTOP <cMsg> ] ;
		=> ;
			[ <oBtn> := ] SButton():ReDefine( <nId>, <nType>, <cMsg>, <{uAction}>,;

#xcommand @ <nRow>, <nCol> CHECKBOX [ <oCbx> VAR ] <lVar> ;
				 [ PROMPT <cCaption> ] ;
				 [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ FONT <oFont> ] ;
				 [ <change: ON CLICK, ON CHANGE> <uClick> ] ;
				 [ VALID   <ValidFunc> ] ;
				 [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
				 [ <design: DESIGN> ] ;
				 [ <pixel: PIXEL> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <WhenFunc> ] ;
		=> ;
			[ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>, <cCaption>,;
				 [bSETGET(<lVar>)], <oWnd>, <nWidth>, <nHeight>, <nHelpId>,;
				 [<{uClick}>], <oFont>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
				 <.design.>, <.pixel.>, <cMsg>, <.update.>, <{WhenFunc}> )

#xcommand @ <nRow>, <nCol> RADIO [ <oRadMenu> VAR ] <nVar> ;
     [ <prm: PROMPT, ITEMS> <cItems,...> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <help:HELPID, HELP ID> <nHelpId,...> ] ;
     [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
     [ COLOR <nClrFore> [,<nClrBack>] ] ;
     [ MESSAGE <cMsg> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ VALID <uValid> ] ;
     [ <lDesign: DESIGN> ] ;
     [ <lLook3d: 3D> ] ;
     [ <lPixel: PIXEL> ] ;
     => ;
   [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>, {<cItems>},;
     [bSETGET(<nVar>)], <oWnd>, [{<nHelpId>}], <{uChange}>,;
     <nClrFore>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
     <nWidth>, <nHeight>, <{uValid}>, <.lDesign.>, <.lLook3d.>,;
     <.lPixel.> )

