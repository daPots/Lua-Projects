PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:enter(params)
    if gLastState ~= 'pausingState' then
        self.bird = Bird()
        self.pipePairs = {}
        self.timer = 0
        self.score = 0
        self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    elseif gLastState == 'pausingState' then
        self.bird = params.bird
        self.pipePairs = params.pipePairs
        self.timer = params.timer
        self.score = params.score
        self.lastY = params.lastY
    end
end

function PlayState:update(dt)
    sounds['music']:play()

    self.timer = self.timer + dt

    playerStats = {
        ['score'] = self.score,
        ['bird'] = self.bird,
        ['pipePairs'] = self.pipePairs,
        ['timer'] = self.timer,
        ['score'] = self.score,
        ['lastY'] = self.lastY
    }

    if love.keyboard.wasPressed('p') then
        gLastState = 'playingState'
        gStateMachine:change('paused', playerStats)
    end
    
    if self.timer > math.random(2, 5) then
        local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-20, 20), 
            VIRTUAL_HEIGHT - 70 - PIPE_HEIGHT))
        self.lastY = y
    
        table.insert(self.pipePairs, PipePair(y))
        self.timer = math.random(-1, 0)
    end

    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        pair:update(dt)
    end
    
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                gLastState = 'playingState'
                gStateMachine:change('score', playerStats['score'])
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gLastState = 'playingState'
        gStateMachine:change('score', playerStats['score'])
    end

    if self.bird.y <= 0 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gLastState = 'playingState'
        gStateMachine:change('score', playerStats['score'])
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end