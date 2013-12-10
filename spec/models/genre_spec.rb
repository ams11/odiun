# == Schema Information
#
# Table name: genres
#
#  id   :integer          not null, primary key
#  name :string(255)
#

require 'spec_helper'

describe Genre do
  let(:genre) { create(:genre) }

  subject { genre }

  it { should validate_presence_of(:name) }
  it { should have_many(:videos) }

  %w(Action Drama Comedy Horror).each do |name|
    it "should validate inclusion of #{name}" do
      genre = Genre.new(:name => name)
      genre.save
      genre.errors[:name].should be_blank
    end
  end

  %w(action drama comedy horror foo bar).each do |name|
    it "should validate inclusion of #{name}" do
      genre = Genre.new(:name => name)
      genre.save
      genre.errors[:name].should_not be_blank
    end
  end
end
