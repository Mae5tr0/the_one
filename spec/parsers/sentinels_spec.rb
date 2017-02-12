require_relative '../../lib/uploader/parsers/sentinels_parser'

RSpec.describe Uploader::SentinelsParser, type: :parser do

  let(:subject) { described_class.new(read_zip('sentinels')).parse }

  it 'correct parse routes from files' do
    is_expected.to contain_exactly(
      Uploader::Route.new('sentinels', 'alpha', 'gamma', '2030-12-31T13:00:01', '2030-12-31T13:00:03'),
      Uploader::Route.new('sentinels', 'delta', 'gamma', '2030-12-31T13:00:02', '2030-12-31T13:00:04')
    )
  end

  it 'filter route with 1 point' do
    is_expected.not_to include(
      Uploader::Route.new('sentinels', 'zeta', 'zeta', '2030-12-31T13:00:02', '2030-12-31T13:00:02')
    )
  end
end