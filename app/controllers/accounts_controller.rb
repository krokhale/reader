class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.xml
  def ajaxify_index
    @accounts = Account.all

     respond_to do |format|
       format.html{ render :update do |page|
           page.replace_html "update", :partial => "index_acc", :locals => {:accounts => @accounts}
           page.visual_effect :highlight, "update"
       	end
            }
        end
  end
  
  
  def ajaxify_new
    
    if(params[:new])
      @account = Account.create(:username => params[:username], :password => params[:password])
      @message = "Account Created"
    end
    @accounts = Account.all
    
    respond_to do |format|
       format.html{ render :update do |page|
         if params[:new]
           page.replace_html "update", :partial => "index_acc", :locals => {:accounts => @accounts}
           page.replace_html "message", :partial => "message_acc", :locals => {:message => @message}
         else
           page.replace_html "update", :partial => "new_acc"
          end
           page.visual_effect :highlight, "update"
           page.visual_effect :highlight, "message"
         
       	end
            }
        end
    
  end
  
  def ajaxify
    
    @account = Account.find(params[:id])
    
     respond_to do |format|
         format.html{ render :update do |page|
           page.replace_html "acc#{@account.id}", :partial => "ajaxify_acc", :locals => {:account => @account}
             page.visual_effect :highlight, "update"
         	end
              }
          end
    
    
  end
  
  
  def ajaxify_edit
    
    @account = Account.find(params[:id])
    
    if(params[:edit])
      @account.update_attribute("username", params[:username])
      @account.update_attribute("password", params[:password])
      @message = "Account Credentials Updated."
    end
    
    @accounts = Account.all
    
     respond_to do |format|
         format.html{ render :update do |page|
           if(params[:edit])
             page.replace_html "update", :partial => "index_acc", :locals => {:accounts => @accounts}
             page.replace_html "message", :partial => "message_acc", :locals => {:message => @message}
           else
           page.replace_html "acc#{@account.id}", :partial => "edit_acc", :locals => {:account => @account}
         end
           page.visual_effect :highlight, "update"
           page.visual_effect :highlight, "message"
           
         	end
              }
          end
    
  end
  
  def ajaxify_destroy

     @account = Account.find(params[:id])
     @account.destroy
     @accounts = Account.all
     @message = "Account Deleted."
     

     respond_to do |format|
        format.html{ render :update do |page|
          page.replace_html "update", :partial => "index_acc", :locals => {:accounts => @accounts}
          page.replace_html "message", :partial => "message_acc", :locals => {:message => @message}
          page.visual_effect :highlight, "message"
          
        	end
             }
         end

   end
   
   
  
  
  

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        format.html { redirect_to(@account, :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to(@account, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
end
