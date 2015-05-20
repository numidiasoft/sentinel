# Sentinel App

Sentinel
([tigerlily/sentinel](https://github.com/tigerlily/sentinel)) is a web application 
that aims to monitors all internals and externals used by your stack.

For example: Facebook, twitter..etc.


### Setup

 ```bash
  
  cd api && cp bundle install --path=.bundle
  cp config/mongoid.yml.example config/mongoid.yml
  
 ```
 
### Open console

  ```bash
  
    RACK_ENV=staging bundle exec ./script/console
    
  ```
### Start server

```bash

   RACK_ENV=staging bundle exec rackup --quiet
   
```

### Workflow

Branch off your feature branches from development.
 
