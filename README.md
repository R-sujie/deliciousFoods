# 美食网站

基于 Spring Boot、MyBatis 和 MySQL 的美食网站。前台提供菜谱和食材浏览、分类导航、美食笔记和资讯，后台提供内容管理入口。

- [在线演示](https://web-production-43b9969e.up.railway.app/)
- [在线后台登录页](https://web-production-43b9969e.up.railway.app/end/page/login.html)

线上网站使用从 `database/deliciousfoods.sql` 导入的独立 MySQL 数据库。已验证前台接口可读取原始备份中的 13 条菜谱和 8 条食材。后台登录页使用备份中的测试账号数据。

## 使用 Docker Compose 本地启动

准备 Git 和支持 `docker compose` 的 Docker。Windows 可使用 Docker Desktop，并确认 Docker 已启动。

```sh
git clone https://github.com/R-sujie/deliciousFoods.git
cd deliciousFoods
```

在项目根目录创建名为 `.env` 的文件，用你自己的数据库密码替换示例值：

```dotenv
DB_PASSWORD=change-me-for-local-dev
```

构建并启动。首次运行需要下载基础镜像和 Maven 依赖。

```sh
docker compose up --build -d
docker compose ps
docker compose logs --tail=100 db app
```

- [本地首页](http://localhost:8080/)
- [本地后台登录页](http://localhost:8080/end/page/login.html)
- [本地菜谱接口](http://localhost:8080/foodsMenuInfo/page/all?pageSize=8)

MySQL 首次初始化空数据库卷时，Compose 按顺序执行表结构和示例数据脚本。普通的 `docker compose down` 会停止容器并保留数据库和上传文件。已有数据库卷会继续使用其中的数据，初始化脚本只在空卷上自动执行。

## 数据库文件

| 文件 | 内容 |
| --- | --- |
| [schema.sql](database/schema.sql) | 14 张表的结构 |
| [demo.sql](database/demo.sql) | 供演示使用的分类、菜谱、食材和图片索引 |
| [deliciousfoods.sql](database/deliciousfoods.sql) | 原始 MySQL 备份，包含项目原有测试数据 |
| [account-records.public.csv](database/account-records.public.csv) | 账户记录的 ID 和角色清单 |

### 导入完整原始备份

**原始备份包含 `DROP TABLE IF EXISTS`。** 请在空的测试数据库中导入，或提前备份目标库。账号数据是公开测试数据，请为真实环境另外配置账号。

Docker Compose 数据库可用后，在仓库根目录运行以下命令。导入后，容器中的示例表会被原始备份中的表及数据替换。

```sh
docker compose cp database/deliciousfoods.sql db:/tmp/deliciousfoods.sql
docker compose exec -T db sh -c 'exec mysql --default-character-set=utf8mb4 -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < /tmp/deliciousfoods.sql'
```

使用独立 MySQL 时，可以用 MySQL Workbench 打开 SQL 文件，选择预先建立的 `deliciousfoods` 测试库，再执行整份脚本。原始备份中的图片记录指向上传文件，缺失的原始图片需要从项目备份恢复。

## 使用 Maven 本地开发

准备 JDK 8、Maven 3 和 MySQL 8。创建 UTF-8 数据库 `deliciousfoods`，导入 `schema.sql` 后再导入 `demo.sql`，或者在空库中导入完整备份。给应用分配一个有权访问该库的 MySQL 用户。

Windows PowerShell 示例：

```powershell
$env:DB_URL = 'jdbc:mysql://localhost:3306/deliciousfoods?characterEncoding=utf-8&serverTimezone=Asia/Shanghai'
$env:DB_USERNAME = 'deliciousfoods'
$env:DB_PASSWORD = '替换为自己的数据库密码'
mvn clean package
java -jar target/deliciousFoods-1.0-SNAPSHOT.jar
```

从项目根目录启动应用。应用默认监听 `8080`，也可通过环境变量 `PORT` 修改。上传文件目录为 `src/main/resources/static/file/`。

## 项目目录与部署

| 路径 | 用途 |
| --- | --- |
| `src/main/java` | Java 后端 |
| `src/main/resources/mapper` | MyBatis SQL 映射 |
| `src/main/resources/static/front` | 网站前台 |
| `src/main/resources/static/end` | 后台页面 |
| `database` | 数据库建表脚本、示例数据及原始备份 |
| `Dockerfile` / `Dockerfile.mysql` / `Dockerfile.mysql.full` | 应用镜像、示例 MySQL 镜像及完整备份 MySQL 镜像 |
| `compose.yaml` | 本地应用和 MySQL 编排 |

部署到 Railway 时，网站服务使用根目录的 `Dockerfile`，线上 MySQL 服务使用 `Dockerfile.mysql.full`，首次启动时导入完整备份。`Dockerfile.mysql` 用于单独部署示例库。网站通过 `DB_URL`、`DB_USERNAME`、`DB_PASSWORD` 连接同一项目中的 MySQL。MySQL 数据和站点上传文件分别挂载持久卷，网站域名指向应用监听端口。

## 常见问题

- **端口 8080 已被占用**。在 `compose.yaml` 中将 `8080:8080` 改为 `8081:8080`，从 [8081 端口](http://localhost:8081/)访问。
- **数据库连接失败**。运行 `docker compose ps` 和 `docker compose logs db app`，核对数据库服务状态、地址、用户名和密码。应用容器连接的主机名为 `db`。
- **旧环境没有示例菜谱**。先检查现有数据，确认可以添加演示记录后再手动执行 `database/demo.sql`。直接重复执行可能遇到主键冲突。
- **后台打不开或无法登录**。先区分页面访问和账号认证。演示库可加载登录页，管理员需要配置后才能登录。
