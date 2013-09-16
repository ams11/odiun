class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  DEFAULT_ROLE_NAME = "user"

  def self.default_role
    Role.find_or_create_by(name: DEFAULT_ROLE_NAME)
  end
end