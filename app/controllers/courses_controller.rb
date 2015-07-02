class CoursesController < ApplicationController
  before_action :logged_in_user
  
  def show
    @course = Course.find params[:id]
    @activities = current_user.activities.course_activities @course.id
    @subject = @course.subjects
    @users = @course.trainees
  end

  def index
    @courses = Course.paginate page: params[:page], per_page: Settings.user.per_page
  end
end
