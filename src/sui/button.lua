local utils = require('sui.utils');
local wrapper = require('sui.wrapper');

local Button = {};
setmetatable(Button, {__index = wrapper});

local LAYOUT = { -- 声明在这里的style的优先级比class的高
	style = {},
	text = { -- 也可以是string类型
		style = {},
		value = ''
	}
};
-- 声明在这下面的style的优先级比class的低
local STYLE = {
	opacity = 1,
	['align-items'] = 'center',
	['justify-content'] = 'center',
	['border-color'] = '#A5A5A5',
	['border-width'] = 1,
	['border-radius'] = 8,
	['background-color'] = '#FFFFFF',
	['background-color:active'] = '#DDDDDD',
	['border-width:disabled'] = 0,
	['background-color:disabled'] = 'rgba(0, 0, 0, 0.3)',
	['opacity:disabled'] = 0.3
};

local TEXT_STYLE = {
	lines = 1,
	['text-align'] = 'center',
	['font-size'] = 16
};

local count = 0; -- 记录没有设置id的Button的数量
function Button.create(context, SUILayout)
	if SUILayout == nil then SUILayout = {} end
	local layout = utils.clone(SUILayout); -- 把所有键值对复制到layout中
	utils.def(layout, LAYOUT);
	if layout.id == nil then
		count = count + 1;
		layout.id = '@Button_' .. tostring(count);
	end
	layout.view = 'div';
	layout.subviews = {};
	layout.subviews[1] = utils.tableSelect(LAYOUT.text, layout.text) or {value = tostring(layout.text)};
	layout.subviews[1].view = 'text';
	local instantiation = {};
	layout.text = nil;
	setmetatable(instantiation, {__index = Button});
	--	创建view
	instantiation.view = context:createView(layout);
	instantiation.textView = instantiation.view:getSubview(1);
	--	由于class是在createView之后才会导入到style，这里需要处理style
	--	期望的style优先级：默认style < class定义的 < 内联style
	--	实际的style优先级：class定义的 < 默认style(通过内联方式定义的) < 内联style
	--  处理后基本可达期望情况
	utils.setDefaultStyle(instantiation.view, STYLE);
	utils.setDefaultStyle(instantiation.textView, TEXT_STYLE);
	--	可以修改的属性都会封装getter和setter
	instantiation:setDisabled(layout.disabled); -- 特别的，disabled属性由wrapper封装以保证能生效
	return instantiation;
end

function Button:getText()
	return self.textView:getAttr('value');
end

function Button:setText(text)
	self.textView:setAttr('value', text);
end

return Button;