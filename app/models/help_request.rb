class HelpRequest < ApplicationRecord
  has_one_attached :problem_picture
  belongs_to :subject
  belongs_to :student
  belongs_to :tutor, optional: true
  enum state: [:pending, :in_progress, :finished]
  has_many :offers

  def in_progress?
    state == 'in_progress' 
  end
end
