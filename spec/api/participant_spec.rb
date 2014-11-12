# -*- encoding: utf-8 -*-

# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY
# IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT.
#
# See the Apache Version 2.0 License for specific language governing
# permissions and limitations under the License.

require File.expand_path('../../spec_helper', __FILE__)
require 'ostruct'

describe Plangrade::Api::Participant do

  before :all do
    @client = Plangrade::Client.new(
      :site_url     => 'https://plangrade.com',
      :client_id     => 'PRbTcg9qjgKsp4jjpm1pw',
      :client_secret => 'Xn7kp7Ly0TCY4GtZWkmSsqGEPg10DmMADyjWkf2U',
      :access_token  => 'TolNOFka9Uls2DxahNi78A'
    )
  end

  subject { @client }

  describe 'create_participant' do
    it 'makes an http request' do
      params = {:company_id => 1, :employee_id => 0, :ssn => '1234', :first_name => 'Joe', :last_name => 'Compliance', :street1 => '1234 Fake St.', :city => 'Fake', :state => 'UT', :zip => '84606', :dob => '1983-12-31', :email => 'compliance@plangrade.com', :phone => 1234567890}
      @client.should_receive(:post).with('/api/v1/participants', params)
      @client.create_participant(params)
    end
  end

  describe 'update_participant' do
    it 'makes an http request' do
      params = {:employee_id => 0, :first_name => 'John'}
      @client.should_receive(:put).with('/api/v1/participants/1', params)
      @client.update_participant(1, params)
    end
  end

  describe 'archive_participant' do
    it 'makes an http request' do
      @client.should_receive(:get).with('/api/v1/participants/archive?participant_id=1')
      @client.archive_participant(1)
    end
  end

  describe 'delete_participant' do
    it 'makes an http request' do
      @client.should_receive(:delete).with('/api/v1/participants/1')
      @client.delete_participant(1)
    end
  end

  describe 'get_participant' do
    it 'makes an http request' do
      @client.should_receive(:get).with('/api/v1/participants/1')
      @client.get_participant(1)
    end
  end

  describe 'all_participants' do
    it 'makes an http request' do
      @client.should_receive(:get).with('/api/v1/participants?company_id=1')
      @client.all_participants(:company_id => 1)
    end
  end
end