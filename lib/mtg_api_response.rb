# frozen_string_literal: true

MtgApiResponse = Struct.new(:success?, :status, :body,
                            :current_page, :page_size, :count, :total_count,
                            :ratelimit_limit, :ratelimit_remaining,
                            keyword_init: true) do

  def next_page?
    current_page * page_size < total_count
  end

  def total_pages
    (total_count.to_f / page_size).ceil
  end
end
