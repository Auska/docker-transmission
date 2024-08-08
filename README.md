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
auska/docker-transmission:tagname
```

## 参数解释

* `-p 9091` 网页UI端口
* `-p 51413` - BT软件通讯端口
* `-v /config` - 配置文件目录
* `-v /downloads` - 下载文件目录
* `-v /watch` - 监视种子目录
* `-e PGID` 用户的GroupID，留空为root
* `-e PUID` 用户的UserID，留空为root
* `-e USER` 登录用户名
* `-e PASSWD` 登录密码
* `-e TZ` 时区 默认 Asia/Shanghai
* `-e WEBUI_PORT` 配置网页UI端口
* `-e PORT` 配置BT软件通讯端口

## 更新日志

- 20240808 客户端过滤采用白名单模式
