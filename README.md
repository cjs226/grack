# grack Cookbook

This cookbook provides resources for configuring and managing cron jobs to send Grafana graphs to Slack.
![Grack in the wild](https://raw.githubusercontent.com/cjs226/grack/master/images/grack.png)

## Steps to get it up and running

- Create a Data Bag named grack
- Generate a Grafana API Key
- Store the key in an encrypted Data Bag Item name grafana in the grack Data Bag with the key `api_key`.
- Example:
  ```
  {
    "id": "grafana",
    "api_key": "abc123oibTdsYWRTMWtMUnFWR2pGRlpjenRUMWRCMndERmZIV3YiLCJuIjoicmVhZG9ubHkiLCJpZCI6MX0="
  }
  ```
- Generate a Slack API Token
- Store store the token in an encrypted Data Bag Item named slack in the grack Data Bag with the key `api_token`.
- Example:
  ```
  {
    "id": "slack",
    "api_token": "xoxb-abc12371906-o2HBliCwGgG3R4GS6TPcGzYk"
  }
  ```
- Set the following attributes
  - `node['grack']['graphs']['name_of_graph']['dashboard']['name']`: Grafana dashboard name
    - The name of the Grafana dashboard housing the graph you want to send to Slack.  It can be found via the Grafana URL for the dashboard itself.
    - Example:  https://foobar.com/d/abcdefghi/**mysql**/...
  - `node['grack']['graphs']['name_of_graph']['dashboard']['id']`: Grafana dashboard id
    - The value immediately preceding the name of the dashboard in your Grafana url.
    - Example:  https://foobar.com/d/**abcdefghi**/...
  - `node['grack']['graphs']['name_of_graph']['dashboard']['org_id']`: Grafana org ID
    - The id of your Grafana organization.  It can be found via the Grafana URL for the dashboard itself.
    - Example: https://foobar.com/d/abcdefghi/mysql?panelId=20&**orgId=1**...
  - `node['grack']['grafana']['name_of_graph']['dashboard']['variables']`: Any Grafana variables the graph depends on
    - IF you're using variables they can be found in the dashboards URL
    - Example: https://foobar.com/d/abcdefghi/mysql?panelId=20&orgId=1&**var-datasource=telegraf&var-region=ireland&var-environment=production**...
  - `node['grack']['graphs']['name_of_graph']['hour']`: Hour to send the graph.  Default is 0
  - `node['grack']['graphs']['name_of_graph']['minute']`: Minute to send the graph.  Default is 30
  - `node['grack']['graphs']['name_of_graph']['panel_id']`: Grafana graph panel ID
    - The panel ID of the graph itself.  Click on the title of the graph, click on share and it will be listed as the panelId in the URL.
    - Example: https://foobar.com/d/abcdefghi/mysql?**panelId=20**...
  - `node['grack']['graphs']['name_of_graph']['past_hours']`: Number of hours, in the past, to graph.  Default is 24
  - `node['grack']['graphs']['name_of_graph']['slack_channel']`: Slack channel to send graph to
  - `node['grack']['graphs']['name_of_graph']['sleep_time']`: Amount of seconds to sleep before generating the graph.  This is helpful if you're sending a number of graphs during the same minute and would like them sent in the same order each time.
  - `node['grack']['grafana']['host']`: The fqdn of the Grafana server.  Default is localhost
  - Example:
    ```
      "grack" => {
        "graphs" => {
          "ireland_production_cpu" => {
            "dashboard" => {
              "name" => "mysql,
              "id" => 'abcdefghi',
              "org_id" => 1
             },
            "hour" => 12,
            "minute" => 0,
            "panel_id" => 4,
            "past_hours" => 12,
            "slack_channel" => "ireland_production_status"
          }
        },
        "grafana" => {
          "host" => "foo.bar"
      },
      ```

## Setting defaults

You can set _graph_defaults_ to simplify your config:
- Example:
  ```
    "grack" => {
      "graph_defaults" => {
        "dashboard" => {
          "name" => "mysql",
          "id" => "abcdefghi',
          "org_id" => 1,
          "variables" => {
            "datasource" => "telegraf",
            "environment" => "production"
          },
        "hour" => 12,
        "minute" => 0,
        "slack_channel" => "ireland_production_status"
      },
      "graphs" => {
        "ireland_mysql_connections" => {
          "panel_id" => 5,
          "sleep_time" => 2
        },
        "ireland_mysql_cpu" => {
          "panel_id" => 4
        },
        "ireland_mysql_cpu_for_the_past_7_days" => {
          "hour" => 8,
          "panel_id" => 4,
          "past_hours" => 168
        }
      },
      "grafana" => {
        "host" => "foo.bar"
    },
  ```

## Removing cron jobs

To remove an existing cron job, set the graph's delete key to true:
- `node['grack']['graphs'][''name_of_graph'']['delete']`: true
- Example:
  ```
      "grack" => {
        "graphs" => {
          "ireland_mysql_connections" => {
            "delete" => true
          }
  ``

## License and Authors

- Author:: Clif Smith ([yo@clif.wtf](mailto:yo@clif.wtf))

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
