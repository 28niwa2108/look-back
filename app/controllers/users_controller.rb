class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_identification

  def show
    @user = User.find_by(id: params[:id])
    @subs = Subscription.where(user_id: params[:id])
    redirect_to root_path if @user.nil?
  end

  private

  def user_identification
    redirect_to user_path(current_user) if current_user != User.find_by(id: params[:id])
  end
end
