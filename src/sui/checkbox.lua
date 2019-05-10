local utils = require('sui.utils');
local wrapper = require('sui.wrapper');

local CheckBox = {};
setmetatable(CheckBox, {__index = wrapper});

local LAYOUT = {
	checked = false,
	direction = 0,
	style = {},
	text = { -- 或string类型
		style = {},
		value = ''
	},
	image = {
		style = {},
		res = {
			unchecked = 'xsp://sui/checkbox/unchecked.png',
			checked = 'xsp://sui/checkbox/checked.png',
			unchecked_disabled = 'xsp://sui/checkbox/unchecked_disabled.png',
			checked_disabled = 'xsp://sui/checkbox/checked_disabled.png'
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
}

local count = 0;
function CheckBox.create(context, SUILayout)
	if SUILayout == nil then SUILayout = {} end
	local layout = utils.clone(SUILayout);
	utils.def(layout, LAYOUT);
	if layout.id == nil then
		count = count + 1;
		layout.id = '@CheckBox_' .. tostring(count);
	end
	layout.view = 'div';
	layout.subviews = {{},{}};
	local textIndex, imageIndex = 1, 2;
	if layout.direction then textIndex, imageIndex = 2, 1; end  -- direction之后不可修改，改了也没用
	layout.subviews[textIndex] = utils.tableSelect(LAYOUT.text, layout.text) or {value = tostring(layout.text)};
	layout.subviews[textIndex].view = 'text';
	layout.subviews[imageIndex] = {style = layout.image.style};
	layout.subviews[imageIndex].view = 'image';
	local instantiation = {
		checked = layout.checked,
		res = layout.image.res
	};
	layout.checked = nil;
	layout.direction = nil;
	layout.text = nil;
	layout.image = nil;
	setmetatable(instantiation, {__index = CheckBox});
	instantiation.view = context:createView(layout);
	instantiation.textView = instantiation.view:getSubview(textIndex);
	instantiation.imageView = instantiation.view:getSubview(imageIndex);
	utils.setDefaultStyle(instantiation.view, STYLE);
	utils.setDefaultStyle(instantiation.textView, TEXT_STYLE);
	utils.setDefaultStyle(instantiation.imageView, IMAGE_STYLE);
	instantiation:setDisabled(layout.disabled);
	instantiation:setChecked(instantiation.checked);
	instantiation:onClick();
	return instantiation;
end

function CheckBox:getText()
	return self.textView:getAttr('value');
end

function CheckBox:setText(text)
	self.textView:setAttr('value', text);
end

function CheckBox:getChecked()
	return self.checked;
end

function CheckBox:setChecked(checked)
	self.checked = checked and true or false;
	self.imageView:setAttr('src', self.res[(self.checked and 'checked' or 'unchecked') .. (self:getDisabled() and '_disabled' or '')]);
end

function CheckBox:setDisabled(disabled, ...)
	wrapper.setDisabled(self, disabled, ...);
	self.imageView:setAttr('src', self.res[(self.checked and 'checked' or 'unchecked') .. (self:getDisabled() and '_disabled' or '')]);
end

function CheckBox:onClick(fn)
	return self.view:setActionCallback(UI.ACTION.CLICK, function (...)
			self:setChecked(not self:getChecked());
			return fn and fn(self:getChecked(), ...) or nil;
		end);
end

return CheckBox;