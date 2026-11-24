# 美食网站

这是一个使用 Spring Boot、MyBatis 和 MySQL 的美食网站，包含菜谱、食材、资讯、美食笔记和后台管理。

## 使用 Docker Compose 启动

1. 在项目根目录创建 `.env`，写入 `DB_PASSWORD=你的数据库密码`。
2. 运行 `docker compose up --build -d`。
3. 打开 http://localhost:8080。后台登录页面为 http://localhost:8080/end/page/login.html。

首次创建数据库卷时，MySQL 会执行 `database/schema.sql`。该文件只创建表。全新实例需要另外导入获准使用的菜谱、分类等数据，并设置管理账号。请在私有环境中管理原始数据库导出。

使用已有 MySQL 实例时，可通过 `DB_URL`、`DB_USERNAME`、`DB_PASSWORD` 配置连接。容器平台也可以使用 `PORT` 指定应用监听端口。持续运行时需为 MySQL 和上传文件配置持久存储。
