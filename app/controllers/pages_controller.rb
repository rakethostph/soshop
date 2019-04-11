class PagesController < ApplicationController
  def index
  end

  def results
	query = params[:search_items].presence && params[:search_items][:query]

	  if query
	    @items = Item.search_items(query)
	  end

  end
end