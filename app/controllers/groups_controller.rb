class GroupsController < ApplicationController
  before_action :require_user

  def show
    @group = current_user.groups.find(params[:id])
    @include_members = true
  end

  def create
    @group = Group.new(create_params)
    @group.creator = current_user
    @group.save!
    @include_members = true
    render :show, status: :created
  end

  def update
    @group = current_user.groups.find(params[:id])
    @group.update_attributes!(update_params)
    render :show
  end

  private

  def create_params
    params.permit(:name, :photo_url)
  end

  def update_params
    params.permit(:name, :photo_url)
  end
end
