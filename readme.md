To set up the CTIMySQL project in a test environment with full operational capabilities, follow these steps:

1. Prerequisites:
	•	Java Development Kit (JDK):
	•	Ensure that JDK 8 or higher is installed on your system.
	•	Verify the installation by running java -version in your command line interface.
	•	Apache Maven:
	•	Install Maven for project build and dependency management.
	•	Confirm the installation by executing mvn -version.
	•	MySQL Server:
	•	Install MySQL Server version 5.7 or higher.
	•	Secure the installation and set up a root password.

2. Clone the Repository:
	•	Use Git to clone the CTIMySQL repository:

git clone https://github.com/orskoven/CTIMySQL.git
cd CTIMySQL



3. Configure the Database:
	•	Start MySQL Server:
	•	Ensure the MySQL service is running.
	•	Create a New Database:
	•	Access the MySQL command line interface:

mysql -u root -p


	•	Create a database for the project:

CREATE DATABASE cti_db;


	•	Execute SQL Scripts:
	•	While in the MySQL CLI, select the newly created database:

USE cti_db;


	•	Execute the provided SQL scripts to set up the database schema and insert test data:

SOURCE path/to/DDL.sql;
SOURCE path/to/RBAC_GDPR.sql;
SOURCE path/to/Rolebase_merge_cti.sql;
SOURCE path/to/DATAmysql_dump_data.sql;

Replace path/to/ with the actual paths to the SQL files.

4. Configure the Application:
	•	Database Connection Settings:
	•	Navigate to the src/main/resources directory.
	•	Locate the application.properties file.
	•	Update the database connection properties to match your MySQL setup:

spring.datasource.url=jdbc:mysql://localhost:3306/cti_db
spring.datasource.username=root
spring.datasource.password=your_password

Replace your_password with the actual MySQL root password.

5. Build and Run the Application:
	•	Build the Project:
	•	From the project’s root directory, execute:

mvn clean install


	•	Run the Application:
	•	Start the application using:

mvn spring-boot:run


	•	Access the Application:
	•	Once the application starts, it should be accessible at http://localhost:8080.

6. Verify the Setup:
	•	Test Database Connectivity:
	•	Ensure the application can interact with the MySQL database without errors.
	•	Test Application Functionality:
	•	Perform CRUD operations to confirm that the application functions as expected.

7. Additional Configuration:
	•	User Roles and Permissions:
	•	Review and configure user roles and permissions as defined in the RBAC_GDPR.sql script to ensure they align with your requirements.

By following these steps, you will set up the CTIMySQL project in a test environment, enabling full operational capabilities.