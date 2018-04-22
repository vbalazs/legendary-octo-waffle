# frozen_string_literal: true

require 'optparse'
require_relative 'environment'

OptionParser.new do |opts|
  opts.banner = 'Usage: app.rb [options]'

  opts.on('--task3', "Returns a list of cards from the Khans of Tarkir that ONLY\
                       have the colors red and blue") do |_v|
    cards = PaginatedCollector.new.filtered_set(
      query: { 'setName' => 'Khans of Tarkir', 'colors' => 'red,blue' },
      filter: ->(card) { card.colors == Set['red', 'blue'] }
    )

    puts cards.map(&:name)
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!
