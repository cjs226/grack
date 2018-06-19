group node['grack']['group'] do
  system true
end

user node['grack']['username'] do
  comment 'Grack User'
  group node['grack']['group']
  home node['grack']['directory']
  manage_home true
  shell '/bin/false'
  system true
end

template "#{node['grack']['directory']}/grack.sh" do
  source 'grack.sh.erb'
  variables(
    :grafana_api_key => Chef::EncryptedDataBagItem.load('grack', 'grafana')['api_key'],
    :grafana_host => node['grack']['grafana']['host'],
    :slack_api_token => Chef::EncryptedDataBagItem.load('grack', 'slack')['api_token'],
    :temp_dir => node['grack']['temp_dir']
  )
  owner node['grack']['username']
  group node['grack']['group']
  mode 0500
end
