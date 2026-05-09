# PsiTransfer

## 功能特性

- 拖拽上传文件
- 支持断点续传（tus 协议）
- 文件有效期设置（一次性/1小时/1天/1周等）
- 提取码保护
- 二维码分享
- 打包下载（ZIP/tar.gz）
- 默认中文界面

## 快速部署

```bash
docker run -d \
  -p 3000:3000 \
  -v $(pwd)/data:/data \
  --name psitransfer-zh \
  wsng911/psitransfer-zh:latest
```

访问 `http://localhost:3000`
