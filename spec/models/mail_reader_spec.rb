require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MailReader do
  
  describe "#receive" do
    
    before(:each) do
      @conversation   = Factory.create(:conversation)
      @ogemail = MailCreator.new_mail()
    end

    it "should not create multiple Conversations for the same email" do
      lambda { 2.times { MailReader.receive(@ogemail.to_s) } }.should change(Conversation, :count).by(1)
    end
    
    it "should set the mail_id of the message" do
      MailReader.receive(@ogemail.to_s)
      Message.last.mail_id.should include(@ogemail.message_id)
    end
    
    it "should store the email date" do
      date = "Tue, 19 Jan 2010 10:57:38 -0800 (PST)"
      email = MailCreator.new_mail("date" => date)
      MailReader.receive(email.to_s)
      Message.last.mail_date.should == Time.parse(date)
    end
    
    it "should store who the message was originally sent to" do
      email = MailCreator.new_mail("to" => "bill_biffles@example.com")
      MailReader.receive(email.to_s)
      Message.last.to.should include("bill_biffles@example.com")
    end

    it "should grab the plain version of the body of multiplart messages" do
      body = "lemme git dat crystal AXE AXE AXE"
      email = MailCreator.new_mail("body" => body)
      MailReader.receive(email.to_s)
      Message.last.body.should == "#{body}\r\n\r\n"
    end
    
    it "should add message to an conversation thread" do
      sweet_mail = MailCreator.new_mail("message_id" => "<123bizzlewizzle@donkey.local>")
      MailReader.receive(sweet_mail.to_s)
      Conversation.last.messages.first.mail_id.should == "<123bizzlewizzle@donkey.local>"
    end
    
    it "should add to an existing thread based on references" do
      sweet_mail = MailCreator.new_mail("message_id" => "<123bizzlewizzle@donkey.local>")
      reply_to_sweet_mail = MailCreator.new_mail("references" => "<123bizzlewizzle@donkey.local>")
      MailReader.receive(sweet_mail.to_s)
      MailReader.receive(reply_to_sweet_mail.to_s)
      Conversation.last.messages.size.should == 2
    end
    
    it "should also use the in-reply-to header to thread messages" do
      sweet_mail = MailCreator.new_mail("message_id" => "<123bizzlewizzle@donkey.local>")
      reply_to_sweet_mail = MailCreator.new_mail("in_reply_to" => "<123bizzlewizzle@donkey.local>")
      MailReader.receive(sweet_mail.to_s)
      MailReader.receive(reply_to_sweet_mail.to_s)
      Conversation.last.messages.size.should == 2
    end
  end

end
