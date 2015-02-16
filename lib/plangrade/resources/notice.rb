module Plangrade
  module Resources
    class Notice < Plangrade::Resources::Base

      attr_accessor_deffered :name

      def self.all(company_id)
        result = api_handler.all_notices(company_id)
        parsed_result = JSON.parse(result.body)
        notices ||= begin
          parsed_result.map do |notice|
            new(:id => notice["id"], :name => notice["name"], :plan_name => notice["plan_name"], :link => notice["link"], :created_at => notice["created_at"])
          end
        end
        notices
      end
    end
  end
end