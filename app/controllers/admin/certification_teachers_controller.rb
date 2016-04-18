class Admin::CertificationTeachersController < AdminController

  def index
  	@CertificationTeacher = CertificationTeacher.first
  end

  def update
  	if params[:truncate_data] == "1"
  		ObservationRead.delete_all
  		DomainScore.delete_all
  		IndicatorScore.delete_all
  		EvidenceScore.delete_all
  	end

  	certificationTeacher = CertificationTeacher.first
  	certificationTeacher.employee_id_learner = params[:employee_id_learner]
  	
  	if certificationTeacher.save
      flash[:success] = "Your changes were saved!"
    else
      flash[:error] = "Your changes didn't save, contact the system Administrator"
    end
    redirect_to admin_path, :flash => flash
  end

end
