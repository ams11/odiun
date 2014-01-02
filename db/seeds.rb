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
    if klass.where(value).empty?
      # if there's more than one attribute in the YAML file, treat the first one as the primary key, and update the record if one exists with this primary key, but different other attribute values
      if value.count > 1
        existing = klass.where(value.first[0] => value.first[1])
        if existing.empty?
          puts "Creating #{klass.name} '#{name}'"
          klass.create(value)
        else
          puts "Updating #{klass.name} '#{name}'"
          existing[0].update_attributes(value)
        end
      else
        puts "Creating #{klass.name} '#{name}'"
        klass.create(value)
      end
    else
      puts "a #{klass.name} '#{name}' already exists"
    end
  end
end