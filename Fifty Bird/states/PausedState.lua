PausedState = Class{__includes = BaseState}

function PausedState:enter(params)
    self.score = params['score']
    self.bird = params['bird']
    self.timer = params['timer']
    self.pipePairs = params['pipePairs']
    self.lastY = params['lastY']
end

function PausedState:update(dt)


    sounds['music']:pause()

    if love.keyboard.wasPressed('p') then
        gLastState = 'pausingState'
        gStateMachine:change('play', {
            score = self.score,
            bird = self.bird,
            timer = self.timer,
            pipePairs = self.pipePairs,
            lastY = self.lastY
        })
    end
end

function PausedState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('The Game is Paused', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press P to Resume!', 0, 160, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(smallFont)
    love.graphics.printf('Current Score: ' .. tostring(self.score), 0, 190, VIRTUAL_WIDTH, 'center')
end