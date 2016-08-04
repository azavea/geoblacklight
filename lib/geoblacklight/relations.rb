module Geoblacklight
  class Relations
    attr_accessor :ancestors, :descendants, :search

    def initialize(document)
      @document = document
      @solr = RSolr.connect :url => ENV['SOLR_URL']
      @ancestors = find_ancestors
      @descendants = find_descendants
      # @search for providing link to faceted search results of all descendant records
      @search = {:descendants => "catalog?f[#{Settings.FIELDS.SOURCE}][]=#{@document['layer_slug_s']}"}
    end

    def find_ancestors
      unless @document[Settings.FIELDS.SOURCE].blank?
        ancestors = @solr.get 'select', :params => {:fq => "layer_slug_s:#{@document[Settings.FIELDS.SOURCE].join(' OR layer_slug_s:')}", :fl => [Settings.FIELDS.TITLE, 'layer_slug_s']}
      end
      ancestors['response']['docs'] unless ancestors.blank?
    end

    def find_descendants
      descendants = @solr.get 'select', :params => {:q => "#{Settings.FIELDS.SOURCE}:#{@document['layer_slug_s']}", :fl => [Settings.FIELDS.TITLE, 'layer_slug_s']}
      descendants['response']['docs'] unless descendants.blank?
    end

    def exist?
      !@ancestors.blank? || !@descendants.blank?
    end

  end
end