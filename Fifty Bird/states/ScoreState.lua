ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params
end

function ScoreState:init()
    local bronze = love.graphics.newImage('images/flappy_bronze.png')
    local silver = love.graphics.newImage('images/flappy_silver.png')
    local gold = love.graphics.newImage('images/flappy_gold.png')
end

function ScoreState:update(dt)
    sounds['music']:pause()
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gLastState = 'ScoringState'
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oops! You Lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')

    if self.score <= 5 then
        love.graphics.printf('Bronze!', (VIRTUAL_WIDTH / 2)*1.125, 200, VIRTUAL_WIDTH / 2, 'center')
        love.graphics.draw(love.graphics.newImage('images/flappy_bronze.png'), (VIRTUAL_WIDTH / 2)*1.5, VIRTUAL_HEIGHT / 2 , 0, .075, .075)
    elseif self.score > 5 and self.score <= 10 then
        love.graphics.printf('Silver!', (VIRTUAL_WIDTH / 2)*1.125, 210, VIRTUAL_WIDTH / 2, 'center')
        love.graphics.draw(love.graphics.newImage('images/flappy_silver.png'), (VIRTUAL_WIDTH / 2)*1.5, VIRTUAL_HEIGHT / 2 , 0, .125, .125)
    elseif self.score > 10 then
        love.graphics.printf('Gold!', (VIRTUAL_WIDTH / 2)*1.125, 200, VIRTUAL_WIDTH / 2, 'center')
        love.graphics.draw(love.graphics.newImage('images/flappy_gold.png'), (VIRTUAL_WIDTH / 2)*1.27, (VIRTUAL_HEIGHT / 2)*.65, 0, .3, .3)
    end
end