#!/bin/sh -e

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#

toolkit_path="${NIFI_TOOLKIT_HOME}/bin"

cd ${NIFI_TOOLKIT_BASE_DIR}/certs

if [ -e "${NIFI_TOOLKIT_BASE_DIR}/certs/config.json" ] ; then
    echo 'Using existing config.json'
    
    exec ${toolkit_path}/tls-toolkit.sh server \
    --configJsonIn "config.json" \
    --configJson "config.json" \
    --useConfigJson
else
    ca_hostname=$(hostname -f)
    exec ${toolkit_path}/tls-toolkit.sh server \
    --keyAlgorithm "RSA" \
    --certificateAuthorityHostname ${ca_hostname} \
    --days 1095 \
    --dn "CN=${ca_hostname}, OU=NIFI" \
    --keySize 2048 \
    -p ${PORT:-9999} \
    --signingAlgorithm SHA256WITHRSA \
    --keyStoreType "JKS" \
    --token ${TOKEN:-"finaiappsCAToken!"}
fi