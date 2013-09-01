module NavigationHelper

  def link_to_delete(url, options={})
    name = options[:name] || t(:delete)
    link_to name, "#",
      :class => "delete-resource",
      :data => { :confirm => t(:are_you_sure) },
      :"data-url" => url
  end

  def link_to_feature(url, options={})
    name = options[:name] || t(:feature)
    link_to name, "#",
      :class => "toggle-feature",
      :"data-url" => url
  end
end