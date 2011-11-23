require 'constants'

class TypeGauge
  
  # Try to create useful type size information from a string

  attr_accessor :input, :name, :size, :unit, :approximate

  public

  def initialize input
    self.input = input
    set_size
    self
  end

  def to_mm
    case self.unit
      when :point then self.size * ATF_POINT_IN_MM 
      when :didot then self.size * DIDOT_POINT_IN_MM
      when :line then self.size * ATF_POINT_IN_MM * 12
      when :mm then self.size
    end
  end

  def to_point
    case self.unit
      when :point then self.size 
      when :didot then ((self.size * DIDOT_POINT_IN_MM / ATF_POINT_IN_MM) * 100.00).to_i / 100.00
      when :line then self.size * 12
      when :mm then self.size / ATF_POINT_IN_MM
    end
  end

  def point
    true
  end
  
  def didot
    true
  end

  def line
    true
  end

  def mm
    true
  end

  def us
    true
  end

  def uk
    true
  end

  private

  def likely_input_pattern
    /(\d+\.?\d?)([\s-]+)?(\w+)?/
  end

  def set_unit(str)
    raise UnqualifiedInputException if str == nil
    case str
      when /pt[s]?/ then :point
      when /point[s]?/ then :point
      when /d[s]?/ then :didot
      when /didot[s]?/ then :didot
      when /line[s]?/ then :line
      when /mm[s]?/ then :mm
      when /millimetre[s]?/ then :mm
    end
  end

  def parse_modern_sizes
    result = likely_input_pattern.match(self.input)
    return unless result
    yield(result)
  end

  def normalised_input
    self.input.gsub(/\s+/, ' ').strip.downcase
  end

  def set_size

    TRADITIONAL_NAMES.each do |i|
      if normalised_input == i[0]
        raise AmbiguousInputException.new(self.size, i[1]) if self.size
        self.size = i[1]
        self.unit = :point
        self.approximate = true
      end
    end

    return if self.size
    
    parse_modern_sizes() do |result| 
      self.size = result[1].to_f
      self.unit = set_unit(result[3])
    end

    raise UnparseableInputException.new unless self.size

  end

  class UnparseableInputException < ArgumentError

    attr_reader :message

    def initialize
      @message = "input was not recognised as a type size"
    end
  end

  class AmbiguousInputException < ArgumentError

    attr_reader :message

    def initialize(*args)
      @message = "input could refer to more than one point size: #{args.each {|i| i.to_s}}"
    end
  end

  class UnqualifiedInputException < ArgumentError

    attr_reader :message

    def initialize
      @message = "input did not include recognised measurement unit"
    end
  end

end