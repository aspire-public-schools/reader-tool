require 'spec_helper'

describe Reader do
	it { should validate_presence_of :email }
  it { should have_many(:observation_reads) }
end

describe ObservationRead do
  it { should have_many(:domain_scores)}
  it { should belong_to(:reader)}
end

describe DomainScore do
  it { should belong_to(:observation_read)}
  it { should have_many(:indicator_scores)}
  it { should have_many(:indicators).through(:indicator_scores)}
  it { should belong_to(:domain)}
end

describe Domain do
  it { should have_many(:domain_scores)}
  it { should have_many(:indicators)}
end

describe Indicator do
  it { should belong_to(:domain)}
  it { should have_many(:indicator_scores)}
  it { should have_many(:domain_scores).through(:indicator_scores)}
end

describe EvidenceScore do
  it { should belong_to(:indicator_score)}
  it { should have_many(:domain_scores).through(:indicator_scores)}
  it { should have_many(:indicators).through(:indicator_scores)}
end

describe IndicatorScore do
  it { should have_many(:evidence_scores)}
  it { should belong_to(:indicator)}
  it { should belong_to(:domain_score)}
end



