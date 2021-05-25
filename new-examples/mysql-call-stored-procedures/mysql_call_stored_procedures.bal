import ballerina/io;
import ballerinax/mysql;
import ballerina/sql;

// Student record to represent the database table.
type Student record {
    int id;
    int age;
    string name;
};
public function main() returns error? {
    // Run the prerequisite setup for the example.
    check beforeExample();

    // Initialize the MySQL client.
    mysql:Client mysqlClient = check new (user = "root",
            password = "Test@123", database = "MYSQL_BBE");

    // Create a parameterized query to invoke the procedure.
    string name = "George";
    int age = 24;
    sql:ParameterizedCallQuery sqlQuery = 
                                `CALL InsertStudent(${name}, ${age})`;

    // The stored procedure `InsertStudent` with the IN parameters is invoked. 
    sql:ProcedureCallResult retCall = check mysqlClient -> call(sqlQuery);
    io:println("Call stored procedure `InsertStudent`." +
        "\nAffected Row count: ", retCall.executionResult?.affectedRowCount);
    check retCall.close();

    // Initialize the INOUT & OUT parameters.
    sql:InOutParameter id = new (1);
    sql:IntegerOutParameter totalCount = new;
    sql:ParameterizedCallQuery sqlQuery2 = 
                        `{CALL GetCount(${id}, ${totalCount})}`;

    // The stored procedure with the OUT and INOUT parameters is invoked.
    sql:ProcedureCallResult retCall2 = check mysqlClient -> call(sqlQuery2);
    io:println("Call stored procedure `GetCount`.");
    io:println("Age of the student with id '1' : ", id.get(int));
    io:println("Total student count: ", totalCount.get(int));
    check retCall2.close();

    // Invoke the stored procedure, which returns data.
    sql:ProcedureCallResult retCall3 = 
            check mysqlClient -> call("{CALL GetStudents()}", [Student]);
    io:println("Call stored procedure `GetStudents`.");              

    // Process the returned result stream.
    stream<record{}, sql:Error>? result = retCall3.queryResult;
    if result is stream<record{}, sql:Error> {
        stream<Student, sql:Error> studentStream = 
                <stream<Student, sql:Error>> result;
        sql:Error? e = studentStream.forEach(function(Student student) {
            io:println("Student details: ", student);
        });
    }
    check retCall3.close();

    // Performs cleanup after the example.
    check afterExample(mysqlClient);
}

// Initializes the database as the prerequisite to the example.
function beforeExample() returns sql:Error? {
    mysql:Client mysqlClient = check new (user = "root", password = "Test@123");

    // Create a Database.
    sql:ExecutionResult result =
        check mysqlClient -> execute(`CREATE DATABASE MYSQL_BBE`);

    // Create a table in the database.
    result = check mysqlClient -> execute(`CREATE TABLE MYSQL_BBE.Student( id INT 
            AUTO_INCREMENT, age INT, name VARCHAR(255),PRIMARY KEY (id))`);

    // Create necessary stored procedures using the execute command.
    result = check mysqlClient -> execute(`CREATE PROCEDURE MYSQL_BBE.InsertStudent
        (IN pName VARCHAR(255), IN pAge INT) BEGIN INSERT INTO Student(age, name) 
        VALUES (pAge, pName); END`);
    result = check mysqlClient -> execute(`CREATE PROCEDURE MYSQL_BBE.GetCount(INOUT 
        pID INT, OUT totalCount INT) BEGIN SELECT age INTO pID FROM Student 
        WHERE id = pID; SELECT COUNT(*) INTO totalCount FROM Student; END`);   
    result = check mysqlClient -> execute(`CREATE PROCEDURE MYSQL_BBE.GetStudents() 
        BEGIN SELECT * FROM Student; END`);

    check mysqlClient.close();    
}

// Cleans up the database after running the example.
function afterExample(mysql:Client mysqlClient) returns sql:Error? {
    // Clean the database.
    sql:ExecutionResult result =
            check mysqlClient -> execute(`DROP DATABASE MYSQL_BBE`);

    // Close the MySQL client.
    check mysqlClient.close();
}
