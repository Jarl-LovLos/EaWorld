require 'gosu'

class Monster
  def initialize(window, pos_x, pos_y, horizontal=true)
    @start_x = @x = pos_x
    @start_y = @y = pos_y
    @horizontal = horizontal
    image = ((rand * 1 + 6) %2 == 0 ? 'bicho001.png' : 'bicho002.png')
    @i1, @i2, @i3, @i4, @i5, @i6, @i7, @i8, @i9, @i10, @i11, @i12 = Gosu::Image.load_tiles(window, image, 24, 32, false)
    @next = (@horizontal ? @i4 : @i7)
    @last_time = -1
    @walk_group = [@i4, @i5, @i6]
    @speed = 2
    @distance = 150
    @actual_pos = 0
    @direction = :right
  end

  def draw
    @next.draw(@x, @y, 1)
  end

  def update(map_x, map_y)
    @x = @start_x - map_x + (@horizontal ? @actual_pos : 0)
    @y = @start_y - map_y + (!@horizontal ? @actual_pos : 0)
  end

  def set_direction(direction)
    @direction = direction
    case direction
      when :left
        @walk_group = [@i10, @i11, @i12]
      when :right
        @walk_group = [@i4, @i5, @i6]
      when :up
        @walk_group = [@i1, @i2, @i3]
      else # :down
        @walk_group = [@i7, @i8, @i9]
    end
  end

  def walk(yes=true)
    time_now = (Gosu.milliseconds / 100).round(0)
    if yes
      if @next == @walk_group[1]
        @next = @walk_group[0]
        @last_time = time_now
      end
      @last_time = 0 unless @walk_group.include? @next
      if time_now % 2 == 0 and time_now > @last_time
        if @next == @walk_group[0]
          @next = @walk_group[2]
        else
          @next = @walk_group[0]
        end
        @last_time = time_now
      end
      if @horizontal
        if @direction == :right && @actual_pos < (@distance - @speed)
          @actual_pos += @speed
        elsif @direction == :right && @actual_pos >= (@distance - @speed)
          set_direction :left
          @actual_pos -= @speed
        elsif @direction == :left && @actual_pos >= (@speed)
          @actual_pos -= @speed
        else
          set_direction :right
          @actual_pos += @speed
        end
      else
        if @direction == :down && @actual_pos < (@distance - @speed)
          @actual_pos += @speed
        elsif @direction == :down && @actual_pos >= (@distance - @speed)
          set_direction :up
          @actual_pos -= @speed
        elsif @direction == :up && @actual_pos >= (@speed)
          @actual_pos -= @speed
        else
          set_direction :down
          @actual_pos += @speed
        end
      end
    else
      @next = @walk_group[1]
    end
  end
end