# date-fns parseISO 纳秒精度候选：开工验证清单

- 当前基线：`a9739fb3e5384a810e90d7376446f6d84ecc5029`；默认分支 main；实时 stars 36,657，pushedAt 2026-10-26。
- 独立 checkout：本目录 `source/`，仅本工作线写入；既有 locale #4400 与旧 inspection checkout 不改。
- 原题：#3194，2022-09-30，仍 OPEN。真实数据库 UI 日期跨日及 .NET TimeOnly.MaxValue 报告。
- 来源：OPEN 未合并 #3199，Frédéric Bonnet，commit `4d51210f62c7a074982195d4d66697cacf1255d4`，源 fork MIT。保留原作者和来源，不宣称原创或人审。
- 已核当前 AGENTS/CONTRIBUTING、全部 6 workflow、community profile；无 AI 自主禁令/assignment/CLA 前置。date-fns/.github 不存在，community 贡献入口指向本仓 CONTRIBUTING。模板/AI_POLICY 在全树及常见位置未发现。
- 全量 409 OPEN PR 的标题和正文已读；相关 parseISO actual diff 独立封存并核对。原 PR review/comment、issue 评论/timeline 与 source history 已封存；分页计数须断言完整。

## 必需行为对照

1. 同精确基线的公开 `parseISO` 实际调用：复现原 .NET/数据库纳秒字符串滚动到下一日。
2. 仅应用原 #3199 逻辑的对照：确认纳秒修复，同时 `2014-02-11T00:00:01.001Z`、08.001、32.001 从基线正确变为少 1 ms；1970 年对应值在基线本来已错误，属于原有缺口而非原补丁新增回归。
3. 最终算法须按原始十进制位计算整数毫秒，不用任意 epsilon 或浮点乘积的 floor/round；保护原生支持的秒/分/时小数和逗号小数、pre-epoch、日期边界、带/不带 offset、UTCDate/TZDate context，保留既有校验合同。
4. 同环境 baseline/original/final 的回归与真实 source 入口，保存实际导入路径、版本、日志。
5. 完整构建后的真实 npm 包安装消费者：ESM/CJS/subpath/FP 公开入口、真实文件输入的数据库/.NET 格式时间戳；不以内部 helper 或 mock 代替。

## 当前 upstream PR CI 的全部可提前门槛

- `pnpm install`：原 lockfile，不修改依赖/锁。
- `mise //:types` = `pnpm tsc --build`。
- `mise //:lint` = `pnpm oxlint`；补充 changed-file `pnpm oxfmt --check`、`git diff --check`。
- `mise //pkgs/core:test/locales` = UTC `node scripts/build/localeSnapshots/index.ts --test`。
- `mise //pkgs/core:test/node`：当前 `scripts/test/node.sh` 的 Node 22/24/25/26，各跑完整 core main 单测和 `scripts/test/tz.sh`。
- `mise //pkgs/core:test/browser`：真实 Chromium 完整 core browser suite。
- `mise //pkgs/core:test/tz`：仓库 date-fns-test-tz 全 src/main 时区矩阵。
- `mise //pkgs/core:test/smoke`：CDN/CJS/CTS/ESM/lodash-fp/node-esm/rollup/TS/vite/webpack 全 examples；包含所需完整 package build。
- 相关 parseISO 无 Temporal 实现，但若实现测试被实验 suite 复用则补该适用 suite；可跑完整 temporarily 作为额外兼容验证，不用其替代上列 checks。
- coverage workflow 仅 workflow_dispatch，不是 PR gate；上游 Actions、维护者审批只在 PR 后验证，不冒称提交前通过。

所有必需检查未完成或失败时不投递。失败须同基线同环境对照，但不能以基线同失败替代“已通过”。本文件是清单，不代表已执行结果；结果另存精确 commit/命令/环境日志。
