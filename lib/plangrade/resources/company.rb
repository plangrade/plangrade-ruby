module Plangrade
  module Resources
    class Company < Plangrade::Resources::Base

      attr_accessor_deffered :name, :ein, :grade

      def self.create(ein, name)
        result = api_handler.create_company(:ein => ein, :name => name)
        return nil unless result.created?
        id = result.headers[:location].split('/').last.to_i
        new(:id => id)
      end

      def self.get(id)
        result = api_handler.get_company(id)
        new(result.body)
      end

      def self.all(*opts)
        if opts && opts != nil && opts != {}
          api_handler.all_companies(opts)
        else
          api_handler.all_companies
        end
      end

      def update!(params)
        api_handler.update_company(@id, params)
      end
    end
  end
end