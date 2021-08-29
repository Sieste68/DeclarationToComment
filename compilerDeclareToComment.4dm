//%attributes = {}
/*
🔄: Boolean
#️⃣: Number
🔢: Integer
📆: Date
⏱: Time
🖼: Picture
💫: Variant
💬: Text
🗄: Blob
{}: Object
[]: Collection
➡️: Pointer
*/

#DECLARE($IN_code : Text)->$declareCommented : Text

var $code : Text
var $dataTypes : Collection

$dataTypes:=New collection:C1472()
$dataTypes.push(New object:C1471("emoji"; "🗄"; "type"; "Blob"))
$dataTypes.push(New object:C1471("emoji"; "🔄"; "type"; "Boolean"))
$dataTypes.push(New object:C1471("emoji"; "[]"; "type"; "Collection"))
$dataTypes.push(New object:C1471("emoji"; "{}"; "type"; "Object"))
$dataTypes.push(New object:C1471("emoji"; "📆"; "type"; "Date"))
$dataTypes.push(New object:C1471("emoji"; "🔢"; "type"; "Integer"))
$dataTypes.push(New object:C1471("emoji"; "🖼"; "type"; "Picture"))
$dataTypes.push(New object:C1471("emoji"; "➡️"; "type"; "Pointer"))
$dataTypes.push(New object:C1471("emoji"; "#️⃣"; "type"; "Real"))
$dataTypes.push(New object:C1471("emoji"; "💬"; "type"; "Text"))
$dataTypes.push(New object:C1471("emoji"; "⏱"; "type"; "Time"))
$dataTypes.push(New object:C1471("emoji"; "💫"; "type"; "Variant"))

If (Count parameters:C259=0)
	$code:=""
Else 
	$code:=$IN_code
End if 

$code:=Replace string:C233($code; "\r\n"; "\n")
$code:=Replace string:C233($code; "\r"; "\n")

var $codeLines : Collection
var $newCodeLines : Collection

$codeLines:=Split string:C1554($code; "\n"; sk trim spaces:K86:2)
$newCodeLines:=New collection:C1472()

var $codeLine; $type : Text
var $dataType : Object
var $isDeclaration : Boolean

$isDeclaration:=False:C215

For each ($codeLine; $codeLines) Until ($isDeclaration)
	$isDeclaration:=($codeLine=("#DECLARE(@"))
End for each 


If ($isDeclaration)
	var $posStart; $posEnd; $posSep : Integer
	
	$posStart:=Position:C15("("; $codeLine)
	$posEnd:=Position:C15(")"; $codeLine; $posStart+1)
	
	If (($posStart>0) & ($posEnd>0))
		var $variableNames : Collection
		var $variableDeclaration; $variableOut : Text
		
		$variableNames:=Split string:C1554(Substring:C12($codeLine; $posStart+1; $posEnd-$posStart-1); ";"; sk trim spaces:K86:2)
		$variableOut:=Substring:C12($codeLine; $posEnd+1)
		
		$codeLines.unshift("\r")
		$codeLines.unshift("*/")
		If ($variableOut#"")
			$posSep:=Position:C15(":"; $variableOut)
			$type:=Substring:C12($variableOut; $posSep+2)
			$c:=$dataTypes.query("type =:1"; $type)
			$codeLines.unshift("◀️ "+$c[0].emoji+": "+Substring:C12($variableOut; 3; $posSep-1))
			$codeLines.unshift("--")
		End if 
		
		For each ($variable; $variableNames)
			$posSep:=Position:C15(":"; $variable)
			
			If ($posSep>0)
				$type:=Substring:C12($variable; $posSep+2)
				$c:=$dataTypes.query("type =:1"; $type)
				$codeLines.unshift("▶️ "+$c[0].emoji+": "+Substring:C12($variable; 1; $posSep-1))
			Else 
				
			End if 
		End for each 
		$codeLines.unshift("/*")
		
	End if 
End if 

$declareCommented:=$codeLines.join("\r")