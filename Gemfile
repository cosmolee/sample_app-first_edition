#A note about versions: these versions are ones that have been confirmed to WORK for the purposes here (Hartl book).  If you use different versions, they may cause problems compatibility-wise.  Change at your own risk.  

source 'http://rubygems.org'

gem 'rails', '3.0.11'
# 12/30/2011 - upgrading to 3.0.11, per new version of online book
#gem 'rails', '3.0.3'
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'gravatar_image_tag'
gem 'will_paginate', '3.0.pre2'
gem 'heroku'
gem 'taps'

group :development do
  gem 'rspec-rails', '2.6.1'
# 12/30/2011 - upgrading to 2.6.1 per online book
#  gem 'rspec-rails', '2.3.0'
  gem 'annotate', '2.4.0'
# 12/30/2011 I'm removing this - replaced by "annotate 2.4.0", per listing 6.4  
#gem 'annotate-models'
  gem 'faker'
end

group :test do
  gem 'rspec', '2.6.0'
#Replacing w/ v 2.6.0, which is what rspec-rails 2.6.1 depends on.
#  gem 'rspec', '2.3.0'
  gem 'webrat', '0.7.1'
  gem 'spork', '0.9.0.rc8'
# per online book, 12/30/2011:  gem 'spork', '0.8.4'
  gem 'factory_girl_rails'
  gem 'ffi', '1.0.4'
  gem 'rb-inotify', '0.8.4'
  gem 'autotest-growl', '0.2.9'  

  gem 'autotest', '4.4.6'		
  #autotest is required by autotest-inotify - it won't use autotest-standalone. If autotest-inotify ran with 
  #autotest-standalone, we could get rid of autotest and ZenTest, which are superflous here - alas, we can't.
  #If you aren't going to use autotest-inotify, you can lighten the load and use autotest-standalone instead of loading the autotest/ZenTest combo.

  gem 'autotest-rails-pure', '4.1.2'	
  #required by autotest to detect file changes when running outside of ZenTest (We're not using ZenTest). The 'autotest' gem alone does not suffice.

  gem 'autotest-inotify', '0.0.5'  #Upgrading from 0.0.4 to 0.0.5 did not fix <ctrl-C> issue...

  gem 'ZenTest', '4.4.2'
  #We don't actually need ZenTest, but it is installed automatically as a dependency of autotest-inotify
end


