require 'spec_helper'

describe GamePolicy do 
  subject { GamePolicy.new(user, game)}

  let(:game) { FactoryGirl.create(:game) }

  context "for a guest" do 
    let(:user) { nil }

    it { should permit(:index)       }
    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
    it { should_not permit(:join) }

    context "game is invite only" do 
      let(:game) { FactoryGirl.create(:game, invite_only: true) }
      it { should_not permit(:show)       }
    end

    context "game is not invite only" do
      let(:game) { FactoryGirl.create(:game, invite_only: false) }
      it { should permit(:show)       }
    end
  end

  context "for a user" do 
    let(:user) { FactoryGirl.create(:user) }

    it { should permit(:index)   }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should_not permit(:update)   }
    it { should_not permit(:edit)  }
    it { should_not permit(:destroy) }
  
    context "for a game that is hosted by user" do 
      let(:game) { FactoryGirl.create(:game, creator: user) }
      it { should permit(:show)   }
    end

    context "for a game that is hosted by user and is not in progress" do 
      let(:game) {
        FactoryGirl.create(:game, creator: user, state: 'draft')
      }
      it { should permit(:update)   }
      it { should permit(:edit)  }
      it { should permit(:destroy) }
    end

    context "for a game that is hosted by user and is in progress" do 
      let(:game) {
        FactoryGirl.create(:game, creator: user, state: 'playing')
      }
      it { should_not permit(:update)   }
      it { should_not permit(:edit)  }
      it { should_not permit(:destroy) }
    end

    context "for a game that is open to join" do 
      let(:game) {
        FactoryGirl.create(:game, state: 'open', invite_only: false)
      }
      it { should permit(:join)   }
    end

    # TODO not sure how best to handle invite only games with invited users who are not yet members.
    # Maybe enforce sign up and auto assign them to games to which they have been invited. Skip the 
    # 'open' game state, go straight to 'playing'.
    # So there is no "Join" action in this case.
    # Assumes you cannot reject an invitation to join.
    context "for a game that is private" do 
      let(:game) {
        FactoryGirl.create(:game, invite_only: true)
      }
      it { should_not permit(:join)   }
      it { should_not permit(:show)   }

      context "user is a player" do 
        let(:player) { FactoryGirl.create(:player, user: user, game: game) }
        it { should permit(:show)   }
      end

    end

  end

end