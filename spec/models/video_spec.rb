require "spec_helper"

describe Video do
  let(:video) { create(:video) }

  subject { video }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:unique_id) }
end