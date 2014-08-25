fc_ios
======
企业版ios发布要注意的事项：
*   在code signing中release的地方要选择合适的ios provisioning证书，再打包
*   代码中请求plist的地址在7.0以后必须是https的地址
*   在不同的机器上如何使用同一个证书：先去develop center 下载certificate，然后从原来的电脑上导开发的出专有密匙，在新电脑上导入
*   如果遇到get the task fail for process:xxxx 是因为用的是那个具有发布者权限的证书，要用开发者证书
