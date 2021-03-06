class Admin::DispatchsController < ApplicationController
  def show
    @student = Student.where(status: 1)
    @students = []

    @student.each do |t|
      if t.topic.blank?
      else
        @students << t
      end
    end
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"congvandetai.docx\"" }
    end
  end

  def index
    @timenotifi = Timenotifi.find_by(department_id: current_user.departmentuser.department_id)
    @student = Student.where(status: 1)
    @students = []

    @student.each do |t|
      if t.topic.blank?
      else
        @students << t
      end
    end
    @topics_cancel = Topic.where(status: 5)
    @topics_edit = Topic.where(status: 4)
    if @timenotifi.blank?
      @check = 0
    elsif @timenotifi.status != 2
      @check = 0
    else
      @check = 1
    end
  end

  def cancel
    @topics_cancel = Topic.where(status: 5)
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"congvanxinthoi.docx\"" }
    end
  end
  def edit
    @topics_edit = Topic.where(status: 4)
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"congvansuadoi.docx\"" }
    end
  end
  def protect_word
    @topics_protect = Topic.where(is_proteced: 3)
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"congvanbaove.docx\"" }
    end
  end
  def protect_excel
    @topics_protect = Topic.where(is_proteced: 3)
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="danhsachbaove.xlsx"'
      }
    end
  end
  def protect
    @topics_protect = Topic.where(is_proteced: 3)
  end
  def councils
    @topics_protect = Topic.where(is_proteced: 3)
    @council = Council.find_by(department_id: current_user.departmentuser.id)
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"congvanhoidong.docx\"" }
    end
  end
  def indexcouncil
    @topics_protect = Topic.where(is_proteced: 3)
    @council = Council.find_by(department_id: current_user.departmentuser.id)
    @chairman = Teacher.find_by(id: @council.chairman)
    @commissioner = Teacher.find_by(id: @council.commissioner)
    @secretary = Teacher.find_by(id: @council.secretary)
  end

  def reported
    @topics_done = Topic.where(is_proteced: 4)
    respond_to do |format|
      format.docx { headers["Content-Disposition"] = "attachment; filename=\"baocao.docx\"" }
    end
  end

  def indexreported
    @topics_done = Topic.where(is_proteced: 4)
  end
end
