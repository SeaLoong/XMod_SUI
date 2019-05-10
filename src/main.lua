
local SUI = require('sui.sui')

local ctx = SUI.setContext(SUI.createContext());
local root = ctx:getRootView();


local bar = SUI.createProgressBar({value = 58, style = {width = 200, height = 20}});
local btn_plus = SUI.createButton({text = '+', style = {width = 20, height = 20}});
btn_plus:onClick(function()
	bar:setValue(bar:getValue() + 1);
end);
btn_plus:onLongPress(function()
	bar:setValue(bar:getValue() + 10);
end);
local btn_minus = SUI.createButton({text = '-', style = {width = 20, height = 20}});
btn_minus:onClick(function()
	bar:setValue(bar:getValue() - 1);
end);
btn_minus:onLongPress(function()
	bar:setValue(bar:getValue() - 10);
end);

local tab = SUI.createTabPage({
		index = 1,
		pages = {
			{
				title = 'Page1',
				content = SUI.createButton({text = 'This is a button'}):getView()
			},
			{
				title = 'Page2',
				content = SUI.createCheckBox({text = 'This is a checkbox'}):getView()
			},
			{
				title = 'Page3',
				content = SUI.createRadioBox({text = 'This is a radiobox'}):getView()
			},
			{
				title = 'Page4',
				content = SUI.createView({
					view = 'div',
					style = {
						width = 400,
						height = 20,
						['flex-direction'] = 'row'
					},
					subviews = {
						bar:getView(),
						btn_plus:getView(),
						btn_minus:getView()
					}
				})
			}
		}
	});

tab:onSelect(function (index)
--		tab:setTitle(index, '???');
	end);

local btn_close = SUI.createButton({text = 'X', style = {position = 'fixed', top = 0, right = 0, width = 20, height = 20}});
btn_close:onClick(function()
	SUI.close();
end);

root:addSubview(btn_close:getView());
root:addSubview(tab:getView());

SUI.show();