class TopicsController < ApplicationController
  before_action :user_signin
  before_action :student
  skip_before_action :verify_authenticity_token

  def index
    @timenotifi = Timenotifi.where(department_id: current_user.student.department_id)
    @topic_of_student = current_user.student.topic
    if @timenotifi.blank?
      @check = -1 #chua mo
    elsif @timenotifi[0].status == 0
      @check = 0 #dang dong
    elsif @timenotifi[0].status == 2
      @check = 0 #dang dong
    elsif @topic_of_student.blank?
      @check = 1 #dang ky de tai
    elsif @topic_of_student.status == 0
      @check = 2 #dang cho xu ly
    elsif @topic_of_student.status == 1
      @check = 3 #chap nhan
    elsif @topic_of_student.status == 2
      @check = 4 #khong chap nhan
    end

    @departments = Department.all
    @subjects = Subject.all
    @teacher = Teacher.all
    if(params[:department_id])
      department_id = params[:department_id]
      @department = Department.find_by(id: department_id)
      @subjects_belong_department = @department.subjects
      # do something with some_parameter and return the results

      respond_to do |format|
        format.html
        format.text {render json: @subjects_belong_department}
      end
    end

    if(params[:subject_id])
      subject_id = params[:subject_id]
      @subject = Subject.find_by(id: subject_id)
      @teachers_belong_subject = Teacher.joins(:user)
       .select('teachers.*,users.first_name,users.last_name')
       .where("teachers.subject_id = ?", subject_id)

      respond_to do |format|
        format.html
        format.text {render json: @teachers_belong_subject}
      end
    end
  end

  def show
    @topic = Topic.find_by(id: params[:id])
    @divisions = @topic.divisions
    @teacher = []
    @divisions.each do |division|
      @teacher << division.teacher.user.first_name + " " + division.teacher.user.last_name
    end
  end

  def create
    @timenotifi = Timenotifi.find_by(department_id: current_user.student.department_id)
    @topics = Topic.all
    @check_compair = 0
    @topics.each do |topic|
      if topic.name.to_s == params[:name_topic].to_s
        @check_compair = 1
      end
    end
    if @check_compair == 0
      if @timenotifi.status == 1
        # byebug
        if params[:check].to_i == 1
          @topic = Topic.new(name: params[:name_topic], description: params[:description],
            student_id: current_user.student.id, status: 0)
          @topic.save
          id_topic = @topic.id
          Division.create(teacher_id: params[:teacher_id], topic_id: id_topic)
          if params[:teacher_id_2]
            Division.create(teacher_id: params[:teacher_id_2], topic_id: id_topic)
          end
        elsif params[:check].to_i == 4
          @topic = Topic.find_by(student_id: current_user.student.id)
          @topic.update_attributes(name: params[:name_topic], description: params[:description], status: 0)
          @divisions = @topic.divisions
          @divisions.each do |division|
            division.destroy
          end
          Division.create(teacher_id: params[:teacher_id], topic_id: @topic.id)
          if params[:teacher_id_2]
            Division.create(teacher_id: params[:teacher_id_2], topic_id: @topic.id)
          end
          flash[:success] = "Đã thay đổi đề tài thành công"
        end
      else
        flash[:danger] = "Đã hết thời gian đăng ký"
      end
      redirect_to topics_path
    else
      redirect_to topics_path, notice: "Đề tài của bạn đã bị trùng"
    end
  end
end
