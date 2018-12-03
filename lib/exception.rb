#!/usr/bin/env ruby
# 
# Plugin Exception
# Author L
#

module PluginExcetption
  Remind = Class.new(StandardError)
  Chargeable            = Remind.new 'Found, but this is a payment record.'

  Debug = Class.new(StandardError)
  VerificationCodeError = Debug.new 'Verification code error.'
  InsufficientCredit    = Debug.new 'Insufficient credit, unable to query.'
  HTTPError             = Debug.new 'Service request failed.'
end
