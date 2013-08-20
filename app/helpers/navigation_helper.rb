module NavigationHelper

  def link_to_delete(url, options={})
    name = options[:name] || t(:delete)
    link_to name, url,
      :class => "delete-resource",
      :data => { :confirm => t(:are_you_sure) }
  end
end