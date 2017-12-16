# Eversign Ruby SDK

Ruby SDK for eversign [API](https://eversign.com/api/documentation)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eversign'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eversign

## Configuration

		Eversign.configure do |c|
		  c.api_base = '<YOUR_BASE_API>|https://api.eversign.com/api'
		  c.access_key = '<YOUR_API_KEY>'
		end

## Usage

		client = Eversign::Client.new

### Get All businesses
Using the `gwt_businesses` function all businesses on the eversign account will be fetched and listed along with their Business IDs.


		businesses = client.get_businesses
		p businesses[0]


### Get Documents
Using the following functions required documents on the eversign account associated with given business id will be fetched and listed.

#### All

		documents = client.get_all_ocuments(<BUSINESS_ID>)
		p documents

#### Completed

		documents = client.get_completed_documents(<BUSINESS_ID>)
		p documents

#### Drafts

		documents = client.get_drafts_documents(<BUSINESS_ID>)
		p documents

#### Cancelled

		documents = client.get_cancelled_documents(<BUSINESS_ID>)
		p documents

#### Action Required

		documents = client.get_action_required_documents(<BUSINESS_ID>)
		p documents

#### Waiting for Others

		documents = client.get_waiting_for_others_documents(<BUSINESS_ID>)
		p documents


### Get Templates
Using the following functions required templates on the eversign account associated with given business id will be fetched and listed.

#### All

		templates = client.get_templates(<BUSINESS_ID>)
		p templates

#### Archieved

		templates = client.get_archived_templates(<BUSINESS_ID>)
		p templates

#### Drafts

		templates = client.get_drafts_templates(<BUSINESS_ID>)
		p templates

### Get Document
Using the `get_document` function specific document on the eversign account associated with given business id and document hash will be fetched and listed.

		document = client.get_document(<BUSINESS_ID>,<DOCUMENT_HASH>)
		p document


### [Create Document](/examples/create_document.rb)

### Upload file
		
		file = client.upload_file(<BUSINESS_ID>,<FILE_PATH>)
		p file.file_id

### Download raw file
		
		client.download_raw_document_to_path(<BUSINESS_ID>,<DOCUMENT_HASH>,<FILE_PATH>)

### Download final file
		
		client.download_final_document_to_path(<BUSINESS_ID>,<DOCUMENT_HASH>,<FILE_PATH>)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/workatbest/eversign. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
