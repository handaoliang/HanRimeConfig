<div align="center">

# HanRimeConfig

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/Platform-macOS-lightgrey.svg)](https://github.com/rime/squirrel)
[![Rime](https://img.shields.io/badge/Rime-Squirrel%201.1.2%2B-orange.svg)](https://github.com/rime/squirrel)

一份折腾出来的 Rime / Squirrel 五笔输入法配置——把"还行"调到"用着舒服"。

</div>

本项目部分配置来自于 [KyleBing 的 86五笔极点码表](https://github.com/KyleBing/rime-wubi86-jidian) 和 [雾凇拼音](https://github.com/iDvel/rime-ice)，非常感谢。

⚠️请注意：本项目主要为 **习惯五笔输入法的使用者** 而定制，拼音只是辅助，并不是这份配置的强项。

如果想更好的发挥效率，需要配合这个我优化过的 [Squirrel 衍生项目](https://github.com/handaoliang/squirrel/tree/han-rime) 来使用，在这个项目中，主要做了以下几件事：

- Command + Space 切换中英文：我习惯用 Command + Space 切换中英文，因为这个组合键被触碰的速度最快，但是在macOS下面 Toggle 后会吞掉事件，所以只能借助 CGEventTap 来实现，而 CGEventTap 需要辅助功能，这是和 Rime 不同的地方。
- 中英文自动空格(盘古空格)：之前想纯粹用 Lua 配置来实现盘古空格，但是 Lua 的能力有限，只能在上屏时根据前面输入的字符来判断，放到 Squirrel 前端来实现就靠谱多了，因为它可以请求拿到当前光标前后的真实字符。当然也不是所有的 App 里面都可以，比如在 iTerm2 / Ghostty 等这些不完整遵守 IMKit 协议的终端里面就不行。
- 智能全角 / 半角空格：有些地方，出于排版美观的需要，要用到中文全角空格，而有一些地方则需要用到半角空格，这个平时也是输入非常不方便的地方。借助 Squirrel 的能力来实现的。
- 五笔无候选时自动转英文(前端接管)：这个也是通过 Lua 配置实现不了的，在 Squirrel 中实现反而是可行的。

## 为什么会有这个项目

虽然早在十多年前就知道 [鼠须管](https://rime.im) 这个"为爱发电"的开源输入引擎，之前也玩过一阵，但是一直没有深入玩，由于打字并不是平时工作和生的主要诉求，因此“凑合能用就行”也就成了习惯。但随着用AI越来越多，就发现在各种输入法之间的切换成了瓶颈，每天都要遇到因为输入错误而浪费大量的时间和Token，而我是主要用五笔打的，尽管已经比一般人快了，但还是会有“速度跟不上”的烦恼。在此期间，还折腾过几个市面上的五笔输入法：

- 有的词库一般、调词效果差
- 有的功能太"重"，弹窗、推广、云同步一堆
- 有的不支持自动学习词频
- 有的中英混输处理得不好，每次切换都要按 Shift
- 有的标点习惯和中文写作不合
- 有的连最基本的"反查"都做不到，碰到不会拆的字只能换输入法

均不是十分满意，于是只好抽时间基于 `Rime` 来配置一份适合自己的输入法：

- 主要是五笔输入场景，有些字打着打着不会拆码了，得临时调一下拼音。
- 需要有大量输入英文的场景，需要能无缝输入，而不是要切到ABC下面去输入。
- 可以智能根据词频来排序，而不是固化的每次都要按一下数字来选择，比如 `ipmq` 这个码，我的本意是要输入“觉”字，但是由于词频的原因，经常会导致输入“常见”两个字，这个时候我希望能自动把“觉”字调频到前面，后面就可以直接上屏。
- 写代码、写注释、写Markdown文经常要中英文一起，输入英文之后，有时候是全角空格，有时候是半角空格，这让我这种“有一定洁癖”的人就无法接受统一的，因此要更智能的空格输入。

针对这些小众的需求，不断修修改改，最后变成了一份自己用得舒服的方案。开源出来，希望对其他想用 Rime 五笔的人有点参考价值。

## 主要功能

### 输入

- ✅ **极点五笔 86** 作为主输入方案
- ✅ **雾凇拼音** 作为辅助拼音方案（按 `F4` / `Ctrl+\`` 切换）
- ✅ **大写数字**、五笔拼音混输、简入繁出等方案按需保留在方案菜单中
- ✅ **方案选单标题**改为简体的「选择输入法」

### 反查

- ✅ `z` 触发**雾凇拼音反查**（用 `rime_ice` 词典，词库更全）
- ✅ `` ` `` 触发**简单拼音反查**（用 `pinyin_simp` 词典，输出简体更稳定）

不会拆字时，按反查键 + 拼音就能查到字、同时看到对应的五笔编码——学码神器。

### 中英混输

- ✅ **大写字母自动触发英文累积模式**：按 `H`、`e`、`l`、`l`、`o`、空格、`w`、`o`、`r`、`l`、`d`，回车一次性上屏 `Hello world`
- ✅ **支持 `iMac` 这类小写开头但含大写的输入**：只要输入码中**包含大写字母**就触发
- ✅ **英文模式下支持完整 ASCII 标点**：`Hello, world!` `(test)` `^_^` 都能正常累积
- ✅ **英文模式下屏蔽 Shift 切换**：避免输大写字母时意外触发 ASCII 模式切换导致 input 提前上屏

### 智能标点

- ✅ **中文模式下 `/` 输出顿号 `、`**（写中文比 `,` 顺手）
- ✅ **中文模式下空格输出全角空格 `　`**（适合中文文章排版）
- ✅ **智能空格**：上一次上屏的是英文 → 这次空格用半角；上一次是中文 → 用全角（参考"盘古之白"思想，但作用在按空格本身而不是上屏后自动插入）
- ✅ **中英文之间自动补半角空格**：在极点五笔中启用保守版 Pangu spacing，主要处理英文后接中文候选的场景

### 快捷输入

| 输入 | 输出 |
|---|---|
| `rq` | `YYYY-MM-DD` / `YYYY年MM月DD日` / `MM-DD` / `YYYY/MM/DD` |
| `sj` | `15:30` / `15:30:45` |
| `xq` | `周日` / `星期日` / `礼拜日` |

### 用户词典

- ✅ 启用**词频学习**——选词多的字自动排到前面
- ✅ 启用**自动造词**——连续上屏 `觉` `得`，下次输入对应编码时 `觉得` 作为词组候选出现

## 文件结构

```
HanRimeConfig/
├── README.md
├── LICENSE
├── deploy.sh                         # 使用 Squirrel 自带 rime_deployer 构建本配置
├── default.custom.yaml              # 全局: 方案列表、菜单大小、Shift 切换行为
├── squirrel.custom.yaml             # Squirrel 主题: 颜色、字体、布局
├── wubi86_jidian.custom.yaml         # 极点五笔 86 定制（主方案）
├── wubi86.custom.yaml               # 五笔 86 定制
├── rime_ice.schema.yaml              # 雾凇拼音方案
├── rime_ice.custom.yaml              # 雾凇拼音定制（如模糊音）
├── rime_ice.dict.yaml                # 雾凇拼音主词库入口
├── symbols_v.yaml                    # 雾凇拼音 v 模式符号表
├── cn_dicts/                         # 雾凇拼音中文词库
├── en_dicts/                         # 雾凇拼音英文/中英混输词库
├── luna_pinyin_simp.custom.yaml      # 朙月拼音·简化字定制（备用）
├── rime.lua                         # Lua 总入口(只做 require)
└── lua/
    ├── english_sentence.lua          # 大写字母触发英文句子累积
    ├── smart_space.lua               # 智能半角/全角空格
    ├── pangu_spacing_filter.lua      # 英文后接中文候选时补半角空格
    └── wubi86_jidian_date_translator.lua # 极点五笔日期/时间快捷输入
```

## 安装

### 前置要求

1. **macOS** 系统
2. 安装 **Squirrel 输入法**（推荐 1.1.2 或更高版本）

如果还没装 Squirrel，可以用 Homebrew：

```bash
brew install --cask squirrel
```

或者去官网下载安装包：[https://rime.im/download/](https://rime.im/download/)

### 安装本配置

```bash
# 1. 进入到~/Library/文件夹，Rime的配置目录在这个文件夹下
cd ~/Library/

# 2. 备份你现有的 Rime 配置(以防需要回滚)
mv ~/Library/Rime ~/Library/Rime.bak

# 3. Clone源代码文件到 Rime 用户目录
git clone https://github.com/handaoliang/HanRimeConfig.git Rime

# 4. 构建 Rime 数据
cd ~/Library/Rime
./deploy.sh

# 5. 如 Squirrel 没有立刻刷新，可切换到 ABC 再切回 Squirrel，
#    或点击菜单栏 Squirrel 图标 → "重新部署"
```

### 验证安装

部署成功后：

- 按 `F4` 或 `Ctrl+\``，方案菜单标题应显示**「选择输入法」**
- 方案菜单里应能看到**极点五笔**和**雾凇拼音**
- 选中**极点五笔**，输入 `wqvb` 应该出现"你好"候选

如果部署失败或方案没出现，看下面的"故障排查"。

## 使用指南

### 输入方案切换

按 `F4` 或 `Ctrl+\`` 弹出方案菜单，按数字选择"极点五笔"或"雾凇拼音"。

### 五笔正常输入

输入五笔编码，按空格选第一个候选上屏，按数字 `2`-`9` 选对应序号的候选。

### 反查（不会拆字时）

| 操作 | 触发键 | 说明 |
|---|---|---|
| 雾凇拼音反查 | `z` + 拼音 | 例：`znihao` → 显示"你"、"好"等，候选项的 comment 显示五笔码 |
| 简单拼音反查 | `` ` `` + 拼音 | 使用 `pinyin_simp`，输出简体更稳定 |

按 Esc 退出反查。

### 中英混输

**方式 1：大写字母触发（推荐用于英文短语）**

直接按一个大写字母（如 `H`），自动进入英文累积模式：
- 后续可输入字母、数字、空格、标点
- 按**回车**整段上屏

也支持小写开头但含大写的输入（如 `iMac`、`fooBar`）——只要输入码中**包含**大写字母就触发。

**方式 2：右 Shift 切换 ASCII 模式（推荐用于长段英文/代码）**

按右 Shift，Squirrel 切到英文模式（菜单栏图标提示）。这种状态下所有字母直接输出英文，再次按右 Shift 切回中文。

### 快捷输入

| 输入 | 候选 |
|---|---|
| `rq` | 各种日期格式 |
| `sj` | 各种时间格式 |
| `xq` | 各种星期表示 |

## 自定义建议

### 修改方案显示名

编辑 `wubi86_jidian.custom.yaml` 的这一行：

```yaml
"schema/name": "极点五笔"
```

改成你想要的名字即可。`wubi86_jidian.custom.yaml`、`rime_ice.custom.yaml` 同理。

### 修改方案菜单顺序

编辑 `default.custom.yaml`：

```yaml
schema_list:
  - schema: wubi86_jidian     # 第 1 位:启动后默认方案
  - schema: rime_ice          # 第 2 位
```

顺序就是 F4 菜单里的显示顺序，第一个也是 Squirrel 启动后的默认方案。

### 关闭某个 Lua 功能

优先使用配置开关。比如 `pangu_spacing` 和 `smart_space` 在 `default.custom.yaml` 中默认关闭，只在 `wubi86_jidian.custom.yaml` 中打开：

```yaml
# default.custom.yaml
pangu_spacing:
  enabled: false

smart_space:
  enabled: false
```

```yaml
# wubi86_jidian.custom.yaml
pangu_spacing:
  __include: default:/pangu_spacing
  enabled: true

smart_space:
  __include: default:/smart_space
  enabled: true
```

如果要彻底禁用某个 Lua 模块，再在 `rime.lua` 里把对应 `require` 注释掉，并在方案的 `engine/processors` / `engine/filters` / `engine/translators` 列表里注释掉对应行。例如关闭智能空格：

```lua
-- rime.lua
-- smart_space = require("smart_space")   ← 注释这行
```

```yaml
# wubi86_jidian.custom.yaml
engine/processors:
  - lua_processor@english_sentence
  - ascii_composer
  - ...
  # - lua_processor@smart_space          ← 注释这行
  - ...
```

### 修改颜色主题

编辑 `squirrel.custom.yaml`，里面定义了几个自带主题（`HanDouNormal`、`HanDouLight`、`HanDouDark`）。切换：

```yaml
"style/color_scheme": HanDouNormal        # 浅色模式主题
"style/color_scheme_dark": HanDouNormal   # 深色模式主题
```

## 故障排查

### 部署失败 / 方案没出现

最直接的诊断方法是运行仓库里的部署脚本：

```bash
cd ~/Library/Rime
./deploy.sh
```

脚本会显式传入用户目录、Squirrel 共享目录和 build 目录，比直接执行 `rime_deployer --build ~/Library/Rime` 更稳。输出里会显示每个 schema 部署的错误信息。常见错误：

**`copy on write failed; incompatible node type`**

你的 `*.custom.yaml` 里某个 patch 的值类型和 default 预设里定义的不兼容（比如用字典覆盖列表）。解决：注释掉或换写法。

**`missing input schema: xxx`**

`xxx.schema.yaml` 源文件不存在。如果是 Rime 自带方案（如 `luna_pinyin_simp`），检查共享目录有没有：

```bash
ls "/Library/Input Methods/Squirrel.app/Contents/SharedSupport/" | grep luna_pinyin_simp
```

如果没有，重新安装 Squirrel 或单独下载源文件。

**`resource could not be loaded: symbols_v`**

雾凇拼音的 `rime_ice.schema.yaml` 引用了 `symbols_v.yaml`：

```yaml
punctuator:
  symbols:
    __include: symbols_v:/symbols
```

如果只复制了 `rime_ice.schema.yaml` / `rime_ice.dict.yaml`，但没有复制 `symbols_v.yaml`，就会报这个错。把雾凇拼音配套文件补齐后重新运行 `./deploy.sh`。

**`unresolved dependency: Patch(xxx.custom:patch)`**

custom.yaml 里某个 patch 解析失败（通常前面有更具体的错误）。看更前面的错误日志。

### 五笔能用但词频不学习

检查 `wubi86.custom.yaml` 里这一行是否存在且未注释：

```yaml
"translator/enable_user_dict": true
```

部署成功后，用户词典文件会在对应方案的 `*.userdb/` 目录下出现，例如 `~/Library/Rime/wubi86_jidian.userdb/`。

### 标点没有按预期变成中文

Rime 默认在英文（ASCII）模式下输出英文标点，中文模式下输出中文标点。检查菜单栏图标是不是处于中文模式。

按 `Shift+Space` 可以切换全角/半角。

## 已知限制

下面是一些**没有做到**或**做到了但有妥协**的功能，诚实告知：

### 1. 标点配对（部分）

- ✅ `'` `"` 引号能配对交替输出（`‘` `’` / `“` `”`）
- ⚠️ `(`、`[`、`{`、`<` 的配对在不同 Rime 版本的 default 预设下表现不一致——某些版本能用、某些版本会因为类型冲突部署失败
- ❌ 不能做到"按 `(` 出 `（）` 且光标停在中间"——这需要操作目标程序的光标，Rime 输入法架构上做不到

### 2. App 级别的输入状态

- ❌ 不能做到"打开新 App 自动切到英文"——Rime 收不到 App 切换事件
- 想要这个功能需要借助 [Hammerspoon](https://www.hommerspoon.org/) 等外部工具

### 3. 在中英文之间自动插入空格（Pangu Spacing）

- ✅ 当前在**极点五笔**中保留了一个保守版：英文/数字后选择中文候选时，会在中文候选前补半角空格
- ✅ 另一方向（中文后回车上屏英文）由 `english_sentence.lua` 处理
- ⚠️ 这不是完整的排版引擎；它依赖 Rime 的上屏历史和候选流，只处理最常见的中英混排场景
- ⚠️ 全局默认关闭，只在 `wubi86_jidian.custom.yaml` 中开启

### 4. 全键路径写法的兼容性

- 在某些 Rime 版本下，`punctuator/half_shape/<` 这种全键路径 patch 会因为 default 预设是列表类型而报错。本配置已经规避了已知的雷点（注释掉了 `<` `[` `{` 的 patch），但如果你在新版本的 Squirrel 上遇到问题，可能需要再注释或调整

## 致谢

这份配置站在很多巨人肩膀上：

- **[Rime / librime](https://github.com/rime/librime)** — 神级开源输入引擎，整个项目的基石
- **[Squirrel](https://github.com/rime/squirrel)** — macOS 上的 Rime 前端
- **[rime-wubi](https://github.com/rime/rime-wubi)** — 五笔 86 方案的源文件和词典
- **[rime-luna-pinyin](https://github.com/rime/rime-luna-pinyin)** — 朙月拼音方案和基础拼音资源
- **[雾凇拼音](https://github.com/iDvel/rime-ice)** — 当前拼音辅助方案和 `z` 反查词库
- **[KyleBing 的 86五笔极点码表](https://github.com/KyleBing/rime-wubi86-jidian)** — 当前主要的五笔输入配置
- **[东风破 / plum](https://github.com/rime/plum)** — Rime 方案管理工具

特别感谢中文 Rime 社区的众多前辈分享的各种配置技巧。

## 协议

本仓库以 **GPL-3.0** 协议开源。详见 [LICENSE](./LICENSE) 文件。

简单来说：你可以自由使用、修改、分发本配置；但如果你基于本配置做了修改并分发，你的衍生作品也必须以 GPL-3.0 或兼容协议开源。

## 反馈与贡献

如果你在使用中发现问题、有改进建议、或者基于这份配置做了自己的修改想分享回来——欢迎在 [Issues](https://github.com/handaoliang/HanRimeConfig/issues) 提问，或者 Pull Request。
