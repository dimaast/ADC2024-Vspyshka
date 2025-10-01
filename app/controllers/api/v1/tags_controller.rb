class Api::V1::TagsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /api/v1/tags
  def index
    @tags = ActsAsTaggableOn::Tag.where(tag_type: "tag").order(:name)
    render json: @tags.map { |tag| { id: tag.id, name: tag.name, tag_type: tag.tag_type } }
  end

  # GET /api/v1/categories
  def categories
    @categories = ActsAsTaggableOn::Tag.where(tag_type: "category").order(:name)
    render json: @categories.map { |category| { id: category.id, name: category.name, tag_type: category.tag_type } }
  end
end
