module Plangrade
  module Api
  	module Activity

      def all_activities(company_id)
        get("/api/v1/activities?company_id=#{company_id}")
      end
    end
  end
end