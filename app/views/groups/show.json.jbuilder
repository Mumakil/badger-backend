json.(@group, :id, :name, :photo_url, :code)
json.creator do
  json.partial! 'users/user', user: @group.creator
end

if @include_members
  json.members do
    json.partial! 'users/user', collection: @group.members, as: :user
  end
end
