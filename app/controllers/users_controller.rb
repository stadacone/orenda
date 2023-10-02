# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:edit, :destroy, :update]

  def create
    @user = User.new(create_user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Please check your email for confirmation"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted."
  end

  def edit
    @user = current_user
    @active_sessions = @user.active_sessions.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def update
    @user = current_user
    @active_sessions = @user.active_sessions.order(created_at: :desc)

    unless @user.authenticate(params[:user][:current_password])
      flash.now[:error] = "Incorrect password"
      return render :edit, status: :unprocessable_entity
    end

    unless @user.update(update_user_params)
      return render :edit, status: :unprocessable_entity
    end

    if params[:user][:unconfirmed_email].present?
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Check your email for confirmation instructions."
    else
      redirect_to root_path, notice: "Account updated."
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :unconfirmed_email)
  end
end
