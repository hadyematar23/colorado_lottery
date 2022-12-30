require "./lib/contestant"
require "./lib/game"

RSpec.describe Contestant do 
  context "happy paths" do 
    let(:alexander){Contestant.new({first_name: 'Alexander',
      last_name: 'Aigiades',
      age: 28,
      state_of_residence: 'CO',
      spending_money: 10})}


      it "is an object Contestant" do 
        expect(alexander).to be_an_instance_of(Contestant)
      end 

      it "has a name and other attributes" do 
        expect(alexander.full_name).to eq("Alexander Aigiades") 
        expect(alexander.age).to eq(28)
        expect(alexander.state_of_residence).to eq("CO")
        expect(alexander.spending_money).to eq(10)
      end

      it "can determine if a resident is from out of state" do 
        expect(alexander.out_of_state?).to eq(false)
      end

      it "has game interestsat the outset" do 
        expect(alexander.game_interests).to be_empty
      end

      it "adds some game interests" do 
        alexander.add_game_interest('Mega Millions')
        alexander.add_game_interest('Pick 4')
        expect(alexander.game_interests).to eq(["Mega Millions", "Pick 4"])
      end
  end
end 