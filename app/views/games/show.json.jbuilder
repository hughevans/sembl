json.(
  @game,
  :id,
  :title,
  :description,
  :invite_only,
  :state,
  :uploads_allowed,
  :theme,
  :allow_keyword_search,
  :current_round
)

json.players @game.players, partial: 'players/player', as: :player
json.nodes @game.nodes, partial: 'nodes/node', as: :node
json.links @game.links, partial: 'links/link', as: :link

json.is_participating @game.participating?(current_user)