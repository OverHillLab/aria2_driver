# Aria2Driver

Simple api to manage aria2c via api

# Status
[![Gem Version](https://badge.fury.io/rb/aria2_driver.svg)](http://badge.fury.io/rb/aria2_driver)
[![Build Status](http://img.shields.io/travis/OverHillLab/aria2_driver/master.svg)](https://travis-ci.org/OverHillLab/aria2_driver?branch=master)
[![Code Climate](http://img.shields.io/codeclimate/github/OverHillLab/aria2_driver.svg)](https://codeclimate.com/github/OverHillLab/aria2_driver)

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'aria2_driver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aria2_driver

## Usage


### Simple aria2 client initialization


``` ruby
aria2 = Aria2Driver::JsonRpc::Client.new 'hostname'
```

With the previous line of code you can create a client that will make requests to `aria2c` downloader
running on **hostname** server accepting connections to port **80** with default **http** scheme.
The client created as is will have a self generated client id (using SecureRandom).

``` ruby
aria2 = Aria2Driver::JsonRpc::Client.new 'hostname',
              {port: 9090, scheme: 'https', id: 'my', token: 'abcd-1234'}
```

With the code described above, you can override default connection parameters specifying also a
custom **client_id** and a **secret token**. The latter will be used in any of the following requests and
must match the **--rpc-secret** parameter specified in the aria2c configuration.


### Making requests

Aria2Driver allows you to make a generic request, via jsonrpc, in which you have to put the aria2 **method** and
request parameters, as described below

``` ruby
response = aria2.request Aria2Driver::JsonRpc::Request.new 'aria2.addUri',
                         {params: [['http://www.example.com/a.jpg'], {"dir" => "/tmp/"}]}
```

it's also possible to make the same request as follow

``` ruby
response = aria2.add_uri {params: [['http://www.example.com/a.jpg'], {"dir" => "/tmp/"}]}
```

### Response

Aria2Driver request can lead to a valid aria2c response or to an exception (*ResponseException*) in case of
a connection problem or any other kind of problem occurred in the communication with aria2c.
You can check if a valid response is an 'error' one or a 'result' one checking the **error?** method as below

``` ruby
response = aria2.get_version
response.error?
```

If a response is an error one, the **error** getter returns you a simple ruby wrapper class of the jsonrpc error
block, with **code**, **message** and the optional **data**

``` ruby

error = response.error

error.code # => -32700
error.message # => "Parse error"
```

If you get a non-error response, you can access the **result** in form of an hash obtained parsing the json result block
in the aria2c response

``` ruby
response.result # => {"gid" => "2089b05ecca3d829", "status" => "active"}
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/aria2_driver/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
