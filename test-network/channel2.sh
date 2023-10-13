export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx

#Creating an application channel
configtxgen -profile Consortiums2Channel -outputCreateChannelTx ./channel-artifacts/channel2.tx -channelID channel2

########################### University ###################################

export FABRIC_CFG_PATH=$PWD/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="UniversityMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/University.example.com/users/Admin@University.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

#creating the channel
peer channel create -o localhost:7050  --ordererTLSHostnameOverride orderer.example.com -c channel2 -f ./channel-artifacts/channel2.tx --outputBlock ./channel-artifacts/channel2.block --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"


#Join peers to the channel

peer channel join -b ./channel-artifacts/channel2.block
peer channel getinfo -c channel2

########################### Company ###################################

#We can now join the Company peer to the channel.

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="CompanyMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Company.example.com/users/Admin@Company.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

#get the genesis block for Company:
peer channel fetch 0 ./channel-artifacts/channel_Company.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c channel2 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

#join Company to the channel block
peer channel join -b ./channel-artifacts/channel_Company.block

##########################################################################
############################## Set anchor peers #######################
#University

export FABRIC_CFG_PATH=$PWD/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="UniversityMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/University.example.com/users/Admin@University.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

#fetching the channel configuration
peer channel fetch config channel-artifacts/config_block.pb -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c channel2 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"


####change directory to the channel-artifacts(where channel configuration block was stored )
cd channel-artifacts


#We can now start using the configtxlator tool to start working with the channel configuration. 
configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
jq '.data.data[0].payload.data.config' config_block.json > config.json

cp config.json config_copy.json

# add the University anchor peer to the channel configuration
jq '.channel_group.groups.Application.groups.UniversityMSP.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "peer0.University.example.com","port": 7051}]},"version": "0"}}' config_copy.json > modified_config.json

#updated version of channel configuration in JSON format
configtxlator proto_encode --input config.json --type common.Config --output config.pb
configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
configtxlator compute_update --channel_id channel2 --original config.pb --updated modified_config.pb --output config_update.pb

#anchor peer update
configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"channel2", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json
configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.pb

#Navigate to the test-network directory 
cd ..

#Updating the peer channel
peer channel update -f channel-artifacts/config_update_in_envelope.pb -c channel2 -o localhost:7050  --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

