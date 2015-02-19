require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, :type => :controller do
  describe "GET #index" do
    it "returns all the projects, ordered by recency" do
      older_project = create(:project,
        created_at: Time.zone.now - 1.week)
      old_project = create(:project,
        created_at: Time.zone.now - 1.day)
      oldest_project = create(:project,
        created_at: Time.zone.now - 1.year)

      ordered_projects = [old_project, older_project, oldest_project]

      get :index

      serialized_projects = ActiveModel::ArraySerializer.new(ordered_projects,
        root: :projects)

      expect(response.status).to eq 200
      expect(json).to be_json_eq(serialized_projects)
    end
  end

  describe "GET #show" do
    xit "returns a project" do
      project = create(:project)
      tasks = create_list(:task, 3, project: project)

      serialized_project = ProjectSerializer.new(project, include: [:user, :tasks])

      get :show, id: project.id

      expect(response.status).to eq 200
      expect(json).to be_json_eq serialized_project
    end
  end
end
