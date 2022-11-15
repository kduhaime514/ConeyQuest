--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Config = {}; -- adds Config table to addon namespace

local Config = core.Config;
local UIConfig;

--------------------------------------
-- Defaults (usually a database!)
--------------------------------------
local defaults = {
	theme = {
		r = 0, 
		g = 0.8, -- 204/255
		b = 1,
		hex = "00ccff"
	}
}

--------------------------------------
-- Config functions
--------------------------------------
function Config:Toggle()
    core:Print("This is where I'd show the config menu...")
end

function Config:GetThemeColor()
	local c = defaults.theme;
	return c.r, c.g, c.b, c.hex;
end