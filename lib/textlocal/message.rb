require 'net/https'
require 'uri'
require 'json'
require 'cgi'

module Textlocal
  class Message

    attr_accessor :message
    attr_accessor :numbers
    attr_accessor :sender

    attr_accessor :response

    SMS_ENDPOINT = URI.parse("https://api.textlocal.in/send/?")

    def initialize(message=nil, numbers=nil, options=nil)
      self.message = message if message
      self.numbers = numbers if numbers
      self.options = options if options
    end

    def message=(message)
      @message = CGI.escape(message)
    end

    def numbers
      @numbers ||= []
    end

    def numbers=(numbers)
      @numbers = []
      if numbers.is_a?Array
        numbers.map!(&:to_s)
      else
        numbers = numbers.to_s.split(',')
      end
      numbers.each do |num|
        add_recipient(num)
      end
    end

    def add_recipient(number)
      number = number.gsub(/\s/, '')
      number = case number
        when /^91\d{10}$/
          number
        when /^(?:\+91)(\d{10})$/
          "91#{$1}"
        when /^(\d{10})$/
          "91#{$1}"
        else
          return
      end
      @numbers << number
    end

    def sender
      self.sender = Textlocal.config.sender unless @sender
      @sender
    end

    def sender=(sender)
      @sender = sender.strip.gsub(/[^\w]/, '').to_s[0, 11] if sender
      if @sender && @sender.length < 6
        @sender = nil
      end
    end

    def options=(options)
      self.sender = options[:sender] if options.has_key?(:sender)
    end

    def response=(response)
      unless response.body.empty?
        @response = {}
        data = JSON.parse(response.body)
        data.each_pair do |k, v|
          key = k.gsub(/\B[A-Z]+/, '_\0').downcase.to_sym
          @response[key] = v
        end
      end
    end

    def send!
      http = Net::HTTP.new(SMS_ENDPOINT.host, SMS_ENDPOINT.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new(SMS_ENDPOINT.path)
      params = {'username'=> Textlocal.config.username,
                'hash' => Textlocal.config.api_hash,
                'numbers' => numbers.join(','),
                'message' => self.message,
                'test'    => Textlocal.config.testing? ? true : false
               }
      params['sender'] = sender if sender
      req.set_form_data(params)
      result = http.start { |http| http.request(req) }
      self.response = result
    end
  end
end