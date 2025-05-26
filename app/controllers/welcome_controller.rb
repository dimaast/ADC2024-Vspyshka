class WelcomeController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :search

  # before_action:
  def index
  end

  def about
  end

  def search
    @items = PgSearch.multisearch(params['query'])
    puts @items.count
  end
end
