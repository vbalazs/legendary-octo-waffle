# frozen_string_literal: true

class TestCardParser < Minitest::Test
  def setup
    @parser = CardParser.new
  end

  def test_card_returns_object
    card = @parser.card(json_fixture['cards'].first)

    assert_kind_of Card, card
  end

  def test_card_simple_attributes
    card = @parser.card(json_fixture['cards'].first)

    assert_equal '95ebdf85f4ea74d584dfdfb72e3de5001d0748a9', card.id
    assert_equal 'Adorable Kitten', card.name
    assert_equal 'Unstable', card.set_name
    assert_equal 'Common', card.rarity
  end

  def test_card_downcased_colors
    card = @parser.card(json_fixture['cards'].first)

    assert_equal ['white'], card.colors
  end

  def test_card_list_when_empty_returns_empty
    assert_empty @parser.card_list('cards' => [])
  end

  def test_card_list
    cards = @parser.card_list(json_fixture)

    assert_equal 100, cards.size
    assert_kind_of Card, cards.first
    assert_equal 'Adorable Kitten', cards.first.name
    assert_equal 'The Big Idea', cards.last.name
  end

  private

  def json_fixture
    JSON.parse(File.read('test/fixtures/cards.json'))
  end
end
