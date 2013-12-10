# == Schema Information
#
# Table name: ranks
#
#  id                 :integer          not null, primary key
#  rank               :integer          not null
#  videos_watched     :decimal(10, 4)   not null
#  original_selection :decimal(10, 4)   not null
#  personal_content   :decimal(10, 4)   not null
#

class Rank < ActiveRecord::Base
  has_many :users

  validates_presence_of :rank, :videos_watched, :original_selection, :personal_content
  validates_inclusion_of :videos_watched, :original_selection, :personal_content, in: 0.00..100.00
end
