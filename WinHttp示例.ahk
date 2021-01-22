/*
第1个例子
*/
测试网址1=www.baidu.com
测试网址2=https://baidu.com
测试网址3=https://www.baidu.com

;另一个参数“options”的格式也参照此参数
;更多支持信息参见“WinHttp.UrlDownloadToFile()”中的注释
request_header=
(
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language:zh-CN,zh;q=0.8
Cache-Control:no-cache
Connection:keep-alive
Cookie:123
DNT:1
Host:www.baidu.com
Pragma:no-cache
User-Agent:Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36 SE 2.X MetaSr 1.0
)

;注意下面的“Accept-Encoding:gzip,deflate,sdch”中的gzip让服务器返回gzip压缩后的数据，本库依然可以正确处理
request_header2=
(
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language:zh-CN,zh;q=0.8
Cache-Control:no-cache
Connection:keep-alive
Cookie:123
DNT:1
Host:www.baidu.com
Pragma:no-cache
User-Agent:Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36 SE 2.X MetaSr 1.0
Accept-Encoding:gzip,deflate,sdch
)

MsgBox, 第1个例子，基本的使用。
MsgBox, 首先演示地址不带 “http://” 即 “www.baidu.com” 之类的是不会有结果的。
MsgBox, % WinHttp.UrlDownloadToVar(测试网址1)

MsgBox, 然后演示地址不带 “www.” 即 “https://baidu.com” 之类的不同网站支持情况不同。
MsgBox, % WinHttp.UrlDownloadToVar(测试网址2)

MsgBox, 接着演示地址正常 即 “https://www.baidu.com” 但不带参数的访问。`r`n因为百度有一定的检测，所以获取到的信息依然不太正常。
MsgBox, % WinHttp.UrlDownloadToVar(测试网址3)

MsgBox, 现在演示如何带参数的访问，此时已经跟浏览器中的一样了。
MsgBox, % WinHttp.UrlDownloadToVar(测试网址3,"",request_header)

MsgBox, 注意，本库支持gzip压缩后的数据。
MsgBox, % WinHttp.UrlDownloadToVar(测试网址3,"",request_header2)

MsgBox, 以上全部使用“WinHttp.UrlDownloadToVar()”，使用“WinHttp.URLDownloadToFile()”是一样的，就不重复演示了。

/*
第2个例子
*/
url:="https://www.tingchina.com/yousheng/disp_24366.htm"

option1=
(
Charset: gb2312
)

option2=
(
Charset: gb2312
URLCodePage: 936
)

MsgBox, 第2个例子，解决乱码。
MsgBox, 首先演示，直接访问时乱码。
MsgBox, % WinHttp.UrlDownloadToVar(url)

MsgBox, 接下来演示，设置正确的“charset”，搞定乱码。
MsgBox, % WinHttp.UrlDownloadToVar(url,option1)

MsgBox, 最后演示，同时设置正确的“charset”以及“urlcodepage”，完全搞定乱码（自行和第3步结果对比，是有区别的。另外绝大部分网站不需要设置。）。
MsgBox, % WinHttp.UrlDownloadToVar(url,option2)


/*
第3个例子
*/
URL=http://wesleyzhang.lofter.com/dwr/call/plaincall/ArchiveBean.getArchivePostByTime.dwr

data=
(
callCount=1
scriptSessionId=${scriptSessionId}187
httpSessionId=
c0-scriptName=ArchiveBean
c0-methodName=getArchivePostByTime
c0-id=0
c0-param0=boolean:false
c0-param1=number:156006
c0-param2=number:1611296621156
c0-param3=number:50
c0-param4=boolean:false
batchId=117849
)

request_header=
(
Referer:http://wesleyzhang.lofter.com/view
)

MsgBox, 第3个例子，怎么向网站发送数据。
MsgBox, 首先演示，没有引用地址会得到错误的反馈。
MsgBox, % WinHttp.UrlPost(URL,data,"")

MsgBox, 接着演示，使用正确数据外加正确引用地址返回正确结果。
MsgBox, % WinHttp.UrlPost(URL,data,"",request_header)

/*
第4个例子
*/
url=http://www.baidu.com

option=
(
expected_status:200
number_of_retries:3
)

MsgBox, 第4个例子，怎么获取网站的状态码
MsgBox, 一般来说，状态码为200表示网页内容获取正常。状态码为404表示网页找不到了。`r`n`r`n所以，通过状态码，就可以对内容是否获取正常进行判断。
MsgBox, 下面的例子演示访问“www.baidu.com”，并期望它返回的状态码是200（如果不是，则会进行下一次尝试，总共3次）

WinHttp.UrlDownloadToVar(url,option,"")
MsgBox,% "期望的状态码是" 200 "`r`n实际的状态码是" WinHttp.Status
MsgBox,有一点需要注意的是，使用状态码时，最好加上try语句。`r`n`r`n因为当尝试完指定次数后，状态码依旧与预期不一致时，会产生用于调试的错误信息，不用try语句会打断程序运行。

/*
第5个例子
*/
地址=http://www.ninecmd.com/tools/ip2address/getip.php
rs=
(
Client-IP: 123.123.123.1
X-Forwarded-For: 123.123.123.2
X-Real-IP:123.123.123.3
Proxy-Client-IP:1.2.3.4
WL-Proxy-Client-IP:5.6.7.8
REMOTE-ADDR: 9.10.11.12
)

MsgBox, 第5个例子，如何伪造ip
MsgBox, 我查阅了很多资料，从中提取出了6个可能可以伪造ip的参数。`r`n实践证明，前2个有效，第3个可能有效，最后3个应该没用。`r`n具体进去看源码。
MsgBox, 还有一个要注意的就是，这种伪造ip的方式，并不能使得所有服务器被骗，至于为什么就自行研究了。
MsgBox, % WinHttp.UrlDownloadToVar(地址,"",rs)
MsgBox, 全部演示完毕，自己进来看源码！
return

#Include Lib\WinHttp.ahk
#Include Lib\正则全局模式.ahk