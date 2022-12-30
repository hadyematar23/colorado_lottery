require "./lib/contestant"
require "./lib/game"

RSpec.describe Game do 
  context "happy paths" do 
    let(:pick_4){Game.new('Pick 4', 2)}
    let(:mega_millions){Game.new('Mega Millions', 5, true)}
  
      it "is a game" do 
        
        expect(pick_4).to be_an_instance_of(Game)
 
      end

      it "has a name" do 

        expect(mega_millions.name).to eq("Mega Millions")
      end

      it "has a cost" do 

        expect(mega_millions.cost).to eq(5)
      end

      it "is a national drawing or not" do 
        
        expect(mega_millions.national_drawing?).to eq(true)
      end

      it "is not a national drawing" do 
        expect(pick_4.national_drawing?).to eq(false)
      end
  
  
  
  end
end 
