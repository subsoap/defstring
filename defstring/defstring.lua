-- A module with a set of extra string functions for Defold

local M = {}

-- Trims text to remove whitespace before and after
function M.trim(s)
	return s:match('^%s*(.-)%s*$')
end

-- Only remove whitespace on left side of string
function M.trim_left(s)
	return s:match('^%s*(.-)$')
end

-- Only remove whitespace on right side of string
function M.trim_right(s)
	return s:match('^(.-)%s*$')
end

-- Replaces extra spaces (2 or more) with single spaces
function M.trim_extraspace(s)
	return s:gsub('%s+', ' ') 
end

-- Capitalizes the first character of a string
function M.capitalize(s)
	return s:sub(1,1):upper()..s:sub(2)
end

-- Capitalizes each word in a string
function M.capitalize_every_word(s)
	return (s:gsub('(%w[%w]*)', function (match) return M.capitalize(match) end))	
end

-- Splits a string into a table based on a delimiter
-- split('a,b,c', ',') returns {'a', 'b', 'c'}
function M.split(s,delimiter)
	delimiter = delimiter or '%s'
	local t={}
	local i=1
	for str in string.gmatch(s, '([^'..delimiter..']+)') do
		t[i] = str
		i = i + 1
	end
	return t
end

-- This version of split will include empty values (useful for parsing CSV files with empty cells properly)
function M.split_include_empty(s,delimiter)
	delimiter = delimiter or '%s'
	local t={}
	local i=1
	for str in string.gmatch(s .. delimiter, '([^' .. delimiter .. ']*)' .. delimiter) do
		t[i] = str
		i = i + 1
	end
	return t
end

-- Joins a table into a single string seperated by a delimiter
function M.join(t,delimiter)
	delimiter = delimiter or ' '
	return table.concat(t, delimiter)	
end

-- Replaces a set string within a string with another string
function M.replace(s,replace_this,replace_with)
	replace_with = M.escape(replace_with)
	return string.gsub(s,replace_this,replace_with)
end

-- Returns true if a target string contains another string
function M.contains(s, target)
	return s:find(target, nil, true) ~= nil
end

-- Returns the number of times a target string is within another string
function M.count(s, target)
	target = M.escape(target)
	local _, count = string.gsub(s, target, '')
	return count
end

-- Returns where the first copy of a target string begins and ends within another string or returns nil
function M.where(s, target)
	return string.find(s, target)
end


-- http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/6-b14/java/lang/String.java#String.compareTo%28java.lang.String%29
-- Compares two strings char by char until a difference is found
-- used in sorting based on char value
-- returns 0 if the two strings are equal
-- returns -1 if s1 is greater than s2
-- returns 1 if s2 is greater than s1
function M.compare(s1, s2)
	-- todo, might do add basic sorting too
end

-- Compares two strings like above but doesn't care about case
function M.compare_ignore_case(s1, s2)
end

-- Returns an iterator which will give one character of a string out at a time when called
function M.iterator(s)
	return s:gmatch('.')
end

-- Returns length of a string, here for completeness but you should probably use # directly instead
function M.length(s)
	return #s
end

-- Returns if a string is empty or not
function M.is_empty(s)
	return s == ''
end

-- Returns if a string begins with another target string
function M.is_beginning(s, target)
	return s:sub(1, #target) == target
end

-- Returns if a string ends with another target string
function M.is_ending(s, target)
	return s:sub(-#target) == target
end

-- Returns if a string is contained with a specific beginning and ending
-- leave ending blank to use beginning for both sides
function M.is_contained(s, beginning, ending)
	ending = ending or beginning
	return M.is_beginning(s, beginning) and M.is_ending(s, ending)

end

-- Inserts one string into another at a given position
function M.insert_into(s, position, target)
	local string_head = s:sub(0, position)
	local string_tail = s:sub(position+1)
	return string_head .. target .. string_tail	
end

-- Escapses Lua pattern characters for use in gsub
function M.escape(s)
	return (s:gsub('[[%]%%^$*()%.%+?-]', '%%%1'))
end

-- Returns string with listed chars within removed
function M.strip(s, remove_these_chars)
	return (s:gsub('['..M.escape(remove_these_chars)..']', ''))
end

-- Pads a character to the left until string is as long as length
function M.pad_left(s, pad, length)
	s = tostring(s)
	return (pad:rep(length) .. s):sub(-(length > #s and length or #s))
end

-- Pads a character to the right until string is as long as length
function M.pad_right(s, pad, length)
	s = tostring(s)
	return (s .. pad:rep(length)):sub(1, length > #s and length or #s)
end

-- Zero pads a string with leading zeroes until it is as long as length
function M.pad_zero(s, length)
	return M.pad_left(s, '0', length)
end

-- Adds commas between every third character from right to left
-- 10000000 becomes 10,000,000
function M.comma(s)
	s = tostring(s)
	while true do
		s, k = string.gsub(s, '^(-?%d+)(%d%d%d)', '%1,%2')
		if (k == 0) then
			break
		end
	end
	return s
end

-- List of javascript escape replacements
local javascript_escape_replacements = {
	['\\'] = '\\\\',
	['\0'] = '\\x00',
	['\b'] = '\\b',
	['\t'] = '\\t',
	['\n'] = '\\n',
	['\v'] = '\\v',
	['\f'] = '\\f',
	['\r'] = '\\r',
	['\''] = '\\\'',
	['\''] = '\\\''
}

-- Makes a string safe for use with Javascript
function M.make_javascript_safe(s)
	s = s:gsub('.', javascript_escape_replacements)
	s = s:gsub( '\226\128\168', '\\\226\128\168' ) -- U+2028
	s = s:gsub( '\226\128\169', '\\\226\128\169' ) -- U+2029
	return s
end

-- Returns characters from a string starting at left until number
function M.get_from_left(s, number)
	return string.sub(s, 1, number)
end

-- Returns characters from a starting starting at right until number
function M.get_from_right(s, number)
	return string.sub(s, -number)
end

-- Replaces the character of a position within a string with character(s)
function M.set_char(s, position, target)
	local string_head = s:sub(0, position-1)
	local string_tail = s:sub(position+1)
	return string_head .. target .. string_tail
end

-- Returns the character at a position from a string
function M.get_char(s, position)
	return s:sub(position,position)
end

-- Returns first word of a string
function M.get_first_word(s)
	return s:gmatch('%w+')()
end

-- Returns last word of a string
function M.get_last_word(s)
	return s:gmatch('(%w+)$')()
end

-- Removes last word of a string
function M.remove_last_word(s, number)
	number = number or 1
	for i=1, number, 1 do
		if s:find(' ') then
			s = string.match(s, '(.-)%s(%S+)$')
		else
			s = ''
		end
	end
	return s
end

-- Validates an e-mail address
function M.validate_email_address(s)
	if (s:match('[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?')) then
		return true
	else
		return false
	end
end

-- Checks if string contains only a-z, A-Z
function M.is_alphabetic(s)
	return not s:find('%A')
end

-- Checks if a string contains only 0-9
function M.is_numeric(s)
	return tonumber(s) and true or false
end

-- Removes any final newline character or space
function M.remove_final_newline(s)
	return M.trim_right(s)
end

-- Returns ordinal suffix (1st 2nd 3rd 4th) for a number
function M.ordinal_suffix(number)
	number = math.abs(number) % 100
	local d = number % 10
	if d == 1 and number ~= 11 then return 'st'
	elseif d == 2 and number ~= 12 then return 'nd'
	elseif d == 3 and number ~= 13 then return 'rd'
	else return 'th' end
end

-- Returns a string which is a concatenated number of copies of a string
function M.duplicate(s, number)
	local concatenation = ''
	for i=1,number, 1 do
		concatenation = concatenation .. s
	end
	return concatenation
end

-- Wraps a string to a table of strings without cutting off words
function M.wrap_to_table(s, limit)
	limit = limit or 72
	local here = 1
	local buffer = ''
	local t = {}
	s:gsub('(%s*)()(%S+)()',
	function(sp, st, word, fi)
		if fi-here > limit then
			here = st
			table.insert(t, buffer)
			buffer = word
		else
			buffer = buffer..sp..word
		end
	end)
	if(buffer ~= '') then
		table.insert(t, buffer)
	end
	return (t)	
end

-- Wraps a string to a character limit width paragraph
function M.wrap(s, limit)
	return table.concat(M.wrap_to_table(s, limit), '\n')
end

-- Shortens a string to a max length and adds a tail if you want (such as ...)
-- set reversed to true to start from line end to left
function M.shorten(s,length,tail,reversed)
	tail = tail or '...'
	if length < #tail then return tail:sub(1,w) end
	if #s > length then
		if reversed then
			local i = #s - length + 1 + #tail
			return tail .. s:sub(i)
		else
			return s:sub(1,length-#tail) .. tail
		end
	end
	return s
end

-- Removes line breaks
function M.remove_line_breaks(s)
	s, _ = string.gsub(s, '\n', ' ')
	return s
end

-- Removes all tabs
function M.remove_tabs(s)
	s, _ = string.gsub(s, '\t', '')
	return s
end

-- Executes arbitrary Lua code based on a string (can be dangerous!!)
-- useful for executing scripts based on loaded level data
-- if you have user levels you don't want to allow this without good filters
-- todo write a filter for this to optionally remove dangerous os functions?
-- or to whitelist certain list of functions only
function M.eval(s)
	return assert((loadstring or load)(s))()
end

-- Replace a table of variables within a string
-- s = "Hello, {player_name}!"
-- variable_list = {player_name = "Defold Master"}
function M.replace_variables(s, variable_list)
	if not variable_list then return s end
	local f = function(x)
		return tostring(variable_list[x] or variable_list[tonumber(x)] or "{" .. x .. "}")
	end
	return (s:gsub("{(.-)}", f))
end

-- Keeps all chars but those on the blacklist
function M.blacklist(s, blacklist, escapeflag)
	if escapeflag then
		return (s:gsub('['..M.escape(blacklist)..']', ''))
	else
		return (s:gsub('['..blacklist..']', ''))
	end
end

-- Removes all chars but those on the whitelist
function M.whitelist(s, whitelist, escapeflag)
	if escapeflag then
		return (s:gsub('[^'..M.escape(whitelist)..']', ''))
	else
		return (s:gsub('[^'..whitelist..']', ''))
	end
end

----------------------------------------------------------------
---						Richtext Functions					 --- 
----------------------------------------------------------------
---		Manual: https://defold.com/manuals/font-richtext/	 ---
----------------------------------------------------------------

-- --defstring Example
-- local t_text = "Testing Richtext"
-- t_text = deftext.get_text_replace_raw(t_text, "Richtext", defstring.rich_strike("Richtext"))
-- t_text = deftext.get_text_replace_raw(t_text, "Testing", defstring.rich_wave("Testing"))
-- t_text = defstring.rich_outline(t_text, 1, "#518fdbff")
-- t_text = defstring.rich_shadow(t_text, 1.5, -1, 5, "#000000ff")
-- t_text = defstring.rich_shake(t_text, 12, 0.5)
-- t_text = defstring.rich_ul(t_text)
-- t_text = defstring.rich_gradient(t_text, nil, nil, 3, 0.5, "reverse", nil, {tl="#2AF589", tr="#0B5227", bl="#6B4615", br="#F59C27"})
-- t_text = defstring.rich_gradient_cl(t_text, defstring.COLORS.GREY, defstring.MODE_VERTICAL)
-- node_set_text("textin_text", "("..t_text..")")

--locals 

M.MODE_HORIZONTAL = "horizontal"
M.MODE_VERTICAL = "vertical"
M.MODE_CORNERS = "corners"

M.PATTERN_DASHED = "dashed"
M.PATTERN_LINE = "solid"

M.DIRECTION_FORWARD = "forward"
M.DIRECTION_REVERSE = "reverse"

M.FIT_GLYPH = "glyph"
M.FIT_SPAN = "span"

--review: https://defold.com/manuals/font-richtext/#size for all options 
M.SIZE_TYPE_EM = "em"
M.SIZE_TYPE_PX = "px"

--Left/Right
--Bottom/Top
--customize with your own needs
M.COLORS = {
	CANDY = {"#FF0F7B", "#F89B29"},
	SKY_BLUE = {"#0061FF", "#60EFFF"},
	NEON = {"#00FF87", "#60EFFF"},
	DUSK = {"#FF1B6B", "#45CAFF"},
	LAVENDER = {"#696EFF", "#F8ACFF"},
	FIRE = {"#F7BA2C", "#EA5459"},
	
	DARK_PURPLE = {"#5c3294", "#de7df6"},
	TEAL = {"#169382", "#6dfff8"},
	BROWN = {"#633a11", "#feb54d"},
	GREY = {"#69686E", "#949399"}
}

local function valid_num(value)
	if value ~= nil and type(value) == "number" then return true end
	if value ~= nil then print("Valid value: Must be a number", value) end
	return false 
end

local function valid_fit(fit)
	if fit ~= nil and type(fit) == "string" then 
		if fit == M.FIT_GLYPH or fit == M.FIT_SPAN then 
			return true
		end
		print("Valid fit: glyph, glyph", fit)
	end
	return false 
end
local function valid_direction(direction)
	if direction ~= nil and type(direction) == "string" then 
		if direction == "reversed" then print("Direction should be reverse not reversed") direction = M.DIRECTION_REVERSE end
		if direction == M.DIRECTION_FORWARD or direction == M.DIRECTION_REVERSE then 
			return true
		end
		print("Valid direction: forward, reverse")
	end
	return false 
end
local function valid_pattern(pattern)
	if pattern ~= nil and type(pattern) == "string" then 
		if pattern == "dash" then print("pattern should be dashed not dash") pattern = M.PATTERN_DASHED end
		if pattern == M.PATTERN_LINE or pattern == M.PATTERN_DASHED then 
			return true
		end
		print("Valid ul Patterns: solid, dashed")
	end
	return false 
end
local function valid_size_type(size_type)
	if size_type ~= nil and type(size_type) == "string" then 
		if size_type == M.SIZE_TYPE_EM or size_type == M.SIZE_TYPE_PX then 
			return true
		end
		print("Valid size_type: px, em", size_type)
	end
	return false 
end

local function valid_hex(hex) -- this should work for 8 length too
	if hex == nil then 
		print("Color hex can not be nil")
		return false 
	end 
	hex = hex:gsub("#","")
	if (string.len(hex) == 6) or (string.len(hex) == 8) then
		local num_1 = tonumber("0x"..hex:sub(1, 2))
		local num_2 = tonumber("0x"..hex:sub(3, 4))
		local num_3 = tonumber("0x"..hex:sub(5, 6))

		if num_1 ~= nil and num_2 ~= nil and num_3 ~= nil then 
			if (string.len(hex) == 8) then --checks alpha values
				local num_4 = tonumber("0x"..hex:sub(7, 8))
				if num_4 == nil then 
					return false
				end
			end
			return true
		else
			return false
		end
	else
		return false
	end
end

local function min_max(min, max, value)
	return math.min(math.max(value, min), max)
end

local function alpha_to_hex(alpha)
	alpha = min_max(0, 1, alpha)
	local alpha_int = math.floor(alpha * 255 + 0.5)
	local alpha_hex = string.format("%02X", alpha_int)
	return alpha_hex
end

--functions 

function M.rich_color(text, hex_color, alpha)
	if hex_color == nil then hex_color = "#FFFFFF" end
	local hex_len = string.len(hex_color:gsub("#",""))
	if alpha ~= nil and type(alpha) == "number" and (hex_len == 6) then 
		hex_color = hex_color..alpha_to_hex(alpha)
	end
	if valid_hex(hex_color) then 
		return "<color="..hex_color..">"..text.."</color>"
	end
	print("HEX: "..hex_color.." was invalid!", "<color="..hex_color..">"..text.."</color>")
	return text
end

function M.rich_size_px(text, value, use_percent)
	-- <size=24px>Exactly 24 pixels</size>
	-- <size=120%>120% of the layout base size</size>

	if value ~= nil and type(value) == "number" then 
		local s_type = "px"
		if use_percent then s_type = "%" end
		return "<size="..value..s_type..">"..text.."</size>"
	end
	--print("value was nil")
	return text
end

--modes: horizontal/1, vertical/2, corners/3
--direction: forward, reverse		--Controls the flow direction when hz is non-zero.
--fit: glyph, span
--corners: tl, tr, bl, br			--Top-left, top-right, bottom-left, and bottom-right colors. All four must be present.
--Used with M.COLORS or any table with 2 hex color strings {"#333333", "#FFFFFF"}
function M.rich_gradient_cl(text, colors, mode, hz, direction, fit, corners)
	if type(colors) ~= "table" then 
		print("colors must be a table: {\"#333333\", \"#FFFFFF\"}")
		return text
	 end 
	return M.rich_gradient(text, colors[1], colors[2], mode, hz, direction, fit, corners)
end

function M.rich_gradient(text, cl_x, cl_y, mode, hz, direction, fit, corners)
	-- <gradient left=#FF00FF right=#FFFFFF>Horizontal Gradient</gradient>
	-- <gradient hz=0.25 fit=glyph bottom=#182848 top=#4B6CB7>Animated vertical glyphs</gradient>
	-- <gradient hz=0.25 direction=reverse left=#FF0000 right=#0000FF>Reverse flow</gradient>
	-- <gradient hz=0.25 direction=reverse fit=span left=#FF0000 right=#0000FF>One animated span color</gradient>
	--<gradient fit=glyph tl=#FF0000 tr=#00FF00 bl=#0000FF br=#FFFFFF>Four corners</gradient>

	if mode == nil then mode = M.MODE_HORIZONTAL end 
	mode = tostring(mode)
	
	local horizontal_mode = {["horizontal"] = true, ["1"] = true}
	local vertical_mode = {["vertical"] = true, ["2"] = true}
	local corners_mode = {["corners"] = true, ["3"] = true}

	local build_text = "<gradient"

	if valid_num(hz) then build_text = build_text .. " hz="..hz end
	if valid_direction(direction) then build_text = build_text .. " direction="..direction end
	if valid_fit(fit) then build_text = build_text .. " fit="..fit end

	if valid_hex(cl_x) and valid_hex(cl_y) then 
		if horizontal_mode[mode] ~= nil then 
			build_text = build_text .. " left="..cl_x.." right="..cl_y
		elseif vertical_mode[mode] ~= nil then 
			build_text = build_text .. " bottom="..cl_x.." top="..cl_y
		end
	else
		if corners_mode[mode] ~= nil then 
			if corners.tl ~= nil and corners.tr ~= nil and corners.bl ~= nil and corners.br ~= nil then 
				if valid_hex(corners.tl) and valid_hex(corners.tr) and valid_hex(corners.bl) and valid_hex(corners.br) then 
					build_text = build_text .. " tl="..corners.tl.." tr="..corners.tr.." bl="..corners.bl.." br="..corners.br
				end
			end
		end
	end
	build_text = build_text .. ">"..text.."</gradient>"
	
	return build_text
end

function M.rich_ul(text, pattern)
	-- <ul>Solid underline</ul>
	-- <ul pattern=dashed>Dashed underline</ul>
	local build_text = "<ul"
	if valid_pattern(pattern) then build_text = build_text .. " pattern="..pattern end
	build_text = build_text .. ">"..text.."</ul>"

	return build_text
end

function M.rich_strike(text, pattern)
	-- <strike>No longer available</strike>
	-- <strike pattern=dashed>Dashed strikethrough</strike>
	local build_text = "<strike"
	if valid_pattern(pattern) then build_text = build_text .. " pattern="..pattern end
	build_text = build_text .. ">"..text.."</strike>"

	return build_text
end

--note your .font needs to have the extremes set in order to use this
function M.rich_outline(text, size, color)
	-- <outline size=3 color=#000000>Black outline</outline>
	-- <outline color=#FF0000>Keep inherited width, change color</outline>
	-- <outline size=0>Disable inherited outline</outline>
	local build_text = "<outline"
	if valid_hex(color) then build_text = build_text .. " color="..color end
	if valid_num(size) then build_text = build_text .. " size="..size end
	build_text = build_text .. ">"..text.."</outline>"
	return build_text
end

--note your .font needs to have the extremes set in order to use this
function M.rich_shadow(text, x, y, blur, color)
	-- <shadow x=6 y=-6 blur=4 color=#000000A0>Shadow</shadow>
	-- <shadow x=-2>Override only the horizontal offset</shadow>
	local build_text = "<shadow"
	if valid_num(x) then build_text = build_text .. " x="..x end
	if valid_num(y) then build_text = build_text .. " y="..y end
	if valid_num(blur) then build_text = build_text .. " blur="..blur end
	if valid_hex(color) then build_text = build_text .. " color="..color end
	build_text = build_text .. ">"..text.."</shadow>"
	return build_text
end

function M.rich_shake(text, hz, amplitude, fit)
	--<shake>Default shake</shake>
	-- <shake hz=12 amplitude=0.8 fit=glyph>Glyph shake</shake>
	-- <shake hz=12 amplitude=0.8 fit=span>Rigid span shake</shake>
	local build_text = "<shake"
	if valid_num(hz) then build_text = build_text .. " hz="..hz end
	if valid_num(amplitude) then build_text = build_text .. " amplitude="..amplitude end
	if valid_fit(fit) then build_text = build_text .. " fit="..fit end
	build_text = build_text .. ">"..text.."</shake>"
	
	return build_text
end

function M.rich_wave(text, hz, amplitude, wavelength, direction, fit)
	-- <wave>Animated character wave</wave>
	-- <wave amplitude=4 hz=3 wavelength=8 fit=glyph>Travelling wave</wave>
	-- <wave amplitude=4 hz=3 wavelength=8 fit=glyph direction=reverse>Reverse travelling wave</wave>
	-- <wave amplitude=4 hz=1 fit=span>Whole span moves together</wave>
	local build_text = "<wave"
	if valid_num(hz) then build_text = build_text .. " hz="..hz end
	if valid_num(amplitude) then build_text = build_text .. " amplitude="..amplitude end
	if valid_num(wavelength) then build_text = build_text .. " wavelength="..wavelength end
	if valid_fit(fit) then build_text = build_text .. " fit="..fit end
	if valid_direction(direction) then build_text = build_text .. " direction="..direction end
	build_text = build_text .. ">"..text.."</wave>"

	return build_text
end

function M.rich_sprite(source_id, width, height, size_type)
	-- A <sprite src=engine/engine/content/builtins/assets/images/logo/logo_256.png/> logo
	-- <sprite src=images/banner.png width=4em height=2em/>
	-- <sprite src=images/icons.atlas animation=coin width=2em/>

	--<sprite src=_assets/misc/chat_atlas.atlas animation=pure_coin width=32px/>
	
	-- Here is the <sprite src=/main/defold-logo.png width=1em height=1em/> Defold Logo

	--<sprite src=/main/defold-logo.png width=1em height=1em/>

	if source_id == nil then return "" end
	if not valid_size_type(size_type) then size_type = "px" end 
	if not valid_num(width) then width = 32 end 
	if not valid_num(height) then height = 32 end 
	
	local build_text = "<sprite"
	build_text = build_text .. " src="..source_id
	build_text = build_text .. " width="..width..size_type
	build_text = build_text .. " height="..height..size_type
	build_text = build_text .. "/>"
	
	return build_text
end

function M.rich_sprite_apply(text_label, image, source_id, adjust_position)
	if adjust_position == nil then adjust_position = vmath.vector3(0) end 
	if type(text_label) == "string" then 
		msg.post(image, "disable")
		for _, object in ipairs(label.get_layout_objects(text_label)) do
			if object.type == "sprite" and object.attributes.src == source_id then
				local label_origin = go.get_position(text_label)
				local label_scale = go.get_scale(text_label)
				local object_center = vmath.vector3((object.x + object.width * 0.5)*label_scale.x, (object.y + object.height * 0.5)*label_scale.y, 0)
				go.set_position(label_origin + object_center + adjust_position, image)
				go.set_scale(vmath.vector3(object.width, object.height, 1), image)
				msg.post(image, "enable")
			end
		end
	elseif type(text_label) == "userdata" then 
		gui.set_enabled(image, false)
		for _, object in ipairs(gui.get_layout_objects(text_label)) do
			if object.type == "sprite" and object.attributes.src == source_id then
				local text_position = gui.get_position(text_label)
				local text_scale = gui.get_scale(text_label)
				local object_center = vmath.vector3((object.x + object.width * 0.5)*text_scale.x, (object.y + object.height * 0.5)*text_scale.y, 0)
				gui.set_position(image, text_position + object_center + adjust_position)
				gui.set_size_mode(image, gui.SIZE_MODE_MANUAL)	--needs to be manual
				gui.set_size(image, vmath.vector3(object.width, object.height, 1))
				gui.set_enabled(image, true)
			end
		end
	end
end
 
function M.rich_link(text, id, src, style, extras, use_ul)
	-- -<ul><link id=website src=https://www.defold.com>www.defold.com</link></ul>
	-- <link id=inventory style=menu_link action=open_inventory item=sword>Iron sword</link>
	-- extras = {action="open_inventory", item="sword"}	--example of extras
	
	local build_text = "<link"
	build_text = build_text .. " id="..id
	build_text = build_text .. " src="..src
	if style ~= nil then build_text = build_text .. " style="..style end
	if extras ~= nil then 
		for k, v in pairs(extras) do 
			build_text = build_text .. " "..k.."="..extras[k]
		end
	end
	build_text = build_text ..">".. text.. "</link>"
	if use_ul then 
		build_text = M.rich_ul(build_text)
	end
	return build_text
end

return M
