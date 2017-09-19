class UsersController < ApplicationController
  before_action :require_user
  before_action :me, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  private

  def me
    params[:id] = current_user.id if params[:id] == 'me'
  end
end
