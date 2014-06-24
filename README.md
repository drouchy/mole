# Mole

Tail the logs of multiple services deployed on different servers

## features

* tail the log
* bounce on a gateway host
* group all you services per environment

## requirements:

* [elixir 0.14.x](http://elixir-lang.org)

## changelog

**0.0.2** *2014-06-23*

* can log multiple services in the same environment

**0.0.1** *2014-06-21*

* can log a service
* list environments in the config file

## usage

tail the log of a service

```shell
mole -e staging -s log_service
```

you can tail multiple services on the same environments
```shell
mole -e production -S frontend_service,backend_service
```

## building from sources

clone this repository

```shell
MIX_ENV=prod mix deps.get
MIX_ENV=prod mix escriptize
```

You can find the executable _build/mole

## config file

mole requires a config file where you define all you services, ssh configuration...

You can find an example of this file in the test fixtures: [example](https://github.com/drouchy/mole/blob/master/test/fixtures/config/regular.json)

Edit you config file ~/.mole/config.json

```json
{
  "global" : {
    "user" : "usename",  # login used by ssh to connect to the machine
    "ssh_dir" : "~/.ssh" # path where the ssh keys are located
  },
  "environments" : [
    {
      "name" : "staging",
      "gateway" : "host1.example.com", # host to connect & tunnel all the connections
      "services" : [
        {
          "name" : "log_service", # one service deployed on 2 hosts.
          "hosts" : ["log1.staging", "log2.staging"],
          "logs" : "/var/log/logstash/agent.log" # log file to tail
        }
      ]
    }
  ]
}
```

## License

This software is under GPL v3 license. See the LICENSE file for more information.
