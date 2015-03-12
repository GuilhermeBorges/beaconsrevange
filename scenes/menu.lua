-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- Include Corona's "physics" library
local physics = require "physics"
physics.start();
-- physics.setDrawMode('hybrid')

----------------------------------------------
--- SCENE's VARIABLES ------------------------
----------------------------------------------

-- Screen sizes
local screenW = display.contentWidth 
local screenH = display.contentHeight
local halfW = display.contentWidth*0.5




-- forward declarations and other locals
local playBtn
local grass
local cow
--------------------------------------------



-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	-- composer.gotoScene( "scenes.level1", "fade", 500 )
	composer.gotoScene( "scenes.game", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "img/cloud.png", 385, 575)
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, -50	

	

	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "img/logo.png", 264, 42 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play Now",
		labelColor = { default={255}, over={128} },
		default="img/button.png",
		over="img/button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125



	-- Creating the cow (off-screen), position it, and rotate slightly
	cow = display.newImageRect( "img/vaca_a2.png", 74, 74 )
	cow.x, cow.y = 160, -100
	cow.rotation = 15
	cow.anchorX = 0.5
	cow.anchorY = 0.6

	-- add physics to the cow
	physics.addBody( cow, { density=1.0, friction=0.3, bounce=1 , radius = 37} )

	
	-- create the floor and add physics (with custom shape)
	grass = display.newImageRect( "img/grass.png", 555.5, 114 )
	grass.anchorX = 0
	grass.anchorY = 1
	grass.x, grass.y = 0, display.contentHeight + 50


	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -2*halfW,10, 2*halfW,10, 2*halfW,40, -2*halfW,40 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group

	sceneGroup:insert( background )
	sceneGroup:insert( cow )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( grass )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		if not ( physics.removeBody( cow ) ) then

    		print( "Could not remove physics body" )

		end
		cow:removeSelf()
		cow = nil
		if grass then
			physics.removeBody(grass)
			grass:removeSelf()
			grass = nil
		end
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	-- if cow then
		if not ( physics.removeBody( cow ) ) then

    		print( "Could not remove physics body" )

		end
		cow:removeSelf()
		cow = nil
	-- end

	if grass then
		physics.removeBody(grass)
		grass:removeSelf()
		grass = nil
	end

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene