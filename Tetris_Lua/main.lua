local Tetris = require "tetris"

function love.load()
    love.window.setMode(800, 600, {resizable=false, vsync=0, minwidth=400, minheight=300})
    love.window.setTitle("Tetris")
    gameOverSoundEffect = love.audio.newSource("game_over.wav", "static")
    clearLineSoundEffect = love.audio.newSource("line_clear.wav", "static")
    tetris = Tetris:new()
end

function love.update(dt)
    tetris:update(dt)
end

function love.draw()
    tetris:draw()
end

function love.keypressed(key)
    tetris:keyPressed(key)
end