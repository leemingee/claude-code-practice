---
name: rednote
description: RedNote (小红书) MCP 操作助手 - 管理和使用小红书 MCP 服务
version: 1.0.0
---

# RedNote MCP 技能

这个技能帮助你管理和使用 RedNote (小红书) MCP 服务。

## 🎯 快速使用

当用户询问关于小红书/RedNote 的操作时,使用此技能。

## 🔧 服务管理命令

用户已配置以下 shell 别名:

```bash
# 启动服务
rn-start          # 无头模式 (生产环境,推荐)
rn-start-gui      # GUI 模式 (调试用,显示浏览器)

# 控制服务
rn-stop           # 停止服务
rn-restart        # 重启 (无头)
rn-restart-gui    # 重启 (GUI)
rn-status         # 检查运行状态
rn-logs           # 查看实时日志

# 其他
rn-login          # 重新登录小红书
rn-check          # 验证 MCP 连接
rn-cd             # 跳转到项目目录
```

## 📡 MCP 连接信息

- **服务地址**: `http://localhost:18060/mcp`
- **MCP 名称**: `xiaohongshu-mcp`
- **工具数量**: 12 个

## 🛠️ 可用 MCP 工具

### 1. check_login_status
检查小红书登录状态 (无参数)

### 2. publish_content
发布图文内容

**必需参数**:
- `title` - 标题 (⚠️ 最多 20 字符)
- `content` - 正文 (⚠️ 最多 1000 字符)
- `images` - 图片路径数组 (本地路径或 HTTP 链接)

**可选**: `tags` - 标签数组

### 3. publish_with_video
发布视频内容

**必需参数**:
- `title` - 标题 (最多 20 字符)
- `content` - 描述 (最多 1000 字符)
- `video` - 本地视频文件路径 (⚠️ 仅本地,不支持 HTTP)

### 4. search_feeds
搜索内容

**必需**: `keyword` - 搜索关键词

### 5. list_feeds
获取首页推荐 (无参数)

### 6. get_feed_detail
获取帖子详情

**必需**: `feed_id`, `xsec_token` (从 search/list 获取)

### 7. post_comment_to_feed
发表评论

**必需**: `feed_id`, `xsec_token`, `content`

### 8. user_profile
获取用户主页

**必需**: `user_id`, `xsec_token`

## ⚠️ 重要限制

- 标题: 最多 20 字符
- 正文: 最多 1000 字符
- 发布: 每天约 50 篇
- 图片路径: 不能包含中文
- 账号: 不要在其他网页端同时登录

## 💡 使用示例

### 检查服务状态
```
使用 rn-status 检查 RedNote MCP 是否运行
```

### 发布图文
```
发布小红书图文:
标题: "咖啡时光"
内容: "今天的拿铁真好喝"
图片: /Users/yoyo/Pictures/coffee.jpg
标签: 咖啡, 生活
```

### 搜索内容
```
搜索小红书关于"健身"的内容
```

## 🔍 故障排除

### 服务未运行
```bash
rn-start        # 启动服务
rn-status       # 确认运行
```

### 登录过期
```bash
rn-stop         # 停止服务
rn-login        # 重新登录
rn-start        # 启动服务
```

### 发布失败 - 检查清单
- [ ] 标题 ≤ 20 字符?
- [ ] 正文 ≤ 1000 字符?
- [ ] 路径无中文?
- [ ] 文件存在?
- [ ] 已登录?

### 调试模式
```bash
rn-stop
rn-start-gui    # GUI 模式观察浏览器
rn-logs         # 查看日志
```

## 📚 工作流程

处理小红书请求时:

1. **检查服务** → `rn-status`
2. **确认登录** → 使用 `check_login_status` 工具
3. **执行操作** → 使用对应 MCP 工具
4. **处理错误** → `rn-logs` 查看日志

## 🎓 最佳实践

1. 日常使用 `rn-start` (无头模式)
2. 调试问题用 `rn-start-gui` (看浏览器)
3. 优先使用本地图片路径
4. 添加合适标签增加流量
5. 控制发布频率 (≤50/天)

---

**服务目录**: `~/src/xiaohongshu-mcp`
**详细文档**: `~/src/xiaohongshu-mcp/REDNOTE_MCP_GUIDE.md`
