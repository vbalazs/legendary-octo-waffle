# frozen_string_literal: true

class CardParser
  def card(json_entity)
    Card.new(card_attributes(json_entity))
  end

  def card_list(json)
    json['cards'].map { |entity| card(entity) }
  end

  private

  def card_attributes(json_entity)
    colors = json_entity['colors'].map(&:downcase).to_set

    json_entity
      .slice('id', 'name', 'rarity')
      .merge(colors: colors, set_name: json_entity['setName'])
  end
end
