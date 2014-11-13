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

describe Plangrade::Resources::Base do

  class DummyModel < Plangrade::Resources::Base
    attr_accessor_deffered :name, :email
  end

  class Plangrade::Client
    def update_dummy_model(id, opts={})
      put("/api/v1/dummy_models/#{id}", opts)
    end
  end

  before :all do
    Plangrade.configure do |conf|
      conf.access_token = 'TolNOFka9Uls2DxahNi78A'
    end
  end

  after :all do
    Plangrade.reset!
  end

  context 'new user object with id' do

    subject { DummyModel.new(:id => 42) }

    describe "#id" do
      it 'should be 42' do
        expect(subject.id).to eq 42
      end
    end

    describe "#id=" do
      it 'sets id' do
        subject.send(:"id=", 2)
        expect(subject.id).to eq 2
      end
    end

    describe "#new_record?" do
      it 'returns false' do
        expect(subject.new_record?).to eq false
      end
    end

    describe "#modified?" do

      context 'new model and no changes' do
        it 'returns false' do
          model =  DummyModel.new(:name => 'jim', :email => 'compliance@plangrade.com')
          expect(model.modified?).to eq false
        end
      end

      context 'new model and no changes' do
        it 'returns false' do
          model =  DummyModel.new(:name => 'mary', :email => 'support@plangrade.com')
          model.name = 'jim'
          model.email = 'compliance@plangrade.com'
          expect(model.modified?).to eq false
        end
      end

      context 'persisted model and no changes' do
        it 'returns true' do
          model =  DummyModel.new(:id => 12, :name => 'jim', :email => 'compliance@plangrade.com')
          expect(model.modified?).to eq false
        end
      end

      context 'persisted model and changes' do
        it 'returns true' do
          model =  DummyModel.new(:id => 42, :name => 'jim', :email => 'compliance@plangrade.com')
          model.name = 'smithy'
          expect(model.modified?).to eq true
        end
      end
    end

    describe "#changes" do
      it 'returns empty hash' do
        expect(subject.changes).to eq({})
      end
    end

    describe "#save" do
      it 'returns true' do
        stub_request(:put, "https://plangrade.com/api/v1/dummy_models/42").with(
          :body => {"name"=>"smithy"},
          :headers => {
            'Accept'       =>'application/json',
            'Authorization'=>'Bearer TolNOFka9Uls2DxahNi78A',
            'Content-Type' =>'application/x-www-form-urlencoded',
            'User-Agent'   =>"Plangrade Ruby Gem #{Plangrade::Ruby::VERSION}"})
        model = DummyModel.new(:id => 42, :name => 'jim', :email => 'compliance@plangrade.com')
        model.name = 'smithy'
        model.save
      end
    end

    describe "#base_name" do
      it 'returns true' do
        expect(subject.base_name).to eq 'dummy_model'
      end
    end

    describe "setters" do
      it 'should update modified attributes hash' do
        subject
      end
    end

    describe "#save" do

      context 'unmodified model' do
        it 'does nothing' do
          expect(subject.save).to eq subject
        end
      end

      context 'modified model' do
        subject { DummyModel.new(:id => 42, :name => 'john', :email => 'compliance@plangrade.com') }

        it 'should update model' do
          api_handler = double("ApiHandler")
          expect(api_handler).to receive(:update_dummy_model).with(42, hash_including(
            :name =>'john',
            :email => 'support@plangrade.com')
          ).and_return(double('Response', :success? => true, :created? => true, :body => {:id => 2}))

          allow(subject).to receive_message_chain(:api_handler).and_return(api_handler)
          subject.name = 'john'
          subject.email = 'support@plangrade.com'
          subject.save
        end
      end

      context 'unmodified new model' do
        subject { DummyModel.new(:name => 'jim', :email => 'compliance@plangrade.com') }

        it 'should do nothing' do
          api_handler = double("ApiHandler")
          expect(api_handler).to receive(:create_dummy_model).with(
            hash_including(:name =>'jim', :email => 'compliance@plangrade.com')
          ).and_return(double('Response', :success? => true, :created? => true, :body => {:id => '2'}))

          allow(subject).to receive_message_chain(:api_handler).and_return(api_handler)
          subject.save
        end
      end

      context 'modified new model' do
        subject { DummyModel.new(:name => 'jim', :email => 'compliance@plangrade.com') }

        it 'should create model' do
          api_handler = double("ApiHandler")
          expect(api_handler).to receive(:create_dummy_model).with({
            :name =>'john',
            :email => 'compliance@plangrade.com'
          }).and_return(double('Response', :success? => true, :created? => true, :body => {:id => 2}))

          allow(subject).to receive_message_chain(:api_handler).and_return(api_handler)
          subject.name = 'john'
          subject.save
        end
      end
    end
  end
end