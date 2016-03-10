require 'fabrication'

World(FabricationMethods)

Fabrication::Config.register_with_steps = true

def with_ivars(fabricator)
  @they = yield fabricator
  model = @they.last.class.to_s.underscore
  instance_variable_set("@#{model.pluralize}", @they)
  instance_variable_set("@#{model.singularize}", @they.last)
  Fabrication::Cucumber::Fabrications[model.singularize.gsub(/\W+/, '_').downcase] = @they.last
end

def replace_variables input, &post_processing
  input.gsub(/%{(\w+)}/) do
    key = Regexp.last_match[1]
    value = defined?(JsonSpec) ? JsonSpec.memory[key.to_sym].to_s : nil
    unless value
      value = self.instance_variable_get "@#{key}".to_sym
    end
    value = post_processing.call(value) if post_processing
    value
  end
end

Given /^(?:a|an) ([^"]*) with id "(.+)"$/ do |model_name, id_name|
  object = with_ivars Fabrication::Cucumber::StepFabricator.new(model_name) do |fab|
    fab.n(1)
  end
  self.instance_variable_set "@#{id_name.upcase}".to_sym, object.id
  JsonSpec.memorize id_name.upcase, object.id
end

Given /^(\d+) ([^"]*)$/ do |count, model_name|
  with_ivars Fabrication::Cucumber::StepFabricator.new(model_name) do |fab|
    fab.n(count.to_i)
  end
end

Given /^the following ([^"]*):$/ do |model_name, table|
  with_ivars Fabrication::Cucumber::StepFabricator.new(model_name) do |fab|
    fab.from_table(table)
  end
end

Given /^the following ([^"]*) with id "(.+)":$/ do |model_name, id_name, table|
  object = with_ivars(Fabrication::Cucumber::StepFabricator.new(model_name)) do |fab|
    fab.from_table(table)
  end
  self.instance_variable_set "@#{id_name.upcase}".to_sym, object.id
  JsonSpec.memorize id_name.upcase, object.id
end

Given /^the following ([^"]*) with href "(.+)":$/ do |model_name, href_name, table|
  object = with_ivars(Fabrication::Cucumber::StepFabricator.new(model_name)) do |fab|
    fab.from_table(table)
  end
  self.instance_variable_set "@#{href_name.upcase}".to_sym, "\"/#{model_name.pluralize}/#{object.id}\""
  JsonSpec.memorize href_name.upcase, "\"/#{model_name.pluralize}/#{object.id}\""
end

Given /^that ([^"]*) has the following ([^"]*):$/ do |parent, child, table|
  with_ivars Fabrication::Cucumber::StepFabricator.new(child, :parent => parent) do |fab|
    fab.from_table(table)
  end
end

Given /^that ([^"]*) has the following ([^"]*) with id "([^"]*)":$/ do |parent, child, id_name, table|
  object = with_ivars Fabrication::Cucumber::StepFabricator.new(child, :parent => parent) do |fab|
    fab.from_table(table)
  end
  self.instance_variable_set "@#{id_name.upcase}".to_sym, object.id
  JsonSpec.memorize id_name.upcase, object.id
end

Given /^that ([^"]*) has (\d+) ([^"]*)$/ do |parent, count, child|
  with_ivars Fabrication::Cucumber::StepFabricator.new(child, :parent => parent) do |fab|
    fab.n(count.to_i)
  end
end

Given /^that ([^"]*) has (?:a|an) ([^"]*) with id "(.+)"$/ do |parent, child, id_name|
  object = with_ivars Fabrication::Cucumber::StepFabricator.new(child, :parent => parent) do |fab|
    fab.n(1)
  end
  self.instance_variable_set "@#{id_name.upcase}".to_sym, object.id
  JsonSpec.memorize id_name.upcase, object.id
end

Given /^(?:that|those) (.*) belongs? to that (.*)$/ do |children, parent|
  with_ivars Fabrication::Cucumber::StepFabricator.new(parent) do |fab|
    fab.has_many(children)
  end
end

Then /^I should see (\d+) ([^"]*) in the database$/ do |count, model_name|
  Fabrication::Cucumber::StepFabricator.new(model_name).klass.count.should == count.to_i
end

Then /^I should see the following (.*) in the database:$/ do |model_name, table|
  data = table.rows_hash.reduce({}){|acc, (k,v)| acc[k] = replace_variables(v); acc}.symbolize_keys
  data.update(data){|_,v| v =~ /true|false/ ? v.to_b : v}
  klass = Fabrication::Cucumber::StepFabricator.new(model_name).klass
  klass.where(data).count.should == 1
end
