

read_csv     = step 'Loading CSV',
                   'inputs/csv',
                    path: File.expand_path('./examples/data/sales_data.csv'),
                    encoding: 'ISO-8859-1',
                    columns: ['ORDERNUMBER', 'PRICEEACH']

parse_json  = step 'Parse JSON Body',
                   'parsers/json'

store_file  = step 'Store to a file',
                   'stores/file',
                    path: File.expand_path('./examples/data/sales_data.json')


bind read_csv, parse_json, store_file

