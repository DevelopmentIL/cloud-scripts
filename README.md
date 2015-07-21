# Cloud Scripts

Simple scripts for configure [Node.js](https://nodejs.org/) & [MongoDB](https://www.mongodb.com/)  on cloud.

**Current Support:** Ubuntu 14


## Simple Usage

```
# add some public keys
nano ~/.ssh/authorized_keys

apt-get -y update
apt-get -y install default-jre git ImageMagick

git clone https://github.com/DevelopmentIL/cloud-scripts.git
cd ./cloud-scripts

bash ./swap_create.sh 2048
bash ./ntp_setup.sh /usr/share/zoneinfo/Asia/Jerusalem
bash ./root_email.sh server@development.co.il
bash ./ssh_secure.sh 337

bash ./npm_setup.sh
bash ./logrotate_node.sh

bash ./mongo_setup.sh
bash ./mongo_backup.sh

bash ./node_setup.sh username
bash ./nginx_setup.sh

bash ./monit_setup.sh
```


License
=======

**cloud-scripts** is freely distributable under the terms of the MIT license.

Copyright (c) 2015 Moshe Simantov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.