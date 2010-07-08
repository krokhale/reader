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
            
      emails.each do |email|  
          matched_terms = match(email.subject,email.body,search_terms)
      end
      
      redirect_to :back
    end
    
    
    def match(subject,body,search_terms)
      
      tokens = []
    
       email.subject.split(/[^-a-zA-Z]/).each do |word|
         tokens << word
       end
       
       email.body.decoded.split(/[^-a-zA-Z]/).each do |word|
          tokens << word
        end
        
       matched_terms = tokens & search_terms
       
       return matched_terms
     end
        
        
         
      
  
  
  

  # GET /mails/1
  # GET /mails/1.xml
  def show
    @mail = Mail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mail }
    end
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
