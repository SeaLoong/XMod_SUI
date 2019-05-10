local utils = {}

function utils.clone(t)
	if type(t) == 'table' then
		local ret = {};
		for k, v in pairs(t) do
			ret[k] = utils.clone(v);
		end
		return ret;
	end
	return t;
end

function utils.def(t1, t2)
	if type(t1) == 'table' and type(t2) == 'table' then
		for k, v in pairs(t2) do
			if t1[k] == nil then
				t1[k] = utils.clone(v);
			elseif type(v) == 'table' and type(t1[k]) == 'table' then
				utils.def(t1[k], v);
			end
		end
	end
end

function utils.defStyle(t1, t2)
	if type(t1) == 'table' and type(t2) == 'table' then
		local k1, k2;
		for k, v in pairs(t2) do
			k1 = utils.dash2camelcase(k);
			k2 = utils.camelcase2dash(k);
			if t1[k1] == nil and t1[k2] == nil then
				t1[k] = utils.clone(v);
			end
		end
	end
	return t1;
end

function utils.tableSelect(t1, t2)
	--	t1表示table有哪些key，t2表示这些key的value
	if type(t1) == 'table' and type(t2) == 'table' then
		local ret = {};
		for k, _ in pairs(t1) do
			ret[k] = t2[k];
		end
		return ret;
	end
end

function utils.camelcase2dash(str)
	for u in str:gmatch('%u') do
		str:gsub(u, '-' .. u);
	end
	return str;
end

function utils.dash2camelcase(str)
	for l in str:gmatch('%-(%l)') do
		str:gsub('-' .. l, string.upper(l));
	end
	return str;
end

function utils.setDefaultStyle(view, style)
	view:setStyle(utils.defStyle(view:getStyles(), style));
end

function utils.getBoxStyle(style)
	return {
		width = style.width,
		height = style.height,
		padding = style.padding,
		['padding-left'] = style['padding-left'],
		['padding-right'] = style['padding-right'],
		['padding-top'] = style['padding-top'],
		['padding-bottom'] = style['padding-bottom'],
		margin = style.margin,
		['margin-left'] = style['margin-left'],
		['margin-right'] = style['margin-right'],
		['margin-top'] = style['margin-top'],
		['margin-bottom'] = style['margin-bottom'],
		['border-left-width'] = style['border-left-width'],
		['border-right-width'] = style['border-right-width'],
		['border-top-width'] = style['border-top-width'],
		['border-bottom-width'] = style['border-bottom-width'],
		['border-radius'] = style['border-radius'],
		['border-bottom-left-radius'] = style['border-bottom-left-radius'],
		['border-bottom-right-radius'] = style['border-bottom-right-radius'],
		['border-top-left-radius'] = style['border-top-left-radius'],
		['border-top-right-radius'] = style['border-top-right-radius']
	};
end

function utils.getBoxMarginWidth(style)
	return (style['margin-left'] or style['margin'] or 0) + (style['margin-right'] or style['margin'] or 0);
end

function utils.getBoxBorderWidth(style)
	return (style['border-left-width'] or style['border-width'] or 0) + (style['border-right-width'] or style['border-width'] or 0);
end

function utils.getBoxPaddingWidth(style)
	return (style['padding-left'] or style['padding'] or 0) + (style['padding-right'] or style['padding'] or 0);
end

function utils.getBoxWidth(style)
	return utils.getBoxMarginWidth(style) + utils.getBoxBorderWidth(style) + utils.getBoxPaddingWidth(style) + (style['width'] or 0)
end

function utils.getBoxMarginHeight(style)
	return (style['margin-top'] or style['margin'] or 0) + (style['margin-bottom'] or style['margin'] or 0);
end

function utils.getBoxBorderHeight(style)
	return (style['border-top-width'] or style['border-width'] or 0) + (style['border-bottom-width'] or style['border-width'] or 0);
end

function utils.getBoxPaddingHeight(style)
	return (style['padding-top'] or style['padding'] or 0) + (style['padding-bottom'] or style['padding'] or 0);
end

function utils.getBoxHeight(style)
	return utils.getBoxMarginHeight(style) + utils.getBoxBorderHeight(style) + utils.getBoxPaddingHeight(style) + (style['height'] or 0)
end

function utils.lenSingle(inputstr)
	-- 计算字符串字符个数
	local lenInByte = #inputstr
	local len = 0
	local i = 1
	while (i <= lenInByte)
	do
		local curByte = inputstr:byte(i)
		local byteCount = 1;
		if curByte>0 and curByte<=127 then
			byteCount = 1
		elseif curByte>=192 and curByte<223 then
			byteCount = 2
		elseif curByte>=224 and curByte<239 then
			byteCount = 3
		elseif curByte>=240 and curByte<=247 then
			byteCount = 4
		end
		
		i = i + byteCount
		len = len + 1
	end
	return len
end

function utils.width(inputstr)
	-- 计算字符串字符宽度
	local lenInByte = #inputstr
	local width = 0
	local i = 1
	while (i <= lenInByte)
	do
		local curByte = inputstr:byte(i)
		local byteCount = 1;
		if curByte>0 and curByte<=127 then
			width = width + 1
			byteCount = 1
		else
			width = width + 2
			if curByte>=192 and curByte<223 then
				byteCount = 2
			elseif curByte>=224 and curByte<239 then
				byteCount = 3
			elseif curByte>=240 and curByte<=247 then
				byteCount = 4
			end
		end
		
		i = i + byteCount
	end
	return width
end

function utils.print(t)
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] = "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+4))
						print(indent..string.rep(" ",string.len(pos)+3).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] = "'..val..'"')
					else
						print(indent.."["..pos.."] = "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t,"  ")
		print("}")
	else
		sub_print_r(t,"  ")
	end
	print()
end

return utils;