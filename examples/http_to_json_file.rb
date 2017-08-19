

call_http   = step 'Call http endpoint',
                   'inputs/http',
                    url: 'https://jsonplaceholder.typicode.com/posts'

parse_json  = step 'Parse JSON Body',
                   'parsers/json'

store_file  = step 'Store to a file',
                   'stores/file',
                    path: File.expand_path('./examples/data/sales_data.json')


bind call_http, parse_json, store_file

