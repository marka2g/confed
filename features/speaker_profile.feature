Feature: Speaker Profile
  In order to learn more about a speaker
  As a site visitor
  I want to view a profile page for a speaker

  Scenario: Viewing a speaker with all information provided
    Given a speaker with the following:
      | Name            | Adam                                     |
      | Title           | Software Craftsman                       |
      | Location        | Chicago, IL                              |
      | Bio             | Too much to put in a test                |
      | Company Name    | Foo Inc.                                 |
      | Company URL     | http://foo.com                           |
      | Email           | adam@foo.com                             |
      | Twitter         | adamfoo                                  |
      | Website         | http://blog.com                          |
      | Speaker Rate Id | 111-adam                                 |
    And  I am hitting an external service for an avatar
    When I am on the speaker information page
    Then I should see "Adam"
    #Then I should see "Software Craftsman"
    #Then I should see "Chicago, IL"
    Then I should see "Too much to put in a test"
    Then I should see an external link "Foo Inc." to "http://foo.com"
    Then I should see an external link "Website" to "http://blog.com"
    Then I should see an external link "Twitter" to "http://twitter.com/adamfoo"
    Then I should not see "adam@foo.com"
    Then I should not see "111-adam"

  Scenario: Hide missing external links
    Given a speaker with the following:
      | Name     | Adam               |
      | Title    | Software Craftsman |
      | Location | Chicago, IL        |
    When I am on the speaker information page
    Then I should not see links:
      | Twitter |
      | Website |

  Scenario: Link to presentations
    Given a speaker
    And   the speaker has a presentation with the following:
      | Title    | BDD in Ruby |
      | Released | true        |
    And   I am hitting an external service for url shortening
    And   I am on the speaker information page
    When  I follow "BDD in Ruby"
    Then  I should be on the presentation page

  Scenario: No released presentations are available
    Given a speaker
    And the speaker has a presentation with the following:
      | Title    | BDD in Ruby |
      | Released | false       |
    When I am on the speaker information page
    Then I should see "No presentations are currently available for this speaker"

  Scenario: Has an avatar image
    Given a speaker
    When  I am on the speaker information page
    Then  I should see avatar image

  Scenario: Has page title
    Given a speaker
    When  I am on the speaker information page
    Then  I should see page title as "Jeffrey Lebowski - Confed"
