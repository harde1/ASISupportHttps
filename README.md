# ASIHTTPRequest Support Https 

  该Category目的是为了让ASI请求框架支持单向免证书Https认证，http的request不受此Category影响，在该Category会在接口读取流中加入SSL证书协议

##操作方式：
  在生成request对象的地方，导入该文件的头文件即可
例子： 

```
#import "ASIHTTPRequest+SupportHttps.h"
``
该修改不会影响到其他的功能

##注意用词：
单向免证书Https认证，所谓单向，即仅仅服务器需要提供SSL证书给客户端验证，客户端不需要提供SSL证书给服务器，即客户端不需要植入证书
