require 'spec_helper'

RSpec.describe ActiveETL::Steps::Parsers::Csv do

  first_row = [1, 'Nazar', 12]
  last_row = [2, 'Alpha', 45.6]
  headers = [:id, :name, :number]
  csv_size = 2

  csv_data = "#{SpecUtilities.to_csv(headers)}\n#{SpecUtilities.to_csv(first_row)}\n#{SpecUtilities.to_csv(last_row)}"

  describe 'process' do

    let :step do |i|
      result = ActiveETL::Result.new(i.metadata[:data], ActiveETL::Result::TYPE_BINARY)
      step_options = (i.metadata[:options] || {})
      step = ActiveETL::Steps::Parsers::Csv.new('Sales CSV File', step_options, result)
      step.process
    end

    it 'parse headers and data correctly', options: {headers: true}, data: csv_data do
      expect(step.result.type).to be ActiveETL::Result::TYPE_TABLE
      expect(step.result.data).to be_a(CSV::Table)

      expect(step.result.data.size).to eq csv_size
      expect(step.result.meta[:headers]).to eq headers
      expect(step.result.data[0].values_at).to eq first_row
      expect(step.result.data[step.result.data.size - 1].values_at).to eq last_row
    end

    it 'parse headers and data specifying limited columns', options: {headers: true, columns: headers.slice(0, 5)}, data: csv_data do
      expect(step.result.type).to be ActiveETL::Result::TYPE_TABLE
      expect(step.result.data).to be_a(CSV::Table)

      expect(step.result.data.size).to eq csv_size
      expect(step.result.meta[:headers]).to eq headers.slice(0, 5)
      expect(step.result.data[0].values_at).to eq first_row.slice(0, 5)
      expect(step.result.data[step.result.data.size - 1].values_at).to eq last_row.slice(0, 5)
    end

    it 'parse and consider header as data row if header turned off', options: {headers: headers.map {|h| "#{h}_custom".to_sym}}, data: csv_data do
      expect(step.result.type).to be ActiveETL::Result::TYPE_TABLE
      expect(step.result.data).to be_a(CSV::Table)

      expect(step.result.data.size).to eq csv_size + 1
      expect(step.result.meta[:headers]).to eq headers.map {|h| "#{h}_custom".to_sym}
      expect(step.result.data[0].values_at).to eq headers.map {|k| k.to_s}
      expect(step.result.data[step.result.data.size - 1].values_at).to eq last_row
    end
  end
end