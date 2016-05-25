module BraspagRest
  class FraudAnalysis < Hashie::IUTrash
    include Hashie::Extensions::Coercion

    STATUS_ACCEPTED = 1
    STATUS_REJECTED = 2

    property :sequence, from: 'Sequence'
    property :sequence_criteria, from: 'SequenceCriteria'
    property :finger_print_id, from: 'FingerPrintId'
    property :capture_on_low_risk, from: 'CaptureOnLowRisk'
    property :void_on_high_risk, from: 'VoidOnHighRisk'
    property :browser, from: 'Browser'
    property :cart, from: 'Cart'
    property :merchant_defined_fields, from: 'MerchantDefinedFields'

    property :shipping, from: 'Shipping'
    property :travel, from: 'Travel'

    property :status, from: 'Status'
    property :fraud_analysis_reason_code, from: 'FraudAnalysisReasonCode'

    # Response
    property :travel, from: 'Travel'
    property :shipping, from: 'Shipping'
    property :id, from: 'Id'
    property :reply_data, from: 'ReplyData'

    coerce_key :browser, BraspagRest::FraudAnalyses::Browser
    coerce_key :cart, BraspagRest::FraudAnalyses::Cart
    coerce_key :shipping, BraspagRest::FraudAnalyses::Shipping
    coerce_key :travel, BraspagRest::FraudAnalyses::Travel
    coerce_key :reply_data, BraspagRest::FraudAnalyses::ReplyData
    coerce_key :merchant_defined_fields, Array[BraspagRest::FraudAnalyses::MerchantDefinedFields]

    def accepted?
      status.to_i.eql?(STATUS_ACCEPTED)
    end

    def rejected?
      status.to_i.eql?(STATUS_REJECTED)
    end
  end
end
