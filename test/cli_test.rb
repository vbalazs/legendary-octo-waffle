# frozen_string_literal: true

class TestCli < Minitest::Test
  def setup
    @cli = Cli.new
  end

  def test_hello
    assert_equal :world, @cli.hello
  end
end
