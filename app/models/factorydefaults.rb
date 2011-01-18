class Factorydefaults
  
  def initialize
    @users, @categories, @series, @conferences = load_json_data
  end
  
  def load
    create_categories
    create_conferences
    create_users
    create_series
  end
  
  private
    def create_categories
      @categories.each do |category_data|
        category = Category.find_or_initialize_by_name(category_data['name'])
        unless (parent_category_data = category_data['parent']).empty?
          category.parent = Category.find_or_create_by_name(parent_category_data['name'])
        end
        category.save!
        
        category_data['subcategories'].each do |sub_category_data|
          sub_category = Category.find_or_create_by_name(sub_category_data['name'])
          sub_category.parent = category
          sub_category.save!
        end
      end
    end
    
    def create_conferences
      @conferences.each do |conference_data|
        conference = Conference.create!(
          name: conference_data['name'],
          description: conference_data['description'],
          location: conference_data['location'],
          gps: conference_data['gps'],
          venue: conference_data['venue'],
          accomodation: conference_data['accomodation'],
          howtofind: conference_data['howtofind'],
          startdate: conference_data['startdate'],
          enddate: conference_data['enddate'],
        )
        
        conference_data['categories'].each do |category_data|
          ConferenceCategory.create!(
            conference: conference,
            category: Category.find_by_name(category_data['name'])
          )
        end
      end
    end
    
    def create_users
      @users.each do |user_data|
        user = User.new(
          username: user_data['username'],
          password: user_data['password'],
          full_name: user_data['fullname'],
          email: user_data['email'],
          city: user_data['town'],
          country: user_data['country'],
          gps: user_data['gps']
        )
        user.skip_confirmation!
        user.save!
      end
    end
    
    def create_series
      @series.each do |series_data|
        series = Series.create!(name: series_data['name'])
        
        series_data['contacts'].each do |series_contact_data|
          SeriesContact.create!(
            series: series,
            contact: User.find_by_username(series_contact_data['username'])
          )
        end
      end
    end
    
    def load_json_data
      JSON.parse(IO.read(File.dirname(__FILE__) + '/../../db/data.txt'))
    end
end