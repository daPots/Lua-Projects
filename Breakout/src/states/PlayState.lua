PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.locked = params.locked
    self.paddle = params.paddle
    self.balls = params.balls
    self.health = params.health
    self.score = params.score
    self.bricks = params.bricks
    self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = 5000
    self.state = 'play'

    for b, ball in pairs(self.balls) do
        ball.x = math.random(self.paddle.x, self.paddle.x + self.paddle.width)
        ball.y = self.paddle.y - 8
        ball.dx = math.random(-200, 200)
        ball.dy = math.random(50, 80)
    end

    self.paused = false
    self.extraBalls = PowerBall()
    self.key = PowerKey()
    self.ballBag = {}

    if gUnlocked == false then
        i = math.random(#self.bricks)
        local ex = self.bricks[i].x
        local why = self.bricks[i].y
        table.remove(self.bricks, i)
        self.locked.x = ex
        self.locked.y = why
        table.insert(self.bricks, self.locked)
    end
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
            gSounds['music']:play()
        elseif love.keyboard.wasPressed('escape') then
            love.event.quit()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        gSounds['music']:pause()
        return
    end

    self.paddle:update(dt)
    self.extraBalls:update(dt)
    self.key:update(dt)

    if self.score % 300 == 0 and self.score ~= 0 and self.state == 'play' then
        if self.paddle.size < 4 then
            self.paddle.size = self.paddle.size + 1
            self.paddle.size = self.paddle.size
            self.paddle.width = self.paddle.width + 32
        end
    end

    for b, ball in pairs(self.balls) do
        ball:update(dt)
    end

    for b, ball in pairs(self.balls) do
        if self.extraBalls.inPlay and ball:collides(self.extraBalls) and gGotIt == false then
            self.extraBalls:hit()
            gGotIt = true
            local second = Ball(math.random(7), ball.x, ball.y, math.random(-40, -80), math.random(-60, 60))
            local third = Ball(math.random(7), ball.x, ball.y, math.random(-40, -80), math.random(-60, 60))
            table.insert(self.ballBag, second)
            table.insert(self.ballBag, third)
        end
    end

    for b, ball in pairs(self.balls) do
        if self.key.inPlay and ball:collides(self.key) and gUnlocked == false then
            self.key:hit()
            gUnlocked = true
        end
    end

    for b, ball in pairs(self.ballBag) do
        table.insert(self.balls, ball)
    end

    for b in pairs (self.ballBag) do
        self.ballBag[b] = nil
    end

    for b, ball in pairs(self.balls) do
        for k, brick in pairs(self.bricks) do
            if brick.inPlay and ball:collides(brick) then
                if brick == self.locked then
                    if gUnlocked == true then
                        self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    end
                else
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
                end
                brick:hit()
                if self:checkVictory() then
                    gSounds['victory']:play()
                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        balls = self.balls,
                        highScores = self.highScores
                    })
                end
                    
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                elseif ball.y < brick.y then
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                else
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end
                break
            end
        end
    end

    for b, ball in pairs(self.balls) do
        if ball:collides(self.paddle) then
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy
        
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
        
            gSounds['paddle-hit']:play()
        end
    end

    for b, ball in pairs(self.balls) do
        if ball.y >= VIRTUAL_HEIGHT then
            self.health = self.health - 1
            if self.paddle.size > 1 then
                self.paddle.size = self.paddle.size - 1
                self.paddle.width = self.paddle.width - 32
            end
            gSounds['hurt']:play()
            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve', {
                    balls = self.balls,
                    paddle = self.paddle,
                    paddleSize = self.paddle.size,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints
                })
            end
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end
    
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    
    for b, ball in pairs (self.balls) do
        ball:render()
    end
    
    if gGotIt == false then
        self.extraBalls:render()
    end

    if gUnlocked == false then
        self.key:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end
    return true
end