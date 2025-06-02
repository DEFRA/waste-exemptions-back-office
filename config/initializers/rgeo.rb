require "rgeo"

# Make the default factory skip strict ring checks
# This is required to read all of the spatial data from the
# GeoJSON Administrative_Boundaries_Environment_Agency_and_Natural_England_Public_Face_Areas.json.zip
RGeo::ActiveRecord::SpatialFactoryStore.instance.default =
  ->(*_) { RGeo::Geos.factory(srid: 4326, uses_lenient_assertions: true) }
