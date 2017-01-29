#!/bin/bash
docker build -t mysql_for_tests_step_1 .
MYSQL_CONTAINER_ID=`docker run -d mysql_for_tests_step_1`
docker cp init_data.sql $MYSQL_CONTAINER_ID:/

echo "Waiting until $MYSQL_CONTAINER_ID finishes initialization"
tries="0"
while [ $tries -lt 120 ]  # 120 tries, 4 per second gives 30 s timeout
do
    docker exec -it $MYSQL_CONTAINER_ID /bin/bash -c "mysql -u root -proot -e 'SELECT 1' 2>/dev/null"
    if [ $? -ne 0 ]; then
        tries=$[$tries+1]
        sleep 0.25
    else
        docker exec -it $MYSQL_CONTAINER_ID /bin/bash -c "mysql -u root -proot < /init_data.sql"
        if [ $? -ne 0 ]; then
            echo "failed to initialize DB"
            exit $?
        fi
        docker commit $MYSQL_CONTAINER_ID mysql_initialized:latest
        docker rm --force $MYSQL_CONTAINER_ID
        exit 0
    fi
done

echo "Connection attempt timed out"
exit 1
