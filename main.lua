local love = require("love")

  -- circle variables
  local circle_red = 155
  local circle_green = 255
  local circle_blue = 255  

  local circle_x = 200
  local circle_y = 200
  local circle_velocity_x = 0
  local circle_velocity_y = 0

  local circle_radius = 20
  local circle_speed = 2 * circle_radius

  function love.load()
    love.graphics.setBackgroundColor(0, 0, 255)
  end

  local last_time = love.timer.getTime()

  function move_circle()
      circle_x = circle_x + circle_velocity_x
      circle_y = circle_y + circle_velocity_y

      -- keep the circle on the screen
      if circle_x - circle_radius < 0 then
        circle_x = circle_radius
      end
      if circle_x + circle_radius > love.graphics.getWidth() then
        circle_x = love.graphics.getWidth() - circle_radius
      end
      if circle_y - circle_radius < 0 then
        circle_y = circle_radius
      end
      if circle_y + circle_radius > love.graphics.getHeight() then
        circle_y = love.graphics.getHeight() - circle_radius
      end
  end

  -- update is called once per frame
  -- dt is the amount of seconds elapsed since the last update
  function love.update(dt)
    -- update the circle's position
    local current_time = love.timer.getTime()
    local time_elapsed = current_time - last_time

    if time_elapsed > 0.2 then
      move_circle()
      last_time = current_time
    end

    -- keep the circle on the screen
    if circle_x - circle_radius < 0 then
      circle_x = circle_radius
    end
    if circle_x + circle_radius > love.graphics.getWidth() then
      circle_x = love.graphics.getWidth() - circle_radius
    end
    if circle_y - circle_radius < 0 then
      circle_y = circle_radius
    end
    if circle_y + circle_radius > love.graphics.getHeight() then
      circle_y = love.graphics.getHeight() - circle_radius
    end
  end

  -- draw is called once per frame
  function love.draw()
    -- draw a circle
    love.graphics.setColor(circle_red, circle_green, circle_blue)
    love.graphics.circle("fill", circle_x, circle_y, circle_radius)
  end

  -- keypressed is called when a key is pressed
  function love.keypressed(key)
    -- quit the game when the escape key is pressed
    if key == "escape" then
      love.event.quit()
    end
    
    last_time = love.timer.getTime()

    -- change the circle's velocity when arrow keys are pressed
    if key == "left" then
      circle_velocity_x = -circle_speed
    elseif key == "right" then
      circle_velocity_x = circle_speed
    elseif key == "up" then
      circle_velocity_y = -circle_speed
    elseif key == "down" then
      circle_velocity_y = circle_speed
    end

    move_circle()

  end

  function love.keyreleased(key)
    -- change the circle's velocity when arrow keys are released
    if key == "left" and circle_velocity_x < 0 then
      circle_velocity_x = 0
    elseif key == "right" and circle_velocity_x > 0 then
      circle_velocity_x = 0
    elseif key == "up" and circle_velocity_y < 0 then
      circle_velocity_y = 0
    elseif key == "down" and circle_velocity_y > 0 then
      circle_velocity_y = 0
    end
  end
