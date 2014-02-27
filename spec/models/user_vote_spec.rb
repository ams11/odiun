# == Schema Information
#
# Table name: user_votes
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  video_id        :integer
#  score_emotion   :integer
#  score_intellect :integer
#  score_entertain :integer
#

require 'spec_helper'

describe UserVote do
  let(:user_vote) { create(:user_vote) }

  subject { user_vote }

  it { should belong_to(:user) }
  it { should belong_to(:video) }
end
