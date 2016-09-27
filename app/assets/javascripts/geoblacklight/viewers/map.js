//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.Map = GeoBlacklight.Viewer.extend({
  
  options: {
    /**
    * Initial bounds of map
    * @type {L.LatLngBounds}
    */
    bbox: [[-80, -195], [80, 185]],
    opacity: 0.75
  },
  
  overlay: L.layerGroup(),

  load: function() {
    var mapOptions = {};
    // Setting `scrollWheelZoom` to `undefined` disables scroll
    // zooming, which is not what we want. Instead, we conditionally
    // set the key in `mapOptions` so that if `scrollWheelZoom` is not
    // defined, we fall back to the Leaflet default behavior.
    if (typeof this.options.scrollWheelZoom !== 'undefined') {
      mapOptions.scrollWheelZoom = this.options.scrollWheelZoom;
    }
    if (this.data.mapBbox) {
      this.options.bbox = L.bboxToBounds(this.data.mapBbox);
    }
    this.map = L.map(this.element, mapOptions).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    if (this.data.map !== 'index') {
      this.addBoundsOverlay(this.options.bbox);
    }
  },

  /**
   * Add a bounding box overlay to map.
   * @param {L.LatLngBounds} bounds Leaflet LatLngBounds
   */
  addBoundsOverlay: function(bounds) {
    if (bounds instanceof L.LatLngBounds) {
      this.overlay.addLayer(L.polygon([
        bounds.getSouthWest(),
        bounds.getSouthEast(),
        bounds.getNorthEast(),
        bounds.getNorthWest()
      ]));
    }
  },

  /**
   * Remove bounding box overlay from map.
   */
  removeBoundsOverlay: function() {
    this.overlay.clearLayers();
  },

  /**
   * Add an opacity control to map.
   */
  addOpacityControl: function() {
    this.map.addControl(new L.Control.LayerOpacity(this.overlay));
  },

  /**
  * Selects basemap if specified in data options, if not return mapquest
  */
  selectBasemap: function() {
    var _this = this;
    if (_this.data.basemap) {
      return GeoBlacklight.Basemaps[_this.data.basemap];
    } else {
      return _this.basemap.mapquest;
    }
  }
});
