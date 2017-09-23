class CodesController < ApplicationController
  before_action :require_user

  def update
    @group = current_user.groups.find(params[:group_id])
    @group.generate_code!
    @group.save!
    render 'groups/show'
  end
end
