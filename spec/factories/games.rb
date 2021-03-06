# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    title { Forgery(:lorem_ipsum).word }
    theme { Forgery(:lorem_ipsum).word }
    board { FactoryGirl.create(:board) }
    seed_thing_id { FactoryGirl.create(:thing).id }
    number_of_players { 3 }
    creator { FactoryGirl.create(:user) }

    factory :game_in_progress do
      state { 'draft' }
      after(:create) do |game|
        FactoryGirl.create_list(:player, 3, game: game, state: 'playing_turn')
        game.state = 'playing'
      end
    end

    factory :game_being_joined do
      state { 'joining' }
      invite_only { false }
      after(:create) do |game|
        FactoryGirl.create_list(:player, 2, game: game, state: 'playing_turn')
      end
    end

    factory :game_with_nodes do
      after(:create) do |game|
        (0..4).each do |i|
          FactoryGirl.create(:node, game: game, round: i)
        end
      end
    end

    factory :game_with_completed_nodes do
      after(:create) do |game|
        (0..1).each do |i|
          FactoryGirl.create(:node_with_final_placements, game: game, round: i)
        end
        (2..4).each do |i|
          FactoryGirl.create(:node, game: game, round: i)
        end
      end
    end

    factory :game_with_proposed_nodes do
      after(:create) do |game|
        FactoryGirl.create(:node_with_final_placements, game: game, round: 0)
        FactoryGirl.create(:node_with_proposed_placements, game: game, round: 1)
        (2..4).each do |i|
          FactoryGirl.create(:node, game: game, round: i)
        end
      end
    end
  end
end
