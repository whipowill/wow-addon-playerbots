
PlayerBots = {
	Locales = {},
}

local _usedLocale

function PlayerBots.InitLocale()
	if not PlayerBots.Locales then
		return
	end
	_usedLocale = PlayerBots.Locales[GetLocale()]
	PlayerBots.Locales = nil -- free memory
end

function PlayerBots.I18n(text)
	if _usedLocale then
		return _usedLocale[text] or text
	else
		return text
	end
end
