# caddytrojan

# 推荐部署容器命令
``` sh
docker run --restart=always \
  -d --name caddytrojan \
  --privileged=true \
  -p 443:443/udp \
  -p 443:443/tcp \
  -p 80:80 \
  -e password=123456 \
  -e email=10086@baidu.com \
  -e wz=false \
  -e domain=1.baidu.com \
  byxiaopeng/caddytrojan:latest
```


#password  trojan密码

#email     申请ssl证书邮箱

#wz        是否使用自己域名开关 ture开 false关  不开启默认使用nip.io域名

#domain    填写自己的域名

重启caddytrojan容器代码
``` sh
docker restart caddytrojan
```
