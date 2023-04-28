
PlayerBots = {
	Locales = {},
}

local _usedLocale
function PlayerBots.InitLocale()
	_usedLocale = PlayerBots.Locales[GetLocale()]
end

function PlayerBots.I18n(text)
	if _usedLocale then
		return _usedLocale[text] or text
	else
		return text
	end
end
