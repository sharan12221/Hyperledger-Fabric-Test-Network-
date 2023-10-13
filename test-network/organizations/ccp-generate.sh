#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/University.example.com/tlsca/tlsca.University.example.com-cert.pem
CAPEM=organizations/peerOrganizations/University.example.com/ca/ca.University.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/University.example.com/connection-University.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/University.example.com/connection-University.yaml

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/Company.example.com/tlsca/tlsca.Company.example.com-cert.pem
CAPEM=organizations/peerOrganizations/Company.example.com/ca/ca.Company.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Company.example.com/connection-Company.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Company.example.com/connection-Company.yaml

ORG=3
P0PORT=1051
CAPORT=1054
PEERPEM=organizations/peerOrganizations/Student.example.com/tlsca/tlsca.Student.example.com-cert.pem
CAPEM=organizations/peerOrganizations/Student.example.com/ca/ca.Student.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Student.example.com/connection-Student.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Student.example.com/connection-Student.yaml

ORG=4
P0PORT=1151
CAPORT=1154
PEERPEM=organizations/peerOrganizations/Verifier.example.com/tlsca/tlsca.Verifier.example.com-cert.pem
CAPEM=organizations/peerOrganizations/Verifier.example.com/ca/ca.Verifier.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Verifier.example.com/connection-Verifier.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/Verifier.example.com/connection-Verifier.yaml
