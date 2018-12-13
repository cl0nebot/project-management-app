require_dependency 'project_management'

require_relative '../support/test_attributes'

module ProjectManagement
  RSpec.describe 'Project aggregate' do
    include TestAttributes

    specify 'register new project' do
      project = ProjectManagement::Project.new(project_topsecretdddproject[:uuid])
      project.register(project_topsecretdddproject[:name])

      expect(project).to(have_applied(project_registered))
    end

    specify 'estimate the project' do
      project = ProjectManagement::Project.new(project_topsecretdddproject[:uuid])
      project.register(project_topsecretdddproject[:name])
      project.estimate(project_topsecretdddproject[:estimation])

      expect(project).to(have_applied(project_estimated))
    end

    specify 'assign deadline for the project' do
      project = ProjectManagement::Project.new(project_topsecretdddproject[:uuid])
      project.assign_deadline(project_topsecretdddproject[:deadline])

      expect(project).to(have_applied(deadline_assigned))
    end

    specify 'assigning deadline from the past is forbidden' do
      project          = ProjectManagement::Project.new(project_topsecretdddproject[:uuid])
      project_deadline = Time.current.yesterday.to_date.strftime('%d-%m-%Y')

      expect{ project.assign_deadline(project_deadline) }
        .to(raise_error(ProjectManagement::Project::DeadlineFromPast))
    end

    specify 'assign developer to the project' do
      project = ProjectManagement::Project.new(project_topsecretdddproject[:uuid])
      project.assign_developer(developer_ignacy[:uuid], developer_ignacy[:fullname])

      expect(project).to(have_applied(developer_assigned))
    end

    specify 'assign developer working hours per week' do
      project = ProjectManagement::Project.new(project_topsecretdddproject[:uuid])
      project.assign_developer_working_hours(developer_ignacy[:uuid], developer_ignacy[:hours_per_week])

      expect(project).to(have_applied(developer_working_hours_assigned))
    end

    specify 'cannot assign more then 40 working hours per week' do
      project        = ProjectManagement::Project.new(project_topsecretdddproject[:uuid])
      hours_per_week = 50

      expect{ project.assign_developer_working_hours(developer_ignacy[:uuid], hours_per_week) }
        .to(raise_error(ProjectManagement::Project::HoursPerWeekExceeded))
    end

    private

    def project_registered
      an_event(ProjectManagement::ProjectRegistered).with_data(project_registered_date).strict
    end

    def project_estimated
      an_event(ProjectManagement::ProjectEstimated).with_data(project_estimated_data).strict
    end

    def developer_assigned
      an_event(ProjectManagement::DeveloperAssignedToProject).with_data(developer_assigned_data).strict
    end

    def deadline_assigned
      an_event(ProjectManagement::DeadlineAssignedToProject).with_data(deadline_assigned_data).strict
    end

    def developer_working_hours_assigned
      an_event(ProjectManagement::DeveloperWorkingHoursForProjectAssigned)
        .with_data(developer_working_hours_assigned_data)
        .strict
    end

    def project_registered_date
      {
        uuid: project_topsecretdddproject[:uuid],
        name: project_topsecretdddproject[:name]
      }
    end

    def project_estimated_data
      {
        uuid:  project_topsecretdddproject[:uuid],
        hours: project_topsecretdddproject[:estimation]
      }
    end

    def developer_assigned_data
      {
        project_uuid:       project_topsecretdddproject[:uuid],
        developer_uuid:     developer_ignacy[:uuid],
        developer_fullname: developer_ignacy[:fullname]
      }
    end

    def deadline_assigned_data
      {
        uuid:     project_topsecretdddproject[:uuid],
        deadline: project_topsecretdddproject[:deadline]
      }
    end

    def developer_working_hours_assigned_data
      {
        project_uuid:   project_topsecretdddproject[:uuid],
        developer_uuid: developer_ignacy[:uuid],
        hours_per_week: developer_ignacy[:hours_per_week]
      }
    end
  end
end