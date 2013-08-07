class Video < ActiveRecord::Base

#  attr_accessible :url, :description

  validates_presence_of :description, :url
end
