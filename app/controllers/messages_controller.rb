class MessagesController < ApplicationController
  # GET /mails
  # GET /mails.xml
  def index
    @messages = Message.all
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mails }
    end
  end
  
  def get_mail
     require 'mail'
     require 'pop_ssl.rb'
     
     @account = Account.find(params[:username][:id])
     username = @account.username
     password = @account.password
     search_terms = params[:search_terms].split(",")
     mail_ids = params[:mail_from].split(",")

     Mail.defaults do
        retriever_method :pop3, { :address             => "pop.gmail.com",
                                  :port                => 995,
                                  :user_name           => username,
                                  :password            => password,
                                  :enable_ssl          => true }
      end

      emails = Mail.all
      message_ids = []
            
      emails.each do |email|  
          message_id = match(email,search_terms,mail_ids)
          #only stores ids that are not nil
        if message_id != nil
          message_ids << message_id
        end
      end
      
      redirect_to :controller => "messages", :action => :show, :message_ids => message_ids
    end
    
    
    def match(email,search_terms,mail_ids)
      
      tokens = []
    
       email.subject.split(/[^-a-zA-Z]/).each do |word|
         tokens << word
       end
       
       email.body.decoded.split(/[^-a-zA-Z]/).each do |word|
          tokens << word
        end
        
       matched_terms = tokens & search_terms
       matched_ids = email.from & mail_ids
       
       if (matched_terms.count != 0 && matched_ids.count != 0)
       message = Message.create(:mail_from => email.from.to_s, :subject => email.subject, :body => email.body.decoded,
        :matched => matched_terms.join(","))     
       end
       
       # returns nil if there is no message created else returns the message id.
       if message == nil
       return nil
     else
       return message.id
     end
     
     end
        
        
         
      
  
  
  

  # GET /mails/1
  # GET /mails/1.xml
  def show
    
    @messages = []
    if params[:message_ids]
      params[:message_ids].each do |id|
        @messages << Message.find(id)
      end
    end
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end
  
  
  
  def search
    
    @accounts = Account.all
    
  end
  
  def search_mail
     
     search_terms = params[:search_terms].split(",")
      mail_ids = params[:mail_from].split(",")

      messages_from_ids = messages_from_terms = []

      mail_ids.each do |id|
        messages_from_ids << Message.find_all_by_mail_from(id)
        messages_from_ids.flatten!
      end

      search_terms.each do |term|
        Message.all.each do |message|
          if ((message.matched.split(",") & search_terms).count != 0)
            messages_from_terms << message
          end
        end
      end
      
      
      if ((search_terms.count && mail_ids.count) != 0)
      common_results = messages_from_ids & messages_from_terms
      message_ids = common_results.collect(&:id)
    elsif(search_terms.count == 0)
      message_ids = messages_from_ids.collect(&:id)
    elsif(mail_ids.count == 0)
      message_ids = messages_from_terms.collect(&:id)
    end

      redirect_to :controller => "messages", :action => :show, :message_ids => message_ids
    end
    
    
  

  # GET /mails/new
  # GET /mails/new.xml
  def new
    @mail = Mail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mail }
    end
  end

  # GET /mails/1/edit
  def edit
    @mail = Mail.find(params[:id])
  end

  # POST /mails
  # POST /mails.xml
  def create
    @mail = Mail.new(params[:mail])

    respond_to do |format|
      if @mail.save
        format.html { redirect_to(@mail, :notice => 'Mail was successfully created.') }
        format.xml  { render :xml => @mail, :status => :created, :location => @mail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mails/1
  # PUT /mails/1.xml
  def update
    @mail = Mail.find(params[:id])

    respond_to do |format|
      if @mail.update_attributes(params[:mail])
        format.html { redirect_to(@mail, :notice => 'Mail was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mails/1
  # DELETE /mails/1.xml
  def destroy
    @mail = Mail.find(params[:id])
    @mail.destroy

    respond_to do |format|
      format.html { redirect_to(mails_url) }
      format.xml  { head :ok }
    end
  end
end
