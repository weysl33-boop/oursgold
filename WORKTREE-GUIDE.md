# Git Worktree 开发指南

本项目使用 Git worktree 来支持并行开发。当前配置的 worktrees：

## Worktree 结构

```
D:/Playground/gold/          # 主 worktree (main 分支)
                             # 用于：集成、文档、OpenSpec 管理
                             
D:/Playground/gold-backend/  # 后端开发 worktree (feature/backend-api 分支)
                             # 用于：FastAPI、PostgreSQL、Redis 开发
                             # 对应任务：Phase 1 (tasks.md 1.1-1.7)
                             
D:/Playground/gold-mobile/   # 移动端开发 worktree (feature/mobile-ui 分支)
                             # 用于：Flutter 移动应用开发
                             # 对应任务：Phase 2 (tasks.md 2.1-2.10)
```

## 快速开始

### 1. 查看所有 worktrees

```bash
git worktree list
```

### 2. 在不同 worktree 中工作

**后端开发：**
```bash
cd D:/Playground/gold-backend

# 创建后端项目结构
mkdir -p backend/app/{api,services,repositories,models,schemas}
mkdir -p backend/tests

# 开发工作...
git add backend/
git commit -m "feat(backend): implement user authentication"
git push -u origin feature/backend-api
```

**移动端开发：**
```bash
cd D:/Playground/gold-mobile

# 创建 Flutter 项目
flutter create mobile
cd mobile

# 开发工作...
git add mobile/
git commit -m "feat(mobile): add home page with market cards"
git push -u origin feature/mobile-ui
```

**主分支（集成）：**
```bash
cd D:/Playground/gold

# 合并后端分支
git merge feature/backend-api

# 合并移动端分支
git merge feature/mobile-ui

# 推送集成结果
git push origin main
```

## 工作流程

### 日常开发流程

1. **在各自的 worktree 中开发**
   - 后端团队在 `gold-backend` 中工作
   - 移动端团队在 `gold-mobile` 中工作

2. **定期同步主分支**
   ```bash
   # 在后端 worktree 中
   cd D:/Playground/gold-backend
   git fetch origin
   git rebase origin/main
   
   # 在移动端 worktree 中
   cd D:/Playground/gold-mobile
   git fetch origin
   git rebase origin/main
   ```

3. **推送功能分支**
   ```bash
   git push origin feature/backend-api
   git push origin feature/mobile-ui
   ```

4. **在主分支中集成**
   ```bash
   cd D:/Playground/gold
   git pull origin main
   git merge feature/backend-api
   git merge feature/mobile-ui
   git push origin main
   ```

### 避免冲突的最佳实践

**文件分配原则：**
- **gold-backend**: 只修改 `backend/`, `tests/`, `docker-compose.yml`, `requirements.txt`
- **gold-mobile**: 只修改 `mobile/`, `pubspec.yaml`
- **gold (主)**: 修改 `openspec/`, `README.md`, `docs/`, 集成配置

**分支命名规范：**
- `feature/backend-*` - 后端功能
- `feature/mobile-*` - 移动端功能
- `feature/phase1-*` - 阶段性功能
- `bugfix/*` - Bug 修复
- `chore/*` - 基础设施和配置

## 添加新的 Worktree

如果需要为特定功能创建新的 worktree：

```bash
# 例如：为实时功能创建 worktree
cd D:/Playground/gold
git worktree add -b feature/websocket ../gold-realtime

# 查看所有 worktrees
git worktree list
```

## 删除 Worktree

当功能开发完成并合并后：

```bash
# 1. 删除 worktree
git worktree remove ../gold-backend

# 2. 删除远程分支（可选）
git push origin --delete feature/backend-api

# 3. 删除本地分支（可选）
git branch -d feature/backend-api

# 4. 清理 worktree 引用
git worktree prune
```

## 在 VSCode 中使用

### 方法 1: 打开多个 VSCode 窗口

```bash
# 打开后端 worktree
code D:/Playground/gold-backend

# 打开移动端 worktree
code D:/Playground/gold-mobile

# 打开主 worktree
code D:/Playground/gold
```

### 方法 2: 使用 VSCode Workspace

创建 `gold-platform.code-workspace` 文件：

```json
{
  "folders": [
    {
      "name": "Main (Integration)",
      "path": "."
    },
    {
      "name": "Backend",
      "path": "../gold-backend"
    },
    {
      "name": "Mobile",
      "path": "../gold-mobile"
    }
  ],
  "settings": {
    "files.exclude": {
      "**/.git": true
    }
  }
}
```

然后打开这个 workspace 文件即可在一个窗口中看到所有 worktrees。

## 常见问题

### Q: 如何查看当前在哪个分支？
```bash
git branch --show-current
```

### Q: 如何查看所有分支的状态？
```bash
git log --all --graph --oneline --decorate
```

### Q: 如何在 worktrees 之间切换？
不需要切换！每个 worktree 是独立的目录，直接 `cd` 到对应目录即可。

### Q: 可以在一个 worktree 中看到其他 worktree 的更改吗？
不能直接看到。需要先 commit 并 push，然后在其他 worktree 中 fetch 和 merge。

### Q: 如何同步所有 worktrees？
```bash
# 在主 worktree 中
cd D:/Playground/gold
git fetch --all

# 然后在每个 worktree 中
cd ../gold-backend
git pull origin main

cd ../gold-mobile
git pull origin main
```

## 任务分配建议

根据 `openspec/changes/add-precious-metals-social-platform/tasks.md`：

**gold-backend (Phase 1):**
- 1.1 Project Setup & Infrastructure
- 1.2 Database Models & Schemas
- 1.3 User Authentication System
- 1.4 Market Data Integration
- 1.5 Core API Endpoints
- 1.6 Community & Leaderboard APIs
- 1.7 Phase 1 Finalization

**gold-mobile (Phase 2):**
- 2.1 Flutter Project Setup
- 2.2 Core Infrastructure
- 2.3 Bottom Navigation & Shell
- 2.4 Home Page
- 2.5 Quotes Page
- 2.6 Forex Page
- 2.7 Detail Page
- 2.8 Community Page
- 2.9 Profile Page
- 2.10 Phase 2 Finalization

**gold (主分支):**
- OpenSpec 文档维护
- 集成测试
- CI/CD 配置
- 部署脚本
- 项目文档

## 参考资源

- [Git Worktree 官方文档](https://git-scm.com/docs/git-worktree)
- [OpenSpec 提案](./openspec/changes/add-precious-metals-social-platform/proposal.md)
- [任务列表](./openspec/changes/add-precious-metals-social-platform/tasks.md)
- [技术设计](./openspec/changes/add-precious-metals-social-platform/design.md)

