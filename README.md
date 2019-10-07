# 我的博客
http://blog.auska.win

## 创建镜像

```
docker create --name=transmission \
-v <path to data>:/config \
-v <path to downloads>:/downloads \
-v <path to watch folder>:/watch \
-e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> \
-e USER=<default : admin> -e PASSWD=<default : admin> \
-p 9091:9091 -p 51413:51413 \
-p 51413:51413/udp \
linuxserver/transmission
```

## 参数解释

* `-p 9091` 网页UI端口
* `-p 51413` - BT软件通讯端口
* `-v /config` - 配置文件目录
* `-v /downloads` - 下载文件目录
* `-v /watch` - 监视种子目录
* `-e PGID` 用户的GroupID，留空为root
* `-e PUID` 用户的UserID，留空为root
* `-e TZ` 时区 默认 Asia/Shanghai

## 版本介绍

latest ： 仅仅使用了TWC的UI，适合挂PT使用。
bt     ： 包括了自动添加公用tracker和屏蔽吸血客户端的新功能（迅雷）。
