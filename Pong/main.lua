--this is the one that I made...

local push = require 'push-master'

Class = require 'Class'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('Font.TTF', 8)
    love.graphics.setFont(smallFont)

    scoreFont = love.graphics.newFont('Font.TTF', 32)
    largeFont = love.graphics.newFont('Font.TTF', 16)

    sounds = {
        ['Paddle_Hit'] = love.audio.newSource('sounds/Paddle_Hit.wav', 'static'),
        ['Goal'] = love.audio.newSource('sounds/Goal.wav', 'static'),
        ['Top_Wall_Hit'] = love.audio.newSource('sounds/Top_Wall_Hit.wav', 'static'),
        ['Bottom_Wall_Hit'] = love.audio.newSource('sounds/Bottom_Wall_Hit.wav', 'static'),
        ['Victory'] = love.audio.newSource('sounds/Victory.mp3', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    servingPlayer = 1

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        servingPlayer = 1

        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
        
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['Paddle_Hit']:play()
        end
        
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
        
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['Paddle_Hit']:play()
        end
    
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['Top_Wall_Hit']:play()
        end
    
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['Bottom_Wall_Hit']:play()
        end

        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            if player2Score == 10 then
                sounds['Victory']:play()
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
            sounds['Goal']:play()
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            if player1Score == 10 then
                sounds['Victory']:play()
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
            sounds['Goal']:play()
        end
    end

    player1.y = ball.y

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then 
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end 

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit();
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'

            ball:reset()
            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else 
                servingPlayer = 1
            end
        end
    elseif key == 'space' then
        gameState = 'start'

        ball:reset()
        player1.y = 30
        player2.y = VIRTUAL_HEIGHT - 30
        player1Score = 0
        player2Score = 0

        if winningPlayer == 1 then
           servingPlayer = 2
        else 
            servingPlayer = 1
        end
    end
end

function love.draw()
    --love.graphics.printf(
    --    'Hello Pong!',
    --    0,
    --    WINDOW_HEIGHT / 2 - 6,
    --    WINDOW_WIDTH, 
    --    'center')
    push:apply('start')
    --love.graphics.printf('Hello Pong!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
    --push:apply('end')

    love.graphics.clear(0, 0, 0, 255)

    displayScore()

    love.graphics.setFont(smallFont)

    if gameState =='start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Begin!', 0, 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Space Anytime to Restart!', 0, 60, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        if servingPlayer == 1 then
            love.graphics.printf("Player 1's Serve!", 0, 20, VIRTUAL_WIDTH, 'center')
        elseif servingPlayer == 2 then
            love.graphics.printf("Player 2's Serve!", 0, 20, VIRTUAL_WIDTH, 'center')
        end
        love.graphics.printf('Press Enter to Serve!', 0, 40, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.printf(' ', 0, 40, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        if winningPlayer == 1 then
            love.graphics.printf('Player 1 wins!', 0, 40, VIRTUAL_WIDTH, 'center')
        elseif winningPlayer == 2 then
            love.graphics.printf('Player 2 wins!', 0, 40, VIRTUAL_WIDTH, 'center')
        end
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to Restart!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    player1:render()
    player2:render()
    ball:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end