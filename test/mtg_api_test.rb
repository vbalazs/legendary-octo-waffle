# frozen_string_literal: true

class TestMtgApi < Minitest::Test
  BASE_URL = 'https://api.magicthegathering.io/v1'.freeze
  CARDS_PAGINATED_URL = "#{BASE_URL}/cards?page=1".freeze

  def setup
    @api = MtgApi.new
    @response_body = File.read('test/fixtures/cards.json')
  end

  def test_fetch_cards_when_success_returns_parsed_response
    stub_request(:get, CARDS_PAGINATED_URL)
      .to_return(body: @response_body)

    response = @api.fetch_cards
    assert_kind_of MtgApiResponse, response
    assert_equal 200, response.status
    assert_equal JSON.parse(@response_body), response.body
  end

  def test_fetch_cards_parses_paginate_headers
    stub_request(:get, CARDS_PAGINATED_URL)
      .to_return(status: 200,
                 body: '{}',
                 headers: { 'Count' => 100, 'Total-Count' => 35_983, 'Page-Size' => 100 })

    response = @api.fetch_cards
    assert_equal 100, response.count
    assert_equal 35_983, response.total_count
    assert_equal 100, response.page_size
  end

  def test_fetch_cards_parses_ratelimit_headers
    stub_request(:get, CARDS_PAGINATED_URL)
      .to_return(status: 200,
                 body: '{}',
                 headers: { 'Ratelimit-Limit' => 1000, 'Ratelimit-Remaining' => 999 })

    response = @api.fetch_cards
    assert_equal 1000, response.ratelimit_limit
    assert_equal 999, response.ratelimit_remaining
  end

  def test_when_error_returns_nil_body
    stub_request(:get, CARDS_PAGINATED_URL)
      .to_return(status: 500, body: 'woaa error')

    response = @api.fetch_cards
    assert_nil response.body
  end
end