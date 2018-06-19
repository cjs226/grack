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
      dashboard = graph_details['dashboard'] ? graph_details['dashboard'].to_s : node['grack']['graph_defaults']['dashboard']
      hour = graph_details['hour'] ? graph_details['hour'].to_s : node['grack']['graph_defaults']['hour']
      minute = graph_details['minute'] ? graph_details['minute'].to_s : node['grack']['graph_defaults']['minute']
      past_hours = graph_details['past_hours'] ? graph_details['past_hours'] : node['grack']['graph_defaults']['past_hours']
      slack_channel = graph_details['slack_channel'] ? graph_details['slack_channel'] : node['grack']['graph_defaults']['slack_channel']

      cron graph_name do
        command "#{node['grack']['directory']}/grack.sh #{dashboard} #{graph_details['panel_id']} #{graph_name} #{slack_channel} #{past_hours} 2>&1 | logger -t grack.log"
        hour hour
        minute minute
        user node['grack']['username']
      end
    end
  end
end
