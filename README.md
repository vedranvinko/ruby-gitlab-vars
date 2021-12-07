# ruby-gitlab-ci-vars

Quick parser for JSON containing CI vars in GitLab projects

Code generated by lovely people at [quicktype](https://app.quicktype.io/)

### Usage

NOTE: This is only parser, you have to get data in some other way

```ruby
vars = Vars.from_json! "input"
puts vars[1].key # puts key for first var
```