json.medplan do
  json.id @user.id
  json.lastname @user.lastname
  json.name @user.name
  json.label @user.label

  json.analisys do
    json.partial! 'home/user_event', collection: @analisys.confirmed, as: :event, user: @user
  end
  json.visits do
    json.partial! 'home/user_event', collection: @visits.confirmed, as: :event, user: @user
  end
end