-- vim:ft=lua
package.path= package.path .. ';lib/?.lua'

require 'Test.More'

require_ok('lolivimson.encoder')

local enc= require 'lolivimson.encoder'

is(enc.encode('hoge'), "'hoge'", 'string')
is(enc.encode({}), '[]', 'empty table')
is(enc.encode({1, 2, 3}), '[1.000000000,2.000000000,3.000000000,]', 'table')
is(enc.encode({key='value'}), "{'key':'value',}", 'table')
is(enc.encode(1), '1.000000000', 'integral number')
is(enc.encode(1.0), '1.000000000', 'floating point number')
is(enc.encode(1.1), '1.100000000', 'floating point number')
is(enc.encode(true), '1', 'boolean')
is(enc.encode(false), '0', 'boolean')
is(enc.encode(nil), '0', 'nil value')
