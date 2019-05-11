# This Gem has not been updated and since the last update, the API signature for TextLocal has changed. Please fork andmaintain it yourself if you intend to use it
https://github.com/sajan45/textlocal-india/issues/1
# textlocal-india
Unofficial Ruby wrapper for **textlocal.in** API.

## Installation

Add:
`gem 'textlocal-india', :git => 'https://github.com/sajan45/textlocal-india'` 
or `gem 'textlocal-india'` to your `Gemfile`

or install from Rubygems:
Run `gem install textlocal-india`

## Usage

Configure the default settings

```
Textlocal.config do |c|
  c.sender = "MYAPP"
  c.username = "textlocal_username"
  c.api_hash = "textlocal_hash"
  c.test = false
end
```
In above configuration, set `c.test = true` if you want to use API in test mode. This will not send message, hence no deduction of credit.

Alternative to above configuration, you can just set environment variables for Textlocal username and hash and you are ready to go.

```
TEXTLOCAL_USER_NAME = "textlocal_username"
TEXTLOCAL_API_HASH  = "textlocal_api_hash"
```

Sending SMS:
```
sms = Textlocal.send_message(message, numbers, options)
 # Textlocal.send_message('hello world', '9853xxxxxx')
status = sms.response[:status]      # can be 'success' or 'failure'
```
or you can create message manually:
```
msg = Textlocal::Message.new
msg.message = "your order is received successfully"
msg.numbers = ["9853xxxxxx"]
msg.send!
```
`message` is a string type argument.
`numbers` argument can be `string`, `integer` or `array` of `strings` or `integers`

All of the below can be valid for numbers argument:
* '9853xxxxxx'
* 9853xxxxxx
* ['9853xxxxxx', '9856xxxxxx']
* ['8894xxxxxx', 7504xxxxxx]

Every individual **Number** should be at least 10 character long, containing all numeric character.
Below are valid individual numbers irrespective of string or integer:
* 9876543210
* 919876543210
* +919876543210

But numbers like *987654321* (less than 10 digit) or *98765abcde* (containing non numeric character) is not valid.

#### Options
The third optional argument for `send_message` method is a Hash object.
* **sender** : You can override sender by passing a `sender` option.
  `Textlocal.send_message('message', '9538xxxxxx', 'sender' => 'MYAPPS')`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sajan45/textlocal.

## TODO

* Support for bulk send
* Support for more options like schedule time
* Specs for features

## Credits

This gem was originally insipired from [txtlocal UK](https://github.com/epigenesys/txtlocal) gem.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

