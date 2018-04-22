# frozen_string_literal: true

MtgApiResponse = Struct.new(:success?, :status, :body,
                            :page_size, :count, :total_count,
                            :ratelimit_limit, :ratelimit_remaining,
                            keyword_init: true)
