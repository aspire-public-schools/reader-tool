require 'spec_helper'

describe ObservationRead, '#grader?' do
  let(:grader_1a) { build(:observation_read, reader_number: '1a') }
  let(:grader_1b) { build(:observation_read, reader_number: '1b') }
  let(:supervisor) { build(:observation_read, reader_number: '2') }

  it 'is true if the observation read is assigned to a 1a or 1b'
    expect(grader_1a.grader?).to eq true
    expect(grader_1b.grader?).to eq true
  end

  it 'is false otherwise'
    expect(supervisor.grader?).to eq false
  end
end

describe ObservationRead, '#verify_complete' do
  let(:read) { build(:observation_read, observation_status: 1) }

  it 'updates the observation status to 3' do
    read.verify_complete

    expect(read.observation_status).to eq 3
  end
end

describe ObservationRead, '#complete' do
  let(:grader_read) { build(:observation_read, reader_number: '1a') }
  let(:supervisor_read) { build(:observation_read, reader_number: '2') }

  it 'submits the read for verification if completed by a grader' do
    grader_read.complete

    expect(grader_read.observation_status).to eq 2
  end

  #it 'copies the scores if completed by a grader' do
    grader_read.complete

    expect(scores to be copied)
  end

  it 'is marked as verified if checked by a supervisor' do
    supervisor_read.complete

    expect(supervisor_read.status).to eq 3
  end
end

describe '#my_method' #instance '.my_method' #class
  it 'english description of what it does' do
    #preparation create/build instance lay the groundwork

    # execute the method being tested

    expect(subject).to_not eq  #expectation of results
  end
end

def double(num)
  num * 2
end

num = 5 # prepare the input

results = double(num) # execute

expect(results).to eq 10 #assert your expectation
