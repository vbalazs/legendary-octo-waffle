# frozen_string_literal: true

class GroupCardsService
  class << self
    def call(cards:, primary:, secondary: nil)
      return cards.group_by(&primary) unless secondary

      results = Hash.new do |hsh, key|
        hsh[key] = Hash.new { |subhsh, subkey| subhsh[subkey] = [] }
      end

      cards.each_with_object(results) do |card, hsh|
        hsh[card.set_name][card.rarity] << card
      end
    end
  end
end
