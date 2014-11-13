module Plangrade
  module Resources
    class Participant < Plangrade::Resources::Base

      def self.create(company_id, first_name, last_name, street1, street2, city, state, zip, dob, ssn, email, phone, employee_id)
        result = api_handler.create_participant(:company_id => company_id, :first_name => first_name, :last_name => last_name, :street1 => street1, :street2 => street2, :city => city, :state => state,
                                                :zip => zip, :dob => dob, :ssn => ssn, :email => email, :phone => phone, :employee_id => employee_id)
        return nil unless result.created?
        id = result.headers[:location].split('/').last.to_i
        new(:id => id)
      end

      attr_accessor_deffered :company_id, :employee_id, :first_name, :last_name, :street1, :street2, :city, :state, :zip, :dob, :email, :phone

      def self.get(id)
        result = api_handler.get_participant(id)
        return nil unless result.success?
        new(result.body[:participant])
      end

      def self.all(company_id, opts={})
        opts ||= {}
        opts[:company_id] = company_id
        result = api_handler.all_participants(opts)
        return nil unless result.success?
        new(result.body[:participants])
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