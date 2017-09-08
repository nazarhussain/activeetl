require 'spec_helper'

RSpec.describe ActiveETL::Steps::Inputs::Http do

  describe 'process' do

    let :step do |i|
      step_options = (i.metadata[:options] || {}).merge({url: 'https://gist.githubusercontent.com/nazarhussain/b4755f25da8bd4ed8042019b8ff1be8f/raw/61a65e71bb4413f30687ed7c53216dccde6ecbd9/sample.json'})
      step = ActiveETL::Steps::Inputs::Http.new('Fetch on HTTP', step_options)
      step.process
    end

    context 'GET' do
      it 'fetch and receive response body', options: {method: 'GET'} do
        expect(step.result.type).to be ActiveETL::Result::TYPE_BINARY
        expect(step.result.data).to be_a String

        expect(JSON.parse(step.result.data).to_h.keys).to eq %w'name description main authors keywords'
        expect(step.result.meta[:status]).to eq 200
        expect(step.result.meta[:headers]).to be_a Hash
        expect(step.result.meta[:headers].keys).not_to be_empty
      end
    end
  end
end