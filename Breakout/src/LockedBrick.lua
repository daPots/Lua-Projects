LockedBrick = Class{}

function LockedBrick:init()
    self.width = 32
    self.height = 16
    self.inPlay = true
    self.tier = 10
    self.color = 6

    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
    self.psystem:setParticleLifetime(0.5, 1)
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    self.psystem:setEmissionArea('normal', 5, 5)
    self.psystem:setSizes(.5)
end

function LockedBrick:hit()
    if gUnlocked == false then
        gSounds['wall-hit']:stop()
        gSounds['wall-hit']:play()
    elseif gUnlocked == true then
        self.psystem:setColors(37/255, 40/255, 60/255, 0.75)
        self.psystem:emit(64)
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
        self.inPlay = false

        if not self.inPlay then
            gSounds['brick-hit-1']:stop()
            gSounds['brick-hit-1']:play()
        end
    end
end

function LockedBrick:update(dt)
    self.psystem:update(dt)
end

function LockedBrick:render()
    if self.inPlay then
        if gUnlocked == true then
            love.graphics.draw(gTextures['main'], gFrames['unlocked-brick'],  self.x, self.y)
        else
            love.graphics.draw(gTextures['main'], gFrames['locked-brick'],  self.x, self.y)
        end
    end
end

function LockedBrick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end