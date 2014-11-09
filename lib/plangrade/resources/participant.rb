module Plangrade
  module Resources
    class Participants < Plangrade::Resources::Base

      def self.create(company_id, first_name, last_name, street1, street2, city, state, zip, dob, ssn, email, phone, employee_id)

        result = api_handler.create_participant(:company_id => company_id, :first_name => first_name, :last_name => last_name,
                                                :street1 => street1, :street2 => street2, :city => city, :state => state,
                                                :zip => zip, :dob => dob, :ssn => ssn, :email => email, :phone => phone,
                                                :employee_id => employee_id)
        return nil unless result.created?
        id = result.headers[:location].split('/').last.to_i
        new(:id => id)
      end

      attr_accessor_deffered :id, :company_id, :employee_id, :first_name, :last_name, :street1, :street2, :city, :state, :zip,
      :dob, :ssn, :email, :phone

      def update!(params)
        api_handler.update_participant(@id, params)
      end
    end
  end
end