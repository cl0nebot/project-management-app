class ProjectsController < ApplicationController
  def index
    render json: ProjectsReadModel.new.all, status: :ok
  end

  def create
    command_bus.call(register_project)

    head :created
  end

  def estimate
    command_bus.call(estimate_project)

    head :ok
  end

  private

  def register_project
    Assignments::RegisterProject.new(
      uuid: params[:uuid],
      name: params[:name]
    )
  end

  def estimate_project
    Assignments::EstimateProject.new(
      uuid:  params[:uuid],
      hours: params[:hours]
    )
  end
end
