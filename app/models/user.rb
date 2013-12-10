# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  rank_id                :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  has_many :videos
  belongs_to :rank
  has_and_belongs_to_many :roles
  after_create :add_default_role!

  has_attached_file :image,
                    :styles => { :medium => "200x200#",
                                 :small => "125x125#",
                                 :thumb => "45x45#" },
                    :default_style => :medium,
                    :default_url => '/images/missing.png',
                    :storage => ((Rails.env.production? || Rails.env.staging?) ? :s3 : :filesystem),
                    :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                    :url => (Rails.env.production? || Rails.env.staging?) ? ':s3_alias_url' : '/users/:id/:style/:basename.:extension',
                    :s3_host_alias => "s3-us-west-1.amazonaws.com/odiun-staging",
                    :path => (Rails.env.production? || Rails.env.staging?) ? 'users/:id/:style/:basename.:extension' : ':rails_root/public/users/:id/:style/:basename.:extension'

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def add_default_role!
    self.roles << Role.default_role unless self.has_role?(Role::DEFAULT_ROLE_NAME)
  end

  def turn_into_voter!
    unless self.videos.empty?
      self.roles << Role.voter_role unless self.has_role?(:voter)
    end
  end

  def admin?
    self.has_role?(:admin)
  end

  def voter?
    self.has_role?(:voter)
  end

  def vote_videos
    Video.all.limit(9)
  end

  protected

  def has_role? role_in_question
    self.roles.where(:name => role_in_question.to_s).any?
  end
end
