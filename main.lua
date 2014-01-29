display.setStatusBar(display.HiddenStatusBar)
print ( "______________________________NEW RUN______________________________")

-- things to add/fix
--    isPassword 
--    staticText for native keyboard
--    new text removes when typing on native keyboard
--    multiLine box & scroll
--    cursor

--------------------------------------------------------------------------------
local keyboard  = require '_keyboard5'                  -- require keyboard
local dGroup = display.newGroup( )
--------------------------------------------------------------------------------
                                                        -- all options are optional, default is native keyboard
local options = {  type = "custom",                     -- keyboard to show, native/custom, all other options are for custom only
                  speed = 300,                          -- speed to show/hide keyboard 
                 bounce = true,                         -- keys bounce when pressed
                  click = true,                         -- play click sound when pressed
             background = {"lightGray",0.8},            -- keyboard background color, arg1 is color name, arg2 is alpha
       backgroundStroke = {"darkGray",1},               -- background stroke color,   arg1 is color name, arg2 is alpha      
                    key = {"white",0.9,                 -- key color,                 arg1 is color name, arg2 is alpha,
                           "cornflowerBlue",            --                            arg3 shift key color,
                           "cornflowerBlue"},           --                            arg4 is symbol key color 
              keyStroke = {"black",1},                  -- key stroke color,          arg1 is color name, arg2 is alpha
                letters = {"black",1,"cornflowerBlue"}, -- letter color,              arg1 is color name, arg2 is alpha, arg3 is color when pressed     
                   font = native.systemFontBold }       -- font for letters
                                              
--------------------------------------------------------------------------------
    keyboard.init( options )                     -- init keyboard

--------------------------------------------------------------------------------
                                                 -- all options are optional
local Options1 = { help = "First & Last",        -- help text
              textColor = {"black",1},           -- color of text in box, arg1 is color name, arg2 is alpha
               boxColor = {"white",1},           -- color of field box, arg1 is color name, arg2 is alpha
            strokeColor = {"white",1},           -- color of field box stroke, arg1 is color name, arg2 is alpha
            strokeWidth = 8,                     -- width of field box stroke
                  focus = {"cornflowerBlue", 1},  -- color of field box stroke when has focus, arg1 is color name, arg2 is alpha
                   font = {nil, 28},             -- font and fontSize for text  
                maxChar = 20,                    -- max characters allowed
             isPassword = true,                  -- field box is a password, only works on native
             staticText = "",                    -- text to remain in field box, some issues with native at moment
                  label = {text = "Name",        -- label for field box
                              x = "left",        -- x placement, "left", "center", "right"
                              y = "center",      -- y placement, "top", "center", "bottom"
                        adjustX = 0,             -- x label adjustment
                        adjustY = 0,             -- y label adjustment
                          color = {"white",1},   -- label color, arg1 is color name, arg2 is alpha
                           font = {nil, 28}},    -- label font and fontSize
                  limit = "alpha",               -- keyboard options, "standard","alpha","noArrow","alphaNoArrow","numPad","numPad_noArrow"
                  align = "left" }               -- "left","center","right"

local Options2 = { help = "Physical Address",     
        isScrollEnabled = true,            
              textColor = {"black",1},        
               boxColor = {"white",1},        
            strokeColor = {"white",1},        
            strokeWidth = 8,                  
                  focus = {"cornflowerBlue", 1},
                   font = {nil, 28},          
                maxChar = 200,                 
             isPassword = false,              
             staticText = "",                 
                  label = {text = "Address",   
                              x = "left",     
                              y = "top",
                        adjustX = 0,
                        adjustY = 42,   
                          color = {"white",1},
                           font = {nil, 28}}, 
                  limit = "standard",
                  align = "center" }   

local Options3 = { help = "Home",     
              textColor = {"black",1},        
               boxColor = {"white",1},        
            strokeColor = {"white",1},        
            strokeWidth = 8,                  
                  focus = {"cornflowerBlue", 1},
                   font = {nil, 28},          
                maxChar = 20,                 
             isPassword = false,              
             staticText = "",                 
                  label = {text = "Phone #",   
                              x = "left",     
                              y = "center",  
                              adjustX = 0,
                              adjustY = 0, 
                          color = {"white",1},
                           font = {nil, 28}}, 
                  limit = "numPad",
                  align = "right" }

          -- ( x, y, width, height, cornerRadius, options )

local box1 = display.newInputBox( dGroup, 360, 48, 360, 48, Options1 )
    
local box2 = display.newInputBox( dGroup, 360, 160, 360, 128, 16, Options2 )

local box3 = display.newInputBox( dGroup, 360, 600, 360, 48, 0, Options3 )
    
local cir = display.newCircle(dGroup, 360, 300, 50 ) -- just added for extra objects on screen
--------------------------------------------------------------------------------
-- table = keyboard.getFieldResults( arg )
-- arg is name of scene to get results for
-- if left blank of scene doesn't exist
-- then its returned as a table named fieldList

--local myResults = keyboard.getFieldResults( )
--print(myResults.fieldList.Name)

-- to move display with keyboard
-- returned events - name,phase,height,speed,amount
-- if using storyboard or composer move the current scenes' group
Runtime:addEventListener( "keyboard", function(e)
  print(e.phase)
  if e.phase == "changePosition" then
    dGroup.y = e.amount
  end
  if e.phase == "isShowing" then
    dGroup.y = e.amount
  end
  if e.phase == "returnPosition" then
    dGroup.y = e.amount
  end
end)


