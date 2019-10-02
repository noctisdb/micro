--[[

Micro

UI Framework Lua and Love2d
Noctis

Overview:
Outdated and following OOP.  To be converted to ECS-style code.
Unsure what version of Love2d this supports any longer.

License MIT

--]]


local micro = {}
micro.states = {}
micro.state = {}
micro.id = 0
micro.images = {}
micro.locked = false --this is reserved for when a window is locked and requires action first.
micro.lockedid = {} --store the locked ID

--Load Micro
function micro:load()
	micro.keys = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0",".","-"}
	micro.font = {}
	for i = 4, 50 do 
		micro.font[i] = love.graphics.newFont("/fonts/zekton.ttf", i)
	end
end
--

--Main micro function
function micro:new(id) --Begin the state, this will hold components
	assert(type(id) == "string", "Please enter a string")
	local state = {id = id}
	state.components = {}
	state.visible = true --can see it
	state.active = true --can interact with it
	state.x = 0
	state.y = 0
	state.width = 400
	state.height = 150
	state.border = true --set to false for no border
	function state:create(class, alias) --alias can be used to specify the ID 
		assert(type(class) == "string", "Enter a String")
		local component = micro[class]()
		micro.id = micro.id + 1
		component.id = alias or micro.id
		self.components[component.id] = component
		return component
	end
	
	self.states[state.id] = state
	return state
end
--

--Set state
function micro:deactive(id)
	assert(type(id) == "string", "Please enter a string")
	self.states[id].active = false
	--micro.camera:reset()
end

function micro:active(id)
	assert(type(id) == "string", "Please enter a string")
	self.states[id].active = true
	--micro.camera:reset()
end

function micro:delete(id)
	assert(type(id) == "string", "Please enter a string")
	for _,v in pairs(self.states[id].components) do
		v = nil
	end
	self.states[id] = nil
end
--

--mouse pressed, set the items to true
function micro:mousePressed()
	local x, y = micro.camera:mousePosition()
	for _, state in pairs(self.states) do
		if not self.locked or self.lockid == state.id then
			if state.active then
				for _, v in pairs(state.components) do
					if v.class == "button" or v.class == "input" then
						if x >= state.x + v.x and x <= state.x + v.x + v.width and y >= state.y + v.y and y <= state.y +  v.y + v.height then
							v.pressed = true
						else
							v.pressed = false
							if v.class == "input" then
								v.selected = false
							end
						end
					end
				end
			end
		end
	end
end


--

--mouse released for actually clicking
function micro:mouseReleased()
	local x, y = micro.camera:mousePosition()
	for _, state in pairs(self.states) do
		if not self.locked or self.lockid == state.id then
			if state.active then
				for _, v in pairs(state.components) do
					if v.class == "button" or v.class == "input" then
						if x >= state.x + v.x and x <= state.x + v.x + v.width and y >= state.y + v.y and y <= state.y +  v.y + v.height and v.pressed then
							if v.class == "button" then
								v.action()
							end
							if v.class == "input" then
								v.selected = true
							end
						end
					end
				end
			end
		end
	end
end
--

--
function micro:wheelMoved(x,y)
	for _, state in pairs(self.states) do
		if not self.locked or self.lockid == state.id then
			if state.active then
				for _, v in pairs(state.components) do
					if v.class == "scroll" then	
						if y > 0 then
							if micro.camera.y > 0 then
								micro.camera.y = micro.camera.y - 20
							end
						elseif y < 0 then
							if micro.camera.y < (v.height - love.graphics.getHeight()) then
								micro.camera.y = micro.camera.y + 20
							end
						end
					end
				end
			end
		end
	end
end
--

--key inputs
function micro:keyPressed(key)
	for _, state in pairs(self.states) do
		if not self.locked or self.lockid == state.id then
			if state.active then
				for _, v in pairs(state.components) do
					if v.class == "input" and v.selected then
						if key == "backspace" then
							v.output = string.sub(v.output, 1, -2)
						elseif key == "space" then
							v.output = v.output.." "
						else
							if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
								if self:includedkey(key) then
									local k = string.upper(key)
									if #v.output < v.maxchars then
										v.output = v.output..k
									end
								end
							else
								if self:includedkey(key) then
									if #v.output < v.maxchars then
										v.output = v.output..key
									end
								end
							end
						end
					end
					if v.class  == "button" and key == v.keylistener then
						v.action()
					end
				end
			end
		end
	end
end
--

function micro:isDown(key)
	for _, state in pairs(self.states) do
		if not self.locked or self.lockid == state.id then
			if state.active then
				for _, v in pairs(state.components) do
					if v.class == "scroll" then	
						if key == "up" then
							if micro.camera.y > 0 then
								micro.camera.y = micro.camera.y - 20
							end
						elseif key == "down" then
							if micro.camera.y < (v.height - love.graphics.getHeight()) then
								micro.camera.y = micro.camera.y + 20
							end
						end
					end
				end
			end
		end
	end	
end



--
function micro:includedkey(keycheck)
	for _,v in pairs(self.keys) do
		if keycheck == v then
			return true
		end
	end
	return false
end
--

--clone this into multiple things, button, checkbox, etc
function micro:draw()
	for _,state in pairs(self.states) do
		if state.visible then
			micro.camera:set()
			for _,v in pairs(state.components) do
				if v.class == "image" then
					love.graphics.setColor(v.color)
					love.graphics.draw(micro.images[v.name], state.x + v.x,state.y + v.y)		
				end		
				if v.class == "frame" or v.class == "button" or v.class == "border" or v.class == "input" then
					love.graphics.setColor(v.color)
					love.graphics.rectangle("fill", state.x +v.x, state.y +v.y, v.width, v.height)
				end
				if v.class == "input" or v.class == "outline" then
					love.graphics.setColor(255,255,255,255)
					love.graphics.rectangle("line", state.x +v.x, state.y +v.y, v.width, v.height)
				end
				if v.class == "button" then
					self:print(v.fontsize, v.output, v.fontcolor, state.x + v.x + (v.width/2), state.y + v.y + (v.height/2), v.fontalign)
				end			
				if v.class == "text" then
					self:print(v.fontsize, v.output, v.fontcolor, state.x + v.x ,state.y + v.y, v.fontalign)
				end
				if v.class == "input" then
					self:print(v.fontsize, v.output, v.fontcolor, state.x + v.x + (v.width/2) , state.y + v.y + (v.height/2), v.fontalign)
				end
				if v.class == "textblock" then
					self:printblock(v.fontsize, v.output, v.fontcolor, state.x + v.x , state.y + v.y, v.fontalign)
				end
			end
			micro.camera:unset()
			if state.border then
				love.graphics.setColor(255,255,255,255)
				love.graphics.rectangle("line", state.x, state.y, state.width, state.height)
			end
		end
	end
end
--
micro.camera = {}
micro.camera.x, micro.camera.y = 0, 0

function micro.camera:set()
	love.graphics.push()
	love.graphics.translate(-self.x, -self.y)
end
--

--
function micro.camera:unset()
	love.graphics.pop()
	love.graphics.scale(1,1)
end
--

--
function micro.camera:reset()
	self.x, self.y = 0, 0
end
--

--
function micro.camera:mousePosition()
	return love.mouse.getX() + self.x, love.mouse.getY() + self.y
end
--

--
function micro:newImage(image)
	if micro.images[image] then
		print("Image Reused")
	else
		micro.images[image] = love.graphics.newImage(image)
		print("Image Loaded")
	end
end
--

--Scroll Flag
function micro:scroll()
	return {
		id = 0, 
		class = "scroll", 
		height = 600
	}	
end
--

--New Frame
function micro:frame()
	return {
		id = 0, 
		class = "frame", 
		x = 0, 
		y = 0, 
		color = {10,10,10,255},
		width = 400, 
		height = 600, 
		title = "Title", 
		header = false
	}
end
--

--New Button
function micro:button()
	return {
		id = 0, 
		class = "button", 
		x = 0, 
		y = 0, 
		width = 100, 
		height = 28, 
		color = {55,55,55,255},
		output = "Click Me",
		fontsize = 20,
		fontcolor = {255,255,255,255},
		fontalign = "c",
		pressed = false,
		keylistener = nil,
		action = function() print("Button Clicked") end,
		}
end
--

--
function micro:checkbox()
	return {
		id = 0,
		class = "checkbox",
		x = 0,
		y = 0,
		width = 10,
		height = 10,
		checked = false,
	}
end
--

--Image
function micro:image()
	return {
		id = 0,
		class = "image",
		x = 0, 
		y = 0, 
		name = {}, 
		color = {255,255,255,255}
	}
end
--

--Text
function micro:text()
	return {
		id = 0,
		class = "text",
		x = 0, 
		y = 0, 
		output = "Text", 
		fontsize = 20,
		fontcolor = {255,255,255,255}, 
		fontalign = "c"
	}
end
--

--Text
function micro:textblock()
	return {
		id = 0,
		class = "textblock",
		x = 0, 
		y = 0, 
		output = "Text", 
		fontsize = 10,
		fontcolor = {255,255,255,255}, 
	}
end
--

--
function micro:outline()
	return {
		id = 0,
		class = "outline",
		x = 0,
		y = 0,
		width = 400,
		height = 600,
		border = 2,
		color = {255,255,255,255},
	}
end
--

--
function micro:slider()
	return {
		id = 0,
		class = "slider",
		x = 0,
		y = 0,
		width = 25,
		height = 600,
		orientation = "horizontal",
		minvalue = 0,
		maxvalue = 100,
		increment = 10,
		color = {122,122,122,255},	
	}
end
--

--Input Box
function micro:input() --completed, now to implement into the slate functions to pass the args
	return {
		id = 0,
		class = "input",
		x = 0,
		y = 0,
		width = 150,
		height = 25,
		output = "",
		maxchars = 0,
		color = {100,100,100,255},
		fontalign = "c",
		fontsize = 20,
		fontcolor = {255,255,255,255},
		pressed = false,
		selected = false,
	}
end
--

--
function micro:commaFormat(n) --Complete
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
                                :gsub(",(%-?)$","%1"):reverse()
end
--

--
function micro:print(size, text, color, x,  y, align) --X - C(enter) R(ight), Y - B(ottom) C(enter)
	local align = align or {}
	local offsetx = 0
	local offsety = 0
	if align == "c" then
		offsetx = self.font[size]:getWidth(text) / 2
		offsety = self.font[size]:getHeight(text)/2
	elseif align == "r" then
		offset = self.font[size]:getWidth(text)
	else
		offset = 0
	end
	love.graphics.setColor(color)
	love.graphics.setFont(self.font[size])
	love.graphics.print(text, x - offsetx, y - offsety)
end
--

--
function micro:printblock(size, text, color, x,  y, align) --X - C(enter) R(ight), Y - B(ottom) C(enter)
	local f = {}
	local a = ""
	local blockwidth = 372
	if align == "c" then
		a = "center"
	else
		a = "left"
	end
	love.graphics.setColor(color)
	love.graphics.setFont(self.font[size])
	love.graphics.printf(text, x, y, blockwidth, a)
end
--

--
function micro:getBlockHeight(text, size, maxwidth)
	local w = self.font[size]:getWidth(text)
	local h = math.floor(w/maxwidth) --return the number of lines
	return h
end

return micro
