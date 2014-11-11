-- vim:ft=lua
package.path= package.path .. ';lib/?.lua'

require 'Test.More'

require_ok('lolivimson.decoder')

local dec= require 'lolivimson.decoder'

is(dec.decode('"hoge"'), 'hoge')
is_deeply(dec.decode('{}'), {})
is_deeply(dec.decode('[1, 2, 3]'), {1, 2, 3})
is_deeply(dec.decode('{"key": "value"'), {key= 'value'})
is(dec.decode('1'), 1)
is(dec.decode('1.0'), 1.0)
is(dec.decode('1.1'), 1.1)
