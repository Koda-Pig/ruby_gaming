```ruby
# Module-level constant
MY_CONSTANT = "Hello from constant"

# Module to organize code (optional but recommended)
module MyModule
  # Class definition
  class MyClass
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def greet
      "Hello, #{@name}!"
    end
  end

  # Module method (similar to a standalone function)
  def self.my_function(param)
    "Function called with: #{param}"
  end

  # Another way to define module methods
  module_function

  def another_function
    "This is another function"
  end
end

# Top-level method (global scope)
def global_function
  "This is a global function"
end

# Instance variable at file level (not recommended)
@file_variable = "File level variable"

# Global variable (use sparingly)
$global_variable = "Global variable"

# Basic import
require_relative 'my_module'

# Or if it's in a subdirectory
# require_relative 'lib/my_module'

# Using the imported code
puts MY_CONSTANT
puts MyModule.my_function("test")
puts MyModule.another_function

# Creating instance of the class
obj = MyModule::MyClass.new("Alice")
puts obj.greet

# Global function can be called directly
puts global_function

# Accessing global variable
puts $global_variable
```
