class Event < ActiveRecord::Base
  serialize :lonlat, ActiveRecord::Coders::Hstore

  attr_accessible :content, :title, :years_ago, :over_time, :lonlat
end
