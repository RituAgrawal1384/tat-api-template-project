@api_test
Feature: Testing apis Graphql

  @Login
  Scenario: Testing login feature
    Given I generate random number and assign to variable "RAND_NUM"
    And I set system property "system.proxy.apply" to value "false"
    And I assign value to following variables
      | USER_NAME       | testAutomation-56789@mailinator.com |
      | PASSWORD        | Human123                            |
      | EMP_GIVEN_NAME  | Test_${RAND_NUM}                    |
      | EMP_FAMILY_NAME | Emp_${RAND_NUM}                     |
      | EMP_EMAIL       | TestEmp_${RAND_NUM}@mailinator.com  |
      | NODE            | login                               |
    Given I create connection for api service
    And I set endpoint url as "<endpoint url>"
#    And I set api header key "content-type" and value "application/json"
    And I set api headers as below
      | content-type          | application/json |
    And I set graphql request body from file "/testdata/login/login.graphql"

    And I send request "post" to api

    Then I verify response code is 200
    And I get response value for node "data.login.token" into variable "LOGIN_TOKEN"
    And I set api headers as below
      | content-type          | application/json      |
      | Authorization         | Bearer ${LOGIN_TOKEN} |
    And I set graphql request body from file "/testdata/employee/addEmployee.graphql"
    And I send request "post" to api
    Then I verify response code is 200
    And I get response value for node "data.addEmployee.id" into variable "EMP_ID"
    Then I verify response value for node "data.addEmployee.givenName" is "${EMP_GIVEN_NAME}"

  Scenario: Handling Multipart form data file
    And I assign "taf-78654@mailinator.com" to variable "USER_EMAIL"
    Given I assign "/testdata/file_upload" to variable "testdata.path"
    And I assign "${testdata.path}/input/Reg_Template.csv" to variable "INPUT_PATH"
    And I assign "${testdata.path}/output/Reg_Template.csv" to variable "OUTPUT_PATH"
    When I copy the csv template "${INPUT_PATH}" and replace following variables in output path "${OUTPUT_PATH}"
      | agent.Email | ${USER_EMAIL} |
    Given I create connection for api service
    And I set endpoint url as "<endpoint url>"
    And I set multipart key "Reg_Template.csv" as file "/testdata/file_upload/output/Reg_Template.csv"
    And I set multipart key "groupID" as text "SG_UOB"
    And I send request "post" to api
    Then I verify response code is 200

  Scenario: Access rest point
    Given I assign "false" to variable "system.proxy.apply"
    Given I create connection for api service
    And I set endpoint url as "https://www.mailinator.com/fetch_email?msgid=testautomation-5678-1602040835-78788&zone=public"
    And I send request "post" to api
    Then I verify response code is 200

  Scenario: Access rest point
    Given I assign "false" to variable "system.proxy.apply"
    Given I create connection for api service
    And I set endpoint url as "<endpoint url>"
#    And I set multipart key "client_secret" as text ""
#    And I set multipart key "client_id" as text ""
#    And I set multipart key "contact" as text ""
#    And I set multipart key "email" as text ""
    And I set multipart data as below
      | client_secret |  |
      | client_id     |  |
      | contact       |  |
      | email         |  |
    And I send request "post" to api
    Then I verify response code is 200

  Scenario: Get api
    Given I assign "false" to variable "system.proxy.apply"
    Given I create connection for api service
    And I set endpoint url as "<endpoint url>"
    And I send request "get" to api
    Then I verify response code is 200
