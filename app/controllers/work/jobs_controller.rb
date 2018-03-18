module Work
  class JobsController < ApplicationController
    include Destructible

    before_action -> { nav_context(:work, :jobs) }
    decorates_assigned :job, :jobs
    helper_method :sample_job

    def index
      authorize sample_job
      prepare_lenses(:"work/requester", :"work/period")
      @period = lenses[:period].object
      @jobs = policy_scope(Job).for_community(current_community)
      if @period.nil?
        lenses.hide!
      else
        @jobs = @jobs.in_period(@period).includes(:shifts).by_title
        if params[:requester] == "none"
          @jobs = @jobs.from_requester(nil)
        elsif params[:requester].present?
          @jobs = @jobs.from_requester(params[:requester])
        end
      end
    end

    def new
      return render_not_found unless params[:period].present?
      @job = Job.new(period_id: params[:period])
      @job.shifts.build
      authorize @job
      prep_form_vars
    end

    def edit
      @job = Job.find(params[:id])
      authorize @job
      prep_form_vars
    end

    def create
      @job = Job.new
      @job.assign_attributes(job_params)
      authorize @job
      if @job.save
        flash[:success] = "Job created successfully."
        QuotaCalculator.new(@job.period).recalculate_and_save
        redirect_to work_jobs_path
      else
        set_validation_error_notice(@job)
        prep_form_vars
        render :new
      end
    end

    def update
      @job = Job.find(params[:id])
      authorize @job
      if @job.update_attributes(job_params)
        QuotaCalculator.new(@job.period).recalculate_and_save
        flash[:success] = "Job updated successfully."
        redirect_to work_jobs_path
      else
        set_validation_error_notice(@job)
        prep_form_vars
        render :edit
      end
    end

    protected

    def klass
      Job
    end

    private

    def sample_job
      Job.new(period: @period || Period.new(community: current_community))
    end

    def prep_form_vars
      @requesters = People::Group.for_community(current_community).by_name
    end

    # Pundit built-in helper doesn't work due to namespacing
    def job_params
      params.require(:work_job).permit(policy(@job).permitted_attributes)
    end
  end
end
