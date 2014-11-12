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

describe Plangrade::Resources::Company do

  before :all do
    Plangrade.configure do |conf|
      conf.access_token = 'TolNOFka9Uls2DxahNi78A'
    end
  end

  after :all do
    Plangrade.reset!
  end

  context 'class methods' do

    subject { Plangrade::Resources::Company }

    describe '#create' do
      it 'creates a new company' do
        stub_request(:post, "https://plangrade.com/api/v1/companies").with(
          :body    => { :name => "plangrade, llc", :ein => '123456789' },
          :headers => {
            'Accept'          => 'application/json',
            'Authorization'   => "Bearer #{Plangrade.access_token}",
            'Content-Type'    => 'application/x-www-form-urlencoded',
            'User-Agent'      => "Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"
          }
        ).to_return(
          :status => 201,
          :body => '',
          :headers => { 'Location' => 'https://plangrade.com/api/v1/companies/4'}
        )
        subject.create("123456789", "plangrade, llc")
      end
    end
  end

  context 'new company object with id' do

    before :each do
      Plangrade::Resources::Company.identity_map.purge!
    end

    subject { Plangrade::Resources::Company.new(:id => 1) }

    describe "#id" do
      it 'returns id' do
        expect(subject.id).to eq 1
      end
    end
  end

  context 'hydrated user object' do
    subject { Plangrade::Resources::Company.new(MultiJson.load(fixture('company.json'), :symbolize_keys => true)) }

    describe "#id" do
      it 'returns id' do
        expect(subject.id).to eq 4
      end
    end

    describe "#ein" do
      it 'returns ein' do
        stub_request(:get, "https://plangrade.com/api/v1/companies/4").
         with(:headers => {
          'Accept'=>'application/json',
          'Authorization'=>"Bearer #{Plangrade.access_token}",
          'User-Agent'=>"Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"
        }).to_return(
          :status => 200,
          :body => fixture('company.json'),
          :headers => {}
        )
        expect(subject.ein).to eq '123456789'
      end
    end

    describe "#delete" do
      it 'deletes company' do
        stub_request(:delete, "https://plangrade.com/api/v1/companies/4").
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

    describe '#update' do
      context 'with id as an integer' do
        it 'updates company' do
          stub_request(:put, "https://plangrade.com/api/v1/companies/4").with(
            :body    => { :name => 'plangrade, llc' },
            :headers => {
              'Accept'          => 'application/json',
              'Authorization'   => "Bearer #{Plangrade.access_token}",
              'Content-Type'    => 'application/x-www-form-urlencoded',
              'User-Agent'      => "Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"
            }
          ).to_return(
            :status => 200,
            :body => '',
            :headers => { 'Location' => 'https://plangrade.com/api/v1/companies/4'}
          )
          subject.update!(:name => 'plangrade, llc')
        end
      end
    end
  end
end