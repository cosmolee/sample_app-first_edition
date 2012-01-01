require 'spec_helper'

describe PagesController do
  render_views


  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do
    describe "when not signed in" do

      before(:each) do
        get :home
      end
    
      it "should be successful" do
        response.should be_success
      end
    
      it "should have the right title" do
        response.should have_selector("title",
                                      :content => @base_title + "Home")
      end
    end
    
    describe "when signed in" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end
      
      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end
  end

# 12/25/11: I yanked this from the user_controller_spec.rb file.  Use to test that feed isn't showing delete link for non-current_user.
# However, this exercize from 11.5 is out of sync from the book's content - we're not showing non-current_user posts yet, so we can't test 
# for this, unless we rewrite the feed to include non-current_user posts.  But since we haven't developed the "follow" association yet,
# it doesn't make sense here.  Otherwise, we'd just be feedina ALL posts, regardless of whether they were associated with the current_user
# (following or followed, etc).
#
#    it "should not show other user's microposts" do
#      wrong_user = Factory(:user, :email => Factory.next(:email))
#      mp1 = Factory(:micropost, :user => wrong_user, :content => "Foo bar")
#      mp2 = Factory(:micropost, :user => wrong_user, :content => "Baz quux")
#      get :show, :id => @user
#      response.should_not have_selector("span.content", :content => mp1.content)
#      response.should_not have_selector("span.content", :content => mp2.content)
#    end



  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
        response.should have_selector("title",
                        :content => @base_title + "Contact")
      end
    end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                        :content => @base_title + "About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                        :content => @base_title + "Help")
    end
  end


end
