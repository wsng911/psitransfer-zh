# psitransfer-zh Prompts

> 项目：psi-4ward/psitransfer 汉化版（psitransfer-zh）
> 技术栈：Vue 2 + Vuex 前端，Node.js + Express 后端，本地文件存储

---

## 功能迭代

**1. 添加上传进度通知**
在 psitransfer-zh 的上传完成后，添加浏览器桌面通知功能（Notification API）。当文件上传完成时，即使用户切换到其他标签页，也能收到通知提示。需要在 Upload.vue 中监听上传状态变化并请求通知权限。

**2. 支持文件夹上传**
在 psitransfer-zh 的 Files.vue 中添加文件夹上传支持。用户可以拖拽整个文件夹到上传区域，系统自动递归获取文件夹内所有文件并保持目录结构，打包为 ZIP 后上传。

**3. 添加上传记录历史**
在 psitransfer-zh 中使用 localStorage 保存最近 10 次上传记录（分享链接、文件名、上传时间、有效期）。在页面顶部添加"历史记录"入口，方便用户快速找回之前的分享链接。

**4. 支持自定义分享链接后缀**
在 psitransfer-zh 的上传设置中添加"自定义链接"选项，允许用户设置易记的分享链接后缀（如 `/my-files`），后端验证唯一性后生成对应的分享 ID。

**5. 添加文件预览增强**
在 psitransfer-zh 的 PreviewModal 中扩展预览支持：PDF 文件使用 PDF.js 渲染预览，视频文件使用 HTML5 video 标签播放，音频文件使用 audio 标签播放。

---

## Bug 修复

**6. 修复大文件上传时进度条不准确的问题**
在 psitransfer-zh 中上传大文件（>100MB）时，进度条显示的百分比与实际上传进度不一致，有时会在 99% 停留很长时间。检查 upload.js 中的 tus 上传进度回调，确保进度计算基于实际传输字节数。

**7. 修复移动端拖拽上传不可用的问题**
在 psitransfer-zh 的移动端浏览器中，拖拽上传功能无法使用，但点击选择文件正常。在 Files.vue 中添加移动端触摸事件支持（touchstart/touchmove/touchend），或在移动端隐藏拖拽提示改为仅显示点击上传。

**8. 修复一次性下载链接被多次访问的问题**
在 psitransfer-zh 中，设置为"一次性下载"的文件在某些情况下可以被下载多次（如多个标签页同时打开）。在后端添加原子性的下载状态检查，使用文件锁或数据库事务确保一次性下载的原子性。

**9. 修复提取码包含特殊字符时无法解密的问题**
在 psitransfer-zh 中，当用户设置的提取码包含 `+`、`/`、`=` 等特殊字符时，下载页面输入提取码后无法正确解密。检查提取码在 HTTP 请求头中的传输方式，确保进行正确的 URL 编码。

**10. 修复管理页面在文件数量过多时加载缓慢**
在 psitransfer-zh 的 Admin.vue 中，当上传文件数量超过 1000 个时，管理页面加载非常缓慢。加个分页功能，每页显示 50 条记录，并添加按上传时间、文件大小排序的功能。

---

## 重构

**11. 将文件存储层抽象为可替换的接口**
psitransfer-zh 目前只支持本地文件系统存储。把存储操作抽象为 `StorageAdapter` 接口，现有实现作为 `LocalStorageAdapter`，为未来支持 S3、MinIO 等对象存储做准备。

**12. 将配置验证逻辑提取为独立模块**
psitransfer-zh 的 config.js 中混合了配置定义和验证逻辑。把验证逻辑提取到 `lib/configValidator.js`，使用 JSON Schema 或 Joi 进行配置验证，并在启动时提供清晰的错误提示。

---

## 测试

**13. 为文件上传 API 编写集成测试**
使用 Jest + supertest 为 psitransfer-zh 的文件上传接口编写集成测试，覆盖：单文件上传、多文件上传、超出大小限制、密码保护上传、一次性下载设置。使用临时目录隔离测试数据。

**14. 为前端 Vuex store 编写单元测试**
使用 Jest + Vue Test Utils 为 psitransfer-zh 的 Upload/store.js 编写单元测试，覆盖：文件添加/删除、上传进度更新、上传完成状态、错误状态处理。

**15. 为语言文件完整性编写测试**
编写测试脚本验证 psitransfer-zh 的所有语言文件（lang/*.js）的完整性：每个语言文件必须包含英文文件中的所有 key，缺失的 key 自动回退到英文，并在 CI 中运行此检查。

---

## 代码理解

**16. 解释 tus 断点续传协议的实现**
在 psitransfer-zh 中使用了 tus-js-client 实现断点续传。解释 tus 协议的工作原理、psitransfer 如何在服务端处理 tus 请求、断点续传的状态如何保存，以及与普通 multipart 上传相比的优势。

**17. 解释文件分享 ID 的生成和安全机制**
在 psitransfer-zh 中，每次上传会生成一个唯一的分享 ID（sid）。解释 sid 的生成算法、如何防止 ID 碰撞、密码保护是如何实现的（服务端还是客户端加密），以及一次性下载的原子性保证机制。

---

## DevOps

**18. 编写 GitHub Actions 自动构建流水线**
为 psitransfer-zh 编写 `.github/workflows/docker-build.yml`，实现推送 main 分支时自动构建多架构（amd64/arm64/armv7）Docker 镜像并推送到 Docker Hub，镜像标签使用 `latest` 和语义化版本号。

**19. 编写 docker-compose.yml 生产部署配置**
为 psitransfer-zh 编写 `docker-compose.yml`，包含：psitransfer 服务（映射 3000 端口）、数据目录挂载（`./data:/data`）、环境变量配置（上传大小限制、有效期选项、管理密码）、Nginx 反向代理（支持 HTTPS）。

**20. 编写自动清理过期文件的定时任务**
为 psitransfer-zh 编写一个独立的清理脚本 `scripts/cleanup.js`，定期扫描上传目录，删除已过期的文件和目录。编写对应的 cron 配置，并在 docker-compose.yml 中添加定时任务容器。
