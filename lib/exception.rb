#!/usr/bin/env ruby
# 
# Plugin Exception
# Author L
#

module PluginExcetption
  Remind = Class.new(StandardError)
  Chargeable            = Remind.new 'Found, but this is a payment record.'
  Later                 = Remind.new 'In the queue, check it later'

  Debug = Class.new(StandardError)
  VerificationCodeError = Debug.new 'Verification code error.'
  InsufficientCredit    = Debug.new 'Insufficient credit, unable to query.'
  HTTPError             = Debug.new 'Service request failed.'
end
