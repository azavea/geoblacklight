class RelationController < ApplicationController
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  copy_blacklight_config_from(CatalogController)

  def ancestors
    respond_to do |format|
      format.json do
        render json: {:url => root_url, :response => find_ancestors}
      end
    end
  end

  def descendants
    respond_to do |format|
      format.json do
        render json: {:url => root_url, :shared_ancestor => params[:id], :response => find_descendants}
      end
    end
  end

  def find_ancestors
    resp = Geoblacklight::Relation::Ancestors.new(params[:id], repository).results
  end

  def find_descendants
    resp = Geoblacklight::Relation::Descendants.new(params[:id], repository).results
  end

end