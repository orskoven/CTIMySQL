To set up the CTI projects—CTIMySQL, CTIMongoDB, and CTINeo4j—in your test environment, follow this comprehensive installation guide. Each project is hosted on GitHub and involves different database systems. Ensure you have the necessary prerequisites installed before proceeding with the installation steps for each project.

Prerequisites:
	•	Java Development Kit (JDK):
	•	Ensure JDK 8 or higher is installed. Verify by running java -version.
	•	Apache Maven:
	•	Install Maven for project build and dependency management. Confirm installation with mvn -version.
	•	Git:
	•	Ensure Git is installed to clone repositories. Check with git --version.

1. CTIMySQL Installation:

Repository: CTIMySQL
	•	MySQL Server:
	•	Install MySQL Server version 5.7 or higher.
	•	Start the MySQL service and set up a root password.
	•	Clone the Repository:

git clone https://github.com/orskoven/CTIMySQL.git
cd CTIMySQL


	•	Configure the Database:
	•	Access the MySQL command line interface:

mysql -u root -p


	•	Create a new database:

CREATE DATABASE cti_db;
USE cti_db;


	•	Execute the provided SQL scripts to set up the database schema and insert test data:

SOURCE path/to/DDL.sql;
SOURCE path/to/RBAC_GDPR.sql;
SOURCE path/to/Rolebase_merge_cti.sql;
SOURCE path/to/DATAmysql_dump_data.sql;

Replace path/to/ with the actual paths to the SQL files.

	•	Configure the Application:
	•	Navigate to the src/main/resources directory.
	•	Locate the application.properties file.
	•	Update the database connection properties:

spring.datasource.url=jdbc:mysql://localhost:3306/cti_db
spring.datasource.username=root
spring.datasource.password=your_password

Replace your_password with your MySQL root password.

	•	Build and Run the Application:

mvn clean install
mvn spring-boot:run

Access the application at http://localhost:8080.

2. CTIMongoDB Installation:

Repository: CTIMongoDB
	•	MongoDB Server:
	•	Install MongoDB version 4.0 or higher.
	•	Start the MongoDB service.
	•	Clone the Repository:

git clone https://github.com/orskoven/CTIMongoDB.git
cd CTIMongoDB


	•	Import the Database:
	•	Use the mongoimport tool to load the provided document.json file into MongoDB:

mongoimport --db cti_db --collection your_collection --file path/to/document.json --jsonArray

Replace your_collection with the desired collection name and path/to/ with the actual path to the document.json file.

	•	Configure the Application:
	•	Navigate to the src/main/resources directory.
	•	Locate the application.properties file.
	•	Update the MongoDB connection properties:

spring.data.mongodb.uri=mongodb://localhost:27017/cti_db


	•	Build and Run the Application:

mvn clean install
mvn spring-boot:run

Access the application at http://localhost:8080.

3. CTINeo4j Installation:

Repository: CTINeo4j
	•	Neo4j Server:
	•	Install Neo4j version 3.5 or higher.
	•	Start the Neo4j service.
	•	Clone the Repository:

git clone https://github.com/orskoven/CTINeo4j.git
cd CTINeo4j


	•	Import the Database:
	•	Use the Cypher shell to execute the neo4j.cypher script:

cypher-shell -u neo4j -p your_password -f path/to/neo4j.cypher

Replace your_password with your Neo4j password and path/to/ with the actual path to the neo4j.cypher file.

	•	Configure the Application:
	•	Navigate to the src/main/resources directory.
	•	Locate the application.properties file.
	•	Update the Neo4j connection properties:

spring.neo4j.uri=bolt://localhost:7687
spring.neo4j.authentication.username=neo4j
spring.neo4j.authentication.password=your_password

Replace your_password with your Neo4j password.

	•	Build and Run the Application:

mvn clean install
mvn spring-boot:run

Access the application at http://localhost:8080.

General Notes:
	•	Port Conflicts:
	•	Ensure that the default ports used by MySQL (3306), MongoDB (27017), and Neo4j (7687) are not occupied by other services.
	•	Environment Variables:
	•	Alternatively, you can set environment variables for database credentials instead of hardcoding them in the application.properties files.
	•	Security Considerations:
	•	For production environments, implement proper security measures, such as using strong passwords, configuring firewalls, and enabling SSL connections.

By following these steps, you will set up the CTIMySQL, CTIMongoDB, and CTINeo4j projects in your test environment, each accessible at http://localhost:8080. Ensure to replace placeholder values with your actual configuration details during setup.