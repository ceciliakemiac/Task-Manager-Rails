require 'rails_helper'

RSpec.describe 'Task API' do
    before { host! 'api.task-manager.test' }

    let!(:user) { create(:user) }
    let(:headers) do
        {
            'Accept' => 'application/vnd.taskmanager.v2',
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

    describe 'POST /tasks' do
        before do
            post '/tasks', :params => { task: task_params }.to_json, :headers => headers
        end

        context 'when the request params are correct' do
            let(:task_params) { attributes_for(:task) }

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end

            it 'saves the task in the database' do
                expect(Task.find_by(title: task_params[:title])).not_to be_nil
            end

            it 'returns the json data for the created task' do
                expect(json_body['title']).to eq(task_params[:title])
            end

            it 'assigns the created task to the current user' do
                expect(json_body['user_id']).to eq(user.id)
            end
        end

        context 'when the request params are not correct' do
            let(:task_params) { attributes_for(:task, title: '') }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not save the task in the database' do
                expect(Task.find_by(title: task_params[:title])).to be_nil
            end

            it 'returns the json data for the errors' do
                expect(json_body['errors']).to have_key('title')
            end
        end
    end

    describe 'PUT /tasks/:id' do
        let!(:task) { create(:task, user_id: user.id) }

        before do
            put "/tasks/#{task.id}", :params => { task: task_params }.to_json, :headers => headers
        end

        context 'when the request params are valid' do
            let(:task_params) { { title: 'My carreer is...' } }

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end

            it 'returns the json data for the updated task' do
                expect(json_body['title']).to eq(task_params[:title])
            end

            it 'updates the task in the database' do
                expect(Task.find_by(title: task_params[:title])).not_to be_nil
            end
        end

        context 'when the request params are invalid' do
            let(:task_params) { { title: '' } }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns the json data for the errors for the title' do
                expect(json_body['errors']).to have_key('title')
            end

            it 'does not updates the task in the database' do
                expect(Task.find_by(title: task_params[:title])).to be_nil
            end
        end
    end

    describe 'DELETE /tasks/:id' do
        let!(:task) { create(:task, user_id: user.id) }

        before do
            delete "/tasks/#{task.id}", :params => {}, :headers => headers
        end

        it 'returns status code 204' do
            expect(response).to have_http_status(204)
        end

        it 'removes the task from the database' do
            expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end
