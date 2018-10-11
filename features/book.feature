Feature: Provide a consistent standard JSON API endpoint

  In order to build interchangeable front ends
  As a JSON API developer
  I need to allow Create, Read, Update, and Delete functionality

  Background:
    Given there are Books with the following details:
      | title        | author          | hasJoeRead |
      | Meditiations | Marcus Aurelius | false        |
      | Catch 22     | Joseph Heller   | true         |
      | Cat's Cradle | Kurt Vonnegut   | true         |
  @g
  Scenario: Can get a single Book
    Given I request "/book/1" using HTTP GET
    Then the response code is 200
    And the response body contains JSON:
    """
    {
      "id": 1,
      "title": "Meditations",
      "author": "Marcus Aurelius",
      "hasJoeRead": false
    }
    """
  @c
  Scenario: Can get a collection of Book
    Given I request "/book" using HTTP GET
    Then the response code is 200
    And the response body contains JSON:
    """
    [
      {
        "id": 1,
        "title": "Meditations",
        "author": "Marcus Aurelius",
        "hasJoeRead": false
      },
      {
        "id": 2,
        "title": "Catch 22",
        "author": "Joseph Heller",
        "hasJoeRead": true
      },
      {
        "id": 3,
        "title": "Cat's Cradle",
        "author": "Kurt Vonnegut",
        "hasJoeRead": true
      }
    ]
    """
  @p
  Scenario: Can add a new Book
    Given the request body is:
      """
      {
        "title": "Catcher in the Rye",
        "author": "J D Salinger",
        "hasJoeRead": true
      },
      """
    When I request "/book" using HTTP POST
    Then the response code is 201
  @u
  Scenario: Can update an existing Book - PUT
    Given the request body is:
      """
      {
        "title": "Slaughterhouse Five",
        "author": "Kurt Vonnegut",
        "hasJoeRead": true
      }
      """
    When I request "/book/3" using HTTP PUT
    Then the response code is 204
  @a
  Scenario: Can update an existing Album - PATCH
    Given the request body is:
      """
      {
        "title": "Good as Gold",
        "hasJoeRead": false
      }
      """
    When I request "/book/2" using HTTP PATCH
    Then the response code is 204
  @d
  Scenario: Can delete an Book
    Given I request "/book/3" using HTTP GET
    Then the response code is 200
    When I request "/book/3" using HTTP DELETE
    Then the response code is 204
    When I request "/book/3" using HTTP GET
    Then the response code is 404