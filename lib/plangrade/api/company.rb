module Plangrade
  module Api
  	module Company
  	  def create_company(opts = {})
        post('/api/v1/companies', opts)
      end

      def update_company(id, opts={})
        put("/api/v1/companies/#{id}", opts).body[:company]
      end

      def delete_company(id)
        delete("/api/v1/companies/#{id}", opts)
      end

      def get_company(id)
        get("/api/v1/companies/#{id}").body[:company]
      end

      def all_companies(opts={})
        get("/api/v1/companies", opts).body[:companies]
      end
    end
  end
end