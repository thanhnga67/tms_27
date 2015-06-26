class Course < ActiveRecord::Base
  after_update :set_course_activity

  has_many :users, through: :user_courses
  has_many :user_courses, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.user.maximum}
  validates :description, presence: true
  validates :status, presence: true, length: {maximum: Settings.user.maximum}

  scope :current_course, ->{where status: Settings.activity.start}

  private 
  def set_course_activity
    users.each {|user| user.activities.create target_id: id, content: Settings.activity.joined}
  end
end
