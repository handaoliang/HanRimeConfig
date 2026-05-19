-- pangu_spacing_filter.lua
-- 保守版英文后接中文间距: 在 ASCII 字母/数字之后选择中文候选时,
-- 给当前中文候选前补一个半角空格。
-- 另一方向「中文 + 英文」由 english_sentence.lua 在回车上屏时处理。

local function first_codepoint(text)
  if not text or text == "" then return nil end
  for _, codepoint in utf8.codes(text) do
    return codepoint
  end
  return nil
end

local function last_codepoint(text)
  if not text or text == "" then return nil end
  local last = nil
  for _, codepoint in utf8.codes(text) do
    last = codepoint
  end
  return last
end

local function is_ascii_alnum(codepoint)
  if not codepoint then return false end
  return (codepoint >= 0x30 and codepoint <= 0x39)
      or (codepoint >= 0x41 and codepoint <= 0x5A)
      or (codepoint >= 0x61 and codepoint <= 0x7A)
end

local function is_cjk(codepoint)
  if not codepoint then return false end
  return (codepoint >= 0x3400 and codepoint <= 0x4DBF)
      or (codepoint >= 0x4E00 and codepoint <= 0x9FFF)
      or (codepoint >= 0xF900 and codepoint <= 0xFAFF)
      or (codepoint >= 0x20000 and codepoint <= 0x2A6DF)
      or (codepoint >= 0x2A700 and codepoint <= 0x2B73F)
      or (codepoint >= 0x2B740 and codepoint <= 0x2B81F)
      or (codepoint >= 0x2B820 and codepoint <= 0x2CEAF)
      or (codepoint >= 0x2CEB0 and codepoint <= 0x2EBEF)
      or (codepoint >= 0x30000 and codepoint <= 0x3134F)
end

local function starts_with_space(text)
  return text and text:match("^%s") ~= nil
end

local function should_prefix_space(previous_text, current_text)
  if starts_with_space(current_text) then return false end

  local previous_last = last_codepoint(previous_text)
  local current_first = first_codepoint(current_text)

  return is_ascii_alnum(previous_last) and is_cjk(current_first)
end

local function with_prefix_space(cand)
  local text = " " .. cand.text
  if ShadowCandidate then
    return ShadowCandidate(cand, cand.type, text, cand.comment)
  end
  return Candidate(cand.type, cand.start, cand._end, text, cand.comment)
end

local function pangu_spacing_enabled(env)
  local config = env.engine.schema.config
  if not config then return true end
  return config:get_bool("pangu_spacing/enabled")
end

local function pangu_spacing_filter(input, env)
  if not pangu_spacing_enabled(env) then
    for cand in input:iter() do
      yield(cand)
    end
    return
  end

  local context = env.engine.context
  local history = context.commit_history
  local previous = nil

  if history and not history:empty() then
    local last_record = history:back()
    if last_record then
      previous = last_record.text
    end
  end

  for cand in input:iter() do
    if previous and should_prefix_space(previous, cand.text) then
      yield(with_prefix_space(cand))
    else
      yield(cand)
    end
  end
end

return pangu_spacing_filter
