module Plangrade
  module Api
  	module User
  	  def create_user(opts = {})
        post('/api/v1/users', opts)
      end

      def update_user(id, opts={})
        put("/api/v1/users/#{id}", opts).body[:user]
      end

      def delete_user(id)
        delete("/api/v1/users/#{id}", opts)
      end

      def current_user
      	get('/api/v1/me').body
      end
    end
  end
end