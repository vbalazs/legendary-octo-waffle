# frozen_string_literal: true

class PaginatedCollector
  attr_reader :client, :parser

  PAGE_LIMIT = 10 # for development

  def initialize(client: MtgApi.new, parser: CardParser.new)
    @client = client
    @parser = parser
  end

  def filtered_set(query:, filter: nil)
    cards = Set.new
    page = 0

    loop do
      page += 1
      response = client.fetch_cards(page: page, query: query)
      parsed_response = parser.card_list(response.body)

      cards.merge(filter.is_a?(Proc) ? parsed_response.select(&filter) : parsed_response)
      break unless load_next_page?(response)
    end

    cards
  end

  def load_next_page?(response)
    return false if response.current_page >= PAGE_LIMIT

    response.success? && response.next_page?
  end
end
