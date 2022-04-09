---
title: "Configure Meraki VPN Client"
keywords: meraki, vpn, duo, mfa
description: Configure Meraki VPN Client.
---

## Before start VPN configuration
You will request from your IT team next information: 

> **VPN configuration settings you will get from IT**
>
> Server address: vpn.consto.com  
>  Shared secret: testSharedKey$   
>  Username: Your username from AD   
>  Password: Your password from AD  
>  MFA is supported? Yes / No  

## Meraki VPN setup

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#kubeosx">Mac OS X</a></li>
  <li><a data-toggle="tab" href="#kubewin">Windows</a></li>
</ul>
<div class="tab-content">
  <div id="kubeosx" class="tab-pane fade in active">
{% capture local-content %}

#### Mac OS X
Open System Preferences -> Network  
![](images/Merraki_VPN_Cient_01.png)  

Press + button for add new VPN configuration

> **VPN configuration settings**
>
>  Interface: VPN  
>  VPN Type: L2TP over IPSec  
>  Service Name: Some name vpn connection  
{: .important}
  
Example:  
![](images/Merraki_VPN_Cient_02.png)  
  
Type server address and username  
Press Authentication Settings... button   
![](images/Merraki_VPN_Cient_03.png)  
  
Type User Authentication: Password: Your AD password  
Type Machine Authentication: Shared secret: Shared secret  
Check box: Show VPN status in menu bar  
  
![](images/Merraki_VPN_Cient_04.png)  
Press Ok for save changes  

> **VPN configuration settings you will get from IT**
>
> Configuration is done. You can now press connect button.   
> If VPN server requered MFA, you will get MFA request on your phone.  
  
{% endcapture %}
{{ local-content | markdownify }}

</div>
<div id="kubewin" class="tab-pane fade" markdown="1">
{% capture localwin-content %}

#### Windows

.....

{% endcapture %}
{{ localwin-content | markdownify }}
</div>
<hr>
</div>

