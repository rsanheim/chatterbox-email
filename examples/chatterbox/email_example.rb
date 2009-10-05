require 'example_helper'

describe Chatterbox::Email do
  include Chatterbox
  
  describe "creation" do
    it "is wired with valid options" do
      lambda {
        Chatterbox::Email.deliver(valid_options)
      }.should_not raise_error
    end
    
    it "returns TMail::Mail instance" do
      result = Chatterbox::Email.deliver(valid_options)
      result.should be_instance_of(TMail::Mail)
    end
  end
  
  describe "validations" do
    it "should require :message" do
      lambda {
        Email.deliver(:config => { :from => "foo", :to => "foo"})
      }.should raise_error(ArgumentError, /Must configure with a :message/)
    end
    
    it "should require :message => :summary" do
      lambda {
        Email.deliver(:message => {}, :config => { :from => "foo", :to => "foo"})
      }.should raise_error(ArgumentError, /Must provide :summary in the :message/)
    end
    
    it "should require :to" do
      lambda {
        Email.deliver(:message => {:summary => ""}, :config => { :from => "anyone" })
      }.should raise_error(ArgumentError, /Must provide :to in the :config/)
    end
  
    it "should require from address" do
      lambda {
        Email.deliver(:message => {:summary => ""}, :config => { :to => "anyone"})
      }.should raise_error(ArgumentError, /Must provide :from in the :config/)
    end
  end
end