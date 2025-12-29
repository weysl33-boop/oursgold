# 快速开始指南

## ✅ Worktree 已配置完成！

你的项目现在有 3 个并行开发环境：

```
📁 D:/Playground/gold/          ← 主分支 (main)
   用途：集成、文档、OpenSpec 管理

📁 D:/Playground/gold-backend/  ← 后端开发 (feature/backend-api)
   用途：FastAPI、PostgreSQL、Redis
   任务：Phase 1 (tasks.md 1.1-1.7)

📁 D:/Playground/gold-mobile/   ← 移动端开发 (feature/mobile-ui)
   用途：Flutter 移动应用
   任务：Phase 2 (tasks.md 2.1-2.10)
```

## 🚀 立即开始

### 选项 1: 在 VSCode 中打开多个窗口

```bash
# 打开后端开发环境
code D:/Playground/gold-backend

# 打开移动端开发环境
code D:/Playground/gold-mobile

# 保持主窗口用于集成
code D:/Playground/gold
```

### 选项 2: 使用终端

**后端开发：**
```bash
cd D:/Playground/gold-backend

# 开始 Phase 1.1 - 项目设置
mkdir -p backend/app/{api,services,repositories,models,schemas}
mkdir -p backend/tests

# 提交进度
git add backend/
git commit -m "feat(backend): initialize project structure"
git push -u origin feature/backend-api
```

**移动端开发：**
```bash
cd D:/Playground/gold-mobile

# 开始 Phase 2.1 - Flutter 项目设置
flutter create mobile
cd mobile

# 提交进度
git add mobile/
git commit -m "feat(mobile): initialize Flutter project"
git push -u origin feature/mobile-ui
```

## 📋 下一步任务

### 后端团队 (gold-backend)

根据 `openspec/changes/add-precious-metals-social-platform/tasks.md`：

**Phase 1.1 - 项目设置 & 基础设施**
- [ ] 1.1.1 使用 Poetry/pip 初始化 FastAPI 项目结构
- [ ] 1.1.2 配置 PostgreSQL 数据库并创建初始 schema
- [ ] 1.1.3 设置 Redis 用于缓存和会话管理
- [ ] 1.1.4 配置 Docker Compose 用于本地开发
- [ ] 1.1.5 设置 Alembic 用于数据库迁移
- [ ] 1.1.6 配置 pytest 与 fixtures 和测试数据库
- [ ] 1.1.7 设置 pre-commit hooks (Black, isort, pylint)
- [ ] 1.1.8 创建 OpenAPI/Swagger 文档结构

**验证**: `docker-compose up` 启动所有服务，`pytest` 运行成功

### 移动端团队 (gold-mobile)

**Phase 2.1 - Flutter 项目设置**
- [ ] 2.1.1 使用正确的包结构初始化 Flutter 项目
- [ ] 2.1.2 配置 iOS 和 Android 构建设置
- [ ] 2.1.3 设置依赖注入 (get_it 或 riverpod)
- [ ] 2.1.4 配置路由 (go_router 或 auto_route)
- [ ] 2.1.5 设置环境配置 (dev/staging/prod)
- [ ] 2.1.6 配置 linting (analysis_options.yaml)
- [ ] 2.1.7 设置测试框架 (flutter_test, mockito)
- [ ] 2.1.8 创建文件夹结构 (features, core, data, widgets)

**验证**: `flutter run` 启动应用，导航工作，测试运行

## 🔄 日常工作流程

### 1. 在各自的 worktree 中开发

```bash
# 后端开发者
cd D:/Playground/gold-backend
# ... 开发工作 ...
git add .
git commit -m "feat(backend): add user authentication"
git push origin feature/backend-api

# 移动端开发者
cd D:/Playground/gold-mobile
# ... 开发工作 ...
git add .
git commit -m "feat(mobile): add home page"
git push origin feature/mobile-ui
```

### 2. 定期同步主分支

```bash
# 在后端 worktree
cd D:/Playground/gold-backend
git fetch origin
git rebase origin/main

# 在移动端 worktree
cd D:/Playground/gold-mobile
git fetch origin
git rebase origin/main
```

### 3. 集成到主分支

```bash
cd D:/Playground/gold
git pull origin main
git merge feature/backend-api
git merge feature/mobile-ui
git push origin main
```

## 📚 重要文档

- **完整 Worktree 指南**: [WORKTREE-GUIDE.md](./WORKTREE-GUIDE.md)
- **OpenSpec 提案**: [openspec/changes/add-precious-metals-social-platform/proposal.md](./openspec/changes/add-precious-metals-social-platform/proposal.md)
- **任务列表**: [openspec/changes/add-precious-metals-social-platform/tasks.md](./openspec/changes/add-precious-metals-social-platform/tasks.md)
- **技术设计**: [openspec/changes/add-precious-metals-social-platform/design.md](./openspec/changes/add-precious-metals-social-platform/design.md)
- **产品需求**: [prd.md](./prd.md)

## 🛠️ 常用命令

```bash
# 查看所有 worktrees
git worktree list

# 查看当前分支
git branch --show-current

# 查看所有分支状态
git log --all --graph --oneline --decorate

# 查看 OpenSpec 变更
openspec list
openspec show add-precious-metals-social-platform
```

## ❓ 需要帮助？

- 查看 [WORKTREE-GUIDE.md](./WORKTREE-GUIDE.md) 了解详细的工作流程
- 查看 [openspec/changes/add-precious-metals-social-platform/](./openspec/changes/add-precious-metals-social-platform/) 了解项目规范
- 遇到问题？检查 Git 状态：`git status` 和 `git worktree list`

## 🎯 项目目标

根据 OpenSpec 提案，这是一个 **14-18 周**的项目，分为 4 个阶段：

- **Phase 1**: 后端 API + 数据库 (3-4 周)
- **Phase 2**: 移动端 UI 基础 (3-4 周)
- **Phase 3**: 社交功能 (4-5 周)
- **Phase 4**: 实时功能 (2-3 周)
- **最终**: 测试 & 发布准备 (2 周)

**现在开始 Phase 1 和 Phase 2 的并行开发！** 🚀

