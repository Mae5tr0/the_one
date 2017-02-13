require_relative '../../lib/uploader/parsers/loopholes_parser'

RSpec.describe Uploader::LoopholesParser, type: :parser do
  let(:subject) { described_class.new(read_zip('loopholes')).parse }

  it 'correct parse routes from files' do
    is_expected.to contain_exactly(
      Uploader::Route.new('loopholes', 'gamma', 'lambda', '2030-12-31T13:00:04', '2030-12-31T13:00:06'),
      Uploader::Route.new('loopholes', 'beta', 'lambda', '2030-12-31T13:00:05', '2030-12-31T13:00:07')
    )
  end
end
