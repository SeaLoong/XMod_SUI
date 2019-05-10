local utils = require('sui.utils');
local wrapper = {};
--setmetatable(wrapper, {_index = wrapper});

function wrapper:getID()
	return self.view:getID();
end

function wrapper:getType()
	return self.view:getType();
end

function wrapper:getAttr(...)
	return self.view:getAttr(...);
end

function wrapper:getAttrs()
	return self.view:getAttrs();
end

function wrapper:getStyle(...)
	return self.view:getStyle(...);
end

function wrapper:getStyles()
	return self.view:getStyles();
end

function wrapper:setAttr(...)
	return self.view:setAttr(...);
end

function wrapper:setStyle(...)
	return self.view:setStyle(...);
end

function wrapper:subviewsCount()
	return self.view:subviewsCount();
end

function wrapper:getSubview(...)
	return self.view:getSubview(...);
end

function wrapper:addSubview(...)
	return self.view:addSubview(...);
end

function wrapper:removeSubview(...)
	return self.view:removeSubview(...);
end

function wrapper:removeFromParent()
	return self.view:removeFromParent();
end

function wrapper:setActionCallback(...)
	return self.view:setActionCallback(...);
end

function wrapper:toJson()
	return self.view:toJson();
end

--Custom

function wrapper:getView()
	return self.view;
end

function wrapper:getDisabled()
	return self.view:getAttr('disabled');
end

function wrapper:setDisabled(disabled)
	disabled = disabled and true or false;
	self:forEachSubview(function (view)
			view:setAttr('disabled', disabled);
		end);
	return self.view:setAttr('disabled', disabled);
end

function wrapper:forEachAttr(fn)
	for k, v in pairs(self.view:getAttrs()) do
		fn(k, v);
	end
end

function wrapper:forEachStyle(fn)
	for k, v in pairs(self.view:getStyles()) do
		fn(k, v);
	end
end

function wrapper:forEachSubview(fn)
	for i = 1, self.view:subviewsCount() do
		fn(self.view:getSubview(i));
	end
end

--Callback

function wrapper:onAppear(fn, view)
	view = view or 'view';
	return self[view]:setActionCallback(UI.ACTION.APPEAR, fn);
end

function wrapper:onDisappear(fn, view)
	view = view or 'view';
	return self[view]:setActionCallback(UI.ACTION.DISAPPER, fn);
end

function wrapper:onClick(fn, view)
	view = view or 'view';
	return self[view]:setActionCallback(UI.ACTION.CLICK, fn);
end

function wrapper:onLongPress(fn, view)
	view = view or 'view';
	return self[view]:setActionCallback(UI.ACTION.LONG_PRESS, fn);
end

function wrapper:onSwipe(fn, view)
	view = view or 'view';
	return self[view]:setActionCallback(UI.ACTION.SWIPE, fn);
end

function wrapper:onInput(fn, view)
	view = view or 'view';
	return self[view]:setActionCallback(UI.ACTION.INPUT, fn);
end

return wrapper;