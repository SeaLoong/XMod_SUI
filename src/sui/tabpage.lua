local utils = require('sui.utils');
local wrapper = require('sui.wrapper');

local TabPage = {};
setmetatable(TabPage, {__index = wrapper});

local LAYOUT = {
	index = 1,
	style = {},
	pages = {
		{
			title = '',
			content = {}
		}
	}
};

local STYLE = {
	width = 734,
	height = 1500,
	margin = 8
};

local TITLE_STYLE = {
	lines = 1,
	color = '#000000',
	['font-size'] = 16,
	['text-align'] = 'center',
	['font-weight'] = 'normal',
	['margin-left'] = 2,
	['margin-right'] = 2,
	['border-bottom-width'] = 2,
	['border-bottom-color'] = 'transparent'
};

local TITLE_SELECTED_STYLE = {
	color = '#0455E5',
	['font-weight'] = 'bold',
	['border-bottom-color'] = '#0455E5'
};


local count = 0;
function TabPage.create(context, SUILayout)
	if SUILayout == nil then SUILayout = {} end
	local layout = utils.clone(SUILayout);
	utils.def(layout, LAYOUT);
	if layout.id == nil then
		count = count + 1;
		layout.id = '@TabPage_' .. tostring(count);
	end
	layout.view = 'div';
	layout.subviews = {
		{
			view = 'scroller',
			['show-scrollbar'] = false,
			['scroll-direction'] = 'horizontal',
			style = {
				height = 24,
				['flex-direction'] = 'row'
			},
			subviews = {}
		},
		{
			view = 'div',
			style = {
				overflow = 'hidden',
				['padding-top'] = 4
			},
			subviews = {}
		}
	};
	local index = layout.index;
	local pages = layout.pages;
	local instantiation = {
		context = context,
		index = nil,
		pageCount = 0,
		titleViewMap = {},
		wrapDivViewMap = {},
		selectHandler = nil
	};
	layout.index = nil;
	layout.pages = nil;
	setmetatable(instantiation, {__index = TabPage});
	instantiation.view = context:createView(layout);
	instantiation.titlesView = instantiation.view:getSubview(1);
	instantiation.contentsView = instantiation.view:getSubview(2);
	utils.setDefaultStyle(instantiation.view, STYLE);
	instantiation.contentsView:setStyle({
			width = instantiation.view:getStyle('width') - utils.getBoxPaddingWidth(instantiation.view:getStyles()),
			height = instantiation.view:getStyle('height') - utils.getBoxHeight(instantiation.titlesView:getStyles()),
		});
	for i, v in pairs(pages) do
		instantiation:addPage(v.title, v.content);
	end
	instantiation:setDisabled(layout.disabled);
	instantiation:setIndex(index);
	return instantiation;
end

function TabPage:getIndex()
	return self.index;
end

function TabPage:setIndex(index)
	local oldIndex = self:getIndex();
	if not index or index == oldIndex then return end
	
	self.titleViewMap[index]:setStyle(TITLE_SELECTED_STYLE);
	self.wrapDivViewMap[index]:setStyle('height', self.contentsView:getStyle('height'));
	
	if oldIndex then
		self.titleViewMap[oldIndex]:setStyle(TITLE_STYLE);
		self.wrapDivViewMap[oldIndex]:setStyle('height', 0);
	end
	
	self.index = index;
	utils.print(self)
	if type(self.selectHandler) == 'function' then self.selectHandler(index) end
end

function TabPage:getPageCount()
	return self.pageCount;
end

function TabPage:onSelect(fn)
	self.selectHandler = fn;
end

function TabPage:addPage(title, content)
	local titleView = self.context:createView({view = 'text', value = title});
	utils.setDefaultStyle(titleView, TITLE_STYLE);
	titleView:setStyle('width', 24 + 8 * utils.width(title));
	
	if content == nil then content = {view = 'div'} end
	local contentView = type(content) == 'table' and self.context:createView(content) or content;
	
	local wrapDivView = self.context:createView({
			view = 'div',
			style = {
				width = self.contentsView:getStyle('width') - utils.getBoxPaddingWidth(self.contentsView:getStyles()),
				height = 0
			},
			subviews = {}
		});
	
	wrapDivView:addSubview(contentView);
	
	self.titlesView:addSubview(titleView);
	self.contentsView:addSubview(wrapDivView);
	
	self.pageCount = self.pageCount + 1;
	local index = self.pageCount;
	
	self.titleViewMap[index] = titleView;
	self.wrapDivViewMap[index] = wrapDivView;
	
	titleView:setActionCallback(UI.ACTION.CLICK, function ()
			self:setIndex(index);
		end);
	
	
end

function TabPage:removePage(index)
	self.titleViewMap[index]:removeFromParent();
	self.wrapDivViewMap[index]:removeFromParent();
	
	for i = index, self.pageCount - 1 do
		self.titleViewMap[i] = self.titleViewMap[i + 1];
		self.wrapDivViewMap[i] = self.wrapDivViewMap[i + 1];
	end
	self.titleViewMap[self.pageCount] = nil;
	self.wrapDivViewMap[self.pageCount] = nil;
	
	self.pageCount = self.pageCount - 1;
end

function TabPage:getTitle(index)
	return self.titleViewMap[index]:getAttr('value');
end

function TabPage:setTitle(index, text)
	self.titleViewMap[index]:setAttr('value', text);
end

function TabPage:getContentView(index)
	return self.wrapDivViewMap[index]:subviewsCount() and self.wrapDivViewMap[index]:getSubview(1) or nil;
end

function TabPage:setContentView(index, contentView)
	if self.wrapDivViewMap[index]:subviewsCount() then self.wrapDivViewMap[index]:removeSubview(1) end
	self.wrapDivViewMap[index]:addSubview(contentView);
end

return TabPage;