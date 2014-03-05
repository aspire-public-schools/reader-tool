class Child < ActiveRecord::Base
  belongs_to :parent

  attr_accessible :attr1, :attr2
end