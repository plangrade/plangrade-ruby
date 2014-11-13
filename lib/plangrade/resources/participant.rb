module Plangrade
  module Resources
    class Participant < Plangrade::Resources::Base

      attr_accessor_deffered :company_id, :employee_id, :first_name, :last_name, :street1, :street2, :city, :state, :zip, :dob, :email, :phone

      def self.create(company_id, first_name, last_name, street1, street2, city, state, zip, dob, email, phone, employee_id, opts={})
        if opts && !opts.nil? && opts != {}
          result = api_handler.create_participant(:company_id => company_id, :first_name => first_name, :last_name => last_name, :street1 => street1, :street2 => street2, :city => city, :state => state,
                                                  :zip => zip, :dob => dob, :ssn => opts[:ssn], :email => email, :phone => phone, :employee_id => employee_id)
        else
          result = api_handler.create_participant(:company_id => company_id, :first_name => first_name, :last_name => last_name, :street1 => street1, :street2 => street2, :city => city, :state => state,
                                                  :zip => zip, :dob => dob, :email => email, :phone => phone, :employee_id => employee_id)
        end
        return nil unless result.created?
        id = result.headers[:location].split('/').last.to_i
        new(:id => id)
      end

      def self.get(id)
        result = api_handler.get_participant(id)
        parsed_result = JSON.parse(result.body)
        new(:id => parsed_result["id"], :company_id => parsed_result["company_id"], :employee_id => parsed_result["employee_id"], :first_name => parsed_result["first_name"], 
            :last_name => parsed_result["last_name"], :street1 => parsed_result["street1"], :street2 => parsed_result["street2"], :city => parsed_result["city"], :state => parsed_result["state"],
            :zip => parsed_result["zip"], :dob => parsed_result["dob"], :email => parsed_result["email"], :phone => parsed_result["phone"])
      end

      def self.all(company_id)
        result = api_handler.all_participants(company_id)
        parsed_result = JSON.parse(result.body)
        participants ||= begin
          parsed_result.map do |participant|
            new(:id => participant["id"], :company_id => participant["company_id"], :employee_id => participant["employee_id"], :first_name => participant["first_name"], 
                :last_name => participant["last_name"], :street1 => participant["street1"], :street2 => participant["street2"], :city => participant["city"], :state => participant["state"],
                :zip => participant["zip"], :dob => participant["dob"], :email => participant["email"], :phone => participant["phone"])
          end
        end
        participants
      end

      def archive!
        result = api_handler.archive_participant(@id)
        return nil unless result.success?
        new(result.body)
      end

      def update!(params)
        api_handler.update_participant(@id, params)
      end
    end
  end
end