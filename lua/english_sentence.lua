-- english_sentence.lua
-- 配合 Rime 原生 uppercase 段使用,实现"大写字母触发英文句子输入"
--
-- 工作原理:
--   1. Rime 检测到输入码中包含大写字母时,识别为 uppercase 段
--      不查码表,字母在 preedit 累积显示
--   2. 默认行为下,空格和标点会被其他 processor 抢走触发上屏
--      本 processor 在 uppercase 段中拦截它们,追加到 input
--   3. 在 uppercase 段中按单独的 Shift 键不切换 ASCII 模式
--      避免输大写字母组合时意外触发模式切换导致 input 上屏
--   4. 回车 / Esc / BackSpace 走 Rime 默认行为(上屏 / 取消 / 删字符)
--
-- 作者: handaoliang

local kAccepted = 1
local kNoop     = 2

-- 在 uppercase 段中需要拦截并追加到 input 的按键
-- key_repr -> 实际追加的字符
-- 覆盖几乎所有可打印 ASCII 标点
local key_to_char = {
  -- 空格
  ["space"]        = " ",
  -- 数字键；在 composing 状态下数字默认可能被 selector 当成选词键，
  -- uppercase 段中显式接管才能稳定输入 Hello 2026 这类内容。
  ["0"]            = "0",
  ["1"]            = "1",
  ["2"]            = "2",
  ["3"]            = "3",
  ["4"]            = "4",
  ["5"]            = "5",
  ["6"]            = "6",
  ["7"]            = "7",
  ["8"]            = "8",
  ["9"]            = "9",
  -- 直接键位标点
  ["comma"]        = ",",
  ["period"]       = ".",
  ["semicolon"]    = ";",
  ["apostrophe"]   = "'",
  ["grave"]        = "`",
  ["minus"]        = "-",
  ["equal"]        = "=",
  ["bracketleft"]  = "[",
  ["bracketright"] = "]",
  ["backslash"]    = "\\",
  ["slash"]        = "/",
  -- Shift + 数字 / 符号
  ["exclam"]       = "!",   -- Shift+1
  ["at"]           = "@",   -- Shift+2
  ["numbersign"]   = "#",   -- Shift+3
  ["dollar"]       = "$",   -- Shift+4
  ["percent"]      = "%",   -- Shift+5
  ["asciicircum"]  = "^",   -- Shift+6
  ["ampersand"]    = "&",   -- Shift+7
  ["asterisk"]     = "*",   -- Shift+8
  ["parenleft"]    = "(",   -- Shift+9
  ["parenright"]   = ")",   -- Shift+0
  ["underscore"]   = "_",   -- Shift+-
  ["plus"]         = "+",   -- Shift+=
  ["braceleft"]    = "{",   -- Shift+[
  ["braceright"]   = "}",   -- Shift+]
  ["bar"]          = "|",   -- Shift+\
  ["colon"]        = ":",   -- Shift+;
  ["quotedbl"]     = "\"",  -- Shift+'
  ["asciitilde"]   = "~",   -- Shift+`
  ["less"]         = "<",   -- Shift+,
  ["greater"]      = ">",   -- Shift+.
  ["question"]     = "?",   -- Shift+/
}

-- 判断当前是否处于 uppercase 段: input 中包含任意大写字母
-- 这样 iMac / nA / GitHub 等小写开头但含大写的输入也能触发英文累积
-- local function is_uppercase_segment(context)
--   local input = context.input
--   if not input or input == "" then return false end
--   return input:match("[A-Z]") ~= nil
-- end

local function has_uppercase(input)
  return input:match("[A-Z]") ~= nil
end

local function has_special_char(input)
  return input:match("[._+%-%$'\"`~!@#%%%^&*=%|\\/:;,?%(%)%[%]{}<>]") ~= nil
end

local function is_english_accumulation_segment(context)
  local input = context.input
  if not input or input == "" then return false end
  return has_uppercase(input) or has_special_char(input)
end

local function processor(key_event, env)
  local key = key_event:repr()
  local context = env.engine.context

  -- 按键释放事件: 默认放行
  -- 唯一例外: 在 uppercase 段中,屏蔽 Shift_R / Shift_L 的释放,
  -- 避免 ascii_composer 因释放事件触发 ASCII 模式切换导致 input 提前上屏
  if key_event:release() then
    -- if is_uppercase_segment(context)
    if is_english_accumulation_segment(context)
       and (key == "Shift_R" or key == "Shift_L") then
      return kAccepted
    end
    return kNoop
  end

  -- 仅在 uppercase 段中介入下面的逻辑
  -- if not is_uppercase_segment(context) then
  if not is_english_accumulation_segment(context) then
    return kNoop
  end

  -- 屏蔽单独按下的 Shift_R / Shift_L,避免触发模式切换
  -- (Shift + 字母 组合不受影响,因为字母键事件单独到达,会产生大写字母)
  if key == "Shift_R" or key == "Shift_L" then
    return kAccepted
  end

  -- 拦截标点 / 空格,追加到 input
  local char = key_to_char[key]
  if char then
    context.input = context.input .. char
    return kAccepted
  end

  -- 其他按键 (字母 / 数字 / 回车 / Esc / BackSpace 等) 走 Rime 默认行为
  return kNoop
end

return processor
