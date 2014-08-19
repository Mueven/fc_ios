fc_ios
======
企业版ios发布要注意的事项：
*   在code signing中release的地方要选择合适的ios provisioning证书，再打包
*   在别的机器上也要安装相应地证书
*   代码中请求plist的地址在7.0以后必须是https的地址
*   在不同的机器上使用同样地证书，可以把原机器的各种专用钥匙直接导出来再导进到新电脑中
*   如果遇到get the task fail for process:xxxx 是因为用的是那个具有发布者权限的证书，要用开发者证书
