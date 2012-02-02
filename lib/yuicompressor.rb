require 'open3'

# This class wraps the C++ obfuscation engine produced by Stunnix.
# {Stunnix C++ Obfuscator}[http://www.stunnix.com/prod/cxxo/overview.shtml]
class YUICompressor

	# By default the engine is distributed in the ext folder of this gem.
	# This constant allows us to find the path to the engine executable. 
	ENGINE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
	BINARY = false # input is in text format
	NOSTDIN = false # accepts standard input
	PLATFORM = "linux" # Linux program
 
	attr_reader :options

	# The user can instantiate this class by passing in a Hash of options
	# 
	# Default options:
	#
	# By default the engine is distributed with this gem in the "ext" folder
	#  :command => File.join(ENGINE_ROOT,"ext","yuicompressor-2.4.7","build","yuicompressor-2.4.7.jar")
	#
	def initialize(options = {})
		@name = self.class.to_s.downcase
		@options = default_options.merge(options)
		@command_options = generate_command_options
	end
	
	# this method obfuscates code and provides the obfuscated code, errors 
	# produced by the engine, and the engine's exit status
	#  String: input
	#  String: output, errors
	#  Integer: exitstatus
	#  obfuscate(input) => output, errors, exitstatus
	#
	def obfuscate(input)
		output, errors, exitstatus = "", "", 0
		
		Open3.popen3(@options[:command] + " " + @command_options ) do |stdin,stdout,stderr,wait_thr|
			stdin.write(input)
			stdin.close
			output = stdout.read
			errors = stderr.read		
			exitstatus = wait_thr.value.exitstatus
		end
		
		return output, errors, exitstatus 
	end

	private
		# This method defines the default options in a Hash
		# 
		# By default, the engine is expected to be in the "ext" folder.
		# 
		# By default, standard C++ library functions and classes should be 
		# preserved during obfuscation.
		def default_options
			{
				# By default the engine is in the ext folder of this gem
				:command => File.join(ENGINE_ROOT,"ext","yuicompressor-2.4.7","build","yuicompressor-2.4.7.jar")
			}
		end

		# This method converts the options Hash into a string of flags for the 
		# command line call.
		#
		def generate_command_options
			command_options = ""
			@options.each do |key, value|
				if key.to_s != "command"
					if value.kind_of?(Array)
						value.each{|val| command_options += "#{key} #{val} "}
					elsif
						command_options += "#{key} #{value} "
					end		
				end
			end
			command_options.rstrip
		end
end
