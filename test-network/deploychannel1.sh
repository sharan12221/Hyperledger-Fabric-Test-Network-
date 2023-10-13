#Going to the chaincode-go directory
cd ../asset-transfer-basic/chaincode-go
#go module to install chaincode dependences
cat go.mod

GO111MODULE=on go mod vendor

cd ../../test-network
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
peer version

#create the chaincode package
peer lifecycle chaincode package basic.tar.gz --path ../asset-transfer-basic/chaincode-go/ --lang golang --label basic_1.0

########################################################################################################################################
##################################################Install the chaincode package######################################################################################
################ on University
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="UniversityMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/University.example.com/users/Admin@University.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

# install the chaincode on peer
peer lifecycle chaincode install basic.tar.gz

###############on Company
export CORE_PEER_LOCALMSPID="CompanyMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Company.example.com/users/Admin@Company.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

# install the chaincode on peer
peer lifecycle chaincode install basic.tar.gz

###############on Student
export CORE_PEER_LOCALMSPID="StudentMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Student.example.com/users/Admin@Student.example.com/msp
export CORE_PEER_ADDRESS=localhost:1051

# install the chaincode on peer
peer lifecycle chaincode install basic.tar.gz

###############on Verifier
export CORE_PEER_LOCALMSPID="VerifierMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Verifier.example.com/users/Admin@Verifier.example.com/msp
export CORE_PEER_ADDRESS=localhost:1151

# install the chaincode on peer
peer lifecycle chaincode install basic.tar.gz

############################################################################################################################
############################### Approve a chaincode definition

peer lifecycle chaincode queryinstalled

#exporing package id 
export CC_PACKAGE_ID=basic_1.0:3cfcf67978d6b3f7c5e0375660c995b21db19c4330946079afc3925ad7306881

#######check this if error
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name basic --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"


####### direct to University
export CORE_PEER_LOCALMSPID="UniversityMSP"
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/University.example.com/users/Admin@University.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name basic --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

########direct to Student
export CORE_PEER_LOCALMSPID="StudentMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Student.example.com/users/Admin@Student.example.com/msp
export CORE_PEER_ADDRESS=localhost:1051

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name basic --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

########direct to Student
export CORE_PEER_LOCALMSPID="CompanyMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Company.example.com/users/Admin@Company.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name basic --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

#####Committing the chaincode definition to the channel
peer lifecycle chaincode checkcommitreadiness --channelID channel1 --name basic --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --output json

###########commit command also needs to be submitted by an organization admin.
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name basic --version 1.0 --sequence 1 --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/ca.crt" --peerAddresses localhost:1051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/ca.crt" --peerAddresses localhost:1151 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/ca.crt"

########confirm that the chaincode definition has been committed to the channel.
peer lifecycle chaincode querycommitted --channelID channel1 --name basic --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"


#############################Invoking the chaincode
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C channel1 -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/ca.crt" --peerAddresses localhost:1051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/ca.crt" --peerAddresses localhost:1151 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'

###############query
peer chaincode query -C channel1 -n basic -c '{"Args":["GetAllAssets"]}'
