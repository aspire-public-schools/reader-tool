class Domain < ActiveRecord::Base
  attr_accessible :number, :description
  has_many :domain_scores
  has_many :indicators
end

def int_to_words(int)

  numbers = {1 => 'One',
             2 => 'Two',
             3 => 'Three',
             4 => 'Four',
             5 => 'Five',
             6 => 'Six',
             7 => 'Seven',
             8 => 'Eight',
             9 => 'Nine',
             10 => 'Ten',
             11 => 'Eleven',
             12 => 'Twelve',
             13 => 'thirteen',
             14 => 'fourteen',
             15 =>'fifteen'}

  return (numbers[int]) if (10...20).include?(int)
  return ((numbers[int - int % 10]).to_s + (numbers[int % 10]).to_s).rstrip if int <100
  return (numbers[int / 100] + ' hundred ' + in_words(int % 100)).rstrip if (100..999).include?(int)
  return 'one million' if int == 1_000_000
  (in_words(int / 1_000) + ' thousand ' + in_words(int % 1_000)).rstrip
end