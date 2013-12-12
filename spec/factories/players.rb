# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    user { FactoryGirl.create(:user) }
    game { FactoryGirl.create(:game) }
  end
end
