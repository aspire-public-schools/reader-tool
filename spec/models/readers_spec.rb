require 'spec_helper'

describe Reader do
	it { should validate_presence_of :email }
  has_many :observation_reads
end