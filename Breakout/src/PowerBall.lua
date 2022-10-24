PowerBall = Class{}

function PowerBall:init()
    self.x = math.random(15, VIRTUAL_WIDTH - 15)
    self.y = (VIRTUAL_HEIGHT / 2) * .75
    self.dy = 0
    self.width = 16
    self.height = 16
    self.inPlay = true
end

function PowerBall:update(dt)
    if gGotIt == false then
        self.y = self.y + 0.1
        if self.y >= VIRTUAL_HEIGHT then
            self.y = (VIRTUAL_HEIGHT / 2) * .75
        end
    end
end

function PowerBall:hit()
    gSounds['extra-balls']:stop()
    gSounds['extra-balls']:play()
    self.inPlay = false
end

function PowerBall:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['extra-balls'],  self.x, self.y)
    end
end