#Set-ExecutionPolicy Unrestricted -force

#Create your own direct access for CMD command:
Add-Type -AssemblyName Microsoft.VisualBasic
$_command = [Microsoft.VisualBasic.Interaction]::InputBox('Write the CMD command: ', 'CMD Command')

if ($_command) {

    Add-Type -AssemblyName Microsoft.VisualBasic
    $_name = [Microsoft.VisualBasic.Interaction]::InputBox('Write the new name of shortcut: ', 'Name')

    $_CMDPath = 'C:\Windows\System32\cmd.exe'
    $_Caracter = ' /k'

    $WS = New-Object -comObject WScript.Shell
    $Shortcut = $WS.CreateShortcut("$Home/Desktop/$_name.lnk")
    $Shortcut.TargetPath = "$_CMDPath"
    $Shortcut.Arguments = "$_Caracter"+" $_command"
    $Shortcut.Save()

}