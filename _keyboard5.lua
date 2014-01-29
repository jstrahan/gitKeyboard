
--** NOTE **--
-- module is based on a content width and height of 640,960 although it will
-- work with other settings higher but not lower without adjusting some figures

local M = {}
  local audio, display, math, native, timer, transition, string = audio, display, math, native, timer, transition, string
	local rgb = require'_rgb'
  local touchGroup = display.newGroup( )
  local inputBox, fieldTable, index, labelCount, csr = {}, {}, 0, 0, 0
  local currentInputBox, prevInputBox, sceneName, keyboardTop, nativeBox, keyboardShow, keyboardHide
  local cursor, flash = display.newText( touchGroup, "_", 0, 0, native.systemFontBold, 28 )
        cursor.alpha = 0

	function M.init(params)
----------------------------------------setup
		local currentKeyboard, currentControl = 1, 1
    local keyboardNames = { "standard", "alpha", "noArrow", "alphaNoArrow", "standardCaps", "alphaCaps", "noArrowCaps",
                            "alphaNoArrowCaps", "standardSymbol", "noArrowSymbol", "numPad", "numPad_noArrow" }
		local keyboard = display.newGroup( )
		local background, buildKeyboard
    local isShowing, isActive, isReady = false, false, false
    local shift, symbol = 0, 0
    local click = audio.loadSound( "click.wav" )

----------------------------------------keys
		local keyboardKeys = { { "1","2","3","4","5","6","7","8","9","0","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","@","z","x","c","v","b","n","m",".","Clr","Del","<-","Shift","#=","Space","Done","->"},
                           { "1","2","3","4","5","6","7","8","9","0","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","@","z","x","c","v","b","n","m",".","Clr","Del","<-","Shift","Space","Done","->"},
                           { "1","2","3","4","5","6","7","8","9","0","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","@","z","x","c","v","b","n","m",".","Clr","Del","Shift","#=","Space","Done"},
                           { "1","2","3","4","5","6","7","8","9","0","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","@","z","x","c","v","b","n","m",".","Clr","Del","Shift","Space","Done"},
                           { "1","2","3","4","5","6","7","8","9","0","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","@","Z","X","C","V","B","N","M",".","Clr","Del","<-","Shift","#=","Space","Done","->"},
                           { "1","2","3","4","5","6","7","8","9","0","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","@","Z","X","C","V","B","N","M",".","Clr","Del","<-","Shift","Space","Done","->"},
                           { "1","2","3","4","5","6","7","8","9","0","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","@","Z","X","C","V","B","N","M",".","Clr","Del","Shift","#=","Space","Done"},
                           { "1","2","3","4","5","6","7","8","9","0","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","@","Z","X","C","V","B","N","M",".","Clr","Del","Shift","Space","Done"},
              	           { "!","@","#","$","%","^","&","*","(",")","`","~","-","_","=","+","[","]","{","}","\\","|",";",":","'",'"',",","", "<",">","/","?", "", "", "", "", "",".","Clr","Del","<-","Shift","#=","Space","Done","->"},
                           { "!","@","#","$","%","^","&","*","(",")","`","~","-","_","=","+","[","]","{","}","\\","|",";",":","'",'"',",","", "<",">","/","?", "", "", "", "", "",".","Clr","Del","Shift","#=","Space","Done"},
                      	   { "7","8","9","4","5","6","1","2","3","-","0",".","<-","Clr","Del","Done","->"},
                           { "7","8","9","4","5","6","1","2","3","-","0",".","Clr","Del","Done"} }
    local controlKeys ={ { 1, 1.75, 1, 4.02, 1.75, 1 },{ 1, 1.75, 5.02, 1.75, 1 },{ 1.75, 1, 6.02, 1.75 },{ 1.75, 7.02, 1.75 },{ 0.5, 0.5, 0.5, 1, 0.5 },{ 0.5, 0.5, 2 } } 

----------------------------------------params
		local params                      = params                      or {}
          keyboardType                = params.type                 or "native"                     -- use native/custom keyboard
          params.speed                = params.speed                or 250                          -- speed to display  keyboard
          params.bounce               = params.bounce               or true                         -- keys bounce when  touched
          params.click                = params.click                or true                         -- click sound then  touched
          params.background           = params.background           or {}                           -- background color  table
          params.background[1]        = params.background[1]        or "lightGray"                  -- background color  name
          params.background[2]        = params.background[2]        or 0.9                          -- background color  alpha
          params.backgroundStroke     = params.backgroundStroke     or {}                           -- background stroke table
          params.backgroundStroke[1]  = params.backgroundStroke[1]  or "darkGray"                   -- background stroke color
          params.backgroundStroke[2]  = params.backgroundStroke[2]  or 1                            -- background stroke alpha
          params.key                  = params.key                  or {}                           -- key        color  table
          params.key[1]               = params.key[1]               or "white"                      -- key        color  name
          params.key[2]               = params.key[2]               or 1                            -- key        color  alpha
          params.key[3]               = params.key[3]               or "cornflowerBlue"             -- key shift  color  name
          params.key[4]               = params.key[4]               or params.key[3]                -- key symbol color  name
          params.keyStroke            = params.keyStroke            or {}                           -- key        stroke table
          params.keyStroke[1]         = params.keyStroke[1]         or "black"                      -- key        stroke name
          params.keyStroke[2]         = params.keyStroke[2]         or params.backgroundStroke[2]   -- key        stroke alpha
          params.letters              = params.letters              or {}                           -- letter     color  table
          params.letters[1]           = params.letters[1]           or "black"                      -- letter     color  name
          params.letters[2]           = params.letters[2]           or 1                            -- letter     color  alpha
          params.letters[3]           = params.letters[3]           or "cornflowerBlue"             -- letter     color  when pressed
          params.font                 = params.font                 or native.systemFontBold        -- letter     font   name
----------------------------------------functions

    M.getHeight = function()
      return keyboardTop
    end
    M.getSpeed = function()
      return params.speed
    end
    function M.isShowing()
      return isShowing
    end

    local function getScreenSize()
			return display.contentWidth, display.contentHeight, display.contentWidth>display.contentHeight
		end

		local function getKeyboardValues() -- arg = number of keys across
			local across 					= currentKeyboard < 11 and 10 or 3									
			local _w,_h,_o     		= getScreenSize()	
			local keyboardHeight 	= (math.floor((_w>_h and 640 or 480) * (640 / _w)))-display.screenOriginY
			local keyboardWidth 	= (((across > 10 and _w > _h) and _h or _w)-10)-(2*display.screenOriginX)
			local keyboardRadius 	= math.floor(16 * ((_w>_h and 640 or 480) / _w))
			local buttonHeight 		= math.floor(keyboardHeight/5) - 2
			local buttonWidth 		= math.floor(keyboardWidth/(across+0.3)) - 1
			local buttonRadius 		= math.floor(buttonWidth/8)
			local characterSize		= buttonWidth - ((currentKeyboard<11 and _o == true) and 48 or (currentKeyboard<11 and _o == false) and 32 or 144)
			return keyboardWidth, keyboardHeight, keyboardRadius, buttonWidth, buttonHeight, buttonRadius, characterSize
		end
    local function cursorFlash()
      cursor:toFront( )
      csr = (csr+1)%2
      cursor.alpha = csr
      cursor.y = inputBox[sceneName][index].input.y
      cursor.x = inputBox[sceneName][index].input.x
    end

    function keyboardShow(arg)
      if keyboardType ~= "native" then
        local arg = arg or {}
        local arg1 = arg.keyboard or "standard"
              arg1 = table.indexOf( keyboardNames, arg1 )  or 1
        local arg2 = arg.speed or params.speed
        params.click = M.click or params.click
        params.bounce = M.bounce or params.bounce
        if isShowing == true and currentInputBox ~= prevInputBox then
            isReady = false
            keyboard.isVisible = false
            currentKeyboard = arg1
            buildKeyboard()
            keyboard.isVisible = true
            keyboard.y = keyboard.height/2
            if currentInputBox.input.text == currentInputBox.options.help then
              timer.performWithDelay( 500, function() 
                currentInputBox.input.text = ""
                isReady = true
              end)
            else
              isReady = true
            end
            Runtime:dispatchEvent( {name = "keyboard",
                                 phase = "isShowing",
                                 speed = params.speed,
                                height = keyboardTop,
                                amount = inputBox[sceneName][index].y > keyboardTop and
                                         -(inputBox[sceneName][index].y - keyboardTop) - inputBox[sceneName][index].height or 0 })

        elseif isShowing == false then
          currentKeyboard = arg1
          buildKeyboard()
          keyboard.isVisible = true
          isShowing = true
          Runtime:dispatchEvent( {name = "keyboard",
                                 phase = "changePosition",
                                 speed = params.speed,
                                height = keyboardTop,
                                amount = inputBox[sceneName][index].y > keyboardTop and
                                         -(inputBox[sceneName][index].y - keyboardTop) - inputBox[sceneName][index].height or 0 })

          transition.moveTo( keyboard, { time = arg2, y = display.contentHeight/2 - keyboard.height/2,
            onComplete = function()
              isReady = true
              if inputBox[sceneName][index].input.text == inputBox[sceneName][index].options.help then
                inputBox[sceneName][index].input.text = ""
              end
              Runtime:dispatchEvent( { name = "keyboard",
                                      phase = "changePositionComplete",
                                      speed = params.speed,
                                     height = keyboardTop,
                                     amount = inputBox[sceneName][index].y > keyboardTop and
                                              -(inputBox[sceneName][index].y - keyboardTop) - inputBox[sceneName][index].height or 0 })
          end })
          cursor.fontSize = inputBox[sceneName][index].options.font[2]
          flash = timer.performWithDelay( 400, cursorFlash ,0 )
        end
      end
    end
    function keyboardHide(arg)
      local arg = arg or params.speed
      timer.cancel( flash )
      isShowing = false
      Runtime:dispatchEvent( { name = "keyboard",
                              phase = "returnPosition",
                              speed = params.speed,
                             height = keyboardTop,
                             amount = 0 })
      transition.to( keyboard, { time = arg, y = (display.contentHeight*2),
        onComplete = function() 
          Runtime:dispatchEvent( { name = "keyboard",
                                  phase = "returnPositionComplete",
                                  speed = params.speed,
                                 height = keyboardTop,
                                 amount = 0} )
      end })
    end

----------------------------------------build keyboard

		function buildKeyboard()
			display.remove(keyboard)
			keyboard = display.newGroup( )
			local _kW, _kH, _kR, _bW, _bH, _bR, _cS = getKeyboardValues()
			background = display.newRoundedRect( keyboard, display.contentCenterX, display.contentCenterY-display.screenOriginY, _kW, _kH, _kR )
			background:setFillColor(rgb.color(params.background[1],params.background[2]))
      background:setStrokeColor(rgb.color(params.backgroundStroke[1],params.backgroundStroke[2]))
      background.strokeWidth = 4
      background:addEventListener("touch", function() return true; end)
      keyboard.y = ((display.contentHeight/2) - (background.height/2)-8) -- set to off screen
      keyboardTop = background.contentBounds.yMin - 8
      local function buildKeys()
        local a,b,c
        local add = 0
        keyboardGroup   = display.newGroup( )
        local function buildButtons(a,b)
          local btn = display.newGroup( )
          local offset = currentKeyboard<11 and (_bW/2)*((a+1)%2) or 0
          local label = keyboardKeys[currentKeyboard][((a-1)*(currentKeyboard < 11 and 10 or 3))+b]
          local left = (b-1)*_bW + offset 
          local top = (a-1)*_bH
          local w1 = a < 5 and 1 or controlKeys[currentKeyboard == 10 and 3 or (((currentKeyboard+3)%4)+1)+(currentKeyboard>10 and 2 or 0)][b] 
          local btnWidth = math.floor(_bW * w1)
          left = (a==5 and (b==1 and 0 or add) or left)
          add = add + (a==5 and btnWidth or 0)
          local key = display.newRoundedRect( btn, left, top, btnWidth-4, _bH-4, _bR )
          			key.anchorX = 0
          			key:setFillColor( rgb.color( (shift == 1 and label == "Shift") and params.key[3] or (symbol == 1 and label == "#=") and params.key[4] or params.key[1], params.key[2] ) )
                key:setStrokeColor( rgb.color( params.keyStroke[1]), params.keyStroke[2] )
                key.strokeWidth = 2
                key.txt = display.newText( btn, label, key.x+(key.width/2), key.y, params.font, _cS)
                key.txt:setFillColor( rgb.color( params.letters[1], params.letters[2] ) )
                key.isHitTestable = true
                key:addEventListener("touch", function(e)
                  if e.phase == "began" then
                    isActive = false
                    display.getCurrentStage():setFocus( e.target )
                    if params.bounce == true and label ~= "" then
                      key.txt.y = key.txt.y - _bH
                      key.txt.x = (key.txt.text == "Done" and ((currentKeyboard+3)%4)+1 == 3 or ((currentKeyboard+3)%4)+1 == 4 ) and (key.txt.x - _bW/2-48) or key.txt.x
                      key.txt.x = (key.txt.text == "Shift" and ((currentKeyboard+3)%4)+1 == 3 or ((currentKeyboard+3)%4)+1 == 4 ) and (key.txt.x + _bW/2+48) or key.txt.x
                      key.txt.x = (key.txt.text == "Del" and ((currentKeyboard+3)%4)+1 < 13 ) and (key.txt.x - _bW/2 - 16) or key.txt.x
                      key.txt.size = key.txt.size*4
                      key.txt:setFillColor( rgb.color( params.letters[3], 1 ) )
                    end
                    touchGroup:dispatchEvent({name = "typing",
                                             phase = e.phase,
                                            target = e.target,
                                               key = label})
                  end
                  if e.phase == "offTarget" then
                    display.getCurrentStage():setFocus(nil)
                    isActive = true
                    if params.bounce == true and label ~= "" then
                      key.txt.y = key.txt.y + _bH
                      key.txt.x = (key.txt.text == "Done" and ((currentKeyboard+3)%4)+1 == 3 or ((currentKeyboard+3)%4)+1 == 4 ) and (key.txt.x + _bW/2+48) or key.txt.x
                      key.txt.x = (key.txt.text == "Shift" and ((currentKeyboard+3)%4)+1 == 3 or ((currentKeyboard+3)%4)+1 == 4 ) and (key.txt.x - _bW/2-48) or key.txt.x
                      key.txt.x = (key.txt.text == "Del" and ((currentKeyboard+3)%4)+1 < 13 ) and (key.txt.x + _bW/2 + 16) or key.txt.x
                      key.txt.size = key.txt.size/4
                      key.txt:setFillColor( rgb.color( params.letters[1], 1 ) )
                    end
                    touchGroup:dispatchEvent({name = "typing",
                                             phase = "offTarget",
                                            target = e.target,
                                               key = label})
                  end
                  if e.phase == "moved" then
                    if e.x < e.target.contentBounds.xMin or
                       e.x > e.target.contentBounds.xMax or
                       e.y < e.target.contentBounds.yMin or
                       e.y > e.target.contentBounds.yMax then
                        e.phase = "offTarget"
                        e.target:dispatchEvent(e)
                    end
                  end
                  if e.phase == "ended" then
                    if isActive == false then
                      display.getCurrentStage():setFocus(nil)
                      if params.bounce == true and label ~= "" then
                        key.txt.y = key.txt.y + _bH
                        key.txt.x = (key.txt.text == "Done" and ((currentKeyboard+3)%4)+1 == 3 or ((currentKeyboard+3)%4)+1 == 4 ) and (key.txt.x + _bW/2+48) or key.txt.x
                        key.txt.x = (key.txt.text == "Shift" and ((currentKeyboard+3)%4)+1 == 3 or ((currentKeyboard+3)%4)+1 == 4 ) and (key.txt.x - _bW/2-48) or key.txt.x
                        key.txt.x = (key.txt.text == "Del" and ((currentKeyboard+3)%4)+1 < 13 ) and (key.txt.x + _bW/2 + 16) or key.txt.x
                        key.txt.size = key.txt.size/4
                        key.txt:setFillColor( rgb.color( params.letters[1], 1 ) )
                      end
                      if params.click == true then audio.play( click ) end
                      touchGroup:dispatchEvent({name = "typing",
                                               phase = e.phase,
                                              target = e.target,
                                                 key = label})
                    end
                  end
                  if e.phase == "cancelled" then
                    if isActive == false then
                      display.getCurrentStage():setFocus(nil)
                      if params.bounce == true and label ~= "" then
                        key.txt.y = key.txt.y + buttonHeight
                        key.txt.x = (key.txt.text == "Done" and ((currentKeyboard+3)%4)+1 == 3 or ((currentKeyboard+3)%4)+1 == 4 ) and (key.txt.x + _bW/2+48) or key.txt.x
                        key.txt.x = (key.txt.text == "Shift" and ((currentKeyboard+3)%4)+1 == 3 or ((currentKeyboard+3)%4)+1 == 4 ) and (key.txt.x - _bW/2-48) or key.txt.x
                        key.txt.x = (key.txt.text == "Del" and ((currentKeyboard+3)%4)+1 < 13 ) and (key.txt.x + _bW/2 + 16) or key.txt.x
                        key.txt.size = key.txt.size/4
                        key.txt:setFillColor( rgb.color( params.letters[1], 1 ) )
                      end
                      touchGroup:dispatchEvent({name = "typing",
                                               phase = e.phase,
                                              target = e.target,
                                                 key = label})
                    end
                  end
                end)
          keyboardGroup:insert(btn)
        end
        c = 0
        for a = 1, 4 do -- 5 rows of keys
          for b = 1, currentKeyboard < 11 and 10 or 3 do 
            buildButtons(a,b)
            c = c + 1
          end
        end
        for b = 1, #keyboardKeys[currentKeyboard]-c do
          buildButtons(5,b)
        end
        local add = 0
        keyboardGroup.x = background.x - keyboardGroup.width/2
        keyboardGroup.y = background.y - keyboardGroup.height/2 + _bH/2 + 2
        keyboard:insert(keyboardGroup)
        keyboard:toFront( )
        keyboard.y = 2 * display.contentHeight 
        keyboard.isVisible = false
        currentControl = (((currentKeyboard+3)%4)+1)+(currentKeyboard == 9 and 0 or currentKeyboard == 10 and 1 or 0)
			end
			buildKeys()
		end
		Runtime:addEventListener( "orientation", function() keyboardShow({keyboard = keyboardNames[currentKeyboard]}) end)

----------------------------------------handle key presses

    touchGroup:addEventListener( "typing", function(e)
      if isReady == true then
      if e.phase == "ended" then
        if e.key == "Done" then
          isReady = false
          currentInputBox:setStrokeColor( rgb.color(currentInputBox.options.strokeColor[1], currentInputBox.options.strokeColor[2] ))
          if currentInputBox.input.text == "" then currentInputBox.input.text = currentInputBox.options.help end
          currentInputBox, prevInputBox = nil, nil
          keyboardHide()
        elseif e.key == "Shift" then
          keyboard.isVisible = false
          shift = ((shift+1)%2)
          currentKeyboard = (shift == 0 and symbol == 0 and currentControl == 1) and 1 or
                            (shift == 0 and symbol == 0 and currentControl == 2) and 2 or
                            (shift == 0 and symbol == 0 and currentControl == 3) and 3 or
                            (shift == 0 and symbol == 0 and currentControl == 4) and 4 or
                            (shift == 0 and symbol == 1 and currentControl == 1) and 9 or
                            (shift == 0 and symbol == 1 and currentControl == 3) and 10 or
                            (shift == 1 and symbol == 0 and currentControl == 1) and 5 or
                            (shift == 1 and symbol == 0 and currentControl == 2) and 6 or
                            (shift == 1 and symbol == 0 and currentControl == 3) and 7 or
                            (shift == 1 and symbol == 0 and currentControl == 4) and 8 or
                            (shift == 1 and symbol == 1 and currentControl == 1) and currentKeyboard or
                            (shift == 1 and symbol == 1 and currentControl == 3) and currentKeyboard or currentKeyboard
          keyboardShow({keyboard = keyboardNames[currentKeyboard]})
        elseif e.key == "#=" then
          keyboard.isVisible = false
          symbol = ((symbol+1)%2)
          currentKeyboard = (shift == 0 and symbol == 0 and currentControl == 1) and 1 or
                            (shift == 0 and symbol == 0 and currentControl == 2) and 2 or
                            (shift == 0 and symbol == 0 and currentControl == 3) and 3 or
                            (shift == 0 and symbol == 0 and currentControl == 4) and 4 or
                            (shift == 0 and symbol == 1 and currentControl == 1) and 9 or
                            (shift == 0 and symbol == 1 and currentControl == 3) and 10 or
                            (shift == 1 and symbol == 0 and currentControl == 1) and 5 or
                            (shift == 1 and symbol == 0 and currentControl == 2) and 6 or
                            (shift == 1 and symbol == 0 and currentControl == 3) and 7 or
                            (shift == 1 and symbol == 0 and currentControl == 4) and 8 or
                            (shift == 1 and symbol == 1 and currentControl == 1) and 9 or
                            (shift == 1 and symbol == 1 and currentControl == 3) and 10 or currentKeyboard
          keyboardShow({keyboard = keyboardNames[currentKeyboard]})
        elseif e.key == "Space" then
          inputBox[sceneName][index].input.text = inputBox[sceneName][index].input.text.." "
        elseif e.key == "Clr" then
          inputBox[sceneName][index].input.text = inputBox[sceneName][index].options.staticText
        elseif e.key == "Del" then
          if inputBox[sceneName][index].input.text ~= inputBox[sceneName][index].options.staticText then
            inputBox[sceneName][index].input.text = string.sub(inputBox[sceneName][index].input.text,1,#inputBox[sceneName][index].input.text-1)
            inputBox[sceneName][index].parent.text = inputBox[sceneName][index].input.text
          end
        elseif e.key == "<-" then
          if currentInputBox.input.text == "" then
              currentInputBox.input.text = currentInputBox.options.help
          end
          index = math.max(1, index - 1)
          currentInputBox:setStrokeColor( rgb.color(currentInputBox.options.strokeColor[1], currentInputBox.options.strokeColor[2] ))
          inputBox[sceneName][index]:setStrokeColor( rgb.color( inputBox[sceneName][index].options.focus[1], inputBox[sceneName][index].options.focus[2] ))
          prevInputBox = currentInputBox
          currentInputBox = inputBox[sceneName][index]
          keyboardShow({keyboard = inputBox[sceneName][index].options.limit})
        elseif e.key == "->" then
          if currentInputBox.input.text == "" then
              currentInputBox.input.text = currentInputBox.options.help
          end
          index = math.min(#inputBox[sceneName], index + 1)
          currentInputBox:setStrokeColor( rgb.color(currentInputBox.options.strokeColor[1], currentInputBox.options.strokeColor[2] ))
          inputBox[sceneName][index]:setStrokeColor( rgb.color( inputBox[sceneName][index].options.focus[1], inputBox[sceneName][index].options.focus[2] ))
          prevInputBox = currentInputBox
          currentInputBox = inputBox[sceneName][index]
          keyboardShow({keyboard = inputBox[sceneName][index].options.limit})
        else
          if #inputBox[sceneName][index].input.text < inputBox[sceneName][index].options.maxChar then
            inputBox[sceneName][index].input.text = inputBox[sceneName][index].input.text .. e.key
            inputBox[sceneName][index].text = inputBox[sceneName][index].input.text
            print(inputBox[sceneName][index].input.height)
          end
        end
        inputBox[sceneName][index].input:setFillColor( rgb.color(inputBox[sceneName][index].options.textColor[1],
                                                                 inputBox[sceneName][index].input.text ~= 
                                                                 inputBox[sceneName][index].options.staticText..inputBox[sceneName][index].options.help and 1 or 0.3) )             
      end
      end
    end)
	end

----------------------------------------display.newInputBox

function display.newInputBox(...)
  local boxGroup = display.newGroup( )
  local arg, newBox = {}
        sceneName = storyboard ~= nil and storyboard.getCurrentSceneName( ) or
                    composer   ~= nil and composer.getSceneName("current") or
                    "fieldList"

  arg.g, arg.x, arg.y, arg.w, arg.h, arg.r, arg.o = ...
  if type(arg.g) == "number" then
    arg.o, arg.r, arg.h, arg.w, arg.y, arg.x = arg.r, arg.h, arg.w, arg.y, arg.x, arg.g
    arg.g = nil
  end
  if type(arg.r) == "table" then
    arg.o, arg.r = arg.r, 0
  end
  arg.o                     = arg.o                 or {}
  arg.o.help                = arg.o.help            or ""
  arg.o.textColor           = arg.o.textColor       or {}
    arg.o.textColor[1]      = arg.o.textColor[1]    or "black"
    arg.o.textColor[2]      = arg.o.textColor[2]    or 1
  arg.o.boxColor            = arg.o.boxColor        or {}
    arg.o.boxColor[1]       = arg.o.boxColor[1]     or "white"
    arg.o.boxColor[2]       = arg.o.boxColor[2]     or 1
  arg.o.strokeColor         = arg.o.strokeColor     or {}
    arg.o.strokeColor[1]    = arg.o.strokeColor[1]  or "white"
    arg.o.strokeColor[2]    = arg.o.strokeColor[2]  or 1
    arg.o.strokeWidth       = arg.o.strokeWidth     or 4
  arg.o.focus           = arg.o.focus       or {}
    arg.o.focus[1]      = arg.o.focus[1]    or "cornflowerBlue"
    arg.o.focus[2]      = arg.o.focus[2]    or 1
  arg.o.font                = arg.o.font            or {}
    arg.o.font[1]           = arg.o.font[1]         or native.systemFont
    arg.o.font[2]           = arg.o.font[2]         or arg.h - 8
  arg.o.maxChar             = arg.o.maxChar         or 20
  arg.o.staticText          = arg.o.staticText      or ""
  arg.o.label               = arg.o.label           or {}
    arg.o.label.text        = arg.o.label.text      or ""
    arg.o.label.x           = arg.o.label.x         or "left"
    arg.o.label.y           = arg.o.label.y         or "center"
    arg.o.label.adjustX     = arg.o.label.adjustX   or 0
    arg.o.label.adjustY     = arg.o.label.adjustY   or 0
    arg.o.label.color       = arg.o.label.color     or {}
      arg.o.label.color[1]  = arg.o.label.color[1]  or "white"
      arg.o.label.color[2]  = arg.o.label.color[2]  or 1
      arg.o.label.font      = arg.o.label.font      or {}
      arg.o.label.font[1]   = arg.o.label.font[1]   or native.systemFontBold
      arg.o.label.font[2]   = arg.o.label.font[2]   or arg.o.font[2]
  arg.o.limit               = arg.o.limit           or "standard"
  arg.o.align               = arg.o.align           or "left"
  labelCount = labelCount + 1
  cursor:setFillColor( rgb.color( "red", 1 ) )
  arg.o.label.text = arg.o.label.text == "" and "field_"..labelCount or arg.o.label.text
  local boxOptions    = { parent = boxGroup,
                            text = arg.o.staticText..arg.o.help,
                               x = (arg.x + (arg.o.align == "left" and 8 or arg.o.align == "right" and -8 or 0)),
                               y = arg.y+6,
                           width = arg.w,
                          height = arg.h,
                            font = arg.o.font[1],
                        fontSize = arg.o.font[2],
                           align = arg.o.align }
  local labelOptions  = { parent = boxGroup,
                            text = arg.o.label.text,
                               x = arg.x,
                               y = arg.y,
                            font = arg.o.label.font[1],
                        fontSize = arg.o.label.font[2] }
  newBox = display.newRoundedRect( boxGroup, arg.x, arg.y, arg.w, arg.h, arg.r )
  newBox:setFillColor( rgb.color( arg.o.boxColor[1], arg.o.boxColor[2] ))
  newBox:setStrokeColor( rgb.color( arg.o.strokeColor[1], arg.o.strokeColor[2] ))
  arg.o.strokeWidth = arg.r == 0 and arg.o.strokeWidth or arg.o.strokeWidth/2
  newBox.strokeWidth = arg.o.strokeWidth
  newBox.input = display.newText( boxOptions )
  newBox.input:setFillColor( rgb.color( arg.o.textColor[1], 0.3 ))
  newBox.label = display.newText( labelOptions )
  newBox.label:setFillColor( rgb.color( arg.o.label.color[1], arg.o.label.color[2]))
  newBox.label.x = arg.o.label.x == "left" and newBox.contentBounds.xMin - (newBox.label.width/2) - 8 or
                   arg.o.label.x == "center" and newBox.x or
                   arg.o.label.x == "right" and newBox.contentBounds.xMax + (newBox.label.width/2) + 8
  newBox.label.y = arg.o.label.y == "top" and newBox.contentBounds.yMin - (newBox.label.height/2) - 8 or
                   arg.o.label.y == "center" and newBox.y or
                   arg.o.label.y == "bottom" and newBox.contentBounds.yMax + (newBox.label.height/2) + 8
  newBox.label.x = newBox.label.x + arg.o.label.adjustX
  newBox.label.y = newBox.label.y + arg.o.label.adjustY
  newBox.isHitTestable = true
  newBox.options = arg.o
  newBox:addEventListener("touch", function(e)
      
      index = table.indexOf( inputBox[sceneName], e.target )
    if keyboardType ~= "native" then
      if e.phase == "began" then
        
      end
      if e.phase == "ended" then
        if currentInputBox ~= nil and prevInputBox ~= nil then
          currentInputBox.input.text = currentInputBox.input.text == "" and currentInputBox.options.help or currentInputBox.input.text
          currentInputBox:setStrokeColor( rgb.color(currentInputBox.options.boxColor[1], currentInputBox.options.boxColor[2] ))
          e.target:setStrokeColor( rgb.color( e.target.options.focus[1], e.target.options.focus[2] ))
          prevInputBox = currentInputBox
          currentInputBox = e.target
          keyboardShow({keyboard = e.target.options.limit})
        else
          e.target:setStrokeColor( rgb.color( e.target.options.focus[1], e.target.options.focus[2] ))
          prevInputBox = e.target
          currentInputBox = e.target
          keyboardShow({keyboard = e.target.options.limit})
        end
      end
    else
      if e.phase == "began" then
        nativeBox = native.newTextField(-1000, -1000, 1, 1)
        nativeBox.inputType = (arg.o.limit == "numPad" or arg.o.limit == "numPad_noArrow") and "number" or "help"
        nativeBox.isEditable = true
        nativeBox.isSecure = arg.o.isPassword
        timer.performWithDelay( 150, function()  
          Runtime:dispatchEvent( { name = "keyboard",
                                phase = "changePosition",
                                speed = nil,
                               height = nil,
                               amount = inputBox[sceneName][index].y > display.contentCenterY and
                                        -(inputBox[sceneName][index].y - display.contentCenterY) - inputBox[sceneName][index].height or 0 })
        end)
        nativeBox:addEventListener("userInput", function(e)
          inputBox[sceneName][index]:setStrokeColor( rgb.color( inputBox[sceneName][index].options.focus[1], inputBox[sceneName][index].options.focus[2] ))
          flash = timer.performWithDelay( 500, cursor ,0 )
          if e.phase == "began" then
            if inputBox[sceneName][index].input.text == inputBox[sceneName][index].options.help then
              e.target.text = ""
              inputBox[sceneName][index].input.text = ""
            end
          end
          if e.phase == "editing" and sceneName then
            if #e.text < #inputBox[sceneName][index].options.staticText then
              e.text = inputBox[sceneName][index].options.staticText
            end
            e.text = string.sub( e.text, 1, inputBox[sceneName][index].options.maxChar )
            inputBox[sceneName][index].input.text = e.text
          end
          if (e.phase == "submitted" or e.phase == "ended") and sceneName then
            timer.cancel( flash )
            if e.target.text == "" then
              inputBox[sceneName][index].input.text = inputBox[sceneName][index].options.help
            end
            inputBox[sceneName][index]:setStrokeColor( rgb.color(inputBox[sceneName][index].options.boxColor[1], inputBox[sceneName][index].options.boxColor[2] ))
            native.setKeyboardFocus(nil)
            Runtime:dispatchEvent( { name = "keyboard",
                                    phase = "returnPosition",
                                    speed = nil,
                                   height = nil,
                                   amount = 0} )
            nativeBox:removeSelf( )
          end
        end)
      end
      if e.phase == "ended" then
        native.setKeyboardFocus(nativeBox)
      end
    end
  end)
  if inputBox[sceneName] == nil then
    inputBox[sceneName] = {}
  end
  if fieldTable[sceneName] == nil then
    fieldTable[sceneName] = {}
  end
  inputBox[sceneName][#inputBox[sceneName]+1] = newBox
  fieldTable[sceneName][arg.o.label.text] = newBox.input.text == arg.o.help and "noInput" or newBox.input.text
  if arg.g ~= nil then
    arg.g:insert(boxGroup)
  end
  boxGroup.text = newBox.input.text
  touchGroup:insert(boxGroup)
  arg.g:insert(touchGroup)
  return boxGroup
end
--------------------------------------getFieldResults

function M.getFieldResults(arg)
  local arg = arg or nil
  local tbl
  if fieldTable[arg] ~= nil then
    tbl = fieldTable[arg]
  else
    tbl = fieldTable
  end
  print("\n")
  print(fieldTable[arg] == nil and "ALL FIELDS" or "FIELD GROUP "..arg)
  print("{")
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      print("",k.." = {")
      for k1, v1 in pairs(v) do
        print("","",k1.." = "..v1..",")
      end
    else
      print("","",k.." = "..v..",")
    end
  end     
  print("","","}")
  print(fieldTable[arg] == nil and "}" or "")
  if fieldTable[arg] then return fieldTable[arg] else return fieldTable end
end

return M







