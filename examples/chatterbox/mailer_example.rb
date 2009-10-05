require 'example_helper'

describe Chatterbox::Mailer do
  before { ActionMailer::Base.delivery_method = :test }
  include Chatterbox

  describe "wiring the email" do
    it "should set subject to the summary" do
      email = Mailer.create_message(valid_options.merge(:message => { :summary => "check this out"}))
      email.subject.should == "check this out"
    end
    
    it "should not require a body (for emails that are subject only)" do
      email = Mailer.create_message(valid_options.merge(:message => { :body => nil}))
      email.body.should be_blank # not nil for some reason -- ActionMailer provides an empty string somewhere
    end
    
    it "should set body to the body" do
      email = Mailer.create_message(valid_options.merge(:message => { :body => "here is my body"}))
      email.body.should == "here is my body"
    end
    
    it "should set from" do
      email = Mailer.create_message(valid_options.merge(:config => { :from => ["from@example.com"] }))
      email.from.should == ["from@example.com"]
    end
  end
  
  describe "content type" do
    it "can be set" do
      Mailer.create_message(valid_options.merge(:config => { :content_type => "text/html"})).content_type.should == "text/html"
    end
    
    it "should default to text/plain" do
      Mailer.create_message(valid_options).content_type.should == "text/plain"
    end
  end
  
  [:to, :cc, :bcc, :reply_to].each do |field| 
    describe "when configuring the #{field} field that takes one or many email addresses" do
      it "should allow setting a single address" do
        email = Mailer.create_message(valid_options.merge(:config => { field => "joe@exmaple.com"}))
        email.send(field).should == ["joe@exmaple.com"]
      end
      
      it "should allow setting multiple addresses" do
        email = Mailer.create_message(valid_options.merge(:config => { field => ["joe@example.com", "frank@example.com"]}))
        email.send(field).should == ["joe@example.com", "frank@example.com"]
      end
    end
  end

end

# content_type - Specify the content type of the message. Defaults to text/plain.
# headers - Specify additional hea
