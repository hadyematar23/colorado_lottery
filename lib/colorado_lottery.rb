class ColoradoLottery
        attr_reader :registered_contestants,      
                    :winners, 
                    :current_contestants

  def initialize
    @registered_contestants = {}  
    @winners = []
    @current_contestants = {}

  end

  def interested_and_18?(contestant, game)
    if contestant.game_interests.include?(game.name) && contestant.age > 18 
      true 
    else 
      false
    end
  end

  def can_register?(contestant, game) 
    if interested_and_18?(contestant, game) && (contestant.out_of_state? == false || game.national_drawing == true)
      true 
    else 
      false 
    end
  end 

  def register_contestant(contestant, game)
    if @registered_contestants[game.name] == nil  
      @registered_contestants[game.name] = [contestant]
    else 
      @registered_contestants[game.name] << contestant
    end 
  end

  def eligible_contestants(game)
    registered_contestants[game.name].select do |contestant|
      contestant.spending_money > game.cost
    end
  end

  def charge_contestants(game)
    eligible_contestants(game).map do |contestant|
      contestant.spending_money -= game.cost
        if @current_contestants[game] == nil  
          @current_contestants[game] = ["#{contestant.first_name} #{contestant.last_name}"]
        else 
          @current_contestants[game] << ("#{contestant.first_name} #{contestant.last_name}")
        end 
    end
  end

  def draw_winners
    current_date = DateTime.now.strftime "%Y/%d/%m"
    @current_contestants.each do |game|
      @winners << {game[1].sample => game[0].name}
    end
    return current_date
  end


end