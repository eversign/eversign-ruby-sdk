# EversignClient

Ruby SDK for eversign [API](https://eversign.com/api/documentation)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eversign_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eversign_client

## Usage

		client = EversignClient::Client.new(<YOUR_API_KEY>)

### List businesses
Using the `list_businesses` function all businesses on the eversign account will be fetched and listed along with their Business IDs.


		businesses = client.list_businesses
		p businesses[0]


### List Documents
Using the `list_document` function all documents on the eversign account associated with given business id and type will be fetched and listed.

		documents = client.list_documents(<BUSINESS_ID>,<TYPE>)
		p documents

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/workatbest/eversign_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

