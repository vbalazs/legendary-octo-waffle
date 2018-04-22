# frozen_string_literal: true

class TestPaginatedCollector < Minitest::Test
  def setup
    @client = Minitest::Mock.new
    @parser = Minitest::Mock.new
    @repo = PaginatedCollector.new(client: @client, parser: @parser)
  end

  def test_load_next_page_when_unsuccessful
    response = MtgApiResponse.new(success?: false, current_page: 1)

    refute @repo.load_next_page?(response)
  end

  def test_load_next_page_when_successful_but_no_next_page
    response = Minitest::Mock.new
    response.expect :current_page, 1
    response.expect :success?, true
    response.expect :next_page?, false

    refute @repo.load_next_page?(response)
  end

  def test_load_next_page_when_successful_and_there_is_next_page
    response = Minitest::Mock.new
    response.expect :current_page, 1
    response.expect :success?, true
    response.expect :next_page?, true

    assert @repo.load_next_page?(response)
  end

  def test_filtered_set_paginates
    1.upto(3) do |p|
      @client.expect :fetch_cards,
                     MtgApiResponse.new(success?: true, current_page: p, body: {},
                                        total_count: 5, page_size: 2),
                     [{ page: p, query: { 'setName' => 'Unstable' } }]
      @parser.expect :card_list, [], [Hash]
    end

    @repo.filtered_set(query: { 'setName' => 'Unstable' })

    @client.verify
    @parser.verify
  end

  def test_filtered_set_filter_by_proc
    @client.expect :fetch_cards, MtgApiResponse.new(success?: true, current_page: 1, body: {},
                                                    total_count: 1, page_size: 1), [Hash]
    parsed_cards = [Card.new(name: 'King X'), Card.new(name: 'Red 5'), Card.new(name: 'King II')]
    @parser.expect :card_list, parsed_cards, [Hash]

    result = @repo.filtered_set(
      query: {},
      filter: ->(card) { card.name.downcase.include?('king') }
    )

    assert_equal ['King II', 'King X'], result.map(&:name).sort
  end

  def test_all_calls_filtered_set
    @repo.stub :filtered_set, [1, 2, 3] do
      assert_equal [1, 2, 3], @repo.all
    end
  end
end
