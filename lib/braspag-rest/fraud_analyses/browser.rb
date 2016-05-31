module BraspagRest
  module FraudAnalyses
    class Browser < Hashie::IUTrash
      property :cookies_accepted, from: 'CookiesAccepted'
      property :email, from: 'Email'
      property :host_name, from: 'HostName'
      property :ip_address, from: 'IpAddress'
      property :type, from: 'Type'
    end
  end
end
