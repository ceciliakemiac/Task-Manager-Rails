require 'rails_helper'

RSpec.describe 'Task API' do
    before { host! 'api.task-manager.test' }

    let!(:user) { create(:user) }
    let(:headers) do
        {
            'Accept' => 'application/vnd.taskmanager.v1',
            'Authorization' => user.auth_token,
            'Content-Type' => Mime[:json].to_s
        }
    end

    describe 'GET /tasks' do
        before do
            create_list(:task, 5, user_id: user.id)
            get '/tasks', :params => {}, :headers => headers
        end

        it 'returns status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'returns 5 tasks from database' do
            expect(json_body['tasks'].count).to eq(5)
        end
    end

    describe 'GET /tasks/:id' do
        let(:task) { create(:task, user_id: user.id) }
        let(:task_id) { task.id }
        
        before do
            get "/tasks/#{task.id}", :params => {}, :headers => headers
        end

        context 'when the task exists' do
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
    
            it 'returns the json data for the task' do
                expect(json_body['title']).to eq(task.title)
            end
        end

        context 'when the task not exists' do
            before do
                get "/tasks/250", :params => {}, :headers => headers
            end

            it 'return status code 404' do
                expect(response).to have_http_status(404)
            end
        end
    end
end
