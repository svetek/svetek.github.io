---
title: "Install Microsoft Remote Desktop (RDP Client)"
keywords: RDP, AVD
description: Install Microsoft Remote Desktop (RDP Client).
---
## Install Microsoft Remote Desktop Windows 10 (RDP Client) from an MSI package (Recommended!!!)

Download MSI on your PC use that URL:  
[Windows 64-bit](https://go.microsoft.com/fwlink/?linkid=2068602)  
[Windows 32-bit](https://go.microsoft.com/fwlink/?linkid=2098960)  
[Windows ARM64](https://go.microsoft.com/fwlink/?linkid=2098961)

When downloading is done, run the installation MSI by double-clicking on the file:  
![MSI](../images/rdclient_install_from_msi_01.png)  
Press "Run"  
![MSI](../images/rdclient_install_from_msi_02.png)  
On the "Welcome" screen press "Next"  
![MSI](../images/rdclient_install_from_msi_03.png)  
Click on the checkbox "I accept ...." and press "Next"  
![MSI](../images/rdclient_install_from_msi_04.png)  
Click on "Install for all users" and press "Next"  
![MSI](../images/rdclient_install_from_msi_05.png)  
Press "Yes"  
![MSI](../images/rdclient_install_from_msi_06.png)
Installation is done. Press "Finish" for close the window and run the app.  
![MSI](../images/rdclient_install_from_msi_07.png)

![MSI](../images/step_07.png)

The installation is done. Go to “ADD WORKSPACE” for configuring Microsoft Remote Desktop.

## Install Microsoft Remote Desktop Windows 10 (RDP Client) from Microsoft store

If you use Windows 10 run Microsoft Store just type in search "store" and press on Microsoft Store  
![Remote Desktop](../images/step_01.png)  
On new windows Microsoft Store in search input type "Remote Desktop" and select "Microsoft Remote Desktop"  
![Remote Desktop](../images/step_02.png)  
Next step we need press "Get" button for for start downloading app  
![Remote Desktop](../images/step_03.png)  
On popup window "Use across your devices" press "No, thanks" button  
![Remote Desktop](../images/step_04.png)  
You will see starting process download and Install app  
![Remote Desktop](../images/step_05.png)  
When installation process done, you will press "Launch" button  
![Remote Desktop](../images/step_06.png)  
![Remote Desktop](../images/step_07.png)

Installation is done.  Go to [ADD WORKSPACE ACCESS](#add-workspace-access) for configuring Microsoft Remote Desktop.


## ADD WORKSPACE ACCESS

Now you need add User Workspace. Press "ADD" -> "Workspaces"  
![Workspace](../images/step_08.png)  
For "Email or Workspace URL" type: [https://rdweb.wvd.microsoft.com/api/arm/feeddiscovery](https://rdweb.wvd.microsoft.com/api/arm/feeddiscovery)  and press "Subscribe" button  
![Workspace](../images/step_09.png)  
Type your work or school account username / password  
![Workspace](../images/step_10.png)  
Press "Work or school account"  
![Workspace](../images/step_11.png)  
Done. Now you can try connecting to the SessionDesktop or WVD APP.  
![Workspace](../images/step_12.png)

## Configure redirection folders

### OS X

Open Microsoft Remote Desktop app and go to "Preferences...".  
![OSX](../images/WVD_OSX_CLIENT_01.png)

Open drop-down "If folder redirection is enabled for RDP..." and select "Choose folder..." option  
![OSX](../images/WVD_OSX_CLIENT_02.png)

Select a local folder for RDP folder redirection.  
![OSX](../images/WVD_OSX_CLIENT_03.png)

Connect and check the redirection folder  
![OSX](../images/WVD_OSX_CLIENT_04.png)  
