local sui = {};
local utils = require('sui.utils');

sui.VERSION = '0.0.1';

sui.utils = utils;
sui.Button = require('sui.button');
sui.CheckBox = require('sui.checkbox');
sui.ProgressBar = require('sui.progressbar');
sui.RadioBox = require('sui.radiobox');
sui.TabPage = require('sui.tabpage');

local CONTEXT_LAYOUT = {
	view = 'div',
	style = {
		opacity = 0.95,
		['background-color'] = '#FFFFFF'
	}
};

local context;
local blocking = false;

function sui.createContext(layout, style)
	if layout == nil then layout = {} end
	utils.def(layout, CONTEXT_LAYOUT);
	return UI.createContext(layout, style);
end

function sui.show()
	context:show();
	sui.blocking();
end

function sui.close()
	context:close();
	blocking = false;
end

function sui.blocking(interval)
	interval = interval or 100;
	blocking = true;
	while blocking do sleep(interval) end
end

function sui.setContext(ctx)
	context = ctx;
	return ctx;
end

function sui.createView(SUILayout)
	if SUILayout == nil then SUILayout = {} end
	local layout = utils.clone(SUILayout);
	local subviews = {};
	if type(layout.subviews) == 'table' then
		for k, v in pairs(layout.subviews) do
			if type(v) ~= 'table' then
				table.insert(subviews, v);
				layout.subviews[k] = nil;
			end
		end
	end
	local view = context:createView(layout);
	for k, v in pairs(subviews) do
		view:addSubview(v, k);
	end
	return view;
end

function sui.createButton(SUILayout)
	return sui.Button.create(context, SUILayout);
end

function sui.createCheckBox(SUILayout)
	return sui.CheckBox.create(context, SUILayout);
end

function sui.createProgressBar(SUILayout)
	return sui.ProgressBar.create(context, SUILayout);
end

function sui.createRadioBox(SUILayout)
	return sui.RadioBox.create(context, SUILayout);
end

function sui.createTabPage(SUILayout)
	return sui.TabPage.create(context, SUILayout);
end

return sui;