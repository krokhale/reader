class TermsController < ApplicationController
  # GET /terms
  # GET /terms.xml
  def index
    @terms = Term.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @terms }
    end
  end
  
  
  def ajaxify_new
    
     if params[:new]
       params[:str].split(",").each do |str|
       @term = Term.create(:str => str, :account_id => params[:account_id])
     end
     end
     
     @accounts = Account.all
     @account = Account.find(params[:account_id])
     @message = "Terms added."
       
     
     respond_to do |format|
        format.html{ render :update do |page|
          page.replace_html "update", :partial => "new_term"
          if params[:new]
          page.replace_html "update", :partial => "accounts/index_acc", :locals => {:accounts => @accounts}
          page.replace_html "message", :partial => "accounts/message_acc", :locals => {:message => @message}
          
          page.visual_effect :highlight, "message"
          page.visual_effect :highlight, "update"
        end
          
          
        	end
             }
         end
    
    
  end
  
  
  
  def ajaxify_remove
    
    
    @terms = Term.find_all_by_account_id(params[:account_id])
    
    if(params[:remove])
      Term.destroy(params[:term_id])
      @message = "Term Deleted."
      @terms_after = Term.all
    end
    
    
    
    respond_to do |format|
        format.html{ render :update do |page|
          if params[:remove]
          page.replace_html "update", :partial => "remove_term", :locals => {:terms => @terms_after}          
          page.replace_html "message", :partial => "accounts/message_acc", :locals => {:message => @message}
          
          page.visual_effect :highlight, "message"
        else
          page.replace_html "update", :partial => "remove_term", :locals => {:terms => @terms}
        end
          
          
        	end
             }
         end
         
    
  end
  

  # GET /terms/1
  # GET /terms/1.xml
  def show
    @term = Term.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @term }
    end
  end

  # GET /terms/new
  # GET /terms/new.xml
  def new
    @term = Term.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @term }
    end
  end

  # GET /terms/1/edit
  def edit
    @term = Term.find(params[:id])
  end

  # POST /terms
  # POST /terms.xml
  def create
    @term = Term.new(params[:term])

    respond_to do |format|
      if @term.save
        format.html { redirect_to(@term, :notice => 'Term was successfully created.') }
        format.xml  { render :xml => @term, :status => :created, :location => @term }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /terms/1
  # PUT /terms/1.xml
  def update
    @term = Term.find(params[:id])

    respond_to do |format|
      if @term.update_attributes(params[:term])
        format.html { redirect_to(@term, :notice => 'Term was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /terms/1
  # DELETE /terms/1.xml
  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    respond_to do |format|
      format.html { redirect_to(terms_url) }
      format.xml  { head :ok }
    end
  end
end
