module Plangrade
  module Api
  	module User
  	  def create_user(opts = {})
        post('/api/v1/users', opts)
      end

      def update_user(id, opts={})
        put("/api/v1/users/#{id}", opts)
      end

      def delete_user(id)
        delete("/api/v1/users/#{id}", opts)
      end

      def current_user
      	get('/api/v1/me')
      end
    end
  end
end