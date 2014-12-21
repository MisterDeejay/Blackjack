require_relative 'dealer'
class BlackjackGame
  attr_reader :dealer, :players, :deck

  def inititalize
    @deck = Deck.new
    @dealer = Dealer.new
    @players = create_players
  end

  def play_round
    play_again? = true
    while play_again?
      @deck.shuffle
      @players.each do |player|
        take_bet(player)
        hit_player(player)
      end

      @dealer.pay_bets
      @dealer.return_cards(@deck)
      @players.each { |player| player.return_cards(@deck) }
      print "Play again? (y/n) "
      play_again? = get_play_again_choice
    end
  end

  private
  def get_play_again_choice
    begin
      play_again_choice = gets.chomp.downcase[0]
      unless play_again_choice == 'y' || play_again_choice == 'n'
        raise("Incorrent entry, try again")
      end
    rescue Exception => e
      puts e.message
      retry
    end

    play_again_choice == 'y' ? true : false
  end

  def hit_player(player)
    stay? = false
    until player.hand.busted? || stay?
      puts "Dealer Hand: #{ @dealer.hand.to_s }"
      puts "#{ player.name }'s Hand: #{ player.hand.to_s }"
      print "#{ player.name }, (h)it or (s)tay? "
      choice = get_choice
      choice == 's' ? stay? = true : player.hand.hit(@deck)
    end
  end

  def get_hit_choice
    begin
      hit_choice = gets.chomp.downcase[0]
      unless hit_choice == 's' || hit_choice == 'h'
        raise("Incorrent entry, try again")
      end
    rescue Exception => e
      puts e.message
      retry
    end

    hit_choice
  end

  def take_bet(player)
    print "#{ player.name }, enter your wager amount: "
    @dealer.take_bet(player, get_wager)
  end

  def get_wager
    begin
      wager_amt = gets.chomp.to_i
      raise("Must wager an amount") if player_pot <= 0
    rescue Exception => e
      puts e.message
      retry
    end

    wager_amt
  end

  def create_players
    players = []
    puts 'How many players are there?'
    num_players = gets.chomp.to_i
    num_players.times do |player_num|
      name = get_name(player_num)
      player_pot = get_starting_amt(player_num)
      players << Player.new(name, player_pot, @deck)
    end

    players
  end

  def get_name(player_num)
    begin
      puts "Enter name for Player #{ player_num + 1 }"
      name = gets.chomp
      raise("Name must be greater than one character") if name.size <= 1
    rescue Exception => e
      puts e.message
      retry
    end

    name
  end

  def get_starting_amt(player_num)
    begin
      puts "Player #{ player_num + 1 }, how much money are you starting with?"
      player_pot = gets.chomp.to_i
      raise("Can't start without any money") if player_pot <= 0
    rescue Exception => e
      puts e.message
      retry
    end

    player_pot
  end
end
