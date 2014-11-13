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
        participant = result.body["participant"]
        new(participant)
      end

      def self.all(company_id, *opts)
        opts ||= {}
        opts[:company_id] = company_id
        api_handler.all_participants(opts)
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