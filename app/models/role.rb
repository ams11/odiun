# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  DEFAULT_ROLE_NAME = "user"

  def self.default_role
    Role.find_or_create_by(name: DEFAULT_ROLE_NAME)
  end

  def self.voter_role
    Role.find_or_create_by(:name => :voter)
  end

  def self.admin_role
    Role.find_or_create_by(:name => :admin)
  end
end
