require "spec_helper"

describe Video do
  let(:video) { create(:video) }

  subject { video }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:url) }
end