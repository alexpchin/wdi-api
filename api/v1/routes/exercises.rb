module V1
  module Routes
    class Exercises < Sinatra::Application
      before do
        content_type 'application/json', charset: 'utf-8'
      end

      get "/exercises" do 
      end

      get "/exercises/:name" do 
      end
    end
  end
end