# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  def create
    @user = User.authenticate_by(username: params[:user][:username], password: params[:user][:password])

    unless @user
      flash.now[:alert] = "Incorrect username or password."
      render :new, status: :unprocessable_entity and return
    end

    if @user&.unconfirmed?
      redirect_to login_path, alert: "Incorrect username or password."
    else
      after_login_path = session[:user_return_to] || root_path
      active_session = login @user
      remember active_session if params[:user][:remember_me] == "1"
      redirect_to after_login_path, notice: "Signed in."
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end
end
