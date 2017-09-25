json.group do
  json.partial! 'groups/group', group: @membership.group
end
