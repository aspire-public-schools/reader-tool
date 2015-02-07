require "spec_helper"

describe ObservationRead do
  let(:observation_read) { create(:observation_read, reader_number: '1a', comments: "some comment") }

  describe "#copy_to_reader2" do
    let!(:observation_read2) { create(:observation_read, reader_number: '2', observation_group_id: observation_read.observation_group_id)}

    it "should only copy over once from reader 1" do
      observation_read.copy_to_reader2
      observation_read.copy_to_reader2
      expect(observation_read.comments).to eq("some comment")
    end

  end

end
