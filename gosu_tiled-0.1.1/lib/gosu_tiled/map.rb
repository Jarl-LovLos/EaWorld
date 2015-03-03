module Gosu
  module Tiled
    class Map
      attr_reader :tilesets, :layers, :width, :height

      def initialize(window, data, data_dir)
        @window = window
        @data = data
        @data_dir = data_dir
        @width = data['width'] * data['tilewidth']
        @height = data['height'] * data['tileheight']
        @tilesets = Tilesets.new(window, data['tilesets'], data_dir)
        @layers = Layers.new(window, data['layers'], width: @width, height: @height, tile_width: data['tilewidth'],
                             tile_height: data['tileheight'])
        @collision_coord = build_collision_coord
      end

      def draw(offset_x, offset_y)
        @layers.each do |layer|
          layer.draw(offset_x, offset_y, tilesets)
        end
      end


      ### All to down implemented by Clemente Jr

      def get_collision_coord
        @collision_coord
      end

      def collides? (x, y, obj_width)
        @collision_coord.each { |object|
          (x..x + obj_width).each { |obj_x|
            if object[1][0] <= y && y <= object[1][1]
              if object[0][0] <= obj_x && obj_x <= object[0][1]
                return true
              end
            end
          }
        }
        false
      end

      private
      def build_collision_coord
        collision_layer = nil
        collision_pos = []
        @data['layers'].each { |l|
          if l['name'] == 'Collision'
            collision_layer = l['objects']
            break
          end
        }
        if collision_layer
          collision_layer.each { |obj|
            collision_pos << [[obj['x'], obj['x'] + obj['width']], [obj['y'], obj['y'] + obj['height']]]
          }
        end
        collision_pos
      end
    end
  end
end