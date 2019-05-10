local utils = require('sui.utils');
local wrapper = require('sui.wrapper');

local ProgressBar = {};
setmetatable(ProgressBar, {__index = wrapper});

local LAYOUT = {
	value = 0,
	style = {}
};

local STYLE = {
	width = 750,
	height = 8,
	opacity = 1,
	['border-radius'] = 4
};

local INNER_STYLE = {
	['border-radius'] = 4,
	['background-color'] = '#0196FF'
};


local count = 0;
function ProgressBar.create(context, SUILayout)
	if SUILayout == nil then SUILayout = {} end
	local layout = utils.clone(SUILayout);
	utils.def(layout, LAYOUT);
	if layout.id == nil then
		count = count + 1;
		layout.id = '@ProgressBar_' .. tostring(count);
	end
	layout.view = 'div';
	layout.subviews = {{view = 'div'}};
	local instantiation = {
		value = layout.value
	};
	layout.value = nil;
	setmetatable(instantiation, {__index = ProgressBar});
	instantiation.view = context:createView(layout);
	instantiation.innerView = instantiation.view:getSubview(1);
	utils.setDefaultStyle(instantiation.view, STYLE);
	utils.setDefaultStyle(instantiation.innerView, INNER_STYLE);
	instantiation.view:setStyle('border-radius', instantiation.view:getStyle('height') / 2);
	instantiation.innerView:setStyle('height', instantiation.view:getStyle('height'));
	instantiation.innerView:setStyle('border-radius', instantiation.view:getStyle('border-radius'));
	instantiation:setValue(instantiation.value);
	return instantiation;
end

function ProgressBar:getValue()
	return self.value;
end

function ProgressBar:setValue(value)
	if value > 100 then value = 100;
	elseif value < 0 then value = 0 end;
	self.value = value;
	self.innerView:setStyle('width', self.value / 100 * self.view:getStyle('width'));
end

return ProgressBar;