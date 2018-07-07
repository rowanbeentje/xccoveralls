require 'spec_helper'

describe Xccoveralls::Manager do # rubocop:disable Metrics/BlockLength
  before(:each) do
    allow(Coveralls::API).to receive(:post_json)
    allow(instance.xccov).to receive(:json).and_return json
  end
  let(:options) do
    { repo_token: 'asdf' }
  end
  let(:json) do
    {
      source_files: [
        { name: 'Dummy.swift' }
      ]
    }
  end
  let(:instance) { described_class.new(options) }
  subject { instance }
  describe 'initialize' do
    its(:repo_token) { is_expected.to eq 'asdf' }
    its(:xccov) { is_expected.not_to be_nil }
  end

  describe 'run!' do
    before(:all) do
      @org_repo_token = ENV['COVERALLS_REPO_TOKEN']
      ENV['COVERALLS_REPO_TOKEN'] = 'foo'
    end
    after(:all) do
      ENV['COVERALLS_REPO_TOKEN'] = @org_repo_token
    end
    subject { -> { instance.run! } }
    it { is_expected.not_to raise_error }
    it do
      is_expected.to change {
        (instance.coveralls_configuration || {})[:repo_token]
      }.from(nil).to('asdf')
    end
  end
end
