# Guard::Shotgun

Guard::Shotgun automatically starts and restarts Sinatra (through `rackup`) when needed. As useful as Shotgun when developing a Sinatra app.

* Tested on Ruby 1.9.2-p290 only.

## Why?

* You are **developing with Sinatra** and you have to **restart your development server each time you change your source code**?
* You are **using Shotgun** to do this, but well, the **latest version is not showing the logs anymore** in your console, which makes developing a little harder?

If you have answered 'yes' to any of these questions, you may find some use to this plugin.

## Install

Please be sure to have [Guard](http://github.com/guard/guard) installed before continue.

Install the gem:

    gem install guard-shotgun

Or add it to your Gemfile (inside development group):

    gem 'guard-shotgun', :git => https://github.com/rchampourlier/guard-shotgun.git

Add guard definition to your Guardfile by running this command:

    guard init shotgun

## Usage

This guard plugin is intended to be used when **developing a Sinatra application**, loaded through `rackup`.

**It allows automatic reloading of your Sinatra server when a file is changed.**

> It provides the same service as the **Shotgun** gem, relying on **Guard** to watch for your files.

Please read [Guard usage doc](http://github.com/guard/guard#readme)

## Guardfile

For example, to look at the `main.rb` file in your application directory, just set this guard:

    guard 'shotgun' do
      watch('main.rb')
    end
    
Please read [Guard doc](http://github.com/guard/guard#readme) for more info about Guardfile DSL.


## Options

Currently there is no option.

## History

#### v0.0.4

Killing Sinatra when reloading on change without waiting for requests to be completed.

#### v0.0.3

Initial release

## TODOs

* Add some options: host, port...
* Allow starting Sinatra applications without using rackup.
* Tests.

Help is welcome!


## Development

* Source hosted at [GitHub](http://github.com/crymer11/guard-shotgun)
* Report issues/Questions/Feature requests on [GitHub Issues](http://github.com/crymer11/guard-shotgun/issues)

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change
you make.

## Authors

[Romain Champourlier](http://github.com/rchampourlier)
[Colin Rymer](http://github.com/crymer11)


## Credits

This gem has been built from [guard-webrick](https://github.com/guard/guard-webrick) of [Fletcher Nichol](http://github.com/fnichol).
