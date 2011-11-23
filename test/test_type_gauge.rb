require 'test/unit'
require 'type_gauge'

class TypeGaugeTest < Test::Unit::TestCase

  def test_valid_input
    tg = TypeGauge.new("12 pt")
    assert tg
  end

  def test_invalid_input
    assert_raise(TypeGauge::UnparseableInputException) {TypeGauge.new("silly pt")}
  end

  def test_unqualified_input
    assert_raise(TypeGauge::UnqualifiedInputException) {TypeGauge.new("24")}
  end

  def test_ambiguous_input
    assert_raise(TypeGauge::AmbiguousInputException) {TypeGauge.new("Double small pica")}
  end

  def test_to_mm
    tg = TypeGauge.new("12 pt")
    assert_equal tg.to_mm, 4.216867199999999
  end

  def test_to_point
    tg = TypeGauge.new("5 mm")
    assert_equal tg.to_point, 14.228572339200058
  end

  def test_traditional_name_input
    tg = TypeGauge.new("brevier")
    assert_equal tg.unit, :point
    assert tg.approximate
  end

end