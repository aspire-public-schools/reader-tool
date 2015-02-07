require "spec_helper"

describe Reader do
  let(:reader) { create(:reader) }

  it "should default to reader1a and reader1b but not reader2" do
    expect(reader.reader1a?).to eq(true)
    expect(reader.reader1b?).to eq(true)
    expect(reader.reader2?).to eq(false)
  end

end
