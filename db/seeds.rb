# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Dir[Rails.root.join("db/seed/*.yml")].each do |f|
  klass = f.split("/").last.slice(0..-5).classify.constantize
  yaml_data = YAML::load_file(f)
  yaml_data.each do |name, value|
    value.each do |n, v|
      if klass.where(n => v).empty?
        puts "Creating #{klass.name} '#{name}'"
        klass.create(value)
      else
        puts "a #{klass.name} '#{name}' already exists"
      end
    end
  end
end