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
    @user = User.find(params[:user_id])
    authorize!(@user, :index)
    @groups = @user.groups
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

  def authorize!(model, action)
    case action
    when :index
      raise Forbidden, 'Record not found' unless model == current_user
    end
  end
end
