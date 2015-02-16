module Plangrade
  module Resources
    class Activity < Plangrade::Resources::Base

      attr_accessor_deffered :name, :start_time

      def self.all(company_id)
        result = api_handler.all_activities(company_id)
        parsed_result = JSON.parse(result.body)
        activities ||= begin
          parsed_result.map do |activity|
            new(:id => activity["id"], :name => activity["name"], :start_time => activity["start_time"])
          end
        end
        activities
      end
    end
  end
end