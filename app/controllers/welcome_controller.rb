# origin: M
class WelcomeController < ApplicationController
  
  def hello
    @categories = Category.root.all
    @conferences = Conference.all
    @running_conferences = Conference.running.all
    @tomorrows_conferences = Conference.tomorrow.all
  end
end
