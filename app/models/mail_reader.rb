require 'tmail_mail_extension'
class MailReader < ActionMailer::Base
  def receive(email)
    return true if Conversation.find_by_mail_id(email.message_id)

    @conversation = Conversation.find_by_mail_id(email['In-Reply-To'].to_s.strip) if email['In-Reply-To']
    email.references.each do |ref|
      break if @conversation = Conversation.find_by_mail_id(ref)
    end if email.references
    
    @message = Message.create(
      :subject      => email.subject,
      :from         => email.from,
      :to           => email.to,
      :body         => email.body_plain.nil? ? email.body_html : email.body_plain,
      :mail_id      => email.message_id,
      :mail_date    => email.date,
      :conversation => @conversation || Conversation.create
    )
  end
  
  def self.check_mail
     begin
       require 'net/imap'
     rescue LoadError
       raise RequiredLibraryNotFoundError.new('NET::Imap could not be loaded')
     end

    @@config_path = (RAILS_ROOT + '/config/mailreader.yml')
    @@config = YAML.load_file(@@config_path)[RAILS_ENV].symbolize_keys

    imap = Net::IMAP.new(@@config[:email_server], port=@@config[:email_port], usessl=@@config[:use_ssl])
    
    imap.login(@@config[:email_login], @@config[:email_password])
    imap.select(@@config[:email_folder])  
    imap.search(['ALL']).each do |message_id|
      msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      MailReader.receive(msg)
      #simulate gmail archive:
      imap.copy(message_id, "[Gmail]/All Mail")
      imap.store(message_id, "+FLAGS", [:Deleted])
    end
  end
end