# Not actively maintained

As of June 10th, 2021, Ruby SDK for eversign is no longer actively supported. The reason for this is the lack of community interest in this specific SDK.

Important notes:
- New community-contributed fixes will be merged and distributed if tests are green.
- New community-contributed features will be merged and distributed if they include test coverage.
- On April 6th, 2021, the gem hosted on rubygems.org as been renamed from `eversign` to `eversign-sdk`. Please make sure you switch to the new gem eversign-SDK to get the latest updates and improve visibility on how much this gem is in use.
- If you are starting with new project/integration with eversign, consider other integration options that we are providing ([PHP SDK](https://github.com/eversign/eversign-php-sdk), [Python SDK](https://github.com/eversign/eversign-python-sdk), [eversign public API](https://eversign.com/api/documentation)).

# Eversign Ruby SDK

Ruby SDK for eversign [API](https://eversign.com/api/documentation)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eversign-sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eversign-sdk

## Configuration

		Eversign.configure do |c|
		  c.api_base = '<YOUR_BASE_API>|https://api.eversign.com/api'
		  c.access_key = '<YOUR_API_KEY>'
		  c.business_id = <YOUR_BUISINESS_ID>
		end

OR directly set on client if needed

		client.business_id = <YOUR_BUISINESS_ID>


## Usage

		client = Eversign::Client.new

### Get All businesses
Using the `gwt_businesses` function all businesses on the eversign account will be fetched and listed along with their Business IDs.


		businesses = client.get_businesses()
		p businesses[0]


### Get Documents
Using the following functions required documents on the eversign account associated with given business id will be fetched and listed.

#### All

		documents = client.get_all_documents()
		p documents

#### Completed

		documents = client.get_completed_documents()
		p documents

#### Draft

		documents = client.get_draft_documents()
		p documents

#### Cancelled

		documents = client.get_cancelled_documents()
		p documents

#### Action Required

		documents = client.get_action_required_documents()
		p documents

#### Waiting for Others

		documents = client.get_waiting_for_others_documents()
		p documents


### Get Templates
Using the following functions required templates on the eversign account associated with given business id will be fetched and listed.

#### All

		templates = client.get_templates
		p templates

#### Archieved

		templates = client.get_archived_templates()
		p templates

#### Draft

		templates = client.get_draft_templates()
		p templates

### Get Document
Using the `get_document` function specific document on the eversign account associated with given business id and document hash will be fetched and listed.

		document = client.get_document(<DOCUMENT_HASH>)
		p document


### [Create Document](/examples/create_document.rb)

### Upload file
		
		file = client.upload_file(<FILE_PATH>)
		p file.file_id

### Download raw file
		
		client.download_raw_document_to_path(<DOCUMENT_HASH>,<FILE_PATH>)

### Download final file
		
		client.download_final_document_to_path(<DOCUMENT_HASH>,<FILE_PATH>)

### Send Email Reminder

		send_reminder_for_document(<DOCUMENT_HASH>,<SIGNER_ID>)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

- Run tests dockerized:

1. `docker build -t ruby-sdk .`
2. `docker run -it -v $(pwd)/spec:/app/spec ruby-sdk`

- In order to run examples from /examples folder

1. create .env file based on .env-sample
2. run example like `ruby ./examples/create_document_from_template.rb`

## Testing

		bundle exec COVERAGE=1 rspec
		
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eversign/eversign-ruby-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
