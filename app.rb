#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'replay'

Dir.chdir( '/var/chroot/' )
Dir.chroot( '/var/chroot/' )

post '/' do
	input = params[ :input ]
	output = params[ :output ]
	commands = params[ :commands ]
	replay = Replay.new input, output, commands
	replay.validates
	replay.valid?.to_s
end
