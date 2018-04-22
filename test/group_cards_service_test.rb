# frozen_string_literal: true

class TestGroupCardsService < Minitest::Test
  def setup
    @c1 = Card.new(name: 'Adorable Kitten', set_name: 'Unstable', rarity: 'Common')
    @c2 = Card.new(name: 'Aerial Toastmaster', set_name: 'Test 1', rarity: 'Uncommon')
    @c3 = Card.new(name: 'Amateur Auteur', set_name: 'Unstable', rarity: 'Common')
    @c4 = Card.new(name: 'By Gnome Means', set_name: 'Test 2', rarity: 'Rare')
    @c5 = Card.new(name: 'Chivalrous Chevalier', set_name: 'Unstable', rarity: 'Uncommon')
    @cards = [@c1, @c2, @c3, @c4, @c5]
    @cls = GroupCardsService
  end

  def test_when_primary_only_grouping
    result = @cls.call(cards: @cards, primary: ->(card) { card.set_name })

    assert_equal ['Test 1', 'Test 2', 'Unstable'], result.keys.sort
    assert_equal [@c2], result['Test 1']
    assert_equal [@c4], result['Test 2']
    assert_equal [@c1, @c3, @c5], result['Unstable']
  end

  def test_when_primary_and_secondary_grouping # # rubocop:disable Metrics/AbcSize
    result = @cls.call(cards: @cards,
                       primary: ->(card) { card.set_name },
                       secondary: ->(card) { card.rarity })

    assert_equal ['Test 1', 'Test 2', 'Unstable'], result.keys.sort
    assert_equal [@c2], result['Test 1']['Uncommon']
    assert_equal [@c4], result['Test 2']['Rare']
    assert_equal [@c1, @c3], result['Unstable']['Common']
    assert_equal [@c5], result['Unstable']['Uncommon']
  end
end
