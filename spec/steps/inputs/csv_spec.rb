require 'spec_helper'

RSpec.describe ActiveETL::Steps::Inputs::Csv do

  sample_file = File.join(__dir__, '../../../examples/data/sales_data.csv')
  headers = [:ordernumber, :quantityordered, :priceeach, :orderdate, :status, :productline, :productcode, :customername, :phone, :addressline1, :city, :state, :postalcode, :country, :territory, :contactlastname, :contactfirstname]
  first_row = [10107, 30, 95.7, '2/24/2003 0:00', 'Shipped', 'Motorcycles', 'S10_1678', 'Land of Toys Inc.', 2125557818, '897 Long Airport Avenue', 'NYC', 'NY', 10022, 'United States', 'NA', 'Yu', 'Kwai']
  last_row = [10414, 47, 65.52, '5/6/2005 0:00', 'On Hold', 'Ships', 'S72_3212', 'Gifts4AllAges.com', 6175559555, '8616 Spinnaker Dr.', 'Boston', 'MA', 51003, 'USA', 'NA', 'Yoshido', 'Juri']
  csv_size = 2823

  describe 'process' do

    let :step do |i|
      step_options = (i.metadata[:options] || {}).merge({path: sample_file})
      step = ActiveETL::Steps::Inputs::Csv.new('Sales CSV File',step_options)
      step.process
    end

    it 'parse headers and data correctly', options: {headers: true} do
      expect(step.result.type).to be ActiveETL::Result::TYPE_TABLE
      expect(step.result.data).to be_a(CSV::Table)

      expect(step.result.data.size).to eq csv_size
      expect(step.result.meta[:headers]).to eq headers
      expect(step.result.data[0].values_at).to eq first_row
      expect(step.result.data[step.result.data.size - 1].values_at).to eq last_row
    end

    it 'parse headers and data specifying limited columns', options: {headers: true, columns: headers.slice(0, 5)} do
      expect(step.result.type).to be ActiveETL::Result::TYPE_TABLE
      expect(step.result.data).to be_a(CSV::Table)

      expect(step.result.data.size).to eq csv_size
      expect(step.result.meta[:headers]).to eq headers.slice(0, 5)
      expect(step.result.data[0].values_at).to eq first_row.slice(0, 5)
      expect(step.result.data[step.result.data.size - 1].values_at).to eq last_row.slice(0, 5)
    end

    it 'parse and consider header as data row if header turned off', options: {headers: headers.map{|h| "#{h}-custom".to_sym}} do
      expect(step.result.type).to be ActiveETL::Result::TYPE_TABLE
      expect(step.result.data).to be_a(CSV::Table)

      expect(step.result.data.size).to eq csv_size + 1
      expect(step.result.meta[:headers]).to eq headers.map{|h| "#{h}-custom".to_sym}
      expect(step.result.data[0].values_at).to eq headers.map{|k| k.to_s.upcase}
      expect(step.result.data[step.result.data.size - 1].values_at).to eq last_row
    end
  end
end