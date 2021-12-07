class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :user_identification, except: [:index]

  def show
    set_user
    set_subs
  end

  def new
    set_user
    @subs = Subscription.new
  end

  def create
    @subs = Subscription.new(subs_params)
    #更新タイプが「日」なら、更新日タイプをnilにする
    @subs.update_day_type_id = nil if @subs.update_type_id == 1
    if @subs.save
      redirect_to user_path(current_user)
    else
      set_user
      render 'subscriptions/new'
    end
  end

  def edit
    set_user
    set_subs
  end

  def update
    set_subs
    update_sub = subs_params
    #更新タイプが「日」なら、更新日タイプをnilにする
    update_sub[:update_day_type_id] = nil if update_sub[:update_type_id] == "1"
    if @subs.update(subs_params)
      redirect_to user_path(current_user)
    else
      set_user
      render :edit
    end
  end

  def destroy
    set_subs
    sub_name = @subs.name
    if @subs.destroy
      render json: { subname: sub_name }
    else
      render json: { process_ng: true }
    end
  end

  private

  def user_identification
    redirect_to user_path(current_user) if current_user != User.find_by(id: params[:user_id])
  end

  def set_user
    @user = current_user
  end

  def set_subs
    @subs = Subscription.find_by(id: params[:id])
    redirect_to user_path(current_user) if @subs.nil?
  end

  def subs_params
    params.require(:subscription).permit(
      :name, :price, :contract_date, :update_type_id, :update_cycle, :update_day_type_id
    ).merge(user_id: current_user.id)
  end
end
