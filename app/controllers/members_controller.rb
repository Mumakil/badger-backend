class MembersController < ApplicationController
  before_action :require_user

  def index
    @members = group.members
  end

  def create
    @membership = group_by_code.memberships.create!(user: current_user)
    render status: :created
  end

  def destroy
    authorize!(membership, :destroy)
    membership.destroy!
  end

  private

  def membership
    @membership ||= begin
      Membership.where(user_id: params[:id], group_id: params[:group_id]).first!
    end
  end

  def group_by_code
    @group ||= begin
      Group.find_by_code!(params[:code])
    end
  end

  def group
    @group ||= begin
      current_user.groups.find(params[:group_id])
    end
  end

  def user
    @user ||= begin
      User.find(params[:id])
    end
  end

  def authorize!(membership, action)
    case action
    when :destroy
      raise Unauthorized, 'User not found' unless membership.user_id == current_user.id
    else
      raise 'Unknown action'
    end
  end
end
