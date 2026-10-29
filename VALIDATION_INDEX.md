# 验证证据索引

候选分支 `fix/parseiso-submillisecond-precision`，基线 `a9739fb3e5384a810e90d7376446f6d84ecc5029`，最终候选 tree `f33c3d17040806a2c91c55bb28d0ae3d763fcdee`。产品改动仅 `pkgs/core/src/parseISO/index.ts` 和 `test.ts`。未 commit/push/创建 PR；最终准入及公开操作交 root。

- `CANONICAL_TREE.json` / `CANONICAL_READBACK.json`：2070 个文件 blob/mode 绑定；用 `GIT_NO_LAZY_FETCH=1` 和 raw Gitblob 校验，非仅两文件 hash。
- `CRLF_ARCHIVE_DIFFERENCES.json`：第一次 Windows archive 的 2057 个 CRLF-only 差异；历史日志保留，正式结果采用 `canonical-*` 重绑轮。
- `canonical-node-matrix.json/log` 与各 `canonical-node{22,24,25,26}-{main,dst}.log`：四个当前官方 runtime，完整 253 files / 3180 PASS / 19 SKIP，各真实 DST 脚本 PASS。
- `canonical-timezone-full.json/log`：完整 378/378 时区，每区完整 main suite，PASS。
- `canonical-browser-all.log`：真实 Chromium / Xvfb，253 files / 3181 PASS / 18 SKIP。
- `canonical-quality-types.log`、`canonical-quality-lint.log`、`canonical-format-check.log`：实际 tsc build、全 1759 files oxlint、两改动文件官方 oxfmt。
- `canonical-smoke-all.log`：forced 全 package build 和全部 10 类 examples（CDN/CJS/CTS/ESM/lodash-fp/node-esm/rollup/TS/vite/webpack）成功。
- `canonical-formal-rest-final.json` 的 aggregate exit1 来自上述正式命令全部 exit0 之后的自加全树完整性 guard：识别到官方 locale task 产生的 19 个输出。不能把该 aggregate 写为 PASS，也不能把它描述为产品检查失败。

## Locale gate 的准确边界

当前 `.github/workflows/code_quality.yaml` 调 `mise //pkgs/core:test/locales`，后者传 `--test`；但 `scripts/build/localeSnapshots/index.ts` 只识别裸 `test`。因此现行官方 task 是生成操作，exit0 不能叫 snapshot 验证通过。

- `canonical-quality-locales.log`：原命令实际成功生成，非验证。
- `baseline-official-snapshot-generation.json`：独立 canonical baseline、同 Node26.13.0/依赖执行原命令，exit0。
- `SNAPSHOT_GENERATION_COMPARISON.json`：全部 95 份 baseline/candidate 生成结果逐字相同；每份前后 SHA 都保存。
- `SNAPSHOT_SEMANTIC_COMPARISON.json`：19 份相对 Gitblob 变化中，16 份仅表格 padding/分隔宽度；zh-CN/zh-HK/zh-TW 有上游已陈旧的解析值，baseline/candidate 一致。不能说19份全是排版。
- `baseline-true-snapshot-check.json` / `candidate-true-snapshot-check.json`：裸 `test` 双侧均在原始 ar-DZ snapshot mismatch 失败。当前 CI/CONTRIBUTING 没有明确调用裸 `test` 的门槛；此事实交 root 判定，不以基线失败豁免明确必过检查。
- `POST_TASK_MUTATIONS.json`、`generated-snapshots/`：原始生成产物与识别记录。
- `restore-generated-only.mjs` 只恢复清单中这19个 Markdown 到 canonical Gitblob；不泛 restore，不把无关输出加入 PR。

## 复现与来源

`date-fns-3199-3194-org.json`、`date-fns-3199-original-files.json`、`original-3199-author.patch`、`original-3199-LICENSE.md`、`ORIGINAL_COMMIT.json` 包含 OPEN 未合并 #3199、原作者/精确 SHA/许可证、完整 issue/comment/review/timeline。`related-pr*-files.json` 是相关 OPEN 实际 diff；全部409个 OPEN 标题正文已封存。

`original-ported-parseISO-index.ts` / `original-ported-parseISO-test.ts` 仅是原补丁在当前路径/Vitest 的最小移植，供 root 的保留原作者及 `-x` 来源 commit 使用；不是最终实现。最终实现已完全换成精确十进制位计算以避免原 floor 补丁对标准 `.001` 的回归。

`canonical-targeted-*` 为同一90项回归的 canonical baseline / 原补丁 / 最终对照。root 另有未变 source SHA 下的3000项独立 rational/BigInt 参考检查，见 root 自己证据，不充当 browser 或安装包证明。

## 最后完成的包与真实入口证明

`canonical-package-rebuild.json/log` 的最终 canonical build exit0。`PACKAGE_CANONICAL_EQUALITY.json` 及前后 manifest 确认全部5136个包文件逐字一致。`installed-package-proof.json/log` 记录干净npm pack/install后ESM/CJS/subpath/FP/带context入口读取6条真实文件输入，60项断言通过，其中一条由本机.NET10.0.11实际TimeOnly.MaxValue/DateTimeOffset序列化生成。`INSTALLED_CONSUMER_RESULT.json` 仅从该原始stdout提取结构结果，不是重复测试。最终2070-file/mode readback零差异。技术验证交付完成；新鲜准入核验、作者保留commit与公开PR仍由root执行。

精确校验保留既有数学 `hours<25` 范围；极长24.999...从浮点误拒变为实际小于25接受。24.x本身不是合法ISO、另题#4219未解决；不声称所有非法输入逐字不变或完整ISO兼容。
