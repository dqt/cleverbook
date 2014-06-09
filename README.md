# Facebook Autoresponder Bot
##### Tested on Ubuntu 12.10 i686  VM from [DigitalOcean](https://www.digitalocean.com/?refcode=491a07ff4e96 )

>Author: Thomas Graves  
Twitter: [@dqt](http://twitter.com/dqt)  
Email: prostitute@att.net  
Website: http://digitalgangster.com


## First install Ruby using RVM

http://rvm.io/rvm/install

## Install required gems

```
gem install koala
gem install xmpp4r
gem install xmpp4r_facebook
gem install capybara
gem install capybara-webkit
gem install selenium-webdriver
```

## Install PhantomJS

##### Adjust code to fit your environment

```
sudo apt-get install libfontconfig1
cd /usr/local/share/
wget https://phantomjs.googlecode.com/files/phantomjs-1.9.1-linux-x86_64.tar.bz2
tar xjf phantomjs-1.9.1-linux-x86_64.tar.bz2
rm -f phantomjs-1.9.1-linux-x86_64.tar.bz2
ln -s phantomjs-1.9.1-linux-x86_64 phantomjs
sudo ln -s /usr/local/share/phantomjs/bin/phantomjs /usr/bin/phantomjs
phantomjs --version
```