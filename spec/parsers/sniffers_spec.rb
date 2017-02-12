require_relative '../../lib/uploader/parsers/sniffers_parser'

RSpec.describe Uploader::SniffersParser, type: :parser do

  let(:subject) { described_class.new(read_zip('sniffers')).parse }

  it 'correct parse routes from files' do
    is_expected.to contain_exactly(
      Uploader::Route.new('sniffers', 'lambda', 'omega', '2030-12-31T13:00:06', '2030-12-31T13:00:09'),
      Uploader::Route.new('sniffers', 'lambda', 'omega', '2030-12-31T13:00:07', '2030-12-31T13:00:09'),
    )
  end
end