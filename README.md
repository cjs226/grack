# grack Cookbook

This cookbook provides resources for configuring and managing cron jobs to send Grafana graphs to Slack.
![Grack in the wild](./images/grack.png)

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
- `node['grack']['graphs']['name_of_graph']['dashboard']`: Grafana dashboard name
  - replace `name_of_graph` with the name you want Slack to set as the title of the graph
- `node['grack']['graphs']['name_of_graph']['hour']`: Hour to send the graph.  Default is 0
- `node['grack']['graphs']['name_of_graph']['minute']`: Minute to send the graph.  Default is 30
- `node['grack']['graphs']['name_of_graph']['panel_id']`: Grafana graph panel ID
- `node['grack']['graphs']['name_of_graph']['past_hours']`: Number of hours, in the past, to graph.  Default is 24
- `node['grack']['graphs']['name_of_graph']['slack_channel']`: Slack channel to send graph to
- `node['grack']['grafana']['host']`: If Grafana is NOT running locally, set to the fqdn of the Grafana server
- Example:
  ```
  "grack" => {
    "graphs" => {
      "ireland_mysql_cpu" => {
        "dashboard" => "ireland_production",
        "hour" => 8,
        "minute" => 0,
        "panel_id" => 4,
        "past_hours" => 168,
        "slack_channel" => "ireland_production_status"
    },
    "grafana" => {
      "host" => "foo.bar"
  },
  ```

## Setting defaults

You can set _graph_defaults_:
- `node['grack']['graph_defaults']['name_of_graph']['dashboard']`: 'ireland_production'
- `node['grack']['graph_defaults']['name_of_graph']['hour']`: 8
- `node['grack']['graph_defaults']['name_of_graph']['minute']`: 0
- `node['grack']['graph_defaults']['name_of_graph']['slack_channel']`: 'ireland_status'
- Example:
  ```
    "grack" => {
      "graph_defaults" => {
        "dashboard" => "ireland_production",
        "hour" => 12,
        "minute" => 0,
        "slack_channel" => "ireland_production_status"
      },
      "graphs" => {
        "ireland_mysql_connections" => {
          "panel_id" => 5
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
