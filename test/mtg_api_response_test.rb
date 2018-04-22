# frozen_string_literal: true

class TestMtgApiResponse < Minitest::Test
  def test_next_page_when_total_count_is_bigger
    subject = MtgApiResponse.new(total_count: 10, page_size: 2, current_page: 4)

    assert subject.next_page?
  end

  def test_next_page_when_total_count_is_equal
    subject = MtgApiResponse.new(total_count: 10, page_size: 2, current_page: 5)

    refute subject.next_page?
  end

  def test_next_page_when_total_count_is_smaller
    subject = MtgApiResponse.new(total_count: 9, page_size: 2, current_page: 5)

    refute subject.next_page?
  end
end
