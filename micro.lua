--[[

Micro

UI Framework Lua and Love2d
Noctis

Overview:
Outdated and following OOP.  To be converted to ECS-style code.
Unsure what version of Love2d this supports any longer.

License MIT

--]]

return {

    new = function(tbl)
        local micro = {
            states = {},
            state = {},
            id = 0,
            images = {},
            locked = false, --this is reserved for when a window is locked and requires action first.
            lockid = {}, --store the locked ID
            width = love.graphics.getWidth(),
            height = love.graphics.getHeight(),
        }
        function micro:load()
            self.keys = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0",".","-"}
            self.font = {}
            --DEFAULTFONT = love.graphics.newFont("fonts/PixelOperatorMono-Bold.ttf", 16)
            --DEFAULTFONTRegular = love.graphics.newFont("fonts/PixelOperatorMono.ttf", 16)
        	for i = 4, 50 do 
        		self.font[i] = love.graphics.newFont("/fonts/PixelOperatorMono-Bold.ttf", i)
        	end
            print("Micro Loaded")
        end
        function micro:new(id) --Create a new State
        	assert(type(id) == "string", "Please enter a string")
        	local state = {id = id}
        	state.components = {}
        	state.visible = true --can see it
        	state.active = true --can interact with it
        	state.x = 0
        	state.y = 0
        	state.width = self.width
        	state.height = self.height
        	state.border = true --set to false for no border
            function state:scroll(tbl)
                micro.id = micro.id + 1
            	local scroll = {
            		id = micro.id, 
            		class = "scroll", 
            		height = tbl.height or 600
            	}
                self.components[scroll.id] = scroll
                return scroll
            end
            function state:input(tbl)
            	micro.id = micro.id + 1
                local input = { 
            		id = micro.id,
            		class = "input",
            		x = tbl.x or 0,
            		y = tbl.y or 0,
            		width = tbl.width or 150,
            		height = tbl.height or 25,
            		output = tbl.output or "",
            		maxchars = tbl.maxchars or 0,
            		color = tbl.color or {100,100,100,255},
            		fontalign = tbl.fontalign or "c",
            		fontsize = tbl.fontsize or 20,
            		fontcolor = tbl.fontcolor or {255,255,255,255},
            		pressed = false,
            		selected = false,
            	}
                self.components[input.id] = input
                return input
            end

            function state:frame()
                micro.id = micro.id + 1
            	local frame = {
            		id = micro.id, 
            		class = "frame", 
            		x = 0, 
            		y = 0, 
            		color = {10,10,10,255},
            		width = 400, 
            		height = 600, 
            		title = "Title", 
            		header = false
            	}
                self.components[frame.id] = frame
                return frame
            end
            function state:button(tbl)
                micro.id = micro.id + 1
            	local button = {
            		id = tbl.alias or micro.id, 
            		class = "button", 
            		x = tbl.x or 0, 
            		y = tbl.y or 0, 
            		width = tbl.width or 100, 
            		height = tbl.height or 20, 
            		color = tbl.color or {55,55,55,255},
            		output = tbl.output or "Click Me",
            		fontsize = tbl.fontsize or 16,
            		fontcolor = tbl.fonctolor or {255,255,255,255},
            		fontalign = tbl.fontalign or "c",
            		pressed = false,
            		keylistener = tbl.keylistener or nil,
            		action = tbl.action or function() print("Button Clicked") end,
            		}
                    if tbl.outline == true then
                       self:outline {x = button.x, y = button.y, width = button.width, height = button.height, border = 1} 
                    end
                    self.components[button.id] = button
                    return button
            end
            function state:checkbox()
                micro.id = micro.id + 1
            	local checkbox = {
            		id = micro.id,
            		class = "checkbox",
            		x = 0,
            		y = 0,
            		width = 10,
            		height = 10,
            		checked = false,
            	}
                self.components[checkbox.id] = checkbox
                return checkbox
            end
            function state:image()
                micro.id = micro.id + 1
            	local image = {
            		id = micro.id,
            		class = "image",
            		x = 0, 
            		y = 0, 
            		name = {}, 
            		color = {255,255,255,255}
            	}
                self.components[image.id] = image
                return image
            end
            function state:text(tbl)
                micro.id = micro.id + 1
            	local text = {
            		id = tbl.alias or micro.id,
            		class = "text",
            		x = tbl.x or 0, 
            		y = tbl.y or 0, 
            		output = tbl.output or "Text", 
            		fontsize = tbl.fontsize or 16,
            		fontcolor = tbl.fontcolor or {255,255,255,255}, 
            		fontalign = tbl.fontalign or "c"
            	}
                self.components[text.id] = text
                return text
            end
            function state:textblock()
                micro.id = micro.id + 1
            	local textblock = {
            		id = micro.id,
            		class = "textblock",
            		x = 0, 
            		y = 0, 
            		output = "Text", 
            		fontsize = 16,
            		fontcolor = {255,255,255,255}, 
            	}
                self.components[textblock.id] = textblock
                return textblock
            end
            function state:outline(tbl)
                micro.id = micro.id + 1
            	local outline = {
            		id = micro.id,
            		class = "outline",
            		x = tbl.x or 0,
            		y = tbl.y or 0,
            		width = tbl.width or 400,
            		height = tbl.height or 600,
            		border = tbl.border or 2,
            		color = tbl.color or {255,255,255,255},
            	}
                self.components[outline.id] = outline
                return outline
            end
            function state:slider(tbl)
                micro.id = micro.id + 1
            	local slider = {
            		id = micro.id,
            		class = "slider",
            		x = tbl.x or 0,
            		y = tbl.y or 0,
            		width = tbl.width or 25,
            		height = tbl.height or 600,
            		orientation = tbl.orientation or "horizontal",
            		minvalue = tbl.minvalue or 0,
            		maxvalue = tbl.maxvalue or 100,
            		increment = tbl.increment or 10,
            		color = tbl.color or {122,122,122,255},	
            	}
                self.components[slider.id] = slider
                return slider
            end


            function state:deactivate()
            	self.active = false
            end
            function state:activate()
            	self.active = true
            end

            function state:show()
            	self.visible = true        
            end
            function state:hide()
            	self.visible = false       
            end	
        	self.states[state.id] = state
        	return state
        end

        function micro:mousePressed()
        	local x, y = love.mouse.getPosition()
        	for _, state in pairs(self.states) do
        		if not self.locked or self.lockid == state.id then
        			if state.active then
        				for _, v in pairs(state.components) do
        					if v.class == "button" or v.class == "input" then
        						if x >= state.x + v.x and x <= state.x + v.x + v.width and y >= state.y + v.y and y <= state.y +  v.y + v.height then
        							v.pressed = true
                                    print("found")
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
        function micro:mouseReleased()
        	local x, y = love.mouse.getPosition()
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
        function micro:keyPressed(key)
        	for _, state in pairs(self.states) do
        		if not self.locked or self.lockid == state.id then
        			if state.active then
        				for _, v in pairs(state.components) do
        					if v.class == "input" and v.selected then
        						if key == "backspace" then
        							v.output = string.sub(v.output, 1, -2)
        						elseif key == " " then
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
        function micro:includedkey(keycheck)
        	for _,v in pairs(self.keys) do
        		if keycheck == v then
        			return true
        		end
        	end
        	return false
        end
        function micro:draw()
        	for _,state in pairs(self.states) do
        		if state.visible then
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
        			if state.border then
        				love.graphics.setColor(255,255,255,255)
        				love.graphics.rectangle("line", state.x, state.y, state.width, state.height)
        			end
        		end
        	end
        end
        --Components
        function micro:newImage(image)
        	if micro.images[image] then
        		print("Image Reused")
        	else
        		micro.images[image] = love.graphics.newImage(image)
        		print("Image Loaded")
        	end
        end
        function micro:newFont(pathtofont,fontname)
        	for i = 4, 50 do 
        		micro.font[i] = love.graphics.newFont(pathtofont, i)
        	end
        end
        --Formatters
        function micro:commaFormat(n) --Complete
          return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
                                        :gsub(",(%-?)$","%1"):reverse()
        end
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
        function micro:getBlockHeight(text, size, maxwidth)
        	local w = self.font[size]:getWidth(text)
        	local h = math.floor(w/maxwidth) --return the number of lines
        	return h
        end
        micro:load()
        return micro
    end
}
