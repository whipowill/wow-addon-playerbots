local PlayerBots_EventFrame = CreateFrame("Frame")
PlayerBots_EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
PlayerBots_EventFrame:RegisterEvent("CHAT_MSG_WHISPER")
PlayerBots_EventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
PlayerBots_EventFrame:RegisterEvent("UPDATE")
PlayerBots_EventFrame:Hide()

local ToolBars = {}
function CreateToolBar(frame, y, name, buttons, x, spacing, register)
    if (x == nil) then x = 5 end
    if (spacing == nil) then spacing = 5 end
    if (register == nil) then register = true end

    if (frame.toolbar == nil) then
        frame.toolbar = {}
    end

    local tb = CreateFrame("Frame", "Toolbar" .. name, frame)
    tb:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)
    tb:SetWidth(frame:GetWidth() - x - 5)
    tb:SetHeight(22)
    tb:SetBackdropColor(0, 0, 0, 1.0)
    tb:SetBackdrop({
        edgeFile="Interface/ChatFrame/ChatFrameBackground",
        tile = false, tileSize = 16, edgeSize = 0,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    tb:SetBackdropBorderColor(0, 0, 0, 1.0)

    tb.buttons = {}
    for key, button in pairs(buttons) do
        local btn = CreateFrame("Button", "Toolbar" .. name .. key, tb)
        btn:SetPoint("TOPLEFT", tb, "TOPLEFT", button["index"] * (22 + spacing), 0)
        btn:SetWidth(20)
        btn:SetHeight(20)
        btn:SetBackdrop({
            edgeFile="Interface/ChatFrame/ChatFrameBackground",
            tile = false, tileSize = 16, edgeSize = 2,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        btn:SetBackdropBorderColor(0, 0, 0, 0)
        btn:EnableMouse(true)
        btn:RegisterForClicks("AnyDown")
        btn:SetScript("OnEnter", function(self)
          GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", 0, -frame:GetHeight() - 40)
          GameTooltip:SetText(button["tooltip"])
          GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function(self)
          GameTooltip:Hide()
        end)
        btn:SetScript("OnClick", function()
            btn:SetBackdropBorderColor(0.8, 0.2, 0.2, 1.0)
            for key, command in pairs(button["command"]) do
                SendChatMessage(command, "WHISPER", nil, GetUnitName("target"))
            end
        end)

        local image = CreateFrame("Frame", "Toolbar" .. name .. key .. "Image", btn)
        image:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
        image:SetWidth(16)
        image:SetHeight(16)
        image.texture = image:CreateTexture(nil, "BACKGROUND")
        local filename = "Interface\\Addons\\PlayerBots\\images\\" .. button["icon"] .. ".tga"
        image.texture:SetTexture(filename)
        image.texture:SetAllPoints()
        btn.image = image

        tb.buttons[key] = btn
    end

    frame.toolbar[name] = tb
    if (register) then
        ToolBars[name] = buttons
    end
end

function ToggleButton(frame, toolbar, button, toggle)
    local btn = frame.toolbar[toolbar].buttons[button]
    if (toggle) then
        btn:SetBackdropBorderColor(0.2, 1.0, 0.2, 1.0)
    else
        btn:SetBackdropBorderColor(0, 0, 0, 0)
    end
end

function EnablePositionSaving(frame, frameName)
    frame:SetScript("OnMouseDown", frame.StartMoving)
    frame:SetScript("OnMouseUp", function(self, button)
            self:StopMovingOrSizing()

            if (frameopts == nil) then
                frameopts = {}
            end
            if (frameopts[frameName] == nil) then
                frameopts[frameName] = {}
            end

            local opts = frameopts[frameName]
            local from, _, to, x, y = self:GetPoint()

            opts.anchorFrom = from
            opts.anchorTo = to

            if self.is_expanded then
                if opts.anchorFrom == "TOPLEFT" or opts.anchorFrom == "LEFT" or opts.anchorFrom == "BOTTOMLEFT" then
                    opts.offsetx = x
                elseif opts.anchorFrom == "TOP" or opts.anchorFrom == "CENTER" or opts.anchorFrom == "BOTTOM" then
                    opts.offsetx = x - 151/2
                elseif opts.anchorFrom == "TOPRIGHT" or opts.anchorFrom == "RIGHT" or opts.anchorFrom == "BOTTOMRIGHT" then
                    opts.offsetx = x - 151
                end
            else
                opts.offsetx = x
            end
            opts.offsety = y
        end)

    do
        -------------------------------------------------------------------------------
        -- Restore the panel's position on the screen.
        -------------------------------------------------------------------------------
        local function Reset_Position(self)
            if (frameopts == nil) then
                frameopts = {}
            end
            if (frameopts[frameName] == nil) then
                frameopts[frameName] = {}
            end
            local opts = frameopts[frameName]
            local FixedOffsetX = opts.offsetx

            self:ClearAllPoints()

            if opts.anchorTo == nil then
                self:SetPoint("CENTER", UIParent, "CENTER")
            else
                self:SetPoint(opts.anchorFrom, UIParent, opts.anchorTo, opts.offsetx, opts.offsety)
            end
        end

        frame:SetScript("OnShow", Reset_Position)
    end -- do-block
end

function ResizeBotPanel(frame, width, height)
    frame:SetWidth(width)
    frame:SetHeight(height)
    frame.header:SetWidth(frame:GetWidth())
    frame.header.text:SetWidth(frame.header:GetWidth())
    for toolbarName,toolbar in pairs(ToolBars) do
        frame.toolbar[toolbarName]:SetWidth(frame:GetWidth() - 10)
    end
end

function CreateBotRoster()
    local frame = CreateFrame("Frame", "BotRoster", UIParent)
    frame:Hide()
    frame:SetWidth(170)
    frame:SetHeight(155)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetFrameStrata("DIALOG")
    frame:SetBackdropColor(0, 0, 0, 1.0)
    frame:SetBackdrop({
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
        tile = true, tileSize = 16, edgeSize = 0,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    frame:SetBackdropBorderColor(0, 0, 0, 1)
    frame:RegisterForDrag("LeftButton")

    EnablePositionSaving(frame, "BotRoster")

    frame.items = {}
    for i = 1,10 do
        local item = CreateFrame("Frame", "BotRoster_Item" .. i, frame)
        item:SetPoint("TOPLEFT", frame, "TOPLEFT", i * 100, 0)
        item:SetWidth(80)
        item:SetHeight(40)
        item:SetBackdropColor(0,0,0,1)
        item:SetBackdrop({
            bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
            edgeFile="Interface/ChatFrame/ChatFrameBackground",
            tile = true, tileSize = 16, edgeSize = 2,
            insets = { left = 2, right = 2, top = 2, bottom = 0 }
        })
        item:SetBackdropBorderColor(0.8,0.8,0.8,1)

        item.text = item:CreateFontString("BotRoster_ItemHeader" .. i)
        item.text:SetPoint("TOPLEFT", item, "TOPLEFT", 20, 1)
        item.text:SetWidth(item:GetWidth())
        item.text:SetHeight(22)
        item.text:SetFont("Fonts/FRIZQT__.TTF", 11, "OUTLINE")
        item.text:SetJustifyH("LEFT")
        item.text:SetText("Click!")

        local cls = CreateFrame("Frame", "BotRoster_ItemHeader" .. i .. "Image", item)
        cls:SetPoint("TOPLEFT", item, "TOPLEFT", 3, -3)
        cls:SetWidth(16)
        cls:SetHeight(16)
        cls.texture = cls:CreateTexture(nil, "BACKGROUND")
        cls.texture:SetTexture("Interface\\Addons\\PlayerBots\\images\\role_dps.tga")
        cls.texture:SetAllPoints()
        item.cls = cls

        CreateToolBar(item, -18, "quickbar"..i, {
            ["login"] = {
                icon = "login",
                command = {[0] = ""},
                strategy = "",
                tooltip = "Bring bot online",
                index = 0
            },
            ["logout"] = {
                icon = "logout",
                command = {[0] = ""},
                tooltip = "Logout bot",
                strategy = "",
                index = 0
            },
            ["invite"] = {
                icon = "invite",
                command = {[0] = ""},
                tooltip = "Invite to your group",
                strategy = "",
                index = 1
            },
            ["leave"] = {
                icon = "leave",
                command = {[0] = ""},
                tooltip = "Remove from group",
                strategy = "",
                index = 1
            },
            ["whisper"] = {
                icon = "whisper",
                command = {[0] = ""},
                tooltip = "Start whisper chat",
                strategy = "",
                index = 2
            }
        }, 20, 0, false)
        local tb = item.toolbar["quickbar"..i]
        tb:SetBackdropBorderColor(0,0,0,0.0)
        tb.buttons["login"]:SetPoint("TOPLEFT", tb, "TOPLEFT", 0, 0)
        tb.buttons["logout"]:SetPoint("TOPLEFT", tb, "TOPLEFT", 0, 0)
        tb.buttons["invite"]:SetPoint("TOPLEFT", tb, "TOPLEFT", 16, 0)
        tb.buttons["leave"]:SetPoint("TOPLEFT", tb, "TOPLEFT", 16, 0)
        tb.buttons["whisper"]:SetPoint("TOPLEFT", tb, "TOPLEFT", 32, 0)

        item:Hide()
        frame.items[i] = item
    end

    CreateToolBar(frame, 0, "quickbar", {
        ["login_all"] = {
            icon = "login",
            command = {[0] = ""},
            strategy = "",
            tooltip = "Bring all bots online",
            index = 0
        },
        ["logout_all"] = {
            icon = "logout",
            command = {[0] = ""},
            tooltip = "Logout all bots",
            strategy = "",
            index = 1
        },
        ["invite_all"] = {
            icon = "invite",
            command = {[0] = ""},
            tooltip = "Invite all bots to your group",
            strategy = "",
            index = 2
        },
        ["leave_all"] = {
            icon = "leave",
            command = {[0] = ""},
            tooltip = "Remove all bots from group",
            strategy = "",
            index = 3
        }
    }, 5, 0, false)
    local tb = frame.toolbar["quickbar"]
    tb:SetBackdropBorderColor(0,0,0,0.0)

    return frame
end

function CreateSelectedBotPanel()
    local frame = CreateFrame("Frame", "SelectedBotPanel", UIParent)
    frame:Hide()
    frame:SetWidth(170)
    frame:SetHeight(155)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetFrameStrata("DIALOG")
    frame:SetBackdropColor(0, 0, 0, 1.0)
    frame:SetBackdrop({
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
        edgeFile="Interface/ChatFrame/ChatFrameBackground",
        tile = true, tileSize = 16, edgeSize = 2,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    frame:SetBackdropBorderColor(0.5,0.1,0.7,1)
    frame:RegisterForDrag("LeftButton")

    frame.header = CreateFrame("Frame", "SelectedBotPanelHeader", frame)
    frame.header:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.header:SetWidth(frame:GetWidth())
    frame.header:SetHeight(22)
    frame.header:SetBackdropColor(0.5,0.1,0.7,1)
    frame.header:SetBackdrop({
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
        edgeFile="Interface/ChatFrame/ChatFrameBackground",
        tile = true, tileSize = 16, edgeSize = 0,
        insets = { left = 2, right = 2, top = 2, bottom = 0 }
    })
    frame.header:SetBackdropBorderColor(0.5,0.1,0.7,1)

    frame.header.text = frame.header:CreateFontString("SelectedBotPanelHeaderText")
    frame.header.text:SetPoint("TOPLEFT", frame, "TOPLEFT", 22, 0)
    frame.header.text:SetWidth(frame.header:GetWidth())
    frame.header.text:SetHeight(22)
    frame.header.text:SetFont("Fonts/FRIZQT__.TTF", 11, "OUTLINE")
    frame.header.text:SetJustifyH("LEFT")
    frame.header.text:SetText("Click!")

    frame.header.role = CreateFrame("Frame", "SelectedBotPanelHeaderRole", frame.header)
    frame.header.role:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
    frame.header.role:SetWidth(16)
    frame.header.role:SetHeight(16)
    frame.header.role.texture = frame.header.role:CreateTexture(nil, "BACKGROUND")
    frame.header.role.texture:SetTexture("Interface\\Addons\\PlayerBots\\images\\role_dps.tga")
    frame.header.role.texture:SetAllPoints()

    EnablePositionSaving(frame, "SelectedBotPanel")

    local y = 25
    CreateToolBar(frame, -y, "movement", {
        ["follow_master"] = {
            icon = "follow_master",
            command = {[0] = "nc +follow,?"},
            strategy = "follow",
            tooltip = "Follow",
            index = 0
        },
        ["stay"] = {
            icon = "stay",
            command = {[0] = "nc +stay,?"},
            strategy = "stay",
            tooltip = "Stay",
            index = 1
        },
        ["set_guard"] = {
            icon = "set_guard",
            command = {[0] = "position guard"},
            strategy = "",
            tooltip = "Set guard position",
            index = 2
        },
        ["guard"] = {
            icon = "guard",
            command = {[0] = "nc +guard,?"},
            strategy = "guard",
            tooltip = "Guard",
            index = 3
        },
        ["grind"] = {
            icon = "grind",
            command = {[0] = "nc +grind,?", [1] = "co +grind,?"},
            strategy = "grind",
            tooltip = "Aggresive mode",
            index = 4
        },
        ["passive"] = {
            icon = "flee",
            command = {[0] = "nc +passive,?", [1] = "co +passive,?"},
            strategy = "passive",
            tooltip = "Passive mode",
            index = 5
        },
        ["reset_movement"] = {
            icon = "passive",
            command = {[0] = "nc -follow,-stay,-guard,-grind,-passive,?", [1] = "co -grind,-passive,?"},
            strategy = "",
            tooltip = "Reset movement",
            index = 8
        },
    })

    y = y + 25
    CreateToolBar(frame, -y, "actions", {
        ["stats"] = {
            icon = "stats",
            command = {[0] = "stats"},
            strategy = "",
            tooltip = "Stats",
            index = 0
        },
        ["loot"] = {
            icon = "loot",
            command = {[0] = "nc +loot,?"},
            strategy = "loot",
            tooltip = "Loot",
            index = 1
        },

        ["reset_actions"] = {
            icon = "passive",
            command = {[0] = "nc -loot,?"},
            strategy = "",
            tooltip = "Reset actions",
            index = 8
        },
    })

    y = y + 25
    CreateToolBar(frame, -y, "formation", { -- note formation shield and queue are not in here, seem duplicative
        ["near"] = {
            icon = "formation_near",
            command = {[0] = "formation near"},
            formation = "near",
            tooltip = "Formation near",
            index = 0
        },
        ["melee"] = {
            icon = "formation_melee",
            command = {[0] = "formation melee"},
            formation = "melee",
            tooltip = "Formation melee",
            index = 1
        },
        ["line"] = {
            icon = "formation_line",
            command = {[0] = "formation line"},
            formation = "line",
            tooltip = "Formation line",
            index = 2
        },
        ["circle"] = {
            icon = "formation_circle",
            command = {[0] = "formation circle"},
            formation = "circle",
            tooltip = "Formation circle",
            index = 3
        },
        ["arrow"] = {
            icon = "formation_arrow",
            command = {[0] = "formation arrow"},
            formation = "arrow",
            tooltip = "Formation arrow",
            index = 4
        },
        ["far"] = {
            icon = "formation_far",
            command = {[0] = "formation far"},
            formation = "far",
            tooltip = "Formation far",
            index = 5
        },
        ["chaos"] = {
            icon = "formation_chaos",
            command = {[0] = "formation chaos"},
            formation = "chaos",
            tooltip = "Formation chaos",
            index = 6
        },
        ["reset_formation"] = {
            icon = "passive",
            command = {[0] = "formation near"},
            strategy = "",
            tooltip = "Reset formations",
            index = 8
        },
    })

    y = y + 25
    CreateToolBar(frame, -y, "attack_type", {
        ["tank_aoe"] = {
            icon = "tank_aoe",
            command = {[0] = "nc +tank aoe,?", [1] = "co +tank aoe,?"},
            strategy = "tank aoe",
            tooltip = "Play as primary tank",
            index = 0
        },
        ["tank_assist"] = {
            icon = "tank_assist",
            command = {[0] = "nc +tank assist,?", [1] = "co +tank assist,?"},
            strategy = "tank assist",
            tooltip = "Play as secondary tank",
            index = 1
        },
        ["dps_assist"] = {
            icon = "dps_assist",
            command = {[0] = "nc +dps assist,?", [1] = "co +dps assist,?"},
            strategy = "dps assist",
            tooltip = "Play as DPS",
            index = 2
        },
        ["reset_attacktype"] = {
            icon = "passive",
            command = {[0] = "nc -tank aoe,-tank assist,-dps aoe,-dps assist,?", [1] = "co -tank aoe,-tank assist,-dps aoe,-dps assist,?"},
            strategy = "",
            tooltip = "Reset attacktype",
            index = 8
        }
    })

    --[[
    y = y + 25
    CreateToolBar(frame, -y, "rti", {
        ["attack_rti"] = {
            icon = "attack_rti",
            command = {[0] = "nc +attack rti,?",[1] = "co +attack rti,?"},
            strategy = "attack rti",
            tooltip = "Attack enemy with assigned mark",
            index = 0
        },
        ["rti_skull"] = {
            icon = "rti_skull",
            command = {[0] = "rti skull"},
            rti = "skull",
            tooltip = "Assign skull mark",
            index = 1
        },
        ["rti_cross"] = {
            icon = "rti_cross",
            command = {[0] = "rti cross"},
            rti = "cross",
            tooltip = "Assign cross mark",
            index = 2
        },
        ["rti_circle"] = {
            icon = "rti_circle",
            command = {[0] = "rti circle"},
            rti = "circle",
            tooltip = "Assign circle mark",
            index = 3
        },
        ["rti_star"] = {
            icon = "rti_star",
            command = {[0] = "rti star"},
            rti = "star",
            tooltip = "Assign star mark",
            index = 4
        },
        ["rti_square"] = {
            icon = "rti_square",
            command = {[0] = "rti square"},
            rti = "square",
            tooltip = "Assign square mark",
            index = 5
        },
        ["rti_triangle"] = {
            icon = "rti_triangle",
            command = {[0] = "rti triangle"},
            rti = "triangle",
            tooltip = "Assign triangle mark",
            index = 6
        },
        ["rti_diamond"] = {
            icon = "rti_diamond",
            command = {[0] = "rti diamond"},
            rti = "diamond",
            tooltip = "Assign diamond mark",
            index = 7
        },
        ["rti_moon"] = {
            icon = "rti_moon",
            command = {[0] = "rti moon"},
            rti = "moon",
            tooltip = "Assign moon mark",
            index = 8
        }
    })
    ]]

    y = y + 25
    CreateToolBar(frame, -y, "generic", {
        ["potions"] = {
            icon = "potions",
            command = {[0] = "co +potions,?"},
            strategy = "potions",
            tooltip = "Use health and mana potions",
            index = 0
        },
        ["food"] = {
            icon = "food",
            command = {[0] = "nc +food,?"},
            strategy = "food",
            tooltip = "Use food and drinks",
            index = 1
        },
        ["cast_time"] = {
            icon = "cast_time",
            command = {[0] = "co +cast time,?"},
            strategy = "cast time",
            tooltip = "Cast long spells cautiously",
            index = 2
        },
        ["conserve_mana"] = {
            icon = "conserve_mana",
            command = {[0] = "nc +conserve mana,?", [1] = "co +conserve mana,?"},
            strategy = "conserve mana",
            tooltip = "Conserve mana",
            index = 3
        },
        ["attack_weak"] = {
            icon = "attack_weak",
            command = {[0] = "nc +attack weak,?", [1] = "co +attack weak,?"},
            strategy = "attack weak",
            tooltip = "Attack weak enemy first",
            index = 4
        },
        ["threat"] = {
            icon = "threat",
            command = {[0] = "co +threat,?"},
            strategy = "threat",
            tooltip = "Keep threat level low",
            index = 5
        },
        ["custom_say"] = {
            icon = "whisper",
            command = {[0] = "nc +custom::say,?", [1] = "co +custom::say,?"},
            strategy = "custom::say",
            tooltip = "Say custom lines",
            index = 6
        },
        ["reset_generic"] = {
            icon = "passive",
            command = {[0] = "nc -potions,-food,-cast time,-conserve mana,-attack weak,-custom::say,?", [1] = "co -potions,-food,-cast time,-conserve mana,-attack weak,-threat,-custom::say,?"},
            strategy = "",
            tooltip = "Reset generic",
            index = 8
        }
    })

    y = y + 25
    CreateToolBar(frame, -y, "CLASS_DRUID", {
        ["bear"] = {
            icon = "bear",
            command = {[0] = "co +bear,?", [1] = "nc +bear,?"},
            strategy = "bear",
            tooltip = "Use bear form",
            index = 0
        },
        ["cat"] = {
            icon = "cat",
            command = {[0] = "co +cat,?", [1] = "nc +cat,?"},
            strategy = "cat",
            tooltip = "Use cat form",
            index = 1
        },
        ["caster"] = {
            icon = "caster",
            command = {[0] = "co +caster,?", [1] = "nc +caster,?"},
            strategy = "caster",
            tooltip = "Use owl form",
            index = 2
        },
        ["heal"] = {
            icon = "heal",
            command = {[0] = "co +heal,?", [1] = "nc +heal,?"},
            strategy = "heal",
            tooltip = "Healer mode",
            index = 3
        },
        ["reset_druid"] = {
            icon = "passive",
            command = {[0] = "nc -bear,-cat,-caster,-heal,?", [1] = "co -bear,-cat,-caster,-heal,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })
    CreateToolBar(frame, -y, "CLASS_HUNTER", {
        ["dps"] = {
            icon = "dps",
            command = {[0] = "co +dps,?"},
            strategy = "dps",
            tooltip = "DPS mode",
            index = 0
        },
        ["bspeed"] = {
            icon = "bspeed",
            command = {[0] = "co +bspeed,?", [1] = "nc +bspeed,?"},
            strategy = "bspeed",
            tooltip = "Buff movement speed",
            index = 1
        },
        ["bmana"] = {
            icon = "bmana",
            command = {[0] = "co +bmana,?", [1] = "nc +bmana,?"},
            strategy = "bmana",
            tooltip = "Buff mana regen",
            index = 2
        },
        ["bdps"] = {
            icon = "bdps",
            command = {[0] = "co +bdps,?", [1] = "nc +bdps,?"},
            strategy = "bdps",
            tooltip = "Buff DPS",
            index = 3
        },
        ["reset_hunter"] = {
            icon = "passive",
            command = {[0] = "nc -dps,-bspeed,-bmana,-bdps,?", [1] = "co -dps,-bspeed,-bmana,-bdps,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })
    CreateToolBar(frame, -y, "CLASS_MAGE", {
        ["arcane"] = {
            icon = "arcane",
            command = {[0] = "co +arcane,?"},
            strategy = "arcane",
            tooltip = "Use arcane spells",
            index = 0
        },
        ["fire"] = {
            icon = "fire",
            command = {[0] = "co +fire,?"},
            strategy = "fire",
            tooltip = "Use fire spells",
            index = 1
        },
        ["fire_aoe"] = {
            icon = "fire_aoe",
            command = {[0] = "co +fire aoe,?"},
            strategy = "fire aoe",
            tooltip = "Use fire AOE abilities",
            index = 2
        },
        ["frost"] = {
            icon = "frost",
            command = {[0] = "co +frost,?"},
            strategy = "frost",
            tooltip = "Use frost spells",
            index = 3
        },
        ["frost_aoe"] = {
            icon = "frost_aoe",
            command = {[0] = "co +frost aoe,?"},
            strategy = "frost aoe",
            tooltip = "Use frost AOE abilities",
            index = 4
        },
        ["bmana"] = {
            icon = "bmana",
            command = {[0] = "co +bmana,?", [1] = "nc +bmana,?"},
            strategy = "bmana",
            tooltip = "Buff mana regen",
            index = 5
        },
        ["bdps"] = {
            icon = "bdps",
            command = {[0] = "co +bdps,?", [1] = "nc +bdps,?"},
            strategy = "bdps",
            tooltip = "Buff DPS",
            index = 6
        },
        ["reset_mage"] = {
            icon = "passive",
            command = {[0] = "nc -bmana,-bdps,?", [1] = "co -arcane,-fire,-fire aoe,-frost,-frost aoe,-bmana,-bdps,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })
    CreateToolBar(frame, -y, "CLASS_PALADIN", {
        ["dps"] = {
            icon = "dps",
            command = {[0] = "co +dps,?"},
            strategy = "dps",
            tooltip = "DPS mode",
            index = 0
        },
        ["tank"] = {
            icon = "tank",
            command = {[0] = "co +tank,?"},
            strategy = "tank",
            tooltip = "Tank mode",
            index = 1
        },
        ["bmana"] = {
            icon = "bmana",
            command = {[0] = "co +bmana,?", [1] = "nc +bmana,?"},
            strategy = "bmana",
            tooltip = "Buff mana regen",
            index = 2
        },
        ["bhealth"] = {
            icon = "bhealth",
            command = {[0] = "co +bhealth,?"},
            strategy = "bhealth",
            tooltip = "Buff health regen",
            index = 3
        },
        ["bdps"] = {
            icon = "bdps",
            command = {[0] = "co +bdps,?", [1] = "nc +bdps,?"},
            strategy = "bdps",
            tooltip = "Buff DPS",
            index = 4
        },
        ["barmor"] = {
            icon = "barmor",
            command = {[0] = "co +barmor,?", [1] = "nc +barmor,?"},
            strategy = "barmor",
            tooltip = "Buff armor",
            index = 5
        },
        ["bspeed"] = {
            icon = "bspeed",
            command = {[0] = "co +bspeed,?", [1] = "nc +bspeed,?"},
            strategy = "bspeed",
            tooltip = "Buff movement speed",
            index = 6
        },
        ["bthreat"] = {
            icon = "bthreat",
            command = {[0] = "co +bthreat,?", [1] = "nc +bthreat,?"},
            strategy = "bthreat",
            tooltip = "Buff threat generation",
            index = 7
        },
        ["reset_paladin"] = {
            icon = "passive",
            command = {[0] = "nc -bmana,-bdps,-barmor,-bspeed,-bthreat,?", [1] = "co -dps,-tank,-bmana,-bhealth,-bdps,-barmor,-bspeed,-bthreat,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })
    CreateToolBar(frame, -y, "CLASS_PRIEST", {
        ["heal"] = {
            icon = "heal",
            command = {[0] = "nc +heal,?", [1] = "co +heal,?"},
            strategy = "heal",
            tooltip = "Healer mode",
            index = 0
        },
        ["holy"] = {
            icon = "holy",
            command = {[0] = "co +holy,?"},
            strategy = "holy",
            tooltip = "Use holy spells",
            index = 1
        },
        ["shadow"] = {
            icon = "shadow",
            command = {[0] = "co +shadow,?"},
            strategy = "shadow",
            tooltip = "Shadow",
            index = 2
        },
        ["shadow_aoe"] = {
            icon = "shadow_aoe",
            command = {[0] = "co +shadow aoe,?"},
            strategy = "shadow aoe",
            tooltip = "Use shadow AOE abilities",
            index = 3
        },
        ["shadow_debuff"] = {
            icon = "shadow_debuff",
            command = {[0] = "co +shadow debuff,?"},
            strategy = "shadow debuff",
            tooltip = "Use shadow debuffs",
            index = 4
        },
        ["reset_priest"] = {
            icon = "passive",
            command = {[0] = "nc -heal,?", [1] = "co -heal,-holy,-shadow,-shadow aoe,-shadow debuff,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })
    CreateToolBar(frame, -y, "CLASS_ROGUE", {
        ["dps"] = {
            icon = "dps",
            command = {[0] = "co +dps,?"},
            strategy = "dps",
            tooltip = "DPS mode",
            index = 0
        },
        ["reset_rogue"] = {
            icon = "passive",
            command = {[0] = "co -dps,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })
    CreateToolBar(frame, -y, "CLASS_SHAMAN", {
        ["caster"] = {
            icon = "caster",
            command = {[0] = "co +caster,?"},
            strategy = "caster",
            tooltip = "Caster mode",
            index = 0
        },
        ["caster_aoe"] = {
            icon = "caster_aoe",
            command = {[0] = "co +caster aoe,?"},
            strategy = "caster aoe",
            tooltip = "Use caster AOE abilities",
            index = 1
        },
        ["heal"] = {
            icon = "heal",
            command = {[0] = "co +heal,?"},
            strategy = "heal",
            tooltip = "Healer mode",
            index = 2
        },
        ["melee"] = {
            icon = "dps",
            command = {[0] = "co +melee,?"},
            strategy = "melee",
            tooltip = "Melee mode",
            index = 3
        },
        ["totems"] = {
            icon = "totems",
            command = {[0] = "co +totems,?"},
            strategy = "totems",
            tooltip = "Use totems",
            index = 4
        },
        ["bmana"] = {
            icon = "bmana",
            command = {[0] = "co +bmana,?", [1] = "nc +bmana,?"},
            strategy = "bmana",
            tooltip = "Buff mana regen",
            index = 5
        },
        ["bdps"] = {
            icon = "bdps",
            command = {[0] = "co +bdps,?", [1] = "nc +bdps,?"},
            strategy = "bdps",
            tooltip = "Buff DPS",
            index = 6
        },
        ["reset_shaman"] = {
            icon = "passive",
            command = {[0] = "nc -bmana,-bdps,?", [1] = "co -caster,-caster aoe,-heal,-melee,-totems,-bmana,-bdps,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })
    CreateToolBar(frame, -y, "CLASS_WARLOCK", {
        ["dps"] = {
            icon = "dps",
            command = {[0] = "co +dps,?"},
            strategy = "dps",
            tooltip = "DPS mode",
            index = 0
        },
        ["dps_debuff"] = {
            icon = "dps_debuff",
            command = {[0] = "co +dps debuff,?"},
            strategy = "dps debuff",
            tooltip = "Use DPS debuffs",
            index = 1
        },
        ["caster_aoe"] = {
            icon = "caster_aoe",
            command = {[0] = "co +aoe,?"},
            strategy = "aoe",
            tooltip = "Use AOE abilities",
            index = 2
        },
        ["tank"] = {
            icon = "tank",
            command = {[0] = "co +tank,?"},
            strategy = "tank",
            tooltip = "Tank mode",
            index = 3
        },
        ["reset_warlock"] = {
            icon = "passive",
            command = {[0] = "co -dps debuff,-aoe,-tank,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })
    CreateToolBar(frame, -y, "CLASS_WARRIOR", {
        ["dps"] = {
            icon = "dps",
            command = {[0] = "co +dps,?"},
            strategy = "dps",
            tooltip = "DPS mode",
            index = 0
        },
        ["warrior_aoe"] = {
            icon = "warrior_aoe",
            command = {[0] = "co +aoe,?"},
            strategy = "aoe",
            tooltip = "Use AOE abilities",
            index = 1
        },
        ["tank"] = {
            icon = "tank",
            command = {[0] = "co +tank,?"},
            strategy = "tank",
            tooltip = "Tank mode",
            index = 2
        },
        ["reset_warrior"] = {
            icon = "passive",
            command = {[0] = "co -dps,-aoe,-tank,?"},
            strategy = "",
            tooltip = "Reset class",
            index = 8
        }
    })

    frame:SetHeight(y + 25)
    return frame
end

function SetFrameColor(frame, class)
    local color = RAID_CLASS_COLORS[class]
    frame:SetBackdropBorderColor(color.r, color.g, color.b, 1.0)
    frame.header:SetBackdropColor(color.r, color.g, color.b, 1.0)
    frame.header:SetBackdropBorderColor(color.r, color.g, color.b, 1.0)
end

local botTable = {}
SelectedBotPanel = CreateSelectedBotPanel();
BotRoster = CreateBotRoster();

PlayerBots_EventFrame:SetScript("OnEvent", function(self, event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...
    -- print(event)
    if (BotRoster:IsVisible() and event == "PLAYER_TARGET_CHANGED") then
        local name = GetUnitName("target")
        local self = GetUnitName("player")
        if (name == nil or not UnitIsPlayer("target") or name == self or UnitIsEnemy(self, name)) then
            SelectedBotPanel:Hide()
        else
            wait(0.1, function() SendChatMessage("nc ?", "WHISPER", nil, name) end)
            wait(0.2, function() SendChatMessage("co ?", "WHISPER", nil, name) end)
            wait(0.3, function() SendChatMessage("formation ?", "WHISPER", nil, name) end)
            --wait(0.8, function() SendChatMessage("rti ?", "WHISPER", nil, name) end)
        end
    end

    if (event == "CHAT_MSG_SYSTEM") then
        local message = arg1
        if (OnSystemMessage(message)) then
            BotRoster:Show()
            for i = 1,10 do
                BotRoster.items[i]:Hide()
            end
            local index = 1
            local x = 5
            local width = 0
            local height = 0
            local y = 5
            local colCount = 2
            local allBots = ""
            local first = true
            local allBotsLoggedIn = true
            local allBotsLoggedOut = true
            local allBotsInParty = true
            local atLeastOneBotInParty = false
            for key,bot in pairs(botTable) do
                local item = BotRoster.items[index]
                if (first) then first = false
                else allBots = allBots .. "," end
                allBots = allBots .. key

                item.text:SetText(key)

                local filename = "Interface\\Addons\\PlayerBots\\images\\cls_" .. bot["class"]:lower() ..".tga"
                item.cls.texture:SetTexture(filename)

                local color = RAID_CLASS_COLORS[bot["class"]:upper()]
                item.text:SetTextColor(color.r, color.g, color.b, 1.0)

                item:SetPoint("TOPLEFT", BotRoster, "TOPLEFT", x, -y)

                local loginBtn = item.toolbar["quickbar"..index].buttons["login"]
                loginBtn:Hide()
                local logoutBtn = item.toolbar["quickbar"..index].buttons["logout"]
                logoutBtn:Hide()
                local inviteBtn = item.toolbar["quickbar"..index].buttons["invite"]
                inviteBtn:Show()
                local leaveBtn = item.toolbar["quickbar"..index].buttons["leave"]
                leaveBtn:Hide()
                local whisperBtn = item.toolbar["quickbar"..index].buttons["whisper"]
                whisperBtn:Hide()
                if (bot["online"]) then
                    item:SetBackdropBorderColor(0.2, 1.0, 0.2, 1.0)
                    logoutBtn:Show()
                    whisperBtn:Show()
                    local inParty = false
                    for i = 1,5 do
                        if (UnitName("party"..i) == key) then
                            inviteBtn:Hide()
                            leaveBtn:Show()
                            atLeastOneBotInParty = true
                            inParty = true
                        end
                    end
                    if (not inParty) then allBotsInParty = false end
                    allBotsLoggedOut = false
                else
                    item:SetBackdropBorderColor(0.4,0.4,0.4,1)
                    loginBtn:Show()
                    inviteBtn:Hide()
                    allBotsLoggedIn = false
                end
                loginBtn:SetScript("OnClick", function()
                    SendChatMessage(".playerbots bot add " .. key, "SAY")
                end)
                logoutBtn:SetScript("OnClick", function()
                    SendChatMessage(".playerbots bot rm " .. key, "SAY")
                end)
                inviteBtn:SetScript("OnClick", function()
                    InviteUnit(key)
                end)
                leaveBtn:SetScript("OnClick", function()
                    SendChatMessage("leave", "WHISPER", nil, key)
                end)
                whisperBtn:SetScript("OnClick", function()
                    local editBox = _G["ChatFrame1EditBox"]
                    editBox:Show()
                    editBox:SetFocus()
                    editBox:SetText("/w " .. key .. " ")
                end)

                item:Show()

                index = index + 1
                x = x + (5 + item:GetWidth())
                height = item:GetHeight()
                if (width < x) then width = x end
                if ((index - 1) % colCount == 0) then
                    y = y + (5 + height)
                    x = 5
                end
            end
            if ((index - 1) % colCount ~= 0) then
                y = y + (5 + height)
            end
            BotRoster:SetWidth(width)
            BotRoster:SetHeight(y + 22)

            local tb = BotRoster.toolbar["quickbar"]
            tb:SetPoint("TOPLEFT", BotRoster, "TOPLEFT", 5, -y)
            local loginAllBtn = tb.buttons["login_all"]
            x = 0
            loginAllBtn:SetPoint("TOPLEFT", tb, "TOPLEFT", x, 0)
            if (not allBotsLoggedIn) then
                loginAllBtn:Show()
                x = x + 16
            else
                loginAllBtn:Hide()
            end
            loginAllBtn:SetScript("OnClick", function()
                SendChatMessage(".playerbots bot add " .. allBots, "SAY")
            end)

            local logoutAllBtn = tb.buttons["logout_all"]
            logoutAllBtn:SetPoint("TOPLEFT", tb, "TOPLEFT", x, 0)
            if (not allBotsLoggedOut) then
                logoutAllBtn:Show()
                x = x + 16
            else
                logoutAllBtn:Hide()
            end
            logoutAllBtn:SetScript("OnClick", function()
                SendChatMessage(".playerbots bot rm " .. allBots, "SAY")
            end)

            local inviteAllBtn = tb.buttons["invite_all"]
            inviteAllBtn:SetPoint("TOPLEFT", tb, "TOPLEFT", x, 0)
            if (not allBotsInParty) then
                inviteAllBtn:Show()
                x = x + 16
            else
                inviteAllBtn:Hide()
            end
            inviteAllBtn:SetScript("OnClick", function()
                local timeout = 0.1
                for key,bot in pairs(botTable) do
                    wait(timeout, function() InviteUnit(key) end)
                    timeout = timeout + 0.1
                end
                wait(1, function() SendChatMessage(".playerbots bot list", "SAY") end)
            end)

            local leaveAllBtn = tb.buttons["leave_all"]
            leaveAllBtn:SetPoint("TOPLEFT", tb, "TOPLEFT", x, 0)
            if (atLeastOneBotInParty) then
                leaveAllBtn:Show()
                x = x + 16
            else
                leaveAllBtn:Hide()
            end
            leaveAllBtn:SetScript("OnClick", function()
                local timeout = 0.1
                for key,bot in pairs(botTable) do
                    wait(timeout, function() SendChatMessage("leave", "WHISPER", nil, key) end)
                    timeout = timeout + 0.1
                end
            end)
        end
    end

    if (event == "CHAT_MSG_WHISPER") then
        local message = arg1
        local sender = arg2

        OnWhisper(message, sender)

        if (string.find(message, "Hello") == 1 or string.find(message, "Goodbye") == 1) then
            SendChatMessage(".playerbots bot list", "SAY")
        end

        local bot = botTable[sender]
        if (bot == nil or bot["strategy"] == nil or bot["role"] == nil) then
            SelectedBotPanel:Hide()
            return
        end
        local selected = GetUnitName("target")
        if (BotRoster:IsVisible() and sender == selected) then
            SelectedBotPanel:Show()

            local tmp, class = UnitClass("target")
            SetFrameColor(SelectedBotPanel, class)

            local filename = "Interface\\Addons\\PlayerBots\\images\\role_" .. bot["role"] .. ".tga"
            SelectedBotPanel.header.role.texture:SetTexture(filename)
            SelectedBotPanel.header.text:SetText(sender)

            local width = 0
            local height = 0
            for toolbarName,toolbar in pairs(ToolBars) do
                local panelVisible = true
                if (string.find(toolbarName, "CLASS_") == 1) then
                    if (string.sub(toolbarName, 7) == class) then
                        SelectedBotPanel.toolbar[toolbarName]:Show()
                    else
                        SelectedBotPanel.toolbar[toolbarName]:Hide()
                        panelVisible = false
                    end
                end
                local numButtons = 0
                for buttonName,button in pairs(toolbar) do
                    local toggle = false
                    if (button["strategy"] ~= nil) then
                        for key,strategy in pairs(bot["strategy"]["nc"]) do
                            if (strategy == button["strategy"]) then
                                toggle = true
                                break
                            end
                        end
                        for key,strategy in pairs(bot["strategy"]["co"]) do
                            if (strategy == button["strategy"]) then
                                toggle = true
                                break
                            end
                        end
                    end
                    if (button["formation"] ~= nil and bot["formation"] ~= nil and string.find(bot["formation"], button["formation"]) ~= nil) then
                        toggle = true
                    end
                    if (button["rti"] ~= nil and bot["rti"] ~= nil and string.find(bot["rti"], button["rti"]) ~= nil) then
                        toggle = true
                    end
                    ToggleButton(SelectedBotPanel, toolbarName, buttonName, toggle)
                    numButtons = numButtons + 1
                end
                if (panelVisible) then
                    height = height + 1
                    if (width < numButtons) then width = numButtons end
                end
            end
            ResizeBotPanel(SelectedBotPanel, width * 25 + 20, height * 25 + 25)

            if (string.find(message, "Following") == 1 or string.find(message, "Staying") == 1 or string.find(message, "Fleeing") == 1) then
                wait(0.1, function() SendChatMessage("nc ?", "WHISPER", nil, sender) end)
            end
            if (string.find(message, "Formation set to") == 1) then
                wait(0.1, function() SendChatMessage("formation ?", "WHISPER", nil, sender) end)
            end
            if (string.find(message, "rti set to") == 1) then -- "rti" must be lowercase to detect
                wait(0.1, function() SendChatMessage("rti ?", "WHISPER", nil, sender) end)
            end
        end
    end
end)

function trim2(s)
  return s:match "^%s*(.-)%s*$"
end

function OnWhisper(message, sender)
    if (botTable[sender] == nil) then
        botTable[sender] = {}
    end

    local bot = botTable[sender]
    if (string.find(message, 'Strategies: ') == 1) then
        local list = {}
        local type = "co"
        local role = "dps"
        for i in string.gmatch(string.sub(message, 13), "([^,]+)") do
            local name = trim2(i)
            table.insert(list, name)
            if (name == "nc") then type = 'nc' end
            if (name == "heal") then role = "heal" end
            if (name == "tank" or name == "bear") then role = "tank" end
        end
        if (bot['strategy'] == nil) then
            bot['strategy'] = {nc = {}, co = {}}
        end
        if (type == "co") then
            bot["role"] = role
        end
        bot['strategy'][type] = list
    end
    if (string.find(message, 'Formation: ') == 1) then
        bot['formation'] = string.sub(message, 11)
    end
    if (string.find(message, 'RTI: ') == 1) then
        bot['rti'] = string.sub(message, 5)
    end
end

function OnSystemMessage(message)
    if (string.find(message, 'Bot roster: ') == 1) then
        botTable = {}
        for i in string.gmatch(string.sub(message, 13), "([^,]+)") do
            local line = trim2(i)
            local on = string.sub(line, 1, 1)
            local pos = string.find(line, " ")
            local name = string.sub(line, 2, pos - 1)
            local cls = string.sub(line, pos + 1)

            if (botTable[name] == nil) then
                botTable[name] = {}
            end
            local bot = botTable[name]
            bot["class"] = cls
            bot["online"] = (on == "+")
        end
        return true
    end
    return false
end

SLASH_PlayerBots1 = '/bot'
function SlashCmdList.PlayerBots(msg, editbox) -- 4.
    if (msg == "" or msg == "roster") then
        if (BotRoster:IsVisible()) then
            BotRoster:Hide()
            SelectedBotPanel:Hide()
        else
            SendChatMessage(".playerbots bot list", "SAY")
        end
    end
end

local waitTable = {};
local waitFrame = nil;

function wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
end

print("PlayerBots Addon is loaded");