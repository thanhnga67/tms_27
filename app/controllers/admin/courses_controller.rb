class Admin::CoursesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update]
  before_action :is_admin, except: [:index, :show]
  before_action :set_course, only: [:show, :edit, :update]
  before_action :super_of_course, only: [:edit, :update]

  def index
    @courses = Course.paginate page: params[:page], per_page: Settings.user.per_page
  end

  def show
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    if @course.save
      @course.supervisors << current_user
      flash[:success] = I18n.t "create_course_succ"
      redirect_to [:admin, @course]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = I18n.t "Admin.course_update"
      redirect_to [:admin, @course]
    else
      render :edit
    end
  end
  
  def destroy
    @course.destroy
    flash[:success] = t "Admin.course_delete"
    redirect_to :back 
  end

  private
  def set_course
    @course = Course.find params[:id]
  end

  def course_params
    params.require(:course).permit :name, :start, :description, :finish, :status, supervisor_ids: [],
      trainee_ids: [], subject_ids: [], course_subjects_attributes: [:status]
  end

  def super_of_course
    unless @course.supervisors.include? current_user
      flash[:danger] = I18n.t "assign_course_please"
      render :edit
    end
  end
end
