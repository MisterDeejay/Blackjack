require_relative 'player'

class Dealer < Player
  attr_reader :bets

  def initialize
    super("dealer", 0)

    @bets = {}
  end

  def place_bet(dealer, amt)
    raise "Dealer doesn't bet"
  end

  def play_hand(deck)
    @hand.hit(deck) until @hand.points >= 17 || @hand.busted?
  end

  def take_bet(player, amt)
    @bets[player] = amt
  end

  def pay_bets
    @bets.each_pair do |player, bet_amt|
      player.pay_winnings(2 * bet_amt) if (player.hand).beats?(@hand)
    end
  end
end
