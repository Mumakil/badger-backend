json.(@user, :id, :name, :avatar_url)

if current_user == @user
  json.(@user, :fbid, :created_at, :updated_at)
end
