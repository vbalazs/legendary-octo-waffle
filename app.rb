# frozen_string_literal: true

require 'optparse'
require_relative 'environment'

def task1
  cards = PaginatedCollector.new.all
  grouped = GroupCardsService.call(cards: cards, primary: ->(c) { c.set_name })

  PrintHelpers.print_subtree(grouped)
end

def task2
  cards = PaginatedCollector.new.all
  grouped = GroupCardsService.call(cards: cards,
                                   primary: ->(c) { c.set_name },
                                   secondary: ->(c) { c.rarity })

  PrintHelpers.print_subtree(grouped)
end

def task3
  cards = PaginatedCollector.new.filtered_set(
    query: { 'setName' => 'Khans of Tarkir', 'colors' => 'red,blue' },
    filter: ->(card) { card.colors == Set['red', 'blue'] }
  )

  cards.each { |c| PrintHelpers.print_card(c) }
end

OptionParser.new do |opts|
  opts.banner = 'Usage: app.rb [options]'

  opts.on('--task1', 'Returns a list of Cards grouped by Set') do
    task1
  end

  opts.on('--task2', 'Returns a list of Cards grouped by Set and then by rarity') do
    task2
  end

  opts.on('--task3', 'Returns a list of cards from the Khans of Tarkir that ONLY ' \
                     'have the colors red and blue') do
    task3
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!
