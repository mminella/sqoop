#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
function print_usage(){
  echo "Usage: sqoop.sh COMMAND"
  echo "       where COMMAND is one of:"
  echo "  server <start/stop>    Start/stop the server"
  echo "  client [script]        Start an interactive shell without a script"
  echo "                         or run a script with a batch shell"
  echo ""
}

if [ $# = 0 ]; then
  print_usage
  exit
fi

OLD_DIR=`pwd`
CUR_DIR=`cd $(dirname $(which $0))/..; pwd`
cd ${CUR_DIR}
echo "Sqoop home directory: ${CUR_DIR}..."

COMMAND=$1
case $COMMAND in
  server)
    if [ $# = 1 ]; then
      echo "Usage: sqoop.sh server <start/stop>"
      exit
    fi

    server/bin/catalina.sh $2
    ;;

  client)
    for f in client/lib/*.jar; do
      CLASSPATH=${CLASSPATH}:$f;
    done

    java -classpath ${CLASSPATH} org.apache.sqoop.client.shell.SqoopShell $2
    ;;

  *)
    echo "Command is not recognized."
    ;;
esac

cd ${OLD_DIR}