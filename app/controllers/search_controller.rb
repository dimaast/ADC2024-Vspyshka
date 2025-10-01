class SearchController < ApplicationController
  def index
    @query = params[:query] || ""
    @items = []
    
    if @query.present?
      @items = PgSearch.multisearch(@query)
    end

    @events = @items.select { |item| item.searchable_type == 'Event' && item.searchable.present? }
    @meets = @items.select { |item| item.searchable_type == 'Meet' && item.searchable.present? }
    @communities = @items.select { |item| item.searchable_type == 'Community' && item.searchable.present? }
  end

  def autocomplete
    query = params[:query] || ""
    
    if query.length >= 3
      items = PgSearch.multisearch(query).limit(5)

      valid_items = items.select { |item| item.searchable.present? && item.searchable_type != 'User' }
      results = valid_items.map do |item|
        {
          title: get_searchable_title(item.searchable),
          url: polymorphic_url(item.searchable),
          type: item.searchable_type
        }
      end
    else
      results = []
    end
    
    render json: results
  end

  private

  def get_searchable_title(searchable)
    case searchable
    when Event
      searchable.title
    when Meet
      searchable.body.truncate(50)
    when Community
      searchable.title
    else
      "Неизвестный объект"
    end
  end
end