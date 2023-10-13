#!/bin/bash

function createUniversity() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/University.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/University.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-University --tls.certfiles ${PWD}/organizations/fabric-ca/University/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-University.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-University.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-University.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-University.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/University.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-University --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/University/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-University --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/University/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-University --id.name Universityadmin --id.secret Universityadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/University/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-University -M ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/msp --csr.hosts peer0.University.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/University/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/University.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-University -M ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls --enrollment.profile tls --csr.hosts peer0.University.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/University/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/University.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/University.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/University.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/University.example.com/tlsca/tlsca.University.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/University.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/University.example.com/peers/peer0.University.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/University.example.com/ca/ca.University.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-University -M ${PWD}/organizations/peerOrganizations/University.example.com/users/User1@University.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/University/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/University.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/University.example.com/users/User1@University.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://Universityadmin:Universityadminpw@localhost:7054 --caname ca-University -M ${PWD}/organizations/peerOrganizations/University.example.com/users/Admin@University.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/University/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/University.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/University.example.com/users/Admin@University.example.com/msp/config.yaml
}

function createCompany() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/Company.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/Company.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-Company --tls.certfiles ${PWD}/organizations/fabric-ca/Company/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-Company.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-Company.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-Company.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-Company.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/Company.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-Company --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/Company/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-Company --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/Company/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-Company --id.name Companyadmin --id.secret Companyadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/Company/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-Company -M ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/msp --csr.hosts peer0.Company.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/Company/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Company.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-Company -M ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls --enrollment.profile tls --csr.hosts peer0.Company.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/Company/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/Company.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Company.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/Company.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Company.example.com/tlsca/tlsca.Company.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/Company.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/Company.example.com/peers/peer0.Company.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/Company.example.com/ca/ca.Company.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-Company -M ${PWD}/organizations/peerOrganizations/Company.example.com/users/User1@Company.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/Company/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Company.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Company.example.com/users/User1@Company.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://Companyadmin:Companyadminpw@localhost:8054 --caname ca-Company -M ${PWD}/organizations/peerOrganizations/Company.example.com/users/Admin@Company.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/Company/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Company.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Company.example.com/users/Admin@Company.example.com/msp/config.yaml
}

function createStudent() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/Student.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/Student.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1054 --caname ca-Student --tls.certfiles ${PWD}/organizations/fabric-ca/Student/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1054-ca-Student.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1054-ca-Student.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1054-ca-Student.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1054-ca-Student.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/Student.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-Student --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/Student/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-Student --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/Student/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-Student --id.name Studentadmin --id.secret Studentadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/Student/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1054 --caname ca-Student -M ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/msp --csr.hosts peer0.Student.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/Student/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Student.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1054 --caname ca-Student -M ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls --enrollment.profile tls --csr.hosts peer0.Student.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/Student/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/Student.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Student.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/Student.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Student.example.com/tlsca/tlsca.Student.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/Student.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/Student.example.com/peers/peer0.Student.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/Student.example.com/ca/ca.Student.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1054 --caname ca-Student -M ${PWD}/organizations/peerOrganizations/Student.example.com/users/User1@Student.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/Student/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Student.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Student.example.com/users/User1@Student.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://Studentadmin:Studentadminpw@localhost:1054 --caname ca-Student -M ${PWD}/organizations/peerOrganizations/Student.example.com/users/Admin@Student.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/Student/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Student.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Student.example.com/users/Admin@Student.example.com/msp/config.yaml
}

function createVerifier() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/Verifier.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/Verifier.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1154 --caname ca-Verifier --tls.certfiles ${PWD}/organizations/fabric-ca/Verifier/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1154-ca-Verifier.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1154-ca-Verifier.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1154-ca-Verifier.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1154-ca-Verifier.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/Verifier.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-Verifier --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/Verifier/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-Verifier --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/Verifier/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-Verifier --id.name Verifieradmin --id.secret Verifieradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/Verifier/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1154 --caname ca-Verifier -M ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/msp --csr.hosts peer0.Verifier.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/Verifier/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1154 --caname ca-Verifier -M ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls --enrollment.profile tls --csr.hosts peer0.Verifier.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/Verifier/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/Verifier.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Verifier.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/Verifier.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/Verifier.example.com/tlsca/tlsca.Verifier.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/Verifier.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/peers/peer0.Verifier.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/Verifier.example.com/ca/ca.Verifier.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1154 --caname ca-Verifier -M ${PWD}/organizations/peerOrganizations/Verifier.example.com/users/User1@Verifier.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/Verifier/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Verifier.example.com/users/User1@Verifier.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://Verifieradmin:Verifieradminpw@localhost:1154 --caname ca-Verifier -M ${PWD}/organizations/peerOrganizations/Verifier.example.com/users/Admin@Verifier.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/Verifier/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/Verifier.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/Verifier.example.com/users/Admin@Verifier.example.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}
