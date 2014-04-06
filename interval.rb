class Interval
  # Note that time is in ms.
  def initialize(time=0, &block)
    @interval = `setInterval(function(){#{block.call}}, time)`
  end

  def stop
    `clearInterval(#@interval)`
  end
end
