require 'minitest/autorun'
require 'yuicompressor'

class TestYUICompressor < MiniTest::Unit::TestCase
	
	def setup
		@engine = YUICompressor.new
		@input = <<EOS 
document.write("<h2>Table of Factorials</h2>");
for(i = 1, fact = 1; i < 10; i++, fact *= i) {
    document.write(i + "! = " + fact);
    document.write("<br>");
}
EOS
	end

	def test_obfuscate
		output, errors, status = @engine.obfuscate(@input)
		assert_equal 'document.write("<h2>Table of Factorials</h2>");for(i=1,fact=1;i<10;i++,fact*=i){document.write(i+"! = "+fact);document.write("<br>")};', output
		assert_equal '', errors
		assert_equal 0, status
	end
end

