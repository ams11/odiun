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

require 'spec_helper'

describe Rank do
  let(:rank) { create(:rank) }

  subject { rank }

  it { should validate_presence_of(:rank) }
  it { should validate_presence_of(:videos_watched) }
  it { should validate_presence_of(:original_selection) }
  it { should validate_presence_of(:personal_content) }

  it { should have_many(:users) }

  [:videos_watched, :original_selection, :personal_content].each do |property|
    # valid values
    [0.00, 34.98, 100.00].each do |number|
      it "should validate inclusion of #{number}" do
        rank = Rank.new(property => number)
        rank.save
        rank.errors[property].should be_blank
      end
    end

    # invlaid values
    [-1.00, 100.01, 590.34].each do |number|
      it "should validate inclusion of #{number}" do
        rank = Rank.new(property => number)
        rank.save
        rank.errors[property].should_not be_blank
      end
    end
  end
end
