class MessagesController < ApplicationController
  
  
  include Script
  
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
  
  
  def eval
    
    @result_messages = get_mail()
    
    
     respond_to do |format|
       format.html{ render :update do |page|
           page.replace_html "update", :partial => "show_results", :locals => {:results => @result_messages}
           page.visual_effect :highlight, "update"
       	end
            }
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
    
    @terms = Term.all
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
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
