---
title: "Install Microsoft Windows App (Formerly Remote Desktop App)"
keywords: RDP, AVD
description: Install Microsoft Windows App (Former Microsoft Remote Desktop (RDP Client)).
---

## Install Microsoft Windows App from an MSI package

Download MSI to your PC using one of the below URLs:  
[Windows 64-bit](https://go.microsoft.com/fwlink/?linkid=2262633)  
[Windows 32-bit](https://go.microsoft.com/fwlink/?linkid=2262634)  
[Windows ARM64](https://go.microsoft.com/fwlink/?linkid=2262635)

See [this page](https://learn.microsoft.com/en-gb/windows-app/whats-new?tabs=windows#latest-release) for the latest releases. 

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

## Install Microsoft Windows App from the Microsoft Store (Recommended)

Download the Windows App from the [Microsoft Store](https://apps.microsoft.com/detail/9N1F85V9T8BN)

From your Windows Desktop type "store" in the search field and click Microsoft Store when found
![Remote Desktop](../images/step_01.png)  
While in the Microsoft Store, search for "Windows App" and select "Windows App" to open it 
![Remote Desktop](../images/step_02.jpeg)  
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
