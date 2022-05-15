---
title: "Markdown syntax"
keywords: markdown, syntax
description: Markdown syntax.
---

## Start MD Document 
```none
---
title: "Share the application"
keywords: get started, setup, orientation, quickstart, intro, concepts, containers, docker desktop, docker hub, sharing 
redirect_from:
- /get-started/part3/
description: Sharing our image we built for our example application so we can run it else where and other developers can use it
---
```

## Examples

[Github markdown syntax](https://github.github.com/gfm/){: class="button primary-btn" style="margin-bottom: 30px; margin-right: 200%"}

### Text examples

```none
Click **Login** and then select **docker** from the drop-down list.
```
Click **Login** and then select **docker** from the drop-down list.

```none
Open your browser to [Play with Docker](https://labs.play-with-docker.com/){:target="_blank" rel="noopener" class="_"}.
```
Open your browser to [Play with Docker](https://labs.play-with-docker.com/){:target="_blank" rel="noopener" class="_"}.

### List 

```none
- Test text 
- Test text
- Test text
```

- Test text 
- Test text
- Test text

```none
1. Test text 
2. Test text
3. Test text
```

1. Test text
2. Test text
3. Test text

### Images 
```
![](https://help.svetek.com/get-started/images/dashboard-open-cli-ubuntu.png)
```

![](https://help.svetek.com/get-started/images/dashboard-open-cli-ubuntu.png)


### Button 
```
[On to deploying to Kubernetes >>](kube-deploy.md){: class="button primary-btn" style="margin-bottom: 30px; margin-right: 200%"}
```
[On to deploying to Kubernetess](kube-deploy.md){: class="button primary-btn" style="margin-bottom: 30px; margin-right: 200%"}


### Tabs
```html
<!---
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#kubeosx">Mac</a></li>
  <li><a data-toggle="tab" href="#kubewin">Windows</a></li>
</ul>
<div class="tab-content">
  <div id="kubeosx" class="tab-pane fade in active">
{% capture local-content %}

#### Mac
    
some text

{% endcapture %}
{{ local-content | markdownify }}

</div>
<div id="kubewin" class="tab-pane fade" markdown="1">
{% capture localwin-content %}

#### Windows
  
some text2

{% endcapture %}
{{ localwin-content | markdownify }}
</div>
<hr>
</div>
```

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#kubeosx">Mac</a></li>
  <li><a data-toggle="tab" href="#kubewin">Windows</a></li>
</ul>
<div class="tab-content">
  <div id="kubeosx" class="tab-pane fade in active">
{% capture local-content %}

#### Mac

some text 2
{% endcapture %}
{{ local-content | markdownify }}

</div>
<div id="kubewin" class="tab-pane fade" markdown="1">
{% capture localwin-content %}

#### Windows

some text

{% endcapture %}
{{ localwin-content | markdownify }}
</div>
<hr>
</div>

### Code block 
#### Docker code block
```
```dockerfile
RUN apt-get -y update
RUN apt-get install -y python
``` // example
```
```dockerfile
RUN apt-get -y update
RUN apt-get install -y python
```

#### Shell code block
```shell
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=37 time=21.393 ms
64 bytes from 8.8.8.8: seq=1 ttl=37 time=15.320 ms
64 bytes from 8.8.8.8: seq=2 ttl=37 time=11.111 ms
``` //example
```
```shell  
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=37 time=21.393 ms
64 bytes from 8.8.8.8: seq=1 ttl=37 time=15.320 ms
64 bytes from 8.8.8.8: seq=2 ttl=37 time=11.111 ms
```
#### Console code block
```
```console  
$ kubectl logs demo
``` // example
``` 

```console  
$ kubectl logs demo
```

### important block
```
> **Installation requirements**
>
> The Duo Authentication Proxy can be installed on a physical or virtual host.
> We recommend a system with at least 1 CPU, 200 MB disk space, and 4 GB RAM (although 1 GB RAM is usually sufficient).
{: .important}
```
> **Installation requirements**
>
> The Duo Authentication Proxy can be installed on a physical or virtual host.
> We recommend a system with at least 1 CPU, 200 MB disk space, and 4 GB RAM (although 1 GB RAM is usually sufficient).
{: .important}

### Notification block
```
> **Docker ID**
>
> A Docker ID allows you to access Docker Hub which is the world's largest library and community for container images. Create a [Docker ID](https://hub.docker.com/signup){:target="_blank" rel="noopener" class="_"} for free if you don't have one.
```
> **Docker ID**
>
> A Docker ID allows you to access Docker Hub which is the world's largest library and community for container images. Create a [Docker ID](https://hub.docker.com/signup){:target="_blank" rel="noopener" class="_"} for free if you don't have one.

### Youtube video 

```
<!-- blank line -->
<figure class="video_container">
    <iframe width="900" height="600" src="https://www.youtube.com/embed/PRGJCKcx8p8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</figure>
<!-- blank line -->
```

<!-- blank line -->
<figure class="video_container">
    <iframe width="900" height="600" src="https://www.youtube.com/embed/PRGJCKcx8p8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</figure>
<!-- blank line -->