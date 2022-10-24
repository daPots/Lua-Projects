PowerKey = Class{}

function PowerKey:init()
    self.x = math.random(15, VIRTUAL_WIDTH - 15)
    self.y = math.random(((VIRTUAL_HEIGHT / 2) * .75), VIRTUAL_HEIGHT - 50)
    self.dy = 0
    self.width = 16
    self.height = 16
    self.inPlay = true
end

function PowerKey:update(dt)
    if gUnlocked == false then
        self.y = self.y + 0.1
        if self.y >= VIRTUAL_HEIGHT then
            self.y = (VIRTUAL_HEIGHT / 2) * .75
        end
    end
end

function PowerKey:hit()
    gSounds['unlocked']:stop()
    gSounds['unlocked']:play()
    self.inPlay = false
end

function PowerKey:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['key'],  self.x, self.y)
    end
end