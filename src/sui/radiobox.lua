local utils = require('sui.utils');
local wrapper = require('sui.wrapper');

local RadioBox = {};
setmetatable(RadioBox, {__index = wrapper});

local LAYOUT = {
	checked = false,
	direction = 0,
	group = '',
	style = {},
	text = { -- 或string类型
		style = {},
		value = ''
	},
	image = {
		style = {},
		res = {
			unchecked = 'xsp://sui/radiobox/unchecked.png',
			checked = 'xsp://sui/radiobox/checked.png',
			unchecked_disabled = 'xsp://sui/radiobox/unchecked_disabled.png',
			checked_disabled = 'xsp://sui/radiobox/checked_disabled.png'
		}
	}
};

local STYLE = {
	opacity = 1,
	['align-items'] = 'center',
	['justify-content'] = 'flex-start',
	['flex-direction'] = 'row',
	['background-color'] = '#FFFFFF'
};

local TEXT_STYLE = {
	lines = 1,
	['text-align'] = 'center',
	['font-size'] = 16,
	['color:disabled'] = 'rgba(0, 0, 0, 0.3)'
};

local IMAGE_STYLE = {
	width = 24,
	height = 24
};


local groups = {};
local count = 0;
function RadioBox.create(context, SUILayout)
	if SUILayout == nil then SUILayout = {} end
	local layout = utils.clone(SUILayout);
	utils.def(layout, LAYOUT);
	if layout.id == nil then
		count = count + 1;
		layout.id = '@RadioBox_' .. tostring(count);
	end
	layout.view = 'div';
	layout.subviews = {{},{}};
	local textIndex, imageIndex = 1, 2;
	if layout.direction then textIndex, imageIndex = 2, 1; end
	layout.subviews[textIndex] = utils.tableSelect(LAYOUT.text, layout.text) or {value = tostring(layout.text)};
	layout.subviews[textIndex].view = 'text';
	layout.subviews[imageIndex] = {style = layout.image.style};
	layout.subviews[imageIndex].view = 'image';
	local instantiation = {
		checked = layout.checked,
		group = layout.group,
		res = layout.image.res
	};
	layout.checked = nil;
	layout.direction = nil;
	layout.group = nil;
	layout.text = nil;
	layout.image = nil;
	setmetatable(instantiation, {__index = RadioBox});
	instantiation.view = context:createView(layout);
	instantiation.textView = instantiation.view:getSubview(textIndex);
	instantiation.imageView = instantiation.view:getSubview(imageIndex);
	utils.setDefaultStyle(instantiation.view, STYLE);
	utils.setDefaultStyle(instantiation.textView, TEXT_STYLE);
	utils.setDefaultStyle(instantiation.imageView, IMAGE_STYLE);
	instantiation:setDisabled(layout.disabled);
	instantiation:setChecked(instantiation.checked);
	instantiation:setGroup(instantiation.group);
	instantiation:onClick();
	return instantiation;
end

function RadioBox:getText()
	return self.textView:getAttr('value');
end

function RadioBox:setText(text)
	self.textView:setAttr('value', text);
end

function RadioBox:getGroup()
	return self.group;
end

function RadioBox:setGroup(group)
	local oldGroup = self:getGroup();
	if oldGroup and type(groups[oldGroup]) == 'table' then
		for i, v in pairs(groups[oldGroup]) do
			if v == self then
				table.remove(groups[oldGroup], i);
				break;
			end
		end
	end
	if not groups[group] then groups[group] = {} end
	table.insert(groups[group], self);
	self.group = group;
end

function RadioBox:getChecked()
	return self.checked;
end

function RadioBox:setChecked(checked)
	self.checked = checked and true or false;
	if self.checked and self:getGroup() ~= nil then
		for _, v in ipairs(groups[self:getGroup()]) do
			if v ~= self then
				v:setChecked(false);
			end
		end
	end
	self.imageView:setAttr('src', self.res[(self.checked and 'checked' or 'unchecked') .. (self:getDisabled() and '_disabled' or '')]);
end

function RadioBox:setDisabled(disabled, ...)
	wrapper.setDisabled(self, disabled, ...);
	self.imageView:setAttr('src', self.res[(self.checked and 'checked' or 'unchecked') .. (self:getDisabled() and '_disabled' or '')]);
end

function RadioBox:onClick(fn)
	return self.view:setActionCallback(UI.ACTION.CLICK, function (...)
			self:setChecked(not self:getChecked());
			return fn and fn(self:getChecked(), ...) or nil;
		end);
end

return RadioBox;