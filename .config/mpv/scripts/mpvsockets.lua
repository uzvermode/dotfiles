-- mpvsockets, one socket per instance, removes socket on exit

local utils = require 'mp.utils'
tempDir = "/tmp"

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function join_paths(...)
    local arg={...}
    path = ""
    for i,v in ipairs(arg) do
        path = utils.join_path(path, tostring(v))
    end
    return path;
end

ppid = os.capture("stat=($(</proc/$$/stat)) && echo \"${stat[3]}\"", false)
os.execute("mkdir " .. join_paths(tempDir, "mpv-sockets") .. " 2>/dev/null")
mp.set_property("options/input-ipc-server", join_paths(tempDir, "mpv-sockets", ppid))

function vsync(name, value)
  -- print(value)
  if value == false then
    -- os.execute("xvsync&")
    -- os.execute("sleep 1;xrandr --output eDP1 --mode 1920x1080 --rate 59.9")
    -- os.execute("xrandr --output eDP1 --mode 1920x1080 --rate 60")
    -- os.execute("xvsync&")
  end
end
-- mp.observe_property("fullscreen", "bool", vsync)

function shutdown_handler()
    os.remove(join_paths(tempDir, "mpv-sockets", ppid))
    -- mp.set_property("fullscreen", "no")
    -- os.execute("xvsync&")
    -- os.execute("xrandr --output eDP1 --mode 1920x1080 --rate 60")
    -- os.execute("xrandr --output eDP1 --mode 1920x1080 --rate 59.9")
end
mp.register_event("shutdown", shutdown_handler)
