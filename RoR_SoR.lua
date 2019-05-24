if not RoR_SoR then RoR_SoR= {} end
local version = "112"
local ZoneLockTimer = 10
local RoR_Window_Scale

local c_DEFAULT_HIDE_TIMER = 1.0
local c_DEFAULT_FADEIN_TIMER = 0.3
local c_DEFAULT_FADEOUT_TIMER = 0.3

local Popper = {m_HideCountdown = c_DEFAULT_HIDE_TIMER, m_IsShowing = false,}

if not RoR_SoR.Settings then RoR_SoR.Settings ={ShowT1 = true,ShowT4 = true,StackDir = 2} end

RoR_SoR.DebugKeep = false
RoR_SoR.DebugBO = false
--(wstring.match(wstring.gsub(wstring.gsub(wstring.gsub(L"Dont Feel Nuthing",L" of ", L"O"), L"%s",L""), L"%l*", L""), L"([^^]+)^?.*"))  --This is for Shortening Guildnames
RoR_SoR.RealmColors = {{r=155,g=155,b=155},{r=107,g=191,b=255},{r=255,g=105,b=105}}
RoR_SoR.CappingRealmColors = {{r=255,g=255,b=255},{r=255,g=105,b=105},{r=107,g=191,b=255}}
RoR_SoR.T4_ActiveZones = {[3]=1,[5]=2,[9]=3,[103]=1,[105]=2,[109]=3,[209]=3,[205]=2,[203]=1}
--RoR_SoR.KeepLord = {[1] = "MurderballOrder",[2] = "MurderballDestruction"}
RoR_SoR.Forts = {[4]=2,[10]=1,[104]=2,[110]=1,[204]=2,[210]=1}
RoR_SoR.KeepLord = {[1] = "SoR_LordIcon",[2] = "SoR_LordIcon"}
RoR_SoR.ZoneNames = {[1]={1,7},[2]={2,8},[6]={6,11},[7]={1,7},[8]={2,8},[11]={6,11},[100]={100,106},[101]={107,101},[102]={102,108},[106]={100,106},[107]={107,101},[108]={102,108},[200]={200,206},[201]={207,201},[202]={202,208},[206]={200,206},[207]={207,201},[208]={202,208}}
RoR_SoR.TierNames = {[1]={006,011,100,106,200,206},[2]={001,007,101,107,201,207},[3]={002,008,102,108,202,208},[4]={003,005,009,103,105,109,209,205,203}}

RoR_SoR.TextLock = towstring(GetStringFromTable("MapSystem", StringTables.MapSystem.TEXT_CAMPAIGN_PAIRING_LOCKED ) )
RoR_SoR.TextZoneLocked =	towstring(GetStringFromTable("Hardcoded", 1268))
RoR_SoR.TextTaken = towstring(GetStringFromTable("Hardcoded", 274))

RoR_SoR.TextNeutral = towstring(GetStringFromTable("Default", StringTables.Default.LABEL_UNCONTROLLED ) )
RoR_SoR.TextOrder = towstring(GetStringFromTable("Default", StringTables.Default.LABEL_UNCONTROLLED ) )
RoR_SoR.TextDestro = towstring(GetStringFromTable("Default", StringTables.Default.LABEL_ORDER_CONTROLLED ) )


--103 CW,105 praag, 109 Reik 
function RoR_SoR.OnInitialize()
--This is for debugging
RoR_SoR.Debug_T2_BO_Texts = {[1]=L"StreamName: ",[2]=L"ZoneID: ",[3]=L"BO1_ID: ",[4]=L"BO1_OWNER: ",[5]=L"BO1_STATE: ",[6]=L"BO1_TIMER: ",[7]=L"BO2_ID: ",
						[8]=L"BO2_OWNER: ",[9]=L"BO2_STATE: ",[10]=L"BO2_TIMER: ",[11]=L"BO3_ID: ",[12]=L"BO3_OWNER: ",[13]=L"BO3_STATE: ",[14]=L"BO3_TIMER: ",
						[15]=L"BO4_ID: ",[16]=L"BO4_OWNER: ",[17]=L"BO4_STATE: ",[18]=L"BO4_TIMER: ",[19]=L"VP's: ",[20]=L"Supply: ",[21]=L"Guilds: "}

RoR_SoR.Debug_T3_BO_Texts = {[1]=L"StreamName: ",[2]=L"ZoneID: ",[3]=L"BO1_ID: ",[4]=L"BO1_OWNER: ",[5]=L"BO1_STATE: ",[6]=L"BO1_TIMER: ",[7]=L"BO2_ID: ",
						[8]=L"BO2_OWNER: ",[9]=L"BO2_STATE: ",[10]=L"BO2_TIMER: ",[11]=L"BO3_ID: ",[12]=L"BO3_OWNER: ",[13]=L"BO3_STATE: ",[14]=L"BO3_TIMER: ",
						[15]=L"BO4_ID: ",[16]=L"BO4_OWNER: ",[17]=L"BO4_STATE: ",[18]=L"BO4_TIMER: ",[19]=L"VP's: ",[20]=L"Supply: ",[21]=L"Guilds: ",[22]=L"ACTIVE_ZONE: "}						

						
RoR_SoR.Debug_T2_KEEP_Texts = {[1]=L"StreamName: ",[2]=L"ZoneID: ",[3]=L"KEEP1_ID: ",[4]=L"KEEP1_RANK: ",[5]=L"KEEP1_OWNER: ",[6]=L"KEEP1_STATUS: ",[7]=L"KEEP1_MESSAGE: ",
						[8]=L"KEEP_1_CLAIMED: ",[9]=L"KEEP_1_INNER: ",[10]=L"KEEP_1_LORD: ",[11]=L"KEEP1_??: ",[12]=L"KEEP2_ID: ",[13]=L"KEEP2_RANK: ",[14]=L"KEEP2_OWNER: ",[15]=L"KEEP2_STATUS: ",
						[16]=L"KEEP2_MESSAGE: ",[17]=L"KEEP_2_CLAIMED: ",[18]=L"KEEP_2_INNER_DOOR: ",[19]=L"KEEP_2_LORD: ",[20]=L"KEEP2_??: ",[21]=L"AAO: "}

RoR_SoR.Debug_T3_KEEP_Texts = {[1]=L"StreamName: ",[2]=L"ZoneID: ",[3]=L"KEEP1_ID: ",[4]=L"KEEP1_OWNER: ",[5]=L"KEEP1_RANK: ",[6]=L"KEEP1_STATUS: ",[7]=L"KEEP1_MESSAGE: ",
						[8]=L"KEEP_1_OUTER: ",[9]=L"KEEP_1_INNER: ",[10]=L"KEEP_1_LORD: ",[11]=L"KEEP_1_CLAIMED: ",[12]=L"KEEP2_ID: ",[13]=L"KEEP2_OWNER: ",[14]=L"KEEP2_RANK: ",[15]=L"KEEP2_STATUS: ",
						[16]=L"KEEP2_MESSAGE: ",[17]=L"KEEP_2_OUTER_DOOR: ",[18]=L"KEEP_2_INNER_DOOR: ",[19]=L"KEEP_2_LORD: ",[20]=L"KEEP_2_CLAIMED: ",[21]=L"ACTIVE_ZONE: ",[22]=L"AAO: "}						
						
RoR_SoR.Debug_KEEP_STATUS = {[1]=L"KEEPSTATUS_SAFE",[2]=L"KEEPSTATUS_OUTER_WALLS_UNDER_ATTACK",[3]=L"KEEPSTATUS_INNER_SANCTUM_UNDER_ATTACK",[4]=L"KEEPSTATUS_KEEP_LORD_UNDER_ATTACK",
							[5]=L"KEEPSTATUS_SEIZED",[6]=L"KEEPSTATUS_LOCKED"}						
						
RoR_SoR.Debug_KEEP_MESSAGE = {[0]=L"Safe",[1]=L"Outer75",[2]=L"Outer50",[3]=L"Outer20",[4]=L"Outer0",[5]=L"Inner75",[6]=L"Inner50",[7]=L"Inner20",[8]=L"Inner0",[9]=L"Lord100",[10]=L"Lord50",[11]=L"Lord20",[12]=L"Fallen"}			
							

CreateWindow("RoR_SoR_Main_Window", false)
CreateWindow("RoR_SoR_Popper", false)
CreateWindow("RoR_SoR_Button", true)

LayoutEditor.RegisterWindow( "RoR_SoR_Main_Window", L"SoR Anchor Window", L"SoR Anchor Window", true, true, true, nil )
LayoutEditor.RegisterWindow( "RoR_SoR_Button", L"SoR Toggle Button", L"SoR Toggle Button", false, false, false, nil )	
	
RegisterEventHandler( SystemData.Events.ENTER_WORLD, "RoR_SoR.Enable" )
RegisterEventHandler( SystemData.Events.INTERFACE_RELOADED, "RoR_SoR.Enable" )							
RegisterEventHandler(TextLogGetUpdateEventId("Chat"), "RoR_SoR.OnChatLogUpdated")
TextLogAddEntry("Chat", 0, L"<icon00057> RoR_SoR "..towstring(version)..L" Loaded.")
	
RoR_Window_Scale = (tonumber(WindowGetScale("RoR_SoR_Main_Window")))
RoR_Window_Alpha = (tonumber(WindowGetAlpha("RoR_SoR_Main_Window")))

RoR_SoR.Timers = {}
RoR_SoR.OpenZones = {}
RoR_SoR.ZoneTimer = {}
RoR_SoR.BO_States = {}
RoR_SoR.BO_IDs = {}
RoR_SoR.KEEP_States = {}
RoR_SoR.KEEP_IDs = {}
RoR_SoR.HideChannel(65)
RoR_SoR.Fort = {}

if not RoR_SoR.Settings.Offset then RoR_SoR.Settings.Offset = 15 end

	if (LibSlash ~= nil) then
	LibSlash.RegisterSlashCmd("soroffset", function(input) RoR_SoR.Offset(input) end)
	end

--Registers the /slash commands 




WindowSetScale("RoR_SoR_Popper",RoR_Window_Scale)
end

function RoR_SoR.OnShutdown()
	
UnregisterEventHandler(TextLogGetUpdateEventId("Chat"), "RoR_SoR.OnChatLogUpdated")
UnregisterEventHandler( SystemData.Events.ENTER_WORLD, "RoR_SoR.Enable" )
UnregisterEventHandler( SystemData.Events.INTERFACE_RELOADED, "RoR_SoR.Enable" )			
end

function RoR_SoR.OnChatLogUpdated(updateType, filterType)
	if WindowGetShowing("RoR_SoR_Main_Window") == true then
		if( updateType == SystemData.TextLogUpdate.ADDED ) then 			
			if filterType == SystemData.ChatLogFilters.CHANNEL_9 then	
				local _, filterId, text = TextLogGetEntry( "Chat", TextLogGetNumEntries("Chat") - 1 ) 
				RoR_SoR.Text_Stream_Fetch(text)
			end
		end
	end
end
function RoR_SoR.Enable()
SendChatText(L".sorenable", L"")
end


function RoR_SoR.Text_Stream_Fetch(text)
local text = towstring(text)
--TODO: Ask Hargrim to include outer door in T2 keep stream as an placeholder for the higher tiers (should be at stream possition 9)

	if text:find(L"SoR_") and (not text:find(L"SoR_F")) then
		--Check For BO stream
		if text:match( L"SoR_+[^%.]+_BO:([^%.]+).") then	
		local SoR_BO_SPLIT_TEXT_STREAM = StringSplit(tostring(text), ":")
		if SoR_BO_SPLIT_TEXT_STREAM[15] == nil then return end -- check and exit if short string

		--Create window if not exist
			local Window_Name = tostring(SoR_BO_SPLIT_TEXT_STREAM[2])
			--Setup Tier 4 BO zone stuff
			if (SoR_BO_SPLIT_TEXT_STREAM[1] == "SoR_T4_BO") and (RoR_SoR.Settings.ShowT4 == true) then			
				local Fetch_Active_Zone = tonumber(SoR_BO_SPLIT_TEXT_STREAM[22])
					if (not DoesWindowExist("SoR_"..Window_Name)) then 
						CreateWindowFromTemplate("SoR_"..Window_Name, "RoR_SoR_RealmTemplate", "Root")
							RoR_SoR.BO_States[Window_Name] = {}
							RoR_SoR.KEEP_States[Window_Name] = {}
							local ZoneData = GetCampaignZoneData(tonumber(Window_Name))
							RoR_SoR.OpenZones[Window_Name] =  tonumber(ZoneData.tierId)
						LabelSetText("SoR_"..Window_Name.."BannerLabel",towstring(GetZoneName(tonumber(Window_Name))))
						local BannerW,_ = LabelGetTextDimensions("SoR_"..Window_Name.."BannerLabel")
						WindowSetDimensions( "SoR_"..Window_Name.."BannerMid", BannerW, 40 )											
					end
			--Setup Tier 1 BO zone stuff	
			elseif	(SoR_BO_SPLIT_TEXT_STREAM[1] == "SoR_T1_BO") and (RoR_SoR.Settings.ShowT1 == true) then	
				if (not DoesWindowExist("SoR_"..Window_Name)) then		
					CreateWindowFromTemplate("SoR_"..Window_Name, "RoR_SoR_RealmTemplate", "Root")
					RoR_SoR.BO_States[Window_Name] = {}
					local ZoneData = GetCampaignZoneData(tonumber(Window_Name))
					RoR_SoR.OpenZones[Window_Name] =  tonumber(ZoneData.tierId)
					LabelSetText("SoR_"..Window_Name.."BannerLabel",towstring(GetZoneName(RoR_SoR.ZoneNames[tonumber(Window_Name)][1]))..L" · "..towstring(GetZoneName(RoR_SoR.ZoneNames[tonumber(Window_Name)][2])))	
					local BannerW,_ = LabelGetTextDimensions("SoR_"..Window_Name.."BannerLabel")
					WindowSetDimensions( "SoR_"..Window_Name.."BannerMid", BannerW, 40 )						
				end
				RoR_SoR.T1_UPDATE(Window_Name,SoR_BO_SPLIT_TEXT_STREAM)	
			--Setup Tier 2-3 BO zone stuff
			elseif((SoR_BO_SPLIT_TEXT_STREAM[1] == "SoR_T2_BO") or (SoR_BO_SPLIT_TEXT_STREAM[1] == "SoR_T3_BO")) and (RoR_SoR.Settings.ShowT4 == true) then --Setup Tier 2 and 3 BO zone stuff
				if (not DoesWindowExist("SoR_"..Window_Name)) then		
					CreateWindowFromTemplate("SoR_"..Window_Name, "RoR_SoR_RealmTemplate", "Root")
					RoR_SoR.BO_States[Window_Name] = {}
					local ZoneData = GetCampaignZoneData(tonumber(Window_Name))
					RoR_SoR.OpenZones[Window_Name] =  tonumber(ZoneData.tierId)
					RoR_SoR.KEEP_States[Window_Name] = {}
					LabelSetText("SoR_"..Window_Name.."BannerLabel",towstring(GetZoneName(RoR_SoR.ZoneNames[tonumber(Window_Name)][1]))..L" · "..towstring(GetZoneName(RoR_SoR.ZoneNames[tonumber(Window_Name)][2])))	
					local BannerW,_ = LabelGetTextDimensions("SoR_"..Window_Name.."BannerLabel")
					WindowSetDimensions( "SoR_"..Window_Name.."BannerMid", BannerW, 40 )						
				end				
			end		
			if RoR_SoR.DebugBO == true then
				if SoR_BO_SPLIT_TEXT_STREAM[1] == "SoR_T4_BO" or SoR_BO_SPLIT_TEXT_STREAM[1] == "SoR_T3_BO" then
					for i=1,#SoR_BO_SPLIT_TEXT_STREAM do
						d(RoR_SoR.Debug_T3_BO_Texts[i]..towstring(SoR_BO_SPLIT_TEXT_STREAM[i]))
					end
				else
					for i=1,#SoR_BO_SPLIT_TEXT_STREAM do
						d(RoR_SoR.Debug_T2_BO_Texts[i]..towstring(SoR_BO_SPLIT_TEXT_STREAM[i]))
					end
				end
			end	
		RoR_SoR.SET_BO(SoR_BO_SPLIT_TEXT_STREAM)
--		d(L"==============================================")

		--Check for KEEP stream	
		elseif text:match( L"SoR_+[^%.]+_Keep:([^%.]+).") then	
			local SoR_KEEP_SPLIT_TEXT_STREAM = StringSplit(tostring(text), ":")
			if SoR_KEEP_SPLIT_TEXT_STREAM[10] == nil then return end
	--			if SoR_KEEP_SPLIT_TEXT_STREAM[1] == "SoR_T4_Keep" or SoR_KEEP_SPLIT_TEXT_STREAM[1] == "SoR_T3_Keep" then
				if RoR_SoR.DebugKeep == true then
					for i=1,#SoR_KEEP_SPLIT_TEXT_STREAM do
						d(RoR_SoR.Debug_T3_KEEP_Texts[i]..towstring(SoR_KEEP_SPLIT_TEXT_STREAM[i]))
					end	
				end	

			RoR_SoR.SET_KEEP(SoR_KEEP_SPLIT_TEXT_STREAM)
		end
	end
	
		if text:find(L"SoR_F") then
		local SoR_FORT_SPLIT_TEXT_STREAM = StringSplit(tostring(text), ":")
--			if SoR_KEEP_SPLIT_TEXT_STREAM[1] == "SoR_T4_Keep" or SoR_KEEP_SPLIT_TEXT_STREAM[1] == "SoR_T3_Keep" then
			if RoR_SoR.DebugKeep == true then
				for i=1,#SoR_FORT_SPLIT_TEXT_STREAM do
					d(towstring(SoR_FORT_SPLIT_TEXT_STREAM[i]))
				end	
			end
			RoR_SoR.SET_FORT(SoR_FORT_SPLIT_TEXT_STREAM)

		end
	
end

function RoR_SoR.SET_FORT(Input)
	local SoR_FORT_SPLIT_TEXT_STREAM = Input
	local Window_Name = tostring(SoR_FORT_SPLIT_TEXT_STREAM[2])
	local F_Stage = tonumber(SoR_FORT_SPLIT_TEXT_STREAM[3])
	
	if DoesWindowExist("SoR_"..Window_Name) then
	LabelSetText("SoR_"..Window_Name.."BannerLabel",towstring(GetZoneName(tonumber(Window_Name))))	
	local BannerW,_ = LabelGetTextDimensions("SoR_"..Window_Name.."BannerLabel")
	WindowSetDimensions( "SoR_"..Window_Name.."BannerMid", BannerW, 40 )			
	DynamicImageSetTexture( "SoR_"..Window_Name.."KEEP1KEEPICON", RoR_SoR.GetKeepTexture(RoR_SoR.Forts[tonumber(Window_Name)],1),42,42 )	
	
		if F_Stage == 1 then
	--	if SoR_KEEP_SPLIT_TEXT_STREAM[1] ~= "SoR_T2_Keep" then	
			local F_Timer = tonumber(SoR_FORT_SPLIT_TEXT_STREAM[4])
			WindowSetShowing( "SoR_"..Window_Name.."_TIMER",true)	
			WindowSetShowing( "SoR_"..Window_Name.."_HEALTH",false)	
			WindowSetShowing( "SoR_"..Window_Name.."KEEP1LORD_ICON",false)	
			WindowSetShowing( "SoR_"..Window_Name.."KEEP1KEEPDOOR1",true)				
			
			
			
			RoR_SoR.Timers[Window_Name][1] = F_Timer	
			for i=1,5 do				
				WindowSetShowing( "SoR_"..Window_Name.."BO"..i.."FlagBG",false)	
				WindowSetShowing( "SoR_"..Window_Name.."BO"..i.."Flag",false)					
			end
			
		elseif 	F_Stage == 2 then
			WindowSetShowing( "SoR_"..Window_Name.."_TIMER",false)	
			WindowSetShowing( "SoR_"..Window_Name.."_HEALTH",true)	
			WindowSetShowing( "SoR_"..Window_Name.."KEEP1LORD_ICON",false)	
			WindowSetShowing( "SoR_"..Window_Name.."KEEP1KEEPDOOR1",true)					
			LabelSetText("SoR_"..Window_Name.."_HEALTH",towstring(SoR_FORT_SPLIT_TEXT_STREAM[4])..L"%")
			for i=1,5 do			
				WindowSetShowing( "SoR_"..Window_Name.."BO"..i.."FlagBG",true)	
				WindowSetShowing( "SoR_"..Window_Name.."BO"..i.."Flag",true)
				DynamicImageSetTexture( "SoR_"..Window_Name.."BO"..i.."FlagBG", RoR_SoR.GetFlag(SoR_FORT_SPLIT_TEXT_STREAM[4+(i*2)],0),31,31 )				
			end
		elseif 	F_Stage == 3 then
			local F_Timer = tonumber(SoR_FORT_SPLIT_TEXT_STREAM[5])
			WindowSetShowing( "SoR_"..Window_Name.."_TIMER",true)	
			WindowSetShowing( "SoR_"..Window_Name.."_HEALTH",true)
			WindowSetShowing( "SoR_"..Window_Name.."KEEP1LORD_ICON",true)						
			WindowSetShowing( "SoR_"..Window_Name.."KEEP1KEEPDOOR1",false)			
			LabelSetText("SoR_"..Window_Name.."_HEALTH",towstring(SoR_FORT_SPLIT_TEXT_STREAM[4])..L"%")
			RoR_SoR.Timers[Window_Name][1] = F_Timer	
			
			for i=1,5 do			
				WindowSetShowing( "SoR_"..Window_Name.."BO"..i.."FlagBG",false)	
				WindowSetShowing( "SoR_"..Window_Name.."BO"..i.."Flag",false)		
			end

		end
		RoR_SoR.ZoneTimer[Window_Name] = ZoneLockTimer
	else			
	CreateWindowFromTemplate("SoR_"..Window_Name, "RoR_SoR_FortTemplate", "Root")	
	RoR_SoR.OpenZones[Window_Name] =  tonumber(5)	
	RoR_SoR.Timers[Window_Name] = {}	
	RoR_SoR.Fort[Window_Name] = true
	RoR_SoR.SET_FORT(SoR_FORT_SPLIT_TEXT_STREAM)	
	end	
	RoR_SoR.Restack()	
end




local function CompareEntry(entryA, entryB)
	return (entryA.Tier > entryB.Tier)
end

function  RoR_SoR.Restack()
		RoR_Window_Scale = (tonumber(WindowGetScale("RoR_SoR_Main_Window")))
		WindowSetScale("RoR_SoR_Popper",RoR_Window_Scale)
		local uiScale = InterfaceCore.GetScale()
		local ResolutionScale = InterfaceCore.GetResolutionScale()			
		local Inteface_Scale = SystemData.Settings.Interface.globalUiScale
		RoR_SoR.StackSort = {};
		for k,v in pairs(RoR_SoR.OpenZones) do
		WindowSetScale("SoR_"..k,WindowGetScale("RoR_SoR_Main_Window"))		
		    --table.insert(RoR_SoR.StackSort,{[v]=k})
			table.insert(RoR_SoR.StackSort,{Zone=k,Tier=v})
			table.sort(RoR_SoR.StackSort, CompareEntry)			
		end
		
		for k,v in ipairs(RoR_SoR.StackSort) do
		local width,height = WindowGetDimensions( "SoR_"..v.Zone)	
		local WndScale = WindowGetScale("SoR_"..v.Zone)
		width = width*WndScale
		height = ((height+RoR_SoR.Settings.Offset)*WndScale)/Inteface_Scale
			WindowClearAnchors( "SoR_"..v.Zone )
			if RoR_SoR.Settings.StackDir == 1 then
			WindowAddAnchor( "SoR_"..v.Zone , "bottom", "RoR_SoR_Main_Window", "top", 0,(0-(height))+(height*k))			
			--	WindowAddAnchor( "SoR_"..v.Zone , "bottom", "RoR_SoR_Main_Window", "top", 0,((175*tonumber(k-1))*RoR_Window_Scale)/(uiScale/ResolutionScale/Inteface_Scale))
			elseif  RoR_SoR.Settings.StackDir == 2 then
			WindowAddAnchor( "SoR_"..v.Zone , "top", "RoR_SoR_Main_Window", "bottom", 0,height-(height*k))				
			--	WindowAddAnchor( "SoR_"..v.Zone , "top", "RoR_SoR_Main_Window", "bottom", 0,0-((((175*tonumber(k-1)))*RoR_Window_Scale)/(uiScale/ResolutionScale/Inteface_Scale)))
			end
		end
return
end


function RoR_SoR.SET_BO(Input)
	local SoR_BO_SPLIT_TEXT_STREAM = Input
	local Window_Name = tostring(SoR_BO_SPLIT_TEXT_STREAM[2])
	if DoesWindowExist("SoR_"..Window_Name) then
		RoR_SoR.Timers[SoR_BO_SPLIT_TEXT_STREAM[2]] = {}
		WindowSetScale("SoR_"..Window_Name,WindowGetScale("RoR_SoR_Main_Window"))
		RoR_SoR.ZoneTimer[Window_Name] = ZoneLockTimer
		RoR_SoR.BO_IDs[Window_Name] = {}
		
		--local ZoneVPs = tonumber(SoR_BO_SPLIT_TEXT_STREAM[19])
		--LabelSetText("SoR_"..Window_Name.."VPPERCENT_ORDER",towstring(ZoneVPs)..L"%")
		--LabelSetText("SoR_"..Window_Name.."VPPERCENT_DESTRO",towstring(100-ZoneVPs)..L"%")
--RoR_SoR.sortlist(RoR_SoR.StackSort,RoR_SoR.StackSort2)
		
		RoR_SoR.Restack()
		
		local Lock_Counter = 0	
		for i=1,4 do	
			local BO_State = tonumber(SoR_BO_SPLIT_TEXT_STREAM[1+(4*i)])
			local BO_Owner = tonumber(SoR_BO_SPLIT_TEXT_STREAM[(4*i)])
				
			RoR_SoR.BO_IDs[Window_Name][i] = {}
			RoR_SoR.BO_IDs[Window_Name][i].ID = SoR_BO_SPLIT_TEXT_STREAM[(4*i)-1]
			RoR_SoR.BO_IDs[Window_Name][i].Owner = BO_Owner
			
			
			local RealmColor = nil
			if BO_State == 4 then
				if RoR_SoR.BO_States[Window_Name][i] ~= 4 then
					WindowStartAlphaAnimation( "SoR_"..Window_Name.."BO"..i.."Flag", Window.AnimationType.LOOP, 1.0, 0.2, 0.5, false, 0.0, 0 ) --start the Burning BO pulse
					RoR_SoR.BO_States[Window_Name][i] = 4
				end
				RealmColor = RoR_SoR.CappingRealmColors[SoR_BO_SPLIT_TEXT_STREAM[(4*i)]+1]				
				WindowSetDimensions("SoR_"..Window_Name.."BO"..i.."Flag",31,31)				
			else
				RoR_SoR.BO_States[Window_Name][i] = nil
				RealmColor = RoR_SoR.RealmColors[SoR_BO_SPLIT_TEXT_STREAM[(4*i)]+1]
				WindowStopAlphaAnimation("SoR_"..Window_Name.."BO"..i.."Flag")
			end
			
			LabelSetTextColor("SoR_"..Window_Name.."BO"..i.."TIMER",RealmColor.r,RealmColor.g,RealmColor.b)
			LabelSetText("SoR_"..Window_Name.."BO"..i.."TIMER",L"")		
			DynamicImageSetTexture( "SoR_"..Window_Name.."BO"..i.."Flag", RoR_SoR.GetFlag(BO_Owner,BO_State),31,31 )	
			DynamicImageSetTexture( "SoR_"..Window_Name.."BO"..i.."FlagBG", RoR_SoR.GetFlag2(BO_Owner,BO_State),31,31 )				
			RoR_SoR.BO_States[Window_Name][i] = BO_State
			
			if tonumber(SoR_BO_SPLIT_TEXT_STREAM[2+(4*i)]) > 0 then
				RoR_SoR.Timers[SoR_BO_SPLIT_TEXT_STREAM[2]][i] = tonumber(SoR_BO_SPLIT_TEXT_STREAM[2+(4*i)])			
			--	LabelSetText("SoR_"..Window_Name.."BO"..i.."TIMER",towstring(SoR_BO_SPLIT_TEXT_STREAM[2+(4*i)]))
			end
			if (BO_State == 6) or (BO_State == 9) then Lock_Counter = Lock_Counter+1 end			
		end	
		
		--Zonelock
		if Lock_Counter == 4 then LabelSetText("SoR_"..Window_Name.."LockedText",towstring(GetStringFromTable("Hardcoded", 1268)))end		
			WindowSetShowing("SoR_"..Window_Name.."LockTint",(Lock_Counter==4))
						
		else
			RoR_SoR.Timers[SoR_BO_SPLIT_TEXT_STREAM[2]] = nil
		end	
end

--Hide Keepstuff for T1
function RoR_SoR.T1_UPDATE(Input,TEXT_STREAM)
local Window_Name = tostring(Input)
local TEXT_STREAM = TEXT_STREAM

if TEXT_STREAM[21] ~= nil then
local AAO = StringSplit(tostring(TEXT_STREAM[21]), ",")
			if AAO[2] ~= nil then
			local ClaimColor = RoR_SoR.RealmColors[AAO[1]+1]
			LabelSetTextColor("SoR_"..Window_Name.."AAO",ClaimColor.r,ClaimColor.g,ClaimColor.b)
			LabelSetText("SoR_"..Window_Name.."AAO",towstring(AAO[2])..L"%")	
			WindowSetShowing("SoR_"..Window_Name.."AAO",tonumber(AAO[2])>0) 
			else
			WindowSetShowing("SoR_"..Window_Name.."AAO",false) 
			end
 end

	if DoesWindowExist("SoR_"..Window_Name) then	
		WindowSetShowing("SoR_"..Window_Name.."KEEP1",false)
		WindowSetShowing("SoR_"..Window_Name.."KEEP2",false)	
		WindowSetShowing("SoR_"..Window_Name.."CLAIM_WINDOW1",false)
		WindowSetShowing("SoR_"..Window_Name.."CLAIM_WINDOW2",false)
		RoR_SoR.ZoneTimer[Window_Name] = ZoneLockTimer
	local ZoneVP	
		if Input == "106" then
			WindowSetShowing("SoR_"..Window_Name.."BO4",false) -- Hide the 4:th BO of Nordland
			DynamicImageSetTexture ("SoR_"..Window_Name.."VPBanner", "Realm2", 256,128)
			ZoneVP = GetCampaignZoneData(106 )
		elseif Input == "206" then
			DynamicImageSetTexture ("SoR_"..Window_Name.."VPBanner", "Realm3", 256,128)
			ZoneVP = GetCampaignZoneData(200 ) 			
		else
			DynamicImageSetTexture ("SoR_"..Window_Name.."VPBanner", "Realm1", 256,128)
			ZoneVP = GetCampaignZoneData(6 )	
		end				
--Update the "progressbars" in the zone pairings
local Width_Zone1_Order = ( ( ZoneVP.controlPoints[1] / 100 ) * 147 )
WindowSetDimensions( "SoR_"..Window_Name.."VPORDER", Width_Zone1_Order+2, 4 )
--if ZoneVP.controlPoints[1] > 0 then WindowSetShowing("RoR_SoR_T1WindowRealm1VP_ORDER",true) else WindowSetShowing("RoR_SoR_T1WindowRealm1VP_ORDER",false) end

local Width_Zone1_Destro = ( ( ZoneVP.controlPoints[2] / 100 ) * 147 )
WindowSetDimensions( "SoR_"..Window_Name.."VPDESTRO", Width_Zone1_Destro+2, 4 )
--if Zone1.controlPoints[2] > 0 then WindowSetShowing("RoR_SoR_T1WindowRealm1VP_DESTRO",true) else WindowSetShowing("RoR_SoR_T1WindowRealm1VP_DESTRO",false) end
	
		LabelSetText("SoR_"..Window_Name.."VPPERCENT_ORDER",towstring((ZoneVP.controlPoints[1])*2)..L"%")
		LabelSetText("SoR_"..Window_Name.."VPPERCENT_DESTRO",towstring((ZoneVP.controlPoints[2])*2)..L"%")

	end
end

function RoR_SoR.SET_KEEP(Input)
	local SoR_KEEP_SPLIT_TEXT_STREAM = Input
	local Window_Name = tostring(SoR_KEEP_SPLIT_TEXT_STREAM[2])
	if DoesWindowExist("SoR_"..Window_Name) then	
	--	if SoR_KEEP_SPLIT_TEXT_STREAM[1] ~= "SoR_T2_Keep" then	
			local KEEP1_ID = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[3])
			local KEEP2_ID = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[12])	
			local KEEP1_State = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[6])
			local KEEP1_Owner = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[4])
			local KEEP2_State = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[15])
			local KEEP2_Owner = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[13])			
			local KEEP1_Rank = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[5])			
			local KEEP2_Rank = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[14])	
			
			local KEEP1_Door1 = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[9])			
			local KEEP1_Door2 = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[8])			
			
			local KEEP2_Door1 = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[18])								
			local KEEP2_Door2 = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[17])
			
			local KEEP1_Lord = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[10])								
			local KEEP2_Lord = tonumber(SoR_KEEP_SPLIT_TEXT_STREAM[19])			

			local KEEP1_CLAIM = SoR_KEEP_SPLIT_TEXT_STREAM[11]
			local KEEP2_CLAIM = SoR_KEEP_SPLIT_TEXT_STREAM[20]
		
			RoR_SoR.KEEP_IDs[Window_Name] = {[1]={ID=KEEP1_ID,Owner=KEEP1_Owner,Rank=KEEP1_Rank,State=KEEP1_State,Claim=KEEP1_CLAIM},[2]={ID=KEEP2_ID,Owner=KEEP2_Owner,Rank=KEEP2_Rank,State=KEEP2_State,Claim=KEEP2_CLAIM}}

--Claim button and text		
		local Claimed_Keep_1 = RoR_SoR.GetKeepClaim2(KEEP1_ID)
		local Claimed_Keep_2 = RoR_SoR.GetKeepClaim2(KEEP2_ID)
		
		WindowSetShowing("SoR_"..Window_Name.."CLAIM_WINDOW1BUTTON",Claimed_Keep_1)
		WindowSetShowing("SoR_"..Window_Name.."CLAIM_WINDOW2BUTTON",Claimed_Keep_2)		
		WindowSetShowing("SoR_"..Window_Name.."CLAIM_WINDOW1TEXT",not Claimed_Keep_1)
		WindowSetShowing("SoR_"..Window_Name.."CLAIM_WINDOW2TEXT",not Claimed_Keep_2)		
		
		ButtonSetText("SoR_"..Window_Name.."CLAIM_WINDOW1BUTTON",L"CLAIM KEEP")
		ButtonSetText("SoR_"..Window_Name.."CLAIM_WINDOW2BUTTON",L"CLAIM KEEP")		
			
--Calculate and show AAO		
			local AAO = StringSplit(tostring(SoR_KEEP_SPLIT_TEXT_STREAM[21]), ",")

			for k,v in pairs(RoR_SoR.TierNames[4]) do
				if tostring(v) == tostring(Window_Name) then
					AAO = StringSplit(tostring(SoR_KEEP_SPLIT_TEXT_STREAM[22]), ",")
					break
				end
			end
			
			if AAO[2] ~= nil then
			local ClaimColor = RoR_SoR.RealmColors[AAO[1]+1]
			LabelSetTextColor("SoR_"..Window_Name.."AAO",ClaimColor.r,ClaimColor.g,ClaimColor.b)
			LabelSetText("SoR_"..Window_Name.."AAO",towstring(AAO[2])..L"%")	
			WindowSetShowing("SoR_"..Window_Name.."AAO",tonumber(AAO[2])>0) -- Hide T1 Stuff
			else
			WindowSetShowing("SoR_"..Window_Name.."AAO",false) -- Hide T1 Stuff
			end
			
			WindowSetShowing("SoR_"..Window_Name.."VP",false) -- Hide T1 Stuff
WindowSetShowing("SoR_"..Window_Name.."CLAIM_WINDOW1TEXTPROXY",false)
WindowSetShowing("SoR_"..Window_Name.."CLAIM_WINDOW2TEXTPROXY",false)			
			DynamicImageSetTexture( "SoR_"..Window_Name.."KEEP1KEEPICON", RoR_SoR.GetKeepTexture(KEEP1_Owner,KEEP1_State),42,42 )	
			DynamicImageSetTexture( "SoR_"..Window_Name.."KEEP2KEEPICON", RoR_SoR.GetKeepTexture(KEEP2_Owner,KEEP2_State),42,42 )

			DynamicImageSetTexture( "SoR_"..Window_Name.."KEEP1LORD_ICON", RoR_SoR.KeepLord[KEEP1_Owner],22,22 )	
			DynamicImageSetTexture( "SoR_"..Window_Name.."KEEP2LORD_ICON", RoR_SoR.KeepLord[KEEP2_Owner],22,22 )			
--			DynamicImageSetTextureSlice( "SoR_"..Window_Name.."KEEP1LORD_ICON", RoR_SoR.KeepLord[KEEP1_Owner] )
--			DynamicImageSetTextureSlice( "SoR_"..Window_Name.."KEEP2LORD_ICON", RoR_SoR.KeepLord[KEEP2_Owner] )			
			

--Check if keeps are claimed and do the keep branding
if KEEP1_CLAIM ~= "0" then
local ClaimColor = RoR_SoR.RealmColors[KEEP1_Owner+1]
LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW1TEXTPROXY",L"<"..towstring(KEEP1_CLAIM)..L">")
local Width,Height = LabelGetTextDimensions("SoR_"..Window_Name.."CLAIM_WINDOW1TEXTPROXY")
if Width < 130 then
LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW1TEXT",L"<"..towstring(KEEP1_CLAIM)..L">")
else
local ShortGName = wstring.match(wstring.gsub(wstring.gsub(wstring.gsub(towstring(KEEP1_CLAIM),L" of ", L"O"), L"%s",L""), L"%l*", L""), L"([^^]+)^?.*")  --This is for Shortening Guildnames
LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW1TEXT",L"<"..towstring(ShortGName)..L">")
end

LabelSetTextColor("SoR_"..Window_Name.."CLAIM_WINDOW1TEXT",ClaimColor.r,ClaimColor.g,ClaimColor.b)
WindowSetShowing("SoR_"..Window_Name.."KEEP1KEEPGLOW",true)
else
local ClaimColor = RoR_SoR.RealmColors[1]
LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW1TEXT",L"Unclaimed")
LabelSetTextColor("SoR_"..Window_Name.."CLAIM_WINDOW1TEXT",ClaimColor.r,ClaimColor.g,ClaimColor.b)
WindowSetShowing("SoR_"..Window_Name.."KEEP1KEEPGLOW",false)
end

if KEEP2_CLAIM ~= "0" then
local ClaimColor = RoR_SoR.RealmColors[KEEP2_Owner+1]
LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW2TEXTPROXY",L"<"..towstring(KEEP2_CLAIM)..L">")
local Width,Height = LabelGetTextDimensions("SoR_"..Window_Name.."CLAIM_WINDOW2TEXTPROXY")
if Width < 130 then
LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW2TEXT",L"<"..towstring(KEEP2_CLAIM)..L">")
else
local ShortGName = wstring.match(wstring.gsub(wstring.gsub(wstring.gsub(towstring(KEEP2_CLAIM),L" of ", L"O"), L"%s",L""), L"%l*", L""), L"([^^]+)^?.*")  --This is for Shortening Guildnames
LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW2TEXT",L"<"..towstring(ShortGName)..L">")
end

LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW2TEXT",L"<"..towstring(KEEP2_CLAIM)..L">")
LabelSetTextColor("SoR_"..Window_Name.."CLAIM_WINDOW2TEXT",ClaimColor.r,ClaimColor.g,ClaimColor.b)
WindowSetShowing("SoR_"..Window_Name.."KEEP2KEEPGLOW",true)
else
local ClaimColor = RoR_SoR.RealmColors[1]
LabelSetText("SoR_"..Window_Name.."CLAIM_WINDOW2TEXT",L"Unclaimed")
LabelSetTextColor("SoR_"..Window_Name.."CLAIM_WINDOW2TEXT",ClaimColor.r,ClaimColor.g,ClaimColor.b)
WindowSetShowing("SoR_"..Window_Name.."KEEP2KEEPGLOW",false)
end

			WindowSetShowing("SoR_"..Window_Name.."KEEP1LORD_ICON",(KEEP1_State == 4))
			WindowSetShowing("SoR_"..Window_Name.."KEEP2LORD_ICON",(KEEP2_State == 4))	

	--Set the different Keep states
	--KEEP 1
local LabelText = L""	
	if KEEP1_State == 1	then	--Safe
	LabelSetText("SoR_"..Window_Name.."KEEP1HEALTH",L"")
	WindowStopAlphaAnimation( "SoR_"..Window_Name.."KEEP1KEEPDOOR1")
	WindowStopAlphaAnimation( "SoR_"..Window_Name.."KEEP1KEEPDOOR2")
	WindowStopAlphaAnimation( "SoR_"..Window_Name.."KEEP1LORD_ICON")
	RoR_SoR.KEEP_States[Window_Name][1] = 1	
	elseif KEEP1_State == 2	then	--OuterDoor attacked
		if KEEP1_Door2 > 0 then LabelText = towstring(KEEP1_Door2)..L"%" else LabelText = L"" end
		if RoR_SoR.KEEP_States[Window_Name][1] ~= 2 then
			RoR_SoR.KEEP_States[Window_Name][1] = 2		
			WindowStartAlphaAnimation( "SoR_"..Window_Name.."KEEP1KEEPDOOR2", Window.AnimationType.LOOP, 1.0, 0.1, 0.5, false, 0.0, 0 ) --start the Door2 pulse
		end
		LabelSetText("SoR_"..Window_Name.."KEEP1HEALTH",LabelText)
	elseif KEEP1_State == 3	then	--InnerDoor attacked
		if KEEP1_Door1 > 0 then LabelText = towstring(KEEP1_Door1)..L"%" else LabelText = L"" end	
		if RoR_SoR.KEEP_States[Window_Name][1] ~= 3 then
			RoR_SoR.KEEP_States[Window_Name][1] = 3		
			WindowStartAlphaAnimation( "SoR_"..Window_Name.."KEEP1KEEPDOOR1", Window.AnimationType.LOOP, 1.0, 0.1, 0.5, false, 0.0, 0 ) --start the Door1 pulse
		end	
		LabelSetText("SoR_"..Window_Name.."KEEP1HEALTH",LabelText)		
	elseif KEEP1_State == 4 then	--Lord Attacked			
	LabelSetText("SoR_"..Window_Name.."KEEP1HEALTH",towstring(KEEP1_Lord)..L"%")
		if RoR_SoR.KEEP_States[Window_Name][1] ~= 4 then
			RoR_SoR.KEEP_States[Window_Name][1] = 4	
			WindowStartAlphaAnimation( "SoR_"..Window_Name.."KEEP1LORD_ICON", Window.AnimationType.LOOP, 1.0, 0.2, 0.5, false, 0.0, 0 ) --start the Lord pulse			
		end
	elseif KEEP1_State == 5	then	--Captured
		RoR_SoR.KEEP_States[Window_Name][1] = 5	
		LabelSetText("SoR_"..Window_Name.."KEEP1HEALTH",L"Captured")
	elseif KEEP1_State == 6	then	--Locked
		RoR_SoR.KEEP_States[Window_Name][1] = 6
		LabelSetText("SoR_"..Window_Name.."KEEP1HEALTH",L"Locked")	
	end					
	--KEEP 2
	if KEEP2_State == 1	then	--Safe
	LabelSetText("SoR_"..Window_Name.."KEEP2HEALTH",L"")
	WindowStopAlphaAnimation( "SoR_"..Window_Name.."KEEP2KEEPDOOR1")
	WindowStopAlphaAnimation( "SoR_"..Window_Name.."KEEP2KEEPDOOR2")
	WindowStopAlphaAnimation( "SoR_"..Window_Name.."KEEP2LORD_ICON")
	RoR_SoR.KEEP_States[Window_Name][2] = 1	
	elseif KEEP2_State == 2	then	--OuterDoor attacked
		if KEEP2_Door2 > 0 then LabelText = towstring(KEEP2_Door2)..L"%" else LabelText = L"" end
		if RoR_SoR.KEEP_States[Window_Name][2] ~= 2 then
			RoR_SoR.KEEP_States[Window_Name][2] = 2		
			WindowStartAlphaAnimation( "SoR_"..Window_Name.."KEEP2KEEPDOOR2", Window.AnimationType.LOOP, 1.0, 0.1, 0.5, false, 0.0, 0 ) --start the Door2 pulse
		end
		LabelSetText("SoR_"..Window_Name.."KEEP2HEALTH",LabelText)	
	elseif KEEP2_State == 3	then	--InnerDoor attacked
		if KEEP2_Door1 > 0 then LabelText = towstring(KEEP2_Door1)..L"%" else LabelText = L"" end
		if RoR_SoR.KEEP_States[Window_Name][2] ~= 3 then
			RoR_SoR.KEEP_States[Window_Name][2] = 3		
			WindowStartAlphaAnimation( "SoR_"..Window_Name.."KEEP2KEEPDOOR1", Window.AnimationType.LOOP, 1.0, 0.1, 0.5, false, 0.0, 0 ) --start the Door1 pulse
		end	
		LabelSetText("SoR_"..Window_Name.."KEEP2HEALTH",LabelText)		
	elseif KEEP2_State == 4 then	--Lord Attacked			
	LabelSetText("SoR_"..Window_Name.."KEEP2HEALTH",towstring(KEEP2_Lord)..L"%")
		if RoR_SoR.KEEP_States[Window_Name][2] ~= 4 then
			RoR_SoR.KEEP_States[Window_Name][2] = 4	
			WindowStartAlphaAnimation( "SoR_"..Window_Name.."KEEP2LORD_ICON", Window.AnimationType.LOOP, 1.0, 0.2, 0.5, false, 0.0, 0 ) --start the Lord pulse			
		end
	elseif KEEP2_State == 5	then	--Captured
		RoR_SoR.KEEP_States[Window_Name][2] = 5
		LabelSetText("SoR_"..Window_Name.."KEEP2HEALTH",L"Captured")
	elseif KEEP2_State == 6	then	--Locked
		RoR_SoR.KEEP_States[Window_Name][2] = 6
		LabelSetText("SoR_"..Window_Name.."KEEP2HEALTH",L"Locked")	
	end					
		
			
			if KEEP1_Rank > 0 then
				DynamicImageSetTextureSlice("SoR_"..Window_Name.."KEEP1KEEPRANK", "KeepDifficulty-"..KEEP1_Rank.."-star" )
			else
				DynamicImageSetTextureSlice("SoR_"..Window_Name.."KEEP1KEEPRANK", "KeepDifficulty-1-star" )
			end
			
			if KEEP2_Rank > 0 then
				DynamicImageSetTextureSlice("SoR_"..Window_Name.."KEEP2KEEPRANK", "KeepDifficulty-"..KEEP2_Rank.."-star" )
			else
				DynamicImageSetTextureSlice("SoR_"..Window_Name.."KEEP2KEEPRANK", "KeepDifficulty-1-star" )
			end
			WindowSetShowing("SoR_"..Window_Name.."KEEP1KEEPRANK",KEEP1_Rank>0)
			WindowSetShowing("SoR_"..Window_Name.."KEEP2KEEPRANK",KEEP2_Rank>0)

			WindowSetShowing("SoR_"..Window_Name.."KEEP1KEEPDOOR1",KEEP1_Door1>0)
			WindowSetShowing("SoR_"..Window_Name.."KEEP1KEEPDOOR2",KEEP1_Door2>0)			
			
			WindowSetShowing("SoR_"..Window_Name.."KEEP2KEEPDOOR1",KEEP2_Door1>0)			
			WindowSetShowing("SoR_"..Window_Name.."KEEP2KEEPDOOR2",KEEP2_Door2>0)	

			if KEEP1_Door2>0 then
				WindowClearAnchors("SoR_"..Window_Name.."KEEP1KEEPDOOR1")
				WindowAddAnchor( "SoR_"..Window_Name.."KEEP1KEEPDOOR1", "topleft", "SoR_"..Window_Name.."KEEP1", "topleft",10,28 )					
			else
				WindowClearAnchors("SoR_"..Window_Name.."KEEP1KEEPDOOR1")
				WindowAddAnchor( "SoR_"..Window_Name.."KEEP1KEEPDOOR1", "topleft", "SoR_"..Window_Name.."KEEP1", "topleft",20,28 )
			end
			
			
			if KEEP2_Door2>0 then
				WindowClearAnchors("SoR_"..Window_Name.."KEEP2KEEPDOOR1")
				WindowAddAnchor( "SoR_"..Window_Name.."KEEP2KEEPDOOR1", "topleft", "SoR_"..Window_Name.."KEEP2", "topleft",10,28 )					
			else
				WindowClearAnchors("SoR_"..Window_Name.."KEEP2KEEPDOOR1")
				WindowAddAnchor( "SoR_"..Window_Name.."KEEP2KEEPDOOR1", "topleft", "SoR_"..Window_Name.."KEEP2", "topleft",20,28 )
			end
				
	end	
end

function RoR_SoR.OnMouseOverStart()
	local WinParent = WindowGetParent(SystemData.MouseOverWindow.name)
	local WindowName = tostring(SystemData.MouseOverWindow.name)

	local Line1,Line2,Line3 = L"",L"",L""
	local Owner,State = nil,nil
	
if WindowName:match("SoR_+[^%.]+BO.") then
	local BoId = string.match( WindowName,"SoR_(%d+)BO.")
	local Number = string.match( WindowName,"BO(%d+)")	
	local Final = RoR_SoR.BO_IDs[tostring(BoId)][tonumber(Number)].ID
	Owner = RoR_SoR.BO_IDs[tostring(BoId)][tonumber(Number)].Owner
	State = RoR_SoR.BO_States[tostring(BoId)][tonumber(Number)]
	

Line1 = towstring(GetObjectiveName(tonumber(Final)))
if (RoR_SoR.Timers[tostring(BoId)][tonumber(Number)] ~= nil) and (RoR_SoR.Timers[tostring(BoId)][tonumber(Number)] > 0) then Line2 = L"<icon29979>"..towstring(TimeUtils.FormatClock(RoR_SoR.Timers[tostring(BoId)][tonumber(Number)])) else Line2 = L"" end
Line3 =RoR_SoR.GetTooltipIcon(Owner,State)

elseif WindowName:match("SoR_+[^%.]+KEEP.") then
	local KeepId = string.match( WindowName,"SoR_(%d+)KEEP.")
	local Number = string.match( WindowName,"KEEP(%d+)")
	local KEEP_DATA = RoR_SoR.KEEP_IDs[tostring(KeepId)][tonumber(Number)]
	
	local Final = KEEP_DATA.ID
	Owner = KEEP_DATA.Owner
	State = KEEP_DATA.State
	
Line1 = towstring(GetKeepName(tonumber(Final)))
Line2 = RoR_SoR.GetKeepRank(KEEP_DATA.Rank)
Line3 =RoR_SoR.GetKeepIcon(Owner,State)	
d("Keep")
end	
		Tooltips.CreateTextOnlyTooltip(SystemData.MouseOverWindow.name,nil)
		Tooltips.SetTooltipText( 1, 1, Line1)
		Tooltips.SetTooltipColorDef( 1, 1, Tooltips.MAP_DESC_TEXT_COLOR )
	--	Tooltips.SetTooltipText( 2, 1, towstring(Line3))	
			if Line2 ~= L""	then 
				Tooltips.SetTooltipText( 2, 1,towstring(Line3))
				Tooltips.SetTooltipText( 2, 3,towstring(Line2)) 				
			else 
				Tooltips.SetTooltipText( 2, 1,towstring(Line3)) 
			end			
		Tooltips.SetTooltipColorDef( 2, 1, RoR_SoR.RealmColors[Owner+1] )
		Tooltips.Finalize()    
		Tooltips.AnchorTooltip( Tooltips.ANCHOR_WINDOW_TOP )
	
end

function RoR_SoR.TIMER_UPDATE(elapsedTime)
if RoR_SoR.Timers ~= nil then
	for k,v in pairs(RoR_SoR.Timers) do
		if v ~= nil then
			for a,b in pairs(v) do
--			k - Area id , v - bonumber, a-bonumber, b-value
			RoR_SoR.Timers[tostring(k)][a] = b-elapsedTime
			
				if DoesWindowExist("SoR_"..k) then	
					if RoR_SoR.Fort[tostring(k)] == nil then
						LabelSetText("SoR_"..k.."BO"..a.."TIMER",towstring(towstring(TimeUtils.FormatClock(RoR_SoR.Timers[tostring(k)][a]))))
						if RoR_SoR.BO_States[k][a] ~= 4 then
							local Builer = 31 - (tonumber(RoR_SoR.Timers[tostring(k)][a])/1.34)
							if (Builer >= 0) and (RoR_SoR.Timers[tostring(k)][a] >= 0) then
								WindowSetDimensions("SoR_"..k.."BO"..a.."Flag",31,Builer)
							else
								WindowSetDimensions("SoR_"..k.."BO"..a.."Flag",31,31)
							end
						end	
					else
						LabelSetText("SoR_"..k.."_TIMER",towstring(towstring(TimeUtils.FormatClock(RoR_SoR.Timers[tostring(k)][a]))))
					end
				end
			end
		end		
	WindowSetAlpha("SoR_"..k.."Background2",WindowGetAlpha("RoR_SoR_Main_Window"))
	end
	
	
	
	if (Popper.m_HideCountdown > 0)
    then
        Popper.m_HideCountdown = Popper.m_HideCountdown - elapsedTime
					
        if (Popper.m_HideCountdown <= 0)
        then
            local windowName        = SystemData.MouseOverWindow.name
            local overSidebarOrChild = false
            while (windowName ~= "Root")
            do
                if (windowName:find("SoR_") or WindowGetParent (windowName) == "RoR_SoR_Main_Window")
                then
                    overSidebarOrChild = true	
						RoR_SoR.ShowPopper()
                    break
                end
                					
                windowName = WindowGetParent (windowName)
            end
            
            if (overSidebarOrChild == false)
            then
                RoR_SoR.HidePopper ()
            else
                Popper.m_HideCountdown = c_DEFAULT_HIDE_TIMER
            end
        end
    end
	
end	

if RoR_SoR.ZoneTimer ~= nil then
	for k,v in pairs(RoR_SoR.ZoneTimer) do
		if DoesWindowExist("SoR_"..k) then
			if v > 0 then 
			RoR_SoR.ZoneTimer[k] = RoR_SoR.ZoneTimer[k] - elapsedTime 
			else
			RoR_SoR.RemoveWindow(k)			
			end
			--d(L"Key: "..towstring(k)..L" , Value: "..towstring(v))
		end
	end
end


if RoR_Window_Scale ~= WindowGetScale("RoR_SoR_Main_Window") then
RoR_SoR.OnSizeUpdated()
RoR_Window_Scale = WindowGetScale("RoR_SoR_Main_Window")
end

end

function RoR_SoR.OnSizeUpdated()
RoR_SoR.Restack()
return		
end

function RoR_SoR.RemoveWindow(Number)
	if Number == nil then return end
	if DoesWindowExist("SoR_"..Number) then
		DestroyWindow("SoR_"..Number)
		
		RoR_SoR.OpenZones[Number] = nil
		RoR_SoR.BO_States[Number] = nil
		RoR_SoR.KEEP_States[Number] = nil
		RoR_SoR.ZoneTimer[Number] = nil
		RoR_SoR.BO_IDs[Number] = nil
		RoR_SoR.KEEP_IDs[Number] = nil
		RoR_SoR.Timers[tostring(Number)] = nil
		RoR_SoR.Restack()
	end
	return
end

function RoR_SoR.ClearTier(Number)
local Number = Number
if RoR_SoR.StackSort == nil then return end
		for k,v in ipairs(RoR_SoR.StackSort) do
			if Number == 1 then
				if v.Tier == 1 then
				RoR_SoR.RemoveWindow(v.Zone)
				end
			else
				if v.Tier ~= 1 then
				RoR_SoR.RemoveWindow(v.Zone)
				end
			end
		end
end

function RoR_SoR.GetFlag(BO_OWNER,BO_STATE)
	local Owner = tonumber(BO_OWNER)
	local State = tonumber(BO_STATE)

	if State == 0 then
		if Owner == 0 then return "SoR_Neutral" end
		if Owner == 1 then return "SoR_Order" end
		if Owner == 2 then return "SoR_Destro" end
	elseif State == 4 then
		if Owner == 0 then return "SoR_Neutral-Burning" end
		if Owner == 1 then return "SoR_Order-Burning" end
		if Owner == 2 then return "SoR_Destro-Burning" end
	elseif State == 8 then
		if Owner == 0 then return "SoR_Neutral-Locked" end
		if Owner == 1 then return "SoR_Order-Locked" end
		if Owner == 2 then return "SoR_Destro-Locked" end
	elseif State == 9 then
		if Owner == 0 then return "SoR_Neutral-Locked" end
		if Owner == 1 then return "SoR_Order-Locked" end
		if Owner == 2 then return "SoR_Destro-Locked" end	
	elseif State == 10 then
		if Owner == 0 then return "SoR_Neutral" end
		if Owner == 1 then return "SoR_Order-Locked" end
		if Owner == 2 then return "SoR_Destro-Locked" end		
	elseif State == 16 then
		if Owner == 0 then return "SoR_Neutral-Glowing" end
		if Owner == 1 then return "SoR_Order-Glowing" end
		if Owner == 2 then return "SoR_Destro-Glowing" end
	else
		if Owner == 0 then return "SoR_Neutral" end
		if Owner == 1 then return "SoR_Order" end
		if Owner == 2 then return "SoR_Destro" end
	end

end

function RoR_SoR.GetFlag2(BO_OWNER,BO_STATE)
	local Owner = tonumber(BO_OWNER)
	local State = tonumber(BO_STATE)

	if State == 0 then
		if Owner == 0 then return "SoR_Neutral" end
		if Owner == 1 then return "SoR_Order" end
		if Owner == 2 then return "SoR_Destro" end
	elseif State == 4 then
		if Owner == 0 then return "" end
		if Owner == 1 then return "" end
		if Owner == 2 then return "" end
	elseif State == 8 then
		if Owner == 0 then return "SoR_Neutral-Locked" end
		if Owner == 1 then return "SoR_Order-Locked" end
		if Owner == 2 then return "SoR_Destro-Locked" end
	elseif State == 9 then
		if Owner == 0 then return "SoR_Neutral-Locked" end
		if Owner == 1 then return "SoR_Order-Locked" end
		if Owner == 2 then return "SoR_Destro-Locked" end	
	elseif State == 10 then
		if Owner == 0 then return "SoR_Neutral" end
		if Owner == 1 then return "SoR_Order-Locked" end
		if Owner == 2 then return "SoR_Destro-Locked" end		
	elseif State == 16 then
		if Owner == 0 then return "SoR_Neutral-Glowing" end
		if Owner == 1 then return "SoR_Order" end
		if Owner == 2 then return "SoR_Destro" end
	else
		if Owner == 0 then return "SoR_Neutral" end
		if Owner == 1 then return "SoR_Order" end
		if Owner == 2 then return "SoR_Destro" end
	end

end

function RoR_SoR.GetKeepTexture(KEEP_OWNER,KEEP_STATE)
	local Owner = tonumber(KEEP_OWNER)
	local State = tonumber(KEEP_STATE)

	if State == 1 then
		if Owner == 0 then return "SoR_Keep_Neutral" end
		if Owner == 1 then return "SoR_Keep_Order" end
		if Owner == 2 then return "SoR_Keep_Destro" end
	elseif State == 2 then
		if Owner == 0 then return "FlagNeutral-Burning" end
		if Owner == 1 then return "SoR_Keep_Order-Attacked" end
		if Owner == 2 then return "SoR_Keep_Destro-Attacked" end
	elseif State == 3 then
		if Owner == 0 then return "FlagNeutral-Burning" end
		if Owner == 1 then return "SoR_Keep_Order-Attacked" end
		if Owner == 2 then return "SoR_Keep_Destro-Attacked" end	
	elseif State == 4 then
		if Owner == 0 then return "BombNeutral" end
		if Owner == 1 then return "SoR_Keep_Order-Attacked" end
		if Owner == 2 then return "SoR_Keep_Destro-Attacked" end
	elseif State == 5 then
		if Owner == 0 then return "FlagNeutral-Burning" end
		if Owner == 1 then return "SoR_Keep_Order" end
		if Owner == 2 then return "SoR_Keep_Destro" end
	elseif State == 6 then
		if Owner == 0 then return "FlagNeutral-Burning" end
		if Owner == 1 then return "SoR_Keep_Order" end
		if Owner == 2 then return "SoR_Keep_Destro" end
	else
		if Owner == 0 then return "SoR_Keep_Neutral" end
		if Owner == 1 then return "SoR_Keep_Order" end
		if Owner == 2 then return "SoR_Keep_Destro" end
	end
end

function RoR_SoR.GetTooltipIcon(BO_OWNER,BO_STATE)
local Owner = tonumber(BO_OWNER)
local State = tonumber(BO_STATE)

if State == 0 then
	if Owner == 0 then return L"<icon29982> "..towstring(RoR_SoR.TextNeutral) end --neutral
	if Owner == 1 then return L"<icon29990> "..towstring(RoR_SoR.TextDestro) end
	if Owner == 2 then return L"<icon29985> "..towstring(RoR_SoR.TextOrder) end
elseif State == 2 then
	if Owner == 0 then return L"<icon29982> Abandoned" end
	if Owner == 1 then return L"<icon29990> Order Abandoned" end
	if Owner == 2 then return L"<icon29985> Destro Abandoned" end		
elseif State == 4 then
	if Owner == 0 then return L"<icon29984> Capping" end
	if Owner == 1 then return L"<icon29992> Destro Capping" end
	if Owner == 2 then return L"<icon29987> Order Capping" end
elseif State == 8 then
	if Owner == 0 then return L"<icon29983> Unlocking" end
	if Owner == 1 then return L"<icon29991> Order "..towstring(RoR_SoR.TextLock) end
	if Owner == 2 then return L"<icon29986> Destro "..towstring(RoR_SoR.TextLock) end
elseif State == 9 then
	if Owner == 0 then return L"<icon29983> "..towstring(RoR_SoR.TextLock) end
	if Owner == 1 then return L"<icon29991> Order "..towstring(RoR_SoR.TextLock) end
	if Owner == 2 then return L"<icon29986> Destro "..towstring(RoR_SoR.TextLock) end	
elseif State == 10 then
	if Owner == 0 then return L"<icon29982> Neutral "..towstring(RoR_SoR.TextLock) end--neutral
	if Owner == 1 then return L"<icon29991> Order "..towstring(RoR_SoR.TextLock) end
	if Owner == 2 then return L"<icon29986> Destro "..towstring(RoR_SoR.TextLock) end		
elseif State == 16 then
	if Owner == 0 then return L"<icon29982> Securing" end
	if Owner == 1 then return L"<icon29993> Order securing" end -- securing / holding
	if Owner == 2 then return L"<icon29988> Destro securing" end
else
	if Owner == 0 then return L"<icon29982> Neutral" end--neutral
	if Owner == 1 then return L"<icon29990> Order" end
	if Owner == 2 then return L"<icon29985> Destro" end
end

end

function RoR_SoR.GetKeepIcon(KEEP_OWNER,KEEP_STATE)
local Owner = tonumber(KEEP_OWNER)
local State = tonumber(KEEP_STATE)

if State == 1 then
	if Owner == 0 then return L"<icon29995> Neutral Keep" end
	if Owner == 1 then return L"<icon29998> Order Keep" end
	if Owner == 2 then return L"<icon29996> Destro Keep" end
elseif State == 2 then
	if Owner == 0 then return L"<icon29995> Under Attack" end
	if Owner == 1 then return L"<icon29999> Under Attack" end
	if Owner == 2 then return L"<icon29997> Under Attack" end
elseif State == 3 then
	if Owner == 0 then return L"<icon29995> Under Attack" end
	if Owner == 1 then return L"<icon29999> Under Attack" end
	if Owner == 2 then return L"<icon29997> Under Attack" end	
elseif State == 4 then
	if Owner == 0 then return L"<icon29995> Under Attack" end
	if Owner == 1 then return L"<icon29999> Under Attack" end
	if Owner == 2 then return L"<icon29997> Under Attack" end
elseif State == 5 then
	if Owner == 0 then return L"<icon29995> Neutral Keep" end
	if Owner == 1 then return L"<icon29998> Order Keep" end
	if Owner == 2 then return L"<icon29996> Destro Keep" end
elseif State == 6 then
	if Owner == 0 then return L"<icon29995> Neutral Keep" end
	if Owner == 1 then return L"<icon29998> Order Keep" end
	if Owner == 2 then return L"<icon29996> Destro Keep" end
else
	if Owner == 0 then return L"<icon29995> Neutral Keep" end
	if Owner == 1 then return L"<icon29998> Order Keep" end
	if Owner == 2 then return L"<icon29996> Destro Keep" end
end
end


function RoR_SoR.GetKeepRank(KeepRank)
local Rank = tonumber(KeepRank)

if Rank == 1 then return L"1 <icon43>"
elseif Rank == 2 then return L"2 <icon43><icon43>"
elseif Rank == 3 then return L"3 <icon43><icon43><icon43>"
elseif Rank == 4 then return L"4 <icon43><icon43><icon43><icon43>"
elseif Rank == 5 then return L"5 <icon43><icon43><icon43><icon43><icon43>"
else return L""

end
end


function RoR_SoR.Toggle()
WindowSetShowing("RoR_SoR_Main_Window",not WindowGetShowing("RoR_SoR_Main_Window"))
WindowSetShowing("RoR_SoR_Popper",WindowGetShowing("RoR_SoR_Main_Window"))
	for k,v in pairs(RoR_SoR.Timers) do
	WindowSetShowing("SoR_"..k,WindowGetShowing("RoR_SoR_Main_Window"))	
	end
RoR_SoR.Enable()	
end

function RoR_SoR.OnTabRBU()
local function MakeCallBack( SelectedOption )
		    return function() RoR_SoR.ToggleShow(SelectedOption) end
		end

  EA_Window_ContextMenu.CreateContextMenu( SystemData.MouseOverWindow.name, EA_Window_ContextMenu.CONTEXT_MENU_1,L"SoR Options")
  EA_Window_ContextMenu.AddMenuDivider( EA_Window_ContextMenu.CONTEXT_MENU_1 )	
  if RoR_SoR.Settings.ShowT1 == true then
  EA_Window_ContextMenu.AddMenuItem( L"<icon00057> Tier 1" , MakeCallBack(1), false, true )
  else
   EA_Window_ContextMenu.AddMenuItem( L"<icon00058> Tier 1" , MakeCallBack(1), false, true )
 end
 
  if RoR_SoR.Settings.ShowT4 == true then
  EA_Window_ContextMenu.AddMenuItem( L"<icon00057> Tier 4" , MakeCallBack(2), false, true )
  else
   EA_Window_ContextMenu.AddMenuItem( L"<icon00058> Tier 4" ,MakeCallBack(2), false, true )
 end
 
 	if RoR_SoR.Settings.StackDir == 1 then
	  EA_Window_ContextMenu.AddMenuItem( L"Set Stack up" , MakeCallBack(3), false, true )
  else
   EA_Window_ContextMenu.AddMenuItem( L"Set Stack down" ,MakeCallBack(4), false, true )
 end
 EA_Window_ContextMenu.AddMenuItem( GetString( StringTables.Default.LABEL_SET_OPACITY ), EA_Window_ContextMenu.OnWindowOptionsSetAlpha, false, true )
 EA_Window_ContextMenu.Finalize()	
end

function RoR_SoR.ToggleShow(SelectedOption)
	if SelectedOption == 1 then RoR_SoR.Settings.ShowT1 = not RoR_SoR.Settings.ShowT1 ; RoR_SoR.ClearTier(1)
	elseif SelectedOption == 2 then RoR_SoR.Settings.ShowT4 = not RoR_SoR.Settings.ShowT4  ; RoR_SoR.ClearTier(2)
	elseif SelectedOption == 3 then RoR_SoR.Settings.StackDir = 2
	elseif SelectedOption == 4 then RoR_SoR.Settings.StackDir = 1
	end
	RoR_SoR.Enable()
	RoR_SoR.Restack()
	
	return
end

function RoR_SoR.ShowPopper ()
	if WindowGetAlpha("RoR_SoR_Popper") < 1 then
		WindowStartAlphaAnimation("RoR_SoR_Popper", Window.AnimationType.SINGLE_NO_RESET, WindowGetAlpha("RoR_SoR_Popper"), 1, c_DEFAULT_FADEIN_TIMER, false, 0, 0)
	end	
    WindowSetShowing ("RoR_SoR_Popper", true)
    Popper.m_IsShowing      = true
    Popper.m_HideCountdown  = c_DEFAULT_HIDE_TIMER
return
end

function RoR_SoR.HidePopper ()
	if WindowGetAlpha("RoR_SoR_Popper") > 0 then
		WindowStartAlphaAnimation("RoR_SoR_Popper", Window.AnimationType.SINGLE_NO_RESET_HIDE, WindowGetAlpha("RoR_SoR_Popper"), 0, c_DEFAULT_FADEOUT_TIMER, false, 0, 0)	
	end
    Popper.m_IsShowing      = false;
    Popper.m_HideCountdown  = c_DEFAULT_HIDE_TIMER
end

function RoR_SoR.HideChannel(channelId)
	for _, wndGroup in ipairs(EA_ChatWindowGroups) do 
		if wndGroup.used == true then
			for tabId, tab in ipairs(wndGroup.Tabs) do
				local tabName = EA_ChatTabManager.GetTabName( tab.tabManagerId )		
				if tabName then
					if tab.tabText ~= L"Debug" then
						LogDisplaySetFilterState(tabName.."TextLog", "Chat", channelId, false)
					else
						LogDisplaySetFilterState(tabName.."TextLog", "Chat", channelId, true)
						LogDisplaySetFilterColor(tabName.."TextLog", "Chat", channelId, 168, 187, 160 )
					end
				end			
			end			
		end		
	end	
end


function RoR_SoR.GetKeepClaim2(KeepId)
local Zone
local Keep_Number
if RoR_SoR.ZoneNames[GameData.Player.zone] == nil then
--d("Player Zone")
Zone = GameData.Player.zone
else
--d("Zone name")
Zone = RoR_SoR.ZoneNames[GameData.Player.zone][1]
end


if not DoesWindowExist("SoR_"..Zone) then return false end
--d("Window Exist")

if RoR_SoR.KEEP_IDs[tostring(Zone)] ~= nil then
	for i=1,2 do
		if KeepId == RoR_SoR.KEEP_IDs[tostring(Zone)][i].ID then
			Keep_Number = i
			break
		end
	end


if RoR_SoR.KEEP_IDs[tostring(Zone)][Keep_Number] == nil then return false end
--d("Keep Id exist")

local ObjectData = GetActiveObjectivesData()
local Keep_Data = RoR_SoR.KEEP_IDs[tostring(Zone)][Keep_Number]
--if Keep_Data.ID == nil then return false end

local KEEP_ID,KEEP_CLAIM,KEEP_OWNER,KEEP_STATE = nil,nil,nil,nil
						
	if ObjectData ~= nil and ObjectData[1] ~= nil then
	--d(L"Is Keep Claimed? "..towstring(RoR_SoR_T2.KeepClaim[T2ComboZone[GameData.Player.zone]][KEEP_ID]))
		if ObjectData[1].isKeep then 
--d("in a keep")		
							--search what ID the keep has
					if tostring(GetKeepName(tonumber(KeepId))) == tostring(ObjectData[1].name) then
						KEEP_ID = Keep_Data.ID
						KEEP_CLAIM = Keep_Data.Claim
						KEEP_OWNER = Keep_Data.Owner
						KEEP_STATE = Keep_Data.State
--d(L"Keep ID: "..towstring(KEEP_ID))						
					else
					return false
					end	
			if KEEP_CLAIM == "0" then
		--	d("Unclaimed")
				if (tonumber(ObjectData[1].controllingRealm) == tonumber(GameData.Player.realm)) then
		--		d("Your Realm Keep")
					if KEEP_STATE == 1 then
				--	d("Safe")
						if GuildWindowTabAdmin.GetGuildCommandPermission(SystemData.GuildPermissons.CLAIM_KEEP, GuildWindowTabAdmin.GetLocalMemberTitleNumber()) then
				--		d("Have Claim Rights")						
						return true
						else
				--		d("NO Claim Rights")
						return false
						end
					else
				--	d("Unsafe")
					return false
					end
				else
			--	d("Enemy keep")	
				return false				
				end
			else
			--d("Claimed")
			return false
			end
		return false
		end
	return false
	end
end	
return false

end

function RoR_SoR.KeepClaimDialog()
local function MakeCallBack()
		    return function() SendChatText(L".claim", L"") end
		end
DialogManager.MakeTwoButtonDialog( L"Claim Keep?<br>This will cost your guild 80G", GetString(StringTables.Default.LABEL_YES),MakeCallBack(),GetString(StringTables.Default.LABEL_NO),nil )
end

 function RoR_SoR.Offset(input)
 local input = tonumber(input)
 RoR_SoR.Settings.Offset = input
 EA_ChatWindow.Print(L"Offset is set to:"..towstring(input))
 end
