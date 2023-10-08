# frozen_string_literal: true
class StaticPagesController < ApplicationController
  def home
    @posts = Post.all
  end
end
