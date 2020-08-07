# 2.0.0 (unreleased)

## Breaking changes

* Support dropped for Ruby 2.3, 2.4 and for Rails 4.2, 5.0, and 5.1

## Fixes

* Fix 'TypeError - hash key raise is not a Symbol' when used with Rails 6.0.3 [#28](https://github.com/iGEL/it/pull/28)  
  *Jason Barnabe* and *wingice*
* Fix Ruby 2.7 deprecations

# 1.0.0 (2017-06-03)

* Allow whitespace after the colon without considering it part of the value [#20](https://github.com/iGEL/it/pull/20)  
  *Russell Norris*
* Run specs with warnings enabled
* 1.0.0 Release to conform with semver 2.0

# 0.8.0 (2015-06-12)

* Make `It.plain` work with empty content [#14](https://github.com/iGEL/it/pull/14)  
  *Emil Sågfors*
* Pass though `:scope` & `:default` [#13](https://github.com/iGEL/it/pull/13)  
  *Emil Sågfors*
