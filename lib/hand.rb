require_relative 'deck'
class Hand
  # This is called a *factory method*; it's a *class method* that
  # takes the `Deck` and creates and returns a `Hand`
  # object. This is in contrast to the `#initialize` method that
  # expects an `Array` of cards to hold.

  def self.deal_from(deck)
    Hand.new(deck.take(2))
  end

  attr_accessor :cards

  def initialize(cards = Hand.deal_from(deck))
    @cards = cards
  end

  def points
    total_pts = 0
    aces = []
    @cards.each do |card|
      if card.value == :ace
        aces << card
      else
        total_pts += card.blackjack_value
      end
    end

    if aces.count == 1
      total_pts + 11 > 21 ? total_pts += 1 : total_pts += 11
    else
      total_pts += aces.count
    end
  end

  def busted?
    self.points > 21
  end

  def hit(deck)
    self.busted? ? (raise 'already busted') : (@cards += deck.take(1))
  end

  def beats?(other_hand)
    if self.busted?
      false
    elsif other_hand.busted?
      true
    else
      (self.points > other_hand.points)
    end
  end

  def return_cards(deck)
    deck.return(@cards)
    @cards = []
  end

  def to_s
    @cards.join(",") + " (#{points})"
  end
end
