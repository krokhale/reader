module Script
  
 require 'mail'
 require 'pop_ssl.rb'
 require 'smtp_tls.rb'

def get_mail
   
   @accounts = Account.all
   result_messages = []
   
   @accounts.each do |account|
       
   username = account.username
   password = account.password
   

   Mail.defaults do
      retriever_method :pop3, { :address             => "pop.gmail.com",
                                :port                => 995,
                                :user_name           => username,
                                :password            => password,
                                :enable_ssl          => true }
    end

    emails = Mail.all
    matched_terms = []
    result_emails = []
    result_email = []
       
    if (emails.count != 0)      
    emails.each do |email|
         @result = match(email,account)
         
         if @result[0] == nil
           @result[0] = []
         end
             
    end
    
     #result_emails.compact!    
    
    result_messages << form_result_message(@result[0], emails, account, @result[1].to_s)
    result_messages.flatten!
    
  else
    
    result_messages <<  form_not_found_message(account)
    result_messages.flatten!
  end
    
  end
  
  write_to_log(result_messages)
    
   return result_messages
  end
  
    
  
  def match(email,account)
    
     tokens =  []
     result_email = []
     result_emails = []
    
     search_terms = Account.find(account).terms.collect(&:str)
     
      email.body.decoded.split(/[^-a-zA-Z]/).each do |word|
         tokens << word
       end
       
       matched_terms = search_terms & tokens
     
     if (matched_terms.count != 0)
        result_email << email.from.to_s
        result_email << email.body.decoded
        result_email << email.subject
        result_emails << result_email   
       return result_emails,matched_terms.join(",")
     else
       return nil,matched_terms.join(",")
     end
     
   
   end
   
   def form_result_message(result_emails, emails,account,matched_terms)

     message = []
     count = 1
       
     message << "-------------------------------------------------------------------"
     message << "Summary::Account: #{account.username}"   
     message << "-------------------------------------------------------------------"
     message << "Total Emails = #{emails.count}"
     message << "Emails matching the search criteria = #{result_emails.count}"
     message << "The following terms matched:"
     message << "#{matched_terms}"
    
     message << "<br />"
     
     result_emails.each do |mail|
       
     message << "EMAIL::#{count}"
     message << "---------------"
     message << "MAIL FROM: #{mail[0]}"
     message << "SUBJECT: #{mail[2]}"
     message << "BODY: #{mail[1]}"
     count = count + 1
    end  

         return message
    end
    
    
    def form_not_found_message(account)
      
      message = []
      
       message << "-------------------------------------------------------------------"
       message << "Summary::Account: #{account.username}"
       message << "-------------------------------------------------------------------"
       message << "Total Emails = 0"
       message << "Emails matching the search criteria = 0"
       message << "The following terms matched:"
       message << "NO MATCH"

           return message
     end
     
     def write_to_log(result_messages)
       
       file_name = "mail_script_log"
       
       path = File.join(RAILS_ROOT, file_name)
       file = File.open(path, "a")  { |f| f.write("Current Time : #{Time.now}") }
       file = File.open(path, "a")  { |f| f.write("\n") }
       result_messages.each do |message|
       file = File.open(path, "a")  { |f| f.write(message) }
       file = File.open(path, "a")  { |f| f.write("\n") }
     end
     file = File.open(path, "a")  { |f| f.write("\n\n\n\n\n\n") }
   end
end