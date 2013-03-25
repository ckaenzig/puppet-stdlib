#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe Puppet::Parser::Functions.function(:validate_ip_address) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  describe 'when calling validate_ip_address from puppet' do

    it "should not compile when argument is a boolean" do
      Puppet[:code] = "validate_ip_address(true)"
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid IP address/)
    end

    it "should not compile when argument is text" do
      Puppet[:code] = "validate_ip_address('hello')"
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid IP address/)
    end

    it "should not compile when argument is a malformed address" do
      Puppet[:code] = "validate_ip_address('192.168.1.')"
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid IP address/)
    end

    it "should compile when multiple valid arguments are passed" do
      Puppet[:code] = "validate_ip_address('192.168.1.53', '255.255.255.0')"
      scope.compiler.compile
    end

    it "should not compile when an undef variable is passed" do
      Puppet[:code] = <<-'ENDofPUPPETcode'
        $foo = undef
        validate_ip_address($foo)
      ENDofPUPPETcode
      expect { scope.compiler.compile }.to raise_error(Puppet::ParseError, /is not a valid IP address/)
    end
  end
end
