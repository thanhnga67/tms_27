class Course < ActiveRecord::Base
  include PrettyUrl

  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :supervisors, ->{where(supervisor: Settings.user.supervisor)}, 
            class_name: "User", through: :user_courses, source: "user"
  has_many :trainees, ->{where(supervisor: Settings.user.notsupervisor)}, 
            class_name: "User", through: :user_courses, source: "user"
  has_many :subjects, through: :course_subjects
  has_many :course_subjects, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.user.maximum}
  validates :description, presence: true
  validates :status, presence: true, length: {maximum: Settings.user.maximum}
  validates_presence_of :start, :finish
  validate :finish_date_is_after_start_date

  after_update :set_course_activity, :check_finish

  scope :current_course, ->{where status: Settings.activity.start}

  private 
  def set_course_activity
    users.each {|user| user.activities.find_or_create_by target_id: id, content: Settings.activity.joined}
  end

  def check_finish
    if Settings.subject.finish == status
      course_subjects.update_all status: Settings.subject.finish
      subjects.each do |subject|
        subject.user_subjects.update_all status: Settings.subject.finish
        subject.tasks.each do |task|
          task.user_tasks.update_all status: Settings.subject.finish
        end
      end
    end
  end

  def finish_date_is_after_start_date
    return if finish.blank? || start.blank?
    if finish < start
      errors.add(:finish, "cannot be before the start date") 
    end
  end
end
