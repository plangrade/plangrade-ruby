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

describe Plangrade::Api::User do

  before :all do
    @client = Plangrade::Client.new(
      :site_url     => 'https://plangrade.com',
      :client_id     => 'PRbTcg9qjgKsp4jjpm1pw',
      :client_secret => 'Xn7kp7Ly0TCY4GtZWkmSsqGEPg10DmMADyjWkf2U',
      :access_token  => 'TolNOFka9Uls2DxahNi78A'
    )
  end

  subject { @client }

  describe 'create_user' do
    it 'makes an http request' do
      params = {:name => 'topher', :email => 'compliance@plangrade.com'}
      expect(@client).to receive(:post).with('/api/v1/users', params)
      @client.create_user(params)
    end
  end

  describe 'update_user' do
    it 'makes an http request' do
      params = {:name => 'christopher'}
      expect(@client).to receive(:put).with('/api/v1/users/1', params)
      @client.update_user(1, params)
    end
  end

  describe 'delete_user' do
    it 'makes an http request' do
      expect(@client).to receive(:delete).with('/api/v1/users/1')
      @client.delete_user(1)
    end
  end

  describe 'current_user' do
    it 'makes an http request' do
      expect(@client).to receive(:get).with('/api/v1/me')
      @client.current_user
    end
  end
end