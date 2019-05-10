local utils = require('sui.utils');
local wrapper = require('sui.wrapper');

local ComboBox = {};
setmetatable(ComboBox, {__index = wrapper});

local LAYOUT = {
	text = '',
	placeHolder = '',
	index = 1,
	style = {},
	text = {
		style = {},
		value = ''
	},
	image = {
		style = {},
		src = 'xsp://sui/ComboBox/unchecked.png'
	}
};

local STYLE = {
	width = 120,
	height = 60,
	opacity = 1,
	['align-items'] = 'center',
	['justify-content'] = 'center',
	['flex-direction'] = 'row',
	['background-color'] = '#FFFFFF'
};

local TEXT_STYLE = {
	lines = 1,
	['text-align'] = 'center',
	['font-size'] = 24,
	['color:disabled'] = 'rgba(0, 0, 0, 0.3)'
};

local IMAGE_STYLE = {
	width = 48,
	height = 48
}

local count = 0;
function ComboBox.create(context, SUILayout)
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
	layout.text.view = 'text';
	layout.subviews[textIndex] = layout.text;
	layout.image.view = 'image';
	layout.subviews[imageIndex] = layout.image;
	local instantiation = {
		checked = layout.checked
	};
	layout.checked = nil;
	layout.direction = nil;
	layout.text = nil;
	layout.image = nil;
	setmetatable(instantiation, {__index = ComboBox});
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

function ComboBox:getText()
	return self.textView:getAttr('value');
end

function ComboBox:setText(text)
	self.textView:setAttr('value', text);
end

function ComboBox:getChecked()
	return self.checked;
end

function ComboBox:setChecked(checked)
	self.checked = checked and true or false;
	self.imageView:setAttr('src', 'xsp://sui/ComboBox/' .. (self.checked and 'checked' or 'unchecked') .. (self:getDisabled() and '_disabled' or '') .. '.png');
end

function ComboBox:onClick(fn)
	return self.view:setActionCallback(UI.ACTION.CLICK, function (...)
			self:setChecked(not self:getChecked());
			return fn and fn(self:getChecked(), ...) or nil;
		end);
end

return ComboBox;