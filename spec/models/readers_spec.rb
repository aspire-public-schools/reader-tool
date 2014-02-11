require 'spec_helper'

describe Reader do
	it { should validate_presence_of :email }
end