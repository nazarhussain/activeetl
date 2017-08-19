

# Series example
# step('Read database').bind(
#   step('Change Values').bind(
#     step('Write Database')
#   )
# )

read_db     = step 'Call API',
                   'inputs/http', url: 'http://google.com'

read_csv     = step 'Loading CSV',
                   'inputs/csv',
                    {file: File.expand_path('./examples/data/sales_data.csv'),
                    encoding: 'ISO-8859-1'}


parse_json  = step 'Parse JSON Body',
                   'parsers/json'

transform   = step 'Transform database',
                   'inputs/http'

store       = step 'Store to database',
                   'inputs/http'

# bind read_db, transform
# bind transform, stores

bind read_csv, parse_json, transform, store

