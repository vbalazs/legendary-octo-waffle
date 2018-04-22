module PrintHelpers
  def print_subtree(hsh, indent = 1)
    hsh.each_key do |k|
      puts indent(indent) + k.to_s

      if hsh[k].is_a?(Hash)
        print_subtree(hsh[k], indent + 1)
      else
        hsh[k].each { |c| print_card(c, indent + 1) }
      end
    end
  end

  def print_card(card, indent = 0)
    puts indent(indent) + "#{card.name} (id=#{card.id})"
  end

  def indent(level)
    ('-' * level) + (level > 0 ? ' ' : '')
  end

  module_function :print_subtree, :print_card, :indent
end
