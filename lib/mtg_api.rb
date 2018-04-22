# frozen_string_literal: true

require 'json'
require 'net/http'

class MtgApi
  API_BASE_URL = 'https://api.magicthegathering.io/v1'.freeze

  def fetch_cards(page: 1, query: {})
    uri = URI(API_BASE_URL + '/cards')
    uri.query = URI.encode_www_form(query.merge(page: page))

    res = Net::HTTP.get_response(uri)
    wrap_response(res, page)
  end

  private

  def wrap_response(res, page) # rubocop:disable Metrics/MethodLength
    MtgApiResponse.new(
      status: res.code.to_i,
      success?: res.is_a?(Net::HTTPSuccess),
      body: parsed_body(res),
      current_page: page,
      count: res['Count'].to_i,
      total_count: res['Total-Count'].to_i,
      page_size: res['Page-Size'].to_i,
      ratelimit_limit: res['Ratelimit-Limit'].to_i,
      ratelimit_remaining: res['Ratelimit-Remaining'].to_i
    )
  end

  def parsed_body(res)
    res.is_a?(Net::HTTPSuccess) ? JSON.parse(res.body) : nil
  end
end
