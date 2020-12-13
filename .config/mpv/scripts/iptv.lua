--mp.set_property("time-pos", 20)

local osd_time=10
local window=7

local timer
-- pls — список элементов плейлиста
local pls
-- plsfiltered — список индексов выбранных фильтром элементов плейлиста
local plsfiltered
--local plscount
local plspos = 1
local wndstart
local wndend
local cursor
local pattern=""
local is_active
local is_altkeys
local is_playlist_loaded
local ass_start = mp.get_property_osd("osd-ass-cc/0")
local ass_stop = mp.get_property_osd("osd-ass-cc/1")

local altkeys={
  ['a']='ф',
  ['b']='и',
  ['c']='с',
  ['d']='в',
  ['e']='у',
  ['f']='а',
  ['g']='п',
  ['h']='р',
  ['i']='ш',
  ['j']='о',
  ['k']='л',
  ['l']='д',
  ['m']='ь',
  ['n']='т',
  ['o']='щ',
  ['p']='з',
  ['q']='й',
  ['r']='к',
  ['s']='ы',
  ['t']='е',
  ['u']='г',
  ['v']='м',
  ['w']='ц',
  ['x']='ч',
  ['y']='н',
  ['z']='я',
  ['`']='ё',
  [',']='б',
  ['.']='ю',
  [';']='ж',
  ['\'']='э',
  ['[']='х',
  [']']='ъ',
}
-- UTF-8 lower/upper conversion
local utf8_lc_uc = {
  ["a"] = "A",
  ["b"] = "B",
  ["c"] = "C",
  ["d"] = "D",
  ["e"] = "E",
  ["f"] = "F",
  ["g"] = "G",
  ["h"] = "H",
  ["i"] = "I",
  ["j"] = "J",
  ["k"] = "K",
  ["l"] = "L",
  ["m"] = "M",
  ["n"] = "N",
  ["o"] = "O",
  ["p"] = "P",
  ["q"] = "Q",
  ["r"] = "R",
  ["s"] = "S",
  ["t"] = "T",
  ["u"] = "U",
  ["v"] = "V",
  ["w"] = "W",
  ["x"] = "X",
  ["y"] = "Y",
  ["z"] = "Z",
  ["а"] = "А",
  ["б"] = "Б",
  ["в"] = "В",
  ["г"] = "Г",
  ["д"] = "Д",
  ["е"] = "Е",
  ["ж"] = "Ж",
  ["з"] = "З",
  ["и"] = "И",
  ["й"] = "Й",
  ["к"] = "К",
  ["л"] = "Л",
  ["м"] = "М",
  ["н"] = "Н",
  ["о"] = "О",
  ["п"] = "П",
  ["р"] = "Р",
  ["с"] = "С",
  ["т"] = "Т",
  ["у"] = "У",
  ["ф"] = "Ф",
  ["х"] = "Х",
  ["ц"] = "Ц",
  ["ч"] = "Ч",
  ["ш"] = "Ш",
  ["щ"] = "Щ",
  ["ъ"] = "Ъ",
  ["ы"] = "Ы",
  ["ь"] = "Ь",
  ["э"] = "Э",
  ["ю"] = "Ю",
  ["я"] = "Я",
  ["ё"] = "Ё"
}

local utf8_uc_lc = {
  ["A"] = "a",
  ["B"] = "b",
  ["C"] = "c",
  ["D"] = "d",
  ["E"] = "e",
  ["F"] = "f",
  ["G"] = "g",
  ["H"] = "h",
  ["I"] = "i",
  ["J"] = "j",
  ["K"] = "k",
  ["L"] = "l",
  ["M"] = "m",
  ["N"] = "n",
  ["O"] = "o",
  ["P"] = "p",
  ["Q"] = "q",
  ["R"] = "r",
  ["S"] = "s",
  ["T"] = "t",
  ["U"] = "u",
  ["V"] = "v",
  ["W"] = "w",
  ["X"] = "x",
  ["Y"] = "y",
  ["Z"] = "z",
  ["А"] = "а",
  ["Б"] = "б",
  ["В"] = "в",
  ["Г"] = "г",
  ["Д"] = "д",
  ["Е"] = "е",
  ["Ж"] = "ж",
  ["З"] = "з",
  ["И"] = "и",
  ["Й"] = "й",
  ["К"] = "к",
  ["Л"] = "л",
  ["М"] = "м",
  ["Н"] = "н",
  ["О"] = "о",
  ["П"] = "п",
  ["Р"] = "р",
  ["С"] = "с",
  ["Т"] = "т",
  ["У"] = "у",
  ["Ф"] = "ф",
  ["Х"] = "х",
  ["Ц"] = "ц",
  ["Ч"] = "ч",
  ["Ш"] = "ш",
  ["Щ"] = "щ",
  ["Ъ"] = "ъ",
  ["Ы"] = "ы",
  ["Ь"] = "ь",
  ["Э"] = "э",
  ["Ю"] = "ю",
  ["Я"] = "я",
  ["Ё"] = "ё"
}

--utf8 char pattern
local utf8_char="[\1-\127\192-\223][\128-\191]*"

local cyr_chars={'а','б','в','г','д','е','ё','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ','ъ','ы','ь','э','ю','я'}

-- символы, которые возможно вводить для поиска
local chars={}
for i=string.byte('a'),string.byte('z') do
  table.insert(chars,i)
end
for i=string.byte('A'),string.byte('Z') do
  table.insert(chars,i)
end
for i=string.byte('0'),string.byte('9') do
  table.insert(chars,i)
end
for _,v in ipairs({',','^','$','(',')','%','.','[',']','*','+','-','?','`',"'",";"}) do
  table.insert(chars,string.byte(v))
end

function add_bindings()
  mp.add_key_binding('UP', 'plsup', up,"repeatable")
  mp.add_key_binding('DOWN', 'plsdown', down,"repeatable")
  for i,v in ipairs(chars) do
    c=string.char(v)
    mp.add_key_binding(c, 'search'..v, typing(c),"repeatable")
  end
  mp.add_key_binding('SPACE', 'search32', typing(' '),"repeatable")

--[[    mp.add_key_binding('а', 'search1000', typing('а'),"repeatable")
    mp.add_key_binding('с', 'search1001', typing('с'),"repeatable")]]

  mp.add_key_binding('BS', 'searchbs', backspace,"repeatable")
  mp.add_key_binding('ENTER', 'plsenter', play)
  for i,v in ipairs(cyr_chars) do
    mp.add_key_binding(v, 'search'..i+1000, typing(v),"repeatable")
  end

--  mp.add_key_binding('Ctrl+6', 'searchaltkeys', switchkbrd)
end

function remove_bindings()
   mp.remove_key_binding('plsup')
   mp.remove_key_binding('plsdown')
   mp.remove_key_binding('plsenter')
   for i,v in ipairs(chars) do
        c=string.char(v)
        mp.remove_key_binding('search'..v)
   end
   mp.remove_key_binding('search32')
   mp.remove_key_binding('searchbs')
   for i,v in ipairs(cyr_chars) do
     mp.remove_key_binding('search'..i+1000)
   end
--   mp.remove_key_binding('searchaltkeys')
end

function activate()
  local i
  local c
  if is_active then
    shutdown()
    return
  else
    is_active=true
    showplaylist()
    add_bindings()
    if not timer then
      timer=mp.add_periodic_timer(osd_time, shutdown)
      timer.oneshot=true
    else
      resumetimer()
    end
  end
end

function tablekeys(t)
  local result={}
  for i,v in ipairs(t) do
    table.insert(result,i)
  end
  return result
end

function mylower(s)
  local res,n =  string.gsub(s,utf8_char,function (c)
                                    return utf8_uc_lc[c]
                                 end)
  return res
end

function myupper(s)
  local res,n =  string.gsub(s,utf8_char,function (c)
                                    return utf8_lc_uc[c]
                                 end)
  return res
end

function prepat(s)
--prepare nocase and magic chars
  s = string.gsub(s, "[%^%$%(%)%%%.%[%]%*%+%-%?]",function (c)
        return '%'..c
      end)
--[[  s = string.gsub(s, utf8_char, function (c)
        return string.format("[%s%s]", utf8_uc_lc[c] or c, utf8_lc_uc[c] or c)
      end)]]
  return s
end

function resumetimer()
  timer:kill()
  timer:resume()
end

function switchkbrd()
  is_altkeys = not is_altkeys
  showplaylist()
end

function typing(char)
  return function()
           local c=string.lower(char)
           if is_altkeys then
             pattern = pattern..( altkeys[c] or c )
           else
             pattern = pattern..c
           end
           filterpls()
           showplaylist()
           resumetimer()
         end
end

function backspace()
  if string.len(pattern)>0 then
--    pattern = string.sub(pattern,1,-2)
-- for unicode
    pattern = string.match(pattern,"(.*)"..utf8_char.."$")
    filterpls()
    showplaylist()
    resumetimer()
  end
end

function filterpls()
  plsfiltered={}
  for i,v in ipairs(pls) do
    if string.match(mylower(v.title),'.*'..prepat(pattern)..'.*') then
      table.insert(plsfiltered,i)
    end
  end
  wndstart=1
  cursor=0
end

function formatentry(v)
  local t
  t=v.title or ""
  if v.current then
    -- current playing entry
    -- mp.msg.error(v.current)
      -- t = "▶ "..t
      t = "{\\1c&H00FF00&}▶ {\\1c&HFFFFFF&}"..t
  end
  return t
end

function play()
--  mp.commandv("playlist-move", wndstart+cursor, 1)
--  mp.commandv("playlist-clear")
--  mp.commandv("playlist-next")
  mp.commandv("loadfile",pls[plsfiltered[wndstart+cursor]].filename)

  if plspos then
    mp.msg.error(plspos)
    pls[plspos].current=false
  end
  plspos=plsfiltered[wndstart+cursor]
  -- msg.error(plspos)
  -- msg.log(error, plspos)
  pls[plspos].current=true
  showplaylist()
  resumetimer()
end

function showplaylist()
  local i
  local newpos
  local msg
  --media-title
  --playlist t[2].title

--[[  if not pls then
    pls=mp.get_property_native("playlist")
    pattern=""
    plsfiltered=tablekeys(pls)
  end]]
  if not plsfiltered then
    return
  end
  if not plspos then
    plspos=mp.get_property_native("playlist-pos-1")
    --plscount=mp.get_property_native("playlist-count")
  end
  if not wndstart or not cursor then
    wndstart=1
    cursor=0
  end

  msg=""
  i = wndstart
  while plsfiltered[i] and i<=wndstart+window-1 do
    if i==wndstart+cursor then
      -- current under cursor entry
      msg = msg.."{\\1c&H0000FF&}● {\\1c&HFFFFFF&}"
    end
    msg = msg..formatentry(pls[plsfiltered[i]]).."\n"
    -- msg = msg.."\n"
    i = i+1
  end
  if wndstart>1 then
    msg = "...\n"..msg
  else
    msg = " \n"..msg
  end
  if wndstart+window-1<#plsfiltered then
    msg = msg.."..."
  end
  if is_altkeys then
    msg="(ru)/"..pattern.."\n"..msg
  else
    msg="/"..pattern.."\n"..msg
  end
  mp.osd_message(ass_start..msg..ass_stop, osd_time)

end

function shutdown()
   local c
   remove_bindings()

   is_active=false
   mp.osd_message("", 1)
end

function down()
  if cursor >= #plsfiltered-1 then return end
  if cursor<window-1 then
    cursor=cursor+1
    showplaylist()
  else
    if wndstart<#plsfiltered-window+1 then
      wndstart=wndstart+1
    end
    showplaylist()
  end
  resumetimer()
end

function up()
  if cursor>0 then
    cursor=cursor-1
    showplaylist()
  else
    if wndstart>1 then
      wndstart=wndstart-1
      showplaylist()
    end
  end
  resumetimer()
end

function on_start_file()
  if is_playlist_loaded then
    if not pls then
      pls=mp.get_property_native("playlist")
      pattern=""
      plsfiltered=tablekeys(pls)
    end
    mp.commandv("stop")
    mp.unregister_event(on_start_file)
    activate()

  else
    is_playlist_loaded = true
  end
end

if mp.get_opt("iptv") then
  mp.add_hook('on_load', 9, function ()
     mp.set_property_native('ytdl', false)
  end)
  mp.set_property_bool("idle", true)
  mp.set_property_bool("force-window", true)
  mp.register_event("start-file", on_start_file)
  mp.add_key_binding('\\', 'activate', activate)
--  mp.set_property("fullscreen", "yes")
end

