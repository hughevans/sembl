# == Schema Information
#
# Table name: games
#
#  id                   :integer          not null, primary key
#  board_id             :integer
#  title                :string(255)      not null
#  description          :text
#  creator_id           :integer
#  updator_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  invite_only          :boolean          default(FALSE)
#  uploads_allowed      :boolean          default(FALSE)
#  theme                :string(255)
#  filter_content_by    :text
#  allow_keyword_search :boolean          default(FALSE)
#  state                :string(255)      default("draft")
#  current_round        :integer          default(1)
#

class Game < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :board

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  has_many :users, through: :players
  has_many :players

  has_many :nodes


  # Games still open to users to join
  def self.open_to_join
    where(invite_only: false).
      joins(:users, :board).
      group("games.id, boards.number_of_players").
      having("count(users.id) < boards.number_of_players")
  end

  def self.completed
    where(state: 'completed')
  end

  def self.in_progress
    where("state != 'draft' AND state != 'completed'")
  end

  def self.invite_only
    where(invite_only: true)
  end

  def self.participating(current_user)
    joins(:users).where(["users.id = ?", current_user.id])
  end

  def self.hosted_by(current_user)
    where(creator: current_user)
  end

  def seed_thing
    seed_node = nodes.where(round: 0).take
    seed_node.final_placement.try(:thing)
  end

end