class Option < ActiveRecord::Base
 belongs_to :question

  #Validations
  validates_presence_of :name




end
