module Plangrade
  module Resources
    class Company < Plangrade::Resources::Base
      attr_reader :id, :name, :ein, :grade

      def initialize(attributes)
        @id = attributes["id"]
        @name = attributes["name"]
        @ein = attributes["ein"]
        @grade = attributes["grade"]
      end

      def self.create(ein, name)
        result = api_handler.create_company(:ein => ein, :name => name)
        return nil unless result.created?
        id = result.headers[:location].split('/').last.to_i
        new(:id => id)
      end

      def self.get(id)
        result = api_handler.get_company(id)
        return nil unless result.success?
        new(result.body[:company])
      end

      def self.all(*opts)
        if opts && opts != nil && opts != {}
          result = api_handler.all_companies(opts)
        else
          result = api_handler.all_companies
        end
        companies = JSON.parse(result[:companies])
        companies.map { |attributes| new(attributes) }
      end

      def update!(params)
        api_handler.update_company(@id, params)
      end
    end
  end
end