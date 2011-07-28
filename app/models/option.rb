class Option < ActiveRecord::Base
  #relationships:
 belongs_to :question

  #Validations
  validates_presence_of :name




end
