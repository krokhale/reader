class Message < ActiveRecord::Base
  
  
  def cron_task
  
   require 'mail'
   require 'pop_ssl.rb'
   
   username = temp.nav.chat
   password = tempnavchat

   Mail.defaults do
      retriever_method :pop3, { :address             => "pop.gmail.com",
                                :port                => 995,
                                :user_name           => username,
                                :password            => password,
                                :enable_ssl          => true }
    end

    emails = Mail.all
          
    emails.each do |email|  
       Message.create(:body => email.body, :subject => email.subject, :mail_from => email.from.to_s)
    end
    
  end
  
  
  
end
