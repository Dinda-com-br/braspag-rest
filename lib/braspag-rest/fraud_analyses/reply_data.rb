module BraspagRest
  module FraudAnalyses
    class ReplyData < Hashie::IUTrash
      property :address_info_code, from: 'AddressInfoCode'
      property :factor_code, from: 'FactorCode'
      property :score, from: 'Score'
      property :bin_country, from: 'BinCountry'
      property :card_issuer, from: 'CardIssuer'
      property :card_scheme, from: 'CardScheme'
      property :host_severity, from: 'HostSeverity'
      property :internet_info_code, from: 'InternetInfoCode'
      property :ip_routing_method, from: 'IpRoutingMethod'
      property :score_model_used, from: 'ScoreModelUsed'
      property :case_priority, from: 'CasePriority'
    end
  end
end
