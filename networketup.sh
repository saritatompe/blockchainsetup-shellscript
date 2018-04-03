

function dinstall(){

	echo "======Docker installation======" 
	
	#	echo "--switch to root---"
	#	sudo su

		echo "Install docker"
  		# command
	
		echo "---First, add the GPG key for the official Docker repository to the system----"
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

		echo "---Add the Docker repository to APT sources: ---"
		 sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable'

		echo "---update the package database with the Docker packages from the newly added repo:---"
	 	sudo apt-get update

		echo "---Make sure you are about to install from the Docker repo instead of the default Ubuntu 16.04 repo:---"
		apt-cache policy docker-ce

		echo "--- install Docker:----"
		sudo  apt-get install -y docker-ce

		echo "---Docker version ---"
		docker version
	
	
}
function dcompose(){
	
	echo "=====Dcoker compose installation=========="

	echo "---We'll check the current release and if necessary, update it in the command below:-----"
	sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

	echo "---we'll set the permissions:-----"
	sudo chmod +x /usr/local/bin/docker-compose


	echo "---verify that the installation was successful by checking the version:---"
	docker-compose --version

}

function goinstall(){
	
	echo "================INSTALL GO ================"
	
	echo "------To download Go language binary archive file-----"
	wget https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz

	echo "----- extract the downloaded archive file and move to the desired location on system-----"
	sudo tar -zxvf go1.7.1.linux-amd64.tar.gz -C /usr/local/

	echo "----Setting Go Environment--------"
	export GOROOT=/usr/local/go
	
	echo "--- Enter directory where you want to install go path --"
	read directory
	export directory
	cd /usr/
	sudo mkdir $directory
	sudo chmod -R 777 $directory
	ls	
	
	export GOPATH=/usr/$directory/go
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
	echo $GOPATH
	echo $PATH
	
	apt install golang-go
	go env 
	
	
}


function setup(){
	echo "----------------------------------------------------------------"
	echo "==============BLOCKCHAIN SETUP STARTS============================"
	echo "----------------------------------------------------------------"

	cd /usr/$directory/	
	pwd
	sudo mkdir src
	cd src/
	sudo mkdir github.com
	cd github.com
	cd ..

	cd github.com/
	sudo mkdir hyperledger
	
	cd hyperledger/
	
	echo "------------------GIT CLONE-------------------" 
	sudo git clone -b release-1.0 --single-branch https://github.com/hyperledger/fabric.git
	cd ..

	

	curl -sSL https://goo.gl/6wtTN5|bash -s 1.1.0-rc1
         sudo mkdir conf
         cd bin/
         mv ./* ../conf/

         cd ..
         sudo cp hyperledger/fabric/examples/e2e_cli/crypto-config.yaml ./conf/
         cd conf/
	 ./cryptogen generate --config=./crypto-config.yaml
	cd ..
	sudo cp hyperledger/fabric/examples/e2e_cli/configtx.yaml ./conf/
	 cd conf/ 
	
         export CHANNEL_NAME=mychannel
         sudo mkdir channel-artifacts
         cd channel-artifacts/
         echo $CHANNEL_NAME
         cd ..
        ./configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
        ./configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

         cd ..
         sudo cp ./hyperledger/fabric/test/feature/docker-compose/docker-compose-solo.yml ./conf
         cd conf
         ./configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
         ./configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

        sudo mkdir base
        sudo cp ../hyperledger/fabric/examples/e2e_cli/base/docker-compose-base.yaml ./base/
        sudo cp ../hyperledger/fabric/examples/e2e_cli/base/peer-base.yaml ./base/
         sudo cp ../hyperledger/fabric/examples/e2e_cli/docker-compose-cli.yaml ./


        docker-compose -f docker-compose-cli.yaml up -d




		

}

function c(){
echo $directory
}





function setupnetwork(){

	#dinstall
	#dcompose
	goinstall
	setup
}


setupnetwork

