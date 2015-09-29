# Sentinel App

Sentinel
([tigerlily/sentinel](https://github.com/tigerlily/sentinel)) is a web application 
that aims to monitor all internals and externals services used by your stack.

For example: Facebook, twitter..etc.


### Setup
 * Install docker machine from : https://docs.docker.com/machine/install-machine/
 * Install docker compose  from : https://docs.docker.com/installation/mac/
 * Create your machine : 
 
 ```bash
   docker-machine create --driver=virtualbox --virtualbox-disk-size 5000 --virtualbox-memory 4024 sentinel-dev
 ```
 If you type the command below, the list of started machines will be displayed : 
 ```bash
   docker_machine ls
 ```
 
 * Start all services
 
 ```
  docker-compose up -d
 ```
 
### Open console
  * Configure your shell : 
 
  ```
     eval "$(docker-machine env sentinel-dev)"
  ```
  * Connect to the console : 
 
  ```
   ./script/docker/console
  ```
  
### Display started services : 

```
 docker-compose ps
```

### Workflow

Branch off your feature branches from development.
 
