class Grid
  attr_reader :height, :width, :canvas, :context, :max_x, :max_y
  attr_accessor :state, :seed

  CELL_HEIGHT = 15;
  CELL_WIDTH  = 15;

  def initialize
    @height  = `$(window).height()`
    @width   = `$(window).width()`
    @canvas  = `document.getElementById(#{canvas_id})` 
    @context = `#{canvas}.getContext('2d')`
    @max_x   = (height / CELL_HEIGHT).floor
    @max_y   = (width / CELL_WIDTH).floor
    @state   = blank_state
    @seed    = []
    draw_canvas
    add_mouse_event_listener
    add_demo_event_listener
  end

  def draw_canvas
    `#{canvas}.width  = #{width}`
    `#{canvas}.height = #{height}`

    x = 0.5
    until x >= width do
      `#{context}.moveTo(#{x}, 0)`
      `#{context}.lineTo(#{x}, #{height})`
      x += CELL_WIDTH
    end

    y = 0.5
    until y >= height do
      `#{context}.moveTo(0, #{y})`
      `#{context}.lineTo(#{width}, #{y})`
      y += CELL_HEIGHT
    end

    `#{context}.strokeStyle = "#eee"`
    `#{context}.stroke()`
  end

  def blank_state
    h = Hash.new
    (0..max_x).each do |x|
      (0..max_y).each do |y|
        h[[x,y]] = 0
      end
    end
    h
  end

  def redraw_canvas
    draw_canvas
    state.each do |cell, liveness|
      fill_cell(cell[0], cell[1]) if liveness == 1
    end
  end
  
  def get_cursor_position(event)
    if (event.page_x && event.page_y)
      x = event.page_x;
      y = event.page_y;
    else
      doc = Opal.Document[0]
      x = event[:clientX] + doc.scrollLeft + doc.documentElement.scrollLeft;
      y = event[:clientY] + doc.body.scrollTop + doc.documentElement.scrollTop;
    end

    x -= `#{canvas}.offsetLeft`
    y -= `#{canvas}.offsetTop`
   
    x = (x / CELL_WIDTH).floor
    y = (y / CELL_HEIGHT).floor

    Coordinates.new(x: x, y: y)
  end

  def fill_cell(x, y)
    x *= CELL_WIDTH;
    y *= CELL_HEIGHT;
    `#{context}.fillStyle = "#000"`
    `#{context}.fillRect(#{x.floor+1}, #{y.floor+1}, #{CELL_WIDTH-1}, #{CELL_HEIGHT-1})`
  end

  def unfill_cell(x, y)
    x *= CELL_WIDTH;
    y *= CELL_HEIGHT;
    `#{context}.clearRect(#{x.floor+1}, #{y.floor+1}, #{CELL_WIDTH-1}, #{CELL_HEIGHT-1})`
  end

  def canvas_id
    'conwayCanvas'
  end

  def add_mouse_event_listener
    Element.find("##{canvas_id}").on :click do |event|
      coords = get_cursor_position(event)
      x, y   = coords.x, coords.y
      fill_cell(x, y)
      seed << [x, y]
    end

    Element.find("##{canvas_id}").on :dblclick do |event|
      coords = get_cursor_position(event)
      x, y   = coords.x, coords.y
      unfill_cell(x, y)
      seed.delete([x, y])
    end
  end

  def add_demo_event_listener
    Document.on :keypress do |event|
      if ctrl_d_pressed?(event)
        [
          [25, 1],
          [23, 2], [25, 2],
          [13, 3], [14, 3], [21, 3], [22, 3],
          [12, 4], [16, 4], [21, 4], [22, 4], [35, 4], [36, 4],
          [1, 5],  [2, 5],  [11, 5], [17, 5], [21, 5], [22, 5], [35, 5], [36, 5],
          [1, 6],  [2, 6],  [11, 6], [15, 6], [17, 6], [18, 6], [23, 6], [25, 6],
          [11, 7], [17, 7], [25, 7],
          [12, 8], [16, 8],
          [13, 9], [14, 9]
        ].each do |x, y|
          fill_cell(x, y)
          seed << [x, y]
        end
      end
    end
  end

  def ctrl_d_pressed?(event)
    event.ctrl_key == true && event.which == 4
  end

end

class Coordinates < OpenStruct; end
