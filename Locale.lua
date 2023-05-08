
PlayerBots = {
	Locales = {},
}

local usedLocale

function PlayerBots.InitLocale()
	if not PlayerBots.Locales then
		return
	end
	usedLocale = PlayerBots.Locales[GetLocale()]
	PlayerBots.Locales = nil -- free memory
end

function PlayerBots.I18n(text)
	if usedLocale then
		return usedLocale[text] or text
	else
		return text
	end
end
