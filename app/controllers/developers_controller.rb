class DevelopersController < ApplicationController
  def index
    render json: DevelopersReadModel.new.all, status: :ok
  end

  def create
    DevelopersService
      .new(event_store: Rails.configuration.event_store)
      .call(register_developer)

    head :created
  end

  private

  def register_developer
    ProjectManagement::RegisterDeveloper.new(
      uuid:     params[:uuid],
      fullname: params[:fullname],
      email:    params[:email]
    )
  end
end
