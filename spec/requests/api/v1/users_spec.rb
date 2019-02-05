require 'rails_helper'

RSpec.describe 'Users API', type: :request do
    let!(:user) { create(:user) }
    let(:user_id) { user.id }

    before { host! 'api.taskmanager.test' }

    describe 'GET /users/:id' do
        before do
            headers = { 'Accept' => 'application/vnd.taskmanager.v1' }
            get "/users/#{user_id}", :params => {}, :headers => headers
        end

        context 'when the user exists' do
            it 'returns the user' do
                user_response = JSON.parse(response.body)
                expect(user_response['id']).to eq(user_id)
            end

            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when the user not exists' do
            let(:user_id) { 200 }

            it 'returns status code 404' do
                expect(response).to have_http_status(404)
            end
        end

    end

    describe 'POST /users' do
        before do
            headers = {'Accept' => 'application/vnd.taskmanager.v1'}
            post "/users", :params => { user: user_params }, :headers => headers
        end
    
        context 'when the request params are valid' do
            let(:user_params) { attributes_for(:user) }
            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end

            it 'returns json data for the created' do
                user_response = JSON.parse(response.body)
                expect(user_response["email"]).to eq(user_params[:email])
            end
        end

        context 'when the request params are invalid' do
            let(:user_params) { attributes_for(:user, email: 'invalido@') }
            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns json data for the errors' do
                user_response = JSON.parse(response.body)
                expect(user_response).to have_key('errors')
            end
        end
    end

    describe 'PUT /users/:id' do
        before do
            headers = {'Accept' => 'application/vnd.taskmanager.v1'}
            put "/users/#{user_id}", :params => {user: user_params}, :headers => headers
        end

        context 'when the request params are valid' do
            let(:user_params) { {email: 'novoemail@gmail.com'} }
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end

            it 'returns json data for the updated user' do
                user_response = JSON.parse(response.body)
                expect(user_response['email']).to eq(user_params[:email])
            end
        end

        context 'when the request params are invalid' do
            let(:user_params) { {email: ''} }
            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns json data for the errors' do
                user_response = JSON.parse(response.body)
                expect(user_response).to have_key('errors')
            end
        end
    end

    describe 'DELETE /users/:id' do
        before do
            headers = {'Accept' => 'application/vnd.taskmanager.v1'}
            delete "/users/#{user_id}", :params => {}, :headers => headers
        end

        it 'returns status code 204' do
            expect(response).to have_http_status(204)
        end

        it 'removes the user from database' do
            expect(User.find_by(id: user.id)).to be_nil
        end
    end
end