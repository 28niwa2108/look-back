class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :user_identification, except: [:index]

  def new
    set_user
    set_subs
  end

  def create
    @subs = Subscription.new(subs_params)
    if @subs.valid?
      @subs.save
      redirect_to user_path(current_user)
    else
      set_user 
      render 'subscriptions/new'
    end
  end

  private
  def user_identification
    redirect_to root_path if current_user != User.find(params[:user_id])
  end

  def set_user
    @user = current_user
  end

  def set_subs
    @subs = Subscription.new
  end

  def subs_params
    params.require(:subscription).permit(
      :name, :price, :contract_date, :update_type_id, :update_cycle
    ).merge(user_id: current_user.id)
  end
end
