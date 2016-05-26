# [Travis now natively supports cron jobs](https://docs.travis-ci.com/user/cron-jobs)

# Deprecated readme

Run travis as cron (also supports travis PRO)

Try locally:
```
cp config{.example,}.yml
# edit config.yml
bundle exec rake cron
```

Heroku
======
setup production section in config.yml
```
heroku create traviscron
rake heroku:configure           # copies config.yml into heroku ENV
git push heroku

# make sure everything is set up correctly
heroku run rake cron
```

### configure scheduler
```
heroku addons:add scheduler
heroku addons:open scheduler
```

add `bundle exec rake cron` daily

Monitoring
==========
 - Setup a [dead man switch](https://deadmanssnitch.com/r/e02191e260) so you know the cron is still running and then change the cron to: `bundle exec rake cron && curl https://nosnch.in/xxxxx`
 - Setup a airbrake project to monitor errors and add `:report_errors_to:` to config.yml

Author
======
[Michael Grosser](http://grosser.it)
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/travis_cron.png)](https://travis-ci.org/grosser/travis_cron)
