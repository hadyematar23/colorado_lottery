require "./lib/contestant"
require "./lib/game"
require "./lib/colorado_lottery"
require 'date'

RSpec.describe Contestant do 
  context "happy paths" do 
    let(:lottery){ColoradoLottery.new}
    let(:pick_4){Game.new('Pick 4', 2)}
    let(:mega_millions){Game.new('Mega Millions', 5, true)}
    let(:cash_5){Game.new('Cash 5', 1)}
    let(:alexander){Contestant.new({
      first_name: 'Alexander',
      last_name: 'Aigades',
      age: 28,
      state_of_residence: 'CO',
      spending_money: 10})}
    let(:benjamin){Contestant.new({
      first_name: 'Benjamin',
      last_name: 'Franklin',
      age: 17,
      state_of_residence: 'PA',
      spending_money: 100})}
    let(:frederick){Contestant.new({
      first_name:  'Frederick',
      last_name: 'Douglass',
      age: 55,
      state_of_residence: 'NY',
      spending_money: 20})}
    let(:winston){Contestant.new({
      first_name: 'Winston',
      last_name: 'Churchill',
      age: 18,
      state_of_residence: 'CO',
      spending_money: 5})}
    let(:grace){Contestant.new({
      first_name: 'Grace',
      last_name: 'Hopper',
      age: 20,
      state_of_residence: 'CO',
      spending_money: 20})}

    it "is an object lottery" do 
      expect(lottery).to be_an_instance_of(ColoradoLottery)
    end

    it "starts out with no registered contestants" do 
      expect(lottery.registered_contestants).to eq ({})
    end

    it "starts out with no winners" do 
      expect(lottery.winners).to eq ([])
    end

    it "starts out with no current contestants" do 
      expect(lottery.current_contestants).to eq ({})
    end

    it "checks to see if they're interested and above the age of 18" do 
      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')

      expect(lottery.interested_and_18?(alexander, pick_4)).to eq(true)
      expect(lottery.interested_and_18?(benjamin, mega_millions)).to eq(false)
    end

    it "potential contestants can register if they are interested in the game, 18 years or older, and either a CO resident or it's a national game" do 
      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')

      expect(lottery.can_register?(alexander, pick_4)).to eq(true)
      expect(lottery.can_register?(alexander, cash_5)).to eq(false)
      expect(lottery.can_register?(frederick, mega_millions)).to eq(true)
      expect(lottery.can_register?(benjamin, mega_millions)).to eq(false)
      expect(lottery.can_register?(frederick, cash_5)).to eq(false)
    end
  
    it "updates the list of registered contestants" do 
      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)

      expect(lottery.registered_contestants).to eq({"Pick 4" => [alexander]})
    end

    it "continues to update the lists of registered contestants" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)

      expect(lottery.registered_contestants).to eq({"Pick 4"=> [alexander], "Mega Millions"=>[alexander]})
    end 

    it "continues to update based on new contestants" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)

      expect(lottery.registered_contestants).to eq({"Pick 4"=> [alexander], 
        "Mega Millions"=> [alexander, frederick, winston], 
        "Cash 5"=> [winston]})

    end

    it "adds new contestants and still works" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)

      expect(lottery.registered_contestants).to eq({"Pick 4"=> [alexander, grace], 
        "Mega Millions"=> [alexander, frederick, winston, grace], 
        "Cash 5"=> [winston, grace]})

      end 

    it "can determine eligible contestants by game type" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)

      expect(lottery.eligible_contestants(pick_4)).to eq([alexander, grace])
      expect(lottery.eligible_contestants(cash_5)).to eq([winston, grace])
      expect(lottery.eligible_contestants(mega_millions)).to eq([alexander, frederick, grace]) 

    end

    it "they can charge contestants" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)
      lottery.charge_contestants(cash_5)

      expect(lottery.current_contestants).to eq({cash_5 =>["Winston Churchill", "Grace Hopper"]})

    end

    it "they can then check spending money" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)
      lottery.charge_contestants(cash_5)

      expect(grace.spending_money).to eq(19)
      expect(winston.spending_money).to eq(4)
    end 

    it "can charge for different games" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)
      lottery.charge_contestants(cash_5)
      lottery.charge_contestants(mega_millions)

      expect(lottery.current_contestants).to eq({
        cash_5 =>["Winston Churchill", "Grace Hopper"], 
        mega_millions=> ["Alexander Aigades", "Frederick Douglass", "Grace Hopper"]
        })
      expect(grace.spending_money).to eq(14)
      expect(winston.spending_money).to eq(4)
      expect(alexander.spending_money).to eq(5)
      expect(frederick.spending_money).to eq(15)
    end

    it "can charge for different games" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)
      lottery.charge_contestants(cash_5)
      lottery.charge_contestants(mega_millions)
      lottery.charge_contestants(pick_4)

      expect(lottery.current_contestants).to eq({
        cash_5 =>["Winston Churchill", "Grace Hopper"], 
        mega_millions=> ["Alexander Aigades", "Frederick Douglass", "Grace Hopper"], 
        pick_4=> ["Alexander Aigades", "Grace Hopper"]
        })
    end 

    # ITERATION 4

    it "draws a winner on today's date" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)
      lottery.charge_contestants(cash_5)
      lottery.charge_contestants(mega_millions)
      lottery.charge_contestants(pick_4)

      expect(lottery.draw_winners).to eq("2022/30/12")

    end 

    it "draws winners and populates the winners array" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)
      lottery.charge_contestants(cash_5)
      lottery.charge_contestants(mega_millions)
      lottery.charge_contestants(pick_4)

      expect(lottery.draw_winners).to eq("2022/30/12")
      
      
    end 

    it "populates the winners array" do 

      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)
      lottery.charge_contestants(cash_5)
      lottery.charge_contestants(mega_millions)
      lottery.charge_contestants(pick_4)
      lottery.draw_winners

      expect(lottery.winners.class).to eq(Array)
      expect(lottery.winners.first.class).to eq(Hash)
      expect(lottery.winners.last.class).to eq(Hash)
      expect(lottery.winners.length).to eq(3)
    end 

    it "can writen this into a string" do 
      alexander.add_game_interest('Pick 4')
      alexander.add_game_interest('Mega Millions')
      frederick.add_game_interest('Mega Millions')
      winston.add_game_interest('Cash 5')
      winston.add_game_interest('Mega Millions')
      benjamin.add_game_interest('Mega Millions')
      lottery.register_contestant(alexander, pick_4)
      lottery.register_contestant(alexander, mega_millions)
      lottery.register_contestant(winston, cash_5)
      lottery.register_contestant(frederick, mega_millions)
      lottery.register_contestant(winston, mega_millions)
      grace.add_game_interest('Mega Millions')
      grace.add_game_interest('Cash 5')
      grace.add_game_interest('Pick 4')
      lottery.register_contestant(grace, mega_millions)
      lottery.register_contestant(grace, cash_5)
      lottery.register_contestant(grace, pick_4)
      lottery.charge_contestants(cash_5)
      lottery.charge_contestants(mega_millions)
      lottery.charge_contestants(pick_4)
      lottery.draw_winners

      expect(lottery.announce_winner("Pick 4")).to eq("")

    end
  end 
end 


