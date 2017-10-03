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
	return s:gsub("%s+", " ") 
end

-- Capitalizes the first character of a string
function M.capitalize(s)
	return s:sub(1,1):upper()..s:sub(2)
end

-- Splits a string into a table based on a delimiter
-- split("a,b,c", ",") returns {"a", "b", "c"}
function M.split(s,delimiter)
	delimiter = delimiter or "%s"
	local t={}
	local i=1
	for str in string.gmatch(s, "([^"..delimiter.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

-- Joins a table into a single string seperated by a delimiter
function M.join(t,delimiter)
	delimiter = delimiter or " "
	return table.concat(t, delimiter)	
end

-- Replaces a set string within a string with another string
function M.replace(s,replace_this,replace_with)
end

-- Returns true if a string contains another string
function M.contains(s, target)
end

-- Returns where a string begins within another string or returns false
function M.where(s, target)
end


-- http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/6-b14/java/lang/String.java#String.compareTo%28java.lang.String%29
-- Compares two strings char by char until a difference is found
-- used in sorting based on char value
-- returns 0 if the two strings are equal
-- returns -1 if s1 is greater than s2
-- returns 1 if s2 is greater than s1
function M.compare(s1, s2)
end

-- Compares two strings like above but doesn't care about case
function M.compare_ignore_case(s1, s2)
end


return M
