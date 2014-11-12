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

describe Plangrade::Resources::Participant do

  before :all do
    Plangrade.configure do |conf|
      conf.access_token = 'TolNOFka9Uls2DxahNi78A'
    end
  end

  after :all do
    Plangrade.reset!
  end

  context 'class methods' do

    subject { Plangrade::Resources::Participant }

    describe '#create' do
      it 'creates a new participant' do
        stub_request(:post, "https://plangrade.com/api/v1/participants").with(
          :body    => { :first_name => "Johnny", :last_name => "Compliance", :email => 'compliance@plangrade.com', :phone => "123456789", :employee_id => "0", :company_id => "1", :street1 => "1234 Fake St.", :street2 => "", :city => "Fake", :state => "UT", :zip => "12345", :dob => "1985-12-31", :ssn => "1234" },
          :headers => {
            'Accept'          => 'application/json',
            'Authorization'   => "Bearer #{Plangrade.access_token}",
            'Content-Type'    => 'application/x-www-form-urlencoded',
            'User-Agent'      => "Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"
          }
        ).to_return(
          :status => 201,
          :body => '',
          :headers => { 'Location' => 'https://plangrade.com/api/v1/participants/3'}
        )
        subject.create(1, "Johnny", "Compliance", "1234 Fake St.", "", "Fake", "UT", "12345", "1985-12-31", "1234", "compliance@plangrade.com", 123456789, 0)
      end
    end
  end

  context 'new participant object with id' do

    before :each do
      Plangrade::Resources::Participant.identity_map.purge!
    end

    subject { Plangrade::Resources::Participant.new(:id => 3) }

    describe "#id" do
      it 'returns id' do
        expect(subject.id).to eq 3
      end
    end
  end

  context 'hydrated participant object' do
    subject { Plangrade::Resources::Participant.new(MultiJson.load(fixture('participant.json'), :symbolize_keys => true)) }

    describe "#id" do
      it 'returns id' do
        expect(subject.id).to eq 3
      end
    end

    describe "#email" do
      it 'returns email address' do
        stub_request(:get, "https://plangrade.com/api/v1/participants/3").
         with(:headers => {
          'Accept'=>'application/json',
          'Authorization'=>"Bearer #{Plangrade.access_token}",
          'User-Agent'=>"Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"
        }).to_return(
          :status => 200,
          :body => fixture('participant.json'),
          :headers => {}
        )
        expect(subject.email).to eq 'compliance@plangrade.com'
      end
    end

    describe "#delete" do
      it 'deletes participant' do
        stub_request(:delete, "https://plangrade.com/api/v1/participants/3").
         with(:headers => {
          'Accept'=>'application/json',
          'Authorization'=>"Bearer #{Plangrade.access_token}",
          'User-Agent'=>"Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"
        }).to_return(
          :status => 200,
          :body => '',
          :headers => {}
        )
        subject.delete!
      end
    end

    describe "#archive" do
      it 'archive participant' do
        stub_request(:get, "https://plangrade.com/api/v1/participants/archive?participant_id=3").
         with(:headers => {
          'Accept'=>'application/json',
          'Authorization'=>"Bearer #{Plangrade.access_token}",
          'User-Agent'=>"Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"
        }).to_return(
          :status => 200,
          :body => '',
          :headers => {}
        )
        expect(subject.id).to eq 3
      end
    end

    describe '#update' do
      context 'with id as an integer' do
        it 'updates participant' do
          stub_request(:put, "https://plangrade.com/api/v1/participants/3").with(
            :body    => { :first_name => 'smithy' },
            :headers => {
              'Accept'          => 'application/json',
              'Authorization'   => "Bearer #{Plangrade.access_token}",
              'Content-Type'    => 'application/x-www-form-urlencoded',
              'User-Agent'      => "Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"
            }
          ).to_return(
            :status => 200,
            :body => '',
            :headers => { 'Location' => 'https://plangrade.com/api/v1/participants/3'}
          )
          subject.update!(:first_name => 'smithy')
        end
      end
    end
  end
end