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

require File.expand_path('../spec_helper', __FILE__)
require 'plangrade/http_adapter'

describe Plangrade::HttpAdapter do

  before :all do
    Plangrade.configure do |conf|
      conf.access_token = 'TolNOFka9Uls2DxahNi78A'
    end
  end

  context "initialization" do 
    context "with user options" do

      before do
        @options = {
          :verify_ssl    => false,
          :max_redirects => 2
        }
      end

      subject { @conn = Plangrade::HttpAdapter.new('https://www.example.com', @options) }

      it "overrides default options" do
        expect(subject.instance_variable_get(:"@connection_options")).to eq @options
      end
    end

    context "with invalid url" do
      it "should raise argument error" do
        expect { Plangrade::HttpAdapter.new('www.example.com') }.to raise_error(ArgumentError)
      end
    end
  end

  context "with no options" do

    subject { @conn = Plangrade::HttpAdapter.new('https://plangrade.com') }

    describe "#scheme" do
      it "returns the http scheme" do
        expect(subject.scheme).to eq 'https'
      end
    end

    describe "#host" do
      it "returns the host server" do
        expect(subject.host).to eq 'plangrade.com'
      end
    end

    describe "site_url" do
      it "returns site_url" do
        expect(subject.site_url).to eq 'https://plangrade.com'
      end
    end

    describe "site_url=" do
      it "sets new site_url on client" do
        subject.site_url = 'https://github.com/topherreynoso'
        expect(subject.site_url).to eq 'https://github.com/topherreynoso'
      end
    end

    describe "connection_options=" do
      it "sets new connection_options" do
        subject.connection_options = { :max_redirects => 6 }
        expect(subject.connection_options).to eq({ :max_redirects => 6 })
      end

      it "should raise error" do
        expect { subject.connection_options = '' }.to raise_error(ArgumentError)
      end
    end

    describe "#absolute_url" do
      context "with no parameters" do
        it "returns a uri without path" do
          expect(subject.send(:absolute_url)).to eq "https://plangrade.com"
        end
      end

      context "with parameters" do
        it "returns a uri with path" do
          expect(subject.send(:absolute_url, '/oauth/authorize')).to eq "https://plangrade.com/oauth/authorize"
        end
      end
    end
  end
end