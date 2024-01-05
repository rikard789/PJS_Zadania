require "blockTypes"
local serpent = require("serpent")
local Tetris = {}

function Tetris:new()
    local tetris = {
        grid = {},
        blockSize = 30,
        width = 10,
        height = 20,
        offset = 2,
        currentBlock = nil,
        timer = 0,
        fallSpeed = 1,
        score = 0,
        isGameOver = false,
        isPaused = false,
        lineClear = false,
        lineClearTimer = 0,
        lineFadeSpeed = 0.05,
        lineClearDuration = 1,
        linesToClear = nil,
        fontSize = 30,
        colors = {
            {255, 0, 0}, -- Red
            {0, 255, 0}, -- Green
            {0, 0, 255}, -- Blue
            {255, 255, 0}, -- Yellow
            {255, 0, 255}, -- Magenta
        }
    }

    for i = 1, tetris.height do
        tetris.grid[i] = {}
        for j = 1, tetris.width - 1 do
            tetris.grid[i][j] = nil
        end
    end

    font = love.graphics.newFont(tetris.fontSize)
    setmetatable(tetris, { __index = Tetris })
    tetris:createNewBlock()
    return tetris
end

function Tetris:update(dt)
    if not self.isGameOver and not self.isPaused then
        self.timer = self.timer + dt
        if self.timer >= self.fallSpeed then
            self:moveDown()
            self.timer = 0
        end
    end
    
    if self.isGameOver then
        gameOverSoundEffect:play()
    end
    if self.lineClear then
        self.lineClearTimer = self.lineClearTimer + dt

        if self.lineClearTimer >= self.lineClearDuration then
            self.linesToClear = nil
            self.lineClear = false
            self.lineClearTimer = 0
        end
        clearLineSoundEffect:stop()
        clearLineSoundEffect:play()
    end    
end

function Tetris:draw()

    local windowWidth, windowHeight = love.graphics.getDimensions()
    local rightOffet = 400

    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('Score: '..self.score, love.graphics.getWidth() - rightOffet, self.fontSize)
	love.graphics.print('Move: left, right, down', love.graphics.getWidth() - rightOffet, self.fontSize*3)
	love.graphics.print('Rotate: up', love.graphics.getWidth() - rightOffet, self.fontSize*4)
	love.graphics.print('Drop: space', love.graphics.getWidth() - rightOffet, self.fontSize*5)
	love.graphics.print('Pause: P', love.graphics.getWidth() - rightOffet, self.fontSize*6)
    love.graphics.print('Save game: S', love.graphics.getWidth() - rightOffet, self.fontSize*7)
    love.graphics.print('Load last game: L', love.graphics.getWidth() - rightOffet, self.fontSize*8)

    if self.isGameOver then
        love.graphics.newFont(50)
        love.graphics.setFont(font)
        love.graphics.print('Game Over!', love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2 - 50)
    end

    

    for i = 1, self.width do
        love.graphics.line(i * self.blockSize, 0, i * self.blockSize - self.offset, self.height * self.blockSize - self.offset)
    end
    for i = 1, self.height do
        love.graphics.line(self.blockSize, i * self.blockSize, self.width * self.blockSize - self.offset, i * self.blockSize - self.offset)
    end
    
    for i = 1, self.height do
        for j = 1, self.width do
            if self.grid[i][j] then
                if self.lineClear and lineToClear == i then
                    tetris:drawLineClearAnimation()
                else    
                    love.graphics.setColor({255,255,255})
                    love.graphics.rectangle("line", j * self.blockSize - self.offset, i * self.blockSize - self.offset, self.blockSize - self.offset, self.blockSize - self.offset)
                    love.graphics.setColor(self.grid[i][j])
                    love.graphics.rectangle("fill", j * self.blockSize - 1, i * self.blockSize - 1, self.blockSize - self.offset*2, self.blockSize - self.offset*2)
                end    
            end
        end
    end

    if self.currentBlock then
        for i, row in ipairs(self.currentBlock.shape) do
            for j, value in ipairs(row) do
                if value == 1 then
                    local x, y = self.currentBlock.x + j - 1, self.currentBlock.y + i - 1
                    love.graphics.setColor({255,255,255})
                    love.graphics.rectangle("line", x * self.blockSize - self.offset, y * self.blockSize - self.offset, self.blockSize - self.offset, self.blockSize - self.offset)
                    love.graphics.setColor(self.currentBlock.color)
                    love.graphics.rectangle("fill", x * self.blockSize - 1, y * self.blockSize - 1, self.blockSize - self.offset*2, self.blockSize - self.offset*2)
                end
            end
        end
    end
end

function Tetris:drawLineClearAnimation()
    local alpha = 255 * (1 - self.lineClearTimer / self.lineClearDuration)
    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.rectangle("fill", self.blockSize - 1, self.lineToClear * self.blockSize - 1, self.blockSize - self.offset*2, self.blockSize - self.offset*2)
end

function Tetris:keyPressed(key)
    if key == "left" then
        self:moveLeft()
    elseif key == "right" then
        self:moveRight()
    elseif key == "down" then
        self:moveDown()
    elseif key == "up" then
        self:rotate()
    elseif key == "s" then
        tetris:save()
    elseif key == "l" then
        tetris:load()
    elseif key == "p" then
        if not self.isPaused then
            self.isPaused = true
        else
            self.isPaused = false 
        end            
    end
end

function Tetris:moveLeft()
    if self:canMove(self.currentBlock, self.currentBlock.x - 1, self.currentBlock.y) then
        self.currentBlock.x = self.currentBlock.x - 1
    end
end

function Tetris:moveRight()
    if self:canMove(self.currentBlock, self.currentBlock.x + 1, self.currentBlock.y) then
        self.currentBlock.x = self.currentBlock.x + 1
    end
end

function Tetris:moveDown()
    if self:canMove(self.currentBlock, self.currentBlock.x, self.currentBlock.y + 1) then
        self.currentBlock.y = self.currentBlock.y + 1
    else
        self:placeBlock()
        self:createNewBlock()
    end
end

function Tetris:rotate()
    local rotatedBlock = self:rotateBlock(self.currentBlock)
    if self:canMove(rotatedBlock, self.currentBlock.x, self.currentBlock.y) then
        self.currentBlock = rotatedBlock
    end
end

function Tetris:rotateBlock(block)
    local rotatedShape = {}
    for j = 1, 4 do
        rotatedShape[j] = {}
        for i = 1, 4 do
            rotatedShape[j][5 - i] = block.shape[i][j]
        end
    end
    block.shape = rotatedShape
    return block
end

function Tetris:save()
    local serializedGameState = serpent.dump({ grid = self.grid, currentBlock = self.currentBlock })
    love.filesystem.write("savegame.txt", serializedGameState)
end

function Tetris:load()
    local success, serializedGameState = pcall(love.filesystem.read, "savegame.txt")
    if success then
        local loadedGameState = loadstring(serializedGameState)()
        self.grid = loadedGameState.grid
        self.currentBlock = loadedGameState.currentBlock
    else
        print("Failed to load the game.")
    end
end

function Tetris:createNewBlock()
    local blockTypes = require 'blockTypes'

    local shape = blockTypes[love.math.random(1, #blockTypes)]
    local color = self.colors[love.math.random(1, #self.colors)]

    self.currentBlock = {
        x = math.floor(self.width / 2) - 2,
        y = -1,
        shape = shape,
        color = color
    }

    if not self:canMove(self.currentBlock, self.currentBlock.x, self.currentBlock.y) then
        self.isGameOver = true
        print("Game Over!")
    end
end

function Tetris:canMove(block, newX, newY)
    for i, row in ipairs(block.shape) do
        for j, value in ipairs(row) do
            if value == 1 then
                local x, y = newX + j - 1, newY + i - 1
                if x < 1 or x > self.width - 1 or y > self.height - 1 or (y > 0 and self.grid[y][x]) then
                    return false
                end
            end
        end
    end
    return true
end

function Tetris:placeBlock()
    for i, row in ipairs(self.currentBlock.shape) do
        for j, value in ipairs(row) do
            if value == 1 then
                local x, y
                x, y = self.currentBlock.x + j - 1, self.currentBlock.y + i - 1
                self.grid[y][x] = self.currentBlock.color
            end
        end
    end

    self:clearLines()
end

function Tetris:clearLines()
    local blocksInLine
    for i = self.height - 1, 1, -1 do
        local line = self.grid[i]
        local isFull = true
        blocksInLine = 0
        for _, cell in pairs(line) do

            if(type(cell) == "table") then
                blocksInLine = blocksInLine + 1
            end    
        end
        if blocksInLine == self.width - 1 then
            self.score = self.score + 100
            table.remove(self.grid, i)
            table.insert(self.grid, 1, {})
            self.lineToClear = i
            self.lineClear = true
        end
    end
end

return Tetris