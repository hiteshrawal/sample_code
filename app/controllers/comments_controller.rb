class CommentsController < ApplicationController
#  sortable_table Comment , :display_columns => ['id','content','user_id']

  sortable_table Comment , :include_relations => [:user],
    :table_headings => [['Id','id'],['Content','content'],['UserName','user.name']],
    :sort_map => {'id' => ["(comments.id || ' ' || users.name)", 'ASC'],'content' =>['comments.content','ASC'],'user.name' => ['users.name','ASC'], 'created_at' => ['comments.created_at', 'ASC']},
    :default_sort => ['content', 'ASC'],
    :secondary_sort => ['user.name','ASC'],
    :filter_map => {'id' => 'comments.id','content' =>'comments.content','user.name' => 'users.name','created_at' => 'comments.created_at'},
    :letter_search => ['comments.content'],
    :per_page => 8
  def index
    #get_sorted_objects(params,:filter => true,:per_page => 20,:conditions =>"users.id = 2")
    get_sorted_objects(params,:filter => true)
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@comment, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
