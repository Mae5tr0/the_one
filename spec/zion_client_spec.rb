require_relative '../lib/uploader/zion_client'

RSpec.describe Uploader::ZionClient do
  let(:source) { 'sentinels' }
  let(:passphrase) { 'secret_passphrase' }
  let(:subject) { described_class.new(passphrase) }

  it 'download' do
    stub_request(:get, "http://challenge.distribusion.com/the_one/routes?passphrase=#{passphrase}&source=#{source}")
      .to_return(
        body: File.read('spec/support/sentinels.zip'),
        status: 200,
        headers: { 'Content-Type' => 'application/zip' }
      )

    parsed_response = subject.download(source)
    expect(parsed_response.length).to eq(1)
    expect(parsed_response.first.name).to eq('routes.csv')
    expect(parsed_response.first.content).not_to be_nil
  end

  it 'upload' do
    routes = [
      Uploader::Route.new('loopholes', 'gamma', 'theta', '2030-12-31T13:00:04', '2030-12-31T13:00:05')
    ]

    stub_request(:post, 'http://challenge.distribusion.com/the_one/routes')
      .with(body: routes.first.to_h.merge(passphrase: passphrase))

    subject.upload(routes)
  end
end
