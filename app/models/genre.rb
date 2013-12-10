# == Schema Information
#
# Table name: genres
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Genre < ActiveRecord::Base
  has_many :videos

  validates_presence_of :name
  validates :name, inclusion: %w(Action Drama Comedy Horror)
end
