# moekoe-music

# 推荐部署容器命令
``` sh
docker run --restart=always \
  -d --name MoeKoeMusic \
  --privileged=true \
  -p 8080:8080 \
  docker.1panel.live/byxiaopeng/moekoe-music:latest
```

重启MoeKoeMusic容器代码
``` sh
docker restart MoeKoeMusic
```
