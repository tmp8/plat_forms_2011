module ConferencesHelper
  def attend_or_unattend_button
    if participation = current_user.participation_for(@conference)
      button_to("Won't attend!!", conference_conference_participation_path(@conference, participation), :method => :delete)
    else
      button_to("Attend!", conference_conference_participations_path(@conference), :method => :post)
    end
  end
  
  def conference_link(conference)
    ("#{conference.startdate} to #{conference.enddate} - " + link_to(conference.name, conference_path(conference))).html_safe
  end
  
  def edit_link_if_creator(user)
    return unless @conference.creator == user
      
    button_to("Edit this conference", edit_conference_path(@conference), :method => :get, :id => :conference_edit)
  end
end
