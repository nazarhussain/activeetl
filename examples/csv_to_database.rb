

read_csv     = step 'Loading CSV',
                   'inputs/csv',
                    path: File.expand_path('./examples/data/sales_data.csv'),
                    encoding: 'ISO-8859-1',
                    columns: ['ORDERNUMBER', 'PRICEEACH']

store_file  = step 'Store to a database',
                   'stores/database',
                    target: :default,
                    table: :dummy

bind read_csv, store_file

