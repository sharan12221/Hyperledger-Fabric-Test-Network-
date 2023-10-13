## Running the test network

You can use the `./network.sh` script to stand up a simple Fabric test network. The test network has two peer organizations with one peer each and a single node raft ordering service. You can also use the `./network.sh` script to create channels and deploy chaincode. For more information, see [Using the Fabric test network](https://hyperledger-fabric.readthedocs.io/en/latest/test_network.html). The test network is being introduced in Fabric v2.0 as the long term replacement for the `first-network` sample.

Before you can deploy the test network, you need to follow the instructions to [Install the Samples, Binaries and Docker Images](https://hyperledger-fabric.readthedocs.io/en/latest/install.html) in the Hyperledger Fabric documentation.


# For Start the network 
* ```./network.sh -ca -s couchdb```

# For Create the Channel1 
* ```./channel1.sh```

# For Deploing and invoking the chaincode 
* ```./deploychannel1.sh```

# .....First do
* ```chmod +x channel1.sh```
* ```chmod +x deploychannel1.sh```