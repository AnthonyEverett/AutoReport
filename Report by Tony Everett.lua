script_name('Lulu Tools')
script_version("0.1")
date_update = "Обновлено 16.05.2022"
script_author('Alan_Butler') -- vk.com/alanbutler
script_properties("work-in-pause")

require 'lib.sampfuncs'
require 'lib.moonloader'

local sampev = require 'lib.samp.events'
local keys = require "vkeys"
local rkeys = require 'rkeys'
local inicfg = require "inicfg"
local imgui = require 'mimgui'
local ffi = require 'ffi'
local dl = require "SA-MP API.init"
ffi.cdef [[
  bool SetCursorPos(int X, int Y);
]]
ffi.cdef [[
    typedef int BOOL;
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;
    typedef int bInvert;
 
    HWND GetActiveWindow(void);

    BOOL FlashWindow(HWND hWnd, BOOL bInvert);
]]
local fa = require("fAwesome5")
local addons = require "ADDONS"
local base64 = require('base64')
local wm = require 'windows.message'
local vector = require "vector3d"
local memory = require("memory")
local mem = require "memory" -- просто забей, не обращай внимания
local effil = require"effil"
local cjson = require"cjson"
local dlstatus = require('moonloader').download_status
local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.BORDER)
local friends_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.BORDER)
local farchat_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.BORDER)
local font = renderCreateFont('Arial',20,1) 


imgui.HotKey = require('mimgui_addons').HotKey
isFastNakActive = false

listpr = 0
val = 0


local Matrix3X3 = require "matrix3x3"
local Vector3D = require "vector3d"


local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local sizeX, sizeY = getScreenResolution()

local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
sw, sh 	= getScreenResolution()

local amenu = new.bool()
local report_window = new.bool()
local gps_window = new.bool()
local lvl_window = new.bool()
local cmd_window = new.bool()
local color_window = new.bool()
local question_window = new.bool()
local fastmenuwindow = new.bool()
local recon_window = new.bool()
local getip_window = new.bool()
local reconinfo_window = new.bool()
local stats_window = new.bool()
local online_window = new.bool()
local amember_window = new.bool()
local tp_window = new.bool()
local update_window = new.bool()
local floodot_window = new.bool()
local admin_menu = new.bool()
local checkerfrac_window = new.bool()
local askin_window = new.bool()
local aveh_window = new.bool()
local agun_window = new.bool()
local fastnak_window = new.bool()
local resultfastnak_window = new.bool()
local pr_window = new.bool()

statusquitdialog = true
statusquesterr = false
statusadminquest = true
statusadmin = true
foundadmrep = false
local skinpng = {}
local VehiclePNG = {}
local GunPNG = {}

fastnak_errors = {}
outputtext = {}

local startafktime = 0
amount_pages = 10
local timerbutton = 0
local y_hovered_button = 0

local col = imgui.new.float[4](1, 0, 0, 1)

local state = false 
local cam = {}
local nearCars = {}
fastnak_cmd = {}
resources = {}
farchat = {}
fractp = false
ableautoquest = false
editrule = false

local lower, sub, char, upper = string.lower, string.sub, string.char, string.upper
local concat = table.concat

-- initialization table
local lu_rus, ul_rus = {}, {}
for i = 192, 223 do
    local A, a = char(i), char(i + 32)
    ul_rus[A] = a
    lu_rus[a] = A
end
local E, e = char(168), char(184)
ul_rus[E] = e
lu_rus[e] = E

--                      ИниКфг

local dirIni = "..\\Lulu Tools\\settings.ini"
local dirIniChecker = "..\\Lulu Tools\\checker.ini"



fracsAmember = {
	"Полиция ЛС",
	"RCSD",
	"FBI",
	"Полиция СФ",
	"Больница LS",
	"Правительство LS",
	"Тюрьма строгого режима LV",
	"Больница СФ",
	"Инструкторы",
	"TV студия LS",
	"Grove Street",
	"Los Santos Vagos",
	"East Side Ballas",
	"Varrios Los Aztecas",
	"The Rifa",
	"Russian Mafia",
	"Yakuza",
	"La Cosa Nostra",
	"Warlock MC",
	"Армия ЛС",
	"Центральный Банк",
	"Больница LV",
	"LVPD",
	"TV студия LV",
	"Night Wolves",
	"TV студия SF",
	"Армия SF",
	"Темное братство",
	"Страховая компания",
}

fracsCoords = {
  {1542.6509,-1675.4852,13.5549},
  {633.3720,-571.6201,16.3359},
  {-2445.8171,501.1045,30.0881},
  {-1606.2194,719.5082,12.0895},
  {1184.1810,-1323.9017,13.5752},
  {1498.0134,-1283.9470,14.5025},
  {232.6571,1900.7318,17.6470},
  {-2667.7461,631.7164,14.4531},
  {-2044.1971,-86.2229,35.1641},
  {1653.3683,-1661.7974,22.5156},
  {2495.1819,-1684.5923,13.5111},
  {2791.4797,-1616.4164,10.9219},
  {2002.7916,-1110.5563,26.7813},
  {2519.9241,-2006.3502,13.5469},
  {2185.7529,-1807.9521,13.3735},
  {946.1972,1731.3156,8.8516},
  {-2459.3276,136.4638,35.1719},
  {1463.7955,2773.2051,10.6719},
  {-2189.0889,-2350.8965,30.6250},
  {2735.3704,-2450.0916,17.5938},
  {1481.2026,-1765.0975,18.7929},
  {1607.5950,1824.4312,10.8203},
  {2286.4060,2425.4919,10.8203},
  {2637.5251,1182.2773,10.8203},
  {2502.6680,-1421.2522,28.5770},
  {-1941.5590,463.4388,35.1719},
  {-1316.8833,508.2705,18.2344},
  {1.0, 1.0, 1.0},
  {-1731.0020,791.0746,24.8906}
}

local ini = inicfg.load({
    main = {
        lvl_adm = "0",
        auto_az = false,
        pass_acc = "",
        pass_adm = "",
        is_clickwarp=false,
        is_gm=false,
        flood_ot=true,
        speed_airbrake = "0.3",
        control_afk=false,
        max_afk = "300",
        limitmax_afk="50",
        ischecker=true,
        delay_checker=10,
        posX = 30,
        posY = (sh / 2) - 100,
        maxAfk = 300,
        maxActive = 120,
        traicers = false,
        whcar = true,
        whdist = 50,
        getipwindow = false,
        statswindow = false,
        statsx = 2000,
        statsy = 60,
        onlinsession = true,
        fullonlineses = true,
        afkses = true,
        onlineday = true,
        fullonlineday = true,
        afkday = true,
        onlineweek = true,
        fullonlineweek = true,
        afkweek = true,
        rep=true,
        repses=true,
        repday=true,
        repweek=true,
        cdacceprform = 5,
        autoprefix=false,
        logcon = false,
        logreg = false,
        logconposx = 500,
        logconposy = 500,
        logconlimit = 5,
        limitreg = 5,
        logregposx = 500,
        logregposy = 500,
        skinauth=0,
        fracauth=0,
        intauth=0,
        autoquest=false,
        repchange=true,
        reputses=true,
        reputday=true,
        reputweek=true,
        spyadm = false,
        flipadm = false,
        slapadm = false,
        funcadmin = false,
        invauth = true,
        editchecker=true,
        infoot=true,
        antifreeze=true,
        bonhead=true,
        rwh=true,
        spyingreport = "Уважаемый игрок, начинаю работать по вашей жалобе.",
        helpreport = "Уважаемый игрок, сейчас попробую вам помочь.",
        givereport = "Уважаемый игрок, передал ваш репорт.",
        updateshown = true,
        fixtp = true,
        delayot=10,
        floodposx=400,
        floodposy=1200,
        cdacceptform=5,
        checkerlead=false,
        msktime = true,
        autob = true,
        limitzams = 0,
        limitmember = 0,
        amemberchecker = true,
        rechecker = true,
        afkcontrol=false,
        delay_fastnak=0,
        fastnakban=false,
        checkerfriends=false,
        friendsx = 1000,
        friendsy = 800,
        friendsoffset = 20,
        regoffset = 20,
        logoffset = 20,
        autobrec = true,
        infammo = true,
        reportadm = false,
        spawnset = false,
        airbreak = true,
        sizeofrles = 0,
        farchatlimit = 10,
        isfarchat = false,
        farchatx=800,
        farchaty=500,
        farchatoffset=20,
    },
    afk = {
      allow = 250,
      limit = 300,
    },
    font = {
    	name = 'Arial',
    	size = 9,
    	flag = 5,
    	offset = 19,
      align=1,
      farchatalign = 1,
    },
    level = {
    	[1] = true,
    	[2] = true,
    	[3] = true,
    	[4] = true,
    	[5] = true,
    	[6] = true,
      [7] = true,
      [8] = true
    },
    forms = {
        tag="// ",
        slap=false,
        flip=false,
        freeze=false,
        unfreeze=false,
        pm=false,
        spplayer=false,
        spcar=false,
        cure=false,
        weap=false,
        unjail=false,
        jail=false,
        unmute=false,
        kick=false,
        mute=false,
        adeldesc=false,
        apunish=false,
        plveh=false,
        bail=false,
        unwarn=false,
        ban=false,
        warn=false,
        accepttrade=false,
        givegun=false,
        trspawn=false,
        destroytrees=false,
        removetune=false,
        clearafklabel=false,
        setfamgz=false,
        delhname=false,
        delbname=false,
        warnoff=false,
        unban=false,
        afkkick=false,
        aparkcar=false,
        setgangzone=false,
        setbizmafia=false,
        cleardemorgane=false,
        sban=false,
        banip=false,
        unbanip=false,
        jailoff=false,
        muteoff=false,
        skick=false,
        setskin=false,
        uval=false,
        ao =false,
        unapunishoff=false,
        unjailoff=false,
        unmuteoff=false,
        unwarnoff=false,
        bizlock=false,
        bizopen=false,
        cinemaunrent=false,
        banipoff=false,
        banoff=false,
        agl=false,
        clearad=false,
        rmute=false,
        unrmute=false,
        autoslap=false,
        autoflip=false,
        autofreeze=false,
        autounfreeze=false,
        autopm=false,
        autospplayer=false,
        autospcar=false,
        autocure=false,
        autoweap=false,
        autounjail=false,
        autojail=false,
        autounmute=false,
        autokick=false,
        automute=false,
        autoadeldesc=false,
        autoapunish=false,
        autoplveh=false,
        autobail=false,
        autounwarn=false,
        autoban=false,
        autowarn=false,
        autoaccepttrade=false,
        autogivegun=false,
        autotrspawn=false,
        autodestroytrees=false,
        autoremovetune=false,
        autoclearafklabel=false,
        autosetfamgz=false,
        autodelhname=false,
        autodelbname=false,
        autowarnoff=false,
        autounban=false,
        autoafkkick=false,
        autoaparkcar=false,
        autosetgangzone=false,
        autosetbizmafia=false,
        autocleardemorgane=false,
        autosban=false,
        autobanip=false,
        autounbanip=false,
        autojailoff=false,
        automuteoff=false,
        autoskick=false,
        autosetskin=false,
        autouval=false,
        autoao=false,
        autounapunishoff=false,
        autounjailoff=false,
        autounmuteoff=false,
        autounwarnoff=false,
        autobizlock=false,
        autobizopen=false,
        autocinemaunrent=false,
        autobanipoff=false,
        autobanoff=false,
        autoagl=false,
        autoclearad=false,
        autormute=false,
        autounrmute=false,
    },
    binds = {
        reoff="F2",
        last_rep="F2",
        bind_ot="F2",
        acceptform = "F2",
        bind_floodot = "F2",
        noviolations = "F2",
        slapmyself = "F2",
        jpmyself = "F2",
        wh = "F2",
        fastnak = "F2",
        whcar = "F2",
    },
    style = {
      color = 0xFF3333AA,
      text = 0xFFFFFFFF,
      logcon_d = 0xFF0000FF,
      logcon_def = 0xFFFFFFFF,
      logreg = 0xFFFFFFFF,
      farchat = 0xFFFFFFFF,
      report = 4282868735,
      adminchat = 2852179097,
      rounding = 15,
      framerounding = 3,
    },
    show = {
    	id = true,
    	level = false,
    	afk = true,
    	recon = true,
    	reputate = false,
    	active = true,
    	selfMark = false,
    },
    recon = {
      x = 1600,
      y = 650,
      funcx = 600,
      funcy = 900,
    },
    onDay = {
      today = os.date("%a"),
      online = 0,
      afk = 0,
      full = 0,
    },
    onWeek = {
      week = 1,
      online = 0,
      afk = 0,
      full = 0,
    },
    myWeekOnline = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
    },
    onDayReport = {
      today = os.date("%a"),
      report = 0,
    },
    onWeekReport = {
      week = 1,
      report = 0,
    },
    myWeekReport = {
      [0] = 0,
      [1] = 0,
      [2] = 0,
      [3] = 0,
      [4] = 0,
      [5] = 0,
      [6] = 0,
    },
    onDayReput = {
      today = os.date("%a"),
      reput = 0,
    },
    onWeekReput = {
      week = 1,
      reput = 0,
    },
    myWeekReput = {
      [0] = 0,
      [1] = 0,
      [2] = 0,
      [3] = 0,
      [4] = 0,
      [5] = 0,
      [6] = 0,
    },
    setcheckerfrac = {
      nick = true,
      zams = true,
      member = true,
      memberafk = true,
    },
    checkerfrac = {
      delay = 2500,
      posx = 1000,
      posy = 1000,
      lspd = true, 
      rcsd = true,
      fbi = true,
      sfpd = true,
      bls = true,
      pravo = true,
      tsr = true,
      bsf = true,
      ash = true,
      tvls = true,
      grove = true,
      vagos = true,
      ballas = true,
      aztec = true,
      rifa = true,
      rm = true,
      yakuza = true,
      lcn = true,
      warlock = true,
      armyls = true,
      cb = true,
      blv = true,
      lvpd = true,
      tvlv = true,
      nv = true,
      tvsf = true,
      armysf = true,
      insur = true,
    },
    color = {
    	[1] = 0xFFBBBD2E,
    	[2] = 0xFFBD920B,
    	[3] = 0xFF3EA3DF,
    	[4] = 0xFF1DB052,
    	[5] = 0xFF7900FF,
    	[6] = 0xFF24AD0A,
      [7] = 0xFF24AD01,
      [8] = 0xFF2F0000,
    	['afk'] 		= 0xFF95FF00,
    	['recon'] 		= 0xFF00C3FF,
    	['reputate'] 	= 0xFFFF8D00,
    	['active'] 		= 0xFF44E300,
    	['note']		= 0xFFAEAEAE,
    },
    notes = {},
    kurators = {},
    zga = {},
    ga = {},
    customcolor = {},
    customcolor_status = {},
    cbName = {},
    cbContent = {},
    cbToggle = {},
    friends = {},
    spcoord = {},
    special = {
    	'Conor',
    	'Sam_Mason'
    }
}, dirIni)
inicfg.save(ini, dirIni)
inicfg.load(ini, dirIni)

local nowTime = os.date("%H:%M:%S", os.time())

statuswaitleader = os.time()
local bindID = 0
notesAdmin = new.char[256]()

mc = imgui.ColorConvertU32ToFloat4(ini.style.color)
tc = imgui.ColorConvertU32ToFloat4(ini.style.text)
cd = imgui.ColorConvertU32ToFloat4(ini.style.logcon_d)
rc = imgui.ColorConvertU32ToFloat4(ini.style.logreg)
ac = imgui.ColorConvertU32ToFloat4(ini.style.adminchat)
report = imgui.ColorConvertU32ToFloat4(ini.style.report)
farchat_clr = imgui.ColorConvertU32ToFloat4(ini.style.farchat)
disc = imgui.ColorConvertU32ToFloat4(ini.style.logcon_def)

local test = new.bool()

rdata = {}
errors_fastnak = {}
spawncord = {
	playerX = 0,
	playerZ = 10,
	playerY = 0
}
bonhead = 0

mode = true
countsettings = 0
for k, v in pairs(ini.setcheckerfrac) do
  if v then
    countsettings = countsettings + 1
  end
end
counttoggles = -8

local sesOnline = 0
local sesAfk = 0
local sesFull = 0
local sesreport = 0
local sesreput = 0
local dayFull = ini.onDay.full
local weekFull = ini.onWeek.full
repNick = "None"
repId = -1
isfrac = false
bindInputs = {}
activeleader = {}
for k,v in pairs(ini.cbContent) do
  bindInputs[#bindInputs+1] = new.char[256](""..v)
end
bindToggle = {}
for k,v in pairs(ini.cbToggle) do
  bindToggle[#bindToggle+1] = new.bool(ini.cbToggle[k])
end
bindName = {}
for k,v in pairs(ini.cbName) do
  bindName[#bindName+1] = new.char[256](""..v)
end
fracschecker = {
  ['lspd'] = {
    frac = "ЛСПД",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['rcsd'] = {
    frac = "РКШД",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['lvpd'] = {
    frac = "ЛВПД",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['fbi'] = {
    frac = "ФБР",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['sfpd'] = {
    frac = "СФПД",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['bls'] = {
    frac = "БЛС",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['pravo'] = {
    frac = "Пра-во",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['tsr'] = {
    frac = "ТСР",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['grove'] = {
    frac = "Грув",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['bsf'] = {
    frac = "БСФ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['ash'] = {
    frac = "АШ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['tvls'] = {
    frac = "СМИ ЛС",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['vagos'] = {
    frac = "Вагос",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['ballas'] = {
    frac = "Баллас",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['aztec'] = {
    frac = "Ацтек",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['rifa'] = {
    frac = "Рифа",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['rm'] = {
    frac = "РМ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['yakuza'] = {
    frac = "Якудза",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['lcn'] = {
    frac = "ЛКН",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['warlock'] = {
    frac = "Варлок",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['armyls'] = {
    frac = "Армия ЛС",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['cb'] = {
    frac = "ЦБ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['blv'] = {
    frac = "БЛВ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['tvlv'] = {
    frac = "СМИ ЛВ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['nv'] = {
    frac = "НВ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['tvsf'] = {
    frac = "СМИ СФ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['armysf'] = {
    frac = "Армия СФ",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
  ['insur'] = {
    frac = "СтК",
    nick = "none",
    id = -1,
    zams = -1,
    member = -1,
    memberafk = -1,
  },
}
fracscheckerName = {
  "lspd",
  "rcsd",
  "fbi",
  "sfpd",
  "bls",
  "pravo",
  "tsr",
  "bsf",
  "ash",
  "tvls",
  "grove",
  "vagos",
  "ballas",
  "aztec",
  "rifa",
  "rm",
  "yakuza",
  "lcn",
  "warlock",
  "armyls",
  "cb",
  "blv",
  "lvpd",
  "tvlv",
  "nv",
  "tvsf",
  "armysf",
  "insur"
}

fracscheckerIni = {
  ["lspd"]           = new.bool(ini.checkerfrac.lspd), 
  ["rcsd"]           = new.bool(ini.checkerfrac.rcsd),
  ["fbi"]            = new.bool(ini.checkerfrac.fbi),
  ["sfpd"]           = new.bool(ini.checkerfrac.sfpd),
  ["bls"]            = new.bool(ini.checkerfrac.bls),
  ["pravo"]          = new.bool(ini.checkerfrac.pravo),
  ["tsr"]            = new.bool(ini.checkerfrac.tsr),
  ["bsf"]            = new.bool(ini.checkerfrac.bsf),
  ["ash"]            = new.bool(ini.checkerfrac.ash),
  ["tvls"]           = new.bool(ini.checkerfrac.tvls),
  ["grove"]          = new.bool(ini.checkerfrac.grove),
  ["vagos"]          = new.bool(ini.checkerfrac.vagos),
  ["ballas"]         = new.bool(ini.checkerfrac.ballas),
  ["aztec"]          = new.bool(ini.checkerfrac.aztec),
  ["rifa"]           = new.bool(ini.checkerfrac.rifa),
  ["rm"]             = new.bool(ini.checkerfrac.rm),
  ["yakuza"]         = new.bool(ini.checkerfrac.yakuza),
  ["lcn"]            = new.bool(ini.checkerfrac.lcn),
  ["warlock"]        = new.bool(ini.checkerfrac.warlock),
  ["armyls"]         = new.bool(ini.checkerfrac.armyls),
  ["cb"]             = new.bool(ini.checkerfrac.cb),
  ["blv"]            = new.bool(ini.checkerfrac.blv),
  ["lvpd"]           = new.bool(ini.checkerfrac.lvpd),
  ["tvlv"]           = new.bool(ini.checkerfrac.tvlv),
  ["nv"]             = new.bool(ini.checkerfrac.nv),
  ["tvsf"]           = new.bool(ini.checkerfrac.tvsf),
  ["armysf"]         = new.bool(ini.checkerfrac.armysf),
  ["insur"]          = new.bool(ini.checkerfrac.insur),
}

--lspd, rcsd, fbi, sfpd, bls, pravo, tsr, bsf, ash, tvls, grove, vagos, ballas, aztec, rifa, rm, yakuza, lcn, warlock, armyls, cb, blv, lvpd, tvlv, nv, tvsf, armysf, insur
local notf_sX, notf_sY				= convertGameScreenCoordsToWindowScreenCoords(605, 438)
local notify						= {
	msg = {},
	pos = {x = notf_sX - 200, y = notf_sY - 70}
}
local alpha							= new.float[1](0)
local alphaAnimTime					= 0.3
local quitReason = { 
	"Crash",
	"/q",
	"Server Kicked"
}

ffi.cdef[[
struct stKillEntry
{
	char					szKiller[25];
	char					szVictim[25];
	uint32_t				clKillerColor; // D3DCOLOR
	uint32_t				clVictimColor; // D3DCOLOR
	uint8_t					byteType;
} __attribute__ ((packed));

struct stKillInfo
{
	int						iEnabled;
	struct stKillEntry		killEntry[5];
	int 					iLongestNickLength;
  	int 					iOffsetX;
  	int 					iOffsetY;
	void			    	*pD3DFont; // ID3DXFont
	void		    		*pWeaponFont1; // ID3DXFont
	void		   	    	*pWeaponFont2; // ID3DXFont
	void					*pSprite;
	void					*pD3DDevice;
	int 					iAuxFontInited;
    void 		    		*pAuxFont1; // ID3DXFont
    void 			    	*pAuxFont2; // ID3DXFont
} __attribute__ ((packed));
]]

local clock = os.clock

formsIni = {
  ['slap']            = new.bool(ini.forms.slap),
  ['flip']            = new.bool(ini.forms.flip),
  ['freeze']          = new.bool(ini.forms.freeze),
  ['unfreeze']        = new.bool(ini.forms.unfreeze),
  ['pm']              = new.bool(ini.forms.pm), 
  ['spplayer']        = new.bool(ini.forms.spplayer),
  ['spcar']           = new.bool(ini.forms.spcar),
  ['cure']            = new.bool(ini.forms.cure),
  ['weap']            = new.bool(ini.forms.weap),
  ['unjail']          = new.bool(ini.forms.unjail),
  ['jail']            = new.bool(ini.forms.jail),
  ['unmute']          = new.bool(ini.forms.unmute),
  ['rmute']           = new.bool(ini.forms.rmute),
  ['unrmute']         = new.bool(ini.forms.unrmute),
  ['kick']            = new.bool(ini.forms.kick),
  ['mute']            = new.bool(ini.forms.mute),
  ['adeldesc']        = new.bool(ini.forms.adeldesc),
  ['apunish']         = new.bool(ini.forms.apunish),
  ['plveh']           = new.bool(ini.forms.plveh),
  ['bail']            = new.bool(ini.forms.bail),
  ['unwarn']          = new.bool(ini.forms.unwarn),
  ['ban']             = new.bool(ini.forms.ban),
  ['warn']            = new.bool(ini.forms.warn),
  ['accepttrade']     = new.bool(ini.forms.accepttrade),
  ['givegun']         = new.bool(ini.forms.givegun),
  ['trspawn']         = new.bool(ini.forms.trspawn),
  ['destroytrees']    = new.bool(ini.forms.destroytrees),
  ['removetune']      = new.bool(ini.forms.removetune),
  ['clearafklabel']   = new.bool(ini.forms.clearafklabel),
  ['setfamgz']        = new.bool(ini.forms.setfamgz),
  ['delhname']        = new.bool(ini.forms.delhname),
  ['delbname']        = new.bool(ini.forms.delbname),
  ['warnoff']         = new.bool(ini.forms.warnoff),
  ['unban']           = new.bool(ini.forms.unban),
  ['afkkick']         = new.bool(ini.forms.afkkick),
  ['aparkcar']        = new.bool(ini.forms.aparkcar),
  ['setgangzone']     = new.bool(ini.forms.setgangzone),
  ['setbizmafia']     = new.bool(ini.forms.setbizmafia),
  ['cleardemorgane']  = new.bool(ini.forms.cleardemorgane),
  ['sban']            = new.bool(ini.forms.sban),
  ['banip']           = new.bool(ini.forms.banip),
  ['unbanip']         = new.bool(ini.forms.unbanip),
  ['jailoff']         = new.bool(ini.forms.jailoff),
  ['muteoff']         = new.bool(ini.forms.muteoff),
  ['skick']           = new.bool(ini.forms.skick),
  ['setskin']         = new.bool(ini.forms.setskin),
  ['uval']            = new.bool(ini.forms.uval),
  ['ao']              = new.bool(ini.forms.ao),
  ['unapunishoff']    = new.bool(ini.forms.unapunishoff),
  ['unjailoff']       = new.bool(ini.forms.unjailoff),
  ['unmuteoff']       = new.bool(ini.forms.unmuteoff),
  ['unwarnoff']       = new.bool(ini.forms.unwarnoff),
  ['bizlock']         = new.bool(ini.forms.bizlock),
  ['bizopen']         = new.bool(ini.forms.bizopen),
  ['cinemaunrent']    = new.bool(ini.forms.cinemaunrent),
  ['banipoff']        = new.bool(ini.forms.banipoff),
  ['banoff']          = new.bool(ini.forms.banoff),
  ['agl']             = new.bool(ini.forms.agl),
  ['clearad']         = new.bool(ini.forms.clearad)
}

AutoformsIni = {
  ['slap']            = new.bool(ini.forms.autoslap),
  ['flip']            = new.bool(ini.forms.autoflip),
  ['freeze']          = new.bool(ini.forms.autofreeze),
  ['unfreeze']        = new.bool(ini.forms.autounfreeze),
  ['pm']              = new.bool(ini.forms.autopm), 
  ['spplayer']        = new.bool(ini.forms.autospplayer),
  ['spcar']           = new.bool(ini.forms.autospcar),
  ['cure']            = new.bool(ini.forms.autocure),
  ['weap']            = new.bool(ini.forms.autoweap),
  ['unjail']          = new.bool(ini.forms.autounjail),
  ['jail']            = new.bool(ini.forms.autojail),
  ['unmute']          = new.bool(ini.forms.autounmute),
  ['rmute']           = new.bool(ini.forms.autormute),
  ['unrmute']         = new.bool(ini.forms.autounrmute),
  ['kick']            = new.bool(ini.forms.autokick),
  ['mute']            = new.bool(ini.forms.automute),
  ['adeldesc']        = new.bool(ini.forms.autoadeldesc),
  ['apunish']         = new.bool(ini.forms.autoapunish),
  ['plveh']           = new.bool(ini.forms.autoplveh),
  ['bail']            = new.bool(ini.forms.autobail),
  ['unwarn']          = new.bool(ini.forms.autounwarn),
  ['ban']             = new.bool(ini.forms.autoban),
  ['warn']            = new.bool(ini.forms.autowarn),
  ['accepttrade']     = new.bool(ini.forms.autoaccepttrade),
  ['givegun']         = new.bool(ini.forms.autogivegun),
  ['trspawn']         = new.bool(ini.forms.autotrspawn),
  ['destroytrees']    = new.bool(ini.forms.autodestroytrees),
  ['removetune']      = new.bool(ini.forms.autoremovetune),
  ['clearafklabel']   = new.bool(ini.forms.autoclearafklabel),
  ['setfamgz']        = new.bool(ini.forms.autosetfamgz),
  ['delhname']        = new.bool(ini.forms.autodelhname),
  ['delbname']        = new.bool(ini.forms.autodelbname),
  ['warnoff']         = new.bool(ini.forms.autowarnoff),
  ['unban']           = new.bool(ini.forms.autounban),
  ['afkkick']         = new.bool(ini.forms.autoafkkick),
  ['aparkcar']        = new.bool(ini.forms.autoaparkcar),
  ['setgangzone']     = new.bool(ini.forms.autosetgangzone),
  ['setbizmafia']     = new.bool(ini.forms.autosetbizmafia),
  ['cleardemorgane']  = new.bool(ini.forms.autocleardemorgane),
  ['sban']            = new.bool(ini.forms.autosban),
  ['banip']           = new.bool(ini.forms.autobanip),
  ['unbanip']         = new.bool(ini.forms.autounbanip),
  ['jailoff']         = new.bool(ini.forms.autojailoff),
  ['muteoff']         = new.bool(ini.forms.automuteoff),
  ['skick']           = new.bool(ini.forms.autoskick),
  ['setskin']         = new.bool(ini.forms.autosetskin),
  ['uval']            = new.bool(ini.forms.autouval),
  ['ao']              = new.bool(ini.forms.autoao),
  ['unapunishoff']    = new.bool(ini.forms.autounapunishoff),
  ['unjailoff']       = new.bool(ini.forms.autounjailoff),
  ['unmuteoff']       = new.bool(ini.forms.autounmuteoff),
  ['unwarnoff']       = new.bool(ini.forms.autounwarnoff),
  ['bizlock']         = new.bool(ini.forms.autobizlock),
  ['bizopen']         = new.bool(ini.forms.autobizopen),
  ['cinemaunrent']    = new.bool(ini.forms.autocinemaunrent),
  ['banipoff']        = new.bool(ini.forms.autobanipoff),
  ['banoff']          = new.bool(ini.forms.autobanoff),
  ['agl']             = new.bool(ini.forms.autoagl),
  ['clearad']         = new.bool(ini.forms.autoclearad)
}

forms = {
  "slap",
  "flip",
  "freeze",
  "unfreeze",
  "pm",
  "spplayer",
  "spcar",
  "cure",
  "weap",
  "unjail",
  "jail",
  "unmute",
  "kick",
  "mute",
  "rmute",
  "unrmute",
  "adeldesc",
  "apunish",
  "plveh",
  "bail",
  "unwarn",
  "ban",
  "warn",
  "clearad",
  "accepttrade",
  "givegun",
  "trspawn",
  "destroytrees",
  "removetune",
  "clearafklabel",
  "setfamgz",
  "delhname",
  "delbname",
  "warnoff",
  "unban",
  "afkkick",
  "aparkcar",
  "setgangzone",
  "setbizmafia",
  "cleardemorgane",
  "sban",
  "banip",
  "unbanip",
  "jailoff",
  "muteoff",
  "skick",
  "setskin",
  "uval",
  "ao",
  "unapunishoff",
  "unjailoff",
  "unmuteoff",
  "unwarnoff",
  "bizlock",
  "bizopen",
  "cinemaunrent",
  "banipoff",
  "agl",
  "banoff",
}

formsFunc = {
  "slap",
  "flip",
  "freeze",
  "unfreeze",
  "pm",
  "spplayer",
  "spcar",
  "cure",
  "weap",
  "unjail",
  "jail",
  "unmute",
  "kick",
  "mute",
  "rmute",
  "unrmute",
  "adeldesc",
  "apunish",
  "plveh",
  "bail",
  "unwarn",
  "ban",
  "warn",
  "accepttrade",
  "givegun",
  "trspawn",
  "destroytrees",
  "removetune",
  "clearafklabel",
  "setfamgz",
  "delhname",
  "delbname",
  "warnoff",
  "unban",
  "afkkick",
  "aparkcar",
  "setgangzone",
  "setbizmafia",
  "cleardemorgane",
  "sban",
  "banip",
  "unbanip",
  "jailoff",
  "muteoff",
  "skick",
  "setskin",
  "uval",
  "ao",
  "unapunishoff",
  "unjailoff",
  "unmuteoff",
  "unwarnoff",
  "bizlock",
  "bizopen",
  "cinemaunrent",
  "banipoff",
  "agl",
  "clearad",
}

autoforms = {
  "autoslap",
  "autoflip",
  "autofreeze",
  "autounfreeze",
  "autopm",
  "autospplayer",
  "autospcar",
  "autocure",
  "autoweap",
  "autounjail",
  "autojail",
  "autounmute",
  "autokick",
  "automute",
  "autormute",
  "autounrmute",
  "autoadeldesc",
  "autoapunish",
  "autoplveh",
  "autobail",
  "autounwarn",
  "autoban",
  "autowarn",
  "autoaccepttrade",
  "autogivegun",
  "autotrspawn",
  "autodestroytrees",
  "autoremovetune",
  "autoclearafklabel",
  "autosetfamgz",
  "autodelhname",
  "autodelbname",
  "autowarnoff",
  "autounban",
  "autoafkkick",
  "autoaparkcar",
  "autosetgangzone",
  "autosetbizmafia",
  "autocleardemorgane",
  "autosban",
  "autobanip",
  "autounbanip",
  "autojailoff",
  "automuteoff",
  "autoskick",
  "autosetskin",
  "autouval",
  "autoao ",
  "autounapunishoff",
  "autounjailoff",
  "autounmuteoff",
  "autounwarnoff",
  "autobizlock",
  "autobizopen",
  "autocinemaunrent",
  "autobanipoff",
  "autobanoff",
  "autoagl",
  "autoclearad",
}


function setPermission()
  if ini.main.lvl_adm == 1 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = false
    formsIni['weap'][0]            = false
    formsIni['unjail'][0]          = false
    formsIni['jail'][0]            = false
    formsIni['unmute'][0]          = false
    formsIni['rmute'][0]           = false
    formsIni['unrmute'][0]         = false
    formsIni['kick'][0]            = false
    formsIni['mute'][0]            = false
    formsIni['adeldesc'][0]        = false
    formsIni['apunish'][0]         = false
    formsIni['plveh'][0]           = false
    formsIni['bail'][0]            = false
    formsIni['clearad'][0]         = false
    formsIni['unwarn'][0]          = false
    formsIni['ban'][0]             = false
    formsIni['warn'][0]            = false
    formsIni['accepttrade'][0]     = false
    formsIni['givegun'][0]         = false
    formsIni['trspawn'][0]         = false
    formsIni['destroytrees'][0]    = false
    formsIni['removetune'][0]      = false
    formsIni['clearafklabel'][0]   = false
    formsIni['setfamgz'][0]        = false
    formsIni['delhname'][0]        = false
    formsIni['delbname'][0]        = false
    formsIni['warnoff'][0]         = false
    formsIni['unban'][0]           = false
    formsIni['afkkick'][0]         = false
    formsIni['aparkcar'][0]        = false
    formsIni['setgangzone'][0]     = false
    formsIni['setbizmafia'][0]     = false
    formsIni['cleardemorgane'][0]  = false
    formsIni['sban'][0]            = false
    formsIni['banip'][0]           = false
    formsIni['unbanip'][0]         = false
    formsIni['jailoff'][0]         = false
    formsIni['muteoff'][0]         = false
    formsIni['skick'][0]           = false
    formsIni['setskin'][0]         = false
    formsIni['uval'][0]            = false
    formsIni['ao'][0]              = false
    formsIni['unapunishoff'][0]    = false
    formsIni['unjailoff'][0]       = false
    formsIni['unmuteoff'][0]       = false
    formsIni['unwarnoff'][0]       = false
    formsIni['bizlock'][0]         = false
    formsIni['bizopen'][0]         = false
    formsIni['cinemaunrent'][0]    = false
    formsIni['banipoff'][0]        = false
    formsIni['banoff'][0]          = false
    formsIni['agl'][0]             = false
    
    
  elseif ini.main.lvl_adm == 2 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = true
    formsIni['weap'][0]            = true
    formsIni['unjail'][0]          = true
    formsIni['jail'][0]            = true
    formsIni['unmute'][0]          = true
    formsIni['kick'][0]            = true
    formsIni['mute'][0]            = true
    formsIni['rmute'][0]           = true
    formsIni['unrmute'][0]         = true
    formsIni['adeldesc'][0]        = true
    formsIni['apunish'][0]         = false
    formsIni['plveh'][0]           = false
    formsIni['bail'][0]            = false
    formsIni['clearad'][0]         = false
    formsIni['unwarn'][0]          = false
    formsIni['ban'][0]             = false
    formsIni['warn'][0]            = false
    formsIni['accepttrade'][0]     = false
    formsIni['givegun'][0]         = false
    formsIni['trspawn'][0]         = false
    formsIni['destroytrees'][0]    = false
    formsIni['removetune'][0]      = false
    formsIni['clearafklabel'][0]   = false
    formsIni['setfamgz'][0]        = false
    formsIni['delhname'][0]        = false
    formsIni['delbname'][0]        = false
    formsIni['warnoff'][0]         = false
    formsIni['unban'][0]           = false
    formsIni['afkkick'][0]         = false
    formsIni['aparkcar'][0]        = false
    formsIni['setgangzone'][0]     = false
    formsIni['setbizmafia'][0]     = false
    formsIni['cleardemorgane'][0]  = false
    formsIni['sban'][0]            = false
    formsIni['banip'][0]           = false
    formsIni['unbanip'][0]         = false
    formsIni['jailoff'][0]         = false
    formsIni['muteoff'][0]         = false
    formsIni['skick'][0]           = false
    formsIni['setskin'][0]         = false
    formsIni['uval'][0]            = false
    formsIni['ao'][0]              = false
    formsIni['unapunishoff'][0]    = false
    formsIni['unjailoff'][0]       = false
    formsIni['unmuteoff'][0]       = false
    formsIni['unwarnoff'][0]       = false
    formsIni['bizlock'][0]         = false
    formsIni['bizopen'][0]         = false
    formsIni['cinemaunrent'][0]    = false
    formsIni['banipoff'][0]        = false
    formsIni['banoff'][0]          = false
    formsIni['agl'][0]             = false
  elseif ini.main.lvl_adm == 3 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = true
    formsIni['weap'][0]            = true
    formsIni['unjail'][0]          = true
    formsIni['jail'][0]            = true
    formsIni['unmute'][0]          = true
    formsIni['kick'][0]            = true
    formsIni['mute'][0]            = true
    formsIni['rmute'][0]           = true
    formsIni['unrmute'][0]         = true
    formsIni['adeldesc'][0]        = true
    formsIni['apunish'][0]         = true
    formsIni['plveh'][0]           = true
    formsIni['bail'][0]            = true
    formsIni['clearad'][0]         = true
    formsIni['unwarn'][0]          = true
    formsIni['ban'][0]             = true
    formsIni['warn'][0]            = true
    formsIni['accepttrade'][0]     = true
    formsIni['givegun'][0]         = true
    formsIni['trspawn'][0]         = true
    formsIni['destroytrees'][0]    = true
    formsIni['removetune'][0]      = true
    formsIni['clearafklabel'][0]   = true
    formsIni['setfamgz'][0]        = false
    formsIni['delhname'][0]        = false
    formsIni['delbname'][0]        = false
    formsIni['warnoff'][0]         = false
    formsIni['unban'][0]           = false
    formsIni['afkkick'][0]         = false
    formsIni['aparkcar'][0]        = false
    formsIni['setgangzone'][0]     = false
    formsIni['setbizmafia'][0]     = false
    formsIni['cleardemorgane'][0]  = false
    formsIni['sban'][0]            = false
    formsIni['banip'][0]           = false
    formsIni['unbanip'][0]         = false
    formsIni['jailoff'][0]         = false
    formsIni['muteoff'][0]         = false
    formsIni['skick'][0]           = false
    formsIni['setskin'][0]         = false
    formsIni['uval'][0]            = false
    formsIni['ao'][0]              = false
    formsIni['unapunishoff'][0]    = false
    formsIni['unjailoff'][0]       = false
    formsIni['unmuteoff'][0]       = false
    formsIni['unwarnoff'][0]       = false
    formsIni['bizlock'][0]         = false
    formsIni['bizopen'][0]         = false
    formsIni['cinemaunrent'][0]    = false
    formsIni['banipoff'][0]        = false
    formsIni['banoff'][0]          = false
    formsIni['agl'][0]             = false
  elseif ini.main.lvl_adm == 4 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = true
    formsIni['weap'][0]            = true
    formsIni['unjail'][0]          = true
    formsIni['jail'][0]            = true
    formsIni['unmute'][0]          = true
    formsIni['rmute'][0]           = true
    formsIni['kick'][0]            = true
    formsIni['mute'][0]            = true
    formsIni['unrmute'][0]         = true
    formsIni['adeldesc'][0]        = true
    formsIni['apunish'][0]         = true
    formsIni['plveh'][0]           = true
    formsIni['bail'][0]            = true
    formsIni['clearad'][0]         = true
    formsIni['unwarn'][0]          = true
    formsIni['ban'][0]             = true
    formsIni['warn'][0]            = true
    formsIni['accepttrade'][0]     = true
    formsIni['givegun'][0]         = true
    formsIni['trspawn'][0]         = true
    formsIni['destroytrees'][0]    = true
    formsIni['removetune'][0]      = true
    formsIni['clearafklabel'][0]   = true
    formsIni['setfamgz'][0]        = true
    formsIni['delhname'][0]        = true
    formsIni['delbname'][0]        = true
    formsIni['warnoff'][0]         = true
    formsIni['unban'][0]           = true
    formsIni['afkkick'][0]         = true
    formsIni['aparkcar'][0]        = true
    formsIni['setgangzone'][0]     = true
    formsIni['setbizmafia'][0]     = true
    formsIni['cleardemorgane'][0]  = true
    formsIni['sban'][0]            = true
    formsIni['banip'][0]           = true
    formsIni['unbanip'][0]         = true
    formsIni['jailoff'][0]         = true
    formsIni['muteoff'][0]         = true
    formsIni['skick'][0]           = true
    formsIni['setskin'][0]         = true
    formsIni['uval'][0]            = true
    formsIni['ao'][0]              = true
    formsIni['unapunishoff'][0]    = true
    formsIni['unjailoff'][0]       = true
    formsIni['unmuteoff'][0]       = true
    formsIni['unwarnoff'][0]       = true
    formsIni['bizlock'][0]         = true
    formsIni['bizopen'][0]         = true
    formsIni['cinemaunrent'][0]    = true
    formsIni['banipoff'][0]        = false
    formsIni['banoff'][0]          = false
    formsIni['agl'][0]             = false
  elseif ini.main.lvl_adm >= 5 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = true
    formsIni['weap'][0]            = true
    formsIni['unjail'][0]          = true
    formsIni['jail'][0]            = true
    formsIni['unmute'][0]          = true
    formsIni['kick'][0]            = true
    formsIni['mute'][0]            = true
    formsIni['rmute'][0]           = true
    formsIni['unrmute'][0]         = true
    formsIni['adeldesc'][0]        = true
    formsIni['apunish'][0]         = true
    formsIni['plveh'][0]           = true
    formsIni['bail'][0]            = true
    formsIni['clearad'][0]         = true
    formsIni['unwarn'][0]          = true
    formsIni['ban'][0]             = true
    formsIni['warn'][0]            = true
    formsIni['accepttrade'][0]     = true
    formsIni['givegun'][0]         = true
    formsIni['trspawn'][0]         = true
    formsIni['destroytrees'][0]    = true
    formsIni['removetune'][0]      = true
    formsIni['clearafklabel'][0]   = true
    formsIni['setfamgz'][0]        = true
    formsIni['delhname'][0]        = true
    formsIni['delbname'][0]        = true
    formsIni['warnoff'][0]         = true
    formsIni['unban'][0]           = true
    formsIni['afkkick'][0]         = true
    formsIni['aparkcar'][0]        = true
    formsIni['setgangzone'][0]     = true
    formsIni['setbizmafia'][0]     = true
    formsIni['cleardemorgane'][0]  = true
    formsIni['sban'][0]            = true
    formsIni['banip'][0]           = true
    formsIni['unbanip'][0]         = true
    formsIni['jailoff'][0]         = true
    formsIni['muteoff'][0]         = true
    formsIni['skick'][0]           = true
    formsIni['setskin'][0]         = true
    formsIni['uval'][0]            = true
    formsIni['ao'][0]              = true
    formsIni['unapunishoff'][0]    = true
    formsIni['unjailoff'][0]       = true
    formsIni['unmuteoff'][0]       = true
    formsIni['unwarnoff'][0]       = true
    formsIni['bizlock'][0]         = true
    formsIni['bizopen'][0]         = true
    formsIni['cinemaunrent'][0]    = true
    formsIni['banipoff'][0]        = true
    formsIni['banoff'][0]          = true
    formsIni['agl'][0]             = true
  end
end

-----------------------------------------------------
      if not doesDirectoryExist("moonloader\\Lulu Tools\\rules") then
        createDirectory("moonloader\\Lulu Tools\\rules")
      end
      inputs = {
        ['report_window_answer'] = new.char[170](""),
        ['finding_question'] = new.char[256](""),
        ['finding_cmd'] = new.char[256](""),
        ['finding_gps'] = new.char[256](""),
        ['delay_checker'] = new.int(ini.main.delay_checker),
			  ['maxAfk'] = new.int(ini.main.maxAfk),
        ['maxActive'] = new.int(ini.main.maxActive),
        ['bufAdd5'] = new.char[256](""),
        ['bufAdd6'] = new.char[256](""),
        ['bufAdd7'] = new.char[256](""),
        ['bufAdd8'] = new.char[256](""),
        ['cdacceptform'] = new.int(ini.main.cdacceptform),
        ['rounding'] = new.int(ini.style.rounding),
        ['logconlimit'] = new.int(ini.main.logconlimit),
        ['limitreg'] = new.int(ini.main.limitreg),
        ['skinauth'] = new.int(ini.main.skinauth),
        ['fracauth'] = new.int(ini.main.fracauth),
        ['intauth'] = new.int(ini.main.intauth),
        ['fr'] = new.int(ini.style.framerounding),
        ['spyingreport'] = new.char[256](""..u8(ini.main.spyingreport)),
        ['helpreport'] = new.char[256](""..u8(ini.main.helpreport)),
        ['givereport'] = new.char[256](""..u8(ini.main.givereport)),
        ['delayot'] = new.int(ini.main.delayot),
        ['limitmember'] = new.int(ini.main.limitmember),
        ['limitzams'] = new.int(ini.main.limitzams),
        ['afklimit'] = new.int(ini.afk.limit),
        ['afkallow'] = new.int(ini.afk.allow),
        ['fastnak'] = new.char[10000](""),
        ['delay_fastnak'] = new.int(ini.main.delay_fastnak),
        ['checkerfriend'] = new.char[256](""),
        ['friendsoffset'] = new.int(ini.main.friendsoffset),
        ['regoffset'] = new.int(ini.main.regoffset),
        ['logoffset'] = new.int(ini.main.logoffset),
        ['farchatoffset'] = new.int(ini.main.farchatoffset),
        ['farchatlimit'] = new.int(ini.main.farchatlimit)
      }

        ActiveClockMenu = {
          v = {ini.binds.reoff}
        }
        lastrep = {
          v = {ini.binds.last_rep}
        }
        bindot = {
          v = {ini.binds.bind_ot}
        }
        acceptform = {
          v = {ini.binds.acceptform}
        }
        bindotflood = {
          v = {ini.binds.bind_floodot}
        }
        noviolations = {
          v = {ini.binds.noviolations}
        }
        slapmyself = {
          v = {ini.binds.slapmyself}
        }
        jpmyself = {
          v = {ini.binds.jpmyself}
        }
        whhotkey = {
          v = {ini.binds.wh}
        }

        fastnak = {
          v = {ini.binds.fastnak}
        }

        whcarhotkey = {
          v = {ini.binds.whcar}
        }

      sliders = {
        ['whdistance'] = new.int(ini.main.whdist)
      }

      toggles = {
        ['floodot'] = new.bool(ini.main.flood_ot),
        ['autoaz'] = new.bool(ini.main.auto_az),
        ['isgm'] = new.bool(ini.main.is_gm),
        ['isclickwarp'] = new.bool(ini.main.is_clickwarp),
        ['checkeradm'] = new.bool(ini.main.ischecker),
        ['customcolorstatus'] = new.bool(),
        ['traicers'] = new.bool(ini.main.traicers),
        ['whcar'] = new.bool(ini.main.whcar),
        ['getipwindow'] = new.bool(ini.main.getipwindow),
        ['statswindow'] = new.bool(ini.main.statswindow),
        ['onlinsession'] = new.bool(ini.main.onlinsession),
        ['fullonlineses'] = new.bool(ini.main.fullonlineses),
        ['afkses'] = new.bool(ini.main.afkses),
        ['onlineday'] = new.bool(ini.main.onlineday),
        ['fullonlineday'] = new.bool(ini.main.fullonlineday),
        ['afkday'] = new.bool(ini.main.afkday),
        ['onlineweek'] = new.bool(ini.main.onlineweek),
        ['fullonlineweek'] = new.bool(ini.main.fullonlineweek),
        ['afkweek'] = new.bool(ini.main.afkweek),
        ['rep'] = new.bool(ini.main.rep),
        ['repses'] = new.bool(ini.main.repses),
        ['repday'] = new.bool(ini.main.repday),
        ['repweek'] = new.bool(ini.main.repweek),
        ['autoprefix'] = new.bool(ini.main.autoprefix),
        ['logcon'] = new.bool(ini.main.logcon),
        ['logreg'] = new.bool(ini.main.logreg),
        ['autoquest'] = new.bool(ini.main.autoquest),
        ['repchange'] = new.bool(ini.main.repchange),
        ['reputses'] = new.bool(ini.main.reputses),
        ['reputday'] = new.bool(ini.main.reputday),
        ['reputweek'] = new.bool(ini.main.reputweek),
        ['spyadm'] = new.bool(ini.main.spyadm),
        ['flipadm'] = new.bool(ini.main.flipadm),
        ['slapadm'] = new.bool(ini.main.slapadm),
        ['funcadmin'] = new.bool(ini.main.funcadmin),
        ['invauth'] = new.bool(ini.main.invauth),
        ['editchecker'] = new.bool(ini.main.editchecker),
        ['infoot'] = new.bool(ini.main.infoot),
        ['antifreeze'] = new.bool(ini.main.antifreeze),
        ['bonhead'] = new.bool(ini.main.bonhead),
        ['rwh'] = new.bool(ini.main.rwh),
        ['fixtp'] = new.bool(ini.main.fixtp),
        ['checkerlead'] = new.bool(ini.main.checkerlead),
        ['nick'] = new.bool(ini.setcheckerfrac.nick),
        ['zams'] = new.bool(ini.setcheckerfrac.zams),
        ['member'] = new.bool(ini.setcheckerfrac.member),
        ['memberafk'] = new.bool(ini.setcheckerfrac.memberafk),
        ['msktime'] = new.bool(ini.main.msktime),
        ['autob'] = new.bool(ini.main.autob),
        ['amemberchecker'] = new.bool(ini.main.amemberchecker),
        ['rechecker'] = new.bool(ini.main.rechecker),
        ['afkcontrol'] = new.bool(ini.main.afkcontrol),
        ['fastnakban'] = new.bool(ini.main.fastnakban),
        ['checkerfriends'] = new.bool(ini.main.checkerfriends),
        ['autobrec'] = new.bool(ini.main.autobrec),
        ['infammo'] = new.bool(ini.main.infammo),
        ['reportadm'] = new.bool(ini.main.reportadm),
        ['spawnset'] = new.bool(ini.main.spawnset),
        ['airbreak'] = new.bool(ini.main.airbreak),
        ['isfarchat'] = new.bool(ini.main.isfarchat)
      }

      buttons = {
        {name='Основное',text='Настройки аккаунта,\nавто /az',icon=fa.ICON_FA_COG,y_hovered=10,timer=0},
        {name='Читы',text='Clickwarp, GM,\nWH на кары, рендер',icon=fa.ICON_FA_CUBE,y_hovered=10,timer=0},
        {name='Цвета',text='Интерфейс, чаты,\nокно регистрации',icon=fa.ICON_FA_IMAGE,y_hovered=10,timer=0},
        {name='Биндер',text='Взятие репорта,\nвыход из рекона, клавиши',icon=fa.ICON_FA_TOGGLE_ON,y_hovered=10,timer=0},
        {name='Формы',text='Ручное принятие,\nавтоформы, бинд',icon=fa.ICON_FA_CROSSHAIRS,y_hovered=10,timer=0},
        {name='Рекон',text='Окно статистики,\nбыстрое меню',icon=fa.ICON_FA_USER_SECRET,y_hovered=10,timer=0},
        {name='Репорт',text='Доп. кнопки, ловля \nрепорта',icon=fa.ICON_FA_BULLHORN,y_hovered=10,timer=0},
        {name='Контроль AFK',text='',icon=fa.ICON_FA_BED,y_hovered=10,timer=0},
        {name='Чекер',text='Администрация,\nгосс.организации',icon=fa.ICON_FA_LIST_UL,y_hovered=10,timer=0},
        {name='Чаты', text="Рабочий чат, дальний чат,\nVIP чат", icon=fa.ICON_FA_COMMENT_ALT,y_hovered=10, timer=0},
      }

      checkers = {
        ['selected'] = 1,
        ['clicked'] = {
          ['last'] = nil,
          ['time'] = nil
        },
        ['buttons'] = {
          'Чекер администрации',
          'Чекер лидеров/замов',
          'Чекер игроков',
          'Лог отключения',
          'Лог регистраций'
        }
      }
      

      reports = {
        ['selected'] = 1,
        ['clicked'] = {
          ['last'] = nil,
          ['time'] = nil
        },
        ['buttons'] = {
          'Настройка ответов',
          'Автоловля репорта'
        }
      }

      local tWeekdays = {
        [0] = 'Воскресенье:',
        [1] = 'Понедельник:', 
        [2] = 'Вторник:', 
        [3] = 'Среда:', 
        [4] = 'Четверг:', 
        [5] = 'Пятница:', 
        [6] = 'Суббота:'
      }

      reportsettings = {
        " "..fa.ICON_FA_COG..u8(' Настройка ответов'),
        " "..fa.ICON_FA_ROBOT..u8(' Автоловля репорта')
      }

      checkersettings = {
        " "..fa.ICON_FA_USER_SHIELD..u8(' Чекер администрации'),
        " "..fa.ICON_FA_USERS..u8(' Чекер лидеров/замов'),
        " "..fa.ICON_FA_USER..u8(' Чекер игроков'),
        " "..fa.ICON_FA_SIGN_OUT_ALT..u8(' Лог отключения'),
        " "..fa.ICON_FA_SIGN_IN_ALT..u8(' Лог регистраций')
      }
      
      bindersettings = {
        " "..fa.ICON_FA_TOGGLE_ON..u8(" Назначение клавиш"),
        " "..fa.ICON_FA_FLUSHED..u8(" Биндер"),
      }

      formsettings = {
        " "..fa.ICON_FA_CROSSHAIRS..u8(" Формы"),
        " "..fa.ICON_FA_BARS..u8(" Выдача наказаний"),
      }
      
  clock = os.clock
  checker_font = renderCreateFont(ini.font.name, ini.font.size, ini.font.flag)
  wh_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.BORDER)
  local BulletSync = {lastId = 0, maxLines = 15}
  for i = 1, BulletSync.maxLines do
    BulletSync[i] = {enable = false, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
  end

      admins = {
        ['forms'] = {
          ['tag'] = new.char[256](""..ini.forms.tag),
          ['ban'] = ini.forms.ban,
        },
        ['profile'] = {
          ['passacc'] = new.char[256](""..base64.decode(ini.main.pass_acc)),
          ['passadm'] = new.char[256](""..ini.main.pass_adm),
        },
        ['checker'] = {
          ['amountOnline'] = 0,
          ['amountAfk'] = 0,
        },
        ['showLvl'] = {
          [1] = new.bool(ini.level[1]),
            [2] = new.bool(ini.level[2]),
            [3] = new.bool(ini.level[3]),
            [4] = new.bool(ini.level[4]),
            [5] = new.bool(ini.level[5]),
            [6] = new.bool(ini.level[6]),
            [7] = new.bool(ini.level[7]),
            [8] = new.bool(ini.level[8])
        },
        ['colors'] = {
          lvl = {
            [1] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[1]).x, imgui.ColorConvertU32ToFloat4(ini.color[1]).y, imgui.ColorConvertU32ToFloat4(ini.color[1]).z, imgui.ColorConvertU32ToFloat4(ini.color[1]).w),
              [2] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[2]).x, imgui.ColorConvertU32ToFloat4(ini.color[2]).y, imgui.ColorConvertU32ToFloat4(ini.color[2]).z, imgui.ColorConvertU32ToFloat4(ini.color[2]).w),
              [3] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[3]).x, imgui.ColorConvertU32ToFloat4(ini.color[3]).y, imgui.ColorConvertU32ToFloat4(ini.color[3]).z, imgui.ColorConvertU32ToFloat4(ini.color[3]).w),
              [4] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[4]).x, imgui.ColorConvertU32ToFloat4(ini.color[4]).y, imgui.ColorConvertU32ToFloat4(ini.color[4]).z, imgui.ColorConvertU32ToFloat4(ini.color[4]).w),
              [5] = imgui.new.float[5](imgui.ColorConvertU32ToFloat4(ini.color[5]).x, imgui.ColorConvertU32ToFloat4(ini.color[5]).y, imgui.ColorConvertU32ToFloat4(ini.color[5]).z, imgui.ColorConvertU32ToFloat4(ini.color[5]).w),
              [6] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[6]).x, imgui.ColorConvertU32ToFloat4(ini.color[6]).y, imgui.ColorConvertU32ToFloat4(ini.color[6]).z, imgui.ColorConvertU32ToFloat4(ini.color[6]).w),
              [7] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[7]).x, imgui.ColorConvertU32ToFloat4(ini.color[7]).y, imgui.ColorConvertU32ToFloat4(ini.color[7]).z, imgui.ColorConvertU32ToFloat4(ini.color[7]).w),
              [8] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[8]).x, imgui.ColorConvertU32ToFloat4(ini.color[8]).y, imgui.ColorConvertU32ToFloat4(ini.color[8]).z, imgui.ColorConvertU32ToFloat4(ini.color[8]).w),
          },
          content = {
		    		['afk'] 		= {'AFK', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['afk']).x, imgui.ColorConvertU32ToFloat4(ini.color['afk']).y, imgui.ColorConvertU32ToFloat4(ini.color['afk']).z, imgui.ColorConvertU32ToFloat4(ini.color['afk']).w)},
			    	['recon'] 		= {'Слежка', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['recon']).x, imgui.ColorConvertU32ToFloat4(ini.color['recon']).y, imgui.ColorConvertU32ToFloat4(ini.color['recon']).z, imgui.ColorConvertU32ToFloat4(ini.color['recon']).w)},
			    	['reputate'] 	= {'Репутация', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['reputate']).x, imgui.ColorConvertU32ToFloat4(ini.color['reputate']).y, imgui.ColorConvertU32ToFloat4(ini.color['reputate']).z, imgui.ColorConvertU32ToFloat4(ini.color['reputate']).w)},
			    	['active'] 		= {'Актив', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['active']).x, imgui.ColorConvertU32ToFloat4(ini.color['active']).y, imgui.ColorConvertU32ToFloat4(ini.color['active']).z, imgui.ColorConvertU32ToFloat4(ini.color['active']).w)},
			    	['note']		= {'Заметки', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['note']).x, imgui.ColorConvertU32ToFloat4(ini.color['note']).y, imgui.ColorConvertU32ToFloat4(ini.color['note']).z, imgui.ColorConvertU32ToFloat4(ini.color['note']).w)},
		    	},
        },
        ['showInfo'] = {
            id 			= new.bool(ini.show.id),
            level 		= new.bool(ini.show.level),
            afk 		= new.bool(ini.show.afk),
            recon 		= new.bool(ini.show.recon),
            reputate 	= new.bool(ini.show.reputate),
            active 		= new.bool(ini.show.active),
            selfMark 	= new.bool(ini.show.selfMark),
        },
        ['pos'] = imgui.ImVec2(ini.main.posX, ini.main.posY),
        ['posstatsrecon'] = imgui.ImVec2(ini.recon.x, ini.recon.y),
        ['poslogdisc'] = imgui.ImVec2(ini.main.logconposx, ini.main.logconposy),
        ['poslogreg'] = imgui.ImVec2(ini.main.logregposx, ini.main.logregposy),
        ['posrecon'] = imgui.ImVec2(ini.recon.funcx, ini.recon.funcy),
        ['posstats'] = imgui.ImVec2(ini.main.statsx, ini.main.statsy),
        ['posflood'] = imgui.ImVec2(ini.main.floodposx, ini.main.floodposy),
        ['poscheckerlead'] = imgui.ImVec2(ini.checkerfrac.posx, ini.checkerfrac.posy),
        ['poscheckerfriends'] = imgui.ImVec2(ini.main.friendsx, ini.main.friendsy),
        ['posfarchat'] = imgui.ImVec2(ini.main.farchatx, ini.main.farchaty),
        ['online'] = nil,
        ['afk'] = nil,
        ['list'] = {},
        ['active'] = {}
      }
      
      fonts = {
        ['input'] = imgui.new.char[256](u8(ini.font.name)),
        ['size'] = imgui.new.int(ini.font.size),
        ['flag'] = imgui.new.int(ini.font.flag),
        ['offset'] = imgui.new.int(ini.font.offset),
      }

      admNames = {
        'Мл. Модератор',
        'Модератор',
        'Ст. Модератор',
        'Администратор',
        'Куратор',
        'Заместитель ГА',
        'Главный администратор',
        'Спец. Администратор'
      }

      rInfo = {
        ['id'] = "-1",
        ['carid'] = "-1",
        ['iscar'] = false,
        ['status'] = false,
        ['name'] = nil,
        ['org'] = "Неизвестно",
        ['rank'] = "-1",
        ['client'] = "Неизвестно",
        ['iskamen'] = false,
        ['lasttp'] = false,
      }

      settingsChecker = {}

      editColors = {
        ['mc'] = new.float[4](mc.x, mc.y, mc.z, mc.w),
        ['tc'] = new.float[4](tc.x, tc.y, tc.z, tc.w),
        ['cd'] = new.float[4](cd.x, cd.y, cd.z, cd.w),
        ['rc'] = new.float[4](rc.x, rc.y, rc.z, rc.w),
        ['ac'] = new.float[4](ac.x, ac.y, ac.z, ac.w),
        ['report'] = new.float[4](report.x, report.y, report.z, report.w),
        ['farchat'] = new.float[4](farchat_clr.x, farchat_clr.y, farchat_clr.z, farchat_clr.w),
        ['disc'] = new.float[4](disc.x, disc.y, disc.z, disc.w)
      }
      NameCar = {
        [400] = 'Landstalker',
        [401] = 'Bravura',
        [402] = 'Buffalo',
        [403] = 'Linerunner',
        [404] = 'Perenniel',
        [405] = 'Sentinel',
        [406] = 'Dumper',
        [407] = 'Firetruck',
        [408] = 'Trashmaster',
        [409] = 'Stretch',
        [410] = 'Manana',
        [411] = 'Infernus',
        [412] = 'Voodoo',
        [413] = 'Pony',
        [414] = 'Mule',
        [415] = 'Cheetah',
        [416] = 'Ambulance',
        [417] = 'Leviathan',
        [418] = 'Moonbeam',
        [419] = 'Esperanto',
        [420] = 'Taxi',
        [421] = 'Washington',
        [422] = 'Bobcat',
        [423] = 'Mr Whoopee',
        [424] = 'BF Injection',
        [425] = 'Hunter',
        [426] = 'Premier',
        [427] = 'Enforcer',
        [428] = 'Securicar',
        [429] = 'Banshee',
        [430] = 'Predator',
        [431] = 'Bus',
        [432] = 'Rhino',
        [433] = 'Barracks',
        [434] = 'Hotknife',
        [435] = 'Article Trailer',
        [436] = 'Previon',
        [437] = 'Coach',
        [438] = 'Cabbie',
        [439] = 'Stallion',
        [440] = 'Rumpo',
        [441] = 'RC Bandit',
        [442] = 'Romero',
        [443] = 'Packer',
        [444] = 'Monster',
        [445] = 'Admiral',
        [446] = 'Squallo',
        [447] = 'Seasparrow',
        [448] = 'Pizzaboy',
        [449] = 'Tram',
        [450] = 'Article Trailer 2',
        [451] = 'Turismo',
        [452] = 'Speeder',
        [453] = 'Reefer',
        [454] = 'Tropic',
        [455] = 'Flatbed',
        [456] = 'Yankee',
        [457] = 'Caddy',
        [458] = 'Solair',
        [459] = "Berkley's RC",
        [460] = 'Skimmer',
        [461] = 'PCJ-600',
        [462] = 'Faggio',
        [463] = 'Freeway',
        [464] = 'RC Baron',
        [465] = 'RC Raider',
        [466] = 'Glendale',
        [467] = 'Oceanic',
        [468] = 'Sanchez',
        [469] = 'Sparrow',
        [470] = 'Patriot',
        [471] = 'Quad',
        [472] = 'Coastguard',
        [473] = 'Dinghy',
        [474] = 'Hermes',
        [475] = 'Sabre',
        [476] = 'Rustler',
        [477] = 'ZR-350',
        [478] = 'Walton',
        [479] = 'Regina',
        [480] = 'Comet',
        [481] = 'BMX',
        [482] = 'Burrito',
        [483] = 'Camper',
        [484] = 'Marquis',
        [485] = 'Baggage',
        [486] = 'Dozer',
        [487] = 'Maverick',
        [488] = 'SAN News Maverick',
        [489] = 'Rancher',
        [490] = 'FBI Rancher',
        [491] = 'Virgo',
        [492] = 'Greenwood',
        [493] = 'Jetmax',
        [494] = 'Hotring Racer',
        [495] = 'Sandking',
        [496] = 'Blista Compact',
        [497] = 'Police Maverick',
        [498] = 'Boxville',
        [499] = 'Benson',
        [500] = 'Mesa',
        [501] = 'RC Goblin',
        [502] = 'Hotring Racer A',
        [503] = 'Hotring Racer B',
        [504] = 'Bloodring Banger',
        [505] = 'Rancher',
        [506] = 'Super GT',
        [507] = 'Elegant',
        [508] = 'Journey',
        [509] = 'Bike',
        [510] = 'Mountain Bike',
        [511] = 'Beagle',
        [512] = 'Cropduster',
        [513] = 'Stuntplane',
        [514] = 'Tanker',
        [515] = 'Roadtrain',
        [516] = 'Nebula',
        [517] = 'Majestic',
        [518] = 'Buccaneer',
        [519] = 'Shamal',
        [520] = 'Hydra',
        [521] = 'FCR-900',
        [522] = 'NRG-500',
        [523] = 'HPV1000',
        [524] = 'Cement Truck',
        [525] = 'Towtruck',
        [526] = 'Fortune',
        [527] = 'Cadrona',
        [528] = 'FBI Truck',
        [529] = 'Willard',
        [530] = 'Forklift',
        [531] = 'Tractor',
        [532] = 'Combine Harvester',
        [533] = 'Feltzer',
        [534] = 'Remington',
        [535] = 'Slamvan',
        [536] = 'Blade',
        [537] = 'Freight (Train)',
        [538] = 'Brownstreak (Train)',
        [539] = 'Vortex',
        [540] = 'Vincent',
        [541] = 'Bullet',
        [542] = 'Clover',
        [543] = 'Sadler',
        [544] = 'Firetruck LA',
        [545] = 'Hustler',
        [546] = 'Intruder',
        [547] = 'Primo',
        [548] = 'Cargobob',
        [549] = 'Tampa',
        [550] = 'Sunrise',
        [551] = 'Merit',
        [552] = 'Utility Van',
        [553] = 'Nevada',
        [554] = 'Yosemite',
        [555] = 'Windsor',
        [556] = 'Monster A',
        [557] = 'Monster B',
        [558] = 'Uranus',
        [559] = 'Jester',
        [560] = 'Sultan',
        [561] = 'Stratum',
        [562] = 'Elegy',
        [563] = 'Raindance',
        [564] = 'RC Tiger',
        [565] = 'Flash',
        [566] = 'Tahoma',
        [567] = 'Savanna',
        [568] = 'Bandito',
        [569] = 'Freight Flat Trailer',
        [570] = 'Streak Trailer',
        [571] = 'Kart',
        [572] = 'Mower',
        [573] = 'Dune',
        [574] = 'Sweeper',
        [575] = 'Broadway',
        [576] = 'Tornado',
        [577] = 'AT400',
        [578] = 'DFT-30',
        [579] = 'Huntley',
        [580] = 'Stafford',
        [581] = 'BF-400',
        [582] = 'Newsvan',
        [583] = 'Tug',
        [584] = 'Petrol Trailer',
        [585] = 'Emperor',
        [586] = 'Wayfarer',
        [587] = 'Euros',
        [588] = 'Hotdog',
        [589] = 'Club',
        [590] = 'Freight Box Trailer',
        [591] = 'Article Trailer 3',
        [592] = 'Andromada',
        [593] = 'Dodo',
        [594] = 'RC Cam',
        [595] = 'Launch',
        [596] = 'Police Car (LSPD)',
        [597] = 'Police Car (SFPD)',
        [598] = 'Police Car (LVPD)',
        [599] = 'Police Ranger',
        [600] = 'Picador',
        [601] = 'S.W.A.T.',
        [602] = 'Alpha',
        [603] = 'Phoenix',
        [604] = 'Glendale Shit',
        [605] = 'Sadler Shit',
        [606] = 'Baggage Trailer A',
        [607] = 'Baggage Trailer B',
        [608] = 'Tug Stairs Trailer',
        [609] = 'Boxville',
        [610] = 'Farm Trailer',
        [611] = 'Utility Trailer',
        [612] = "Mercedes GT63 AMG",
        [613] = "Mercedes G63 AMG",
        [614] = "Audi RS6",
        [662] = "BMW X5m",
        [663] = "Chevrolet Corvette",
        [665] = "Chevrolet Cruze",
        [666] = "Lexus LX 570",
        [667] = "Porsche 911",
        [668] = "Porsche Cayenne S",
        [699] = "Bentley",
        [793] = "BMW M8",
        [794] = "Mercedes E63",
        [909] = "Mercedes S63 AMG Coupe A",
        [965] = "Volkswagen Touareg", 
        [1194] = "Lamborgini Urus",
        [1195] = "Audi Q8",
        [1196] = "Dodge Challenger SRT",
        [1197] = "Acura NSX",
        [1198] = "Volvo V60",
        [1199] = "Range Rover Evoque",
        [1200] = "Honda Civic Type-R", 
        [1201] = "Lexus Sport-S",
        [1202] = "Ford Mustang GT",
        [1203] = "Volvo XC90",
        [1204] = "Jaguar F-pace",
        [1205] = "Kia Optima",
        [3155] = "BMW Z4 40i",
        [3156] = "Mercedes-Benz S600 W124",
        [3157] = "BMW X5 ES3",
        [3158] = "Nissan Skyline R34",
        [3194] = "Ducati Diavel",
        [3195] = "Ducati Panlgale",
        [3196] = "Ducati Ducnaked",
        [3197] = "Kawasaki Ninja ZX-10RR",
        [3198] = "Western",
        [3199] = "Rolls-Royce Cullinan",
        [3200] = "Volkswagen Beetle",
        [3201] = "Bugatti Divo Sport",
        [3202] = "Bugati Chiron",
        [3203] = "Fiat 500",
        [3204] = "Mercedes GLS 2020",
        [3205] = "Mercedes-AMG G65 AMG",
        [3206] = "Lamborghini Aventador SVJ",
        [3207] = "Range Rover SVA",
        [3208] = "BMW 530I E39",
        [3209] = "Mercedes-Benz S600 W220",
        [3210] = "Tesla Model X",
        [3211] = "Nissan LEAF",
        [3212] = "Nissan Silvia S15",
        [3213] = "Subary Forest XT",
        [3215] = "Subaru Legacy 1989",
        [3216] = "Hyundai Sonata",
        [3217] = "BMW 750I E38",
        [3218] = "Mercedes-Benz E 55 AMG",
        [3219] = "Mercedes-Benz E500",
        [3220] = "Storm",
        [3222] = "Makvin",
        [3223] = "Mater",
        [3224] = "Buckingham",
        [3232] = "Infiniti FX 50",
        [3233] = "Lexus RX 450H",
        [3234] = "Kia Sportage",
        [3235] = "Volkswagen Golf R",
        [3236] = "Audi R8",
        [3237] = "Toyota Camry XV40",
        [3238] = "Toyota Camry XV70",
        [3239] = "BMW M5 E60",
        [3240] = "BMW M5 F90",
        [3245] = "Mercedes Maybach S 650",
        [3247] = "Mercedes-Benz AMG GT",
        [3248] = "Porsche Panamera Turbo",
        [3251] = "Volkswagen Passat",
        [3254] = "Chevrole Corvette",
        [3266] = "Dodge Ram",
        [3348] = "Ford Mustang Shelby GT500",
        [3974] = "Aston Martin DB5",
        [4542] = "BMW M3 GTR",
        [4543] = "Chevrolete Camaro",
        [4544] = "Mazda RX7 Veilside FD",
        [4545] = "Mazda RX8",
        [4546] = "Mitsubishi Eclipse",
        [4547] = "Ford Mustang 289",
        [4548] = "Nissan 350Z",
        [4774] = "BMW 760li",
        [4775] = "Aston Martin One-77",
        [4776] = "Bentley Bacalar",
        [4777] = "Bentley Bentyaga",
        [4778] = "BMW M4 G82",
        [4779] = "BMW I8",
        [4780] = "Genesis G90",
        [4781] = "Honda Integra Type-R",
        [4782] = "BMW M3 G20",
        [4783] = "Mercedes-Benz S500 4Matic",
        [4784] = "Ford Raptor F150",
        [4785] = "Ferrari J50",
        [4786] = "Mercedes-Benz SLR McLaren",
        [4787] = "Subaru BRZ",
        [4788] = "Lada Vesta SW Cross",
        [4789] = "Porsche Taycan",
        [4790] = "Ferrari Enzo",
        [4791] = "UAZ Patriot",
        [4792] = "Volga",
        [4793] = "Mercedes-Benz X Class", --
        [4794] = "Jaguar XF",
        [4795] = "RC Shuttle",
        [4796] = "Dodge Grand Caravan",
        [4797] = "Dodge Charger",
        [4798] = "Ford Exploler",
        [4799] = "Ford F150",
        [4800] = "Deltaplan",
        [4801] = "Gidrocycle",
        [4802] = "Lamborgini Cantenario",
        [4803] = "Ferrari 612 Superfast",
        [6604] = "Audi A6",
        [6605] = "Audi Q7",
        [6606] = "BMW M6 2020",
        [6607] = "BMW M6 1990",
        [6608] = "Mercedes-Benz CLA 45 AMG", 
        [6609] = "Mercedes-Benz CLS 63 AMG",
        [6610] = "Haval H6 2.0 GDIT",
        [6611] = "Toyota Land Cruiser VXR V8 4",
        [6612] = "Lincol Continental",
        [6613] = "Porsche Macan Turbo",
        [6614] = "Daewoo Matiz",
        [6615] = "Mercedes-AMG G63 6x6",
        [6616] = "Mercedes-Benz E-63 AMG",
        [6617] = "Monster Mutt",
        [6618] = "Monster Indonesia", --
        [6619] = "Monster El Toro",
        [6620] = "Monster Grave Digger",
        [6621] = "Toyota Land Cruiser Prado",
        [6622] = "Toyota RAV4",
        [6623] = "Toyota Supra A90",
        [6624] = "UAZ",
        [6625] = "Volvo XC90 2012",
        [12713] = "Mercedes-Benz GLE 63",
        [12714] = "Renault Laguna",
        [12715] = "Mercedes-Benz CLS 53",
        [12716] = "Audi RS5",
        [12717] = "Cadilac Escalade 2020",
        [12718] = "Cyber Truck",
        [12719] = "Tesla Model C",
        [12720] = "Ford GT",
        [12721] = "Dodge Viper",
        [12722] = "Volkswagen Polo",
        [12723] = "Mitsubishi Lancer Old",
        [12724] = "Audi TT RS",
        [12725] = "Mercedes-Benz Actros",
        [12726] = "Audi S4",
        [12727] = "BMW 4-Series",
        [12728] = "Cadillac Escalade 2007",
        [12729] = "Toyota Chaser",
        [12730] = "Dacia 1300",
        [12731] = "Mitsubishi Lancer",
        [12732] = "Impala 64",
        [12733] = "Impala 67",
        [12734] = 'Kenwooth Track',
        [12735] = 'Kenwooth Trailer',
        [12736] = "McLaren MP4",
        [12737] = "Ford Mustang Mach 1",
        [12738] = "Rolls-Royce Phantom",
        [12739] = "Pickup truck",
        [12740] = "Volvo Truck",
        [12741] = "Subaru WRX",
        [12742] = "Sherp",
        [12743] = 'Sanki',
        [14119] = 'Audi A6',
        [14120] = 'Toyota Camry',
        [14121] = 'Kia',
        [14122] = 'Tesla Model X',
        [14123] = "Toyota Rav4",
        [14124] = "Nissan GTR 2017", 
        [14767] = "Mercedes-AMG Project One R50",
        [14768] = 'Aston Martin Valkyrie',
        [14769] = "Chevrolet Aveo",
        [14857] = "BUGATTI Bolide",
        [14884] = "Yacota K5",
        [14899] = "Renault DUSTER",
        [14904] = "Ferrari Monza SP2",
        [14905] = "Mercedes-AMG G63",
        [14906] = "HotWheels",
        [14907] = "Hummer HX",
        [14908] = "Ferrari F70",
        [14909] = "BMW M5 CS",
        [14910] = "LADA Priora",
        [14911] = "Quadra Turbo-R V-Tech",
        [14912] = 'Mercedes-Benz GLE',
        [14913] = "Mercedes-Benz VISION AVTR",
        [14914] = "Specialized Stumpjumper",
        [14915] = "Santa Cruz Tallboy",
        [14916] = "Spooky Metalhead",
        [14917] = "Turner Burner",
        [14918] = "Holding Bus Company",
        [14919] = "Los-Santos Inter Bus C.",
        [15085] = "Dodge Charger",
        [15098] = 'BMW M1 e26',
        [15099] = "Lamborghini Countach",
        [15100] = 'Nagasaki',
        [15101] = "Koenigsegg Gemera",
        [15102] = 'Kia K7',
        [15103] = 'toro',
        [15104] = 'Lexus LX600',
        [15105] = 'Nissan Qashqai',
        [15106] = 'predatorr',
        [15107] = 'Volkswagen Scirocco',
        [15108] = 'Longfin',
        [15109] = "Land Cruiser",
        [15110] = 'Wellcraft',
        [15111] = 'Yacht',
        [15112] = 'Boates',
        [15113] = 'Mercedes-Benz A45',
        [15114] = 'Toyota AE86',
        [15115] = "Land Rover Defender",
        [15116] = 'Ford Mustang Mach',
        [15117] = 'Mazda 6',
        [15118] = 'Audi R8s',
        [15119] = 'Hyundai Santa Fe',
        [15295] = 'Range Rover Velar',
      }
      gunmass = {
        1,
        2,
        3,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        17,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        41,
        42,
        43,
        46
      }
----------------------------------------------------

--                      Теги

  local tag_err = "{FF7F50}[Ошибка] {FFFFFF}"
  local tag_q =  "{9370DB}[Lulu-Tools]{FFFFFF}: "
  local tag = "{9370DB}[Lulu-Tools]{FFFFFF}: "



----------------------------------------------------------- 

--                     Фигня всякая

  pass_acc_see = false
  pass_acc_see_adm = false
  keyToggle = VK_MBUTTON
  keyApply = VK_LBUTTON
  repId = "-1"
  lost_report = false
  statuscheckafk=true
  workchecker=false
  adminsOnline = 0
  adminsAfk = 0
  selfrep = 0
  lvladmplayer = "0"
  local idt = -1
  local y = 600
  workingChecker = false
  statsforma = true
  formastop = false
  afktest = false
  enAirBrake = false
  fastmenu_id = -1
  fastmenu_lvl = -1
  listmenu = 0
  ableclickwarp = false
  logcon = {}
  logreg = {} 
  logregnick = {} 
  logregid = {} 
  lastrepnick = {}
  reportsettings_list = new.int(1)
  checkersettings_list = new.int(1)
  bindersettings_list = new.int(1)
  formsettings_list = new.int(1)
  lcTable = {}
  lcTableBuffer = {}

  local objs = {
    [854] = "РЕСУРС",
  }

  local font = renderCreateFont('ShellyAllegroC',6,5)

  function gpsbutton(arg)
    if report_window[0] then
      imgui.StrCopy(inputs['report_window_answer'], u8(gpsInfo[arg]))
      gps_window[0] = false
    else
      lua_thread.create(function()
        sampSetChatInputEnabled(true)
        wait(1)
        sampSetChatInputText(gpsInfo[arg])
        gps_window[0] = false
      end)
    end
  end

  function cmdbutton(arg)
    if report_window[0] then
      imgui.StrCopy(inputs['report_window_answer'], u8(cmdInfo[arg]))
      cmd_window[0] = false
    else
      lua_thread.create(function()
        sampSetChatInputEnabled(true)
        wait(1)
        sampSetChatInputText(cmdInfo[arg])
        cmd_window[0] = false
      end)
    end
  end

  function questionbutton(arg)
    if report_window[0] then
      local answer = string.match(questionInfo[arg], "%[Ответ:(.+)%]")
      imgui.StrCopy(inputs['report_window_answer'], u8(answer))
      question_window[0] = false
    else
      lua_thread.create(function()
        local answer = string.match(questionInfo[arg], "%[Ответ:(.+)%]")
        sampSetChatInputEnabled(true)
        wait(1)
        sampSetChatInputText(answer)
        question_window[0] = false
      end)
    end
  end

--------------------------------------------

function getTime(timezone)
  local https = require 'ssl.https'
  local time = https.request('http://alat.specihost.com/unix-time/')
  return time and tonumber(time:match('^Current Unix Timestamp: <b>(%d+)</b>')) + (timezone or 0) * 60 * 60
end
  

local thisScript = script.this

function main()
    if not isSampLoaded()  then return end
    while  not isSampAvailable() do wait(100) end
    kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
    id = select(2, sampGetPlayerIdByCharHandle(playerPed))
    self = {
      nick = sampGetPlayerNickname(id),
      score = sampGetPlayerScore(id),
      color = sampGetPlayerColor(id),
      ping = sampGetPlayerPing(id),
      gameState = sampGetGamestate()
    }
    sampSendChat("/reoff")
    initializeRender()
    local ip, port = sampGetCurrentServerAddress()
    if ip ~= "80.66.82.168" then
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        thisScript:unload()        
    end
    wait(10)
    if doesFileExist("moonloader\\money_separator.lua") then
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      sampAddChatMessage(tag_err..'Обнаружен конфликтующий скрипт - money_separator.lua!  Удалите его, в Lulu Tools имеется система разделения цифр', -1)
      thisScript:unload()
    end
    if not doesFileExist(getGameDirectory()..'\\_CoreGame.asi') then
      sampAddChatMessage(tag_err..'Внимание! Данный Tools был предназначен для Лаунчера Arizona Games, при игре со сторонних клиентов, возможны ошибки.', -1)
    end
    if not doesDirectoryExist("moonloader\\Lulu Tools") then
      createDirectory("moonloader\\Lulu Tools")
    end
    if not doesDirectoryExist("moonloader\\Lulu Tools\\fonts") then
      createDirectory("moonloader\\Lulu Tools\\fonts")
    end
    if not doesDirectoryExist("moonloader\\Lulu Tools\\images") then
      createDirectory("moonloader\\Lulu Tools\\images")
    end
    if not doesFileExist("moonloader\\Lulu Tools\\images\\color.jpg") then
      downloadUrlToFile("https://lulu-bot.tech/tools/images/color.jpg", "moonloader\\Lulu Tools\\images\\color.jpg", function (id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          print(tag..'Установлено изображение \'color.jpg\'.', -1)
        end
      end)
    end
    if not doesFileExist("moonloader\\reload_all.lua") then
      downloadUrlToFile("https://lulu-bot.tech/tools/reload_all.lua", "moonloader\\reload_all.lua", function (id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          sampAddChatMessage(tag..'Установлен скрипт \'reload_all.lua\'.', -1)
          sampAddChatMessage(tag..'Нажмите Ctrl + R для перезагрузки всех скриптов.', -1)
          reloadScripts()
        end
      end)
    end
    wait(10)
    sampAddChatMessage(tag_q..'Проверка обновления..', -1)
    while update ~= false do 
      wait(100) 
      autoupdate("https://lulu-bot.tech/tools/infoupdate.json", '['..string.upper(thisScript.name)..']: ', "https://lulu-bot.tech/admin-soft/")
    end
    gpsDw()
    if not ini.main.updateshown then
      update_window[0] = true
    end
    setCharCanBeKnockedOffBike(PLAYER_PED, true)
    addEventHandler('onWindowMessage', function(msg, wparam, lparam)
      if msg == 0x100 or msg == 0x101 then
        if wparam == VK_RETURN and report_window[0] and not sampIsChatInputActive() and not isPauseMenuActive() then
          consumeWindowMessage(true, false)
          if msg == 0x101 then
            if len(str(inputs['report_window_answer'])) < 1 then
              return false
            elseif len(str(inputs['report_window_answer'])) > 85 then
              sampAddChatMessage(tag_err..'Длина ответа должна быть не более 85ти символов!', -1)
              return false
            else
              sampSendDialogResponse(1334, 1, 0, u8:decode(str(inputs['report_window_answer'])))
              infoReport(u8:decode(str(inputs['report_window_answer'])))
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
              report_window[0] = false
              addreport()
            end
          end
        end
      end
    end)
    sampDestroy3dText(1646)
    if ini.onDay.today ~= os.date("%a") then 
      ini.onDay.today = os.date("%a")
      ini.onDay.online = 0
       ini.onDay.full = 0
       ini.onDay.afk = 0
         dayFull = 0
         save()
    end

    if ini.onWeek.week ~= number_week() then
      ini.onWeek.week = number_week()
      ini.onWeek.online = 0
      ini.onWeek.full = 0
      ini.onWeek.afk = 0
      weekFull = 0
      for _, v in pairs(ini.myWeekOnline) do 
        v = 0 
        save()
      end            
      
    end

    if ini.onDayReport.today ~= os.date("%a") then
      ini.onDayReport.today = os.date("%a")
      ini.onDayReport.report = 0
      save()
    end

    if ini.onDayReput.today ~= os.date("%a") then
      ini.onDayReput.today = os.date("%a")
      ini.onDayReput.reput = 0
      save()
    end

    if ini.onWeekReport.week ~= number_week() then
      ini.onWeekReport.week = number_week()
      ini.onWeekReport.report = 0
      for _, v in pairs(ini.myWeekOnline) do v = 0 end
      save()
    end
    if ini.onWeekReput.week ~= number_week() then
      ini.onWeekReput.week = number_week()
      ini.onWeekReput.reput = 0
      for _, v in pairs(ini.onWeekReput) do v = 0 end
      save()
    end
    require('memory').write(getModuleHandle("samp.dll") + 0x09D318, 37008, 2, true)
    lua_thread.create(flooder)
    lua_thread.create(time)
    lua_thread.create(autoSave)
    lua_thread.create(flood_report)
    flooderorgmembers()
    lua_thread.create(checkbinds)
    lua_thread.create(COMMANDS)
    lua_thread.create(afktime)

    if ini.main.statswindow then
      stats_window[0] = true
    else
      stats_window[0] = false
    end
    afkstatus = false
    ---------------------------------------------
    while true do
      id = select(2, sampGetPlayerIdByCharHandle(playerPed))
      selfid = select(2, sampGetPlayerIdByCharHandle(playerPed))
      self = {
        nick = sampGetPlayerNickname(id),
        score = sampGetPlayerScore(id),
        color = sampGetPlayerColor(id),
        ping = sampGetPlayerPing(id),
        gameState = sampGetGamestate()
      }
      if isGamePaused() and statuscheckafk then  
        startafktime = os.time()
        statuscheckafk = false
        erorafk = false
      elseif not isGamePaused() then
        statuscheckafk = true 
        startafktime = 0
        if not afkstatus then
          erorafk = false
        end
      end
      if isGamePaused() and ini.main.afkcontrol then
          if os.time() - startafktime > tonumber(ini.afk.limit) then
            ShowMessage('Значение афк уже достигло '..ini.afk.limit..' секунд\nВыхожу из игры', 'Control AFK', 48)
            wait(3000)
            callFunction(8535003, 3, 3, 0, 0, 0)
          end 
      end
      if isGamePaused() and ini.main.afkcontrol then
        if os.time() - startafktime == tonumber(ini.afk.allow) and not erorafk then  
          erorafk = true
          ShowMessage("Ваше AFK приближается к привышению нормы\nВернитесь в игру или игра будет закрыта через "..tonumber(ini.afk.limit) - tonumber(ini.afk.allow).." секунд.", "Контроль AFK", 48)
        end 
      end
      
      if isGamePaused() or afkstatus and not afktest then
        lua_thread.create(function ()
          afktest = true
          while isGamePaused() or afkstatus do
            wait(0)
          end
          wait(1500)
          
          afktest = false
        end)
      end
      while isPauseMenuActive() do
        if cursorEnabled then
          showCursor(false)
        end
        wait(100)
      end
      local oTime = os.time()
      if ini.main.traicers then
        for i = 1, BulletSync.maxLines do
          if BulletSync[i].enable == true and oTime <= BulletSync[i].time then
            local o, t = BulletSync[i].o, BulletSync[i].t
            if isPointOnScreen(o.x, o.y, o.z) and
              isPointOnScreen(t.x, t.y, t.z) then
              local sx, sy = convert3DCoordsToScreen(o.x, o.y, o.z)
              local fx, fy = convert3DCoordsToScreen(t.x, t.y, t.z)
              renderDrawLine(sx, sy, fx, fy, 1, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
              renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
            end
          end
        end
      end
      
      if ini.main.whcar then
        veh = getAllVehicles()
        for k, v in ipairs(veh) do
          if isCarOnScreen(v) then
            model = getNameVehicleModel(getCarModel(v)) .. ' (' .. tostring(select(2, sampGetVehicleIdByCarHandle(v))) .. ')'
            clr, _ = getCarColours(v)
            local cx, cy, cz = getCarCoordinates(v)
            local px, py, pz = getCharCoordinates(PLAYER_PED)
            local x, y = convert3DCoordsToScreen(cx, cy, cz)
            local lenght = renderGetFontDrawTextLength(font, model, true)
            local height = renderGetFontDrawHeight(font)
            local hpModel = getCarHealth(v)
            local dist = getDistanceBetweenCoords3d(cx, cy, cz, px, py, pz)
            if dist <= ini.main.whdist then
              renderFontDrawText(wh_font, model, x - (lenght) / 2, y - (height+50) / 2, 0xFFFFFFFF, true)
              renderFontDrawText(wh_font, "HP: "..hpModel, x - (lenght) / 2, y - (height+20) / 2, 0xFFFFFFFF, true)
            end
          end
        end
      end
      yRender = ini.main.posY
      if ChangePosReconStats and rInfo['id'] == "-1" then
        local cx, cy = getCursorPos()
        renderDrawBox(cx,cy,400,400,0xAAFFFFFF)
      end
      if ini.main.logcon then
        local X = ini.main.logconposx
        local Y = ini.main.logconposy
        local logconcolorconv = imgui.ColorConvertU32ToFloat4(ini.style.logcon_def)
        logconcolorconv = imgui.ColorConvertFloat4ToARGB(logconcolorconv)
        renderFontDrawText(my_font, "Лог отключения:", ini.main.logconposx, ini.main.logconposy-ini.main.logoffset, logconcolorconv)
        for k, v in pairs(logcon) do
          renderFontDrawText(my_font, v, X, Y, logconcolorconv)
          Y = Y + ini.main.logoffset
        end
      end
      if ini.main.logreg then
        local X = ini.main.logregposx
        local Y = ini.main.logregposy --ini.style.logreg
        local logregconv = imgui.ColorConvertU32ToFloat4(ini.style.logreg)
        logregconv = imgui.ColorConvertFloat4ToARGB(logregconv)
        renderFontDrawText(my_font, "Лог регистраций:", ini.main.logregposx, ini.main.logregposy-ini.main.regoffset, logregconv)
        for k, v in pairs(logreg) do
          if not sampIsPlayerConnected(logregid[k]) or sampGetPlayerNickname(logregid[k]) ~= tostring(logregnick[k]) then
            v = v.." {ff0000}[OFF]"
          end
          renderFontDrawText(my_font, v, X, Y, logregconv)
          Y = Y + ini.main.regoffset
        end
      end
      if ChangePosRecon and rInfo['id'] == "-1" then
        local cx, cy = getCursorPos()
        renderDrawBox(cx, cy, 550, 88, 0xAAFFFFFF)
      end
      if ChangePosLogDisc then
        toggles['logcon'][0] = true
        ini.main.logcon = true
        save()
      end
      if ChangePosLogReg then
        toggles['logreg'][0] = true
        ini.main.logreg = true
        save()
      end
      if ChangePosFarChat then
        toggles['isfarchat'][0] = true
        ini.main.isfarchat = true
        save()
      end
      if ini.main.ischecker then
        drawClickableText(true, checker_font, (string.format('{1ECC00}Администрация онлайн [%s | AFK: %s]:', admins['online'] or 0, admins['afk'] or 0)), ini.main.posX, yRender-ini.font.offset, 0xFFFFFFFF, 0xFFFFFFFF, ini.font.align, false)
      end
      if #admins['list'] > 0 then
        local getActive = function(target)
        if ini.show.active and tonumber(admins['active'][target]) then
          local timer = os.time() - admins['active'][target]
          local color = ABGRtoStringRGB(ini.color['active'])
          local text = color .. ' - Актив: '
          local cmdString = timer >= tonumber(ini.main.maxActive) and text .. '{FF0000}' .. timer or text .. timer
          return cmdString
        end
        return ''
      end
      if ini.main.statswindow then
        stats_window[0] = true
      else
        stats_window[0] = false
      end
      local getAfk = function(target, count)
        if ini.show.afk and tonumber(count) then
          local color = ABGRtoStringRGB(ini.color['afk'])
          local text =  '{FFFFFF} - AFK: ' .. color
          local cmdString = count >= tonumber(ini.main.maxAfk) and text .. '{FF0000}' .. count or text .. count
          return cmdString
        end
        return ''
      end
      local getLvlColor = function(id, rb, lvl, name)
        local myId = select(2, sampGetPlayerIdByCharHandle(playerPed))
        if id == myId and rb then
          return ARGBtoStringRGB(rainbow(2))
        elseif ini.customcolor[name] ~= nil then
          return ABGRtoStringRGB(ini.customcolor[name])
        else
          return ABGRtoStringRGB(ini.color[lvl])
        end
      end
      if ini.main.ischecker then
        if #admins['list'] > 0 then
            for lvl = 8, 1, -1 do
              local block = admins['list'][lvl]
              if ini.level[lvl] then
                for i, admin in ipairs(block) do
                  local nick 		= admin[1]
                  local id 		= ini.show.id and ('(%s)'):format(admin[2]) or ''
                  local level 	= ini.show.level and (lvl >= 6 and ('%s+: '):format(lvl) or ('%s: '):format(lvl)) or ''
                  local afk  		= getAfk(nick, admin[3])
                  if tonumber(admin[4]) == selfid then
                    recon = admin[4] and (ini.show.recon and ABGRtoStringRGB(ini.color['recon']) .. (admin[4] >= 0 and (' - /re ЗА ВАМИ') or '') or '') 			or ''
                  else
                    recon = admin[4] and (ini.show.recon and ABGRtoStringRGB(ini.color['recon']) .. (admin[4] >= 0 and (' - /re %s'):format(admin[4]) or '') or '') 			or ''
                  end    
                  local reputate 	= admin[5] and (ini.show.reputate and ABGRtoStringRGB(ini.color['reputate']) .. (' - Rep: %s'):format(admin[5]) or '') 								or ''
                  local active 	= getActive(nick)
                  local note 		= ini.notes[admin[1]] and ABGRtoStringRGB(ini.color['note']) .. (' // %s'):format(ini.notes[admin[1]]:gsub('\n.*', ' ...')) or ''
                  local cmdString = ('%s%s%s%s%s%s%s%s'):format(level, nick, id, afk, recon, reputate, active, note)
                  local lvlColor 	= getLvlColor(admin[2], admins['showInfo'].selfMark[0], lvl, nick)
                  if nick == self.nick then
                    if selfrep ~= admin[5] and selfrep ~= 0 then
                      changeReput(admin[5]-selfrep)
                      if ini.main.repchange then
                        if math.sign(admin[5]-selfrep) == -1 then
                          sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Вам установлено: {FFFFFF}'..admin[5] - selfrep.." к репутации"..ABGRtoStringRGB(ini.style.color)..", возможный игрок который поставил последнюю реакцию: {FFFFFF}"..repNick.."["..repId.."]", -1)
                        else
                          sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Вам установлено: {FFFFFF}+'..admin[5] - selfrep.." к репутации"..ABGRtoStringRGB(ini.style.color)..", возможный игрок который поставил последнюю реакцию: {FFFFFF}"..repNick.."["..repId.."]", -1)
                        end
                        sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Репутации получено за день: {FFFFFF}'..ini.onDayReput.reput, -1)
                      end
                    end
                    selfrep = admin[5]
                    ini.main.lvl_adm = lvl
                  end
                  if drawClickableText(true, checker_font, lvlColor .. cmdString, ini.main.posX, yRender, 0xFFFFFFFF, 0xFFFF0000, ini.font.align, false) and isKeyDown(VK_MENU) and ini.main.editchecker then
                    fastmenuwindow[0] = true
                    fastmenu_id = ini.show.id and ('%s'):format(admin[2]) or ''
                    fastmenu_lvl = (lvl >= 6 and ('%s+'):format(lvl) or ('%s'):format(lvl)) or ''
                    if ini.customcolor_status[sampGetPlayerNickname(fastmenu_id)] == nil then
                      toggle_newcustomcolor = new.bool(false)
                    else
                      toggle_newcustomcolor = new.bool(ini.customcolor_status[sampGetPlayerNickname(fastmenu_id)])

                    end
                    
                    if ini.customcolor[sampGetPlayerNickname(fastmenu_id)] ~= nil then
                      local nc = imgui.ColorConvertU32ToFloat4(ini.customcolor[sampGetPlayerNickname(fastmenu_id)])
                      fc = new.float[4](nc.x, nc.y, nc.z, nc.w)
                    else
                      ini.customcolor[sampGetPlayerNickname(fastmenu_id)] = ini.color[lvl]
                      local nc = imgui.ColorConvertU32ToFloat4(ini.customcolor[sampGetPlayerNickname(fastmenu_id)])
                      fc = new.float[4](nc.x, nc.y, nc.z, nc.w)
                    end
                    
                  end
                  yRender=yRender+ini.font.offset
                end
              end
            end
          end
        end
      end
      if ini.main.isfarchat then
        local ac = imgui.ColorConvertU32ToFloat4(ini.style.farchat)
        ac = imgui.ColorConvertFloat4ToARGB(ac)
        local X = ini.main.farchatx
        local Y = ini.main.farchaty
        drawClickableText(true, farchat_font, "Дальний чат:", ini.main.farchatx, ini.main.farchaty-ini.main.farchatoffset, ac, ac, ini.font.farchatalign, false)
        for k,v in pairs(farchat) do
          drawClickableText(true, farchat_font, farchat[k], X, Y, ac, ac, ini.font.farchatalign, false)
          Y = Y + ini.main.farchatoffset
        end
      end
      maincolor = ABGRtoStringRGB(ini.style.color)
      if isKeyJustPressed(keyToggle) then
        ableclickwarp = true
        cursorEnabled = not cursorEnabled
        showCursor(cursorEnabled)
      end
      if cursorEnabled and ableclickwarp and not admin_menu[0] and not report_window[0] and not gps_window[0] and not lvl_window[0] and not cmd_window[0] and not color_window[0] and not question_window[0] and not fastmenuwindow[0] and not ChangePos and not ChangePosReconStats and not ChangePosRecon and not ChangePosStats and not ChangePosFlood and not ChangePosLogDisc and not getip_window[0] and not online_window[0] and not tp_window[0] and ini.main.is_clickwarp then
        local mode = sampGetCursorMode()
        if mode == 0 then
          showCursor(true)
        end
        local sx, sy = getCursorPos()
        local sw, sh = getScreenResolution()
        -- is cursor in game window bounds?
        if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
          local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
          local camX, camY, camZ = getActiveCameraCoordinates()
          -- search for the collision point
          local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
          if result and colpoint.entity ~= 0 then
            local normal = colpoint.normal
            local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
            local zOffset = 300
            if normal[3] >= 0.5 then zOffset = 1 end
            -- search for the ground position vertically down
            local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
              true, true, false, true, false, false, false)
            if result then
              pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
  
              local curX, curY, curZ  = getCharCoordinates(playerPed)
              local dist              = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
              local hoffs             = renderGetFontDrawHeight(font)
  
              sy = sy - 2
              sx = sx - 2
              renderFontDrawText(font, string.format("%0.2fm", dist), sx, sy - hoffs, 0xEEEEEEEE)
  
              local tpIntoCar = nil
              if colpoint.entityType == 2 then
                local car = getVehiclePointerHandle(colpoint.entity)
                if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
                  displayVehicleName(sx, sy - hoffs * 2, getNameOfVehicleModel(getCarModel(car)))
                  local color = 0xAAFFFFFF
                  if isKeyDown(VK_RBUTTON) and rInfo['id'] == "-1" then
                    tpIntoCar = car
                    color = 0xFFFFFFFF
                  end
                  renderFontDrawText(font2, "Зажмите правую кнопку мыши, чтобы сесть в транспорт", sx, sy - hoffs * 3, color)
                end
              end
  
              createPointMarker(pos.x, pos.y, pos.z)
  
              -- teleport!
              if isKeyDown(keyApply) then
                if tpIntoCar then
                  if not jumpIntoCar(tpIntoCar) then
                    -- teleport to the car if there is no free seats
                    if rInfo['id'] ~= "-1" then
                      sampSendChat("/plpos "..rInfo['id'].." "..pos.x.." "..pos.y.." "..pos.z)
                      ableclickwarp = not ableclickwarp
                    elseif rInfo['id'] == "-1" then
                      teleportPlayer(pos.x, pos.y, pos.z)
                      ableclickwarp = not ableclickwarp
                    end
                  end
                else
                  if isCharInAnyCar(playerPed) then
                    local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
                    local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
                    rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
                    pos = pos - norm * 1.8
                    pos.z = pos.z - 0.8
                  end
                  if rInfo['id'] ~= "-1" then
                    sampSendChat("/plpos "..rInfo['id'].." "..pos.x.." "..pos.y.." "..pos.z)
                    ableclickwarp = not ableclickwarp
                  elseif rInfo['id'] == "-1" then
                    teleportPlayer(pos.x, pos.y, pos.z)
                    ableclickwarp = not ableclickwarp
                  end
                end
                removePointMarker()
                showCursor(false)
              end
            end
          end
        end
      end
      memory.write(sampGetBase() + 643864, 37008, 2, true)
      if ChangePosFlood then
        floodot_window[0] = true
        floodtime = os.time()
      end
      wait(0)
      removePointMarker()
      if ini.main.checkerlead then
        checkerfrac_window[0] = true
      else
        checkerfrac_window[0] = false
      end
      if ini.main.infammo then
        memory.write(0x969178, 1, 1, true)
      else
        memory.write(0x969178, 0, 1, true)
      end
      if isKeyJustPressed(VK_RSHIFT) and not sampIsChatInputActive() and ini.main.airbreak then
          enAirBrake = not enAirBrake
          if enAirBrake then
              local posX, posY, posZ = getCharCoordinates(playerPed)
              airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
          end
      end
      if isKeyJustPressed(VK_SPACE) and not sampIsDialogActive() and not sampIsChatInputActive() and rInfo['id'] ~= "-1" then
        sampSendChat("/re "..rInfo['id'])
        local bool = sampIsCursorActive()
        ableclickwarp = false
        cursorEnabled = false
        showCursor(not bool)
        printStringNow("Updated",2000)
      end
      if isKeyJustPressed(VK_RBUTTON) and not sampIsDialogActive() and not sampIsChatInputActive() and rInfo['id'] ~= "-1" then
        sampSendChat("/re "..rInfo['id'])
        local bool = sampIsCursorActive()
        ableclickwarp = false
        cursorEnabled = false
        showCursor(not bool)
        printStringNow("Updated",2000)
      end
      if isKeyJustPressed(VK_ESCAPE) and not sampIsDialogActive() and not sampIsChatInputActive() and rInfo['id'] ~= "-1" then
        sampSendChat("/re "..rInfo['id'])
        local bool = sampIsCursorActive()
        ableclickwarp = false
        cursorEnabled = false
        showCursor(not bool)
        printStringNow("Updated",2000)
      end
      if enAirBrake then
          local cx, cy, _ = getActiveCameraCoordinates()
          local px, py, _ = getActiveCameraPointAt()
          local camDirection = math.atan2( (px-cx), (py-cy) ) * 180 / math.pi
          renderFontDrawText(my_font, 'AirBreak - '..ini.main.speed_airbrake, sizeX / 1.2, sizeY / 1.03, 0xFFFFFFFF)
          if isCharInAnyCar(playerPed) then 
            heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
            setCarHeading(storeCarCharIsInNoSave(playerPed), - camDirection)
          else 
            heading = getCharHeading(playerPed) 
            setCharHeading(PLAYER_PED, - camDirection)
          end
          local angle = getHeadingFromVector2d(px - cx, py - cy)
          if isCharInAnyCar(playerPed) then difference = 0.79 else difference = 1.0 end
          setCharCoordinates(playerPed, airBrkCoords[1], airBrkCoords[2], airBrkCoords[3] - difference)
          if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
              if isKeyDown(VK_W) then
              airBrkCoords[1] = airBrkCoords[1] + ini.main.speed_airbrake * math.sin(-math.rad(angle))
              airBrkCoords[2] = airBrkCoords[2] + ini.main.speed_airbrake * math.cos(-math.rad(angle))
              if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle) else setCarHeading(storeCarCharIsInNoSave(playerPed), angle) end
              elseif isKeyDown(VK_S) then
                  airBrkCoords[1] = airBrkCoords[1] - ini.main.speed_airbrake * math.sin(-math.rad(heading))
                  airBrkCoords[2] = airBrkCoords[2] - ini.main.speed_airbrake * math.cos(-math.rad(heading))
              end
              if isKeyDown(VK_A) then
                  airBrkCoords[1] = airBrkCoords[1] - ini.main.speed_airbrake * math.sin(-math.rad(heading - 90))
                  airBrkCoords[2] = airBrkCoords[2] - ini.main.speed_airbrake * math.cos(-math.rad(heading - 90))
              elseif isKeyDown(VK_D) then
                  airBrkCoords[1] = airBrkCoords[1] - ini.main.speed_airbrake * math.sin(-math.rad(heading + 90))
                  airBrkCoords[2] = airBrkCoords[2] - ini.main.speed_airbrake * math.cos(-math.rad(heading + 90))
              end
              if isKeyDown(VK_SPACE) then airBrkCoords[3] = airBrkCoords[3] + ini.main.speed_airbrake / 2.0 end
              if isKeyDown(VK_LSHIFT) and airBrkCoords[3] > -95.0 then airBrkCoords[3] = airBrkCoords[3] - ini.main.speed_airbrake / 2.0 end
              save()
          end
      end
      if ini.main.is_gm then
        setCharProofs(playerPed, true, true, true, true, true)
        
        writeMemory(0x96916E, 1, 1, false)
        if isCharInAnyCar(PLAYER_PED) then
          setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
        end
      else
        setCharProofs(playerPed, false, false, false, false, false)
        writeMemory(0x96916E, 1, 0, false)
        if isCharInAnyCar(PLAYER_PED) then
          setCarProofs(veh, false, false, false, false, false)
        end
      end
      if ini.main.rwh then
        for _, obj_hand in pairs(getAllObjects()) do
          local modelid = getObjectModel(obj_hand)
          local _obj = objs[modelid]
          if _obj then
            if isObjectOnScreen(obj_hand) then
              local x,y,z = getCharCoordinates(PLAYER_PED)
              local res,x1,y1,z1 = getObjectCoordinates(obj_hand)
              if res then
                local dist = math.floor(getDistanceBetweenCoords3d(x,y,z,x1,y1,z1))
                local c1,c2 = convert3DCoordsToScreen(x,y,z)
                local o1,o2 = convert3DCoordsToScreen(x1,y1,z1)
                local text = '{6400FF}'.._obj..'\n{C0C0C0}дистанция: '..dist..'m.'
                if dist < 150 then
                  renderFontDrawText(font,text,o1,o2,-1)
                end
              end
            end
          end
        end
      end
      if ini.main.checkerfriends then
        local X = ini.main.friendsx
        local Y = ini.main.friendsy
        renderFontDrawText(friends_font, "Игроки в сети:", ini.main.friendsx, ini.main.friendsy-ini.main.friendsoffset, -1)
        for b = 0, 1001 do
          if sampIsPlayerConnected(b) then name = sampGetPlayerNickname(b) end
          for i = 1, #ini.friends do
            if sampIsPlayerConnected(b) then
              if name == ini.friends[i] then
                friendStreamed, friendPed = sampGetCharHandleBySampPlayerId(b)
                friendsText = string.format("%s %s\n", friendsText, friendList)
                renderFontDrawText(friends_font, ini.friends[i].."["..b.."]", X, Y, -1)
                Y = Y + ini.main.friendsoffset
              end
            end
          end
        end
      end
    end
end

function cmd_test()
  if self.nick == "Alan_Butler" then
    sampAddChatMessage('1', -1)
  end
end

function flooder()
  while true do wait(0)
    if ini.main.ischecker then
      sampSendChat('/admins')
      wait(ini.main.delay_checker * 1000)
    end
  end
end

function flooderorgmembers()
  lua_thread.create(function()
    while true do
      wait(0)
      if sampGetGamestate() == 3 and not isGamePaused() and not afkstatus and not sampIsDialogActive() and not report_window[0] and ini.main.checkerlead then
        wait(5000)
        if not statusstopdialog and not statusstopdialog2 and not statusinvent and not sampIsDialogActive() then
          sampSendChat("/orgmembers")
        end
      elseif report_window[0] then
        lua_thread.create(function ()
          statusstopdialog2 = true

          while os.time() - os.time() < 2 do
            wait(0)
          end

          statusstopdialog2 = false
        end)
      end
    end
  end)
end

function time()
	startTime = os.time()                                               -- "Точка отсчёта"
    connectingTime = 0
    while true do
        wait(1000)
        nowTime = os.date("%H:%M:%S", os.time())
        if sampGetGamestate() == 3 then 								-- Игровой статус равен "Подключён к серверу" (Что бы онлайн считало только, когда, мы подключены к серверу)
	        sesOnline = sesOnline + 1 								-- Онлайн за сессию без учёта АФК
	        sesFull = os.time() - startTime 							-- Общий онлайн за сессию

	        ini.onDay.online = ini.onDay.online + 1 					-- Онлайн за день без учёта АФК
	        ini.onDay.full = dayFull + sesFull 						-- Общий онлайн за день

	        ini.onWeek.online = ini.onWeek.online + 1 					-- Онлайн за неделю без учёта АФК
	        ini.onWeek.full = weekFull + sesFull 					-- Общий онлайн за неделю

          local today = tonumber(os.date('%w', os.time()))
          ini.myWeekOnline[today] = ini.onDay.full

          connectingTime = 0
	    else
        connectingTime = connectingTime + 1                         -- Вермя подключения к серверу
	    	startTime = startTime + 1									-- Смещение начала отсчета таймеров
	    end
    end
end

function afktime()
  while true do
    wait(1000)
    if isGamePaused() then
      sesAfk = sesAfk + 1
      ini.onDay.afk = ini.onDay.afk + 1
      ini.onWeek.afk = ini.onWeek.afk + 1
    end
  end
end

function autoSave()
	while true do 
		wait(60000) -- сохранение каждые 60 секунд
		save()
	end
end

function addreport()
  sesreport = sesreport + 1
  ini.onDayReport.report = ini.onDayReport.report + 1
  ini.onWeekReport.report = ini.onWeekReport.report + 1
  local today = tonumber(os.date('%w', os.time()))
  ini.myWeekReport[today] = ini.onDayReport.report
  save()
end

function changeReput(amount)
  sesreput = sesreput + amount
  ini.onDayReput.reput = ini.onDayReput.reput + amount
  ini.onWeekReput.reput = ini.onWeekReput.reput + amount
  local today = tonumber(os.date('%w', os.time()))
  ini.myWeekReput[today] = ini.onDayReput.reput
  save()
end

function checkbinds()
  while true do
    wait(0)

    if string.match(ini.binds.wh, ",") then
      local b1, b2 = string.match(ini.binds.wh, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        sampSendChat("/wallhack")
      end
    end
    if wasKeyPressed(ini.binds.wh) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
      sampSendChat("/wallhack")
    end
    if string.match(ini.binds.whcar, ",") then
      local b1, b2 = string.match(ini.binds.whcar, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        ini.main.whcar = not ini.main.whcar
        save()
      end
    end
    if wasKeyPressed(ini.binds.whcar) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
      ini.main.whcar = not ini.main.whcar
      save()
    end
    if string.match(ini.binds.fastnak, ",") then
      local b1, b2 = string.match(ini.binds.fastnak, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        fastnak_window[0] = true
      end
    end
    if wasKeyPressed(ini.binds.fastnak) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
      fastnak_window[0] = true
    end
    if isKeyJustPressed(ini.binds.acceptform) and not afktest and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not sampIsScoreboardOpen() then
      prinalforma = true
    end
    if isKeyJustPressed(ini.binds.bind_floodot) and not admin_menu[0] and not report_window[0] and not gps_window[0] and not lvl_window[0] and not cmd_window[0] and not color_window[0] and not question_window[0] and not fastmenuwindow[0] and not getip_window[0] and not online_window[0] and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsScoreboardOpen() then
      floodot = not floodot
      if floodot then
        floodot_window[0] = true
        floodtime = os.time()
        skipped = 0
      else
        floodot_window[0] = false
        skipped = 0
      end
    end
    if string.match(ini.binds.reoff, ",") then
      local b1, b2 = string.match(ini.binds.reoff, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        sampSendChat("/reoff")
        showCursor(false)
      end
    end
    if isKeyJustPressed(ini.binds.reoff) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
      sampSendChat("/reoff")
      showCursor(false)
    end
    if string.match(ini.binds.noviolations, ",") then
      local b1, b2 = string.match(ini.binds.noviolations, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        sampSendChat("/pm "..repId.." 1 Игрок на которого вы пожаловались, не нарушает.")
      end
    end
    if isKeyJustPressed(ini.binds.noviolations) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
      sampSendChat("/pm "..repId.." 1 Игрок на которого вы пожаловались, не нарушает.")
    end
    if string.match(ini.binds.jpmyself, ",") then
      local b1, b2 = string.match(ini.binds.jpmyself, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        sampSendChat("/jp")
      end
    end
    if isKeyJustPressed(ini.binds.jpmyself) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
      sampSendChat("/jp")
    end
    if string.match(ini.binds.slapmyself, ",") then
      local b1, b2 = string.match(ini.binds.slapmyself, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        sampSendChat("/slap "..id.." 1")
      end
    end
    if isKeyJustPressed(ini.binds.slapmyself) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
      sampSendChat("/slap "..id.." 1")
    end
    if string.match(ini.binds.last_rep, ",") then
      local b1, b2 = string.match(ini.binds.last_rep, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        lua_thread.create(function()
          sampSetChatInputEnabled(true)
          wait(1)
          sampSetChatInputText("/pm "..repId.." 0 ")
        end)
      end
    end
    if isKeyJustPressed(ini.binds.last_rep) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
      lua_thread.create(function()
        sampSetChatInputEnabled(true)
        wait(1)
        sampSetChatInputText("/pm "..repId.." 0 ")
      end)
    end
    if string.match(ini.binds.bind_ot, ",") then
      local b1, b2 = string.match(ini.binds.bind_ot, "(%d+),(%d+)")
      if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
        sampSendChat("/ot")
      end
    end
    if isKeyJustPressed(ini.binds.bind_ot) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
      sampSendChat("/ot")
    end
  end
end

function COMMANDS()
  sampRegisterChatCommand('hgps', function() gps_window[0] = not gps_window[0] end)
  sampRegisterChatCommand('hlvl', function() lvl_window[0] = not lvl_window[0] end)
  sampRegisterChatCommand('hcmd', function() cmd_window[0] = not cmd_window[0] end)
  sampRegisterChatCommand('hcolor', function() color_window[0] = not color_window[0] end)
  sampRegisterChatCommand('hquestion', function() question_window[0] = not question_window[0] end)
  sampRegisterChatCommand('online', function() online_window[0] = not online_window[0] end)
  sampRegisterChatCommand('update', function() update_window[0] = not update_window[0] end)
  sampRegisterChatCommand('toolsoff', function() thisScript:unload() end)
  sampRegisterChatCommand('amenu', function() admin_menu[0] = not admin_menu[0] end)
  sampRegisterChatCommand('spcarall', cmd_spcarall)
  sampRegisterChatCommand('rslap', cmd_rslap)
  sampRegisterChatCommand('tpr', cmd_tpr)
  sampRegisterChatCommand('re', cmd_re)
  sampRegisterChatCommand('spawnset', function()
    local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
  
    sampAddChatMessage(tag.."Вы установили точку спавна.", -1)
  
    spawncord = {
      playerX = playerX,
      playerY = playerY,
      playerZ = playerZ
    }
    ini.spcoord = spawncord
    save()
  end)
  sampRegisterChatCommand("orgmembers", function ()
    if ini.main.checkerlead then
      statusorgmembers = true

      sampSendChat("/orgmembers")
    else
      sampSendChat("/orgmembers")
    end
  end)
  sampRegisterChatCommand("arep", function()
    sampSendChat("/flip "..selfid)
  end)
  sampRegisterChatCommand("addplayer", function(args)
    if #args > 0 then
      table.insert(ini.friends, args)
      sampAddChatMessage(tag..'Игрок '..args.." успешно добавлен в чекер.", -1)
    else
      sampAddChatMessage(tag_err..'Используйте: /addplayer (ник)', -1)
    end
  end)
  sampRegisterChatCommand('tpm', function()
    local result, mx, my, mz = SearchMarker(getCharCoordinates(PLAYER_PED))
  
      if result then
        sendClickMap(mx, my, mz)
      else
        sampAddChatMessage(tag_err.."Маркера на карте нет!", -1)
      end
  end)
  sampRegisterChatCommand('addrep', cmd_addrep)
  sampRegisterChatCommand('test', cmd_test)
  --   sampRegisterChatCommand("gang",function()
  --     local gang = IsPlayerGangZone()
  --     if #gang > 0 then
  --         for _, val in ipairs(gang) do
  --             sampAddChatMessage(val.color,-1)
  --         end
  --     end
  -- end)
  sampRegisterChatCommand('pr', function()
    pr_window[0] = not pr_window[0]
  end)

  sampRegisterChatCommand('admins', CMD_admins)
  sampRegisterChatCommand('amember', cmd_amember)
  sampRegisterChatCommand('tp', cmd_tp)
  sampRegisterChatCommand('askin', cmd_askin)
  sampRegisterChatCommand('pveh', cmd_aveh)
  sampRegisterChatCommand('agun', cmd_agun)
  sampRegisterChatCommand('getip', function(arg)
            if os.time() - val < 5 then
              local asd = (val - os.time())*-1
              sampAddChatMessage(tag_err..'Повторите команду через: '..asd.." секунду(-ы).", -1)
              return false
            else
              getip_window[0] = false
              val = os.time()
              sampSendChat("/getip "..arg)
            end
  end)
end

--                  Имгуи Окна

  local updateWindow = imgui.OnFrame(
    function() return update_window[0] end,
    function(self)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX/2, sizeY/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(600, 600))
      imgui.Begin("##updadte", nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
      imgui.SetCursorPos( imgui.ImVec2(170, 10) ) 
      imgui.BeginChild('##TitleUpdatewindow', imgui.ImVec2(600, 40), false)
        imgui.PushFont(imFont[25])
        imgui.CenterTextColoredSameLine(mc, u8('Обновление'))
        imgui.SameLine()
        imgui.Text(u8('| Версия '..thisScript.version))
        imgui.PopFont()
      imgui.End()
      imgui.SetCursorPos(imgui.ImVec2(10,20))
      imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
      
      imgui.BeginChild('##WorkSpaceUpdateWindow', imgui.ImVec2(600, 560), false, imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        imgui.NewLine()
        imgui.Separator()
        imgui.NewLine()
        imgui.PushFont(imFont[20])
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Добавлен Money Separator в здании ЦБ")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Добавил Страховую Компания в /amember и /tp")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Пофикшен баг во время рекона за транспортом с ид 400/611")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Пофикшена команда /re")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Настроил цвета в реконе")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Пофикшен чекер организаций")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Пофикшен подсчет времени в АФК")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Пофикшены формы")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Пофикшено отображение времени в окне статистики")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Пофикшен Контроль AFK")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Добавлены ID транспорта в ВХ")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Исправлен краш при неизвестном ID Транспорта")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Исправлен сбив репорта в реконе")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Добавлен дальний чат")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Исправлены цвета логов")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" Добавлена команда /pr")
        imgui_text_wrapped(fa.ICON_FA_CHECK..u8" ")
        imgui.PopFont()
        imgui.PopStyleVar()
      imgui.End()
      imgui.SetCursorPos(imgui.ImVec2(10,550))
      imgui.Separator()
      imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
      imgui.BeginChild('##CloseButtonUpdateWindow', imgui.ImVec2(600, 40), false, imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        if imgui.ButtonWithSettings(u8'Закрыть окно', {rounding = 5, color = mc}, imgui.ImVec2(583,40)) then
          update_window[0] = false
          ini.main.updateshown = true
          save()
        end
        imgui.PopStyleVar()
      imgui.End()
    end
  )

  local prWindow = imgui.OnFrame(
    function() return pr_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(800, 600))
      imgui.Begin(fa.ICON_FA_PENCIL_ALT..u8" Правила##asd", pr_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
      imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8"Добавить раздел                                 ").x) / 2)
      if imgui.Button(u8"Редактировать правила", imgui.ImVec2(200, 20)) then
        imgui.OpenPopup(u8'Редактирование правил')
      end
      if imgui.BeginPopupModal(u8'Редактирование правил', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize) then
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8"Добавить раздел                                 ").x) / 2)
        imgui.CenterTextColored(mc, u8"Создать раздел")
        if imgui.IsItemClicked() then
          imgui.BeginTooltip()
          local newHeader = {
            name = u8("Новый раздел "..#rulesJs+1),
            text = u8("Текст")
          }
          rulesJs[#rulesJs+1] = newHeader
          local status, code = json('rules\\rules.json'):Save(rulesJs)
          imgui.EndTooltip()
        end
        imgui.Text(u8"                                                                                                                                                                                                              ")
        for i=1, #rulesJs do
          if imgui.Button(rulesJs[i]['name'], imgui.ImVec2(-1,0)) then
            imgui.OpenPopup(rulesJs[i]['name'])
            editrule = new.char[10000](""..rulesJs[i]['text'])
            editrulename = new.char[256](""..rulesJs[i]['name'])
          end
          if imgui.BeginPopupModal(rulesJs[i]['name'], false, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize) then
            imgui.PushItemWidth(-1)
            imgui.InputText("##editrulename", editrulename, sizeof(editrulename))
            imgui.PopItemWidth()
            imgui.NewLine()
            imgui.InputTextMultiline("##editrule", editrule, 10000, imgui.ImVec2(-1,800))
            if imgui.Button(u8"Сохранить", imgui.ImVec2(350,0)) then
              rulesJs[i]['name'] = str(editrulename)
              rulesJs[i]['text'] = str(editrule)
              local status, code = json('rules\\rules.json'):Save(rulesJs)
              imgui.CloseCurrentPopup()
            end
            imgui.SameLine()
            if imgui.Button(u8"Удалить", imgui.ImVec2(350, 0)) then
              imgui.CloseCurrentPopup()
              rulesJs[i] = nil
              local status, code = json('rules\\rules.json'):Save(rulesJs)
            end
            imgui.EndPopup()
          end
        end
        imgui.Text(u8"                                                                                                                                                                                                              ")
        if imgui.Button(u8"Закрыть", imgui.ImVec2(-1,0)) then
          imgui.CloseCurrentPopup()
        end
        imgui.EndPopup()
      end
      imgui.Separator()
      for i=1, #rulesJs do
        if imgui.CollapsingHeader(rulesJs[i]['name']) then
          imgui_text_wrapped(rulesJs[i]['text'])
        end
      end
      imgui.End()
    end
  )

  local report = imgui.OnFrame(
      function() return report_window[0] end,
      function(player)
          imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
          imgui.SetNextWindowSize(imgui.ImVec2(500, 350), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_FA_PAPER_PLANE..u8" Ответ на репорт ##asd", nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
          imgui.Text(u8'Репорт от '..repNick..'['..repId..']')
          imgui.SameLine()
          imgui.TextDisabled(u8'<< Следить')
          if imgui.IsItemClicked() then
              imgui.BeginTooltip();
              sampSendChat("/re "..repId)
              rInfo['id'] = repId
              imgui.EndTooltip();
          end
          if imgui.IsItemHovered() then
            imgui.BeginTooltip();
            imgui.TextUnformatted(u8"Нажмите для слежки");
            imgui.EndTooltip();
          end
          imgui.Separator()
          imgui.PushFont(imFont[13])
          --repText
          local firstline = {}
          local secondline = {}
          local thirdline = {}

          for i = 0, #repText + 1, 1 do
            firstline[i] = repText:sub(i, i)
          end

          zz = 0

          for i, v in pairs(firstline) do
            if zz >= 69 or i == #firstline then
              table.insert(secondline, table.concat(thirdline, ""))

              thirdline = {}
              zz = 0
            end

            zz = zz + 1

            table.insert(thirdline, v)
          end

          for i, v in pairs(secondline) do
            if i == #secondline then
              tiretext = ""
            else
              tiretext = "-"
            end

            imgui.Text(u8(v .. tiretext))
	        end
          imgui.PopFont()
          imgui.Separator()
          if len(str(inputs['report_window_answer'])) > 69 then
            local lenght = len(str(inputs['report_window_answer']))
            imgui.CenterTextColored(imgui.ImVec4(255, 0, 0, 1), u8"Ответ должен содержать не более 85ти символов! ["..lenght.."/85]")
          end
          imgui.PushItemWidth(424)
          imgui.InputText('##report_window_answer', inputs['report_window_answer'], sizeof(inputs['report_window_answer']))
          imgui.PopItemWidth()
          imgui.Separator() -- кнопки
          if imgui.Button(fa.ICON_FA_ROBOT..u8" Слежка за наруш",imgui.ImVec2(138,23)) then
            if string.match(repText, "%d+") then
              if not sampIsPlayerConnected(string.match(repText, "%d+")) then
                sampSendDialogResponse(1334, 1, 0, "Игрока с данным ID нет на сервере.")
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                infoReport("Игрока с данным ID нет на сервере.")
                addreport()
                report_window[0] = false
              end
              if lost_report then
                local spyingreport = ini.main.spyingreport
                if string.find(spyingreport, "{rep_nick}") then
                  spyingreport = string.gsub(spyingreport, "{rep_nick}", repNick)
                elseif string.find(spyingreport, "{rep_id}") then
                  spyingreport = string.gsub(spyingreport, "{rep_id}", repId)
                elseif string.find(spyingreport, "{my_id}") then
                  spyingreport = string.gsub(spyingreport, "{my_id}", id)
                elseif string.find(spyingreport, "{my_nick}") then
                  spyingreport = string.gsub(spyingreport, "{my_nick}", self.nick)
                end
                sampSendChat("/pm "..repId.." 1 "..spyingreport)
                lost_report = false
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                sampSendChat("/re "..string.match(repText, "%d+"))
                rInfo['id'] = string.match(repText, "%d+")
                infoReport(spyingreport)
                addreport()
                report_window[0] = false
              else
                local spyingreport = ini.main.spyingreport
                if string.find(spyingreport, "{rep_nick}") then
                  spyingreport = string.gsub(spyingreport, "{rep_nick}", repNick)
                elseif string.find(spyingreport, "{rep_id}") then
                  spyingreport = string.gsub(spyingreport, "{rep_id}", repId)
                elseif string.find(spyingreport, "{my_id}") then
                  spyingreport = string.gsub(spyingreport, "{my_id}", id)
                elseif string.find(spyingreport, "{my_nick}") then
                  spyingreport = string.gsub(spyingreport, "{my_nick}", self.nick)
                end
                sampSendDialogResponse(1334, 1, 0, spyingreport)
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                sampSendChat("/re "..string.match(repText, "%d+"))
                rInfo['id'] = string.match(repText, "%d+")
                infoReport(spyingreport)
                addreport()
                report_window[0] = false
              end
            else
              sampAddChatMessage(tag_err.."ID не найден в тексте репорта!", -1)
            end
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_PEOPLE_CARRY..u8" Помочь автору",imgui.ImVec2(138,23)) then
            if not sampIsPlayerConnected(repId) then
              sampSendDialogResponse(1334, 1, 0, "Игрока с данным ID нет на сервере.")
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
              infoReport("Игрока с данным ID нет на сервере.")
              addreport()
              report_window[0] = false
            end
            if lost_report then
              local helpreport = ini.main.helpreport
              if string.find(helpreport, "{rep_nick}") then
                helpreport = string.gsub(helpreport, "{rep_nick}", repNick)
              elseif string.find(helpreport, "{rep_id}") then
                helpreport = string.gsub(helpreport, "{rep_id}", repId)
              elseif string.find(helpreport, "{my_id}") then
                helpreport = string.gsub(helpreport, "{my_id}", id)
              elseif string.find(helpreport, "{my_nick}") then
                helpreport = string.gsub(helpreport, "{my_nick}", self.nick)
              end
              sampSendChat("/pm "..repId.." 1 "..helpreport)
              lost_report = false
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
              sampSendChat("/re "..repId)
              rInfo['id'] = repId
              infoReport(helpreport)
              addreport()
              report_window[0] = false
            else
              local helpreport = ini.main.helpreport
              if string.find(helpreport, "{rep_nick}") then
                helpreport = string.gsub(helpreport, "{rep_nick}", repNick)
              elseif string.find(helpreport, "{rep_id}") then
                helpreport = string.gsub(helpreport, "{rep_id}", repId)
              elseif string.find(helpreport, "{my_id}") then
                helpreport = string.gsub(helpreport, "{my_id}", id)
              elseif string.find(helpreport, "{my_nick}") then
                helpreport = string.gsub(helpreport, "{my_nick}", self.nick)
              end
              sampSendDialogResponse(1334, 1, 0, helpreport)
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
              sampSendChat("/re "..repId)
              rInfo['id'] = repId
              infoReport(helpreport)
              addreport()
              report_window[0] = false
            end
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_COMMENTS..u8" Переслать в /a чат",imgui.ImVec2(138,23)) then
            local text = ("/a [Репорт] "..repNick.."["..repId.."]: "..repText)
            if (51 + text:len()) > 143 then
              sampAddChatMessage(tag_err..'Размер сообщений больше допустимого.', -1)
              return false
            else
              sampSendChat(text)
            end
          end
          if imgui.Button(fa.ICON_FA_MAP_MARKED..u8" Помощь по GPS",imgui.ImVec2(138,23)) then
            gps_window[0] = true
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_ADDRESS_BOOK..u8" LVL'a по работ",imgui.ImVec2(138,23)) then
            lvl_window[0] = true
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_STICKY_NOTE..u8" Список команд",imgui.ImVec2(138,23)) then
            cmd_window[0] = true
          end
          if imgui.Button(fa.ICON_FA_PALETTE..u8" Таблица цветов",imgui.ImVec2(138,23)) then
            color_window[0] = true
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_BOOK_OPEN..u8" Частые вопросы",imgui.ImVec2(138,23)) then
            question_window[0] = true
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_HANDSHAKE..u8" Передать адм реп",imgui.ImVec2(138,23)) then
            if lost_report then
              local givereport = ini.main.givereport
              if string.find(givereport, "{rep_nick}") then
                givereport = string.gsub(givereport, "{rep_nick}", repNick)
              elseif string.find(givereport, "{rep_id}") then
                givereport = string.gsub(givereport, "{rep_id}", repId)
              elseif string.find(givereport, "{my_id}") then
                givereport = string.gsub(givereport, "{my_id}", id)
              elseif string.find(givereport, "{my_nick}") then
                givereport = string.gsub(givereport, "{my_nick}", self.nick)
              end
              sampSendChat("/pm "..repId.." 1 "..givereport)
              lost_report = false
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
              infoReport(givereport)
              sampSendChat("/a [Репорт] "..repNick.."["..repId.."]: "..repText)
              addreport()
              report_window[0] = false
            else
              local givereport = ini.main.givereport
              if string.find(givereport, "{rep_nick}") then
                givereport = string.gsub(givereport, "{rep_nick}", repNick)
              elseif string.find(givereport, "{rep_id}") then
                givereport = string.gsub(givereport, "{rep_id}", repId)
              elseif string.find(givereport, "{my_id}") then
                givereport = string.gsub(givereport, "{my_id}", id)
              elseif string.find(givereport, "{my_nick}") then
                givereport = string.gsub(givereport, "{my_nick}", self.nick)
              end
              sampSendDialogResponse(1334, 1, 0, givereport)
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
              infoReport(givereport)
              sampSendChat("/a [Репорт] "..repNick.."["..repId.."]: "..repText)
              addreport()
              report_window[0] = false
            end
          end
          imgui.Separator()

          reportenter = 0

          for k, v in pairs(ini.cbName) do
            if imgui.Button(tostring(v), imgui.ImVec2(138,23)) then
              if ini.cbToggle[k] then
                if ini.cbContent[k] ~= "" then
                  sampSendDialogResponse(1334, 1, 0, u8:decode(ini.cbContent[k]))
                  infoReport(u8:decode(ini.cbContent[k]))
                  imgui.StrCopy(inputs['report_window_answer'], "")
                  sampCloseCurrentDialogWithButton(0)
                  addreport()
                  report_window[0] = false
                else
                  sampAddChatMessage(tag_err.."Введите ответ. Либо закройте репорт.", -1)
                end
              elseif not ini.cbToggle[k] then
                imgui.StrCopy(inputs['report_window_answer'], ini.cbContent[k])
              end
            end

            reportenter = reportenter + 1

            if reportenter == 3 then
              reportenter = 0
            elseif #ini.cbName ~= k then
              imgui.SameLine()
            end
          end
          if #ini.cbName > 0 then
            imgui.Separator()
          end

          if imgui.ButtonWithSettings(u8'Отправить', {rounding = 5, color = imgui.ImVec4(1, 0.3, 0.3, 1)}, imgui.ImVec2(138,23)) then
            if len(str(inputs['report_window_answer'])) < 1 then
              return false
            elseif len(str(inputs['report_window_answer'])) > 85 then
              sampAddChatMessage(tag_err..'Длина ответа должна быть не более 85ти символов!', -1)
              return false
            end
            if lost_report then
              lua_thread.create(function()
                wait(100)
                sampSendChat("/pm "..repId.." 1 "..u8:decode(str(inputs['report_window_answer'])))
                infoReport(u8:decode(str(inputs['report_window_answer'])))
                lost_report = false
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                addreport()
              end)
              report_window[0] = false
            else
              lua_thread.create(function()
                wait(100)
                sampSendDialogResponse(1334, 1, 0, u8:decode(str(inputs['report_window_answer'])))
                infoReport(u8:decode(str(inputs['report_window_answer'])))
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                addreport()
              end)
              report_window[0] = false
            end
          end
          
          imgui.SameLine(294)
          if imgui.ButtonWithSettings(u8'Закрыть', {rounding = 5, color = imgui.ImVec4(1, 0.3, 0.3, 1)}, imgui.ImVec2(138,23)) then
            lua_thread.create(function()
              wait(100)
              sampSendDialogResponse(1334, 0, 0, "")
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
            end)
            lost_report = false
            report_window[0] = false
          end
          
          imgui.End()
      end
  )

  local gpsWindow = imgui.OnFrame(
    function() return gps_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(500, 600))
      imgui.Begin(fa.ICON_FA_MAP_MARKED..u8" Помощь по GPS ", gps_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.PushItemWidth(490)
      imgui.NewInputText('##SearchBar', inputs['finding_gps'], 490, u8'Поиск по списку', 2)
      imgui.PopItemWidth()
      for i = 1, #gpsInfo do
        if #str(inputs['finding_gps']) == 0 or #str(inputs['finding_gps']) > 0 and string.nlower(gpsInfo[i]):find(u8:decode(str(inputs['finding_gps'])), nil, true) or #str(inputs['finding_gps']) > 0 and string.nupper(gpsInfo[i]):find(u8:decode(str(inputs['finding_gps'])), nil, true) or #str(inputs['finding_gps']) > 0 and gpsInfo[i]:find(u8:decode(str(inputs['finding_gps'])), nil, true) then
          if imgui.Button(u8(gpsInfo[i]), imgui.ImVec2(490, 25)) then
            gpsbutton(i)
          end
        end
      end
      imgui.End()
    end
  )

  local lvlWindow = imgui.OnFrame(
    function() return lvl_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(220, 400))
      imgui.Begin(fa.ICON_FA_ADDRESS_BOOK..u8" Помощь по GPS ", lvl_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
      imgui.Text(u8"Таксист - 1 LVL")
      imgui.Text(u8"Водитель автобуса - 2 LVL")
      imgui.Text(u8"Механик - 3 LVL")
      imgui.Text(u8"Мусорщик - 3 LVL")
      imgui.Text(u8"Пожарный - 3 LVL")
      imgui.Text(u8"Металлоломщик - 4 LVL")
      imgui.Text(u8"Развозчик продуктов - 4 LVL")
      imgui.Text(u8"Машинист крана - 5 LVL")
      imgui.Text(u8"Дальнобойщик - 5 LVL")
      imgui.Text(u8"Продавец хот-догов - 5 LVL")
      imgui.Text(u8"Инкассатор - 6 LVL")
      imgui.Text(u8"Адвокат - 7 LVL")
      imgui.Text(u8"Водитель трамвая - 8 LVL")
      imgui.Text(u8"Работник налоговой - 10 LVL")
      imgui.Text(u8"Ремонтник дорог - 10 LVL")
      imgui.Text(u8"Нефтевышка - 10 LVL")
      imgui.Text(u8"Главный фермер - 15 LVL")
      imgui.Text(u8"Руководитель грузчиков - 15 LVL")
      imgui.Text(u8"Руководитель завода - 15 LVL")
      imgui.Text(u8"Машинист поезда - 15 LVL")
      imgui.Text(u8"Пилот - 19 LVL")
      imgui.End()
    end
  )

  local cmdWindow = imgui.OnFrame(
    function() return cmd_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(600,600), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_STICKY_NOTE..u8" Список команд ", cmd_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.PushItemWidth(590)
      imgui.NewInputText('##SearchBarCmd', inputs['finding_cmd'], 590, u8'Поиск по списку', 2)
      imgui.PopItemWidth()
      for i = 1, #cmdInfo do
        if #str(inputs['finding_cmd']) == 0 or #str(inputs['finding_cmd']) > 0 and string.nlower(cmdInfo[i]):find(u8:decode(str(inputs['finding_cmd'])), nil, true) or #str(inputs['finding_cmd']) > 0 and string.nupper(cmdInfo[i]):find(u8:decode(str(inputs['finding_cmd'])), nil, true) or #str(inputs['finding_cmd']) > 0 and cmdInfo[i]:find(u8:decode(str(inputs['finding_cmd'])), nil, true) then
          if imgui.Button(u8(cmdInfo[i]), imgui.ImVec2(590, 25)) then
            cmdbutton(i)
          end
        end
      end
      imgui.End()
    end
  )

  local colorWindow = imgui.OnFrame(
    function() return color_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(1510,736), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_PALETTE..u8" Таблица цветов ", color_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.Image(img, imgui.ImVec2(1500,700))
      imgui.End()
    end
  )

  local questionWindow = imgui.OnFrame(
    function() return question_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(700,600))
      imgui.Begin(fa.ICON_FA_BOOK_OPEN..u8" Частые вопросы", question_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.NewInputText('##SearchBarQuestion', inputs['finding_question'], 690, u8'Поиск по списку', 2)
      for i = 1, #questionInfo do
        if #str(inputs['finding_question']) == 0 or #str(inputs['finding_question']) > 0 and string.nlower(questionInfo[i]):find(u8:decode(str(inputs['finding_question'])), nil, true) or #str(inputs['finding_question']) > 0 and string.nupper(questionInfo[i]):find(u8:decode(str(inputs['finding_question'])), nil, true) or #str(inputs['finding_question']) > 0 and questionInfo[i]:find(u8:decode(str(inputs['finding_question'])), nil, true) then
          if imgui.Button(u8(questionInfo[i]), imgui.ImVec2(690, 25)) then
            questionbutton(i)
          end
        end
      end
      imgui.End()
    end
  )

  local fastmenuWindow = imgui.OnFrame(
    function() return fastmenuwindow[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 1.5, sizeY / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(200, 220))
      imgui.Begin("##fasfdffgfmenu", fastmenuwindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
      local c = imgui.ImVec4(fc[0], fc[1], fc[2], fc[3]) 
      ini.customcolor[sampGetPlayerNickname(fastmenu_id)] = imgui.ColorConvertFloat4ToU32(c)
      save()
      imgui.SetCursorPos( imgui.ImVec2(15, 10) ) 
      imgui.BeginChild('##TitleFastmenu', imgui.ImVec2(150, 40), false)
        imgui.PushFont(imFont[13])
        imgui.TextColored(mc, u8('Быстрое меню'))
        imgui.SameLine()
        imgui.Text(u8('| '..sampGetPlayerNickname(fastmenu_id)))
        imgui.PopFont()
      imgui.End()
      imgui.SetCursorPos( imgui.ImVec2(170, 10) )
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1,1,1,0))
      imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1,1,1,0))
      imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1,1,1,0))
      if imgui.Button(fa.ICON_FA_TIMES,imgui.ImVec2(23,23)) then
        fastmenuwindow[0] = false
      end
      imgui.PopStyleColor(3)
      imgui.SetCursorPos(imgui.ImVec2(10,20))
      imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
      
      imgui.BeginChild('##WorkSpaceFastmenu', imgui.ImVec2(190, 400), false, imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        imgui.NewLine()
        if imgui.Button(u8"Следить", imgui.ImVec2(180,20)) then
          sampSendChat("/re "..fastmenu_id)
          rInfo['id'] = fastmenu_id
          fastmenuwindow[0] = false
        end
        if imgui.Button(u8"Написать в PM", imgui.ImVec2(180,20)) then
          lua_thread.create(function()
            fastmenuwindow[0] = false
            sampSetChatInputEnabled(true)
            wait(1)
            sampSetChatInputText("/pm "..fastmenu_id.." 1 ")
          end)
        end
        if imgui.Button(u8"Слапнуть", imgui.ImVec2(180,20)) then
          sampSendChat("/slap "..fastmenu_id.." 1")
          fastmenuwindow[0] = false
        end
        if imgui.Button(u8"Репорт", imgui.ImVec2(180,20)) then
          sampSendChat("/pm "..fastmenu_id.." 1 ОТВЕЧАЕМ НА РЕПОРТ!!!")
          fastmenuwindow[0] = false
        end
        imgui.PushFont(imFont[13])
        imgui.Text(u8'Цвет админа: ')
        imgui.SameLine()
        addons.ToggleButton("##sdfjun", toggle_newcustomcolor)
        imgui.SameLine()
        if toggle_newcustomcolor[0] then
          imgui.ColorEdit4("##customcolornick", fc, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha)
        else
          ini.customcolor[sampGetPlayerNickname(fastmenu_id)] = ini.color[fastmenu_lvl]
          save()
        end
        ini.customcolor_status[sampGetPlayerNickname(fastmenu_id)] = toggle_newcustomcolor[0]
        save()
        imgui.NewLine()
        imgui.Separator()
        imgui.NewLine()
        if ini.notes[sampGetPlayerNickname(fastmenu_id)] then
          imgui.StrCopy(notesAdmin, u8(ini.notes[sampGetPlayerNickname(fastmenu_id)]))
        else
          imgui.StrCopy(notesAdmin, '')
        end
        if #str(notesAdmin) == 0 then
          ini.notes[sampGetPlayerNickname(fastmenu_id)] = nil
          save()
        end
        imgui.PushItemWidth(180)
        if imgui.InputTextWithHint("##notesAdmin", u8"Заметки", notesAdmin, sizeof(notesAdmin)) then
          ini.notes[sampGetPlayerNickname(fastmenu_id)] = u8:decode(str(notesAdmin))
          save()
        end
        imgui.CenterTextColored(imgui.ImVec4(71, 71, 71, 0.5), u8"очистить")
        if imgui.IsItemClicked() then
          imgui.BeginTooltip()
          ini.notes[sampGetPlayerNickname(fastmenu_id)] = ""
          save()
          imgui.EndTooltip()
        end
        imgui.PopFont()
      imgui.End()
      imgui.PopStyleVar()
    end
  ) 

  local getipWindow = imgui.OnFrame(
    function() return getip_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(600, 235), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_ADDRESS_CARD..u8" Проверка IP##ffdd", getip_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
      imgui.PushFont(imFont[13])
      imgui.TextColored(mc, u8"[Ник] ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), string.format("%s", ipnick))
      imgui.Hint("ipnick", u8"Нажмите для копирования")
      if imgui.IsItemClicked() then
        setClipboardText(ipnick)
        sampAddChatMessage(tag.."Скопировано в буфер обмена.", -1)
      end
      imgui.Separator()
      imgui.TextColored(mc, u8"Reg-IP ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), string.format("[%s] ", rdata[1]["query"]))
      imgui.Hint("getipip1", u8"Нажмите для копирования")
      if imgui.IsItemClicked() then
        setClipboardText(rdata[1]['query'])
        sampAddChatMessage(tag.."Скопировано в буфер обмена.", -1)
      end
      imgui.TextColored(mc, u8"[REG] ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), u8(string.format("Страна: [%s]", rdata[1]["country"])))
      imgui.TextColored(mc, u8"[REG] ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), u8(string.format("Город: [%s]", rdata[1]["city"])))
      imgui.TextColored(mc, u8"[REG] ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), u8(string.format("Провайдер: [%s]", rdata[1]["isp"])))
      imgui.Separator()
      imgui.TextColored(mc, u8"Last-IP ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), string.format("[%s] ", rdata[2]["query"]))
      imgui.Hint("getipip3", u8"Нажмите для копирования")
      if imgui.IsItemClicked() then
        setClipboardText(rdata[2]['query'])
        sampAddChatMessage(tag.."Скопировано в буфер обмена.", -1)
      end
      imgui.TextColored(mc, u8"[Last] ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), u8(string.format("Страна: [%s]", rdata[2]["country"])))
      imgui.TextColored(mc, u8"[Last] ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), u8(string.format("Город: [%s]", rdata[2]["city"])))
      imgui.TextColored(mc, u8"[Last] ")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), u8(string.format("Провайдер: [%s]", rdata[2]["isp"])))
      imgui.Separator()
      imgui.TextColored(mc, u8"Расстояние между городами:")
      imgui.SameLine()
      imgui.TextColored(imgui.ImVec4(255,255,255,1), u8(string.format("[~%s]", math.ceil(distances))))
      imgui.SameLine()
      imgui.TextColored(mc, u8"км.                                                                  ")
      if ini.main.lvl_adm >= 6 then
        for l=1, 8 do
          for i, v in ipairs(admins['list'][l]) do
            if v[1] == ipnick then
              imgui.NewLine()
              if imgui.Button(u8"Выдать аццепт", imgui.ImVec2(500, 20)) then
                sampSendChat("/acceptadmin "..v[2])
                getip_window[0] = false
              end
            end
          end
        end
      end
      imgui.PopFont()
      imgui.End()
    end
  ) 

  local onlineWindow = imgui.OnFrame(
    function() return online_window[0] end,
    function(player)
      imgui.SetNextWindowSize(imgui.ImVec2(400, 230), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8'#WeekOnline', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
      imgui.SetCursorPos(imgui.ImVec2(15, 10))
      imgui.CenterTextColored(mc, u8'Онлайн за неделю: ')
      imgui.CenterTextColored(imgui.ImVec4(255,255,255,1), get_timer(ini.onWeek.full))
      imgui.CenterTextColored(mc, u8'Репорт за неделю: ')
      imgui.CenterTextColored(imgui.ImVec4(255,255,255,1), tostring(ini.onWeekReport.report))
      imgui.NewLine()
      for day = 1, 6 do -- ПН -> СБ
          imgui.Text(u8(tWeekdays[day])); imgui.SameLine(150)
          imgui.Text(get_timer(ini.myWeekOnline[day]))
          imgui.SameLine()
          imgui.Text("[R]:"..tostring(ini.myWeekReport[day]))
      end 
      --> ВС
      imgui.Text(u8(tWeekdays[0])); imgui.SameLine(150)
      imgui.Text(get_timer(ini.myWeekOnline[0]))
      imgui.SameLine()
      imgui.Text("[R]:"..tostring(ini.myWeekReport[0]))

      imgui.NewLine()
      imgui.SetCursorPosX((imgui.GetWindowWidth() - 200) / 2)
      if imgui.Button(u8'Закрыть', imgui.ImVec2(200, 25)) then online_window[0] = false end
      imgui.End()
    end
  ) 
  
  imgui.OnFrame( function () return reconinfo_window[0] and not isGamePaused() end,
    function()
      imgui.SetNextWindowPos(imgui.ImVec2(admins['posstatsrecon'].x+5, admins['posstatsrecon'].y+5)) 
      ycords = 230

			if rInfo['cars'] and tonumber(rInfo['afk']) < 2 then
				ycords = 290
			end
      imgui.SetNextWindowSize(imgui.ImVec2(310, ycords))
      imgui.Begin("##reconfstatswddgfпsfinfddgfow", nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoFocusOnAppearing + imgui.WindowFlags.AlwaysAutoResize)
      local color_recnick = sampGetPlayerColor(rInfo['id'])
      local acr, rcr, gcr, bcr = explode_argb(color_recnick)
      imgui.CenterTextColored(imgui.ImVec4(rcr/255, gcr/255, bcr/255, 1), rInfo['name'].."["..rInfo['id'].."]")
      imgui.Hint("copynick_recon", u8"Нажмите для копирования")
      if imgui.IsItemClicked() then
        imgui.BeginTooltip()
        setClipboardText(rInfo['name'])
        sampAddChatMessage(tag.."Ник успешно скопирован.", -1)
        imgui.EndTooltip()
      end
      if rInfo['lvl'] and rInfo['ping'] and rInfo['hp'] and rInfo['exp'] and rInfo['afk'] and rInfo['arm'] and rInfo['shot'] and rInfo['ammo'] and rInfo['warn'] and rInfo['tshot'] and rInfo['speed'] then
        imgui.Columns(4, "ReconStats", true)
        imgui.Separator()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Уровень") 
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        rInfo['lvl'] = sampGetPlayerScore(rInfo['id'])
        imgui.Text(tostring(rInfo['lvl'])) 
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Опыт") 
        imgui.NextColumn() 
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(rInfo['exp'])
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Пинг")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(rInfo['ping'])
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"АФК")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(tostring(rInfo['afk']) or "loading..")
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Здоровье")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(rInfo['hp'])
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Бронь")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(rInfo['arm'])
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Оружие/ПТ")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(rInfo['ammo'])
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Shot общее")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(rInfo['shot'])
        imgui.NextColumn()
        imgui.Separator()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text("Warns")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8(rInfo['warn']))
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Shot в /re")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(rInfo['tshot'])
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Фракция")
        imgui.NextColumn()
        
        imgui.SetColumnWidth(-1, 75)
        if rInfo['org'] then
          fracr = rInfo['org']
          isfrac = true
        elseif rInfo['org'] == "Без фракции" then
          fracr = "НЕТ"
        else
          fracr = "Неизвестно"
        end
        if rInfo['org'] == "Неизвестно" then
          imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(fracr))
        elseif fracr == "Без фракции" then
          imgui.TextColored(imgui.ImVec4(255, 255, 0, 1), u8(fracr))
        else
          imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8(fracr))
          if imgui.IsItemClicked() then
            imgui.BeginTooltip()
            sampSendChat("/members")
            imgui.EndTooltip()
          end
        end
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Ранг")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8(rInfo['rank']:match("%d+") or "0"))
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Separator()
        imgui.Text(u8"Скорость")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8(rInfo['speed']))
        imgui.NextColumn()
        local skin = sampGetPlayerSkin(rInfo['id'])
        if not skin then
          skin = "-1"
        end
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Скин")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(tostring(skin))
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Игра")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        if rInfo['client'] == "Неизвестно" then
          imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(rInfo['client']))
        else
          imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8(rInfo['client']))
        end
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Защита")
        imgui.SameLine()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        if main_adm then
          imgui.Text("None")
        else
          imgui.Text(rInfo['protect'] or "0")
        end
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Регенерация")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        if main_adm then
          imgui.Text("None")
        else
          imgui.Text(rInfo['regen'] or "0")
        end
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Урон")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        if main_adm then
          imgui.Text("None")
        else
          imgui.Text(rInfo['force'] or "0")
        end
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Камень TP")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        if rInfo['lasttp'] then
          checkertp = "Использовал"
          imgui.TextColored(imgui.ImVec4(85, 255, 0, 1), u8(checkertp))
        else
          checkertp = "Не использ."
          imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(checkertp))
        end
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        imgui.Text(u8"Камень GM")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 75)
        if rInfo['iskamen'] then
          checkerkamen = "Использовал"
          imgui.TextColored(imgui.ImVec4(85, 255, 0, 1), u8(checkerkamen))
        else
          checkerkamen = "Не использ."
          imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(checkerkamen))
        end
        imgui.Columns(1)
        imgui.Separator()
      else
        rInfo['lvl'] = "-"
				rInfo['ping'] = "-"
				rInfo['hp'] = "-"
				rInfo['exp'] = "-"
				rInfo['afk'] = 0
				rInfo['arm'] = "-"
				rInfo['shot'] = "-"
				rInfo['ammo'] = "-"
				rInfo['warn'] = "-"
				rInfo['tshot'] = "-"
				rInfo['speed'] = "-"
      end

      local result, handleRec = sampGetCharHandleBySampPlayerId(rInfo['id'])

			if rInfo['cars'] and tonumber(rInfo['afk']) < 2 and result and isCharInAnyCar(handleRec) then
				carHundle = storeCarCharIsInNoSave(handleRec)
        carName = getNameVehicleModel(getCarModel(carHundle))
      
				imgui.NewLine()
				imgui.SameLine(115)
				imgui.CenterTextColored(imgui.ImVec4(1,1,1,1), u8("[" .. carName .. "]"))
				imgui.Columns(4)
				imgui.Separator()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8("ХП Т/С"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8(rInfo['carhp']))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8("Двигатель"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 75)
        if rInfo['engine'] == "Заведен" then
          imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8(rInfo['engine']))
        else
          imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(rInfo['engine']) or "-")
        end
				imgui.NextColumn()
				imgui.Separator()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8("TwinTurbo"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8(rInfo['twint'] or "-"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8("ИД Т/С"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8(rInfo['carid'] or "-1"))
				imgui.Columns(1)
        imgui.Separator()
			end
      imgui.End()
    end
  ).HideCursor = true

  imgui.OnFrame(function() return recon_window[0] and not isGamePaused() end,
    function()
      imgui.SetNextWindowPos(imgui.ImVec2(admins['posrecon'].x+5, admins['posrecon'].y+5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(sizeX/4, sizeY/10), imgui.Cond.FirstUseEver)
      imgui.Begin("##reconwindfdofdwff", nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoFocusOnAppearing)
	    imgui.SetCursorPos(imgui.ImVec2(5, 33))
      
      if imgui.Button(u8("<< Back")) then
        if rInfo['id'] == "0" then
          sampAddChatMessage(tag_err.."Невозможно! Достигнут минимальный ID", -1)
        else
          rInfo['id'] = rInfo['id'] - 1
          sampSendChat('/re '..rInfo['id'])
        end
      end
    
      imgui.SetCursorPos(imgui.ImVec2(60, 6))
    
      if imgui.Button(u8("Stats")) then
        sampSendChat("/check " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Реги")) then
        sampSendChat("/getip " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Спавн")) then
        sampSendChat("/spplayer " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("UP")) then
        sampSendChat("/Slap " .. rInfo['id'] .. " 1")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("DOWN")) then
        sampSendChat("/Slap " .. rInfo['id'] .. " 2")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Разморозить")) then
        sampSendChat("/unfreeze " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Заморозить")) then
        sampSendChat("/freeze " .. rInfo['id'])
      end
    
      imgui.SetCursorPos(imgui.ImVec2(60, 33))
    
      if imgui.Button(u8("ТП к себе")) then
        lua_thread.create(function ()
          lastid = rInfo['id']
          sampSendChat('/reoff')
          wait(1000)
          sampSendChat('/gethere '..lastid)
        end)
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Выдать HP")) then
        sampSetChatInputEnabled(true)
        sampSetChatInputText("/sethp " .. rInfo['id'] .. "  100")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/weap")) then
        sampSetChatInputEnabled(true)
        sampSetChatInputText("/weap " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Наказания")) then
        sampSendChat("/checkpunish " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Skill gun")) then
        sampSendChat("/checkskills " .. rInfo['id'] .. " 1")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/iwep")) then
        sampSendChat("/iwep " .. rInfo['id'])
      end
    
      imgui.SetCursorPos(imgui.ImVec2(60, 60))
    
      if imgui.Button(u8("Вы тут?")) then
        sampSendChat("/pm " .. rInfo['id'] .. " 1 " .. rInfo['name'] .. "[" .. rInfo['id'] .. "] Вы тут????")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/plveh")) then
        sampSetChatInputEnabled(true)
    
        local cursorotstup = 8
    
        if tonumber(rInfo['id']) < 10 then
          cursorotstup = cursorotstup + 1
        elseif tonumber(rInfo['id']) < 100 and tonumber(rInfo['id']) >= 10 then
          cursorotstup = cursorotstup + 2
        elseif tonumber(rInfo['id']) < 1000 and tonumber(rInfo['id']) >= 100 then
          cursorotstup = cursorotstup + 3
        end
    
        sampSetChatInputText("/plveh " .. rInfo['id'] .. "  0")
        sampSetChatInputCursor(cursorotstup, cursorotstup)
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/pgetip ")) then
        sampSendChat("/pgetip " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Флип")) then
        sampSendChat("/flip " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("ТП к игроку")) then
        lua_thread.create(function ()
          lastid = rInfo['id']
          sampSendChat("/reoff")
          wait(1000)
          sampSendChat("/goto "..lastid)
        end)
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/az")) then
        lua_thread.create(function ()
          lastid = rInfo['id']
          sampSendChat("/reoff")
          wait(1000)
          sampSendChat("/az "..lastid)
          sampAddChatMessage("ID: " .. lastid .. " телепортирован в админ комнату.", 16711680)
        end)
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Выйти")) then
        sampSendChat("/reoff")
        ableclickwarp = false
        cursorEnabled = false
      end
    
      imgui.SameLine()
      imgui.SetCursorPos(imgui.ImVec2(410, 33))
    
      if imgui.Button(u8("Next >>")) then
        if rInfo['id'] == "999" then
          sampAddChatMessage(tag_err.."Невозможно! Достигнут максимальный ID", -1)
        else
          rInfo['id'] = rInfo['id'] + 1
          sampSendChat("/re "..rInfo['id'])
        end
      end
      imgui.End()
    end
  ).HideCursor = true

  imgui.OnFrame(function() return stats_window[0] and not isGamePaused() end,
    function()
      imgui.SetNextWindowPos(imgui.ImVec2(admins['posstats'].x+5, admins['posstats'].y+5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(550, 88), imgui.Cond.FirstUseEver)
      imgui.Begin("##Statswindow", nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoFocusOnAppearing)
      imgui.PushFont(imFont[12])
      if ini.main.msktime then
        imgui.TextColored(mc, u8"Время: ")
        imgui.SameLine()
        imgui.Text(tostring(os.date( "!%H:%M:%S", os.time(utc) + 3 * 3600 )))
      end
      if ini.main.rep then
        imgui.TextColored(mc, u8"Ваша репутация: ")
        imgui.SameLine()
        imgui.Text(tostring(selfrep)) 
      end
      if ini.main.repses then
        imgui.TextColored(mc, u8"Репорт за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(sesreport))
      end
      if ini.main.repday then
        imgui.TextColored(mc, u8"Репорт за день: ")
        imgui.SameLine()
        imgui.Text(tostring(ini.onDayReport.report))
      end
      if ini.main.repweek then
        imgui.TextColored(mc, u8"Репорт за неделю: ")
        imgui.SameLine()
        imgui.Text(tostring(ini.onWeekReport.report)) 
      end
      if ini.main.reputses then
        imgui.TextColored(mc, u8"Репутация за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(sesreput))
      end
      if ini.main.reputday then
        imgui.TextColored(mc, u8"Репутация за день: ")
        imgui.SameLine()
        imgui.Text(tostring(ini.onDayReput.reput))
      end
      if ini.main.reputweek then
        imgui.TextColored(mc, u8"Репутация за неделю: ")
        imgui.SameLine()
        imgui.Text(tostring(ini.onWeekReput.reput))
      end
      if ini.main.onlinsession then
        imgui.TextColored(mc, u8"Онлайн за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(sesOnline)))
      end
      if ini.main.fullonlineses then
        imgui.TextColored(mc, u8"Общий за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(sesFull)))
      end
      if ini.main.afkses then 
        imgui.TextColored(mc, u8"АФК за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(sesAfk)))
      end
      if ini.main.onlineday then
        imgui.TextColored(mc, u8"Онлайн за день: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(ini.onDay.online)))
      end
      if ini.main.fullonlineday then
        imgui.TextColored(mc, u8"Общий за день: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(ini.onDay.full)))
      end
      if ini.main.afkday then
        imgui.TextColored(mc, u8"АФК за день: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(ini.onDay.afk)))
      end
      if ini.main.onlineweek then
        imgui.TextColored(mc, u8"Онлайн за неделю: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(ini.onWeek.online)))
      end
      if ini.main.fullonlineweek then
        imgui.TextColored(mc, u8"Общий за неделю: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(ini.onWeek.full)))
      end
      if ini.main.afkweek then
        imgui.TextColored(mc, u8"АФК за неделю: ")
        imgui.SameLine()
        imgui.Text(tostring(get_timer(ini.onWeek.afk)))
      end
      imgui.PopFont()
      imgui.End()
    end
  ).HideCursor = true 
  
  local amemberWindow = imgui.OnFrame(
    function() return amember_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(400, 400), imgui.Cond.FirstUseEver)
      imgui.Begin(u8("Выберите организацию"), amember_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoSavedSettings)

      for k, v in pairs(fracsAmember) do
        if imgui.Button(u8("Вступить во фракцию - [" .. k .. "] " .. v), imgui.ImVec2(397, 20)) then
          sampSendChat("/amember " .. k .. " 9")
          amember_window[0] = false
        end
      end
    end
  ) 

  local tpWindow = imgui.OnFrame(
    function() return tp_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(600, 407))
      imgui.Begin(u8("TP MENU##ter"), tp_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoSavedSettings)
      imgui.BeginChild("##cr", imgui.ImVec2(133, 370), false, imgui.WindowFlags.NoScrollbar)

      if imgui.Button(u8("Фракции"), imgui.ImVec2(125, 20)) then
        tp = 1
      end

      if imgui.Button(u8("Свои поизиции"), imgui.ImVec2(125, 20)) then
        tp = 2
      end

      if imgui.Button(u8("Тп по метке"), imgui.ImVec2(125, 20)) then
        local result, bx, by, bz = getTargetBlipCoordinatesFixed()

        if result then
          sendClickMap(bx, by, bz)

          tp_window[0] = false

          printStringNow("TP MAP", 1000)
        else
          sampAddChatMessage(tag_err..'Метка не найдена!', -1)
        end
      end
      if imgui.Button(u8("Тп на маркер"), imgui.ImVec2(125, 20)) then
        local result, mx, my, mz = SearchMarker(getCharCoordinates(PLAYER_PED))
    
        if result then
          sendClickMap(mx, my, mz)
    
          tp_window[0] = false
        else
          sampAddChatMessage(tag_err.."Маркера на карте нет!", -1)
        end
      end

      imgui.EndChild()
      imgui.SameLine()
      imgui.BeginChild("##crf", imgui.ImVec2(545, 370), false, imgui.WindowFlags.NoScrollbar) --387

      if tp == 1 then
        for k, v in pairs(fracsAmember) do
          if imgui.Button(u8("[" .. k .. "] Спавн " .. v), imgui.ImVec2(200,20)) then
            sampSendChat("/tp " .. k)
            printStringNow("TP Fraction", 1000)

            tp_window[0] = false
          end
          imgui.SameLine()
          imgui.SetCursorPosX(240)
          if imgui.Button(u8("[" .. k .. "] Улица " .. v), imgui.ImVec2(200,20)) then
            sendClickMap(fracsCoords[k][1], fracsCoords[k][2], fracsCoords[k][3])
            printStringNow("TP Fraction", 1000)

            tp_window[0] = false
          end
        end
      end

      imgui.EndChild()
      imgui.End()
    end
  ) 

  local fastnakWindow = imgui.OnFrame(
    function() return fastnak_window[0] end,
    function()
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(500, 609))
      imgui.Begin(fa.ICON_FA_BARS..u8" Выдача наказаний", fastnak_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
      imgui.CenterTextColored(imgui.ImVec4(1,1,1,1), u8"В данном поле нужно вставить список форм для их выдачи.")
      imgui.Separator()
      imgui.InputTextMultiline("##fastnakinput", inputs['fastnak'], 10000, imgui.ImVec2(485, 520))
      imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8"Начать выдачу                      ").x) / 2)
      if imgui.Button(u8"Начать выдачу", imgui.ImVec2(150, 25)) then
        if not str(inputs['fastnak']):match(".+") then return sampAddChatMessage(tag_err..'Не указаны формы!', -1) end
        fastnak_text = u8:decode(str(inputs['fastnak']))
        multiStringSendChat(ini.main.delay_fastnak, fastnak_text, key)
        imgui.StrCopy(inputs['fastnak'], "")
      end
      imgui.End()
    end
  ) 

  local adminmenuWindow = imgui.OnFrame(
    function() return admin_menu[0] end,
    function(self)
      id = select(2, sampGetPlayerIdByCharHandle(playerPed))
      self = {
        nick = sampGetPlayerNickname(id),
        score = sampGetPlayerScore(id),
        color = sampGetPlayerColor(id),
        ping = sampGetPlayerPing(id),
        gameState = sampGetGamestate()
      }
      imgui.SetNextWindowSize(imgui.ImVec2(900, 600), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(sw * 0.5 , sh * 0.5),imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8'#MainSeвttingsWindаow', admin_menu, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse)
      imgui.SetCursorPos(imgui.ImVec2(15,15))
			imgui.BeginGroup()
				imgui.PushFont(imFont[25])
				imgui.Text('Lulu-Tools')
				imgui.PopFont()
				imgui.SameLine(850)
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1,1,1,0))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1,1,1,0))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1,1,1,0))
				if imgui.Button(fa.ICON_FA_TIMES,imgui.ImVec2(23,23)) then
					admin_menu[0] = false
				end
				imgui.PopStyleColor(3)
				imgui.SetCursorPos(imgui.ImVec2(160, 25))
				imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.Border],'v. '..thisScript.version)
				imgui.Hint('lastupdate',u8(date_update))
			imgui.EndGroup()
      imgui.Separator()
      imgui.PushStyleVarFloat(imgui.StyleVar.ChildRounding, 0)
      imgui.PushFont(imFont[13])
			imgui.BeginChild('##MainSettingsWindowChild',imgui.ImVec2(-1, -1),false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
        if listmenu == 0 then
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
					imgui.SetCursorPos(imgui.ImVec2(25,50))
					imgui.BeginGroup()
          for k,v in pairs(buttons) do
            imgui.BeginGroup()
            local p = imgui.GetCursorScreenPos()
            if imgui.InvisibleButton(v.name, imgui.ImVec2(160,100)) then
              listmenu = k
              alpha[0] = os.clock()
            end

            if v.timer == 0 then
              v.timer = imgui.GetTime()
            end
            if imgui.IsItemHovered() then
              v.y_hovered = math.ceil(v.y_hovered) > 0 and 10 - ((imgui.GetTime() - v.timer) * 100) or 0
              v.timer = math.ceil(v.y_hovered) > 0 and v.timer or 0
              imgui.SetMouseCursor(imgui.MouseCursor.Hand)
            else
              v.y_hovered = math.ceil(v.y_hovered) < 10 and (imgui.GetTime() - v.timer) * 100 or 10
              v.timer = math.ceil(v.y_hovered) < 10 and v.timer or 0
            end
            imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y + v.y_hovered), imgui.ImVec2(p.x + 160, p.y + 110 + v.y_hovered), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Button]), 7)
            imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x-4, p.y + v.y_hovered - 4), imgui.ImVec2(p.x + 164, p.y + 110 + v.y_hovered + 4), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.ButtonActive]), 10, nil, 1.9)
            imgui.SameLine(10)
            imgui.SetCursorPosY(imgui.GetCursorPosY() + 10 + v.y_hovered)
            imgui.PushFont(imFont[25])
            imgui.Text(v.icon)
            imgui.PopFont()
            imgui.SameLine(10)
            imgui.SetCursorPosY(imgui.GetCursorPosY() + 30 + v.y_hovered)
            imgui.BeginGroup()
              imgui.PushFont(imFont[16])
              imgui.Text(u8(v.name))
              imgui.PopFont()
              imgui.Text(u8(v.text))
            imgui.EndGroup()
            imgui.EndGroup()
            if k == 1 then 
              imgui.SameLine(220)
            elseif k == 2 then
              imgui.SameLine(440)
            elseif k == 3 then
              imgui.SameLine(660)
            elseif k == 5 then 
              imgui.SameLine(220)
            elseif k == 6 then
              imgui.SameLine(440)
            elseif k == 7 then
              imgui.SameLine(660)
            elseif k == 9 then
              imgui.SameLine(220)
            elseif k == 10 then
              imgui.SameLine(440)
            elseif k == 11 then
              imgui.SameLine(660)
            end
          end
					imgui.EndGroup()
					imgui.PopStyleVar()
        elseif listmenu == 1 then -- Основное
            imgui.SetCursorPos(imgui.ImVec2(15,20))
            if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
              listmenu = 0
              alpha[0] = os.clock()
            end
            imgui.SetCursorPos(imgui.ImVec2(15,20))
            imgui.PushFont(imFont[16])
            imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
            imgui.PopFont()
            imgui.SameLine()
            local p = imgui.GetCursorScreenPos()
            imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
            imgui.SetCursorPos(imgui.ImVec2(60,15))
            imgui.PushFont(imFont[25])
            imgui.Text(u8"Основное")
            imgui.PopFont()
            imgui.SetCursorPosY(60)
            imgui.SetCursorPosX(100)
            imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
            imgui.BeginChild('##usersettingsmainwindow',false)
              ini.forms.tag = str(admins['forms']['tag'])
              ini.main.pass_acc = base64.encode(str(admins['profile']['passacc']))
              ini.main.pass_adm = str(admins['profile']['passadm'])
              ini.main.auto_az = toggles['autoaz'][0]
              ini.main.getipwindow = toggles['getipwindow'][0]
              ini.main.statswindow = toggles['statswindow'][0]
              ini.main.onlinsession = toggles['onlinsession'][0]
              ini.main.fullonlineses = toggles['fullonlineses'][0]
              ini.main.afkses = toggles['afkses'][0]
              ini.main.onlineday = toggles['onlineday'][0]
              ini.main.fullonlineday = toggles['fullonlineday'][0]
              ini.main.afkday = toggles['afkday'][0]
              ini.main.onlineweek = toggles['onlineweek'][0]
              ini.main.fullonlineweek = toggles['fullonlineweek'][0]
              ini.main.afkweek = toggles['afkweek'][0]
              ini.main.rep = toggles['rep'][0]
              ini.main.repses = toggles['repses'][0]
              ini.main.repday = toggles['repday'][0]
              ini.main.repweek = toggles['repweek'][0]
              ini.main.autoprefix = toggles['autoprefix'][0]
              ini.main.autoquest = toggles['autoquest'][0]
              ini.main.repchange = toggles['repchange'][0]
              ini.main.funcadmin = toggles['funcadmin'][0]
              ini.main.invauth = toggles['invauth'][0]
              ini.main.editchecker = toggles['editchecker'][0]
              ini.main.infoot = toggles['infoot'][0]
              ini.main.slapadm = toggles['slapadm'][0]
              ini.main.flipadm = toggles['flipadm'][0]
              ini.main.spyadm = toggles['spyadm'][0]
              ini.main.reputses = toggles['reputses'][0]
              ini.main.reputday = toggles['reputday'][0]
              ini.main.reputweek = toggles['reputweek'][0]
              ini.main.antifreeze = toggles['antifreeze'][0]
              ini.main.bonhead = toggles['bonhead'][0]
              ini.main.fixtp = toggles['fixtp'][0]
              ini.main.msktime = toggles['msktime'][0]
              ini.main.autob = toggles['autob'][0]
              save()
              imgui.BeginGroup() -- Левая колонка
        
                imgui.SubTitle(u8"Информация:")
                local strCol = ABGRtoStringRGB(ini.style.color)
                imgui.TextColoredRGB(u8(('Ваш аккаунт: %s%s[%s]'):format(strCol, self.nick, self.gameState == 3 and id or 'OFF')))
                imgui.TextColoredRGB(u8(('Уровень: %s%s[%s]'):format(strCol, admNames[tonumber(ini.main.lvl_adm)], ini.main.lvl_adm)))
                imgui.Hint("lvldada", u8"В случае ошибочного отображения уровня, введите /admins")
                imgui.Text(u8'Ваш тег: ')
                imgui.SameLine()
                imgui.PushItemWidth(125)
                imgui.InputText('##tag_adm', admins['forms']['tag'], sizeof(admins['forms']['tag']))
                imgui.PopItemWidth()
                imgui.Text(u8'Пример: Чит '..str(admins['forms']['tag']))
                imgui.NewLine()
                imgui.SubTitle(u8"Пароли:")
                imgui.TextColored(mc, ">> ")
                imgui.SameLine()
                imgui.Text(u8"Пароль от аккаунта: ")
                
                imgui.PushItemWidth(150)
                if pass_acc_see then
                    imgui.InputTextWithHint('##pass_acc', u8"По желанию", admins['profile']['passacc'], sizeof(admins['profile']['passacc']))
                else
                    imgui.InputTextWithHint('##pass_acc', u8"По желанию", admins['profile']['passacc'], sizeof(admins['profile']['passacc']), imgui.InputTextFlags.Password)
                end
                imgui.PopItemWidth()
                imgui.SameLine()
                imgui.Text(fa.ICON_FA_EYE..'')
                if imgui.IsItemClicked() then
                    imgui.BeginTooltip();
                    pass_acc_see = not pass_acc_see
                    imgui.EndTooltip();
                end
                imgui.Hint("passsee", u8"Отображение пароля в окне ввода")
                imgui.TextColored(mc, ">> ")
                imgui.SameLine()
                imgui.Text(u8"Админ пароль: ")
                imgui.PushItemWidth(150)
                if pass_acc_see_adm then
                    imgui.InputTextWithHint('##pass_adm', u8"По желанию", admins['profile']['passadm'], sizeof(admins['profile']['passadm']))
                else
                    imgui.InputTextWithHint('##pass_adm', u8"По желанию", admins['profile']['passadm'], sizeof(admins['profile']['passadm']), imgui.InputTextFlags.Password)
                end
                imgui.PopItemWidth()
                imgui.SameLine()
                imgui.Text(fa.ICON_FA_EYE..'')
                if imgui.IsItemClicked() then
                    imgui.BeginTooltip();
                    pass_acc_see_adm = not pass_acc_see_adm
                    imgui.EndTooltip();
                end
                imgui.Hint("passseesad", u8"Отображение пароля в окне ввода")
                imgui.NewLine()
                
              imgui.EndGroup()
              imgui.SameLine(400)
              imgui.BeginGroup() -- Правая колонка
                imgui.SubTitle(u8"Настройки:")
                imgui.Text(u8'Авто /az: ')
                imgui.SameLine()
                addons.ToggleButton("##4523", toggles['autoaz'])
                
                
                
                
                imgui.Text(u8"/getip в окне: ")
                imgui.SameLine()
                addons.ToggleButton("##getipwindow", toggles['getipwindow'])
                imgui.Text(u8"Окно статистики: ")
                imgui.SameLine()
                addons.ToggleButton("##statswindow", toggles['statswindow'])
                if toggles['statswindow'] then
                  imgui.SameLine()
                  imgui.TextDisabled(fa.ICON_FA_COG)
                  if imgui.IsItemClicked() then
                    imgui.OpenPopup(u8'Настройки статистики')
                  end
                  if imgui.BeginPopupModal(u8'Настройки статистики', false, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar) then
                    imgui.SetNextWindowSize(imgui.ImVec2(200,200))
                    imgui.Text(u8'Местоположение окна статистики: ')
                    imgui.SameLine()
                      if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##statsPosition', imgui.ImVec2(33, 20)) then
                        lua_thread.create(function()
                          local backup = {
                            ['x'] = ini.main.statsx,
                            ['y'] = ini.main.statsy
                          }
                          ChangePosStats = true
                          showCursor(true)
                          admin_menu[0] = false
                          sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                          if not sampIsChatInputActive() then
                            while not sampIsChatInputActive() and ChangePosStats do
                              showCursor(true)
                                wait(0)
                                showCursor(true)
                                ini.main.statsx, ini.main.statsy = getCursorPos()
                                local cX, cY = getCursorPos()
                                admins['posstats'].x = cX
                                admins['posstats'].y = cY
                                if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                                  showCursor(false)
                                  ChangePosStats = false
                                  sampAddChatMessage(tag..'Позиция сохранена!', -1)
                                elseif isKeyJustPressed(VK_ESCAPE) then
                                  ChangePosStats = false
                                  showCursor(false)
                                  admins['posstats'].x = backup['x']
                                  admins['posstats'].y = backup['y']
                                  sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                                end
                            end
                          end
                          ini.main.statsx = admins['posstats'].x
                          ini.main.statsy = admins['posstats'].y 
                          showCursor(false)
                          ableclickwarp = false
                          ChangePosStats = false
                          admin_menu[0] = true
                          end)
                        end
                    imgui.NewLine()
                    imgui.Text(u8"Точное МСК время: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##msktime", toggles['msktime'])
                    imgui.Text(u8"Количество репутации: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##rep", toggles['rep'])
                    imgui.Text(u8"Репутации за сессию: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##reputses", toggles['reputses'])
                    imgui.Text(u8"Репутация за день: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##reputday", toggles['reputday'])
                    imgui.Text(u8"Репутация за неделю: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##reputweek", toggles['reputweek'])
                    imgui.Text(u8"Репорт за сессию: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##repses", toggles['repses'])
                    imgui.Text(u8"Репорт за день: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##repday", toggles['repday'])
                    imgui.Text(u8"Репорт за неделю: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##repweek", toggles['repweek'])
                    imgui.Separator()
                    imgui.Text(u8"Онлайн за сессию: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##onlinsession", toggles['onlinsession'])
                    imgui.Text(u8"Общий онлайн за сессию(с АФК): ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##fullonlineses", toggles['fullonlineses'])
                    imgui.Text(u8"АФК за сессию: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##afkses", toggles['afkses'])
                    imgui.Text(u8"Онлайн за день: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##onlineday", toggles['onlineday'])
                    imgui.Text(u8"Общий онлайн за день(с АФК): ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##fullonlineday", toggles['fullonlineday'])
                    imgui.Text(u8"АФК за день: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##afkday", toggles['afkday'])
                    imgui.Text(u8"Онлайн за неделю: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##onlineweek", toggles['onlineweek'])
                    imgui.Text(u8"Общий онлайн за неделю(с АФК): ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##fullonlineweek", toggles['fullonlineweek'])
                    imgui.Text(u8"АФК за неделю: ")
                    imgui.SameLine()
                    imgui.SetCursorPosX(250)
                    addons.ToggleButton("##afkweek", toggles['afkweek'])
                    if imgui.Button(u8' Закрыть', imgui.ImVec2(300, 20)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.EndPopup()
                  end
                end
                imgui.Text(u8"Авто префикс: ")
                imgui.SameLine()
                addons.ToggleButton("##autoprefix", toggles['autoprefix'])
          
                imgui.Text(u8"Скин при авторизации: ")
                imgui.SameLine()
                imgui.PushItemWidth(35)
                if imgui.InputInt("##skinauth", inputs['skinauth'], 0) then
                  if inputs['skinauth'][0] > 311 then inputs['skinauth'][0] = 0 end
                  if inputs['skinauth'][0] < 0 then inputs['skinauth'][0] = 0 end
                  ini.main.skinauth = inputs['skinauth'][0]
                  save()
                end
                imgui.PopItemWidth()
                imgui.SameLine()
                if imgui.Button(fa.ICON_FA_POWER_OFF, imgui.ImVec2(26,20)) then 
                  inputs['skinauth'][0] = 0
                  ini.main.skinauth = 0
                  save() 
                end
                imgui.Question("skinauth", u8"Введите ID - 0 для отключения функции.")
                imgui.Text(u8"Фракция при авторизации: ")
                imgui.SameLine()
                imgui.PushItemWidth(35)
                if imgui.InputInt("##fracauth", inputs['fracauth'], 0) then
                  if inputs['fracauth'][0] > 28 then inputs['fracauth'][0] = 0 end
                  if inputs['fracauth'][0] < 0 then inputs['fracauth'][0] = 0 end
                  ini.main.fracauth = inputs['fracauth'][0]
                  save()
                end
                imgui.PopItemWidth()
                imgui.SameLine()
                if imgui.Button(fa.ICON_FA_POWER_OFF.."##fracauth", imgui.ImVec2(26,20)) then 
                  inputs['fracauth'][0] = 0
                  ini.main.fracauth = 0
                  save() 
                end
                imgui.Question("fracauth", u8"Введите ID - 0 для отключения функции.")
                imgui.Text(u8"/gotoint при авторизации: ")
                imgui.SameLine()
                imgui.PushItemWidth(35)
                if imgui.InputInt("##intauth", inputs['intauth'], 0) then
                  if inputs['intauth'][0] > 148 then inputs['intauth'][0] = 0 end
                  if inputs['intauth'][0] < 0 then inputs['intauth'][0] = 0 end
                  ini.main.intauth = inputs['intauth'][0]
                  save()
                end
                imgui.PopItemWidth()
                imgui.SameLine()
                if imgui.Button(fa.ICON_FA_POWER_OFF.."##intauth", imgui.ImVec2(26,20)) then 
                  inputs['intauth'][0] = 0
                  ini.main.intauth = 0
                  save() 
                end
                imgui.Question("intauth", u8"Введите ID - 0 для отключения функции.")
                imgui.Text(u8"Авто квест: ")
                imgui.SameLine()
                addons.ToggleButton("##autoquest", toggles['autoquest'])
                imgui.Text(u8"Информации о +/- репе: ")
                imgui.SameLine()
                addons.ToggleButton("##+-rep", toggles['repchange'])
                imgui.Text(u8"Выключить действия адм: ")
                imgui.SameLine()
                addons.ToggleButton("##deistvadm", toggles['funcadmin'])
                imgui.SameLine()
                imgui.TextDisabled(fa.ICON_FA_COG)
                if imgui.IsItemClicked() then
                  imgui.OpenPopup(u8'Настройки действий адм')
                end
                if imgui.BeginPopupModal(u8'Настройки действий адм') then
                  imgui.SetNextWindowSize(imgui.ImVec2(200,200))
                  imgui.Text(u8"Слап: ")
                  imgui.SameLine()
                  addons.ToggleButton("##slapadm", toggles['slapadm'])
                  imgui.Text(u8"Флип: ")
                  imgui.SameLine()
                  addons.ToggleButton("##flipadm", toggles['flipadm'])
                  imgui.Text(u8"Слежка за игроком: ")
                  imgui.SameLine()
                  addons.ToggleButton("##spyadm", toggles['spyadm'])
                  imgui.Text(u8"Ответ на репорт: ")
                  imgui.SameLine()
                  if addons.ToggleButton("##Otvetnarep", toggles['reportadm']) then
                    ini.main.reportadm = toggles['reportadm'][0]
                    save()
                  end
                  if imgui.Button(u8' Закрыть', imgui.ImVec2(270, 20)) then
                      imgui.CloseCurrentPopup()
                  end
                  imgui.EndPopup()
                end
                imgui.Text(u8"/inv при авторизации: ")
                imgui.SameLine()
                addons.ToggleButton("##invauth", toggles['invauth'])
                imgui.Text(u8"Редактор чекера админов: ")
                imgui.SameLine()
                addons.ToggleButton("##editchecker", toggles['editchecker'])
                imgui.SameLine()
                imgui.Question("editchecker", u8"При нажатии по администратору в чекере с зажатым Alt, у вас откроется меня редактора.")
                imgui.Text(u8"Информация после /ot: ")
                imgui.SameLine()
                addons.ToggleButton("##infoot", toggles['infoot'])
                imgui.SameLine()
                imgui.Question("infoot", u8"После ответа на репорт, в чате будет выведено сообщение с ID и ником автора репорта,\nа также Ваш ответ.")
                imgui.Text(u8"AntiFreeze: ")
                imgui.SameLine()
                addons.ToggleButton("##antifreeze", toggles['antifreeze'])
                imgui.Text(u8"/b над головой: ")
                imgui.SameLine()
                addons.ToggleButton("##b_on_head", toggles['bonhead'])
                imgui.Text(u8"Фикс тп по метке: ")
                imgui.SameLine()
                addons.ToggleButton("##fix_tpmark", toggles['fixtp'])
                imgui.Text(u8"Авто /b: ")
                imgui.SameLine()
                addons.ToggleButton("##autob", toggles['autob'])
                imgui.Text(u8"Спавн на /spawnset: ")
                imgui.SameLine()
                if addons.ToggleButton("##spawnset", toggles['spawnset']) then
                  ini.main.spawnset = toggles['spawnset'][0]
                  save()
                end
                imgui.EndGroup()
              imgui.EndGroup()
            imgui.EndChild()
            imgui.PopStyleVar()
        elseif listmenu == 2 then -- Читы
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[25])
          imgui.Text(u8"Читы")
          imgui.PopFont()
          imgui.SetCursorPosX(50)
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.BeginChild('##usersettingsmainwindow'..listmenu,false)
            imgui.SetCursorPosY(50)
            imgui.BeginGroup()
              ini.main.traicers = toggles['traicers'][0]
              ini.main.whcar = toggles['whcar'][0]
              ini.main.is_clickwarp = toggles['isclickwarp'][0]
              ini.main.is_gm = toggles['isgm'][0]
              ini.main.rwh = toggles['rwh'][0]
              save()
              imgui.Text(u8'ClickWarp: ')
              imgui.SameLine()
              addons.ToggleButton("##clickwarp", toggles['isclickwarp'])
              imgui.Text(u8'GM: ')
              imgui.SameLine()
              addons.ToggleButton("##godmode", toggles['isgm'])
              imgui.Text(u8"Вх на кары: ")
              imgui.SameLine()
              addons.ToggleButton("##whcars", toggles['whcar'])
              if toggles['whcar'][0] then
                imgui.SameLine()
                imgui.TextDisabled(fa.ICON_FA_COG)
                if imgui.IsItemClicked() then
                  imgui.OpenPopup(u8'Настройки ВХ')
                end
                if imgui.BeginPopupModal(u8'Настройки ВХ') then
                  imgui.SetNextWindowSize(imgui.ImVec2(200,200))
                  imgui.Text(u8"Дистанция прорисовки ВХ:")
                  imgui.PushItemWidth(200)
                  if imgui.SliderInt("##wallhackdistance", sliders['whdistance'], 10, 150, u8"%d") then
                    ini.main.whdist = sliders['whdistance'][0]
                    save()
                  end
                  imgui.PopItemWidth()
                  imgui.NewLine()
                  if imgui.Button(u8' Закрыть', imgui.ImVec2(200, 20)) then
                      imgui.CloseCurrentPopup()
                  end
                  imgui.EndPopup()
                end
              end
              imgui.Text(u8"Трейсера пуль: ")
              imgui.SameLine()
              addons.ToggleButton("##traicersofbullets", toggles['traicers'])
              imgui.Text(u8"Рендер руды: ")
              imgui.SameLine()
              addons.ToggleButton("##renderores", toggles['rwh'])
              imgui.Text(u8"Бесконечные патроны: ")
              imgui.SameLine()
              if addons.ToggleButton("##infinityammo", toggles['infammo']) then
                ini.main.infammo = toggles['infammo'][0]
                save()
              end
              imgui.Text(u8"Airbreak: ")
              imgui.SameLine()
              if addons.ToggleButton("##airbreak", toggles['airbreak']) then
                ini.main.airbreak = toggles['airbreak'][0]
                save()
              end
              imgui.EndChild()
            imgui.EndGroup()
          imgui.PopStyleVar()
        elseif listmenu == 3 then -- Цвета
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[25])
          imgui.Text(u8"Цвета")
          imgui.PopFont()
          imgui.SetCursorPosY(75)
          imgui.SetCursorPosX(50)
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.BeginChild('##usersettingsmainwindow'..listmenu,false)
            imgui.SubTitle(u8"Интерфейс:")
            if imgui.ColorEdit4('##MainColor', editColors['mc'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              mc = imgui.ImVec4(editColors['mc'][0], editColors['mc'][1], editColors['mc'][2], editColors['mc'][3])
              local u32 = imgui.ColorConvertFloat4ToU32(mc)
              ini.style.color = u32
              theme()
            end
            imgui.SameLine()
            imgui.Text(u8'Цвет интерфейса')

            if imgui.ColorEdit4('##TextColor', editColors['tc'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              tc = imgui.ImVec4(editColors['tc'][0], editColors['tc'][1], editColors['tc'][2], editColors['tc'][3])
              local u32 = imgui.ColorConvertFloat4ToU32(tc)
              ini.style.text = u32
              theme()
            end
            imgui.SameLine()
            imgui.Text(u8'Цвет текста')
            


            imgui.Text(u8"Закругление окна: ")
            imgui.SameLine()
            imgui.PushItemWidth(100)
            if imgui.InputInt("##rounding", inputs['rounding'], 1) then
              if inputs['rounding'][0] < 1 then inputs['rounding'][0] = 1 end
              if inputs['rounding'][0] > 30 then inputs['rounding'][0] = 30 end
              ini.style.rounding = inputs['rounding'][0]
              theme()
            end
            imgui.Question("roundingwindow", u8"Не распространяется на Админ-меню в целях сохранения возможности полного просмотра содержимого")
            imgui.PopItemWidth()
            imgui.Text(u8"Закругление кнопок: ")
            imgui.SameLine()
            imgui.PushItemWidth(100)
            if imgui.InputInt("##fr", inputs['fr'], 1) then
              if inputs['fr'][0] < 1 then inputs['fr'][0] = 1 end
              if inputs['fr'][0] > 30 then inputs['fr'][0] = 30 end
              ini.style.framerounding = inputs['fr'][0]
              theme()
            end
            imgui.PopItemWidth()
            imgui.NewLine()
            imgui.SubTitle(u8"Логи:")

            if imgui.ColorEdit4('##colordisconnectdef', editColors['disc'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              discef = imgui.ImVec4(editColors['disc'][0], editColors['disc'][1], editColors['disc'][2], editColors['disc'][3])
              local u32 = imgui.ColorConvertFloat4ToU32(discef)
              ini.style.logcon_def = u32
              save()
            end
            imgui.SameLine()
            imgui.Text(u8'Дисконнект')

            if imgui.ColorEdit4('##colordisconnect', editColors['cd'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              cd = imgui.ImVec4(editColors['cd'][0], editColors['cd'][1], editColors['cd'][2], editColors['cd'][3])
              local u32 = imgui.ColorConvertFloat4ToU32(cd)
              ini.style.logcon_d = u32
            end
            imgui.SameLine()
            imgui.Text(u8'Дисконнект - [Q]')
            imgui.Question("disconnect", u8"Меняет цвет надписи [Q] в логах дисконнекта")

            if imgui.ColorEdit4('##colorreg', editColors['rc'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              rc = imgui.ImVec4(editColors['rc'][0], editColors['rc'][1], editColors['rc'][2], editColors['rc'][3])
              local u32 = imgui.ColorConvertFloat4ToU32(rc)
              ini.style.logreg = u32
            end
            imgui.SameLine()
            imgui.Text(u8'Регистрация')

            if imgui.ColorEdit4('##colorfarchat', editColors['farchat'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              farchat_clr = imgui.ImVec4(editColors['farchat'][0], editColors['farchat'][1], editColors['farchat'][2], editColors['farchat'][3])
              local u32 = imgui.ColorConvertFloat4ToU32(farchat_clr)
              ini.style.farchat = u32
            end
            imgui.SameLine()
            imgui.Text(u8'Дальний чат')

            imgui.NewLine()
            imgui.SubTitle(u8"Игра:")
            if imgui.ColorEdit4('##admchat', editColors['ac'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              ac = imgui.ImVec4(editColors['ac'][0], editColors['ac'][1], editColors['ac'][2], editColors['ac'][3])
              local u32 = imgui.ColorConvertFloat4ToU32(ac)
              ini.style.adminchat = u32
            end
            imgui.SameLine()
            imgui.Text(u8'Админ-чат')
            if imgui.ColorEdit4('##report', editColors['report'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              report = imgui.ImVec4(editColors['report'][0], editColors['report'][1], editColors['report'][2], editColors['report'][3])
              local u32 = imgui.ColorConvertFloat4ToU32(report)
              ini.style.report = u32
            end
            imgui.SameLine()
            imgui.Text(u8'Репорт')
            save()
          imgui.EndChild()
          imgui.PopStyleVar()
        elseif listmenu == 4 then -- Биндер
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[25])
          imgui.Text(u8"Биндер")
          imgui.PopFont()
          imgui.SetCursorPos(imgui.ImVec2(15,65))
          imgui.BeginGroup()
            imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.05,0.5))
            for k, i in pairs(bindersettings) do
              local clr = imgui.GetStyle().Colors[imgui.Col.Text].x
              if bindersettings_list[0] == k then
                local p = imgui.GetCursorScreenPos()
                imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y + 10),imgui.ImVec2(p.x + 3, p.y + 25), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Border]), 5, imgui.DrawCornerFlags.Right)
              end
              imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(clr,clr,clr,bindersettings_list[0] == k and 0.1 or 0))
              imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(clr,clr,clr,0.15))
              imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(clr,clr,clr,0.1))
              if imgui.AnimButton(i, imgui.ImVec2(162,35)) then
                if bindersettings_list[0] ~= k then
                  bindersettings_list[0] = k
                  alpha[0] = os.clock()
                end
              end
              imgui.PopStyleColor(3)
            end
            imgui.PopStyleVar()
          imgui.EndGroup()
          imgui.SetCursorPos(imgui.ImVec2(195, 0))
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.SetCursorPosY(80)
          imgui.BeginChild('##usersettingsmainwindow'..listmenu,false)
            if bindersettings_list[0] == 1 then
              ActiveClockMenu.v = mysplit(ini.binds.reoff, ",")
              lastrep.v = mysplit(ini.binds.last_rep, ",")
              bindot.v = mysplit(ini.binds.bind_ot, ",")
              noviolations.v = mysplit(ini.binds.noviolations, ",")
              slapmyself.v = mysplit(ini.binds.slapmyself, ",")
              jpmyself.v = mysplit(ini.binds.jpmyself, ",")
              whhotkey.v = mysplit(ini.binds.wh, ",")
              whcarhotkey.v = mysplit(ini.binds.whcar, ",")
              imgui.Text(u8'Выйти из рекона: ')
              imgui.SameLine()
              if imgui.HotKey("##21312", ActiveClockMenu, 70, 25) then
                  ini.binds.reoff = table.concat((ActiveClockMenu.v), ",")
                  save()
                  sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Ответить автору последнего репорта: ")
              imgui.SameLine()
              if imgui.HotKey("##lastrep", lastrep, 70, 25) then
                ini.binds.last_rep = table.concat((lastrep.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Открыть репорт(/ot): ")
              imgui.SameLine()
              if imgui.HotKey("##bindot", bindot, 70, 25) then
                ini.binds.bind_ot = table.concat((bindot.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Написать автору репорта о том что игрок не нарушает: ")
              imgui.SameLine()
              if imgui.HotKey("##noviolations", noviolations, 70, 25) then
                ini.binds.noviolations = table.concat((noviolations.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Слапнуть себя: ")
              imgui.SameLine()
              if imgui.HotKey("##slapmyself", slapmyself, 70, 25) then
                ini.binds.slapmyself = table.concat((slapmyself.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Выдать себе /jp: ")
              imgui.SameLine()
              if imgui.HotKey("##jpmyself", jpmyself, 70, 25) then
                ini.binds.jpmyself = table.concat((jpmyself.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Включить/выключить ВХ: ")
              imgui.SameLine()
              if imgui.HotKey("##whhotkey", whhotkey, 70, 25) then
                ini.binds.wh = table.concat((whhotkey.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Включить/выключить ВХ на Кары: ")
              imgui.SameLine()
              if imgui.HotKey("##whcarhotkey", whcarhotkey, 70, 25) then
                ini.binds.whcar = table.concat((whcarhotkey.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
            elseif bindersettings_list == 2 then
  
            end
          imgui.EndChild()
          imgui.PopStyleVar()
        elseif listmenu == 5 then -- Формы
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end --formsettings
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[25])
          imgui.Text(u8"Формы")
          imgui.PopFont()
          imgui.SetCursorPos(imgui.ImVec2(15,65))
          imgui.BeginGroup()
            imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.05,0.5))
            for k, i in pairs(formsettings) do
              local clr = imgui.GetStyle().Colors[imgui.Col.Text].x
              if formsettings_list[0] == k then
                local p = imgui.GetCursorScreenPos()
                imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y + 10),imgui.ImVec2(p.x + 3, p.y + 25), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Border]), 5, imgui.DrawCornerFlags.Right)
              end
              imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(clr,clr,clr,formsettings_list[0] == k and 0.1 or 0))
              imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(clr,clr,clr,0.15))
              imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(clr,clr,clr,0.1))
              if imgui.AnimButton(i, imgui.ImVec2(162,35)) then
                if formsettings_list[0] ~= k then
                  formsettings_list[0] = k
                  alpha[0] = os.clock()
                end
              end
              imgui.PopStyleColor(3)
            end
            imgui.PopStyleVar()
          imgui.EndGroup()
          imgui.SetCursorPos(imgui.ImVec2(195, 0))
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.SetCursorPosY(80)
          imgui.BeginChild('##usersettingsmainwindow'..listmenu,false)
            if formsettings_list[0] == 1 then
              ini.forms.slap = formsIni['slap'][0]
              ini.forms.flip = formsIni['flip'][0]
              ini.forms.freeze = formsIni['freeze'][0]
              ini.forms.unfreeze = formsIni['unfreeze'][0]
              ini.forms.pm = formsIni['pm'][0]
              ini.forms.spplayer = formsIni['spplayer'][0]
              ini.forms.spcar = formsIni['spcar'][0]
              ini.forms.cure = formsIni['cure'][0]
              ini.forms.weap = formsIni['weap'][0]
              ini.forms.unjail = formsIni['unjail'][0]
              ini.forms.jail = formsIni['jail'][0]
              ini.forms.unmute = formsIni['unmute'][0]
              ini.forms.kick = formsIni['kick'][0]
              ini.forms.mute = formsIni['mute'][0]
              ini.forms.adeldesc = formsIni['adeldesc'][0]
              ini.forms.apunish = formsIni['apunish'][0]
              ini.forms.plveh = formsIni['plveh'][0]
              ini.forms.bail = formsIni['bail'][0]
              ini.forms.unwarn = formsIni['unwarn'][0]
              ini.forms.ban = formsIni['ban'][0]
              ini.forms.warn = formsIni['warn'][0]
              ini.forms.accepttrade = formsIni['accepttrade'][0]
              ini.forms.givegun = formsIni['givegun'][0]
              ini.forms.trspawn = formsIni['trspawn'][0]
              ini.forms.destroytrees = formsIni['destroytrees'][0]
              ini.forms.removetune = formsIni['removetune'][0]
              ini.forms.clearafklabel = formsIni['clearafklabel'][0]
              ini.forms.setfamgz = formsIni['setfamgz'][0]
              ini.forms.delhname = formsIni['delhname'][0]
              ini.forms.delbname = formsIni['delbname'][0]
              ini.forms.warnoff = formsIni['warnoff'][0]
              ini.forms.unban = formsIni['unban'][0]
              ini.forms.afkkick = formsIni['afkkick'][0]
              ini.forms.aparkcar = formsIni['aparkcar'][0]
              ini.forms.setgangzone = formsIni['setgangzone'][0]
              ini.forms.setbizmafia = formsIni['setbizmafia'][0]
              ini.forms.cleardemorgane = formsIni['cleardemorgane'][0]
              ini.forms.sban = formsIni['sban'][0]
              ini.forms.banip = formsIni['banip'][0]
              ini.forms.unbanip = formsIni['unbanip'][0]
              ini.forms.jailoff = formsIni['jailoff'][0]
              ini.forms.muteoff = formsIni['muteoff'][0]
              ini.forms.skick = formsIni['skick'][0]
              ini.forms.setskin = formsIni['setskin'][0]
              ini.forms.uval = formsIni['uval'][0]
              ini.forms.ao = formsIni['ao'][0]
              ini.forms.unapunishoff = formsIni['unapunishoff'][0]
              ini.forms.unjailoff = formsIni['unjailoff'][0]
              ini.forms.unmuteoff = formsIni['unmuteoff'][0]
              ini.forms.unwarnoff = formsIni['unwarnoff'][0]
              ini.forms.bizlock = formsIni['bizlock'][0]
              ini.forms.bizopen = formsIni['bizopen'][0]
              ini.forms.cinemaunrent = formsIni['cinemaunrent'][0]
              ini.forms.banipoff = formsIni['banipoff'][0]
              ini.forms.banoff = formsIni['banoff'][0]
              ini.forms.agl = formsIni['agl'][0]
              ini.forms.rmute = formsIni['rmute'][0]
              ini.forms.unrmute = formsIni['unrmute'][0]
              ini.forms.clearad = formsIni['clearad'][0]
        
              ini.forms.autoslap = AutoformsIni['slap'][0]
              ini.forms.autoflip = AutoformsIni['flip'][0]
              ini.forms.autofreeze = AutoformsIni['freeze'][0]
              ini.forms.autounfreeze = AutoformsIni['unfreeze'][0]
              ini.forms.autopm = AutoformsIni['pm'][0]
              ini.forms.autospplayer = AutoformsIni['spplayer'][0]
              ini.forms.autospcar = AutoformsIni['spcar'][0]
              ini.forms.autocure = AutoformsIni['cure'][0]
              ini.forms.autoweap = AutoformsIni['weap'][0]
              ini.forms.autounjail = AutoformsIni['unjail'][0]
              ini.forms.autojail = AutoformsIni['jail'][0]
              ini.forms.autounmute = AutoformsIni['unmute'][0]
              ini.forms.autokick = AutoformsIni['kick'][0]
              ini.forms.automute = AutoformsIni['mute'][0]
              ini.forms.autoadeldesc = AutoformsIni['adeldesc'][0]
              ini.forms.autoapunish = AutoformsIni['apunish'][0]
              ini.forms.autoplveh = AutoformsIni['plveh'][0]
              ini.forms.autobail = AutoformsIni['bail'][0]
              ini.forms.autounwarn = AutoformsIni['unwarn'][0]
              ini.forms.autoban = AutoformsIni['ban'][0]
              ini.forms.autowarn = AutoformsIni['warn'][0]
              ini.forms.autoaccepttrade = AutoformsIni['accepttrade'][0]
              ini.forms.autogivegun = AutoformsIni['givegun'][0]
              ini.forms.autotrspawn = AutoformsIni['trspawn'][0]
              ini.forms.autodestroytrees = AutoformsIni['destroytrees'][0]
              ini.forms.autoremovetune = AutoformsIni['removetune'][0]
              ini.forms.autoclearafklabel = AutoformsIni['clearafklabel'][0]
              ini.forms.autosetfamgz = AutoformsIni['setfamgz'][0]
              ini.forms.autodelhname = AutoformsIni['delhname'][0]
              ini.forms.autodelbname = AutoformsIni['delbname'][0]
              ini.forms.autowarnoff = AutoformsIni['warnoff'][0]
              ini.forms.autounban = AutoformsIni['unban'][0]
              ini.forms.autoafkkick = AutoformsIni['afkkick'][0]
              ini.forms.autoaparkcar = AutoformsIni['aparkcar'][0]
              ini.forms.autosetgangzone = AutoformsIni['setgangzone'][0]
              ini.forms.autosetbizmafia = AutoformsIni['setbizmafia'][0]
              ini.forms.autocleardemorgane = AutoformsIni['cleardemorgane'][0]
              ini.forms.autosban = AutoformsIni['sban'][0]
              ini.forms.autobanip = AutoformsIni['banip'][0]
              ini.forms.autounbanip = AutoformsIni['unbanip'][0]
              ini.forms.autojailoff = AutoformsIni['jailoff'][0]
              ini.forms.automuteoff = AutoformsIni['muteoff'][0]
              ini.forms.autoskick = AutoformsIni['skick'][0]
              ini.forms.autosetskin = AutoformsIni['setskin'][0]
              ini.forms.autouval = AutoformsIni['uval'][0]
              ini.forms.autoao = AutoformsIni['ao'][0]
              ini.forms.autounapunishoff = AutoformsIni['unapunishoff'][0]
              ini.forms.autounjailoff = AutoformsIni['unjailoff'][0]
              ini.forms.autounmuteoff = AutoformsIni['unmuteoff'][0]
              ini.forms.autounwarnoff = AutoformsIni['unwarnoff'][0]
              ini.forms.autobizlock = AutoformsIni['bizlock'][0]
              ini.forms.autobizopen = AutoformsIni['bizopen'][0]
              ini.forms.autocinemaunrent = AutoformsIni['cinemaunrent'][0]
              ini.forms.autobanipoff = AutoformsIni['banipoff'][0]
              ini.forms.autobanoff = AutoformsIni['banoff'][0]
              ini.forms.autoagl = AutoformsIni['agl'][0]
              ini.forms.autormute = AutoformsIni['rmute'][0]
              ini.forms.autounrmute = AutoformsIni['unrmute'][0]
              ini.forms.autoclearad = AutoformsIni['clearad'][0]
              ini.main.cdacceptform = inputs['cdacceptform'][0]
        
              save()
              acceptform.v = mysplit(ini.binds.acceptform, ",")
              imgui.Text(u8'Бинд принятия: ')
              imgui.SameLine()
              if imgui.HotKey("##acceptform", acceptform, 70, 25) then
                  ini.binds.acceptform = table.concat((acceptform.v), ",")
                  save()
                  sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.SameLine()
              imgui.Question("##bindacceptform", u8"При нажатии на данную клавишу, вы сможете принять форму из админ чата")
              imgui.Text(u8"Время ожидания принятия формы: ")
              imgui.SameLine()
              imgui.PushItemWidth(20)
              if imgui.InputInt("##cdacceptform", inputs['cdacceptform'], 0) then
                if inputs['cdacceptform'][0] < 5 then inputs['cdacceptform'][0] = 5 end
                if inputs['cdacceptform'][0] > 30 then inputs['cdacceptform'][0] = 30 end
                ini.main.cdacceptform = inputs['cdacceptform'][0]
                save()
              end
              imgui.PopItemWidth()
              if imgui.Button(u8"Автоматическая настройка под уровень", imgui.ImVec2(300,20)) then setPermission() end
              imgui.NewLine()
              imgui.Separator()
              imgui.Columns(3, "commandsform", true)
              imgui.PushFont(imFont[18])
              imgui.TextColored(mc, u8"Команда")
              imgui.NextColumn()
              imgui.TextColored(mc, u8"Принимать вручную")
              imgui.NextColumn()
              imgui.TextColored(mc, u8"Автопринятие")
              imgui.PopFont()
              imgui.NextColumn()
              imgui.Separator()
              for i, v in pairs(forms) do
                imgui.Button(u8("/" .. v), imgui.ImVec2(220, 20))
                imgui.NextColumn()
                imgui.Checkbox(u8"##6546g" .. i, formsIni[v])
                imgui.NextColumn()
                imgui.Checkbox(u8"##656g" .. i, AutoformsIni[v])
                imgui.NextColumn()
                imgui.Separator()
              end
              save()
              imgui.Columns(1)
            elseif formsettings_list[0] == 2 then
              fastnak.v = mysplit(ini.binds.fastnak, ",")
              imgui.Text(u8"Клавиша для открытия окна выдачи наказаний: ")
              imgui.SameLine()
              if imgui.HotKey("##fastnak", fastnak, 70, 25) then
                ini.binds.fastnak = table.concat((fastnak.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Задержка: ")
              imgui.SameLine()
              imgui.PushItemWidth(50)
              if imgui.InputInt("##delay_fastnak", inputs['delay_fastnak'], 0) then
                if inputs['delay_fastnak'][0] < 0 then inputs['delay_fastnak'][0] = 0 end
                ini.main.delay_fastnak = inputs['delay_fastnak'][0]
                save()
              end
              imgui.PopItemWidth()
              imgui.SameLine()
              imgui.Text(u8"мс.")
              imgui.Question("delay_fastnak", u8"Введите число 0, чтобы отключить задержку.\n1000 мс = 1 секунда")
              imgui.Text(u8"Авторазбан: ")
              imgui.SameLine()
              if addons.ToggleButton("##autounbanfastnak", toggles['fastnakban']) then
                ini.main.fastnakban = toggles['fastnakban'][0]
                save()
              end
              imgui.Question("fastnakban", u8"Автоматическая нажимает кнопку подтверждение при принятии формы на /unban в окне выдачи наказний")
            end
          imgui.EndChild()
          imgui.PopStyleVar()
        elseif listmenu == 6 then -- Рекон
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[25])
          imgui.Text(u8"Рекон")
          imgui.PopFont()
          imgui.SetCursorPosX(75)
          imgui.SetCursorPosY(75)
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.BeginChild('##usersettingsmainwindow'..listmenu,false)
            imgui.Text(u8'Местоположение окна статистики рекона: ')
            imgui.SameLine()
              if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##statsreconPosition', imgui.ImVec2(33, 20)) then
                lua_thread.create(function()
                  local backup = {
                    ['x'] = ini.recon.x,
                    ['y'] = ini.recon.y
                  }
                  ChangePosReconStats = true
                  showCursor(true)
                  admin_menu[0] = false
                  sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                  if not sampIsChatInputActive() then
                    while not sampIsChatInputActive() and ChangePosReconStats do
                      showCursor(true)
                        wait(0)
                        showCursor(true)
                        ini.recon.x, ini.recon.y = getCursorPos()
                        local cX, cY = getCursorPos()
                        admins['posstatsrecon'].x = cX
                        admins['posstatsrecon'].y = cY
                        if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                          showCursor(false)
                          ChangePosReconStats = false
                          sampAddChatMessage(tag..'Позиция сохранена!', -1)
                        elseif isKeyJustPressed(VK_ESCAPE) then
                          ChangePosReconStats = false
                          showCursor(false)
                          admins['posstatsrecon'].x = backup['x']
                          admins['posstatsrecon'].y = backup['y']
                          sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                        end
                    end
                  end
                  ini.recon.x = admins['posstatsrecon'].x
                  ini.recon.y = admins['posstatsrecon'].y 
                  showCursor(false)
                  ChangePosReconStats = false
                  ableclickwarp = false
                  admin_menu[0] = true
                  end)
                end
            imgui.Text(u8'Местоположение окна рекона: ')
            imgui.SameLine()
              if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##statsrecon', imgui.ImVec2(33, 20)) then
                lua_thread.create(function()
                  local backup = {
                    ['x'] = ini.recon.funcx,
                    ['y'] = ini.recon.funcy
                  }
                  ChangePosRecon = true
                  showCursor(true)
                  admin_menu[0] = false
                  sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                  if not sampIsChatInputActive() then
                    while not sampIsChatInputActive() and ChangePosRecon do
                      showCursor(true)
                        wait(0)
                        showCursor(true)
                        ini.recon.funcx, ini.recon.funcy = getCursorPos()
                        local cX, cY = getCursorPos()
                        admins['posrecon'].x = cX
                        admins['posrecon'].y = cY
                        if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                          showCursor(false)
                          ChangePosRecon = false
                          sampAddChatMessage(tag..'Позиция сохранена!', -1)
                        elseif isKeyJustPressed(VK_ESCAPE) then
                          ChangePosRecon = false
                          showCursor(false)
                          admins['posrecon'].x = backup['x']
                          admins['posrecon'].y = backup['y']
                          sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                        end
                    end
                  end
                  ini.recon.funcx = admins['posrecon'].x
                  ini.recon.funcy = admins['posrecon'].y 
                  showCursor(false)
                  ChangePosRecon = false
                  ableclickwarp = false
                  admin_menu[0] = true
                  end)
                end
            imgui.Text(u8"Авто /b в реконе: ")
            imgui.SameLine()
            if addons.ToggleButton("##autobinrec", toggles['autobrec']) then
              ini.main.autobrec = toggles['autobrec'][0]
            end
            imgui.Question("poleznoautobrec", u8"Автоматически пишет текст в /b при нахождении в реконе\nПолезно, так как обычный чат в реконе - игроки не видят")
            save()
          imgui.EndChild()
          imgui.PopStyleVar()
        elseif listmenu == 7 then -- Репорт
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[25])
          imgui.Text(u8"Репорт")
          imgui.PopFont()
          imgui.SetCursorPos(imgui.ImVec2(15,65))
          imgui.BeginGroup()
          imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.05,0.5))
          for k, i in pairs(reportsettings) do
            local clr = imgui.GetStyle().Colors[imgui.Col.Text].x
            if reportsettings_list[0] == k then
              local p = imgui.GetCursorScreenPos()
              imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y + 10),imgui.ImVec2(p.x + 3, p.y + 25), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Border]), 5, imgui.DrawCornerFlags.Right)
            end
            imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(clr,clr,clr,reportsettings_list[0] == k and 0.1 or 0))
            imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(clr,clr,clr,0.15))
            imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(clr,clr,clr,0.1))
            if imgui.AnimButton(i, imgui.ImVec2(162,35)) then
              if reportsettings_list[0] ~= k then
                reportsettings_list[0] = k
                alpha[0] = os.clock()
              end
            end
            imgui.PopStyleColor(3)
          end
          imgui.PopStyleVar()
          imgui.EndGroup()
          imgui.SetCursorPos(imgui.ImVec2(187, 0))
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.BeginChild('##usersettingsmainwindow', false)
            if reportsettings_list[0] == 1 --[[ Настройка ответов ]] then
              for bind_key, bind_name in pairs(ini.cbContent) do
                ini.cbContent[bind_key] = str(bindInputs[bind_key])
                ini.cbToggle[bind_key] = bindToggle[bind_key][0]
                ini.cbName[bind_key] = str(bindName[bind_key])
                save()
              end
              imgui.SubTitle(u8"Теги:")
              imgui.NewLine()
              imgui.Text(u8"{rep_id} - ID автора репорта")
              imgui.Text(u8"{rep_nick} - Nick автора репорта")
              imgui.Text(u8"{my_id} - Ваш ID")
              imgui.Text(u8"{my_nick} - Ваш Nick")
              imgui.Separator()
              imgui.SubTitle(u8"Стандартные кнопки:")
              imgui.NewLine()
              imgui.Text(u8"Слежка за наруш.: ")
              imgui.SameLine()
              imgui.SetCursorPosX(150)
              if imgui.InputText("##spyingreport", inputs['spyingreport'], sizeof(inputs['spyingreport'])) then
                ini.main.spyingreport = u8:decode(str(inputs['spyingreport']))
                save()
              end
              imgui.Text(u8"Помочь автору: ")
              imgui.SameLine()
              imgui.SetCursorPosX(150)
              if imgui.InputText("##helpreport", inputs['helpreport'], sizeof(inputs['helpreport'])) then
                ini.main.helpreport = u8:decode(str(inputs['helpreport']))
                save()
              end
              imgui.Text(u8"Передать репорт: ")
              imgui.SameLine()
              imgui.SetCursorPosX(150)
              if imgui.InputText("##givereport", inputs['givereport'], sizeof(inputs['givereport'])) then
                ini.main.givereport = u8:decode(str(inputs['givereport']))
                save()
              end
              imgui.Separator()
              if imgui.Button(u8"Добавить кнопку в окно репорта", imgui.ImVec2(700, 30)) then
                ini.cbName[#ini.cbName+1] = ""
                ini.cbContent[#ini.cbContent+1] = ""
                save()
                for k,v in pairs(ini.cbContent) do
                  bindInputs[#bindInputs+1] = new.char[256]()
                  bindToggle[#bindToggle+1] = new.bool(false)
                end
                for k,v in pairs(ini.cbName) do
                  bindName[#bindName+1] = new.char[256]()
                end
              
              end
              imgui.Separator()
              if #ini.cbName > 0 then
                for bind_key, bind_name in pairs(ini.cbName) do
                  imgui.Text(u8"Название: ")
                  imgui.SameLine()
                  imgui.TextColored(mc, bind_name)
                  imgui.SameLine()
                  imgui.SetCursorPosX(410)
                  if imgui.Button(fa.ICON_FA_EDIT.."##"..bind_key) then
                    imgui.OpenPopup("##"..bind_key)
                  end
                  imgui.SameLine()
                  if imgui.Button(fa.ICON_FA_TRASH.."##"..bind_key) then
                    table.remove(ini.cbName, bind_key)
                    table.remove(ini.cbContent, bind_key)
                    table.remove(ini.cbToggle, bind_key)
                    save()
                    table.remove(bindName, bind_key)
                    table.remove(bindInputs, bind_key)
                    table.remove(bindToggle, bind_key)
                  end
                  if imgui.BeginPopupModal("##"..bind_key, false, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar) then
                    imgui.SetNextWindowSize(imgui.ImVec2(600, 600))
                    imgui.Text(u8"Автоматическая отправка: ")
                    imgui.SameLine()
                    addons.ToggleButton("##toglge"..bind_key, bindToggle[bind_key])
                    imgui.Text(u8"Название: ")
                    imgui.SameLine()
                    imgui.PushItemWidth(200)
                    imgui.InputText("##name"..bind_key, bindName[bind_key], 256)
                    imgui.PopItemWidth()
                    imgui.Text(u8"Текст: ")
                    imgui.SameLine()
                    imgui.InputText("##"..bind_key, bindInputs[bind_key], 256)
                    imgui.NewLine()
                    if imgui.Button(u8"Закрыть окно", imgui.ImVec2(600, 30)) then
                      imgui.CloseCurrentPopup()
                    end
                    imgui.EndPopup()
                  end
                  imgui.Text(u8"Текст: ")
                  imgui.SameLine()
                  imgui.TextColored(mc, ini.cbContent[bind_key] or "nil")
                  if ini.cbToggle[bind_key] then
                    imgui.Text(u8"Автоматическая отправка: ")
                    imgui.SameLine()
                    imgui.TextColored(mc, u8"Включено")
                  else
                    imgui.Text(u8"Автоматическая отправка: ")
                    imgui.SameLine()
                    imgui.TextColored(mc, u8"Отключено")
                  end
                  imgui.Separator()
                end
              end
            elseif reportsettings_list[0] == 2 --[[ Автоловля репорта ]] then
              bindotflood.v = mysplit(ini.binds.bind_floodot, ",")
              ini.main.flood_ot = toggles['floodot'][0]
              save()
              imgui.Text(u8"Флуд репорт(/ot): ")
              imgui.SameLine()
              if imgui.HotKey("##bindotflood']", bindotflood, 70, 25) then
                ini.binds.bind_floodot = table.concat((bindotflood.v), ",")
                save()
                sampAddChatMessage(tag.."Успешно!", -1)
              end
              imgui.Text(u8"Задержка: ")
              imgui.SameLine()
              imgui.PushItemWidth(100)
              if imgui.InputInt("##delay_floodot", inputs['delayot'], 1) then
                if inputs['delayot'][0] < 1 then inputs['delayot'][0] = 1 end
                if inputs['delayot'][0] > 1000 then inputs['delayot'][0] = 1000 end
                ini.main.delayot = inputs['delayot'][0]
                save()
              end
              imgui.PopItemWidth()
              imgui.Text(u8"Отключить флуд репорта: ")
              imgui.SameLine()
              addons.ToggleButton("##turnofffloodbyot", toggles['floodot'])
              imgui.SameLine()
              imgui.Question("passseesdf", u8"Удаляет из чата строки по типу:\n[Ошибка] Сейчас нет вопросов в репорт!")
              imgui.Text(u8'Местоположение')
              imgui.SameLine()
              if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##floodotposition', imgui.ImVec2(33, 20)) then
                lua_thread.create(function()
                  local backup = {
                    ['x'] = ini.main.floodposx,
                    ['y'] = ini.main.floodposy
                  }
                  ChangePosFlood = true
                  showCursor(true)
                  admin_menu[0] = false
                  sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                  if not sampIsChatInputActive() then
                      while not sampIsChatInputActive() and ChangePosFlood do
                        showCursor(true)
                          wait(0)
                          showCursor(true)
                          ini.main.floodposx, ini.main.floodposy = getCursorPos()
                          local cX, cY = getCursorPos()
                          admins['posflood'].x = cX
                          admins['posflood'].y = cY
                          if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                              showCursor(false)
                              ChangePosFlood = false
                              sampAddChatMessage(tag..'Позиция сохранена!', -1)
                          elseif isKeyJustPressed(VK_ESCAPE) then
                              ChangePosFlood = false
                              showCursor(false)
                              admins['posflood'].x = backup['x']
                              admins['posflood'].y = backup['y']
                              sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                          end
                      end
                  end
                  ini.main.floodposx = admins['posflood'].x
                  ini.main.floodposy = admins['posflood'].y 
                  showCursor(false)
                  ChangePosFlood = false
                  ableclickwarp = false
                  floodot_window[0] = false
                  admin_menu[0] = true
                end)
              end;
            end
          imgui.EndChild()
					imgui.PopStyleVar()
        elseif listmenu == 8 then -- Контроль AFK
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[22])
          imgui.Text(u8"Контроль AFK")
          imgui.PopFont()
          imgui.SetCursorPosX(75)
          imgui.SetCursorPosY(75)
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.BeginChild('##usersettingsmainwindow'..listmenu,false)
            imgui.Text(u8"Включить Контроль AFK: ")
            imgui.SameLine()
            if addons.ToggleButton("##toggleafk", toggles['afkcontrol']) then
              ini.main.afkcontrol = toggles['afkcontrol'][0]
              save()
            end
            imgui.Text(u8"Лимит АФК: ")
            imgui.SameLine()
            imgui.PushItemWidth(50)
            if imgui.InputInt("##limitafk", inputs['afklimit'], 0) then
              if inputs['afklimit'][0] < 10 then inputs['afklimit'][0] = 10 end
              ini.afk.limit = inputs['afklimit'][0]
              save()
            end
            imgui.PopItemWidth()
            imgui.Text(u8"Предупреждение за: ")
            imgui.SameLine()
            imgui.PushItemWidth(50)
            if imgui.InputInt("##attention", inputs['afkallow'], 0) then
              if inputs['afkallow'][0] > inputs['afklimit'][0] then 
                inputs['afkallow'][0] = 10
              end
              if inputs['afkallow'][0] < 10 then inputs['afkallow'][0] = 10 end
              ini.afk.allow = inputs['afkallow'][0]
              save()
            end
          imgui.PopItemWidth()
          imgui.EndChild()
          imgui.PopStyleVar()
        elseif listmenu == 9 then -- Чекер
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[25])
          imgui.Text(u8"Чекер")
          imgui.PopFont()
          imgui.SetCursorPos(imgui.ImVec2(15,65))
          imgui.BeginGroup()
            imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.05,0.5))
            for k, i in pairs(checkersettings) do
              local clr = imgui.GetStyle().Colors[imgui.Col.Text].x
              if checkersettings_list[0] == k then
                local p = imgui.GetCursorScreenPos()
                imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y + 10),imgui.ImVec2(p.x + 3, p.y + 25), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Border]), 5, imgui.DrawCornerFlags.Right)
              end
              imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(clr,clr,clr,checkersettings_list[0] == k and 0.1 or 0))
              imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(clr,clr,clr,0.15))
              imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(clr,clr,clr,0.1))
              if imgui.AnimButton(i, imgui.ImVec2(175,35)) then
                if checkersettings_list[0] ~= k then
                  checkersettings_list[0] = k
                  alpha[0] = os.clock()
                end
              end
              imgui.PopStyleColor(3)
            end
            imgui.PopStyleVar()
          imgui.EndGroup()
          imgui.SetCursorPos(imgui.ImVec2(195, 0))
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.BeginChild('##usersettingsmainwindow'..listmenu,false)
            imgui.SetCursorPosY(80)
            if checkersettings_list[0] == 1 --[[ Чекер администрации ]] then
              ini.main.ischecker = toggles['checkeradm'][0]
              save()
              imgui.BeginGroup()
                imgui.SubTitle(u8"Основные настройки:")
                imgui.Text(u8"Включить чекер администрации: ")
                imgui.SameLine()
                addons.ToggleButton("##toggleschecker", toggles['checkeradm'])
                imgui.Text(u8"Частота обновления: ")
                imgui.SameLine()
                imgui.PushItemWidth(30)
                if imgui.InputInt("##delay", inputs['delay_checker'], 0) then
                  if inputs['delay_checker'][0] < 5 then inputs['delay_checker'][0] = 5 end
                  if inputs['delay_checker'][0] > 60 then inputs['delay_checker'][0] = 60 end
                  ini.main.delay_checker = inputs['delay_checker'][0]
                end
                imgui.PopItemWidth()
                imgui.Text(u8'Местоположение')
                imgui.SameLine()
                if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##adminsPosition', imgui.ImVec2(33, 20)) then
                  lua_thread.create(function()
                    local backup = {
                      ['x'] = ini.main.posX,
                      ['y'] = ini.main.posY
                    }
                    ChangePos = true
                    showCursor(true)
                    admin_menu[0] = false
                    sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                    if not sampIsChatInputActive() then
                        while not sampIsChatInputActive() and ChangePos do
                          showCursor(true)
                            wait(0)
                            showCursor(true)
                            ini.main.posX, ini.main.posY = getCursorPos()
                            local cX, cY = getCursorPos()
                            admins['pos'].x = cX
                            admins['pos'].y = cY
                            if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                                showCursor(false)
                                ChangePos = false
                                sampAddChatMessage(tag..'Позиция сохранена!', -1)
                            elseif isKeyJustPressed(VK_ESCAPE) then
                                ChangePos = false
                                showCursor(false)
                                admins['pos'].x = backup['x']
                                admins['pos'].y = backup['y']
                                sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                            end
                        end
                    end
                    ini.main.posX = admins['pos'].x
                    ini.main.posY = admins['pos'].y 
                    showCursor(false)
                    ChangePos = false
                    ableclickwarp = false
                    admin_menu[0] = true
                  end)
                end;
      
                imgui.SubTitle(u8'Отображение уровней:')
                for i = 1, 8 do
                  local aname = admNames[i] .. ' (' .. i .. ')'
                  imgui.Text(u8(aname))
                  imgui.SameLine()
                  imgui.SetCursorPosX(180)
                  if addons.ToggleButton(u8("##"..aname), admins['showLvl'][i]) then 
                    ini.level[i] = admins['showLvl'][i][0]
                  end
                end
      
                imgui.SubTitle(u8'Отображение информации:')
                imgui.Text(u8'ID Админа'); imgui.SameLine(80)
                imgui.TextColoredRGB(u8(admins['showInfo'].id[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
                if imgui.IsItemClicked() then
                  admins['showInfo'].id[0] = not admins['showInfo'].id[0]
                  ini.show.id = admins['showInfo'].id[0]
                end
                imgui.Text(u8'Уровень'); imgui.SameLine(80)
                imgui.TextColoredRGB(u8(admins['showInfo'].level[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
                if imgui.IsItemClicked() then
                  admins['showInfo'].level[0] = not admins['showInfo'].level[0]
                  ini.show.level = admins['showInfo'].level[0]
                end
                imgui.Text(u8'AFK'); imgui.SameLine(80)
                imgui.TextColoredRGB(u8(admins['showInfo'].afk[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
                if imgui.IsItemClicked() then
                  admins['showInfo'].afk[0] = not admins['showInfo'].afk[0]
                  ini.show.afk = admins['showInfo'].afk[0]
                end
                imgui.Text(u8'Слежка'); imgui.SameLine(80)
                imgui.TextColoredRGB(u8(admins['showInfo'].recon[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
                if imgui.IsItemClicked() then
                  admins['showInfo'].recon[0] = not admins['showInfo'].recon[0]
                  ini.show.recon = admins['showInfo'].recon[0]
                end
                imgui.Text(u8'Репутация'); imgui.SameLine(80)
                imgui.TextColoredRGB(u8(admins['showInfo'].reputate[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
                if imgui.IsItemClicked() then
                  admins['showInfo'].reputate[0] = not admins['showInfo'].reputate[0]
                  ini.show.reputate = admins['showInfo'].reputate[0]
                end
                imgui.Text(u8'Актив'); imgui.SameLine(80)
                imgui.TextColoredRGB(u8(admins['showInfo'].active[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
                if imgui.IsItemClicked() then
                  admins['showInfo'].active[0] = not admins['showInfo'].active[0]
                  ini.show.active = admins['showInfo'].active[0]
                end
                imgui.Question('active', u8('Актив показывает время (в секундах)\nпосле последнего ответа на репорт'))
                imgui.Text(u8'Это я'); imgui.SameLine(80)
                imgui.TextColoredRGB(u8(admins['showInfo'].selfMark[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
                if imgui.IsItemClicked() then
                  admins['showInfo'].selfMark[0] = not admins['showInfo'].selfMark[0]
                  ini.show.selfMark = admins['showInfo'].selfMark[0]
                end
                imgui.Question('itsMe', u8( string.format('Ваш ник в чекере будет %sпереливаться', ARGBtoStringRGB(rainbow(2)) )))
              imgui.EndGroup()
              imgui.SameLine()
              imgui.SetCursorPosX(imgui.GetCursorPos().x + 100)
              imgui.BeginGroup()
                imgui.SubTitle(u8"Настройка цветов:")
                for lvl, col in ipairs(admins['colors'].lvl) do
                  if imgui.ColorEdit4('##CheckerAdminColor'..lvl, col, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
                    local c = imgui.ImVec4(col[0], col[1], col[2], col[3]) 
                    ini.color[lvl] = imgui.ColorConvertFloat4ToU32(c)
                  end; imgui.SameLine()
                  local aname = admNames[lvl] .. ' (' .. lvl .. ')'
                  imgui.Text(u8(aname))
                end
                imgui.NewLine()
                for name, info in pairs(admins['colors'].content) do
                  if imgui.ColorEdit4('##CheckerContentColor'..name, info[2], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
                    local c = imgui.ImVec4(info[2][0], info[2][1], info[2][2], info[2][3]) 
                    ini.color[name] = imgui.ColorConvertFloat4ToU32(c)
                  end; imgui.SameLine()
                  imgui.Text(u8(info[1]))
                end
                imgui.NewLine()
                imgui.SubTitle(u8"Лимиты:")
      
                imgui.PushItemWidth(40)
                if imgui.InputInt(u8'Лимит АФК##adminsAfkMax', inputs['maxAfk'], 0) then
                  if inputs['maxAfk'][0] < 60 then inputs['maxAfk'][0] = 60 end
                  if inputs['maxAfk'][0] > 3599 then inputs['maxAfk'][0] = 3599 end
                  ini.main.limitmax_afk = inputs['maxAfk'][0]
                end
                imgui.PopItemWidth()
                imgui.Question('maxAfk', u8('При привышении '..ini.main.maxAfk..' секунд, счётчик\nбудет подсвечен {FF0000}красным'))
      
                imgui.PushItemWidth(40)
                if imgui.InputInt(u8'Лимит актива##adminsActiveMax', inputs['maxActive'], 0) then
                  if inputs['maxActive'][0] < 60 then inputs['maxActive'][0] = 60 end
                  if inputs['maxActive'][0] > 3599 then inputs['maxActive'][0] = 3599 end
                  ini.main.maxActive = inputs['maxActive'][0]
                end
                imgui.PopItemWidth()
                imgui.Question('maxActive', u8('При привышении '..ini.main.maxActive..' секунд, счётчик\nбудет подсвечен {FF0000}красным'))
              imgui.EndGroup()
              imgui.BeginGroup()
              imgui.SubTitle(u8"Настройка шрифтов:")
                imgui.PushItemWidth(130)
                if imgui.InputTextWithHint('##FontName', u8'Название шрифта', fonts['input'], ffi.sizeof(fonts['input'])) then
                  ini.font.name = #ffi.string(fonts['input']) > 0 and u8:decode(ffi.string(fonts['input'])) or 'Arial'
                  checker_font = renderCreateFont(ini.font.name, ini.font.size, ini.font.flag)
                end
                imgui.Hint('font_hint_name', u8'Название шрифта')
                if not imgui.IsItemActive() and #ffi.string(fonts['input']) == 0 then
                  imgui.StrCopy(fonts['input'], u8'Arial')
                end
                if imgui.SliderInt('##FontSize', fonts['size'], 1, 25, u8'%d') then
                  if fonts['size'][0] < 1 then fonts['size'][0] = 1 end
                  if fonts['size'][0] > 25 then fonts['size'][0] = 25 end
                  ini.font.size = fonts['size'][0]
                  checker_font = renderCreateFont(ini.font.name, ini.font.size, ini.font.flag)
                end
                imgui.Hint('font_hint_size', u8'Размер шрифта')
                if imgui.SliderInt('##FontFlag', fonts['flag'], 1, 25, u8'%d') then
                  if fonts['flag'][0] < 1 then fonts['flag'][0] = 1 end
                  if fonts['flag'][0] > 25 then fonts['flag'][0] = 25 end
                  ini.font.flag = fonts['flag'][0]
                  checker_font = renderCreateFont(ini.font.name, ini.font.size, ini.font.flag)
                end
                imgui.Hint('font_hint_flag', u8'Флаг шрифта')
                if imgui.SliderInt('##FontOffset', fonts['offset'], 1, 30, u8'%d') then
                  if fonts['offset'][0] < 1 then fonts['offset'][0] = 1 end
                  if fonts['offset'][0] > 30 then fonts['offset'][0] = 30 end
                  ini.font.offset = fonts['offset'][0]
                end
                imgui.Hint('font_hint_offset', u8'Расстояние между строками')
                imgui.PopItemWidth()
                imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 2.0)
                if imgui.BoolButton(ini.font.align == 1, fa.ICON_FA_ALIGN_LEFT, imgui.ImVec2(38, 20)) then
                  ini.font.align = 1
                end
                imgui.SameLine()
                if imgui.BoolButton(ini.font.align == 2, fa.ICON_FA_ALIGN_CENTER, imgui.ImVec2(38, 20)) then
                  ini.font.align = 2
                end
                imgui.SameLine()
                if imgui.BoolButton(ini.font.align == 3, fa.ICON_FA_ALIGN_RIGHT, imgui.ImVec2(38, 20)) then
                  ini.font.align = 3
                end
                imgui.PopStyleVar()
              imgui.EndGroup()
              imgui.NewLine()
              imgui.SetCursorPosX(1)
              imgui.BeginGroup()
                imgui.BeginCustomChild(u8"Кураторы", imgui.ImVec2(220, 317), ini.color[5]) --317
                  imgui.SetCursorPos( imgui.ImVec2(8, 26) )
                  imgui.PushItemWidth(120)
                  imgui.InputTextWithHint('##add5checker', u8'Введите ник куратора', inputs['bufAdd5'], sizeof(inputs['bufAdd5']))
                  imgui.PopItemWidth()
                  imgui.SameLine()
                  local cc = imgui.ColorConvertU32ToFloat4(ini.color[5])
                  imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
                  imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
                  imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
                  if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
                    if #str(inputs['bufAdd5']) > 0 then
                      table.insert(ini.kurators, u8:decode(str(inputs['bufAdd5'])))
                      imgui.StrCopy(inputs['bufAdd5'], '')
                    end
                  end
                  imgui.PopStyleColor(3)
                  if #ini.kurators > 0 then
                    for i, kurator in ipairs(ini.kurators) do 
                      imgui.SetCursorPosX(8)
                      imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, kurator)))
                      imgui.SameLine(imgui.GetWindowWidth() - 30)
                      imgui.Text(fa.ICON_FA_TRASH)
                      if imgui.IsItemClicked() then
                        table.remove(ini.kurators, i)	
                      end
                    end
                  else
                    imgui.SetCursorPosY(110)
                    imgui.CenterTextColored(cc, u8'Список кураторов пуст')
                  end
                imgui.EndChild()
              imgui.EndGroup()
              imgui.SameLine(230)
              imgui.BeginGroup()
                imgui.BeginCustomChild(u8"ЗГА", imgui.ImVec2(200, 147), ini.color[6])
                  imgui.SetCursorPos( imgui.ImVec2(8, 26) )
                  imgui.PushItemWidth(100)
                  imgui.InputTextWithHint('##add6checker', u8'Введите ник ЗГА', inputs['bufAdd6'], sizeof(inputs['bufAdd6']))
                  imgui.PopItemWidth()
                  imgui.SameLine()
                  local cc = imgui.ColorConvertU32ToFloat4(ini.color[6])
                  imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
                  imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
                  imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
                  if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
                    if #str(inputs['bufAdd6']) > 0 then
                      table.insert(ini.zga, u8:decode(str(inputs['bufAdd6'])))
                      imgui.StrCopy(inputs['bufAdd6'], '')
                    end
                  end
                  imgui.PopStyleColor(3)
                  if #ini.zga > 0 then
                    for i, zga in ipairs(ini.zga) do 
                      imgui.SetCursorPosX(8)
                      imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, zga)))
                      imgui.SameLine(imgui.GetWindowWidth() - 30)
                      imgui.Text(fa.ICON_FA_TRASH)
                      if imgui.IsItemClicked() then
                        table.remove(ini.zga, i)	
                      end
                    end
                  else
                    imgui.SetCursorPosY(110)
                    imgui.CenterTextColored(cc, u8'Список ЗГА пуст')
                  end
                imgui.EndChild()
                imgui.NewLine()
                imgui.BeginCustomChild(u8"ГА", imgui.ImVec2(200, 147), ini.color[7])
                  imgui.SetCursorPos( imgui.ImVec2(8, 26) )
                  imgui.PushItemWidth(100)
                  imgui.InputTextWithHint('##add7checker', u8'Введите ник ГА', inputs['bufAdd7'], sizeof(inputs['bufAdd7']))
                  imgui.PopItemWidth()
                  imgui.SameLine()
                  local cc = imgui.ColorConvertU32ToFloat4(ini.color[7])
                  imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
                  imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
                  imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
                  if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
                    if #str(inputs['bufAdd7']) > 0 then
                      table.insert(ini.ga, u8:decode(str(inputs['bufAdd7'])))
                      imgui.StrCopy(inputs['bufAdd7'], '')
                    end
                  end
                  imgui.PopStyleColor(3)
                  if #ini.ga > 0 then
                    for i, ga in ipairs(ini.ga) do 
                      imgui.SetCursorPosX(8)
                      imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, ga)))
                      imgui.SameLine(imgui.GetWindowWidth() - 30)
                      imgui.Text(fa.ICON_FA_TRASH)
                      if imgui.IsItemClicked() then
                        table.remove(ini.ga, i)	
                      end
                    end
                  else
                    imgui.SetCursorPosY(110)
                    imgui.CenterTextColored(cc, u8'Список ГА пуст')
                  end
                imgui.EndChild()
              imgui.EndGroup()
              imgui.SameLine(440)
              imgui.BeginGroup()
              imgui.BeginCustomChild(u8"Спец.Администрация", imgui.ImVec2(220, 317), ini.color[8])
                imgui.SetCursorPos( imgui.ImVec2(8, 26) )
                imgui.PushItemWidth(120)
                imgui.InputTextWithHint('##add8checker', u8'Введите ник Спец.Администратора', inputs['bufAdd8'], sizeof(inputs['bufAdd8']))
                imgui.PopItemWidth()
                imgui.SameLine()
                local cc = imgui.ColorConvertU32ToFloat4(ini.color[8])
                imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
                if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
                  if #str(inputs['bufAdd8']) > 0 then
                    table.insert(ini.special, u8:decode(str(inputs['bufAdd8'])))
                    imgui.StrCopy(inputs['bufAdd8'], '')
                  end
                end
                imgui.PopStyleColor(3)
                if #ini.special > 0 then
                  for i, special in ipairs(ini.special) do 
                    imgui.SetCursorPosX(8)
                    imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, special)))
                    imgui.SameLine(imgui.GetWindowWidth() - 30)
                    imgui.Text(fa.ICON_FA_TRASH)
                    if imgui.IsItemClicked() then
                      table.remove(ini.special, i)	
                    end
                  end
                else
                  imgui.SetCursorPosY(110)
                  imgui.CenterTextColored(cc, u8'Список кураторов пуст')
                end
              imgui.EndChild()
              imgui.EndGroup()
              imgui.NewLine()
            elseif checkersettings_list[0] == 2 --[[ Чекер лидеров/замов ]] then
              imgui.Text(u8"Включить чекер фракций: ")
              imgui.SameLine()
              if addons.ToggleButton("##checkerlead", toggles['checkerlead']) then
                ini.main.checkerlead = toggles['checkerlead'][0]
                statuswaitleader = os.time()
                save()
              end
              imgui.Text(u8'Местоположение')
                imgui.SameLine()
                if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##checkerPosition', imgui.ImVec2(33, 20)) then
                  lua_thread.create(function()
                    local backup = {
                      ['x'] = ini.checkerfrac.posx,
                      ['y'] = ini.checkerfrac.posy
                    }
                    ChangePosCheckerLead = true
                    showCursor(true)
                    admin_menu[0] = false
                    sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                    if not sampIsChatInputActive() then
                        while not sampIsChatInputActive() and ChangePosCheckerLead do
                          showCursor(true)
                            wait(0)
                            showCursor(true)
                            ini.checkerfrac.posx, ini.checkerfrac.posy = getCursorPos()
                            local cX, cY = getCursorPos()
                            admins['poscheckerlead'].x = cX
                            admins['poscheckerlead'].y = cY
                            if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                                showCursor(false)
                                ChangePosCheckerLead = false
                                sampAddChatMessage(tag..'Позиция сохранена!', -1)
                            elseif isKeyJustPressed(VK_ESCAPE) then
                                ChangePosCheckerLead = false
                                showCursor(false)
                                admins['poscheckerlead'].x = backup['x']
                                admins['poscheckerlead'].y = backup['y']
                                sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                            end
                        end
                    end
                    ini.checkerfrac.posx = admins['poscheckerlead'].x
                    ini.checkerfrac.posy = admins['poscheckerlead'].y 
                    save()
                    showCursor(false)
                    ChangePosCheckerLead = false
                    ableclickwarp = false
                    admin_menu[0] = true
                  end)
                end;
              imgui.BeginChild("##fractionstoggle", imgui.ImVec2(325,380), false)
              imgui.SubTitle(u8"Фракции:")
              imgui.Spacing()
              imgui.Columns(4, "##fracscheckertoggle", false)
              for k,v in pairs(fracschecker) do
                imgui.SetColumnWidth(-1, 75)
                imgui.Text(u8(fracschecker[k]['frac'])..": ")
                imgui.NextColumn()
                imgui.SetColumnWidth(-1, 100)
                if addons.ToggleButton("##frac_"..k, fracscheckerIni[k]) then
                  ini.checkerfrac[k] = fracscheckerIni[k][0]
                  save()
                end
                imgui.NextColumn()
              end
              imgui.Columns(1)
              imgui.EndChild()
              imgui.SameLine()
              imgui.BeginChild("##settingsfracscheker", imgui.ImVec2(350, 380), false)
              imgui.SubTitle(u8"Настройки:")
              imgui.Spacing()
              imgui.Text(u8"Ник: ")
              imgui.SameLine()
              imgui.SetCursorPosX(100)
              if addons.ToggleButton("##nickset", toggles['nick']) then
                ini.setcheckerfrac.nick = toggles['nick'][0]
                save()
              end
              imgui.Text(u8"Заместители: ")
              imgui.SameLine()
              imgui.SetCursorPosX(100)
              if addons.ToggleButton("##zamsset", toggles['zams']) then
                ini.setcheckerfrac.zams = toggles['zams'][0]
                save()
              end
              imgui.Text(u8"Состав: ")
              imgui.SameLine()
              imgui.SetCursorPosX(100)
              if addons.ToggleButton("##memberset", toggles['member']) then
                ini.setcheckerfrac.member = toggles['member'][0]
                save()
              end
              imgui.Text(u8"Состав(АФК): ")
              imgui.SameLine()
              imgui.SetCursorPosX(100)
              if addons.ToggleButton("##memberafkset", toggles['memberafk']) then
                ini.setcheckerfrac.memberafk = toggles['memberafk'][0]
                save()
              end

              imgui.NewLine()

              imgui.SubTitle(u8"Лимиты:")
              imgui.Question("limitscheckerld", u8"Если количество игроков меньшее указанного лимита, то текст подсвечивается красным цветом.\nЧтобы отключить, введите число \"0\"")
              imgui.Text(u8"Состав: ")
              imgui.SameLine()
              imgui.SetCursorPosX(100)
              imgui.PushItemWidth(100)
              if imgui.InputInt("##limitmember", inputs['limitmember'], 1) then
                ini.main.limitmember = inputs['limitmember'][0]
                save()
              end
              imgui.PopItemWidth()
              imgui.Text(u8"Заместители: ")
              imgui.SameLine()
              imgui.SetCursorPosX(100)
              imgui.PushItemWidth(100)
              if imgui.InputInt("##limitzams", inputs['limitzams'], 1) then
                ini.main.limitzams = inputs['limitzams'][0]
                save()
              end
              imgui.PopItemWidth()

              imgui.NewLine()

              imgui.SubTitle(u8"Доп.возможности:")
              imgui.Text(u8"Авто /amember по нажатию:")
              imgui.SameLine()
              imgui.SetCursorPosX(200)
              if addons.ToggleButton('##amemberchecker', toggles['amemberchecker']) then
                ini.main.amemberchecker = toggles['amemberchecker'][0]
                save()
              end
              imgui.Question("amemberchecker", u8"Автоматически прописывает \"/amember {фракция} 9\" при нажатии на фракцию")
              imgui.Text(u8"Авто /re по нажатию:")
              imgui.SameLine()
              imgui.SetCursorPosX(200)
              if addons.ToggleButton('##rechecker', toggles['rechecker']) then
                ini.main.rechecker = toggles['rechecker'][0]
                save()
              end
              imgui.Question("rechecker", u8"Автоматически прописывает \"/re\" при нажатии на лидера")

              imgui.EndChild()
            elseif checkersettings_list[0] == 3 --[[ Чекер игроков ]] then
              imgui.Text(u8"Включить чекер игроков: ")
              imgui.SameLine()
              if addons.ToggleButton("##togglecheckerfriends", toggles['checkerfriends']) then
                ini.main.checkerfriends = toggles['checkerfriends'][0]
                save()
              end
              imgui.Text(u8'Местоположение')
              imgui.SameLine()
              if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##checkerfriends', imgui.ImVec2(33, 20)) then
                lua_thread.create(function()
                  local backup = {
                    ['x'] = ini.main.friendsx,
                    ['y'] = ini.main.friendsy
                  }
                  ChangePosCheckerFriend = true
                  showCursor(true)
                  admin_menu[0] = false
                  sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                  if not sampIsChatInputActive() then
                      while not sampIsChatInputActive() and ChangePosCheckerFriend do
                        showCursor(true)
                          wait(0)
                          showCursor(true)
                          ini.main.friendsx, ini.main.friendsy = getCursorPos()
                          local cX, cY = getCursorPos()
                          admins['poscheckerfriends'].x = cX
                          admins['poscheckerfriends'].y = cY
                          if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                              showCursor(false)
                              ChangePosCheckerFriend = false
                              sampAddChatMessage(tag..'Позиция сохранена!', -1)
                          elseif isKeyJustPressed(VK_ESCAPE) then
                              ChangePosCheckerFriend = false
                              showCursor(false)
                              admins['poscheckerfriends'].x = backup['x']
                              admins['poscheckerfriends'].y = backup['y']
                              sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                          end
                      end
                  end
                  ini.main.friendsx = admins['poscheckerfriends'].x
                  ini.main.friendsy = admins['poscheckerfriends'].y 
                  save()
                  showCursor(false)
                  ChangePosCheckerFriend = false
                  ableclickwarp = false
                  admin_menu[0] = true
                end)
              end;
              imgui.PushItemWidth(130)
              imgui.Text(u8"Расстояние между строками: ")
              imgui.SameLine()
              if imgui.SliderInt('##offsetfriends', inputs['friendsoffset'], 1, 30, u8'%d') then
                if inputs['friendsoffset'][0] < 1 then inputs['friendsoffset'][0] = 1 end
                if inputs['friendsoffset'][0] > 30 then inputs['friendsoffset'][0] = 30 end
                ini.main.friendsoffset = inputs['friendsoffset'][0]
                save()
              end
              imgui.PopItemWidth()
              imgui.SetCursorPosX(10)
              imgui.BeginCustomChild(u8"Игроки", imgui.ImVec2(300, 317), ini.style.color) --317
                imgui.SetCursorPos( imgui.ImVec2(8, 26) )
                imgui.PushItemWidth(200)
                imgui.InputTextWithHint('##checkerfriend', u8'Введите ник игрока', inputs['checkerfriend'], sizeof(inputs['checkerfriend']))
                imgui.PopItemWidth()
                imgui.SameLine()
                local cc = imgui.ColorConvertU32ToFloat4(ini.style.color)
                imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
                if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
                  if #str(inputs['checkerfriend']) > 0 then
                    table.insert(ini.friends, u8:decode(str(inputs['checkerfriend'])))
                    imgui.StrCopy(inputs['checkerfriend'], '')
                  end
                end
                imgui.PopStyleColor(3)
                if #ini.friends > 0 then
                  for i, friends in ipairs(ini.friends) do 
                    imgui.SetCursorPosX(8)
                    imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, friends)))
                    imgui.SameLine(imgui.GetWindowWidth() - 30)
                    imgui.Text(fa.ICON_FA_TRASH)
                    if imgui.IsItemClicked() then
                      table.remove(ini.friends, i)	
                    end
                  end
                else
                  imgui.SetCursorPosY(110)
                  imgui.CenterTextColored(cc, u8'Список игроков пуст')
                end
              imgui.EndChild()
            elseif checkersettings_list[0] == 4 --[[ Лог отключения ]] then
              imgui.Text(u8"Включить лог: ")
              imgui.SameLine()
              if addons.ToggleButton("##logconnecting", toggles['logcon']) then
                ini.main.logcon = toggles['logcon'][0]
                save()
              end
              if ini.main.logcon then
                imgui.Text(u8"Лимит строк: ")
                imgui.SameLine()
                imgui.PushItemWidth(100)
                if imgui.InputInt("##limit", inputs['logconlimit'], 1) then
                  if inputs['logconlimit'][0] < 3 then inputs['logconlimit'][0] = 3 end
                  if inputs['logconlimit'][0] > 20 then inputs['logconlimit'][0] = 20 end
                  ini.main.logconlimit = inputs['logconlimit'][0]
                  save()
                  for i=1, #logcon do
                    logcon[i] = nil
                  end
                end
                imgui.PopItemWidth()
                imgui.Text(u8'Местоположение: ')
                imgui.SameLine()
                if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##logdisc', imgui.ImVec2(33, 20)) then
                  lua_thread.create(function()
                    local backup = {
                      ['x'] = ini.main.logconposx,
                      ['y'] = ini.main.logconposy
                    }
                    ChangePosLogDisc = true
                    showCursor(true)
                    admin_menu[0] = false
                    sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                    if not sampIsChatInputActive() then
                      while not sampIsChatInputActive() and ChangePosLogDisc do
                        showCursor(true)
                          wait(0)
                          showCursor(true)
                          ini.main.logconposx, ini.main.logconposy = getCursorPos()
                          local cX, cY = getCursorPos()
                          admins['poslogdisc'].x = cX
                          admins['poslogdisc'].y = cY
                          if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                            showCursor(false)
                            ChangePosLogDisc = false
                            sampAddChatMessage(tag..'Позиция сохранена!', -1)
                          elseif isKeyJustPressed(VK_ESCAPE) then
                            ChangePosLogDisc = false
                            showCursor(false)
                            admins['poslogdisc'].x = backup['x']
                            admins['poslogdisc'].y = backup['y']
                            sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                          end
                      end
                    end
                    ini.main.logconposx = admins['poslogdisc'].x
                    ini.main.logconposy = admins['poslogdisc'].y 
                    showCursor(false)
                    ChangePosLogDisc = false
                    ableclickwarp = false
                    admin_menu[0] = true
                    save()
                    end)
                  end
                imgui.Text(u8"Расстояние между строками: ")
                imgui.SameLine()
                imgui.PushItemWidth(130)
                if imgui.SliderInt('##offsetlog', inputs['logoffset'], 1, 30, u8'%d') then
                  if inputs['logoffset'][0] < 1 then inputs['logoffset'][0] = 1 end
                  if inputs['logoffset'][0] > 30 then inputs['logoffset'][0] = 30 end
                  ini.main.logoffset = inputs['logoffset'][0]
                  save()
                end
                imgui.PopItemWidth()
              end
              
            elseif checkersettings_list[0] == 5 --[[ Лог регистраций ]] then
              imgui.Text(u8"Включить лог регистраций: ")
              imgui.SameLine()
              if addons.ToggleButton("##logregister", toggles['logreg']) then ini.main.logreg = toggles['logreg'][0] end
              if ini.main.logreg then
                imgui.Text(u8"Лимит строк: ")
                imgui.SameLine()
                imgui.PushItemWidth(100)
                if imgui.InputInt("##limitslines", inputs['limitreg'], 1) then
                  if inputs['limitreg'][0] < 3 then inputs['limitreg'][0] = 3 end
                  if inputs['limitreg'][0] > 30 then inputs['limitreg'][0] = 30 end
                  ini.main.limitreg = inputs['limitreg'][0]
                  save()
                end
                imgui.PopItemWidth()
                imgui.Text(u8'Местоположение: ')
                imgui.SameLine()
                if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##logreg', imgui.ImVec2(33, 20)) then
                  lua_thread.create(function()
                    local backup = {
                      ['x'] = ini.main.logregposx,
                      ['y'] = ini.main.logregposy
                    }
                    ChangePosLogReg = true
                    showCursor(true)
                    admin_menu[0] = false
                    sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                    if not sampIsChatInputActive() then
                      while not sampIsChatInputActive() and ChangePosLogReg do
                        showCursor(true)
                          wait(0)
                          showCursor(true)
                          ini.main.logregposx, ini.main.logregposy = getCursorPos()
                          local cX, cY = getCursorPos()
                          admins['poslogreg'].x = cX
                          admins['poslogreg'].y = cY
                          if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                            showCursor(false)
                            ChangePosLogReg = false
                            sampAddChatMessage(tag..'Позиция сохранена!', -1)
                          elseif isKeyJustPressed(VK_ESCAPE) then
                            ChangePosLogReg = false
                            showCursor(false)
                            admins['poslogreg'].x = backup['x']
                            admins['poslogreg'].y = backup['y']
                            sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                          end
                      end
                    end
                    ini.main.logregposx = admins['poslogreg'].x
                    ini.main.logregposy = admins['poslogreg'].y 
                    showCursor(false)
                    ChangePosLogReg = false
                    ableclickwarp = false
                    admin_menu[0] = true
                    save()
                    end)
                  end
                  
                imgui.Text(u8"Расстояние между строками: ")
                imgui.SameLine()
                imgui.PushItemWidth(130)
                if imgui.SliderInt('##regoffset', inputs['regoffset'], 1, 30, u8'%d') then
                  if inputs['regoffset'][0] < 1 then inputs['regoffset'][0] = 1 end
                  if inputs['regoffset'][0] > 30 then inputs['regoffset'][0] = 30 end
                  ini.main.regoffset = inputs['regoffset'][0]
                  save()
                end
                imgui.PopItemWidth()
              end
            end
          imgui.EndChild()
          imgui.PopStyleVar()
        elseif listmenu == 10 then -- Чаты
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          if imgui.InvisibleButton('##butttt',imgui.ImVec2(20,15)) then
            listmenu = 0
            alpha[0] = os.clock()
          end
          imgui.SetCursorPos(imgui.ImVec2(15,20))
          imgui.PushFont(imFont[16])
          imgui.TextColored(imgui.IsItemHovered() and imgui.GetStyle().Colors[imgui.Col.Text] or imgui.GetStyle().Colors[imgui.Col.TextDisabled], fa.ICON_FA_CHEVRON_LEFT..fa.ICON_FA_CHEVRON_LEFT)
          imgui.PopFont()
          imgui.SameLine()
          local p = imgui.GetCursorScreenPos()
          imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + 5, p.y - 10),imgui.ImVec2(p.x + 5, p.y + 26), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.TextDisabled]), 1.5)
          imgui.SetCursorPos(imgui.ImVec2(60,15))
          imgui.PushFont(imFont[22])
          imgui.Text(u8"Чаты")
          imgui.PopFont()
          imgui.SetCursorPosX(10)
          imgui.SetCursorPosY(75)
          imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, ImSaturate(1 / (alphaAnimTime / (os.clock() - alpha[0]))))
          imgui.BeginChild('##usersettingsmainwindow'..listmenu,false)
            imgui.PushFont(imFont[16])
            imgui.CenterTextColored(imgui.ImVec4(1,1,1,1), u8"[ Дальний чат ]")
            imgui.PopFont()
            imgui.Text(u8"Включить дальний чат: ")
            imgui.SameLine()
            if addons.ToggleButton("##turnonfarchat", toggles['isfarchat']) then
              ini.main.isfarchat = toggles['isfarchat'][0]
              save()
            end
            imgui.Text(u8"Лимит строк: ")
            imgui.SameLine()
            imgui.PushItemWidth(100)
            if imgui.InputInt("##farchatlimit", inputs['farchatlimit'], 1) then
              if inputs['farchatlimit'][0] < 3 then inputs['farchatlimit'][0] = 3 end
              if inputs['farchatlimit'][0] > 20 then inputs['farchatlimit'][0] = 20 end
              ini.main.farchatlimit = inputs['farchatlimit'][0]
              save()
              for i=1, #farchat do
                farchat[i] = nil
              end
            end
            imgui.Text(u8"Расстояние между строками: ")
            imgui.SameLine()
            if imgui.SliderInt('##offsetfarchat', inputs['farchatoffset'], 1, 30, u8'%d') then
              if inputs['farchatoffset'][0] < 1 then inputs['farchatoffset'][0] = 1 end
              if inputs['farchatoffset'][0] > 30 then inputs['farchatoffset'][0] = 30 end
              ini.main.farchatoffset = inputs['farchatoffset'][0]
              save()
            end
            imgui.Text(u8'Местоположение')
              imgui.SameLine()
              if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##farchat', imgui.ImVec2(33, 20)) then
                lua_thread.create(function()
                  local backup = {
                    ['x'] = ini.main.farchatx,
                    ['y'] = ini.main.farchaty
                  }
                  ChangePosFarChat = true
                  showCursor(true)
                  admin_menu[0] = false
                  sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                  if not sampIsChatInputActive() then
                      while not sampIsChatInputActive() and ChangePosFarChat do
                        showCursor(true)
                          wait(0)
                          showCursor(true)
                          ini.main.farchatx, ini.main.farchaty = getCursorPos()
                          local cX, cY = getCursorPos()
                          admins['posfarchat'].x = cX
                          admins['posfarchat'].y = cY
                          if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                              showCursor(false)
                              ChangePosFarChat = false
                              sampAddChatMessage(tag..'Позиция сохранена!', -1)
                          elseif isKeyJustPressed(VK_ESCAPE) then
                              ChangePosFarChat = false
                              showCursor(false)
                              admins['posfarchat'].x = backup['x']
                              admins['posfarchat'].y = backup['y']
                              sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                          end
                      end
                  end
                  ini.main.farchatx = admins['posfarchat'].x
                  ini.main.farchaty = admins['posfarchat'].y 
                  save()
                  showCursor(false)
                  ChangePosFarChat = false
                  ableclickwarp = false
                  admin_menu[0] = true
                end)
            end;
            imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 2.0)
            if imgui.BoolButton(ini.font.farchatalign == 1, fa.ICON_FA_ALIGN_LEFT, imgui.ImVec2(38, 20)) then
              ini.font.farchatalign = 1
            end
            imgui.SameLine()
            if imgui.BoolButton(ini.font.farchatalign == 2, fa.ICON_FA_ALIGN_CENTER, imgui.ImVec2(38, 20)) then
              ini.font.farchatalign = 2
            end
            imgui.SameLine()
            if imgui.BoolButton(ini.font.farchatalign == 3, fa.ICON_FA_ALIGN_RIGHT, imgui.ImVec2(38, 20)) then
              ini.font.farchatalign = 3
            end
            imgui.PopStyleVar()
            imgui.Separator()
          imgui.EndChild()
          imgui.PopStyleVar()
        end
      imgui.PopFont()
      imgui.EndChild()
      imgui.End()
			imgui.PopStyleVar()
    end
  ) 

  local askinwindow = imgui.OnFrame(
    function() return askin_window[0] end,
    function(self)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2 , sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(500,800))
      imgui.Begin(u8("ID Скинов"), askin_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoResize)
      local kl = 0
      local posvehx = 5
      local posvehy = 60
      local postextx = 10
      local postexty = 60
      imgui.CenterTextColored(imgui.ImVec4(1,1,1,1), u8"Выберите нужный вам скин кликом ЛКМ")
      imgui.Separator()
      for i = 1, 311, 1 do
          imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
          imgui.BeginChild("##12dsgpokd" .. i, imgui.ImVec2(80, 60))
          imgui.EndChild()    

          if imgui.IsItemClicked() then
              askin_window[0] = false
              sampSendChat(string.format("/setskin %d %d %d",idAskin, i, typeAskin))
          end

          imgui.Hint("askin"..i, u8"Нажмите для\nвыдачи скина " .. i .. u8"\nИгроку " .. sampGetPlayerNickname(idAskin))

          imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
          imgui.Image(skinpng[i], imgui.ImVec2(80, 95))

          postextx = postextx + 100
          posvehx = posvehx + 100
          kl = kl + 1
          if kl > 4 then
              kl = 0
              posvehx = 5
              postextx = 10
              posvehy = posvehy + 120
              postexty = posvehy + 90
          end
      end
      imgui.End()
    end
  ) 

  local avehwindow = imgui.OnFrame(
    function() return aveh_window[0] end,
    function(self)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2 , sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(785,800))
      imgui.Begin(u8("ID Транспорта"), aveh_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoResize)
      imgui.CenterTextColored(imgui.ImVec4(1,1,1,1), u8"Выберите нужный вам транспорт.")
      imgui.Separator()
      kl = 0
      posvehx = 5
      posvehy = 60
      postextx = 10
      postexty = 145

      for i = 400, 611, 1 do
        imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
        imgui.BeginChild("##clickzona" .. i, imgui.ImVec2(115, 80))
        imgui.EndChild()

        if imgui.IsItemClicked() then
          sampSendChat("/plveh " .. idAveh .. " " .. i .. " " .. typeAveh)

          aveh_window[0] = false
        end

        imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
        imgui.Image(VehiclePNG[i], imgui.ImVec2(115, 80))

        if imgui.IsItemHovered() then
          imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
          imgui.Image(VehiclePNG[i], imgui.ImVec2(120, 85))
          imgui.BeginTooltip()
          imgui.TextUnformatted(u8("Нажмите для выдачи транспорта\n\nИгрок: ") .. sampGetPlayerNickname(idAveh) .. u8"\nТранспорт: " .. getNameVehicleModel[i] .. "[" .. i .. "]")
          imgui.EndTooltip()
        end

        imgui.SetCursorPos(imgui.ImVec2(postextx, postexty))
        imgui.Text(getNameVehicleModel[i] .. "[" .. i .. "]")

        postextx = postextx + 130
        posvehx = posvehx + 130
        kl = kl + 1

        if kl > 5 then
          kl = 0
          posvehx = 5
          postextx = 10
          posvehy = posvehy + 110
          postexty = posvehy + 90
        end
      end
      imgui.End()
    end
  ) 

  local agunwindow = imgui.OnFrame(
    function() return agun_window[0] end,
    function(self)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2 , sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(800,sizeY-500))
      imgui.Begin(u8("Выдача оружия игроку " .. sampGetPlayerNickname(idAgun) .. "[" .. idAgun .. "] | Патроны: " .. ammoAgun .. " шт.##аааыв"), agun_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.AlwaysAutoResize)

      kl = 0
      posvehx = 5
      posvehy = 20

      for i = 1, 32, 1 do
        imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
        imgui.BeginChild("##clickzona" .. i, imgui.ImVec2(55, 100))
        imgui.EndChild()

        if imgui.IsItemClicked() then
          sampSendChat("/givegun " .. idAgun .. " " .. gunmass[i] .. " " .. ammoAgun)

          agun_window[0] = false
        end

        imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
        imgui.Image(GunPNG[gunmass[i]], imgui.ImVec2(70, 110))

        if imgui.IsItemHovered() then
          imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
          imgui.Image(GunPNG[gunmass[i]], imgui.ImVec2(75, 115))
          imgui.BeginTooltip()
          imgui.TextUnformatted(u8("Нажмите для выдачи оружия\nИгроку: " .. sampGetPlayerNickname(idAgun).."\nОружие: " .. gunmass[i]))
          imgui.EndTooltip()
        end

        posvehx = posvehx + 80
        kl = kl + 1

        if kl > 9 then
          kl = 0
          posvehx = 5
          posvehy = posvehy + 120
        end
      end
      imgui.End()
    end
  ) 

  local resultfastnakWindow = imgui.OnFrame(
    function() return resultfastnak_window[0] end,
    function()
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(500, 600))
      imgui.Begin(u8"Ошибки при выдачи наказаний", resultfastnak_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
      imgui.Columns(2, "##ColumnsErrors", true)
      for i=1, #outputtext do
        if fastnak_errors[i] ~= nil then
          imgui_text_wrapped(u8(outputtext[i]))
          if imgui.IsItemClicked() then
            setClipboardText(outputtext[i])
            sampAddChatMessage(tag..'Команда успешно скопирована.', -1)
          end
          imgui.NextColumn()
          imgui_text_wrapped(u8(fastnak_errors[i]))
          if imgui.IsItemClicked() then
            setClipboardText(outputtext[i])
            sampAddChatMessage(tag..'Ошибка успешно скопирована.', -1)
          end
          imgui.NextColumn()
          imgui.Separator()
        end
      end
      imgui.Columns(1)
      imgui.End()
    end
  )

  imgui.OnFrame(function() return floodot_window[0] and not isGamePaused() end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(ini.main.floodposx+2, ini.main.floodposy+2))
      imgui.SetNextWindowSize(imgui.ImVec2(220,100))
      imgui.Begin('##asd', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar)
      imgui.SetCursorPos(imgui.ImVec2(10, 10))
      imgui.CenterTextColored(mc, u8"Ловля репорта")
      imgui.Separator()
      imgui.CenterTextColored(mc, u8"Время ожидания:")
      imgui.CenterTextColored(imgui.ImVec4(1,1,1,1), get_timer_minute(os.time()-floodtime))
      imgui.CenterTextColored(mc, u8"Пропущено:")
      imgui.CenterTextColored(imgui.ImVec4(1,1,1,1), tostring(skipped))
      imgui.Separator()
      imgui.End()
    end
  ).HideCursor = true 

  imgui.OnFrame(function() return checkerfrac_window[0] and not isGamePaused() end,
    function(self)
      local chx = 400
      local chy = -500
      if countsettings == 0 then
        chx = 400
        chy = 25
      elseif countsettings == 1 and not ini.setcheckerfrac.nick then
        chx = 250
      elseif countsettings == 1 and ini.setcheckerfrac.nick then
        chx = 220
      elseif countsettings == 2 and not ini.setcheckerfrac.nick then
        chx = 280
      elseif countsettings == 2 and ini.setcheckerfrac.nick then
        chx = 250
      elseif countsettings == 2 and ini.setcheckerfrac.nick and ini.setcheckerfrac.zams then
        chx = 240
      elseif countsettings == 3 and not ini.setcheckerfrac.nick then
        chx = 330 
      elseif countsettings == 3 and ini.setcheckerfrac.nick then
        chx = 280
      elseif countsettings == 3 and ini.setcheckerfrac.nick and ini.setcheckerfrac.member then
        chx = 320
      elseif countsettings == 4 and not ini.setcheckerfrac.nick then
        chx = 310
      elseif countsettings == 4 and ini.setcheckerfrac.nick then
        chx = 320
      end
      if ini.setcheckerfrac.nick then
        chx = chx + 25
      else 
        chx = chx - 125
      end
      imgui.SetNextWindowPos(imgui.ImVec2(ini.checkerfrac.posx+2, ini.checkerfrac.posy+2))
      imgui.SetNextWindowSize(imgui.ImVec2(chx,chy))
      imgui.Begin('##dfаfgf', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        if countsettings == 0 then
          imgui.CenterTextColored(imgui.ImVec4(1,1,1,1), u8"Количество выбранных пунктов менее 1го.")
        else
          imgui.Columns(countsettings+1, "##asddfg", true)
          imgui.SetColumnWidth(-1, 80)
          imgui.CenterColumnText(mc, u8"Фракция")
          imgui.NextColumn()
          if ini.setcheckerfrac.nick then
            imgui.SetColumnWidth(-1, 150)
            imgui.CenterColumnText(mc, u8"Ник")
            imgui.NextColumn()
          end
          if ini.setcheckerfrac.zams then
            imgui.SetColumnWidth(-1, 33)
            imgui.CenterColumnText(mc, u8"Замы")
            imgui.NextColumn()
          end
          if ini.setcheckerfrac.member then
            imgui.SetColumnWidth(-1, 45)
            imgui.CenterColumnText(mc, u8"Состав")
            imgui.NextColumn()
          end
          if ini.setcheckerfrac.memberafk then
            imgui.SetColumnWidth(-1, 35)
            imgui.CenterColumnText(mc, u8"AFK")
            imgui.NextColumn()
          end
          imgui.Separator()
          for k, v in pairs(fracscheckerName) do
            if ini.checkerfrac[fracscheckerName[k]] then
              imgui.SetColumnWidth(-1, 80)
              imgui.CenterColumnText(imgui.ImVec4(1,1,1,1), u8(fracschecker[fracscheckerName[k]]['frac']))
              if ini.main.amemberchecker then
                if imgui.IsItemClicked() then
                  sampSendChat("/amember "..k.." 9")
                end
              end
              imgui.NextColumn()
              if ini.setcheckerfrac.nick then
                imgui.SetColumnWidth(-1, 150)
                if fracschecker[fracscheckerName[k]]['id'] == "Оффлайн" then
                  imgui.CenterColumnText(imgui.ImVec4(1,0,0,1), u8"Не в сети")
                else
                  imgui.CenterColumnText(imgui.ImVec4(1,1,1,1), u8(fracschecker[fracscheckerName[k]]['nick'].."["..fracschecker[fracscheckerName[k]]['id'].."]"))
                  if ini.main.rechecker then
                    if imgui.IsItemClicked() then
                      sampSendChat("/re "..string.match(fracschecker[fracscheckerName[k]]['id'], "%d+"))
                      rInfo['id'] = string.match(fracschecker[fracscheckerName[k]]['id'], "%d+")
                    end
                  end
                end
                imgui.NextColumn()
              end
              if ini.setcheckerfrac.zams then
                imgui.SetColumnWidth(-1, 33)
                if tonumber(fracschecker[fracscheckerName[k]]['zams']) < ini.main.limitzams then
                  imgui.CenterColumnText(imgui.ImVec4(1,0,0,1), tostring(fracschecker[fracscheckerName[k]]['zams']))
                else
                  imgui.CenterColumnText(imgui.ImVec4(1,1,1,1), tostring(fracschecker[fracscheckerName[k]]['zams']))
                end
                imgui.NextColumn()
              end
              if ini.setcheckerfrac.member then
                imgui.SetColumnWidth(-1, 45)
                if tonumber(fracschecker[fracscheckerName[k]]['member']) < ini.main.limitmember then
                  imgui.CenterColumnText(imgui.ImVec4(1,0,0,1), u8(fracschecker[fracscheckerName[k]]['member']))
                else
                  imgui.CenterColumnText(imgui.ImVec4(1,1,1,1), u8(fracschecker[fracscheckerName[k]]['member']))
                end
                imgui.NextColumn()
              end
              if ini.setcheckerfrac.memberafk then
                imgui.SetColumnWidth(-1, 35)
                imgui.CenterColumnText(imgui.ImVec4(1,1,1,1), u8(fracschecker[fracscheckerName[k]]['memberafk']))
                imgui.NextColumn()
              end
              imgui.Separator()
            end
          end
          imgui.Columns(1)
        end
      imgui.End()
    end
  ).HideCursor = true 

  imgui.OnInitialize(function()
    imFont = {}
    local config = imgui.ImFontConfig()
    config.MergeMode, config.PixelSnapH = true, true
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local iconRanges = new.ImWchar[3](fa.min_range, fa.max_range, 0)
    local mainFont = getFolderPath(0x14) .. '\\trebucbd.ttf'
    local iconFont = getWorkingDirectory() .. '\\Lulu Tools\\fonts\\fa-solid-900.ttf'

    img = imgui.CreateTextureFromFile(getGameDirectory() .. '\\moonloader\\Lulu Tools\\images\\color.jpg') 
   	imgui.GetIO().Fonts:Clear()
   	imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 12.0, nil, glyph_ranges)
   	imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 15.0, config, iconRanges)

   	imFont[11] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 11.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 11.0, config, iconRanges)

   	imFont[12] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 12.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 12.0, config, iconRanges)

   	imFont[13] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 13.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 13.0, config, iconRanges)

    imFont[16] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 16.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 16.0, config, iconRanges)

    imFont[18] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 18.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 18.0, config, iconRanges)


    imFont[20] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 20.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 20.0, config, iconRanges)

    imFont[22] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 22.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 22.0, config, iconRanges)
    
    imFont[25] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 25.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 25.0, config, iconRanges)
    
    imFont[50] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 50.0, nil, glyph_ranges)

    theme()
    for k, v in pairs(gunmass) do
      if not doesFileExist("moonloader\\Lulu Tools\\Weapon\\wep_" .. v .. ".png") then
        downloadUrlToFile("https://lulu-bot.tech/tools/Weapon/wep_" .. v .. ".png", "moonloader\\Lulu Tools\\Weapon\\wep_" .. v .. ".png", function (d, status, p1, p2)
          if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            sampShowDialog(8919484915, "Загружен файл wep_" ..v.. ".png", "Установка дополнительных файлов", "ОК", "", 0)
            GunPNG[v] = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\Lulu Tools\\Weapon\\wep_" .. v .. ".png")
          end
        end)
      end
    end

    if not doesDirectoryExist("moonloader\\Lulu Tools\\skins") then
      createDirectory("moonloader\\Lulu Tools\\skins")
      sampAddChatMessage(tag.."Началась установка дополнительных файлов(Скины).", -1)
    end
    for i = 1, 311, 1 do
      if not doesFileExist("moonloader\\Lulu Tools\\skins\\skin_" .. i .. ".png") then
        downloadUrlToFile("https://lulu-bot.tech/tools/skins/Skin_" .. i .. ".png", "moonloader\\Lulu Tools\\skins\\skin_" .. i .. ".png", function (id, status, p1, p2)
          if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            sampShowDialog(89194849, "Загружен файл Skin_" ..i.. ".png", "Установка дополнительных файлов", "ОК", "", 0)
            skinpng[i] = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\Lulu Tools\\skins\\Skin_" .. i .. ".png")
          end
        end)
      end
    end

    if not doesDirectoryExist("moonloader\\Lulu Tools\\Vehicle") then
      createDirectory("moonloader\\Lulu Tools\\Vehicle")
      sampAddChatMessage(tag.."Началась установка дополнительных файлов(Транспорт).", -1)
    end
    for i = 400, 611, 1 do
      if not doesFileExist("moonloader\\Lulu Tools\\Vehicle\\Vehicle_" .. i .. ".jpg") then
        downloadUrlToFile("https://lulu-bot.tech/tools/Vehicle/Vehicle_" .. i .. ".jpg", "moonloader\\Lulu Tools\\vehicle\\Vehicle_" .. i .. ".jpg", function (id, status, p1, p2)
          if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            sampShowDialog(891948491, "Загружен файл Vehicle_" ..i.. ".jpg", "Установка дополнительных файлов", "ОК", "", 0)
            VehiclePNG[i] = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\Lulu Tools\\vehicle\\vehicle_" .. i .. ".jpg")
          end
        end)
      end
    end
    if not doesDirectoryExist("moonloader\\Lulu Tools\\Weapon") then
      createDirectory("moonloader\\Lulu Tools\\Weapon")
      sampAddChatMessage(tag.."Началась установка дополнительных файлов(Оружие).", -1)
    end
    for i = 1, 311, 1 do
        skinpng[i] = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\Lulu Tools\\skins\\skin_" .. i .. ".png")
    end
    
    for i = 400, 611, 1 do
      VehiclePNG[i] = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\Lulu Tools\\vehicle\\vehicle_" .. i .. ".jpg")
    end
    for k, v in pairs(gunmass) do
      GunPNG[v] = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\Lulu Tools\\Weapon\\wep_" .. v .. ".png")
    end
  end)

----------------------------------------------------------------------

--                 Хуки

  function sampev.onSendMapMarker(position)
    if ini.main.fixtp then
      lua_thread.create(function ()
        xpostp, ypostp, zpostp = getCharCoordinates(PLAYER_PED)
        
        local px, py, pz = getCharCoordinates(PLAYER_PED)

        sendClickMap(position.x, position.y, position.z)

        local time = os.time()

        if getDistanceBetweenCoords3d(xpostp, ypostp, zpostp, position.x, position.y, position.z) > 5 then
          while getDistanceBetweenCoords3d(xpostp, ypostp, zpostp, position.x, position.y, position.z) > 5 and os.time() - time < 2 do
            wait(0)

            xpostp, ypostp, zpostp = getCharCoordinates(PLAYER_PED)
          end
        end

        xpostp, ypostp, zpostp = getCharCoordinates(PLAYER_PED)

        sendClickMap(xpostp, ypostp, getGroundZFor3dCoord(xpostp, ypostp, 999))
      end)

      return false
    else
      sendClickMap(position.x, position.y, getGroundZFor3dCoord(position.x, position.y, 999))

      return false
    end
  end

  function sampev.onDisplayGameText(style, time, text)
    if text:find("Report++") then
      return false
    end
    if text:find("Welcome") then
      lua_thread.create(function()
        wait(1000)
        if #tostring(ini.main.pass_adm) > 4 then
          sampSendChat("/apanel")
        end
      end)
    end
  end

  function sampev.onTogglePlayerControllable(controllable)
    if not controllable and ini.main.antifreeze then
      return false
    end
  end

  function sampev.onServerMessage(color, text)
    if text:find("^{33CC00}Администрация онлайн: %(в сети: (%d+), из них в АФК: (%d+)%)") then
      admins['list'] = { {}, {}, {}, {}, {}, {}, {}, {} }
    end
    if text:find(" Игрок не найден") then
      if rInfo['id'] == "-1" then
        sampAddChatMessage(tag_err.."Игрок с данным ID не найден.", -1)
        rInfo['id'] = "-1"
        rInfo['carid'] = "-1"
        rInfo['iscar'] = false
        rInfo['status'] = false
        recon_window[0] = false
        reconinfo_window[0] = false
        isfrac = false
        main_adm = false
        return false
      else
        sampAddChatMessage(tag_err.."Игрок с данным ID не найден.", -1)
        return false
      end
    end
    if isFastNakActive then
      if text:find("%[Ошибка%] {ffffff}Игрок с ником '.+' не найден базе данных.") then 
        local nickError = text:match("%[Ошибка%] {ffffff}Игрок с ником '(.+)' не найден базе данных.")
        fastnak_errors[#outputtext] = string.format("Игрок с ником %s не найден в базе данных", nickError) 
      elseif text:find("%[Ошибка%] {ffffff}Такой аккаунт не найден в базе данных.") then
        fastnak_errors[#outputtext] = string.format("Игрок с данным ником не найден в базе данных", nickError) 
      elseif text:find("Использовать можно с интервалом в 5 секунд.") then
        fastnak_errors[#outputtext] = text
      end
    end
    if text:find("Используйте: {ffffff}/orgmembers %[ид организации%]") then
      return false
    end
    if text:find("Игрок не найден") then
      rInfo['id'] = -1
      return true
    end
    if text:find("^%[A%] .+%[%d+%]: %[Forma%] %+$") then
      formastop = true
  
      return false
    end
    if statusformerror and (text:find("^Используй: /.+") or text:find("^Используйте: /.+") or text:find("^%[Ошибка%] {FFFFFF}Используй: /.+") or text:find("^%[Ошибка%] У игрока нет варнов!") or text:find("^Этот игрок уже в ТСР!") or text:find("^%[Ошибка%] {ffffff}Игрок не был ранен.") or text:find("^%[Ошибка%] %{......%}Не найдено игроков в AFK более 5 минут.") or text:find("^%[Информация%] %{......%}Вы успешно кикнули 1 игроков!")) or text:find("^%[Ошибка%] %{......%}Вы не можете выдать транспорт игроку в интерьере!") or text:find("^У выбранного игрока посаженных деревьев нет.") then
			sampSendChat("/a " .. formanick .. "[" .. formaid .. "] " .. text)

			statusformerror = false
      formastop = false
			return false
		end
    if statusformerror and (text:find("^Используйте: %{......%}/rmute %[ид игрока/часть ника%] %[количество минут 10%-180%] %[причина%]")) then
      sampSendChat("/a " .. formanick .. "[" .. formaid .. "] Используйте: /rmute [ид] [время 10-180] [причина]")

			statusformerror = false
      formastop = false
			return false
    end
		if statusformerror and (text:find("^Не больше %d+ символов!$") or text:find("^У этого игрока уже есть бан чата!$") or text:find("/unbanip [ip]") or text:find("/warnoff [name] [количество] [причина]") or text:find("^Игрок не в игре!$") or text:find("^%[Ошибка%] {FFFFFF}Игрок не в сети!$") or text:find("^Игрок не законектился еще!$") or text:find("^Этот игрок уже в ДЕМОРГАНЕ!$") or text:find("^Извините , но такого человека сейчас нет в тюрьме!$") or text:find("^%[Ошибка%] {ffffff}Использовать команду можно если онлайн авторизированных игроков более 950.") ) then
			sampSendChat("/a " .. formanick .. "[" .. formaid .. "] " .. text)

			statusformerror = false
      formastop = false

			return false
		end
    if text:match("^%[A%] (.*)%[(%d+)%]: /(.*)") and statsforma and not afktest and not isGamePaused() then
			formanick, formaid, forma = text:match("%[A%] (.*)%[(%d+)%]: (/.*)")
      if formanick ~= self.nick then
        if not formanick:find("%s+") then
          if forma:find("/(%w+)%s*.*") then
            local cmdcheck = forma:match("/(%w+)%s*.*")
            cmdcheck = "auto"..cmdcheck
            if ini.forms[cmdcheck] then
              lua_thread.create(function()
                wait(0)
                sampSendChat("/a [Forma] +")
                sampSendChat(forma)
                statusformerror = false
                printStyledString("Admin form accepted", 1500, 5)
                sampAddChatMessage('{545454}[Admin-Form] Форма >> {E3C47F}'..forma..' {545454}<< выдана!', -1)
              end)
              local n1, n2, n3 = string.match(text, '%[A%] (%a+%_%a+)%[(%d+)%]: (.+)')
              for l=1, 8 do
                for i, v in ipairs(admins['list'][l]) do
                  if v[1] == n1 then
                    if ini.customcolor[n1] ~= nil then
                      text = ("[A] "..ABGRtoStringRGB(ini.customcolor[n1])..n1.."["..n2.."]{99CC00}: "..n3):format(n1, n2, n3)
                    else
                      text = ("[A] "..ABGRtoStringRGB(ini.color[l])..n1.."["..n2.."]{99CC00}: "..n3):format(n1, n2, n3)
                    end
                  end
                end
              end
              return {color, text}
            elseif ini.forms[forma:match("/(%w+)%s*.*")] then
              statsforma = false
              sampAddChatMessage("{545454}[Admin-Form] Найдено форма  >> {E3C47F}"..forma.." {545454}<< Отправитель: {E3C47F}"..formanick.."["..formaid.."]", -1)
              sampAddChatMessage('{545454}[Admin-Form] Нажмите клавишу >> {E3C47F}'..keyname(acceptform.v)..' {545454}<< чтобы принять форму.', -1)
              lua_thread.create(function()
                lasttime = os.time()
                lasttimes = 0
                prinalforma = false
                formastop = false
                while lasttimes < tonumber(ini.main.cdacceptform) do
                  if formastop then
                    sampAddChatMessage("{545454}[Admin Forma] Форма уже принята!", -1)
                    break
                  end
                  lasttimes = os.time() - lasttime
                  wait(0)
                  printStyledString("ADMIN FORM " .. ini.main.cdacceptform - lasttimes .. " WAIT", 1, 5)
                  if prinalforma then
                    timeerr = os.time()
                    statusformerror = true
                    statsforma = true

                    if forma:find("/(%w+)%s+(%d+)%s*(.*)") then
                      cmd, form_id, form_other = forma:match("/(%w+)%s+(%d+)%s*(.*)")

                      if tonumber(form_id) < 0 or tonumber(form_id) > 999 then
                        statsforma = true

                        return
                      end

                      if not sampIsPlayerConnected(tonumber(form_id)) and tonumber(form_id) ~= tonumber(id) and not checkIntable(admins['list'], form_id) and not forma:find("off") and not forma:find("unban") and not forma:find("spcar") and not forma:find("aparkcar") and not forma:find("afkkick") and not forma:find("ao") then
                        sampSendChat("/a [Admin Forma]: Игрок под ID: " .. form_id .. " Оффлайн!")

                        statsforma = true
                        formastop = false

                        return
                      end

                      for l=1, 8 do
                        for i, v in ipairs(admins['list'][l]) do
                          --sampAddChatMessage(v[1], -1)
                          if v[1] == sampGetPlayerNickname(tonumber(form_id)) and not forma:find("plveh") then
                            sampSendChat("/a [Admin Forma]: " .. formanick .. "[" .. formaid .. "] вы пытаетесь наказать администратора >> " .. sampGetPlayerNickname(form_id) .. "[" .. form_id .. "]" .. " <<")
      
                            statsforma = true
                            formastop = false
      
                            return
                          end
                        end
                      end
                    elseif forma:match("/(%w+)%s+(%S+)%s*(.*)") then
                      local cmd, form_nick, form_other = forma:match("/(%w+)%s+(%S+)%s*(.*)")
                      if not isPlayerOnline(tostring(form_nick)) and tostring(form_nick) ~= tostring(getMyNick()) and not forma:find("off") and not forma:find("unban") and not forma:find("spcar") and not forma:find("aparkcar") and not forma:find("afkkick") and not forma:find("ao") then
                        sampSendChat("/a [Admin Forma]: Игрок " .. form_nick .. " оффлайн!")

                        statsforma = true
                        formastop = false

                        return
                      elseif isPlayerOnline(tostring(form_nick)) and tostring(form_nick) ~= tostring(getMyNick()) and formastop then
                        sampSendChat(forma)

                        statsforma = true
                        formastop = false

                        return
                      end

                      for l=1, 8 do
                        for i, v in ipairs(admins['list'][l]) do
                          --sampAddChatMessage(v[1], -1)
                          if v[1] == tonumber(form_id) and not forma:find("plveh") then
                            sampSendChat("/a [Admin Forma]: " .. formanick .. "[" .. formaid .. "] вы пытаетесь наказать администратора >> " .. sampGetPlayerNickname(form_id) .. "[" .. form_id .. "]" .. " <<")
      
                            statsforma = true
                            formastop = false
      
                            return
                          end
                        end
                      end
                    end

                    forma_copy = forma
                    cmd, form_other = forma_copy:match("/(%w+)%s+(.*)")
                    sampSendChat("/a [Forma] +")
                    sampSendChat(forma)
                    formastop = false
                    printStyledString("Admin form accepted", 1500, 5)
                    sampAddChatMessage('{545454}[Admin-Form] Форма >> {E3C47F}'..forma..' {545454}<< выдана!', -1)
                    if os.time() - timeerr < 2 then
                      while os.time() - timeerr < 2 and statusformerror do
                        wait(0)

                        statusformerror = true
                      end
                    end

                    statusformerror = false

                    return
                  end
                end
                statsforma = true
                  printStyledString("You missed the form", 1500, 5)

                  if not formastop then
                    sampAddChatMessage('{545454}[Admin-Form] Форма >> {E3C47F}'..forma..' {545454}<< не принята! Истекло время ожидания.', -1)
                    formastop = false
                  end
              end)
            end
          end
        end
      end
    end 
    if text:find("^Приветствуем нового игрока нашего сервера: %{......%}.+ %{......%}%(ID: %d+%)  %{......%}IP: .+") then
      local reg_nick, reg_id, reg_ip = text:match("Приветствуем нового игрока нашего сервера: %{......%}(.+) %{......%}%(ID: (%d+)%)  %{......%}IP: (.+)")
      text = ABGRtoStringRGB(ini.style.logreg).. "[R] "..reg_nick.."["..reg_id.."] - IP: "..reg_ip

      while #logreg == ini.main.limitreg do table.remove(logreg, 1) end
      logreg[#logreg+1] = text
      logregnick[#logregnick+1] = reg_nick
      logregid[#logregid+1] = reg_id
      return false
    end
    if text:find("^.+%[ID: %d+%] %- %{......%}.+") then
      if not rInfo['statusiskamen2'] then
        local player, status = text:match("^(.+)%[ID: %d+%] %- %{......%}(.+)")
        if rInfo['name'] == player then
          if status:find("не использовал камень пространства") then
            rInfo['iskamen'] = false
          else
            rInfo['iskamen'] = true
          end
        end
        return false
      else
        rInfo['statusiskamen2'] = false
      end
    end
    if text:find("^.+%[ID: %d+%] %- %{......%}.+") then
      if not rInfo['statusistp2'] then
        local player, status = text:match("^(.+)%[ID: %d+%] %- %{......%}(.+)")
        if rInfo['name'] == player then
          if status:find("не использует камень неузвимости") then
            rInfo['lasttp'] = false
          else
            rInfo['lasttp'] = true
          end
        end
      else
        rInfo['statusistp2'] = false
      end
    end
    if text:find("^Игрок .+%[%d+%] подключен с %{......%}.+") then
      if not rInfo['statusclcheck2'] then
        local player, id, client = string.match(text, "^Игрок (.+)%[(%d+)%] подключен с %{......%}(.+)")
        if rInfo['name'] == player then
          if client:find("PC Launcher") then
            rInfo['client'] = "Launcher"
          elseif client:find("Mobile Launcher") then
            rInfo['client'] = "Mobile"
          elseif client:find("нет voice") then
            rInfo['client'] = "Client"
          end
        end
        return false
      else
        rInfo['statusclcheck2'] = false
      end
    end
    local all, inAfk = text:match('^{33CC00}Администрация онлайн: %(в сети: (%d+), из них в АФК: (%d+)%)')
    if all and inAfk then
      admins['online'] = tonumber(all)
      admins['afk'] = tonumber(inAfk)
      admins['count'] = 0
      lua_thread.create(function()
        for _, name in ipairs(ini.kurators) do
          local result, id = getPlayerIdByNickname(name)
          if result then 
            table.insert(admins['list'][5], {name, id, nil, -1, nil})
            admins['online'] = admins['online'] + 1
            admins['count'] = admins['count'] + 1
            admins['active'][name] = false
          end
        end
        for _, name in ipairs(ini.zga) do
          local result, id = getPlayerIdByNickname(name)
          if result then 
            table.insert(admins['list'][6], {name, id, nil, -1, nil})
            admins['online'] = admins['online'] + 1
            admins['count'] = admins['count'] + 1
            admins['active'][name] = false
          end
        end
        for _, name in ipairs(ini.ga) do
          local result, id = getPlayerIdByNickname(name)
          if result then 
            table.insert(admins['list'][7], {name, id, nil, -1, nil})
            admins['online'] = admins['online'] + 1
            admins['count'] = admins['count'] + 1
            admins['active'][name] = false
          end
        end
        for _, name in ipairs(ini.special) do
          local result, id = getPlayerIdByNickname(name)
          if result then 
            table.insert(admins['list'][8], {name, id, nil, -1, nil})
            admins['online'] = admins['online'] + 1
            admins['count'] = admins['count'] + 1
            admins['active'][name] = false
          end
        end
      end)
      return false
    end
    local name, id, lvl, reconInfo, afk, rep = text:match("{fefe22}(.*)%[(%d+)%] %- %[(%d+) lvl%](.*)%[AFK: (%d+)%].*Репутация: (.*)")
    if name and id and lvl and afk and rep then
      if tonumber(id) == selfId then
        if tonumber(lvl) >= 1 and tonumber(lvl) <= 8 then
          ini.main.lvl_adm = tonumber(lvl)
          save()
        end
      end
      local recon = reconInfo:match('/re (%d+)')
      table.insert(admins['list'][tonumber(lvl)], {name, tonumber(id), tonumber(afk), (recon and tonumber(recon) or -1), tonumber(rep)})
      admins['count'] = admins['count'] + 1
      ableautoquest = trues
      if not admins['active'][name] then admins['active'][name] = os.time() end
      if admins['count'] == admins['online'] then requestAdmins = false end
      return false
    end
    if ini.main.ischecker and ini.show.active then
      local admin = text:match('Администратор ([0-9A-z_]+)%[%d+%] ответил игроку')
      if admin and admins['active'][admin] then
        admins['active'][admin] = os.time() 
      end
    end
    if string.find(text, '%[A%] %a+%_%a+%[%d+%]: .+') then
      if admins['list'][1] or admins['list'][2] or admins['list'][3] or admins['list'][4] then
        local n1, n2, n3 = string.match(text, '%[A%] (%a+%_%a+)%[(%d+)%]: (.+)')
        for l=1, 8 do
          for i, v in ipairs(admins['list'][l]) do
            if v[1] == n1 then
              local ac = imgui.ColorConvertU32ToFloat4(ini.style.adminchat)
              ac = imgui.ColorConvertFloat4ToARGB(ac)
              color = argb_to_rgba(ac)
              if ini.customcolor[n1] ~= nil then
                text = (ABGRtoStringRGB(ini.style.adminchat).."[A] "..ABGRtoStringRGB(ini.customcolor[n1])..n1.."["..n2.."]"..ABGRtoStringRGB(ini.style.adminchat)..": "..n3):format(n1, n2, n3)
              else
                text = (ABGRtoStringRGB(ini.style.adminchat).."[A] "..ABGRtoStringRGB(ini.color[l])..n1.."["..n2.."]"..ABGRtoStringRGB(ini.style.adminchat)..": "..n3):format(n1, n2, n3)
              end
            end
          end
        end
      end
      return {color, text}
    end
    if text:find('%[A%] Вы успешно авторизовались как') then
      if ini.main.auto_az then
          sampSendChat("/az")
      end
      if ini.main.spawnset then
        if ini.spcoord.playerX ~= nil and ini.spcoord.playerY ~= nil and ini.spcoord.playerZ ~= nil then
          sendClickMap(ini.spcoord.playerX,ini.spcoord.playerY, ini.spcoord.playerZ)
        end
      end
      sampSendChat("/admins")
      if ini.main.fracauth ~= 0 then 
        sampSendChat("/amember "..ini.main.fracauth.." 9")
      end
      if ini.main.skinauth ~= 0 then
        id = select(2, sampGetPlayerIdByCharHandle(playerPed))
        sampSendChat("/setskin "..id.." "..ini.main.skinauth.." 0")
      end
      if ini.main.intauth ~= 0 then
        sampSendChat("/gotoint "..ini.main.intauth)
      end
      if ini.main.invauth then
        sampSendChat("/inv")
      end
      if ini.main.checkerlead then
        sampSendChat("/orgmembers")
      end
      ableautoquest=true
    end
    if text:find('%[Ошибка%] {FFFFFF}Сейчас нет вопросов в репорт!') and ini.main.flood_ot then
      return false
    end
    if text:find('^Nick %[.+%]  R%-IP %[.+%]  IP | A%-IP %[%{......%}.+ | .+%{......%}%]') then
      if rdata[1] ~= nil then
        for k in pairs (rdata) do
          rdata [k] = nil
        end
      end
      getip_window[0] = false
      ipnick, getipip1, getipip3, getipip2 = string.match(text, '^Nick %[(.+)%]  R%-IP %[(.+)%]  IP | A%-IP %[%{......%}(.+) | (.+)%{......%}%]')
      ip(getipip1.." "..getipip3)
      return false
    end
    if text:find("%[Подсказка%] {FFFFFF}Админское задание успешно завершено. Используйте /apanel %- админские квесты") and ini.main.autoquest then
      statusadminquest = true
      sampSendChat("/apanel")
      statustext = true
      return false
    end
    if text:find("Используйте /quest!") and (statusquest or statusadminquest) and ini.main.autoquest then
      statusquesterr = true
  
      return false
    end
    if ini.main.funcadmin then
      if text:find("^%[A%] Администратор .+%[%d+%] дал поджопник .+%[%d+%]") and ini.main.slapadm then
        return false
      end
      if text:find("^%[A%] .+%[%d+%] флип'нул игрока .+ %[ID:%d+%]") and ini.main.flipadm then
        return false
      end
      if text:find("^.+%[%d+%] начал следить за .+%[%d+%]") and ini.main.spyadm then
        return false
      end
      if text:find('Администратор ([0-9A-z_]+)%[%d+%] ответил игроку') and ini.main.reportadm then
        return false
      end
    end
    if ini.main.bonhead then
      if text:find("%(%( Администратор .+%[%d+%]: %{......%}.+%{......%} %)%)") then
        local nickB, idB, textB = text:match("%(%( Администратор (.+)%[(%d+)%]: %{......%}(.+)%{......%} %)%)")
        if nickB == self.nick then return true end
        bonhead = bonhead + 1
        renderNrp(nickB, idB, textB)
      elseif text:find("%(%( .+%[%d+%]: %{......%}.+%{......%} %)%)") then
        local nickB, idB, textB = text:match("%(%( (.+)%[(%d+)%]: %{......%}(.+)%{......%} %)%)")
        if nickB == self.nick then return true end
        bonhead = bonhead + 1
        renderNrp(nickB, idB, textB)
      end
    end
    if text:find("%[Жалоба%] от .+%[%d+%]:{FFFFFF} .+. Уже .+") then
      if floodot and not report_window[0] then
        skipped = skipped+1
      end
      local n1, n2, n3, n4, n5 = text:match("%[Жалоба%] от (.+)%[(%d+)%]:{FFFFFF} (.+). Уже (%d+) (.+)")
      text = (ABGRtoStringRGB(ini.style.report).."[Жалоба] от "..n1.."["..n2.."]:{FFFFFF} "..n3..". Уже "..ABGRtoStringRGB(ini.style.report)..n4.." {FFFFFF}"..n5)
      local ac = imgui.ColorConvertU32ToFloat4(ini.style.report)
            ac = imgui.ColorConvertFloat4ToARGB(ac)
            color = argb_to_rgba(ac)
      return {color, text}
    end
    if text:find("{DFCFCF}%[Подсказка%] {DC4747}На сервере есть инвентарь, используйте клавишу Y для работы с ним.") then
      if self.nick == "Christopher_Dills" then
        sampAddChatMessage('------------------------------------------------------------------------------------', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage(tag_q..'Здравствуйте, Кристофер Дилллс. Приятного пользования тулсом от сервера Arizona RP - Page.', -1)
        sampAddChatMessage(tag_q..'Это правильный выбор!', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage('------------------------------------------------------------------------------------', -1)
      elseif self.nick == "Merino_Vittozzi" then
        sampAddChatMessage('------------------------------------------------------------------------------------', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage(tag_err..'Вы не можете использовать данный скрипт. Вы в Черном Списке Lulu Tools.', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage('', -1)
        sampAddChatMessage('------------------------------------------------------------------------------------', -1)
        thisScript:unload()
      end
    end
    if text:find("Админский wallhack включен") then
      printString("Wallhack - ~g~ON", 1500)
      return false
    elseif text:find("Админский wallhack выключен") then
      printString("Wallhack - ~r~OFF", 1500)
      return false
    end
    text = separator(text)
    return {color, text}
  end

  function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if string.find(title, "Информация") and string.find(text, "Баланс Фракций") then
      local info = { fractions = {}, price = 0, farm = 0, buy_ls = 0, buy_lv = 0 }
  
      for line in string.gmatch(text, "[^\n]+") do
        local org, balance = string.match(line, "^%- (.+): {%x+}(%d+){%x+}")
        if org and balance then
          table.insert(info.fractions, { org, tonumber(balance) or 0 })
        end
  
        local price = string.match(line, "Цена выкупа: {%x+}(%d+)")
        if price then info.price = tonumber(price) end
  
        local farm = string.match(line, "Закупка продуктов на ферме: {%x+}(%d+)")
        if farm then info.farm = tonumber(farm) end
  
        local buy_ls = string.match(line, "Продажа продуктов в Los Santos: {%x+}(%d+)")
        if buy_ls then info.buy_ls = tonumber(buy_ls) end
  
        local buy_lv = string.match(line, "Продажа продуктов в Las Venturas: {%x+}(%d+)")
        if buy_lv then info.buy_lv = tonumber(buy_lv) end
      end
  
      table.sort(info.fractions, function(a, b) 
        return a[2] > b[2] 
      end)
  
      local result = "{AAAAAA}"
      result = result .. "Каждой организации необходимо иметь деньги на счету банка чтобы выплачивать\n"
      result = result .. "премии своим работникам, а также закупать патроны и продукты у других предприятий и фракций.\n"
  
      result = result .. "\n"
      result = result .. "{FFFFFF}Балансы всех гос-организаций по убыванию:\n\n"
  
      for _, org in ipairs(info.fractions) do
        result = result .. string.format("{FFFFFF} - %s: {73B461}$%s\n", org[1], sumFormat(org[2]))
      end
  
      result = result .. "\n"
      result = result .. "{FFFFFF}Получатель налогов: {73B461}Центральный Банк\n"
  
      result = result .. "\n"
      result = result .. ("{FFFFFF}Цена выкупа: {73B461}%s\n"):format(sumFormat(info.price))
  
      result = result .. "\n"
      result = result .. ("{FFFFFF}Закупка продуктов на ферме: {73B461}%s\n"):format(sumFormat(info.farm))
      result = result .. ("{FFFFFF}Продажа продуктов в Los Santos: {73B461}%s\n"):format(sumFormat(info.buy_ls))
      result = result .. ("{FFFFFF}Продажа продуктов в Las Venturas: {73B461}%s"):format(sumFormat(info.buy_lv))
  
      return { dialogId, style, title, button1, button2, result }
    end
    if dialogId == 91 and isFastNakActive and ini.main.fastnakban then
      sampCloseCurrentDialogWithButton(1)
      return false
    end
    if text:find("Организация.*Состав") and (ini.main.checkerlead or os.time() - statuswaitleader < 2) then
      for k in text:gmatch("[^\n\r]+") do
        if k:find(".+\t.+%[.+%]\t.+") then
          local frac, fracNick, fracId, fracZams, fracMember, fracMemberAfk = k:match("(.+)\t(.+)%[(.+)%]\t(%d+) чел.\t(%d+) чел. %(из них в афк: (%d+)%)")
          if frac == "Полиция ЛС" then
            fracschecker['lspd']['frac'] = "ЛСПД"
            fracschecker['lspd']['nick'] = fracNick
            fracschecker['lspd']['id'] = fracId
            fracschecker['lspd']['zams'] = fracZams
            fracschecker['lspd']['member'] = fracMember
            fracschecker['lspd']['memberafk'] = fracMemberAfk
          end
          if frac == "Областная полиция" then
            fracschecker['rcsd']['frac'] = "РКШД"
            fracschecker['rcsd']['nick'] = fracNick
            fracschecker['rcsd']['id'] = fracId
            fracschecker['rcsd']['zams'] = fracZams
            fracschecker['rcsd']['member'] = fracMember
            fracschecker['rcsd']['memberafk'] = fracMemberAfk
          end
          if frac == "FBI" then
            fracschecker['fbi']['frac'] = "ФБР"
            fracschecker['fbi']['nick'] = fracNick
            fracschecker['fbi']['id'] = fracId
            fracschecker['fbi']['zams'] = fracZams
            fracschecker['fbi']['member'] = fracMember
            fracschecker['fbi']['memberafk'] = fracMemberAfk
          end
          if frac == "Полиция СФ" then
            fracschecker['sfpd']['frac'] = "СФПД"
            fracschecker['sfpd']['nick'] = fracNick
            fracschecker['sfpd']['id'] = fracId
            fracschecker['sfpd']['zams'] = fracZams
            fracschecker['sfpd']['member'] = fracMember
            fracschecker['sfpd']['memberafk'] = fracMemberAfk
          end
          if frac == "Больница LS" then
            fracschecker['bls']['frac'] = "БЛС"
            fracschecker['bls']['nick'] = fracNick
            fracschecker['bls']['id'] = fracId
            fracschecker['bls']['zams'] = fracZams
            fracschecker['bls']['member'] = fracMember
            fracschecker['bls']['memberafk'] = fracMemberAfk
          end
          if frac == "Правительство LS" then
            fracschecker['pravo']['frac'] = "Пра-во"
            fracschecker['pravo']['nick'] = fracNick
            fracschecker['pravo']['id'] = fracId
            fracschecker['pravo']['zams'] = fracZams
            fracschecker['pravo']['member'] = fracMember
            fracschecker['pravo']['memberafk'] = fracMemberAfk
          end
          if frac == "Тюрьма строгого режима LV" then
            fracschecker['tsr']['frac'] = "ТСР"
            fracschecker['tsr']['nick'] = fracNick
            fracschecker['tsr']['id'] = fracId
            fracschecker['tsr']['zams'] = fracZams
            fracschecker['tsr']['member'] = fracMember
            fracschecker['tsr']['memberafk'] = fracMemberAfk
          end
          if frac == "Больница СФ" then
            fracschecker['bsf']['frac'] = "БСФ"
            fracschecker['bsf']['nick'] = fracNick
            fracschecker['bsf']['id'] = fracId
            fracschecker['bsf']['zams'] = fracZams
            fracschecker['bsf']['member'] = fracMember
            fracschecker['bsf']['memberafk'] = fracMemberAfk
          end
          if frac == "Инструкторы" then
            fracschecker['ash']['frac'] = "АШ"
            fracschecker['ash']['nick'] = fracNick
            fracschecker['ash']['id'] = fracId
            fracschecker['ash']['zams'] = fracZams
            fracschecker['ash']['member'] = fracMember
            fracschecker['ash']['memberafk'] = fracMemberAfk
          end
          if frac == "TV студия" then
            fracschecker['tvls']['frac'] = "СМИ ЛС"
            fracschecker['tvls']['nick'] = fracNick
            fracschecker['tvls']['id'] = fracId
            fracschecker['tvls']['zams'] = fracZams
            fracschecker['tvls']['member'] = fracMember
            fracschecker['tvls']['memberafk'] = fracMemberAfk
          end
          if frac == "Grove Street" then
            fracschecker['grove']['frac'] = "Грув"
            fracschecker['grove']['nick'] = fracNick
            fracschecker['grove']['id'] = fracId
            fracschecker['grove']['zams'] = fracZams
            fracschecker['grove']['member'] = fracMember
            fracschecker['grove']['memberafk'] = fracMemberAfk
          end
          if frac == "Los Santos Vagos" then
            fracschecker['vagos']['frac'] = "Вагос"
            fracschecker['vagos']['nick'] = fracNick
            fracschecker['vagos']['id'] = fracId
            fracschecker['vagos']['zams'] = fracZams
            fracschecker['vagos']['member'] = fracMember
            fracschecker['vagos']['memberafk'] = fracMemberAfk
          end
          if frac == "East Side Ballas" then
            fracschecker['ballas']['frac'] = "Баллас"
            fracschecker['ballas']['nick'] = fracNick
            fracschecker['ballas']['id'] = fracId
            fracschecker['ballas']['zams'] = fracZams
            fracschecker['ballas']['member'] = fracMember
            fracschecker['ballas']['memberafk'] = fracMemberAfk
          end
          if frac == "Varrios Los Aztecas" then
            fracschecker['aztec']['frac'] = "Ацтек"
            fracschecker['aztec']['nick'] = fracNick
            fracschecker['aztec']['id'] = fracId
            fracschecker['aztec']['zams'] = fracZams
            fracschecker['aztec']['member'] = fracMember
            fracschecker['aztec']['memberafk'] = fracMemberAfk
          end
          if frac == "The Rifa" then
            fracschecker['rifa']['frac'] = "Рифа"
            fracschecker['rifa']['nick'] = fracNick
            fracschecker['rifa']['id'] = fracId
            fracschecker['rifa']['zams'] = fracZams
            fracschecker['rifa']['member'] = fracMember
            fracschecker['rifa']['memberafk'] = fracMemberAfk
          end
          if frac == "Russian Mafia" then
            fracschecker['rm']['frac'] = "РМ"
            fracschecker['rm']['nick'] = fracNick
            fracschecker['rm']['id'] = fracId
            fracschecker['rm']['zams'] = fracZams
            fracschecker['rm']['member'] = fracMember
            fracschecker['rm']['memberafk'] = fracMemberAfk
          end
          if frac == "Yakuza" then
            fracschecker['yakuza']['frac'] = "Якудза"
            fracschecker['yakuza']['nick'] = fracNick
            fracschecker['yakuza']['id'] = fracId
            fracschecker['yakuza']['zams'] = fracZams
            fracschecker['yakuza']['member'] = fracMember
            fracschecker['yakuza']['memberafk'] = fracMemberAfk
          end
          if frac == "La Cosa Nostra" then
            fracschecker['lcn']['frac'] = "ЛКН"
            fracschecker['lcn']['nick'] = fracNick
            fracschecker['lcn']['id'] = fracId
            fracschecker['lcn']['zams'] = fracZams
            fracschecker['lcn']['member'] = fracMember
            fracschecker['lcn']['memberafk'] = fracMemberAfk
          end
          if frac == "Warlock MC" then
            fracschecker['warlock']['frac'] = "Варлок"
            fracschecker['warlock']['nick'] = fracNick
            fracschecker['warlock']['id'] = fracId
            fracschecker['warlock']['zams'] = fracZams
            fracschecker['warlock']['member'] = fracMember
            fracschecker['warlock']['memberafk'] = fracMemberAfk
          end
          if frac == "Армия ЛС" then
            fracschecker['armyls']['frac'] = "Армия ЛС"
            fracschecker['armyls']['nick'] = fracNick
            fracschecker['armyls']['id'] = fracId
            fracschecker['armyls']['zams'] = fracZams
            fracschecker['armyls']['member'] = fracMember
            fracschecker['armyls']['memberafk'] = fracMemberAfk
          end
          if frac == "Центральный Банк" then
            fracschecker['cb']['frac'] = "ЦБ"
            fracschecker['cb']['nick'] = fracNick
            fracschecker['cb']['id'] = fracId
            fracschecker['cb']['zams'] = fracZams
            fracschecker['cb']['member'] = fracMember
            fracschecker['cb']['memberafk'] = fracMemberAfk
          end
          if frac == "Больница LV" then
            fracschecker['blv']['frac'] = "БЛВ"
            fracschecker['blv']['nick'] = fracNick
            fracschecker['blv']['id'] = fracId
            fracschecker['blv']['zams'] = fracZams
            fracschecker['blv']['member'] = fracMember
            fracschecker['blv']['memberafk'] = fracMemberAfk
          end
          if frac == "Полиция ЛВ" then
            fracschecker['lvpd']['frac'] = "ЛВПД"
            fracschecker['lvpd']['nick'] = fracNick
            fracschecker['lvpd']['id'] = fracId
            fracschecker['lvpd']['zams'] = fracZams
            fracschecker['lvpd']['member'] = fracMember
            fracschecker['lvpd']['memberafk'] = fracMemberAfk
          end
          if frac == "TV студия LV" then
            fracschecker['tvlv']['frac'] = "СМИ ЛВ"
            fracschecker['tvlv']['nick'] = fracNick
            fracschecker['tvlv']['id'] = fracId
            fracschecker['tvlv']['zams'] = fracZams
            fracschecker['tvlv']['member'] = fracMember
            fracschecker['tvlv']['memberafk'] = fracMemberAfk
          end
          if frac == "Night Wolves" then
            fracschecker['nv']['frac'] = "НВ"
            fracschecker['nv']['nick'] = fracNick
            fracschecker['nv']['id'] = fracId
            fracschecker['nv']['zams'] = fracZams
            fracschecker['nv']['member'] = fracMember
            fracschecker['nv']['memberafk'] = fracMemberAfk
          end
          if frac == "TV студия SF" then
            fracschecker['tvsf']['frac'] = "СМИ СФ"
            fracschecker['tvsf']['nick'] = fracNick
            fracschecker['tvsf']['id'] = fracId
            fracschecker['tvsf']['zams'] = fracZams
            fracschecker['tvsf']['member'] = fracMember
            fracschecker['tvsf']['memberafk'] = fracMemberAfk
          end
          if frac == "Армия SF" then
            fracschecker['armysf']['frac'] = "Армия СФ"
            fracschecker['armysf']['nick'] = fracNick
            fracschecker['armysf']['id'] = fracId
            fracschecker['armysf']['zams'] = fracZams
            fracschecker['armysf']['member'] = fracMember
            fracschecker['armysf']['memberafk'] = fracMemberAfk
          end
          if frac == "Страховая компания" then
            fracschecker['insur']['frac'] = "СтК"
            fracschecker['insur']['nick'] = fracNick
            fracschecker['insur']['id'] = fracId
            fracschecker['insur']['zams'] = fracZams
            fracschecker['insur']['member'] = fracMember
            fracschecker['insur']['memberafk'] = fracMemberAfk
          end
        end
      end
      if not statusorgmembers then
        sampSendDialogResponse(dialogId, 1, _, _)
        sampSendDialogResponse(dialogId, 0, _, _)
        return false
      else
        statusorgmembers = false
      end
    end
    if dialogId == 15330 then
      sampCloseCurrentDialogWithButton(1)
      return false
    end
    if ini.main.checkerlead then
      lua_thread.create(function ()
        statusstopdialog = true
  
        wait(4500)
  
        statusstopdialog = false
      end)
    end
    if text:find("%[%d+%] Admins") then
      if status_spcarall and not status_spcaralldon then
        status_spcaralldon = true
  
        sampSendDialogResponse(dialogId, 1, 5, _)
  
        return false
      end
    end
    if text:find("Весь транспорт") and status_spcaralldon then
      sampSendDialogResponse(dialogId, 1, 0, _)
  
      status_spcaralldon = false
      status_spcarall = false
  
      sampSendChat("/ao [Спавн Транспорта] Весь транспорт успешно был заспавнен!")
  
      return false
    end
    if fix and text:find("Курс пополнения счета") then
      sampSendDialogResponse(dialogId, 0, 0, "")
      return false
    end
    if dialogId == 0 and statusquitdialog and ini.main.autoquest then
      statusquitdialog = false
      statusadminquest = true
      sampSendChat("/apanel")
  
      return false
    end
    if dialogId == 7972 and statusacceptquest and ini.main.autoquest then
        sampSendDialogResponse(dialogId, 1, _, _)
        statusadminquest = true
        sampSendChat("/apanel")
        statusacceptquest = false
        return false
    end
    if dialogId == 7971 and statusquest and ini.main.autoquest then
      if not statusquesterr then
        lua_thread.create(function ()
          i = 0
          i2 = 0
  
          for k in text:gmatch("[^\n\r]+") do
            if k:find("%[Можно завершить%]") then
              sampSendDialogResponse(dialogId, 1, i, _)
  
              statusquitdialog = true
  
              break
            end
  
            if k:find("%[Доступен%]") then
              i2 = i2 + 1
  
              sampSendDialogResponse(dialogId, 1, i, _)
  
              statusacceptquest = true
  
              if i > 10 then
                sampAddChatMessage("Ошибка!", -1)
              end
  
              break
            end
  
            i = i + 1
          end
  
          statusquest = false
        end)
        return false
      else
        sampAddChatMessage("Ошибка!", -1)
  
        statusquest = false
        statusquesterr = false
      end
  
      return false
    end
  
    if dialogId == 265 and statusadminquest and ini.main.autoquest then
      statusadminquest = false
      if not statusquesterr then
        statusadminquest = false
        statusquest = true
  
        sampSendDialogResponse(dialogId, 1, 26, _)
      else
        statusquesterr = false
  
        sampAddChatMessage("Ошибка!", -1)
      end
  
      return false
    end
    if report_window[0] then
      sampAddChatMessage(tag.."Сбито окно репорта. ID Диалога - "..dialogId, -1)
      return false
    end
    if title:find("Основная статистика") and rInfo['id'] ~= "-1" then
      if not rInfo['statusinfocheck2'] then
        if not sampGetDialogCaption():find("Выберите действие") and rInfo['id'] ~= "-1" then
          local frac, rank = text:match("Организация:.*}%[(.*)%].*Должность:.*(%d+)%).*Уро")
          local protect = text:match("Защита: %{......%}%[%-(%d+)%% урона%]")
          local regen = text:match("Регенерация: %{......%}%[(%d+) HP в мин")
          local force = text:match("Урон: %{......%}%[%+(%d+) урона")
          if frac and rank then
            rInfo['rank'] = rank
            rInfo['org'] = frac
          else
            rInfo['org'] = "Без фракции"
            rInfo['rank'] = "Без Фракции"
          end
          rInfo['protect'] = protect
          rInfo['force'] = force
          rInfo['regen'] = regen
        end
        return false
      else
        rInfo['statusinfocheck2'] = false
      end
    end
    if dialogId == 2 and title:match('Авторизация') and #tostring(ini.main.pass_acc) > 4 then
      local try = text:match('Попыток для ввода пароля: {%x+}(%d)')
      if try then
        if tonumber(try) >= 3 then
          if #ini.main.pass_acc > 4 then
            sampSendDialogResponse(dialogId, 1, _, base64.decode(ini.main.pass_acc))
            return false
          else
            text = text:gsub('Введите свой пароль', '{33AA33}Пароль введён автоматически')
            lua_thread.create(function()
              wait(0)
              sampSetCurrentDialogEditboxText(base64.decode(ini.main.pass_acc))
            end)
          end
        elseif tonumber(try) == 2 and #ini.main.pass_acc > 4 then
          text = text:gsub('Неверный пароль!', 'Авто-ввод пароля не удался!\n%1')
        end
        return {dialogId, style, title, but_1, but_2, text}
      end
    end
    if dialogId == 211 and title:match('Админ%-панель') and #tostring(ini.main.pass_adm) > 4 then
      sampSendDialogResponse(dialogId, 1, _, ini.main.pass_adm)
      return false
    end
    if text:find("Жалоба/Вопрос от:") then
      floodot = false
      floodot_window[0] = false
      skipped = 0
      repNick, repId, repText = string.match(text, "Жалоба/Вопрос от: (.+)%[(%d+)%]\n\n{BFE54C}(.+)\n")
      report_window[0] = true
      return false
    end
    text = separator(text)
    title = separator(title)
    return {dialogId, style, title, button1, button2, text}
  end

  function sampev.onSpectatePlayer(playerid, camtype)
    local main_adm = false
    rInfo['cars'] = false
    rInfo['id'] = playerid
    rInfo['iscar'] = false
    rInfo['status'] = true
    rInfo['name'] = sampGetPlayerNickname(rInfo['id'])
    for l=1, 8 do
      for i, v in ipairs(admins['list'][l]) do
        if v[2] == tonumber(rInfo['id']) then

          for key,value in pairs(ini.kurators) do
            if v[1] == value then
              main_adm = true
            end
          end
          for key, value in pairs(ini.zga) do
            if v[1] == value then
              main_adm = true
            end
          end
          for key, value in pairs(ini.ga) do
            if v[1] == value then
              main_adm = true
            end
          end
          if v[4] ~= -1 and not main_adm then
            lua_thread.create(function ()
              wait(0)
              sampSendChat("/re "..v[4])
              rInfo['id'] = v[4]
              sampAddChatMessage(tag.."Автоматическая слежка за игроком из рекона администратора.", -1)
            end)
          end
        end
      end
    end
    if rInfo['id'] ~= "-1" then
      recon_window[0] = true
      reconinfo_window[0] = true
    end
    if rInfo['id'] ~= "-1" then
      lua_thread.create(function ()
        wait(2000)
  
        if not sampIsDialogActive() and not report_window[0] and rInfo['id'] ~= "-1" then
          rInfo['statusinfocheck'] = true
          rInfo['statusclcheck'] = true
          rInfo['statusiskamen'] = true
          rInfo['statusistp'] = true
          if not main_adm then
            sampSendChat("/cl "..rInfo['id'])
            sampSendChat("/check " .. rInfo['id'])
          end
        end
      end)
    end
  end

  function sampev.onTogglePlayerSpectating(state)
    if state then
      if rInfo['id'] ~= "-1" then
        recon_window[0] = true
        reconinfo_window[0] = true
      end
      main_adm = false
    elseif not state then -- вышел из рекона
      rInfo['id'] = "-1"
      rInfo['carid'] = "-1"
      rInfo['iscar'] = false
      rInfo['status'] = false
      recon_window[0] = false
      reconinfo_window[0] = false
      isfrac = false
      main_adm = false
      if not report_window[0] then
        lua_thread.create(function() wait(0)
          fix = true
          sampSendChat("/donate")
          wait(3000)
          fix = false
        end)
      end
    end
  end

  function sampev.onSpectateVehicle(vehicleId, camType)
    recon_window[0] = true
    rInfo['cars'] = vehicleId
    rInfo['carid'] = vehicleId
    rInfo['iscar'] = true
    rInfo['status'] = true
    if rInfo['-1'] ~= "-1" then
      lua_thread.create(function ()
        wait(2000)
  
        if not sampIsDialogActive() and not report_window[0] and rInfo['id'] ~= "-1" then
          rInfo['statusinfocheck'] = true
          rInfo['statusclcheck'] = true
          rInfo['statusiskamen'] = true
          rInfo['statusistp'] = true
          sampSendChat("/cl "..rInfo['id'])
          if not report_window[0] then
            sampSendChat("/check " .. rInfo['id'])
          end
        end
      end)
    end
  end

  function sampev.onSendSpectatorSync(syncdata)
    if rInfo['id'] ~= -1 and (syncdata.upDownKeys ~= 0 or syncdata.leftRightKeys ~= 0 or syncdata.keysData == 8) then
      return false
    end
  end

  function sampev.onShowTextDraw(id, data)
    if data.text:find("LD_BEAT:chit") and not statusinvent then
      lua_thread.create(function ()
      statusinvent = true
      if not report_window[0] then
        fix = true
        sampSendChat("/donate")
        wait(3000)
        fix = false
      end
        while statusinvent do
          wait(0)
  
          if not sampTextdrawIsExists(2105) then
            break
          end
        end
  
        statusinvent = false
      end)
    end--
    if data.text:find("LD_SPAC:white") and not statusinvent then
      lua_thread.create(function ()
      statusinvent = true
        while statusinvent do
          wait(0)
  
          if not sampTextdrawIsExists(2105) then
            break
          end
        end
  
        statusinvent = false
      end)
    end
    if data.text == "…H‹EHЏAP’" then
      idt = id
    end
    if data.text:find("Box") and tostring(data.position.x) == tostring(6.1998000144958) and tostring(data.position.y) == tostring(179.52949523926) and rInfo['id'] ~= "-1" then
      rInfo['lastid'] = id + 55
		  rInfo['oneid']= id
      sampAddChatMessage(tag.."Для вызова курсора/обновления информации рекона используйте клавишу SPACE/ПКМ/ESC", -1)
      
      return false
    end

    if rInfo['oneid'] and rInfo['lastid'] and rInfo['oneid'] <= id and id <= rInfo['lastid'] and rInfo['id'] ~= "-1" then
      if rInfo['oneid'] + 33 == id then
        rInfo['name'] = data.text
  
        if rInfo['status'] then
          rInfo['name'] = data.text
        end
      end
  
      if rInfo['oneid'] + 47 == id then
        rInfo['id'] = data.text
  
        if rInfo['status'] then
          rInfo['id'] = data.text
        end
      end
    end
    if rInfo['id'] ~= "-1" and rInfo['oneid'] and rInfo['lastid'] and rInfo['oneid'] <= id and id <= rInfo['lastid'] then
      return false
    end
  end

  function sampev.onSendCommand(cmd)
    if string.match(cmd, "/ot") and report_window[0] then
      return false
    end
    if (cmd:find("^/check%s+") or cmd:find("^/stats")) and not rInfo['statusinfocheck'] then
      rInfo['statusinfocheck2'] = true
    elseif cmd:find("^/check%s+") and rInfo['statusinfocheck'] then
      rInfo['statusinfocheck'] = false
    end
    if (cmd:find("^/cl%s+") and not rInfo['statusclcheck']) then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusclcheck2'] = true
      end)
    elseif cmd:find("^/cl%s+") and rInfo['statusclcheck'] then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusclcheck'] = false
      end)
    end
    if (cmd:find("^/iskamen%s+") and not rInfo['statusiskamen']) then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusiskamen2'] = true
      end)
    elseif cmd:find("^/iskamen%s+") and rInfo['statusiskamen'] then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusiskamen'] = false
      end)
    end
    if (cmd:find("^/lasttp%s+") and not rInfo['statusistp']) then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusistp2'] = true
      end)
    elseif cmd:find("^/lasttp%s+") and rInfo['statusistp'] then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusistp'] = false
      end)
    end
    if ini.main.autoprefix then
      if cmd:find("^/ban%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/banoff%s+") and (tonumber(ini.main.lvl_adm) < 5) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/banipoff%s+") and (tonumber(ini.main.lvl_adm) < 5) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end

      if cmd:find("^/uval%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a "..cmd.." "..ini.forms.tag
        }
        return cmd
      end
  
      if cmd:find("^/warnoff%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unjailoff%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unmuteoff%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/banip%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/sban%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
      if cmd:find("^/unban%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/jailoff%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/warn%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/kick%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/jail%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/mute%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/skick%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/plveh%s+") and tonumber(ini.main.lvl_adm) < 3 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
      if cmd:find("^/rmute%s+") and tonumber(ini.main.lvl_adm) < 2 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/weap%s+") and tonumber(ini.main.lvl_adm) < 2 then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unmute%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unjail%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unwarn%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/apunish%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unban%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/bail%s+") and tonumber(ini.main.lvl_adm) < 3 then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/givegun%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/trspawn%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/aparkcar%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/cleardemorgane%s+") and tonumber(ini.main.lvl_adm) < 4 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/unbanip%s+") and tonumber(ini.main.lvl_adm) < 4 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/ao%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/setskin%s+") and tonumber(ini.main.lvl_adm) < 4 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/trremove%s+") and (tonumber(ini.main.lvl_adm) < 5) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/setgangzone%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
      if cmd:find("^/afkkick") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
    end
  end

  function sampev.onSendClientJoin(version,mod,nick)
    if isGamePaused() or isPauseMenuActive() then
      ShowMessage('Вы подключились к серверу!', '', 0x30)
      writeMemory(7634870, 1, 0, 0)
      writeMemory(7635034, 1, 0, 0)
      memory.hex2bin('5051FF1500838500', 7623723, 8)
      memory.hex2bin('0F847B010000', 5499528, 6)
      addOneOffSound(0.0, 0.0, 0.0, 1188)
    end
  end

  function sampev.onBulletSync(playerid, data)
    if ini.main.traicers then
      if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
        return true
      end
      BulletSync.lastId = BulletSync.lastId + 1
      if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
        BulletSync.lastId = 1
      end
      local id = BulletSync.lastId
      BulletSync[id].enable = true
      BulletSync[id].tType = data.targetType
      BulletSync[id].time = os.time() + 15
      BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
      BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
    end
  end

  function sampev.onTextDrawSetString(id, text)
    if rInfo['oneid'] then
      if rInfo['oneid'] + 33 == id then
        rInfo['name'] = text
  
        if rInfo['status'] then
          rInfo['name'] = text
        end
      end
  
      if rInfo['oneid'] + 47 == id then
        rInfo['id'] = text
  
        if rInfo['status'] then
          rInfo['id'] = text
        end
      end
    end


    if rInfo['oneid'] then
      if rInfo['oneid'] + 33 == id then
        rInfo['name'] = text
      end
  
      if rInfo['oneid'] + 47 == id then
        rInfo['id'] = text
      end
  
      if rInfo['oneid'] + 35 == id then
        rInfo['lvl'], rInfo['exp'] = text:match("(%d+):(.*)")
      end
  
      if rInfo['oneid'] + 36 == id then
        rInfo['warn'] = text
      end
  
      if rInfo['oneid'] + 37 == id then
        rInfo['arm'] = text
      end
  
      if rInfo['oneid'] + 38 == id then
        rInfo['hp'] = text
      end
  
      if rInfo['oneid'] + 39 == id then
        rInfo['carhp'] = text
      end
  
      if rInfo['oneid'] + 40 == id then
        rInfo['speed'] = text
      end
  
      if rInfo['oneid'] + 41 == id then
        rInfo['ping'] = text
      end
  
      if rInfo['oneid'] + 42 == id then
        rInfo['ammo']= text
      end
  
      if rInfo['oneid'] + 43 == id then
        rInfo['shot'] = text
      end
  
      if rInfo['oneid'] + 44 == id then
        rInfo['tshot'] = text
      end
  
      if rInfo['oneid'] + 45 == id then
        rInfo['afk'] = text
  
        if rInfo['status'] then
          rInfo['afk'] = text
        end
      end
  
      if rInfo['oneid'] + 46 == id then
        if text:find("%-") then
          rInfo['engine'] = "-"
          rInfo['twint'] = "-"
        end
  
        if text:find("%w+%((.*)%)") then
          rec1, rec2 = text:match("(%w+)%((.*)%)")
        end
  
        if tostring(rec1) == tostring("On") then
          rInfo['engine'] = "Заведен"
        elseif tostring(rec1) == tostring("Off") then
          rInfo['engine'] = "Заглушен"
        end
  
        if tostring(rec2) == tostring("TT") then
          rInfo['twint'] = "Есть"
        elseif tostring(rec2) == tostring("NO TT") then
          rInfo['twint'] = "Нету"
        end
      end
    end
  end

  function sampev.onPlayerQuit(playerId, reason)
    while #logcon == ini.main.logconlimit do table.remove(logcon, 1) end
    logcon[#logcon+1] = ABGRtoStringRGB(ini.style.logcon_d).."[Q] "..ABGRtoStringRGB(ini.style.logcon_def)..sampGetPlayerNickname(playerId).."["..playerId.."] - "..quitReason[reason+1]
  end

  function sampev.onSendChat(msg)
    if ini.main.autob then
      sampSendChat("/b "..msg)
      return false
    end
    if ini.main.autobrec then
      if rInfo['id'] ~= "-1" then
        sampSendChat("/b "..msg)
        return false
      end
    end
  end

  function sampev.onPlayerDeathNotification(killerId, killedId, reason)
    local kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
  
    local n_killer = ( sampIsPlayerConnected(killerId) or killerId == myid ) and sampGetPlayerNickname(killerId) or nil
    local n_killed = ( sampIsPlayerConnected(killedId) or killedId == myid ) and sampGetPlayerNickname(killedId) or nil
    lua_thread.create(function()
      wait(0)
      if n_killer then kill.killEntry[4].szKiller = ffi.new('char[25]', ( n_killer .. '[' .. killerId .. ']' ):sub(1, 24) ) end
      if n_killed then kill.killEntry[4].szVictim = ffi.new('char[25]', ( n_killed .. '[' .. killedId .. ']' ):sub(1, 24) ) end
    end)
  end

  function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
    text = separator(text)
    return {id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text}
  end

  function sampev.onPlayerChatBubble(playerId, color, distance, duration, message)
    if message:find("AFK") then
      return false
    end
    while #farchat == ini.main.farchatlimit do table.remove(farchat, 1) end
    farchat[#farchat+1] = string.format("[D:%s]"..'{'..string.sub(bit.tohex(sampGetPlayerColor(playerId)), 3, 8)..'}'.." %s[%s]: "..'{'..string.sub(bit.tohex(color), 1, 6)..'}'.."%s", distance, sampGetPlayerNickname(playerId), playerId, message)
  end
----------------------------------------------------------------------

--                 Мелкие функции

  function save()
      inicfg.save(ini, dirIni)
      countsettings = 0
      for k, v in pairs(ini.setcheckerfrac) do
        if v then
          countsettings = countsettings + 1
        end
      end
  end

  function initializeRender()
      font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
      font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
  end

  --[[function mySort(a,b)
      if  a[2] < b [2] then
          return true
      end
      return false
  end ]]

----------------------------------------------------------------------

--                 Команды 

  function cmd_re(arg)
    if string.match(arg, "%d+") then
      local reId = string.match(arg, "%d+")
      if tonumber(reId) < 0 or tonumber(reId) > 999 then
        sampAddChatMessage(tag_err..'ID игрока не может быть больше 999 или меньше 0', -1)
        return false
      end
      sampSendChat("/re "..arg)
      rInfo['id'] = tonumber(reId)
      rInfo['name'] = sampGetPlayerNickname(tonumber(reId))
    else
      sampAddChatMessage(tag_err..'Используйте: /re (ид)', -1)
      return false
    end
  end
  function cmd_addrep(arg)
    if ini.main.lvl_adm < 6 then
      sampAddChatMessage(tag_err..'Вам не доступна данная команда!', -1)
      return false
    end
    if not arg:match("%d+ %d+") then
      sampAddChatMessage(tag_err.."Используйте: /addrep (id) (кол-во)", -1)
      return false
    end
    local idAdm, repAdm = arg:match("(%d+) (%d+)")
    for l=1, 8 do
      for i, v in ipairs(admins['list'][l]) do
        if tonumber(v[2]) == tonumber(idAdm) then
          foundadmrep = true
          admrep = v[5]
        end
      end
    end
    if foundadmrep then
      sampSendChat("/setrep "..idAdm.." "..admrep+repAdm)
      sampAddChatMessage('{00FF00}[Успешно] {FFFFFF}Вы успешно выдали {00FF00}'..repAdm.."{FFFFFF} репутации администратору {00FF00}"..sampGetPlayerNickname(idAdm).."{FFFFFF}.", -1)
      foundadmrep = false
    else
      sampAddChatMessage('{FF0000}[Ошибка] {FFFFFF}Игрок не является администратором!', -1)
      foundadmrep = false
      return false
    end
  end
  function cmd_spcarall(arg)
    lua_thread.create(function ()
      if arg:find("%d+") then
        if tonumber(arg) >= 10 and tonumber(arg) <= 60 then
          sampSendChat("/ao [Спавн Транспорта] Ув.Игроки через " .. arg .. " секунд будет спавн всего транспорта!")
          sampSendChat("/ao [Спавн Транспорта] Займите свой транспорт,в противном случае он пропадет!")

          spcartime = os.time()

          while os.time() - spcartime < tonumber(arg) do
            printStyledString("Spawn cars through: " .. arg - (os.time() - spcartime), 1, 6)
            wait(0)
          end

          sampAddChatMessage(tag.."Начинается спавн транспорта", -1)

          status_spcarall = true

          sampSendChat("/apanel")

          dfssdsd = os.time()

          if os.time() - dfssdsd < 3 then
            while os.time() - dfssdsd < 3 and status_spcarall do
              wait(0)
            end
          end

          status_spcarall = false
          status_spcaralldon = false
        else
          sampAddChatMessage(tag_err.."Укажите время в секундах (10-60 сек.)", -1)
        end
      else
        sampAddChatMessage(tag_err.."Используйте: /spcarall (время в секундах)", -1)
      end
    end)
  end
  function flood_report()
    while true do
      wait(ini.main.delayot)
      if floodot then
        sampSendChat("/ot")
      end
    end
  end
  function cmd_tpr(arg)
    local result, x, y, z = getNearestRoadCoordinates()
    if arg == "" then
      if result then 
        if rInfo['id'] ~= "-1" then
          lua_thread.create(function()
            sampSendChat("/plpos "..rInfo['id'].." "..x.." "..y.." "..math.ceil(z))
            local _, handle = sampGetCharHandleBySampPlayerId(rInfo['id'])
            if isCharInAnyCar(handle) then
              wait(500)
              sampSendChat("/flip "..rInfo['id'])
            end
          end)
        elseif rInfo['id'] == "-1" then
          sampSendChat("/plpos "..id.." "..x.." "..y.." "..math.ceil(z))
        end
      else
        sampAddChatMessage(tag_err..'Не найдено дороги поблизости.', -1)
      end
    elseif string.match(arg, "%a+") then
      sampAddChatMessage(tag_err..'Используйте: /tpr (ID)', -1)
    elseif string.match(arg, "%d+") then
      if sampIsPlayerConnected(arg) then
        lua_thread.create(function()
          sampSendChat("/plpos "..arg.." "..x.." "..y.." "..math.ceil(z))
          local _, handle = sampGetCharHandleBySampPlayerId(arg)
          if isCharInAnyCar(handle) then
            wait(500)
            sampSendChat("/flip "..arg)
          end
        end)
      else
        sampAddChatMessage(tag_err..'Не найден игрок с данным ID.', -1)
      end
    else
      sampAddChatMessage(tag_err..'Используйте: /tpr (ID)', -1)
    end
  end
  function CMD_admins(argument)
    sampSendChat('/admins')
    requestAdmins = true
    lua_thread.create(function()
      while requestAdmins do wait(0) end
      if tonumber(argument) then
        local lvl = tonumber(argument)
        if lvl >= 1 and lvl <= 6 then
          local block = admins['list'][lvl]
          local countAfk = function(t)
            local i = 0
            for _, v in ipairs(t) do 
              if v[3] and v[3] > 0 then
                i = i + 1
              end
            end
            return i
          end
          sampAddChatMessage(('Администрация %s уровня онлайн [Всего: %s | В АФК: %s]:'):format(lvl >= 6 and '6+' or  lvl..'-го', #block, countAfk(block)), 0x1ECC00)
            for i, admin in ipairs(block) do
              local recon = admin[4] and (admin[4] >= 0 and ': /re ' ..admin[4] .. ',' or ':') or ':'
              sampAddChatMessage(('%s) %s(%s){FFFFFF}%s AFK: %s, Репутация: %s'):format(i, admin[1], admin[2], recon, admin[3] or 'N', admin[5] or 'N'), 0xFEFE22)
            end
            if #block == 0 then
            sampAddChatMessage('Отсутсвует', 0xFEFE22)
          end
          return
        end
        sampAddChatMessage(tag..'Используйте: /admins [ 1 - 6 ]', imgui.ColorConvertFloat4ToARGB(mc))
      else
        if argument:lower() == 'afk' then
          local count, arr = 0, {}
          for lvl = 1, 6 do
            local block = admins['list'][lvl]
            for _, v in ipairs(block) do 
              if v[3] and v[3] > 0 then
                count = count + 1
                local recon = v[4] and (v[4] >= 0 and ': /re ' ..v[4] .. ',' or ':') or ':'
                local str = ('%s) %s(%s){FFFFFF}%s AFK: %s, Репутация: %s'):format(count, v[1], v[2], recon, v[3] or 'N', v[5] or 'N')
                table.insert(arr, str)
              end
            end
          end
          sampAddChatMessage(('Администрация в АФК [Всего: %s]:'):format(count), 0x1ECC00)
          for _, str in ipairs(arr) do 
            sampAddChatMessage(str, 0xFEFE22)
          end
          if #arr == 0 then
            sampAddChatMessage('Отсутсвует', 0xFEFE22)
          end
          return
        end
        local count = 0
        sampAddChatMessage('Администрация онлайн:', 0x1ECC00)
        for lvl = 1, 6 do
          local block = admins['list'][lvl]
          for i, v in ipairs(block) do
            count = count + 1
            local recon = v[4] and (v[4] >= 0 and ': /re ' ..v[4] .. ',' or ':') or ':'
            local str = ('%s) %s(%s) [%s LVL]{FFFFFF}%s AFK: %s, Репутация: %s'):format(count, v[1], v[2], (lvl >= 6 and lvl..'+' or lvl), recon, v[3] or 'N', v[5] or 'N')
            sampAddChatMessage(str, 0xFEFE22)
          end
        end
        sampAddChatMessage(('Всего: %s, из них %s в АФК'):format(admins['online'], admins['afk']), 0x1ECC00)
      end
    end)
  end
  function cmd_amember(arg)
    if arg:match("%d+ %d+") then
      sampSendChat("/amember "..arg)
    else
      amember_window[0] = not amember_window[0]
    end
  end
  function cmd_tp(arg)
    if arg:match("%d+") then
      if tonumber(arg) < 1 or tonumber(arg) > 28 then
        sampAddChatMessage(tag_err.."Выберите ID от 1го до 28и", -1)
      else
        sampSendChat("/tp "..arg)
      end
    else
      tp_window[0] = not tp_window[0]
    end
  end
  function cmd_rslap(arg)
    if not arg:match("%d+") then
      sampAddChatMessage(tag_err..'Используйте: /rslap (радиус)', -1)
      return false
    end
    if tonumber(arg:match("%d+")) > 10 or tonumber(arg:match("%d+")) < 1 then
      sampAddChatMessage(tag_err..'Радиус не может быть меньше 1 или больше 10', -1)
    end
    local nearestChars = sampGetCharsInSphere(arg)
    for k, v in pairs(nearestChars) do
      sampSendChat("/slap "..v.." 1")
    end
  end
  function cmd_askin(arg)
    if arg:match("%d+ %d+") then
      idAskin, typeAskin = arg:match("(%d+) (%d+)")
      askin_window[0] = true
    else
      sampAddChatMessage(tag_err.."Используйте: /askin (id) (0 - временный/1 - вечный)", -1)
    end
  end
  function cmd_aveh(arg)
    if arg:match("%d+ %d+") then
      idAveh, typeAveh = arg:match("(%d+) (%d+)")
      aveh_window[0] = true
    else
      idAveh, typeAveh = selfid, 0
      aveh_window[0] = true
    end
  end
  function cmd_agun(arg)
    if arg:match("(%d+) (%d+)") then
      idAgun, ammoAgun = arg:match("(%d+) (%d+)")
      agun_window[0] = true
    else
      sampAddChatMessage(tag_err.."Используйте: /agun (id) (кол-во патронов)", -1)
    end
  end
----------------------------------------------------------------------

--                    Фигня всякая


  function keyname(key)
    if key ~= "" or key ~= nil then
      if #rkeys.getKeysName(key) == 1 then
        return rkeys.getKeysName(key)[1]
      elseif #rkeys.getKeysName(key) > 1 then
        for k, v in pairs(rkeys.getKeysName(key)) do
          cmdkey = k == 1 and v or "" .. "+" .. v
        end

        return cmdkey
      end
    else
      return "Не указана"
    end
  end
  function getMyNick()
    local result, id = sampGetPlayerIdByCharHandle(playerPed)
    if result then
        local nick = sampGetPlayerNickname(id)
        return nick
    end
  end

  function getMyId()
    local result, id = sampGetPlayerIdByCharHandle(playerPed)
    if result then
        return id
    end
  end
  function sampGetPlayerSkin(id)
    result, pedHandle = sampGetCharHandleBySampPlayerId(id)
    if result then
        skinId = getCharModel(pedHandle)
        return skinId
    end
  end
  function drawClickableText(active, font, text, posX, posY, color, colorA, align, b_symbol) --cfg.main.align
    local cursorX, cursorY = getCursorPos()
    local lenght = renderGetFontDrawTextLength(font, text)
    local height = renderGetFontDrawHeight(font)
    local symb_len = renderGetFontDrawTextLength(font, '>')
    local hovered = false
    local result = false
      b_symbol = b_symbol == nil and false or b_symbol
      align = align or 1
  
      if align == 2 then
        posX = posX - (lenght / 2)
      elseif align == 3 then
        posX = posX - lenght
    end
  
      if active and cursorX > posX and cursorY > posY and cursorX < posX + lenght and cursorY < posY + height then
          hovered = true
          if isKeyJustPressed(0x01) then -- LButton
            result = true 
          end
      end
  
      local anim = math.floor(math.sin(os.clock() * 10) * 3 + 5)
  
     if hovered and b_symbol and (align == 2 or align == 1) then
        renderFontDrawText(font, '>', posX - symb_len - anim, posY, 0x90FFFFFF)
      end 
  
      renderFontDrawText(font, text, posX, posY, hovered and color_hovered or color)
  
      if hovered and b_symbol and (align == 2 or align == 3) then
        renderFontDrawText(font, '<', posX + lenght + anim, posY, 0x90FFFFFF)
      end 
  
      return result
  end
  function imgui.ButtonWithSettings(text, settings, size)
    imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, settings.rounding or imgui.GetStyle().FrameRounding)
    imgui.PushStyleColor(imgui.Col.Button, settings.color or imgui.GetStyle().Colors[imgui.Col.Button])
    imgui.PushStyleColor(imgui.Col.ButtonHovered, settings.color_hovered or imgui.GetStyle().Colors[imgui.Col.ButtonHovered])
    imgui.PushStyleColor(imgui.Col.ButtonActive, settings.color_active or imgui.GetStyle().Colors[imgui.Col.ButtonActive])
    imgui.PushStyleColor(imgui.Col.Text, settings.color_text or imgui.GetStyle().Colors[imgui.Col.Text])
    local click = imgui.Button(text, size)
    imgui.PopStyleColor(4)
    imgui.PopStyleVar()
    return click
  end

  function theme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding         = imgui.ImVec2(8, 8)
    style.WindowRounding        = ini.style.rounding
    style.ChildRounding   	  	= ini.style.rounding
    style.FramePadding          = imgui.ImVec2(5, 3)
    style.FrameRounding         = ini.style.framerounding
    style.ItemSpacing           = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing      = imgui.ImVec2(4, 4)
    style.IndentSpacing         = 21
    style.ScrollbarSize         = 10.0
    style.ScrollbarRounding     = 13
    style.GrabMinSize           = 8
    style.GrabRounding          = 1
    style.WindowTitleAlign      = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign       = imgui.ImVec2(0.5, 0.5)

    colors[clr.Text]                                = ImVec4(tc.x, tc.y, tc.z, 1.00)
    colors[clr.TextDisabled]                        = ImVec4(0.40, 0.40, 0.40, 1.00)
    colors[clr.WindowBg]                            = ImVec4(0.09, 0.09, 0.09, 1.00)
    colors[clr.ChildBg]                       		  = ImVec4(0.09, 0.09, 0.09, 1.00)
    colors[clr.PopupBg]                             = ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[clr.Border]                              = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.BorderShadow]                        = ImVec4(0.00, 0.60, 0.00, 0.00)
    colors[clr.FrameBg]                             = ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[clr.FrameBgHovered]                      = ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.FrameBgActive]                       = ImVec4(mc.x, mc.y, mc.z, 0.80)
    colors[clr.TitleBg]                             = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.TitleBgActive]                       = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.TitleBgCollapsed]                    = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.MenuBarBg]                           = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]                         = ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.ScrollbarGrab]                       = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.ScrollbarGrabHovered]                = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.ScrollbarGrabActive]                 = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.CheckMark]                           = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.SliderGrab]                          = ImVec4(mc.x, mc.y, mc.z, 0.70)
    colors[clr.SliderGrabActive]                    = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.Button]                              = ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.ButtonHovered]                       = ImVec4(mc.x, mc.y, mc.z, 0.80)
    colors[clr.ButtonActive]                        = ImVec4(mc.x, mc.y, mc.z, 0.90)
    colors[clr.Header]                              = ImVec4(1.00, 1.00, 1.00, 0.20)
    colors[clr.HeaderHovered]                       = ImVec4(1.00, 1.00, 1.00, 0.20)
    colors[clr.HeaderActive]                        = ImVec4(1.00, 1.00, 1.00, 0.30)
    colors[clr.TextSelectedBg]                      = ImVec4(mc.x, mc.y, mc.z, 0.90)
    colors[clr.Tab]                      			= ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.TabHovered]                      	= ImVec4(mc.x, mc.y, mc.z, 0.70)
    colors[clr.TabActive]                      		= ImVec4(mc.x, mc.y, mc.z, 0.90)
    colors[clr.TabUnfocused]                      	= ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.TabUnfocusedActive]                  = ImVec4(mc.x, mc.y, mc.z, 0.90)
  end

  function mysplit (inputstr, sep)
      if sep == nil then
              sep = "%s"
      end
      local t={}
      for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
              table.insert(t, tonumber(str))
      end
      return t
  end

  function rainbow(speed, alpha)
    local alpha = alpha or 255
      local r = math.floor(math.sin(os.clock() * speed) * 127 + 128)
      local g = math.floor(math.sin(os.clock() * speed + 2) * 127 + 128)
      local b = math.floor(math.sin(os.clock() * speed + 4) * 127 + 128)
      return join_argb(alpha, r, g, b)
  end
----------------------------------------------------------------------

--                       Вырезано

  function getNameVehicleModel(id)
    local name
    if NameCar[id] ~= nil then 
        name = NameCar[id]
    else
        name = 'Неизвестно'
    end
    return name
  end
  function comma_value(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
  end
  
  function separator(text)
    if text:find("$") then
        for S in string.gmatch(text, "%$%d+") do
          local replace = comma_value(S)
          text = string.gsub(text, S, replace)
        end
        for S in string.gmatch(text, "%d+%$") do
          S = string.sub(S, 0, #S-1)
          local replace = comma_value(S)
          text = string.gsub(text, S, replace)
        end
    end
    return text
  end
  function multiStringSendChat(delay, multiStringText,key)
    fastnak_window[0] = false
    for i=1, #outputtext do
      outputtext[i] = nil
    end
    for i=1, #fastnak_errors do
      fastnak_errors[i] = nil
    end
    lua_thread.create(function()
        multiStringText = multiStringText..'\n'
        for s in multiStringText:gmatch('.-\n') do
          outputtext[#outputtext+1] = s
          isFastNakActive = true
          s = s:gsub("\n", "")
          sampSendChat(s)
          wait(delay)
        end
        isFastNakActive = false
        if #fastnak_errors ~= 0 then
          sampAddChatMessage(tag_err.."Найдены ошибки во время выдачи наказаний.", -1)
          resultfastnak_window[0] = true
        else
          sampAddChatMessage(tag..'Выдача наказаний прошла успешно. Выдано '..#outputtext.." формы", -1)
        end
        wait(1000)
    end)
  end

  function saturate(f) 
    return f < 0 and 0 or (f > 255 and 255 or f) 
  end

  function join_argb(a, r, g, b)
      local argb = b
      argb = bit.bor(argb, bit.lshift(g, 8))
      argb = bit.bor(argb, bit.lshift(r, 16))
      argb = bit.bor(argb, bit.lshift(a, 24))
      return argb
  end

  function onSendPacket()
    if pause then
      return false
    end
  end
  function imgui.CenterColumnText(color, text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextColored(color, text)
  end
  function imgui.AnimButton(label, size, duration)
    if not duration then
      duration = 1.0
    end

    local cols = {
      default = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Button]),
      hovered = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]),
      active  = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])
    }

    if UI_ANIMBUT == nil then
      UI_ANIMBUT = {}
    end
    if not UI_ANIMBUT[label] then
      UI_ANIMBUT[label] = {
        color = cols.default,
        hovered = {
          cur = false,
          old = false,
          clock = nil,
        }
      }
    end
    local pool = UI_ANIMBUT[label]

    if pool['hovered']['clock'] ~= nil then
      if clock() - pool['hovered']['clock'] <= duration then
        pool['color'] = bringVec4To( pool['color'], pool['hovered']['cur'] and cols.hovered or cols.default, pool['hovered']['clock'], duration)
      else
        pool['color'] = pool['hovered']['cur'] and cols.hovered or cols.default
      end
    else
      pool['color'] = cols.default
    end

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(pool['color']))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(pool['color']))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(pool['color']))
    local result = imgui.Button(label, size or imgui.ImVec2(0, 0))
    imgui.PopStyleColor(3)

    pool['hovered']['cur'] = imgui.IsItemHovered()
    if pool['hovered']['old'] ~= pool['hovered']['cur'] then
      pool['hovered']['old'] = pool['hovered']['cur']
      pool['hovered']['clock'] = clock()
    end

    return result
  end
  function ImSaturate(f)
    return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
  end
  function sampGetCharsInSphere(radius)
    local inSphere = {}
    if not radius then return {} end
    local Mx, My, Mz = getCharCoordinates(PLAYER_PED)
    for k,v in pairs(getAllChars()) do
        local x, y, z = getCharCoordinates(v)

        if getDistanceBetweenCoords3d(Mx, My, Mz, x, y, z) <= tonumber(radius) and v ~= 1 then
            local result, id = sampGetPlayerIdByCharHandle(v)

            if result then
                inSphere[#inSphere + 1] = id
            end
        end
    end

    return inSphere
  end
  ffi.cdef [[
  struct stGangzone
  {
      float    fPosition[4];
      uint32_t    dwColor;
      uint32_t    dwAltColor;
  };

  struct stGangzonePool
  {
      struct stGangzone    *pGangzone[1024];
      int iIsListed[1024];
  };
  ]]
  function IsPlayerGangZone()
      local gang = {}
      local gz_pool = ffi.cast('struct stGangzonePool*', sampGetGangzonePoolPtr())
      for i = 0,1023 do
          if gz_pool.iIsListed[i] ~= 0 and gz_pool.pGangzone[i] ~= nil then
              local gz_pos = gz_pool.pGangzone[i].fPosition
              local color = gz_pool.pGangzone[i].dwColor
              local x,y, z = getCharCoordinates(PLAYER_PED)
              if ((x >= gz_pos[0] and x <= gz_pos[2]) or (x <= gz_pos[0] and x >= gz_pos[2])) and ((y >= gz_pos[1] and y <= gz_pos[3]) or (y <= gz_pos[1] and y >= gz_pos[3])) then
                  table.insert(gang, {id = id,pos1 = {x = gz_pos[0],y = gz_pos[1]},pos2 = {x = gz_pos[2],y = gz_pos[3]},color = color})
              end
          end
      end
      return gang
  end
  function getTargetBlipCoordinatesFixed()
    local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
    requestCollision(x, y); loadScene(x, y, z)
    local bool, x, y, z = getTargetBlipCoordinates()
    return bool, x, y, z
  end
  function sampGetCharsInSphere(radius)
    local inSphere = {}
    if not radius then return {} end
    local Mx, My, Mz = getCharCoordinates(PLAYER_PED)
    for k,v in pairs(getAllChars()) do
        local x, y, z = getCharCoordinates(v)

        if getDistanceBetweenCoords3d(Mx, My, Mz, x, y, z) <= tonumber(radius) and v ~= 1 then
            local result, id = sampGetPlayerIdByCharHandle(v)

            if result then
                inSphere[#inSphere + 1] = id
            end
        end
    end

    return inSphere
  end
  function math.sign(value)
    return value < 0 and -1 or value > 0 and 1 or 0
  end
  function len(text)
    return #tostring(text):gsub('[\128-\191]', '')
  end
  local function sampGetListboxItemByText(text, plain)
    if not sampIsDialogActive() then return -1 end
    plain = not (plain == false)
    for i = 0, sampGetListboxItemsCount() - 1 do
        if sampGetListboxItemText(i):find(text, 1, plain) then
            return i
        end
    end
    return -1
  end
  function sendClickMap(kak, tak, epta)
    nepon = raknetNewBitStream()

    raknetBitStreamWriteFloat(nepon, kak)
    raknetBitStreamWriteFloat(nepon, tak)
    raknetBitStreamWriteFloat(nepon, epta)
    raknetSendRpc(119, nepon)
    raknetDeleteBitStream(nepon)
  end
  function SearchMarker(posX, posY, posZ)
    local ret_posX = 0.0
    local ret_posY = 0.0
    local ret_posZ = 0.0
    local isFind = false
    for id = 0, 31 do
        local MarkerStruct = 0
        MarkerStruct = 0xC7F168 + id * 56
        local MarkerPosX = representIntAsFloat(readMemory(MarkerStruct + 0, 4, false))
        local MarkerPosY = representIntAsFloat(readMemory(MarkerStruct + 4, 4, false))
        local MarkerPosZ = representIntAsFloat(readMemory(MarkerStruct + 8, 4, false))
        if MarkerPosX ~= 0.0 or MarkerPosY ~= 0.0 or MarkerPosZ ~= 0.0 then
            ret_posX = MarkerPosX
            ret_posY = MarkerPosY
            ret_posZ = MarkerPosZ
            isFind = true
        end
    end
    return isFind, ret_posX, ret_posY, ret_posZ
  end
  function isPlayerOnline(nick)
    nick = nick:lower()
    for i = 0, 999 do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i):lower() == nick then
            return true
        end
    end
    return false
  end
  function enableDialog(bool)
    local memory = require 'memory'
    memory.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
    sampToggleCursor(bool)
  end
  function bringFloatTo(from, dest, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
      local count = timer / (duration / 100)
      return from + (count * (dest - from) / 100)
    end
    return (timer > duration) and dest or from
  end
  local print_orig = print
  function print(...)
      local args = {...}
      function table.val_to_str( v )
            if "string" == type( v ) then
              v = string.gsub( v, "\n", "\\n" )
              if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
                    return "'" .. v .. "'"
              end
              return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
            else
              return "table" == type( v ) and table.tostring( v ) or tostring( v )
            end
      end
      function table.key_to_str( k )
            if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
              return k
            else
              return "[" .. table.val_to_str( k ) .. "]"
            end
      end
      function table.tostring( tbl )
          local result, done = {}, {}
          for k, v in ipairs( tbl ) do
              table.insert( result, table.val_to_str( v ) )
              done[ k ] = true
          end
          for k, v in pairs( tbl ) do
              if not done[ k ] then
                  table.insert( result, table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
              end
          end
          return "{" .. table.concat( result, "," ) .. "}"
      end
      for i, arg in ipairs(args) do
          if type(arg) == "table" then
              args[i] = table.tostring(arg)
          end
      end
      print_orig(table.unpack(args))
  end
  function ip(cl)
    ips = {}
    for word in string.gmatch(cl, "(%d+%p%d+%p%d+%p%d+)") do
      table.insert(ips, { query = word })
    end
    if #ips > 0 then
      data_json = cjson.encode(ips)
      asyncHttpRequest(
        "POST",
        "http://ip-api.com/batch?fields=25305&lang=ru",
        { data = data_json },
        function(response)
          rdata = cjson.decode(u8:decode(response.text))
          textGetip = ""
          for i = 1, #rdata do
            if rdata[i]["status"] == "success" then
              distances =
                distance_cord(
                  rdata[1]["lat"],
                  rdata[1]["lon"],
                  rdata[i]["lat"],
                  rdata[i]["lon"]
                )
              if i == 1 then
                textGetip = textGetip .. string.format(
                  "Reg-ip:\n\nIP - %s\nСтрана - %s\nГород - %s\nПровайдер - %s\nРастояние - %d  \n\n",
                  rdata[i]["query"],
                  rdata[i]["country"],
                  rdata[i]["city"],
                  rdata[i]["isp"],
                  distances
                )
              else
                textGetip = textGetip .. string.format(
                  "Log-ip:\n\nIP - %s\nСтрана - %s\nГород - %s\nПровайдер - %s\nРастояние - %d  \n\n",
                  rdata[i]["query"],
                  rdata[i]["country"],
                  rdata[i]["city"],
                  rdata[i]["isp"],
                  distances
                )
              end
            end
          end
          if textGetip == "" then
            textGetip = " \n\tНичего не найдено"
          end
          if ini.main.getipwindow then
            getip_window[0] = true
          else
            sampAddChatMessage('', -1)
            sampAddChatMessage(string.format(maincolor.."[Ник] {FFFFFF}%s | "..maincolor.."R-IP {FFFFFF}[%s] "..maincolor.."A-IP {FFFFFF}[%s] "..maincolor.."L-IP {FFFFFF}[%s]", ipnick, rdata[1]["query"], getipip2, rdata[2]["query"]), -1)
            sampAddChatMessage(string.format(maincolor.."[Страна] REG - {FFFFFF}%s | "..maincolor.."Last - {FFFFFF}%s", rdata[1]["country"], rdata[2]["country"]), -1)
            sampAddChatMessage(string.format(maincolor.."[Город] REG - {FFFFFF}%s | "..maincolor.."Last - {FFFFFF}%s", rdata[1]["city"], rdata[2]["city"]), -1)
            sampAddChatMessage(string.format(maincolor.."[Провайдер] REG - {FFFFFF}%s | "..maincolor.."Last - {FFFFFF}%s", rdata[1]["isp"], rdata[2]["isp"]), -1)
            sampAddChatMessage(string.format(maincolor.."Расстояние между городами: {FFFFFF}[~%s]"..maincolor.."км.", math.ceil(distances)), -1)
            sampAddChatMessage('', -1)
          end
        end,
        function(err)
          sampAddChatMessage(tag_err..'Произошла ошибка \n '..err, -1)
        end
      )
    end
  end

  function distance_cord(lat1, lon1, lat2, lon2)
    if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil or lat1 == "" or lon1 == "" or lat2 == "" or lon2 == "" then
      return 0
    end
    local dlat = math.rad(lat2 - lat1)
    local dlon = math.rad(lon2 - lon1)
    local sin_dlat = math.sin(dlat / 2)
    local sin_dlon = math.sin(dlon / 2)
    local a =
      sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(
        math.rad(lat2)
      ) * sin_dlon * sin_dlon
    local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    local d = 6378 * c
    return d
  end
  function asyncHttpRequest(method, url, args, resolve, reject)
    local request_thread = effil.thread(function(method, url, args)
      local requests = require"requests"
      local result, response = pcall(requests.request, method, url, args)
      if result then
        response.json, response.xml = nil, nil
        return true, response
      else
        return false, response
      end
    end)(method, url, args)
  
    if not resolve then
      resolve = function() end
    end
    if not reject then
      reject = function() end
    end
    lua_thread.create(function()
      local runner = request_thread
      while true do
        local status, err = runner:status()
        if not err then
          if status == "completed" then
            local result, response = runner:get()
            if result then
              resolve(response)
            else
              reject(response)
            end
            return
          elseif status == "canceled" then
            return reject(status)
          end
        else
          return reject(err)
        end
        wait(0)
      end
    end)
  end
  function sampSetChatInputCursor(start, finish)
    local finish = finish or start
    local start, finish = tonumber(start), tonumber(finish)
    local mem = require 'memory'
    local chatInfoPtr = sampGetInputInfoPtr()
    local chatBoxInfo = getStructElement(chatInfoPtr, 0x8, 4)
    mem.setint8(chatBoxInfo + 0x11E, start)
    mem.setint8(chatBoxInfo + 0x119, finish)
    return true
  end
  function getPlayerIdByNickname(name)
    for i = 0, sampGetMaxPlayerId(false) do
        if sampIsPlayerConnected(i) then
            if sampGetPlayerNickname(i):lower() == tostring(name):lower() then return true, i end
        end
    end
    return false
  end
  function imgui.BeginCustomChild(str_id, size, color)
    local pos = imgui.GetCursorScreenPos()
    local Y = imgui.GetCursorPos().y
    local drawList = imgui.GetWindowDrawList()
    local rounding = imgui.GetStyle().ChildRounding
    local text = str_id:gsub('##.+$', '')
    local lenght = imgui.CalcTextSize(text).x
    imgui.BeginChild(str_id, imgui.ImVec2(size.x, size.y), false)
    local wsize = imgui.GetWindowSize()
    imgui.SetCursorPosX((wsize.x - lenght) / 2)
    imgui.Text(text)
    drawList:AddRect(imgui.ImVec2(pos.x - 1, pos.y - 1), imgui.ImVec2(pos.x + wsize.x + 1, pos.y + wsize.y + 1), color, rounding)
    drawList:AddRectFilled(imgui.ImVec2(pos.x - 1, pos.y - 1), imgui.ImVec2(pos.x + wsize.x + 1, pos.y + 17 + 1), color, rounding, 19)
  end
  function imgui.CustomBarCheckers()
    local pos = imgui.GetCursorScreenPos()
    local winWide = imgui.GetWindowWidth()
    local drawList = imgui.GetWindowDrawList()

    local count = #checkers['buttons']
    local butWide = winWide / count
    local animTime = 0.2
    local sel = checkers['selected']
    local col = imgui.ColorConvertFloat4ToU32(mc)

      drawList:AddRectFilled(imgui.ImVec2(pos.x, pos.y), imgui.ImVec2(pos.x + winWide, pos.y + 60), 0xFF191919, 15)
      
      local renderButton = function(n, color)
        if n == 1 then
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color, 15, 5)
        elseif n == count then
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color, 15, 10)
        else
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color)
        end
      end
      local smooth = function(color)
      local s = function(f)
        return f < 0 and 0 or (f > 255 and 255 or f)
      end
      local _, r, g, b = explode_U32(color)
        local a = s((os.clock() - checkers['clicked']['time']) * (128 / animTime))
        return join_argb(a, r, g, b)
      end
      if checkers['clicked']['time'] and os.clock() - checkers['clicked']['time'] < 0.4 then
        renderButton(sel, smooth(col))
    else
      renderButton(sel, col)
    end
      imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 15)
      imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 4))
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      for i, button in ipairs(checkers['buttons']) do
        if imgui.Button(u8(button .. '##' .. i), imgui.ImVec2(butWide, 60)) then
          if checkers['selected'] ~= i then
            checkers['clicked']['last'] = checkers['selected']
            checkers['clicked']['time'] = os.clock()
            checkers['selected'] = i
          end
        end
        if i ~= count then
          imgui.SameLine()
        end
      end
      imgui.PopStyleColor(3)
      imgui.PopStyleVar(2)
    end
    function imgui.Hint(str_id, hint, delay)
    local hovered = imgui.IsItemHovered()
    local col = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
    local animTime = 0.2
    local delay = delay or 0.00
    local show = true

    if not allHints then allHints = {} end
    if not allHints[str_id] then
      allHints[str_id] = {
        status = false,
        timer = 0
      }
    end

    if hovered then
      for k, v in pairs(allHints) do
        if k ~= str_id and os.clock() - v.timer <= animTime  then
          show = false
        end
      end
    end

    if show and allHints[str_id].status ~= hovered then
      allHints[str_id].status = hovered
      allHints[str_id].timer = os.clock() + delay
    end

    local showHint = function(text, alpha)
      imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)
      imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 5)
      imgui.BeginTooltip()
        imgui.TextColored(imgui.ImVec4(col.x, col.y, col.z, 1.00), fa.ICON_FA_INFO_CIRCLE..u8' Подсказка:')
        imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
        imgui.TextColoredRGB(text, false, true)
        imgui.PopStyleVar()
      imgui.EndTooltip()
      imgui.PopStyleVar(2)
    end

    if show then
      local btw = os.clock() - allHints[str_id].timer
      if btw <= animTime then
        local s = function(f) 
          return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
        end
        local alpha = hovered and s(btw / animTime) or s(1.00 - btw / animTime)
        showHint(hint, alpha)
      elseif hovered then
        showHint(hint, 1.00)
      end
    end
  end
  function imgui.CustomBarReports()
    local pos = imgui.GetCursorScreenPos()
    local winWide = imgui.GetWindowWidth()
    local drawList = imgui.GetWindowDrawList()

    local count = #reports['buttons']
    local butWide = winWide / count
    local animTime = 0.2
    local sel = reports['selected']
    local col = imgui.ColorConvertFloat4ToU32(mc)

      drawList:AddRectFilled(imgui.ImVec2(pos.x, pos.y), imgui.ImVec2(pos.x + winWide, pos.y + 60), 0xFF191919, 15)
      
      local renderButton = function(n, color)
        if n == 1 then
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color, 15, 5)
        elseif n == count then
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color, 15, 10)
        else
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color)
        end
      end
      local smooth = function(color)
      local s = function(f)
        return f < 0 and 0 or (f > 255 and 255 or f)
      end
      local _, r, g, b = explode_U32(color)
        local a = s((os.clock() - reports['clicked']['time']) * (128 / animTime))
        return join_argb(a, r, g, b)
      end
      if reports['clicked']['time'] and os.clock() - reports['clicked']['time'] < 0.4 then
        renderButton(sel, smooth(col))
    else
      renderButton(sel, col)
    end
      imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 15)
      imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 4))
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      for i, button in ipairs(reports['buttons']) do
        if imgui.Button(u8(button .. '##' .. i), imgui.ImVec2(butWide, 60)) then
          if reports['selected'] ~= i then
            reports['clicked']['last'] = reports['selected']
            reports['clicked']['time'] = os.clock()
            reports['selected'] = i
          end
        end
        if i ~= count then
          imgui.SameLine()
        end
      end
      imgui.PopStyleColor(3)
      imgui.PopStyleVar(2)
    end
    function imgui.Hint(str_id, hint, delay)
    local hovered = imgui.IsItemHovered()
    local col = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
    local animTime = 0.2
    local delay = delay or 0.00
    local show = true

    if not allHints then allHints = {} end
    if not allHints[str_id] then
      allHints[str_id] = {
        status = false,
        timer = 0
      }
    end

    if hovered then
      for k, v in pairs(allHints) do
        if k ~= str_id and os.clock() - v.timer <= animTime  then
          show = false
        end
      end
    end

    if show and allHints[str_id].status ~= hovered then
      allHints[str_id].status = hovered
      allHints[str_id].timer = os.clock() + delay
    end

    local showHint = function(text, alpha)
      imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)
      imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 5)
      imgui.BeginTooltip()
        imgui.TextColored(imgui.ImVec4(col.x, col.y, col.z, 1.00), fa.ICON_FA_INFO_CIRCLE..u8' Подсказка:')
        imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
        imgui.TextColoredRGB(text, false, true)
        imgui.PopStyleVar()
      imgui.EndTooltip()
      imgui.PopStyleVar(2)
    end

    if show then
      local btw = os.clock() - allHints[str_id].timer
      if btw <= animTime then
        local s = function(f) 
          return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
        end
        local alpha = hovered and s(btw / animTime) or s(1.00 - btw / animTime)
        showHint(hint, alpha)
      elseif hovered then
        showHint(hint, 1.00)
      end
    end
  end
  function explode_U32(u32)
    local a = bit.band(bit.rshift(u32, 24), 0xFF)
    local r = bit.band(bit.rshift(u32, 16), 0xFF)
    local g = bit.band(bit.rshift(u32, 8), 0xFF)
    local b = bit.band(u32, 0xFF)
    return a, r, g, b
  end

  function join_argb(a, r, g, b)
    local argb = b
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
  end

  function imgui.ColorConvertFloat4ToARGB(float4)
    local abgr = imgui.ColorConvertFloat4ToU32(float4)
    local a, b, g, r = explode_U32(abgr)
    return join_argb(a, r, g, b)
  end

  function ARGBtoStringRGB(argb)
    local color = ('%x'):format(bit.band(argb, 0xFFFFFF))
    return ('{%s%s}'):format(('0'):rep(6 - #color), color)
  end

  function ABGRtoStringRGB(abgr)
    local a, b, g, r = explode_U32(abgr)
    local argb = join_argb(a, r, g, b)
    return ARGBtoStringRGB(argb)
  end
  function imgui.CloseButton(rad, bool)
    local pos = imgui.GetCursorScreenPos()
    local poss = imgui.GetCursorPos()
    local a, b, c, d = pos.x - rad, pos.x + rad, pos.y - rad, pos.y + rad
    local e, f = poss.x - rad, poss.y - rad
    local drawList = imgui.GetWindowDrawList()
    drawList:AddLine(imgui.ImVec2(a, d), imgui.ImVec2(b, c), cbcolor and cbcolor or -1)
    drawList:AddLine(imgui.ImVec2(b, d), imgui.ImVec2(a, c), cbcolor and cbcolor or -1)
    imgui.SetCursorPos(imgui.ImVec2(e, f))
    if imgui.InvisibleButton('##closebut', imgui.ImVec2(rad * 2, rad * 2)) then
        bool[0] = false
    end
    cbcolor = imgui.IsItemHovered() and 0xFF707070 or nil
  end

  function imgui_text_wrapped(text)
    text = ffi.new('char[?]', #text + 1, text)
    local text_end = text + ffi.sizeof(text) - 1
    local pFont = imgui.GetFont()

    local scale = 1.0
    local endPrevLine = pFont:CalcWordWrapPositionA(scale, text, text_end, imgui.GetContentRegionAvail().x)
    imgui.TextUnformatted(text, endPrevLine)

    while endPrevLine < text_end do
        text = endPrevLine
        if text[0] == 32 then text = text + 1 end
        endPrevLine = pFont:CalcWordWrapPositionA(scale, text, text_end, imgui.GetContentRegionAvail().x)
        if text == endPrevLine then
            endPrevLine = endPrevLine + 1
        end
        imgui.TextUnformatted(text, endPrevLine)
    end
  end

  function imgui.CenterTextColoredSameLine(clr, text)
    local width = imgui.GetWindowWidth()
    local lenght = imgui.CalcTextSize(text).x
  
    imgui.SetCursorPosX((width - lenght) / 2)
    imgui.SameLine()
    imgui.TextColored(clr, text)
  end

  function imgui.CenterTextColored(clr, text)
    local width = imgui.GetWindowWidth()
    local lenght = imgui.CalcTextSize(text).x
  
    imgui.SetCursorPosX((width - lenght) / 2)
    imgui.TextColored(clr, text)
  end

  function getNearestRoadCoordinates(radius)
    local A = { getCharCoordinates(PLAYER_PED) }
    local B = { getClosestStraightRoad(A[1], A[2], A[3], 0, radius or 600) }
    if B[1] ~= 0 and B[2] ~= 0 and B[3] ~= 0 then
        return true, B[1], B[2], getGroundZFor3dCoord(B[1], B[2], 999)
    end
    return false
  end

  local splitsigned = function(n) 
      n = tonumber(n)
      local x, y = bit.band(n, 0xffff), bit.rshift(n, 16)
      if x >= 0x8000 then x = x-0xffff end
      if y >= 0x8000 then y = y-0xffff end
      return x, y
  end

  function rotateCarAroundUpAxis(car, vec)
    local mat = Matrix3X3(getVehicleRotationMatrix(car))
    local rotAxis = Vector3D(mat.up:get())
    vec:normalize()
    rotAxis:normalize()
    local theta = math.acos(rotAxis:dotProduct(vec))
    if theta ~= 0 then
      rotAxis:crossProduct(vec)
      rotAxis:normalize()
      rotAxis:zeroNearZero()
      mat = mat:rotate(rotAxis, -theta)
    end
    setVehicleRotationMatrix(car, mat:get())
  end

  function readFloatArray(ptr, idx)
    return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
  end

  function writeFloatArray(ptr, idx, value)
    writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
  end

  function getVehicleRotationMatrix(car)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
      local mat = readMemory(entityPtr + 0x14, 4, false)
      if mat ~= 0 then
        local rx, ry, rz, fx, fy, fz, ux, uy, uz
        rx = readFloatArray(mat, 0)
        ry = readFloatArray(mat, 1)
        rz = readFloatArray(mat, 2)

        fx = readFloatArray(mat, 4)
        fy = readFloatArray(mat, 5)
        fz = readFloatArray(mat, 6)

        ux = readFloatArray(mat, 8)
        uy = readFloatArray(mat, 9)
        uz = readFloatArray(mat, 10)
        return rx, ry, rz, fx, fy, fz, ux, uy, uz
      end
    end
  end

  function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
      local mat = readMemory(entityPtr + 0x14, 4, false)
      if mat ~= 0 then
        writeFloatArray(mat, 0, rx)
        writeFloatArray(mat, 1, ry)
        writeFloatArray(mat, 2, rz)

        writeFloatArray(mat, 4, fx)
        writeFloatArray(mat, 5, fy)
        writeFloatArray(mat, 6, fz)

        writeFloatArray(mat, 8, ux)
        writeFloatArray(mat, 9, uy)
        writeFloatArray(mat, 10, uz)
      end
    end
  end

  function displayVehicleName(x, y, gxt)
    x, y = convertWindowScreenCoordsToGameScreenCoords(x, y)
    useRenderCommands(true)
    setTextWrapx(640.0)
    setTextProportional(true)
    setTextJustify(false)
    setTextScale(0.33, 0.8)
    setTextDropshadow(0, 0, 0, 0, 0)
    setTextColour(255, 255, 255, 230)
    setTextEdge(1, 0, 0, 0, 100)
    setTextFont(1)
    displayText(x, y, gxt)
  end

  function createPointMarker(x, y, z)
    pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
  end

  function removePointMarker()
    if pointMarker then
      removeUser3dMarker(pointMarker)
      pointMarker = nil
    end
  end

  function getCarFreeSeat(car)
    if doesCharExist(getDriverOfCar(car)) then
      local maxPassengers = getMaximumNumberOfPassengers(car)
      for i = 0, maxPassengers do
        if isCarPassengerSeatFree(car, i) then
          return i + 1
        end
      end
      return nil -- no free seats
    else
      return 0 -- driver seat
    end
  end

  function string.nlower(s)
    s = lower(s)
    local len, res = #s, {}
    for i = 1, len do
        local ch = sub(s, i, i)
        res[i] = ul_rus[ch] or ch
    end
    return concat(res)
  end

  function string.nupper(s)
      s = upper(s)
      local len, res = #s, {}
      for i = 1, len do
          local ch = sub(s, i, i)
          res[i] = lu_rus[ch] or ch
      end
      return concat(res)
  end

  function jumpIntoCar(car)
    local seat = getCarFreeSeat(car)
    if not seat then return false end                         -- no free seats
    if seat == 0 then warpCharIntoCar(playerPed, car)         -- driver seat
    else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) -- passenger seat
    end
    restoreCameraJumpcut()
    return true
  end

  function teleportPlayer(x, y, z)
    if isCharInAnyCar(playerPed) then
      setCharCoordinates(playerPed, x, y, z)
    end
    setCharCoordinatesDontResetAnim(playerPed, x, y, z)
  end

  function setCharCoordinatesDontResetAnim(char, x, y, z)
    if doesCharExist(char) then
      local ptr = getCharPointer(char)
      setEntityCoordinates(ptr, x, y, z)
    end
  end

  function setEntityCoordinates(entityPtr, x, y, z)
    if entityPtr ~= 0 then
      local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
      if matrixPtr ~= 0 then
        local posPtr = matrixPtr + 0x30
        writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
        writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
        writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
      end
    end
  end

  function showCursor(toggle)
    if toggle then
      sampSetCursorMode(CMODE_LOCKCAM)
    else
      sampToggleCursor(false)
    end
    cursorEnabled = toggle
  end
    
  function imgui.TextColoredRGB(text, shadow, wrapped)
    local style = imgui.GetStyle()
    local colors = style.Colors

    local designText = function(text)
		local pos = imgui.GetCursorPos()
		for i = 1, 1 do
			imgui.SetCursorPos(imgui.ImVec2(pos.x + i, pos.y))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x - i, pos.y))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y + i))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y - i))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
		end
		imgui.SetCursorPos(pos)
	end

	text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')
	local render_func = wrapped and imgui_text_wrapped_colored or function(clr, text)
		if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end
		if shadow then designText(text) end
		imgui.TextUnformatted(text)
		if clr then imgui.PopStyleColor() end
	end

	local split = function(str, delim, plain)
		local tokens, pos, i, plain = {}, 1, 1, not (plain == false)
		repeat
			local npos, epos = string.find(str, delim, pos, plain)
			tokens[i] = string.sub(str, pos, npos and npos - 1)
			pos = epos and epos + 1
			i = i + 1
		until not pos
		return tokens
	end

	local color = colors[ffi.C.ImGuiCol_Text]
	for _, w in ipairs(split(text, '\n')) do
		local start = 1
		local a, b = w:find('{........}', start)
		while a do
			local t = w:sub(start, a - 1)
			if #t > 0 then
				render_func(color, t)
				imgui.SameLine(nil, 0)
			end

			local clr = w:sub(a + 1, b - 1)
			if clr:upper() == 'STANDART' then color = colors[ffi.C.ImGuiCol_Text]
			else
				clr = tonumber(clr, 16)
				if clr then
					local r = bit.band(bit.rshift(clr, 24), 0xFF)
					local g = bit.band(bit.rshift(clr, 16), 0xFF)
					local b = bit.band(bit.rshift(clr, 8), 0xFF)
					local a = bit.band(clr, 0xFF)
					color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
				end
			end

			start = b + 1
			a, b = w:find('{........}', start)
		end
		imgui.NewLine()
		if #w >= start then
			imgui.SameLine(nil, 0)
			render_func(color, w:sub(start))
		end
	end
  end
  function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
  end
  function argb_to_rgba(argb)
    local a, r, g, b = explode_argb(argb)
    return join_argb(r, g, b, a)
  end

  function join_argbRecon(r, g, b)
    local rgb = b
    rgb = bit.bor(rgb, bit.lshift(g, 8))
    rgb = bit.bor(rgb, bit.lshift(r, 16))
    return rgb
  end

  function argb_to_rgbaRecon(argb)
    local _, r, g, b = explode_argb(argb)
    return join_argbRecon(r, g, b)
  end

----------------------------------------------------------------------

--                             Системки

  function sumFormat(sum)
    sum = tostring(sum)
      if sum and string.len(sum) > 3 then
          local b, e = ('%d'):format(sum):gsub('^%-', '')
          local c = b:reverse():gsub('%d%d%d', '%1.')
          local d = c:reverse():gsub('^%.', '')
          return (e == 1 and '-' or '')..d
      end
      return sum
  end
  function renderNrp(nick, id, text)
    local renderid = id
    lua_thread.create(function()
      sampCreate3dTextEx(1646, "(( "..text.." ))", 0xFFFFFFFF, 0, 0, 0.3, 15, false, renderid, -1)
      wait(10000)
      sampDestroy3dText(1646)
    end)
  end
  function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\'..thisScript.name..'-version.json'
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
              if updateversion ~= thisScript.version then
                lua_thread.create(function(prefix)
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  sampAddChatMessage(tag..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript.version..' на '..updateversion, -1)
                  wait(250)
                  downloadUrlToFile(updatelink, thisScript.path,
                    function(id3, status1, p13, p23)
                      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                        print(string.format('Загружено %d из %d.', p13, p23))
                      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                        print('Загрузка обновления завершена.')
                        sampAddChatMessage(tag..'Обновление завершено!', -1)
                        ini.main.updateshown = false
                        save()
                        goupdatestatus = true
                        lua_thread.create(function() wait(1000) thisScript:reload() end)
                      end
                      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                        if goupdatestatus == nil then
                          sampAddChatMessage(tag..'Обновление прошло неудачно. Запускаю устаревшую версию..', -1)
                          update = false
                        end
                      end
                    end
                  )
                  end
                )
              else
                update = false
                print('v'..thisScript.version..': Обновление не требуется.')
                sampAddChatMessage(tag.."Обновление не требуется!", -1)
                sampAddChatMessage(tag.."Открыть админ меню - /amenu", -1)
                sampAddChatMessage(tag..'По всем проблемам обращайтесь на почту - support@lulu-bot.tech', -1)
              end
            end
          else
            sampAddChatMessage(tag_err..' Чёт не работает, толи у вас инет умер, толи вас убила Lulu. Смиритесь или проверьте самостоятельно на '..url, -1)
			sampAddChatMessage(tag_err..' Ваша установленная версия: '..thisScript.version..'', -1)
            update = false
          end
        end
      end
    )
    while update ~= false do wait(100) end
  end
  function checkIntable(t, str)
    for k, v in pairs(t) do
      if v == str then return true end
    end
    return false
  end
  function number_week() -- получение номера недели в году
    local current_time = os.date'*t'
    local start_year = os.time{ year = current_time.year, day = 1, month = 1 }
    local week_day = ( os.date('%w', start_year) - 1 ) % 7
    return math.ceil((current_time.yday + week_day) / 7)
  end

  function getStrDate(unixTime)
    local tMonths = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'}
    local day = tonumber(os.date('%d', unixTime))
    local month = tMonths[tonumber(os.date('%m', unixTime))]
    local weekday = tWeekdays[tonumber(os.date('%w', unixTime))]
    return string.format('%s, %s %s', weekday, day, month)
  end

  function get_timer(sec)
    local hours = sec/60/60
    hours = math.floor(hours)
    local minute = (sec-math.floor(hours)*60*60)/60
    minute = math.floor(minute)
    local second = sec - math.floor(minute)*60 - math.floor(hours)*60*60
    if second < 10 then
      second = "0"..second
    end
    if minute < 10 then
      minute = "0"..minute
    end
    if hours < 10 then
      hours = "0"..hours
    end
    return string.format("%s:%s:%s", tostring(hours), tostring(minute), tostring(second))
  end
  function get_timer_minute(time)
    local timezone_offset = 86400 - os.date('%M', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400)..'д ' or '')..'%M:%S', time + timezone_offset)
  end
  function imgui.NewInputText(lable, val, width, hint, hintpos)
    local hint = hint and hint or ''
    local hintpos = tonumber(hintpos) and tonumber(hintpos) or 1
    local cPos = imgui.GetCursorPos()
    imgui.PushItemWidth(width)
    local result = imgui.InputText(lable, val, sizeof(val))
    if #str(val) == 0 then
        local hintSize = imgui.CalcTextSize(hint)
        if hintpos == 2 then imgui.SameLine(cPos.x + (width - hintSize.x) / 2)
        elseif hintpos == 3 then imgui.SameLine(cPos.x + (width - hintSize.x - 5))
        else imgui.SameLine(cPos.x + 5) end
        imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 0.40), tostring(hint))
    end
    imgui.PopItemWidth()
    return result
  end
  function imgui.BoolButton(bool, ...)
    if type(bool) ~= 'boolean' then return end
    if bool then
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 0.28, 0.28, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.28, 0.28, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1.00, 0.28, 0.28, 1.00))
        local result = imgui.Button(...)
        imgui.PopStyleColor(3)
        return result
    else
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.20, 0.20, 0.20, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.18, 0.18, 0.18, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.16, 0.16, 0.16, 1.00))
        local result = imgui.Button(...)
        imgui.PopStyleColor(3)
        return result
    end
  end
  function imgui.Question(...)
    imgui.SameLine()
    imgui.SetCursorPosY(imgui.GetCursorPos().y + 3)
    imgui.PushFont(imFont[11])
    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.3), fa.ICON_FA_QUESTION)
    imgui.PopFont()
    local id = imgui.GetCursorPos()
    imgui.Hint(...)
    imgui.SetCursorPosY(imgui.GetCursorPos().y - 3)
  end
  function imgui.NavigateButton(bool, icon, name)
    local buttonWide = 190
    local animTime = 0.25
    local drawList = imgui.GetWindowDrawList()
    local p1 = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      local button = imgui.InvisibleButton(name, imgui.ImVec2(buttonWide, 35))
      if button and not bool then navigateLast = os.clock() end
      local pressed = imgui.IsItemActive()
      imgui.PopStyleColor(3)
    if bool then
      if navigateLast and (os.clock() - navigateLast) < animTime then
        local wide = (os.clock() - navigateLast) * (buttonWide / animTime)
        drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2((p1.x + 190) - wide, p1.y + 35), 0x10FFFFFF, 15, 10)
            drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 5, p1.y + 35), imgui.ColorConvertFloat4ToU32(mc))
        drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + wide, p1.y + 35), imgui.ColorConvertFloat4ToU32(imgui.ImVec4(mc.x, mc.y, mc.z, 0.6)), 15, 10)
      else
        drawList:AddRectFilled(imgui.ImVec2(p1.x, (pressed and p1.y + 3 or p1.y)), imgui.ImVec2(p1.x + 5, (pressed and p1.y + 32 or p1.y + 35)), imgui.ColorConvertFloat4ToU32(mc))
        drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), imgui.ColorConvertFloat4ToU32(imgui.ImVec4(mc.x, mc.y, mc.z, 0.6)), 15, 10)
      end
    else
      if imgui.IsItemHovered() then
        drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), 0x10FFFFFF, 15, 10)
      end
    end
    imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 8)
    if bool then
      imgui.Text((' '):rep(3) .. icon)
      imgui.SameLine(60)
      imgui.Text(name)
    else
      imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
      imgui.SameLine(60)
      imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
    end
    imgui.SetCursorPosY(p2.y + 40)
    return button
  end

  function imgui.SubTitle(title)
    imgui.PushFont(imFont[18])
    imgui.TextColored(mc, title)
    imgui.PopFont()
  end
  function getTargetBlipCoordinatesFixed()
    local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
    requestCollision(x, y); loadScene(x, y, z)
    local bool, x, y, z = getTargetBlipCoordinates()
    return bool, x, y, z
  end
  function ShowMessage(text, title, style)
    local messageboxathread = effil.thread(function(text, title, style)
      local ffi = require('ffi')
      ffi.cdef("int MessageBoxA( void* hWnd, const char* lpText, const char* lpCaption, unsigned int uType); ")
      ffi.C.MessageBoxA(nil, text, title, style and (style + 327680) or 327680)
    end)(text, title, style) --(Unable to dump Lua function: Unknown (1))

    lua_thread.create(function()
      local msgboxthread = messageboxathread
      while true do
        wait(0)
        local status, err = msgboxthread:status()

        if not err and status == "completed" then
          return
        end
      end
    end)
  end

  function gpsDw()
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\Lulu Tools\\gps.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile("https://lulu-bot.tech/tools/gps.json", json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              gpsInfo = decodeJson(f:read('*a'))
              f:close()
            end
          end
        end
      end
    )

    local json = getWorkingDirectory() .. '\\Lulu Tools\\cmd.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile("https://lulu-bot.tech/tools/cmd.json", json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              cmdInfo = decodeJson(f:read('*a'))
              f:close()
            end
          end
        end
      end
    )--

    local json = getWorkingDirectory() .. '\\Lulu Tools\\question.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile("https://lulu-bot.tech/tools/question.json", json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              questionInfo = decodeJson(f:read('*a'))
              f:close()
            end
          end
        end
      end
    )
  end
  

  addEventHandler("onWindowMessage", function (msg, wparam, lparam)
      if msg == wm.WM_MOUSEWHEEL and enAirBrake then
          local button, delta = splitsigned(ffi.cast('int32_t', wparam))
          if delta > 0 then
              if ini.main.speed_airbrake <= 0.11 then
                  return false
              end
              ini.main.speed_airbrake = ini.main.speed_airbrake - 0.1
          elseif delta < 0 then
              ini.main.speed_airbrake = ini.main.speed_airbrake + 0.1
          end
      end
      if msg == wm.WM_SETFOCUS then
    
        memory.hex2bin("5051FF1500838500", 7623723, 8)
        memory.hex2bin("0F847B010000", 5499528, 6)
    
        if not isGamePaused() then
          erorafk = false
        end
    
        afkstatus = false
      end
  end)

  function infoReport(answer)
    if ini.main.infoot then
      sampAddChatMessage('{ffa6a6}---------------------------------------------------------------------------------------------', -1)
      sampAddChatMessage('', -1)
      sampAddChatMessage('', -1)
      sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Автор жалобы: {FFFFFF}'..repNick.."["..repId.."]", -1)
      sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Текст: {FFFFFF}'..repText, -1)
      sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Ответ: {FFFFFF}'..answer, -1)
      sampAddChatMessage('', -1)
      sampAddChatMessage('', -1)
      sampAddChatMessage('{ffa6a6}---------------------------------------------------------------------------------------------', -1)
    end
  end

----------------------------------------------------------------------
