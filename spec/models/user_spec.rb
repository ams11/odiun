require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  subject { user }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:videos) }
end
