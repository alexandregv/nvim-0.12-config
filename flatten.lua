-- Flattens init.lua by inlining require("<module>")
-- Run with: nvim --headless -l flatten.lua > init_flattened.lua

local uv = vim and vim.loop or nil -- present when run via Neovim
local function file_exists(p)
  local f = io.open(p, "r")
  if f then f:close(); return true end
  return false
end

local function norm_module_to_path(mod)
  -- "foo.bar" -> "lua/foo/bar.lua"
  local rel = "lua/" .. (mod:gsub("%.", "/")) .. ".lua"
  return rel
end

local visiting = {}   -- to detect cycles (stack)
local seen = {}       -- optional: avoid duplicate inclusions; comment out to inline duplicates
local function process_file(path, origin)
  if visiting[path] then
    io.write(("-- cycle detected: already processing %s; required from %s\n"):format(path, origin or "unknown"))
    return
  end
  visiting[path] = true

  local fh, err = io.open(path, "r")
  if not fh then
    io.write(("-- missing file: %s (%s)\n"):format(path, err or ""))
    visiting[path] = nil
    return
  end

  for line in fh:lines() do
    -- Match ONLY a standalone require("<module>") line (optionally with spaces and optional semicolon)
    local mod = line:match("^%s*require%s*%(%s*\"([%w%._%-%/]+)\"%s*%)%s*;?%s*$")
                or line:match("^%s*require%s*%(%s*'([%w%._%-%/]+)'%s*%)%s*;?%s*$")

    if not mod then
      io.write(line, "\n")
    else
      local mod_path = norm_module_to_path(mod)
      io.write(("\n-- {{{ %s\n"):format(string.upper(mod)))
      if file_exists(mod_path) then
        if not seen[mod_path] then
          seen[mod_path] = true
          process_file(mod_path, path)
        else
          io.write(("-- skipped duplicate include: %s\n"):format(mod_path))
        end
      else
        io.write(("-- not found on disk: %s (keeping original require)\n"):format(mod_path))
        io.write(line, "\n")
      end
      io.write(("-- %s }}}\n"):format(string.upper(mod)))
    end
  end

  fh:close()
  visiting[path] = nil
end

io.write("-- vim: foldmethod=marker:fmr={{{,}}}\n\n") -- Enable auto folds with default markers ("{{{" / "}}}")
process_file("init.lua", nil)
