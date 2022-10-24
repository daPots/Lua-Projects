CountDownState = Class{__includes = BaseState}

COUNT_DOWN_TIME = 0.75

function CountDownState:enter(params)
    self.playerStats = playerStats
end

function CountDownState:init()
    self.count = 3
    self.timer = 0
end

function CountDownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNT_DOWN_TIME then
        self.timer = self.timer % COUNT_DOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gLastState = 'countdownState'
            gStateMachine:change('play', playerStats)
        end
    end
end

function CountDownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end