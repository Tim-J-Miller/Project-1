# Project 1: Hive Queries


## Project Description
Enabling Hive features with querying and optimizations where the main focal point is to understand the organization and positioning of data. Followed by querying the data, loading it into HDFS , and querying it into Hive. All of these processes are accomplished on Ubuntu.

## Technology Stack
- DBeaver
- Hive
- YARN
- HDFS
- Git + GitHub


## Features
List of features ready and TODO's for future development.

### Features:
A powerpoint presentation showing the queries used and the subsequent outputs

### TODO:
Put the queries into a CLI so that the output can be produced dynamically rather than viewed statically

## Getting Started
GitHub clone URL: https://github.com/Tim-J-Miller/Project-1.git

###To see the project output
- Open the power point file to view the queries and subsequent outputs

###To produce the project output
- Enable WSL and update to WSL2 on Windows 10 
- Install Java JDK 1.8 on Windows 10
- Install Ubuntu 18+
- Install Java JDK 1.8 on Ubuntu
- Install Hadoop on Ubuntu
- Install Apache-Hive on Ubuntu
- install DBeaver
- Open Ubuntu Terminal:
    - ssh localhost
    - ~HADOOP_HOME/sbin/start-dfs.sh
    - ~HADOOP_HOME/sbin/start-yarn.sh
    - cd ~
    - hdfs dfs -mkdir /user/<username>/project1
    - hdfs dfs -mkdir /user/<username>/project1/Dataset
    - hdfs dfs -chmod 777 /user/<username>/project1
    - hdfs dfs -cp /mnt/<path to dataset>/Bev_BranchA.txt /user/project1/Bev_BranchA.txt
    - hdfs dfs -cp /mnt/<path to dataset>/Bev_BranchB.txt /user/project1/Bev_BranchB.txt
    - hdfs dfs -cp /mnt/<path to dataset>/Bev_BranchC.txt /user/project1/Bev_BranchC.txt
    - hdfs dfs -cp /mnt/<path to dataset>/Bev_ConscountA.txt /user/project1/Bev_ConscountA.txt
    - hdfs dfs -cp /mnt/<path to dataset>/Bev_ConscountB.txt /user/project1/Bev_ConscountB.txt
    - hdfs dfs -cp /mnt/<path to dataset>/Bev_ConscountC.txt /user/project1/Bev_ConscountC.txt
    - nohup hiveserver2 &
    - beeline -u jdbc:hive2://localhost:10000
  - Open DBeaver
    - Create a hive connection
    - Set hive connection as  the datasource
    - Open P1-queires.sql in DBeaver
    - Execute the queries to reproduce the outputs found in the aforemetioned powerpoint
    
    
## Contributors
- Timothy Miller
  - https://github.com/Tim-J-Miller
    
## License
