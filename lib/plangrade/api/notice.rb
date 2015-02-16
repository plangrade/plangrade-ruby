module Plangrade
  module Api
  	module Notice

      def all_notices(company_id)
        get("/api/v1/notices?company_id=#{company_id}")
      end
    end
  end
end