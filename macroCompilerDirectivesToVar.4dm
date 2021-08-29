//%attributes = {"invisible":true}
var $oldCode; $newCode : Text
var $selectionType : Integer

$selectionType:=Highlighted method text:K5:18
GET MACRO PARAMETER:C997($selectionType; $oldCode)

If ($oldCode="")
	$selectionType:=Full method text:K5:17
	GET MACRO PARAMETER:C997($selectionType; $oldCode)
End if 

If ($oldCode#"")
	$newCode:=compilerDirectivesToVar($oldCode)
	
	If ($newCode#$oldCode)
		SET MACRO PARAMETER:C998($selectionType; $newCode)
	End if 
End if 