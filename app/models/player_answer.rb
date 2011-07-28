class PlayerAnswer < ActiveRecord::Base
validates_presence_of :player_id
  validates_presence_of :question_id
  validates_presence_of :answer
  validates_presence_of :answer_after_self_scoring
  validates_numericality_of :player_id,:message => "should be a integer"
  validates_numericality_of :question_id,:message => "should be a integer"
  validates_numericality_of :answer_after_self_scoring,:message => "should be a integer"
end
