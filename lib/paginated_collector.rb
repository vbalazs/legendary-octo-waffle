# frozen_string_literal: true

require 'concurrent'

class PaginatedCollector
  attr_reader :client, :parser

  def initialize(client: MtgApi.new, parser: CardParser.new)
    @client = client
    @parser = parser
  end

  def all
    filtered_set(query: {})
  end

  def filtered_set(query:, filter: nil)
    agent = Concurrent::Agent.new(Set.new)

    first_page_response = future_page(1, query, filter, agent).value

    if first_page_response.next_page?
      jobs = 2.upto(first_page_response.total_pages).map do |page|
        future_page(page, query, filter, agent)
      end

      jobs.map(&:value)
    end

    agent.await.value
  end

  def future_page(page, query, filter, agent)
    Concurrent::Future.execute do
      response = client.fetch_cards(page: page, query: query)
      parsed_response = parser.card_list(response.body)
      new_elements = filter.is_a?(Proc) ? parsed_response.select(&filter) : parsed_response

      agent.send { |set| set | new_elements }

      response
    end
  end
end
