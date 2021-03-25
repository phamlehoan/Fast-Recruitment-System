class Recruiter::InstitutionsController < RecruiterController
  before_action :get_institution, only: [:edit, :update]

  def new
    @institution = Institution.new
  end

  def create
    @institution = Institution.new institution_params
    @institution.created_by = current_user.id
    if check_creation_condidion && @institution.save
      flash[:success] = t "institution.create_success"
      redirect_to institution_path(id: @institution.id)
    else
      flash.now[:warning] = t "institution.create_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @institution.update institution_params
      flash[:success] = t "institution.update_success"
      redirect_to institution_path(id: @institution.id)
    else
      flash.now[:warning] = t "institution.update_fail"
      render :edit
    end
  end

  private

  def get_institution
    @institution = Institution.find_by id: params[:id]
    return if @institution

    flash[:danger] = t "institution.nil"
    redirect_to new_recruiter_institution_path
  end

  def institution_params
    params.require(:institution)
          .permit :institution_name, :address, :logo, :description
  end

  def check_creation_condidion
    return if params[:institution][:logo] &&
              current_user.update(institution_id: @institution.id)
  end
end
