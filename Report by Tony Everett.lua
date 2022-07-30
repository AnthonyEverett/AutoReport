script_name("AutoReport")
script_version("2.0")
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Îáíàðóæåíî îáíîâëåíèå. Ïûòàþñü îáíîâèòüñÿ c '..thisScript().version..' íà '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Çàãðóæåíî %d èç %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')sampAddChatMessage(b..'Îáíîâëåíèå çàâåðøåíî!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóñêàþ óñòàðåâøóþ âåðñèþ..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Îáíîâëåíèå íå òðåáóåòñÿ.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Íå ìîãó ïðîâåðèòü îáíîâëåíèå. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, âûõîäèì èç îæèäàíèÿ ïðîâåðêè îáíîâëåíèÿ. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/AnthonyEverett/AutoReport/main/update-version.json" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/AnthonyEverett/AutoReport"
        end
    end
end
require('moonloader')
local key = require('vkeys')
local sampev = require('lib.samp.events')
local imgui = require('imgui')
local rkeys = require('rkeys')
imgui.HotKey = require('imgui_addons').HotKey
local encoding = require('encoding')
encoding.default = 'CP1251'
 u8 = encoding.UTF8
local path = getGameDirectory()..'\\moonloader\\Report\\report-settings.json'
local sound = loadAudioStream('moonloader/Report/sound.mp3')
local cfg = {
    bindClock = {
        v = {49}
    }
}
if not doesFileExist(path) then
    local f = io.open(path, 'w+')
    f:write(encodeJson(cfg)):close()
else
    local f = io.open(path, "r")
    a = f:read("*a")
    cfg = decodeJson(a)
    f:close()
end

local tLastKeys = {}
local window = imgui.ImBool(false)

local spawned = false
local ips = {
    "185.169.134.3",
    "185.169.134.4",
    "185.169.134.43",
    "185.169.134.44",
    "185.169.134.45",
    "185.169.134.5",
    "185.169.134.59",
    "185.169.134.61",
    "185.169.134.107",
    "185.169.134.109",
    "185.169.134.166",
    "185.169.134.171",
    "185.169.134.172",
    "185.169.134.173",
    "185.169.134.174",
    "80.66.82.191",
    "80.66.82.190",
	"80.66.82.168",
    "80.66.82.188",
    "80.66.82.159" ,
    "80.66.82.200",
    "80.66.82.144"
}

function main()
    while not isSampAvailable() do wait(100) end
	if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
        sampRegisterChatCommand("areport", function() window.v = not window.v end)
		if sampIsLocalPlayerSpawned() and not spawned then
            for i, k in pairs(ips) do
                local ip, port = sampGetCurrentServerAddress()
                if ip == k then
                    spawned = true
                    name = sampGetCurrentServerName()
                    sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff}: Проверка на сервер пройдена, вы сейчас на: {ff6a6a}"..name.."{FFFFFF}!", -1)
                    sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff}: Приветствую, {FFFFFF}"..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))).."!", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff}: Вы успешно авторизовались как:", -1)
                    sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff}: {FFFFFF}Меню настройки - {7eff39}/areport", -1)
                end
            end
				if thisScript().filename ~= "Report by Tony Everett.lua" then
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					sampAddChatMessage("» {9f7ec9}[Ловля репорта]{FFFFFF}: Название скрипта было изменено, скрипт отключён и удалён из папки с игрой", -1)
					thisScript():unload()
					os.remove(thisScript().path)
			end
            if not spawned then
                sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
				sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Данный скрипт, работает только на серверах {db2e29}Arizona {ffffff}Role Play", 0x9f7ec9)
                sampAddChatMessage("» {9f7ec9}[Ловля репорта]{ffffff} Свяжитесь с разработчиком, если хотите уточнить возможность решения данной проблемы", 0x9f7ec9)
                sampShowDialog(6406, "Связь с разработчиком", "{9f7ec9}Разработчик - {FFFFFF}Tony Everett{9f7ec9}[{FFFFFF}Page{9f7ec9}]", "Открыть",'Понял', 0)
                while sampIsDialogActive(6406) do wait(100) end
                local res, butt, list, input = sampHasDialogRespond(6406)
                if butt == 1 then
                    os.execute('start https://vk.com/id666441368')
					thisScript():unload()
                else
                    thisScript():unload()
					os.remove(thisScript().path)
                end
            end
        end
    while true do wait(0)
		active = not active
        if isKeyJustPressed(cfg.bindClock.v[1]) and not sampIsDialogActive() and not sampIsCursorActive() then
		sampAddChatMessage(u8'» {9f7ec9}[Ловля репорта] {ffffff}Автоматическая ловля репорта: {ff004d}'..(active and 'включена' or 'выключена'), -1)
			if active and not sampIsDialogActive() and not sampIsCursorActive() then 
				sampSendChat('/ot')
				sampSendChat('/ot')
				sampSendChat('/ot')
				sampSendChat('/ot')
				sampSendChat('/ot')
				wait(620)
	end
end
        imgui.Process = window.v
        JSONSave()
    end
end

function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'update-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'» {9f7ec9}[Ловля репорта] {ffffff}: Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('» {9f7ec9}[Ловля репорта] {ffffff}: Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('» {9f7ec9}[Ловля репорта] {ffffff}: Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'» {9f7ec9}[Ловля репорта] {ffffff}: Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'» {9f7ec9}[Ловля репорта] {ffffff}: Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('» {9f7ec9}[Ловля репорта] {ffffff}: v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('» {9f7ec9}[Ловля репорта] {ffffff}: v'..thisScript().version..': Не могу проверить обновление. Смиритесь или обратитесь к разработчику')
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function imgui.OnDrawFrame()
    if window.v then
        imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 100), imgui.Cond.FirstUseEver)
        imgui.Begin("Ловля репорта", window, imgui.WindowFlags.NoResize)
            imgui.Text('Текущая кнопка ловли') imgui.SameLine()
            if imgui.HotKey("##1", cfg.bindClock, tLastKeys, 100) then
                rkeys.changeHotKey(bind, cfg.bindClock.v)
                JSONSave()
            end
        imgui.End()
    end
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4
    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end
    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end
    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], text[i])
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(w)
            end
        end
    end
    render_text(text)
end


function JSONSave()
    if doesFileExist(path) then
        local f = io.open(path, 'w+')
        if f then
            f:write(encodeJson(cfg)):close()
        end
    end
end
