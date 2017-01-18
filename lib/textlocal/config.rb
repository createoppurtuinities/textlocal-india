module Textlocal
  class Config

    # this can be overridden on a per-message basis
    attr_accessor :sender

    # The username of the Textlocal account to use when accessing the API
    attr_accessor :username

    # The API hash of the Textlocal account to use when accessing the API
    attr_accessor :api_hash

    # Access the API in test mode
    attr_accessor :test

    def initialize
      @test = false
      @username = ENV['TEXTLOCAL_USER_NAME']
      @api_hash = ENV['TEXTLOCAL_API_HASH']
    end

    def testing?
      !!@test
    end

  end
end