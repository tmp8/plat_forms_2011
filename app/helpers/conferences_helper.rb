module ConferencesHelper
  def attend_or_unattend_button
    if current_user 
      if participation = current_user.participation_for(@conference)
        button_to('Wont attend', conference_conference_participation_path(@conference, participation), :confirm => "Are you sure?", :method => :delete)
      else
        button_to('Attend', conference_conference_participations_path(@conference), :confirm => "Are you sure?", :method => :post)
      end
    else
      # FIXME: go through sing-in / up and participate
    end
  end
  
  def conference_link(conference)
    ("#{conference.startdate} to #{conference.enddate} - " + link_to(conference.name, conference_path(conference))).html_safe
  end
end
