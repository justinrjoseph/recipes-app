require 'test_helper'

class ChefTest < ActiveSupport::TestCase
   
    def setup
      @chef = Chef.new(chefname: "John", 
                       email: "john@example.com")
    end
    
    test "chef should be valid" do
        assert @chef.valid?
    end
    
    test "chefname should be present" do
        @chef.chefname = ""
        assert_not @chef.valid?
    end
    
    test "chefname should not be longer than 40 characters" do
        @chef.chefname = "a" * 41
        assert_not @chef.valid?
    end
    
    test "chefname should not be shorter than 3 characters" do
       @chef.chefname = "aa"
       assert_not @chef.valid?
    end
    
    test "email should be present" do
       @chef.email = ""
       assert_not @chef.valid?
    end
    
    test "email should not be longer than 100 characters" do
        char = "a"
        @chef.email = "#{char * 94}@example.com"
        assert_not @chef.valid?
    end
    
    test "email should be unique" do
        duplicate_chief = @chef.dup
        duplicate_chief.email = @chef.email.upcase
        @chef.save
        assert_not duplicate_chief.valid?
    end
  
    test "email should be valid" do
        valid_addresses = %w[user@eee.com R_TDD-DS@eee.hello.org user@example.com first.last@eem.au laura+joe@monk.cm]
        valid_addresses.each do |va|
            @chef.email = va
            assert @chef.valid?, "#{va.inspect} should be a valid email address"
        end
    end
    
    test "email should not be invalid" do
        invalid_addresses = %w[user@example,com user_at_eee.org user.name@example. foo@eee+arr.com]
        invalid_addresses.each do |iva|
            @chef.email = iva
            assert_not @chef.valid?, "#{iva.inspect} should be an invalid email address"
        end
    end
    
end