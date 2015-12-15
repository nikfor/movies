require_relative "movie"
require 'date'

class ModernMovie < Movie

  @@weight_variable = 0.5

  def self.weight (value)
    @@weight_variable = value
  end

  def weight
    @@weight_variable
  end

  def description
    puts "#{@name} - modern movie. Roles are played - #{@actors.join(", ")}."
  end

  weight 0.8

  print_format {"%{name} - современный фильм. Роли исполняют - %{actors}."}

  filter { |year| (1969..2000).cover?(year) }

  attr_accessor :user_point, :watched
end
