module Plangrade
  module Api
  	module Participant
  	  def create_participant(opts = {})
        post('/api/v1/participants', opts)
      end

      def update_participant(id, opts={})
        put("/api/v1/participants/#{id}", opts)
      end

      def delete_participant(id)
        delete("/api/v1/participants/#{id}", opts)
      end

      def get_participant(id)
        get("/api/v1/participants/#{id}")
      end

      def all_participants(opts={})
        get("/api/v1/participants", opts)
      end
    end
  end
end