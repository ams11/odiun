require 'spec_helper'

describe UserVote do
  let(:user_vote) { create(:user_vote) }

  subject { user_vote }

  it { should belong_to(:user) }
  it { should belong_to(:video) }
end