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
#  genre_id               :integer
#  videos_watched_count   :integer
#  user_genre_score_id    :integer
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
  has_many :user_genre_scores
  has_many :user_votes
  has_and_belongs_to_many :roles
  belongs_to :rank
  belongs_to :original_genre, :foreign_key => "genre_id", :class_name => "Genre"
  belongs_to :primary_genre_score, :foreign_key => "user_genre_score_id", :class_name => "UserGenreScore"

  after_create :set_defaults!

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

  def set_defaults!
    self.roles << Role.default_role unless self.has_role?(Role::DEFAULT_ROLE_NAME)

    self.rank = Rank.find_by_rank(0) if self.rank.nil?
    self.original_genre = Genre.first if self.original_genre.nil?
    self.save!

    self.update_ratings UserGenreScore::ORIGINAL, self.original_genre
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
    self.rank.rank > 0
  end

  def vote_videos
    Video.all.limit(9)
  end

  def rank_score score_type
    self.rank.send(score_type).to_d / 100.00 rescue 0
  end

  def primary_score
    primary_user_genre_score = self.primary_genre_score
    if primary_user_genre_score.nil?
      primary_user_genre_score = UserGenreScore.totals.where(:user => self).order("score DESC").limit(1).first
      self.update_attribute(:user_genre_score_id, primary_user_genre_score.id) unless primary_user_genre_score.nil?
    end

    return primary_user_genre_score.score unless primary_user_genre_score.nil?
    0.00
  end

  def update_ratings score_type, current_genre, total_count = 1
    primary_genre_score = nil
    Genre.find_each do |genre|
      total_score = 0.0
      found_score_type = false
      user_genre_score_total = nil
      UserGenreScore.where(:user => self, :genre => genre).each do |user_genre_score|
        if user_genre_score.score_type == UserGenreScore::TOTAL
          user_genre_score_total = user_genre_score
        else
          if user_genre_score.score_type == score_type
            found_score_type = true
            if genre == current_genre
              video_count = (user_genre_score.video_count + 1).to_d
              params = { :video_count => video_count }
            else
              video_count = user_genre_score.video_count.to_d
              params = {}
            end
            params.merge!({ :score => (video_count / total_count) * self.rank_score(user_genre_score.score_type) })
            user_genre_score.update_attributes(params)
          end
          total_score = user_genre_score.score
        end
      end

      if !found_score_type && genre == current_genre
        score = (1.00 / total_count) * self.rank_score(score_type)
        UserGenreScore.create(:score_type => score_type, :user => self, :genre => current_genre, :score => score, :video_count => 1)
        total_score += score
      end

      if user_genre_score_total.nil?
        user_genre_score_total = UserGenreScore.create(:score_type => UserGenreScore::TOTAL, :user => self, :genre => genre, :score => total_score)
      else
        user_genre_score_total.update_attribute(:score, total_score)
      end

      primary_genre_score = user_genre_score_total if (primary_genre_score.nil? || primary_genre_score.score < user_genre_score_total.score)
    end
    self.update_attribute :user_genre_score_id, primary_genre_score.id unless primary_genre_score.id == self.user_genre_score_id
  end

  # upgrade a guest user to Rank 1 after they upload their first video
  def upgrade_rank
    if self.rank.nil? || self.rank.rank == 0
      rank1 = Rank.find_by_rank(1)
      self.update_attribute(:rank_id, rank1.id) unless rank1.nil?
    end
  end

  protected

  def has_role? role_in_question
    self.roles.where(:name => role_in_question.to_s).any?
  end
end
