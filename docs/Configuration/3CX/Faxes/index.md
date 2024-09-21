---
title: "3CX Configure faxes"
keywords: 3cx, voip, pbx, telephony, faxes
description: 3CX Configure faxes.
---

## Inbound faxes
For turn on fax server, go to 3CX WEB UI -> Advanced -> Fax Server  
![](images/3CX_FAXES_01.png)

Type Default Email Address for reciving faxes, Enable G.711 to T.38 Fallback, to save press OK button     
![](images/3CX_FAXES_02.png)

Go to SIP Trunks, open AWS sip trunk, on DIDs tab add additional DID  
![](images/3CX_FAXES_03.png)

Go to Inbound Routes, Add new DID rule, type Name: Fax Rule, select DID for assign.  
Set Route calls to Send fax to -> users who will recived fax to PDF

![](images/3CX_FAXES_04.png)

## Outbound fax
For outboud faxes, you need use ATA devices with fax machine.  
Or use software for SipToFax, like:  
http://www.t38faxvoip.com/  

## FAX Devices 

To configure SIP ATA Grandstream HT801 go to 3CX Web UI -> Advanced -> FXS/DCT and press Add FXS/DCT button and enter information (Name, Mac addr, etc).  
  
![](images/3CX_FAXES_05.png)  
  
You also need download config file from provisioning Link    
  
![](images/3CX_FAXES_06.png)  
  
Goto Web managment page Grandstream HT801  
  
![](images/3CX_FAXES_07.png)  
  
And open ADVANCED SETTINGS tab, press Upload configuration.  
  
![](images/3CX_FAXES_08.png)

Upload from local directory and chose saved xml configuration file. After 30 sec ATA device will be configured successfully.  

![](images/3CX_FAXES_09.png)

Password from Grandstream Web UI will be updated from 3CX and you can find in 3CX Web UI -> Advanced -> FXS/DCT -> ATA Settings page.  

To test outbound fax delivery, use this test fax phone number from HP: 1-888-473-2963

### References 
https://www.3cx.com/voip-gateways/grandstream-ht-fxs/
