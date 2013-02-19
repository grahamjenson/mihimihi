class Event < ActiveRecord::Base

  attr_accessible :content, :title, :years_ago, :over_time, :lonlat, :large_icon_url
end
