class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :user_identification, only: [:show]

  def show
    @user = User.find_by(id: params[:id])
    all_subs = Subscription.where(user_id: params[:id])
    @subs = []
    @renewal = []
    all_subs.each do |sub|
      if sub.contract_cancel.nil?
        @subs << sub
        @renewal << sub.contract_renewal
      end
    end
  end

  private

  def user_identification
    redirect_to user_path(current_user) if current_user != User.find_by(id: params[:id])
  end
end
