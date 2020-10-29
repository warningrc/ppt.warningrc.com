title: RESTful装X指南
speaker: Warning
transition: kontext
files: /js/ga.js

[slide style="background-image:url('/img/bg1.png')" data-transition="zoomout"]

# RESTful装X指南
## warning
[slide  style="background-image:url('/img/bg1.png')"]
[magic data-transition="slide"]
#几个定义

====
#`URI`
#`URL`
#`URN`
====

====
###`URI`

`(Uniform Resource Identifier)`

**统一资源标识符**
====
###`URL`
`(Uniform Resource Locator)`

**统一资源定位符**

URL是URI的一种,不仅标识了Web 资源,还指定了操作或者获取方式,同时指出了主要访问机制和网络位置。
====
###`URN`

`(Uniform Resource Name)`

**统一资源名称**

URN是URI的一种,用特定命名空间的名字标识资源。使用URN可以在不知道其网络位置及访问方式的情况下讨论资源。


* `urn:[NID]:[NSS]`
	* `NID`:命名空间标识符
	* `NSS`:标识命名空间的特定字符串

====

<pre><code class="markdown">
    magnet:?xt=urn:btih:101123757f77becf556461fbf39451ab2c59d5aa
    urn:issn:1535-3613

    btih:(BitTorrent Info Hash)
    issn:(International Standard Serial Number,国际标准连续出版物编号)
</code>
</pre>

[/magic]

[slide  style="background-image:url('/img/bg1.png')"]
<pre><code class="markdown">
					hierarchical part
		┌───────────────────┴─────────────────┐
				authority           path
		┌──────────────┴────────────┐┌───┴────┐
  http://user:pwd@example.com:123/path/data?key=value&key2=value2#fragid1
  └─┬─┘  └──┬────┘ └─────┬─────┘ └┬┘           └──────────┬─────────┘ └──┬──┘
 scheme   user        host    port                  query         fragment

  urn:example:mammal:monotreme:echidna
  └┬┘ └───────────────┬────────────────┘
scheme              path
</code>
</pre>
[slide  style="background-image:url('/img/bg1.png')"]

![](/img/6941baebgw1evu0o8swewj20go0avq3e.jpg)


[slide  style="background-image:url('/img/bg1.png')"]

* `Uniform`:规定统一的格式可方便处理多种不同类型的资源，而不用根据上下文环境来识别资源指定的访问方式。新增的协议方案也更容易。
	* 比如`http:`,`ftp:`,`mailto:`,`tel:`,`urn:`,`dubbo:`.
* `Resource`:资源的定义是**`可标识的任何东西`**(`消费者能够与之交互以达成某种目标的`**`任何`**`东西`).


[slide  style="background-image:url('/img/bg1.png')"]

# **两个问题**
----
* 什么是`REST`? {:&.rollIn}
* 什么是`RESTful`?

[slide  style="background-image:url('/img/bg1.png')"]

##`Representational State Transfer`

> REST这个词，是`Roy Thomas Fielding`在他2000年的博士论文中提出的。

* 核心主题:`Resources`(资源)

* `Representation`:`Resources`是一种信息实体，它可以有多种外在表现形式(`html,xml,txt,json,byte[],jpg,png`)。我们把"资源"具体呈现出来的形式，叫做它的`Representation`（`表现层`）。

* `State Transfer`:状态转移(变化)。URI不体现资源状态，若要操作资源，必须通过某种手段，让资源发生状态变化。由于万维网主要基于http协议，那么操作就基于http的动作(`GET,POST,PUT,DELETE`)


>如果一个架构符合REST原则，就称它为RESTful架构。

[slide  style="background-image:url('/img/bg1.png')"]
#REST关键原则

REST定义了应该如何正确地使用Web标准，例如HTTP和URI

#五条关键原则

* 为所有`Resources`定义ID
* 将所有`Resources`链接在一起
* 使用标准方法
* 资源多重表述
* 无状态通信


[slide  style="background-image:url('/img/bg1.png')"]

#为所有`Resources`定义ID

* 系统=各种抽象资源的堆积
* 资源≠数据库记录 资源比数据库记录更加抽象

<pre><code class="markdown">
http://warningrc.com/users/1234
http://warningrc.com/orders/2007/10/776654
http://warningrc.com/products/4554
http://warningrc.com/processes/salary-increase-234
</code></pre>

<pre><code class="markdown">
http://warningrc.com/orders/2007/11
http://warningrc.com/products?productline=kaoyan
</code></pre>

>使用URI标识所有值得标识的事物，特别是应用中提供的所有“高级”资源，无论这些资源代表单一数据项、数据项集合、虚拟亦或实际的对象还是计算结果等。


[slide  style="background-image:url('/img/bg1.png')"]
#将所有事物链接在一起

[slide  style="background-image:url('/img/bg1.png')"]
#使用标准方法
<pre><code class="markdown">class Resource {
     Resource(URI u);
     Response get();
     Response post(Request r);
     Response put(Request r);
     Response delete();
}</code></pre>

>为使客户端程序能与你的资源相互协作，资源应该正确地实现默认的应用协议（HTTP），也就是使用标准的GET、PUT、POST和DELETE方法。


[slide  style="background-image:url('/img/bg1.png')"]
#资源多重表述(json,html,xml等)

<pre><code class="markdown">GET /users/1234 HTTP/1.1
Host: warningrc.com
Accept: application/vnd.koolearn.user+json</code></pre>

<pre><code class="shell">GET /users/1234 HTTP/1.1
Host: warningrc.com
Accept: text/x-vcard</code></pre>

>针对不同的需求提供资源多重表述


[slide  style="background-image:url('/img/bg1.png')"]
#无状态通信

>客户端和服务器之间的交互在请求之间是无状态的,即从客户端到服务器的每个请求都必须包含理解请求所必需的信息

[slide  style="background-image:url('/img/bg1.png')"]

# REST架构

[slide  style="background-image:url('/img/bg1.png')"]

![](/img/413241324134132.png)

[slide  style="background-image:url('/img/bg1.png')"]

![](/img/4132431243124312.png)

[slide  style="background-image:url('/img/bg1.png')"]

#Leonard成熟度模型

[slide  style="background-image:url('/img/bg1.png')"]

# `URI`>`HTTP`>`Hypermedia(超媒体)`

`level 0` > `level 1` > `level 2` > `level 3`

[slide  style="background-image:url('/img/bg1.png')"]

# 零级服务

服务中有单个的URI，并且使用单个的HTTP方法(post)。(SOAP WebService)

>ws-*(SOAP的规范和技术，WSDL,WS-Transfer,WS-MetadataExchange) 使用单个URI来标识一个端点，并且使用HTTP post来转移基于SOAP的载荷，完全忽略了HTTP动词的其余部分

[slide  style="background-image:url('/img/bg1.png')"]

#一级服务

服务中使用了多个URI，但只使用单个HTTP方法(post,get)

>与零级服务的关键区别在于，这种服务暴露了很多逻辑上的资源。然而该级别的服务中通常将操作名称和参数插入到URI中，然后将URI传递给一个远程服务(HTTP GET).



[slide  style="background-image:url('/img/bg1.png')"]

#二级服务

二级服务使用了大量的可通过URI寻址的资源。这样的服务支持多个HTTP动词来暴露资源，同时使用HTTP动词和状态码来协调交互。(`CRUD`服务)

[slide  style="background-image:url('/img/bg1.png')"]

#三级服务

支持`超媒体作为应用状态的引擎(超媒体约束)(Hypermedia as the engine of application state)`的观念。即，表述包含了消费者可能感兴趣的到其他资源的URI连接。这种服务通过追踪资源来引导消费者，结果是引起状态的迁移。

[slide  style="background-image:url('/img/bg1.png')"]
#将所有事物链接在一起

<pre><code class="xml">
&lt;order self="http://example.com/orders/1234"&gt;
   &lt;amount>23&lt;/amount&gt;
   &lt;product ref="http://example.com/products/4554"&gt;
		&lt;user ref="http://example.com/users/1234"/&gt;
	&lt;/product&gt;
&lt;/order>
</code></pre>

>超媒体原则还有一个更重要的方面——应用“状态”。简而言之，实际上服务器端为客户端提供一组链接，使客户端能通过链接将应用从一个状态改变为另一个状态。

[slide  style="background-image:url('/img/bg1.png')"]

# 如何设计 RESTful API

* 为所有`Resources`定义ID
* 将所有`Resources`链接在一起
* 使用标准方法
* 资源多重表述
* 无状态通信


[slide  style="background-image:url('/img/bg1.png')"]

# 为所有`Resources`定义ID

* 资源的抽象
* 协议:`https`
* 域名:专有域名(`https://api.koolearn.cn`,`https://study.koolearn.cn/api/`)
* 版本:`URL`?`header`?
* URL命名:名词(资源/服务)


[slide  style="background-image:url('/img/bg1.png')"]

# 使用标准方法

* `GET(SELECT)`:从服务器取出资源（一项或多项）。
* `POST(CREATE)`:在服务器新建一个资源。
* `PUT(UPDATE)`:在服务器更新资源（客户端提供改变后的完整资源）。
* `PATCH(UPDATE)`:在服务器更新资源（客户端提供改变的属性）。
* `DELETE(DELETE)`:从服务器删除资源。
* `HEAD`:从服务器检索资源的元数据
* `OPTIONS`:从服务器检索客户端允许对资源做的操作。

[slide  style="background-image:url('/img/bg1.png')"]

# 状态码

* 2xx:成功
	* 200  204  206
* 3xx:重定向
	* 301  302  303  304  307
* 4xx:客户端错误
	* 400 401 403 404
* 5xx:服务器错误
	* 500 503

[slide  style="background-image:url('/img/bg1.png')"]
----
<iframe data-src="http://tool.oschina.net/commons?type=5" style="width: 1024px;height: 768px;" src="about:blank;"></iframe>

[slide  style="background-image:url('/img/bg1.png')"]

#资源多重表述

* Accept
* Content-Type

[slide  style="background-image:url('/img/bg1.png')"]
# 错误处理

* 状态码
* 错误信息

[slide  style="background-image:url('/img/bg1.png')"]

#将所有`Resources`链接在一起(`Hypermedia API`)
<pre><code class="json">
{
	"link": {
		"rel":   "collection https://www.example.com/zoos",
		"href":  "https://api.example.com/zoos",
		"title": "List of zoos",
		"type":  "application/vnd.yourformat+json"
	}
}
</code></pre>

https://api.github.com/


[slide  style="background-image:url('/img/bg1.png')"]

# 其他

* 鉴权 Authentication
* 缓存
* 速度限制(HTTP状态码429（too many requests）)
* 数据压缩
* 文档


[slide  style="background-image:url('/img/bg1.png')"]

# ***谢谢！***
