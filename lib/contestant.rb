class Contestant
          attr_reader :first_name, 
                      :last_name, 
                      :age, 
                      :state_of_residence 
                      
          attr_accessor :game_interests, 
                        :spending_money

  def initialize(information)
    @first_name = information[:first_name]
    @last_name = information[:last_name]
    @age = information[:age]
    @state_of_residence = information[:state_of_residence]
    @spending_money = information[:spending_money]
    @game_interests = []
    
  end

  def full_name 
    @full_name = "#{@first_name} #{@last_name}"
    return @full_name
  end

  def out_of_state?
   @state_of_residence != "CO"
  end

  def add_game_interest(game)
    @game_interests << game 
  end


end