# 推荐部署容器命令
``` sh
docker run --restart=always \
  -d --name v2tls \
  --privileged=true \
  -p 80:80 \
  byxiaopeng/xray:latest
```
