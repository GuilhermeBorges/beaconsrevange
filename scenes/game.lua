----------------------------------------------
--- IMPORTS ----------------------------------
----------------------------------------------

local composer = require( "composer" )

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
-- physics.setDrawMode('hybrid')

----------------------------------------------
--- CREATING SCENE --------------------------
----------------------------------------------

local scene = composer.newScene()
local sceneGroup

----------------------------------------------
--- SCENE's VARIABLES ------------------------
----------------------------------------------

-- Screen sizes
local screenW = display.contentWidth 
local screenH = display.contentHeight
local halfW = display.contentWidth*0.5
local lifes = 3
local animals = 0

----------------------------------------------
--- SCENE's aux-FUNCTIONS --------------------
----------------------------------------------

-- function tap_animal:tap(event)
-- 	local animal = event.target
-- 	animals = animals + 1
-- 	animal:removeSelf()
-- 	return
-- end

function create_animals()
	-- Creating the cow (off-screen), position it, and rotate slightly
	local aux = math.random(0,screenW)
	local animal
	if aux % 2 == 0 then
		animal = display.newImageRect( "img/vaca_a2.png", 74, 74 )
		animal.x, animal.y = aux, -100
		animal.name = "cow"

		-- add physics to the cow
		physics.addBody( animal, { density=5, friction=0.3, bounce=0.6 , radius = 35} )
		sceneGroup:insert(animal)

	elseif aux % 3 ==0 then
		animal = display.newImageRect( "img/ovelha_a2.png", 66, 60 )
		animal.x, animal.y = aux, -100
		animal.name = "sheep"
	-- add physics to the sheep
		physics.addBody( animal, { density=1.0, friction=0.3, bounce=0.8 , radius = 29} )

	
	else
		animal = display.newImageRect( "img/porco_a4.png", 69, 65 )
		animal.x, animal.y = aux, -100
		animal.name = "pig"
	-- add physics to the sheep
		physics.addBody( animal, { density=3, friction=0.3, bounce=0.7 , radius = 31} )

	end

	animal.rotation = aux % 30
	animal.anchorX = 0.5
	animal.anchorY = 0.6
	sceneGroup:insert(animal)
	local function animal_touch(event)
		local animal = event.target
		animals = animals + 1
		animal:removeSelf()
		print(aniamls)
		return true
	end
	animal:addEventListener("touch",animal_touch)

	return animal	
end

-- function create_animals(sceneGroup)
-- 	-- Creating the cow (off-screen), position it, and rotate slightly
-- 		local cow = display.newImageRect( "img/vaca_a2.png", 74, 74 )
-- 		cow.x, cow.y = aux, -100
-- 		cow.rotation = 15
-- 		cow.anchorX = 0.5
-- 		cow.anchorY = 0.6

-- 		-- add physics to the cow
-- 		physics.addBody( cow, { density=1.0, friction=0.3, bounce=0.3 , radius = 37} )
-- 		sceneGroup:insert(cow)
-- 		return cow
-- end
----------------------------------------------
--- SCENE MAIN FUNCTIONS ---------------------
----------------------------------------------

--- Create -----------------------------------
	-- This will create all the backgrounds and structure of the scene
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

function scene:create( event )
	sceneGroup = self.view

	-- creating background with the size of the screen
	local background = display.newImageRect( "img/churrasqueira.jpg", 400, 650 )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, -40 -- Set the image at the top left


	local bottom = display.newRect(halfW,screenH+45,screenW,1)
	bottom:setFillColor(0,255,0)
	bottom.alpha = 0
	physics.addBody( bottom, "static", { friction=0.3} )

	local left_wall = display.newRect(0,halfW+90,1,screenH+100)
	left_wall:setFillColor(0,255,0)
	left_wall.alpha = 0
	physics.addBody( left_wall, "static", { friction=0.3} )

	local right_wall = display.newRect(screenW,halfW+90,1,screenH+100)
	right_wall:setFillColor(0,255,0)
	right_wall.alpha = 0
	physics.addBody( right_wall, "static", { friction=0.3} )



	-- local right_wall = display.newRect(-halfW,0+40,10,screenH)
	-- right_wall:setFillColor(0,255,0)
	-- right_wall.alpha = 0
	-- physics.addBody( right_wall, "static", { friction=0.3} )


-- The order here matters, since if i display the background after generating the animals it will not displauy the animals, the backgorund will be over then.
	sceneGroup:insert( background )
	sceneGroup:insert( bottom )
	sceneGroup:insert( left_wall )
	sceneGroup:insert( right_wall )
	timer.performWithDelay(500, create_animals, 100);


end

--- Show -------------------------------------

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
		physics.start()
	end
end

--- Hide -------------------------------------

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

--- Destroy ----------------------------------

function scene:destroy( event )
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

----------------------------------------------
--- SCENE LISTENERS --------------------------
----------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------
return scene