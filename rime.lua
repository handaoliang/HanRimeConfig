-- Rime Lua 总入口
-- 各功能模块拆分到 lua/ 目录下,本文件只做 require 和全局注册
-- 作者: handaoliang

-- 日期 / 时间 / 星期 快捷输入 (translator)
-- 在 schema 中通过 engine/translators 加 lua_translator@date_translator 启用
date_translator = require("date_translator")

-- 单字优先过滤器 (filter)
-- 在 schema 中通过 engine/filters 加 lua_filter@single_char_first_filter 启用
-- single_char_first_filter = require("single_char_first_filter")

-- 英文后接中文时自动补半角空格 (filter)
-- 在 schema 中通过 engine/filters 加 lua_filter@pangu_spacing_filter 启用
pangu_spacing_filter = require("pangu_spacing_filter")

-- 智能空格: 根据上一个上屏内容决定半角/全角 (processor)
smart_space = require("smart_space")

-- 大写字母触发英文句子累积输入 (processor)
english_sentence = require("english_sentence")
