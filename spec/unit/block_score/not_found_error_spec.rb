RSpec.describe BlockScore::NotFoundError, vcr: true do
  subject { BlockScore::Person.retrieve('abc123') }
  let(:message) do
    '(Type: invalid_request_error) ' \
    'Person with id abc123 could not be found (Status: 404)'
  end

  it_behaves_like 'an error'
end
