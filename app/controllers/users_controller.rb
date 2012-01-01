class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]

#  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]
  before_filter :check_new,    :only => [:create, :new] #Signed-in users have no reason to access new and create actions.


  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ''
      @user.password_confirmation = ''
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end



# 12-18-2011
# destroy()  * FAIL *


#Why is this suddenly failing rspec testing?  It was passing before, but now rspec is saying .to_i is an undefined method of User.
# WTF! I DO NOT LIKE IT WHEN SHIT JUST SPONTANEOUSLY STARTS TO FAIL.  I HAVEN'T CHANGED ANYTHING IN HERE SINCE THE TESTS PASSED! NOT FUCKING COOL!!
# And besides, the method works correctly when I try to delete users from a web page.
    #if current_user.id == params[:id].to_i 

    #p_id = params[:id].to_i
    #puts "p_id is: " + p_id.to_s


# current_user.id is a Fixnum and  params[:id] is a String!
#    if current_user.id == params[:id] #fails to compare properly if params[:id] is not cast into a number!
# This problem was not caught by the controller Spec test!
# I guess this is the argument for integration tests!

# puts "current_user.id: " + current_user.id.class.to_s
# puts "params[:id]: " + params[:id].class.to_s

# This ALWAYS FAILS w/o the number cast:
#    if current_user.id == params[:id] #.to_i
#      puts "ids are EQUAL"
#    else
#      puts "ids are NOT equal"
#    end


# CHECK THIS OUT: 
# puts params[:id].class 
# `puts params[:id].class` returns "string" from the controller when using manual input from the browser - thus, 
# the code    if current_user.id == params[:id]  # (note: without the .to_i) 
# the == comparison *always* fails at the controller, allowing a user do delete himself(!).  

# But the puts output of the spec test returns User.fixnum - SOMETIMES - thus the undefined method error: fixnum is already a number, 
# so there would be no to_i() method for it.  So the type/class of params[:id] is different in the view vs. the spec!  
# See this by observing the output in the rspec test vs the `rails server` output.  But there were times when the params[:id] was NOT
# a Fixnum, because the spec PASSED w/o error and params[:id].to_i did not produce an error from the spec!  
# That's what makes this bug so insidious - after passing the spec tests w/o a problem, it spontaneouly started to fail.  
# So the pitfalls are twofold - the data types of params[:id] are different in the view vs. the spec, and then the 
# data type of params[:id] returned in the spec spontaneously changed, resulting in a failed spec test - not due to anything that changed in the spec!


# 12-20-2011
# AHA!  I found an error - not the fault of rspec - mine own?  I still swear that the tests were passing before, then spontaneously began to fail,
# but I see where the error could potentially be from.  But I'm willing to concede that my memory may be bad - I might have made a small change somwhere...
# In one test I wrote:
#  delete :destroy, :id => @user
# In another test I wrote:
#  delete :destroy, :id => @admin.id
# the `.id` version cast the variable explicitly into an integer, causing the mismatch in data types!
# So, in one case I'm passing a data type of "User" object, in another I'm passing a "Fixnum".
# My fault lay in trying to make things more explicit with the @admin.id, but this changed the process from passing a User object to passing a Fixnum object,
# so the comparison process ceased to be parallel in the rspec test vs manual controller usage.   

# So the question is how to avoid this kind of problem in the future?
# In the case of this code, if the comparison fails, it goes ahead and allows a destroy action that should not happen.  That's a critical error.
# Is the solution to always check the data types of the compared elements?
# And shouldn't a failed comparison result in the code breaking insted of the `if` statement proceeding to process?

# Is this a moment to formulate a principle of "NEVER GO ON FAIL, ONLY ON CONFIRMATION"?  Because a failure could come from a number of sources, other than the one
# you are checking.  ie, the construction:

#  if current_user.id == param[:id]
#     don't delete user
#   else
#     delete user (the "go", on fail)
#   end

# Hmmm, but I'm not sure how to write this as a confirmation, because ultimately, we are checking for falsity...


#  if current_user.id != params[:id]
#    delete user (the "go", on confirmation)
#  else
#    don't delete user
#  end

# Nah, that doesn't fix it either.  We just reversed the control logic, but the same pitfall exists.

# Ultimately, the problem is that NOT being something encompasses a MUCH larger sphere than BEING something.  

# The only fix seems to be to make sure that we're actually comparing what we think we're comparing - here, that the two operands are at least the same data type...

# Perhaps this is an example of how lose data-typing can get one in trouble.  If this code required strict data typing, the code would have instead thrown an error at runtime.


# 12-21-2011
# I see, the interesting thing here is that params[:id] isn't actually the id # of the user the delete is being requested for.  It's actually a user object which 
# contains an "id" attribute.  To access the id, I'd need to access "params[:id][:id]".  

# But that's not the solution he wants - he wants something that's more canonically correct Rails: take params[:id], create a new User object from it,
# then delete from that object.  I got that from the getsatisfaction.com site thread for this exercize (10.6.5).  It makes sense, as it is typical
# of the code I've seen so far.  Even though it seems very inefficient to go through the whole creation of a User object.  
# This allows us to make use of Rails "magic", where "user = User.find(params[:id])" takes care of deconstructing
# the params[] hash, instead of my having to deconstruct it manually and having to know that I have to access "params[:id][:id]", which took a bit of 
# detective work to figure out on my own.  

# We'll also be making use of the current_user?() method created earlier.

# Further complicating things is that code running from the rspec test results in different results from manual testing.
# Eg, the code
#  puts "params[:id] class: " + params[:id].class.to_s + " " + params[:id].to_s

# from the rspec test results in (rspec test output): 
#  params[:id] class: User #<User:0xac9aae0>

# whereas the output from manual testing from the browser screen results in (rails server output):
#  params[:id] class: String 8

# So, the code run manually is a step deconstructed.  Such that the following flags an error from manual testing, but not from rspec testing:
# puts "params[:id][:id] class: " + params[:id][:id].class.to_s + " " + params[:id][:id].to_s



# I'm going to rewrite the code to follow that example.  
# http://getsatisfaction.com/railstutorial/topics/how_to_prevent_admin_user_from_deleting_themselves



# puts "params class: " + params.class.to_s + " " + params.to_s
# puts "params[:id] class: " + params[:id].class.to_s + " " + params[:id].to_s
## puts "params[:id][:id] class: " + params[:id][:id].class.to_s + " " + params[:id][:id].to_s
# puts "params[:id][:user] class: " + params[:id][:user].class.to_s + " " + params[:id][:user].to_s
# puts "params[:user] class: " + params[:user].class.to_s + " " + params[:user].to_s
# puts "current_user.id class: " + current_user.id.class.to_s + " " + current_user.id.to_s

# My original code
#  def destroy
#    if current_user.id == params[:id] #.to_i 
#      flash[:error] = "You may not delete yourself!"
#    else
#      User.find(params[:id]).destroy
#      flash[:success] = "User destroyed."
#    end
#    redirect_to(users_path)
#  end


  def destroy
    user = User.find(params[:id])

    if current_user?(user)
      flash[:error] = "You may not delete yourself!"
    else
      user.destroy	# Obviously, need some error checking here...
      flash[:success] = "User destroyed."
    end

    redirect_to(users_path)
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def check_new
      redirect_to(root_path) if signed_in?
    end


end
