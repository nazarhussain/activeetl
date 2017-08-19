

# Series example
# step('Read database').bind(
#   step('Change Values').bind(
#     step('Write Database')
#   )
# )

read_db = step 'Call API', 'inputs/http_input', url: 'http://google.com'
parse_json = step 'Parse JSON Body', 'parsers/json'
transform = step('Transform database', 'inputs/http_input')
store = step('Store to database', 'inputs/http_input')

# bind read_db, transform
# bind transform, store

bind read_db, parse_json, transform, store

