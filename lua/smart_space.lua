-- smart_space.lua
-- 智能空格:根据上一个上屏内容决定输出半角还是全角空格
-- - 上一个上屏是 ASCII (英文/数字/英文标点) -> 半角空格 " "
-- - 上一个上屏是中文 / 无历史 -> 不处理,交给 punctuator 输出全角空格 "　"
-- 作者: handaoliang

local kAccepted = 1
local kNoop     = 2

-- 判断字符串最后一个"字符"是否为 ASCII 可打印字符(英文字母/数字/英文标点)
-- 注意: Lua 的 # 取的是字节数,中文 UTF-8 占 3 字节,所以不能直接 str:sub(-1)
local function last_char_is_ascii(text)
  if not text or text == "" then
    return false
  end
  -- 取最后一个字节
  local last_byte = text:byte(#text)
  if not last_byte then return false end
  -- ASCII 可打印范围: 0x21 ~ 0x7E
  -- 也允许 0x20 (空格自己),避免连续空格场景判断错误
  return last_byte >= 0x20 and last_byte <= 0x7E
end

local function processor(key_event, env)
  -- 忽略按键释放
  if key_event:release() then return kNoop end

  local key = key_event:repr()
  local context = env.engine.context

  -- 只处理空格键
  if key ~= "space" then return kNoop end

  -- 正在输入码状态: 让原有行为处理(选词上屏)
  if context:is_composing() then return kNoop end

  -- 此时是"空 input + 按空格"的场景
  -- 看 commit_history 最后一条
  local history = context.commit_history
  if not history or history:empty() then
    -- 没有上屏历史 -> 走默认行为(走 punctuator 输出全角空格)
    return kNoop
  end

  -- 取最后一条 commit 记录
  local last_record = history:back()
  if not last_record then return kNoop end

  local last_text = last_record.text
  if last_char_is_ascii(last_text) then
    -- 上一个上屏是 ASCII -> 输出半角空格,接管按键
    env.engine:commit_text(" ")
    return kAccepted
  end

  -- 上一个上屏是中文 -> 不处理,让 punctuator 输出全角空格
  return kNoop
end

return processor
