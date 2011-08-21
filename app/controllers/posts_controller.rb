# encoding: UTF-8
class PostsController < ApplicationController
  helper :profile
  before_filter :protect, :protect_blog

  def index
    @title = "Nachricht ändern"
		@posts = Post.find_all_by_blog_id(params[:blog_id])		
		
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts.to_xml }
    end
  end

  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def new
    @post = Post.new
    @title = "Neue Nachricht erstellen"
  end

  def edit
    @post = Post.find(params[:id])
    @title = "Ändern von #{@post.title}."
  end
	
	def create
	  @post = Post.new(params[:post])
	  @post.blog_id = params[:blog_id]
	  respond_to do |format|
	    if @post.save
	      format.html { redirect_to(blog_posts_path, :notice => 'Nachricht wurde erstellt!') }
	      format.xml  { render :xml => @post, :status => :created, :location => @post}
	    else
        format.html { render :action => "new" }
	      format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
	    end
	  end
	end

  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Nachricht wurde geändert!'
        format.html { redirect_to blog_post_url(:id => @post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
    	flash[:notice] = 'Nachricht wurde gelöscht!'
      format.html { redirect_to blog_posts_url }
      format.xml  { head :ok }
    end
  end
  
	private

  def protect_blog
    @blog=Blog.find(params[:blog_id])
    user=User.find(session[:user_id])
    unless @blog.user==user
      flash[:notice]= "Das ist nicht dein Nachrichtenbereich!"
      redirect_to :action=>"index",:controller=>"user"
      return false
    end
  end
  
  def protect_post
    post = Post.find(params[:id])    
    unless post.blog == @blog
      flash[:notice] = "Das ist nicht deine Nachricht!"
      redirect_to hub_url
    	redirect_to :action=>"index",:controller=>"user"
      return false
    end
  end
end