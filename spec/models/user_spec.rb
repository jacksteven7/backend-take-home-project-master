require 'rails_helper'
require 'factory_bot'

RSpec.describe "User API", type: :request do
  describe 'Create one User' do
    it 'returns the user created' do
      user_params = {
        user: {
          email: "jackS@stevens.dsf",
          phone_number: "stevens",
          full_name: "Pepito Per12d32edsz2",
          password: "admidoaksdj123",
          metadata: " name: pepito, email: pepito@perez"
        }
      }

      post '/api/users', params: user_params

      user_req = JSON.parse(response.body)
      response.code.should eq "201"
      expect(user_req["email"]).to eq user_params[:user][:email]
    end
  end

  describe 'Create one User with incomplete info' do
    it 'returns the array of errors' do
      user_params = {
        user: {
          email: "",
          phone_number: "",
          full_name: "",
          password: "",
          metadata: ""
        }
      }

      post '/api/users', params: user_params

      user_req = JSON.parse(response.body)
      
      #Fields with erors
      expect(user_req["errors"].keys).to eq(["email", "phone_number"])
      #Error message
      expect(user_req["errors"].values.to_s).to include("can't be blank")
    end
  end

  describe 'Create one User' do
    it 'returns the user created' do
      
      user = FactoryBot.create_list(:user, 12)
      
      get '/api/users'
      users_req = JSON.parse(response.body)["users"]
      #Gets all the users created
      users_req.count eq 12
      #Gets the required data for each user
      expect(users_req.first.keys).to eq(["email", "phone_number", "full_name", "key", "account_key", "metadata"])
    end
  end

  describe 'Filter users' do
    
    before :all do
      User.destroy_all
      user1 = FactoryBot.create(:user, email: "Jack@Ibarra.com", phone_number: "1234", full_name: "Jack Ibarra", password: "123")
      user2 = FactoryBot.create(:user, email: "Steven@Marquez.com", phone_number: "5678", full_name: "Steven Marquez", password: "456")
      user3 = FactoryBot.create(:user, email: "Jose@Joaquin.com", phone_number: "9012", full_name: "Jose Joaquin", password: "789", metadata: "metadata")
    end
    
    describe 'by email' do
      it 'returns the users based on the filter' do
        get '/api/users?email=Jack@Ibarra.com'
        users_req = JSON.parse(response.body)["users"]
        
        #Gets the required data for each user
        expect(users_req.first["email"]).to eq("Jack@Ibarra.com")
      end    
    end

    describe 'by full_name' do
      it 'returns the users based on the filter' do
        get '/api/users?full_name=Steven Marquez'
        users_req = JSON.parse(response.body)["users"]
        
        expect(users_req.first["email"]).to eq("Steven@Marquez.com")
      end    
    end

    describe 'by metadata' do
      it 'returns the users based on the filter' do
        get '/api/users?metadata=metadata'
        users_req = JSON.parse(response.body)["users"]
        
        expect(users_req.first["email"]).to eq("Jose@Joaquin.com")
      end    
    end
  end
end