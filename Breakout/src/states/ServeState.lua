ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    if gGot == true then
        self.locked = params.locked
    else
        self.locked = LockedBrick()
    end
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = params.recoverPoints
    if gGotIt == true then
        self.balls = params.balls
    else
        self.balls = BallHandler:init()
    end
end

function ServeState:update(dt)
    self.paddle:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            locked = self.locked,
            balls = self.balls,
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            level = self.level,
            recoverPoints = self.recoverPoints
        })
    end
    
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    for b, ball in pairs(self.balls) do
        ball:render()
    end

    self.paddle:render()
    
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 3,
    VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
    VIRTUAL_WIDTH, 'center')
end