require_relative '../../lib/uploader/parsers/sniffers_parser'

RSpec.describe Uploader::SniffersParser, type: :parser do

  let(:subject) { described_class.new(read_zip('sniffers')).parse }

  it 'correct parse routes from files' do
    is_expected.to contain_exactly(
      Uploader::Route.new('sentinels', 'alpha', 'gamma', '2030-12-31T13:00:01', '2030-12-31T13:00:03'),
      Uploader::Route.new('sentinels', 'delta', 'gamma', '2030-12-31T13:00:02', '2030-12-31T13:00:04')
    )
  end
end