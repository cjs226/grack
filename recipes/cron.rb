if node['grack'] && node['grack']['graphs']
  node['grack']['graphs'].each do |graph_name,graph_details|
    if graph_details['delete']
      Chef::Log.info("#{cookbook_name}::#{recipe_name} Deleting grack cron #{graph_name}")
      cron graph_name do
        user node['grack']['username']
        action :delete
      end
    else
      Chef::Log.info("#{cookbook_name}::#{recipe_name} Creating grack cron #{graph_name}")
      dashboard_id = graph_details['dashboard'] && graph_details['dashboard']['id'] ? graph_details['dashboard']['id'] : node['grack']['graph_defaults']['dashboard']['id']
      dashboard_name = graph_details['dashboard'] && graph_details['dashboard']['name'] ? graph_details['dashboard']['name'] : node['grack']['graph_defaults']['dashboard']['name']
      hour = graph_details['hour'] ? graph_details['hour'].to_s : node['grack']['graph_defaults']['hour']
      minute = graph_details['minute'] ? graph_details['minute'].to_s : node['grack']['graph_defaults']['minute']
      org_id = graph_details['dashboard'] && graph_details['dashboard']['org_id'] ? graph_details['dashboard']['org_id'] : node['grack']['graph_defaults']['dashboard']['org_id']
      past_hours = graph_details['past_hours'] ? graph_details['past_hours'] : node['grack']['graph_defaults']['past_hours']
      slack_channel = graph_details['slack_channel'] ? graph_details['slack_channel'] : node['grack']['graph_defaults']['slack_channel']
      sleep_time = graph_details['sleep_time'] ? graph_details['sleep_time'] : node['grack']['graph_defaults']['sleep_time']
      variables = graph_details['variables'] ? graph_details['variables'] : node['grack']['graph_defaults']['variables']

      if variables
        formatted_variables=nil
        variables.each do |key,value|
          formatted_variables="#{formatted_variables}&var-#{key}=#{value}"
        end
      end

      cron graph_name do
        command "sleep #{sleep_time}; #{node['grack']['directory']}/grack.sh #{dashboard_id} #{dashboard_name} #{org_id} #{graph_details['panel_id']} \"#{formatted_variables}\" #{graph_name} #{slack_channel} #{past_hours} 2>&1 | logger -t grack.log"
        hour hour
        minute minute
        user node['grack']['username']
      end
    end
  end
end
