#Set-ExecutionPolicy Unrestricted -force


#Script for uninstall apps unnecesary in your Windows 10:

$_option = Read-Host "You want to uninstall apps for all users(0) or a specific one(1) ?"

switch ($_option) {

    "0" {
    
        #To uninstall 3D Builder:
        Get-AppxPackage -allusers *3dbuilder* | remove-appxpackage

        #To uninstall Alarms & Clock:
        Get-AppxPackage -allusers *alarms* | remove-appxpackage

        #To uninstall App Connector:
        Get-AppxPackage -allusers *appconnector* | remove-appxpackage

        #To uninstall Get Office:
        Get-AppxPackage -allusers *officehub* | remove-appxpackage

        #To uninstall Maps:
        Get-AppxPackage -allusers *maps* | remove-appxpackage

        #To uninstall Microsoft Solitaire Collection:
        Get-AppxPackage -allusers *solitaire* | remove-appxpackage

        #To uninstall Microsoft Wallet:
        Get-AppxPackage -allusers *wallet* | remove-appxpackage

        #To uninstall Phone and Phone Companion apps Together:
        Get-AppxPackage -allusers *phone* | remove-appxpackage

        #To uninstall Sway:
        Get-AppxPackage -allusers *sway* | remove-appxpackage

        #To uninstall View 3D:
        Get-AppxPackage -allusers *3d* | remove-appxpackage

        #To uninstall Windows Holographic:
        Get-AppxPackage -allusers *holographic* | remove-appxpackage

        #To uninstall Xbox:
        Get-AppxPackage -allusers *xbox* | remove-appxpackage

        #To uninstall Sway:
        Get-AppxPackage -allusers *sway* | remove-appxpackage
        
        break;
    }

    "1" {

        $_user = Read-Host "Type the user name (If you are not sure type the command in other shell 'whoami /user')"
    
        #To uninstall 3D Builder:
        Get-AppxPackage -user $_user *3dbuilder* | remove-appxpackage

        #To uninstall Alarms & Clock:
        Get-AppxPackage -user  $_user *alarms* | remove-appxpackage

        #To uninstall App Connector:
        Get-AppxPackage -user  $_user *appconnector* | remove-appxpackage

        #To uninstall Get Office:
        Get-AppxPackage -user  $_user *officehub* | remove-appxpackage

        #To uninstall Maps:
        Get-AppxPackage -user  $_user *maps* | remove-appxpackage

        #To uninstall Microsoft Solitaire Collection:
        Get-AppxPackage -user  $_user *solitaire* | remove-appxpackage

        #To uninstall Microsoft Wallet:
        Get-AppxPackage -user  $_user *wallet* | remove-appxpackage

        #To uninstall Phone and Phone Companion apps Together:
        Get-AppxPackage -user  $_user *phone* | remove-appxpackage

        #To uninstall Sway:
        Get-AppxPackage -user  $_user *sway* | remove-appxpackage

        #To uninstall View 3D:
        Get-AppxPackage -user  $_user *3d* | remove-appxpackage

        #To uninstall Windows Holographic:
        Get-AppxPackage -user  $_user *holographic* | remove-appxpackage

        #To uninstall Xbox:
        Get-AppxPackage -user  $_user *xbox* | remove-appxpackage

        #To uninstall Sway:
        Get-AppxPackage -user  $_user *sway* | remove-appxpackage

        Clear-Variable _*
        
        break;
    }

    default { [System.Windows.MessageBox]::Show('Please write 0 or 1'); break; }

}


