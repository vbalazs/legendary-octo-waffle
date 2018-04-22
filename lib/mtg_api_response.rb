# frozen_string_literal: true

MtgApiResponse = Struct.new(:status, :body, :page_size, :count, :total_count,
                            :ratelimit_limit, :ratelimit_remaining,
                            keyword_init: true)
