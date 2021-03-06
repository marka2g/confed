module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the presentation page/
      event_presentation_path(@presentation.event, @presentation)
    when /the speaker information page/
      speaker_path(@speaker)
    when /the speakers index page/
      speakers_path
    when /the events index page/
      events_path
    when /the event page/
      event_path(@event)
    when /the admin presentation page/
      admin_event_presentation_path(@presentation.event, @presentation)
    when /the admin edit presentation page/
      edit_admin_event_presentation_path(@presentation.event, @presentation)
    when /the event show page/
      event_path(@event)
    when /the new user registration page/
      @user_count = User.count
      new_user_registration_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
