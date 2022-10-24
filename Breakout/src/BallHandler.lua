BallHandler = Class{}

function BallHandler:init()
    self.balls = {
        Ball(math.random(7), VIRTUAL_WIDTH / 2, 4 * VIRTUAL_HEIGHT / 5, 0, 0)
    }
    return self.balls
end

function BallHandler:createBalls(num)
    for i = 0, num do
        table.insert(self.balls, Ball(math.random(7)))
    end
    return self.balls
end

function BallHandler:removeBalls(num)
    for i = num, 1, -1 do
        table.remove(self.balls, num)
    end
end