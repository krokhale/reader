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
    result_emails = []
    matched_terms = []
       
    if (emails.count != 0)      
    emails.each do |email|
         result = match(email,account)
         result_emails << result[0]
         matched_terms << result[1]
    end
    
    result_emails.compact!    
    
    result_messages << form_result_message(result_emails, emails, account, matched_terms.to_s)
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
    
     search_terms = Account.find(account).terms.collect(&:str)
     
      email.body.decoded.split(/[^-a-zA-Z]/).each do |word|
         tokens << word
       end
       
       matched_terms = search_terms & tokens
     
     if (matched_terms.count != 0)
       return email,matched_terms.join(",")
     else
       return nil,matched_terms.join(",")
     end
     
   
   end
   
   def form_result_message(result_emails, emails,account,matched_terms)

     message = []
       
     message << "-------------------------------------------------------------------"
     message << "Summary::Account: #{account.username}"   
     message << "-------------------------------------------------------------------"
     message << "Total Emails = #{emails.count}"
     message << "Emails matching the search criteria = #{result_emails.count}"
     message << "The following terms matched:"
     message << "#{matched_terms}"

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
     
     
     
end