require_relative 'card'

# Represents a deck of playing cards.
class Deck
  # Returns an array of all 52 playing cards.
  def self.all_cards
    full_deck = []
    begin
      Card::SUIT_STRINGS.each_key do |suit|
        Card::VALUE_STRINGS.each_key do |value|
          begin
            full_deck << Card.new(suit, value)
          rescue Exception => e
            puts e.message
            puts e.backtrace.join("\n")
          end
        end
      end
    end

    full_deck
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  def inspect
    puts 'First two cards:'
    p @cards[0]
    p @cards[1]
    puts 'Last two cards:'
    p @cards[-2]
    p @cards[-1]
  end

  def shuffle
    @cards.shuffle
  end

  # Returns the number of cards in the deck.
  def count
    @cards.count
  end

  # Takes `n` cards from the top of the deck.
  def take(n)
    raise ArgumentError.new('not enough cards') if n > self.count
    @cards.shift(n)
  end

  # Returns an array of cards to the bottom of the deck.
  def return(cards)
    cards.each { |card| @cards << card }
  end
end
