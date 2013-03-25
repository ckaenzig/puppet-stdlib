module Puppet::Parser::Functions

  newfunction(:validate_ip_address, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are valid IPv4 or IPv6 addresses.
    Abort catalog compilation if any value fails this check.

    The following values will pass:

        $my_address = '192.168.52.1' 
        validate_address($my_address)

    The following values will fail, causing compilation to abort:

        validate_ip_address('192.168.3.7.8')
        validate_ip_address('192.168.1')
        validate_ip_address('some string')

    ENDHEREDOC

    unless args.length > 0 then
      raise Puppet::ParseError, ("validate_ip_address(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    require 'ipaddr'

    args.each do |arg|

      begin
        ip = IPAddr.new(arg)
      rescue ArgumentError
        is_valid = false
      else
        if ip.ipv4? or ip.ipv6? then
          is_valid = true
        else
          is_valid = false
        end
      end

      unless is_valid
        raise Puppet::ParseError, ("#{arg} is not a valid IP address")
      end
    end

  end

end
