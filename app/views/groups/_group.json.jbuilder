json.(group, :id, :name, :photo_url, :code)
json.creator do
  json.partial! 'users/user', user: group.creator
end
