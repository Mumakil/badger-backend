class GroupsController < ApplicationController
  before_action :require_user
  before_action :me, only: [:index]

  def show
    @group = current_user.groups.find(params[:id])
  end

  def create
    @group = Group.new(create_params)
    @group.creator = current_user
    @group.save!
    render :show, status: :created
  end

  def update
    @group = current_user.groups.find(params[:id])
    @group.update_attributes!(update_params)
    render :show
  end

  def index
    authorize!(user, :index)
    @groups = user.groups.includes(:creator)
  end

  private

  def create_params
    params.permit(:name, :photo_url)
  end

  def update_params
    params.permit(:name, :photo_url)
  end

  def me
    params[:user_id] = current_user.id if params[:user_id] == 'me'
  end

  def authorize!(user, action)
    case action
    when :index
      raise ApplicationError::Forbidden, 'Record not found' unless user == current_user
    else
      raise 'Unknown action'
    end
  end

  def user
    @user ||= begin
      User.find(params[:user_id])
    end
  end
end
