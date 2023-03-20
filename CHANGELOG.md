# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.9.1] - 2023-03-20
### Changed
- Upgrade to Ruby 3.2.0
- Update Manuals
- Update Readme
- Updated Rails libraries
- Updated Javascript libraries
- Update browser requirements

## [1.1.0] - 2021-10-08
### Changed
- Add move settings to Settings files
- Add Devise views
- Add differents authentication's systems
- Add inline field update
- Add new fields into User model
- Add demo settings
- Add user samples
- Upgrade to Ruby 3
- Update Manuals
- Update Readme
- Updated Rails libraries
- Updated Javascript libraries
- Update browser requirements
- Remove compatibility with Internet Explorer 11

## [1.0.9] - 2020-12-11
### Changed
- Rails version 6.1
- Updated Rails libraries
- Updated Javascript libraries
- Fix pagination with Pagy
- Fix tooltip views

## [1.0.8] - 2020-10-08
### Changed
- Ruby version 2.7.2
- Updated Rails libraries
- Updated Javascript libraries

## [1.0.7] - 2020-09-30
### Changed
- Fixed: next visit due date management in case a risk category was first added to an employee, then removed and re-added. In this case, the application entered the next useful date by adding X months to the current date. Instead now the added date is the same as the current date as if it were a first insertion.
- Updated Rails libraries
- Updated Javascript libraries

## [1.0.5] - 2020-07-23
### Changed
- Fixed sync job
- Fixed user alert for change emergency's number
- Fixed double start of Puma into deploy
- Updated libraries

## [1.0.4] - 2020-07-01
### Changed
- Deploy procedure

## [1.0.3] - 2020-06-30
### Changed
- Fix version into publiccode.yml

## [1.0.2] - 2020-06-30
### Added
- logo svg
- roadmap
- screenshot
- secrets.yml

### Changed
- Fix reload user's view after appointment confirmation
- Fix calendar view
- Fix deploy procedure
- Fix license
- Fix readme file
- Library update

### Deleted
- Unused files
- Unused CSS classes

## [1.0.1] - 2020-06-08
### Changed
- Bumps ouma from 4.3.4 to 4.3.5. Fix CVE-2020-11076 and CVE-2020-11077
- Bumps websocket-extensions from 0.1.3 to 0.1.5. Fix CVE-2020-766 and CVE-2020-7663

## [1.0.0] - 2020-06-08
### Added
- risks management
- users management
- appointment management
