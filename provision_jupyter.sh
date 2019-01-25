#! /bin/bash
# make sure this file and your environment.yml are in the home folder, ~, please
JUPYTER_PORT=8888
JUPYER_PASSWORD=mypassword

DEBIAN_FRONTEND=noninteractive
sudo rm /etc/apt/apt.conf.d/*.*
sudo apt update

mkdir downloads
mkdir .cert
cd downloads
wget https://repo.continuum.io/archive/Anaconda3-2018.12-Linux-x86_64.sh
bash Anaconda3-2018.12-Linux-x86_64.sh -b -p $HOME/anaconda3
export PATH=$HOME/anaconda3/bin:$PATH
echo 'export PATH=$HOME/anaconda3/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

sudo apt -y upgrade --force-yes
sudo apt -y autoremove

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $HOME/.cert/mykey.key -out $HOME/.cert/mycert.pem -subj "/C=SG/ST=Singapore/L=Singapore/O=AI Singapore/OU=Industry Innovation/CN=aisingapore.org"

jupyter notebook --generate-config
SHA1_PWD=$(echo -n $JUPYTER_PASSWORD | sha1sum | awk '{print $1}')
echo "PASSWORD SET"
echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.certfile = u'$HOME/.cert/mycert.pem'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.keyfile = u'$HOME/.cert/mykey.key'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.token = '$JUPYTER_PASSWORD'" >> ~/.jupyter/jupyter_notebook_config.py
sudo ufw allow $JUPYTER_PORT/tcp

cd ..
rm -r downloads
conda env create -f environment.yml

jupyter notebook



