module V1
  module Helpers
    module Guards
      def require_key
        return if params[:key]

        halt 401, { error: "Please provide your WDI API key" }.to_json
      end 
    end
  end
end