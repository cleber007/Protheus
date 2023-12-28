#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"

/*/{Protheus.doc} CXVldEmail
TODO Validação de Campo E-mail.

@author Rayanne Meneses
@since 26/09/2016
@version 1.0
@type function
/*/

User Function CXVldEmail( _cEmail )

Local lReturn := .F.
Local aArray := StrTokArr( _cEmail, ";" ) //Separo a string em um array, para que possa verificar cada e-mail digitado
Local i as numeric 

for i := 1 To Len(aArray)

	if IsEmail( AllTrim( aArray[i] ) )
		lReturn := .T.
	Else
		lReturn := .F.
	EndIf

	if !lReturn
		Help('',1,'EMAIL',,'E-mail inválido',1,0)
		i := Len(aArray)
	EndIf

 Next

Return( lReturn )
