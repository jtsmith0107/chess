require 'gosu'
require_relative './piece'
require 'debugger'


class GameWindow < Gosu::Window
  
  def initialize(board)
    super(600, 600, true)
    self.caption = "Awesome Chess"
    @background_image = Gosu::Image.new(self, "./media/600px-Chess_Board.png", true)
    @board = board
    @mouse_clicked = false
    @moving_piece = nil
    @turn = :W
  end

  def needs_cursor?
    true
  end

  def mouse_clicked?
    @mouse_clicked
  end
  
  
  def change_turn
    @turn == :W ? @turn = :B : @turn = :W
  end
    

  def update
    #@moving_piece.draw(mouse_x.to_i,mouse_y.to_i) unless @moving_piece.nil?
    if button_down?(Gosu::MsLeft)
      @mouse_clicked = true
    else
      @mouse_clicked = false
    end
    x,y = get_mouse_grid
    #puts "#{x}, #{y}"
    # curr_piece = @board.get_piece([x, y])
    #puts "This is board position #{curr_piece.pos}" unless  curr_piece.nil?
#     if button_down?(Gosu::MsLeft) && get_mouse_grid == [x, y]
#       @p.x, @p.y = grid_to_pixel(*get_mouse_grid)
#      end
  end

  def button_down(id)
    if id == Gosu::MsLeft && @moving_piece.nil?
      @moving_piece = @board.all_pieces.each do |piece|
        puts "looping throuh pieces"
        if piece.pos == get_mouse_grid && piece.color == @turn
          @moving_piece = piece
          puts "Setting moving_piece to #{@moving_piece}"
          return
        end
      end
      @moving_piece = nil
    end
  end
  
  def button_up(id)
    if id == Gosu::MsLeft && !@moving_piece.nil?
      p @moving_piece.pos
      p get_mouse_grid
      @board.move(@moving_piece.pos, get_mouse_grid)
      
      puts "Setting moving_piece to #{@moving_piece}"
      @moving_piece = nil
    end
      
  end

  def get_mouse_grid
    mouse = []
    mouse = mouse_x, mouse_y
    #converts pixels to grid
    [((mouse[1] - 10) / 75).to_i,((mouse[0] - 10) / 75).to_i]
  end

  #takes in array, and returns pixel values for chess pieces
  def grid_to_pixel(x, y, z = 0.5)
    [(y * 75 + 10).to_i, (x * 75 + 10).to_i,z]
  end

  def draw
    @background_image.draw(0,0,0)
    @board.all_pieces.each { |piece| piece.draw }
  end
  
end


class MousePosError < StandardError
  def initialize(message)
    super(message)
  end
end
