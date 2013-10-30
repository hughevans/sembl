# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  user_id    :integer
#  score      :float
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)      default("completing_turn")
#

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  def can_end_turn?
    game.links.where(user: user).
    joins(:node).
    where("nodes.round == ?", [game.current_round]).
    present?
  end
end
