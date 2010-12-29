require 'digest/sha1'
require 'tempfile'

TMP_DIR = File.expand_path( File.join( File.dirname(__FILE__ ), 'tmp' ))

class Replay
	def initialize( input, output, commands )
		Tempfile.open Digest::SHA1.hexdigest( 'input-' + commands ) do |file|
			@input_file = file.path
			file.write input
		end

		Tempfile.open Digest::SHA1.hexdigest( 'output-' + commands ) do |file|
			@output_file = file.path
			file.write output
		end

		Tempfile.open Digest::SHA1.hexdigest( 'commands-' + commands ) do |file|
			@commands_file = file.path
			file.write commands
		end
	end

	def validates
		system("vim -n --noplugin -i NONE +0 -s #{@commands_file} #{@input_file}")
		@valid = false

		if $?.exitstatus.zero?
			diff = `diff --strip-trailing-cr #{@input_file} #{@output_file}`
			@valid = true if diff.size === 0
		end
	end

	def valid?
		@valid
	end
end
