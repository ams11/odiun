module NavigationHelper

  def link_to_delete(url, options={})
    name = options[:name] || t(:delete)
    link_to name, "#",
      :class => "delete-resource",
      :data => { :confirm => t(:are_you_sure),
                 :url => url }
  end

  def link_to_feature(url, options={})
    name = options[:name] || t(:feature)
    link_to name, "#",
      :class => "toggle-feature",
      :data => { :url => url }
  end

  def tab(*args)
    options = {:label => args.first.to_s}
    if args.last.is_a?(Hash)
      options = options.merge(args.pop)
    end
    options[:route] ||=  "admin_#{args.first}"

    destination_url = options[:url] || send("#{options[:route]}_path")

    titleized_label = t(options[:label], :default => options[:label]).titleize

    link = link_to(titleized_label, destination_url)

    css_classes = []

    selected = if options[:match_path]
      matched = false
      if options[:match_path].is_a? Hash
        options[:match_path][:start_with] ||= []
        options[:match_path][:end_with] ||= []

        options[:match_path][:start_with].each do |path|
          matched = request.fullpath.gsub('//', '/').starts_with?("#{root_path}admin#{path}")
          break if matched
        end

        unless matched
          options[:match_path][:end_with].each do |path|
            matched = request.fullpath.gsub('//', '/').ends_with?(path) && !request.fullpath.gsub('//', '/').index("#{root_path}admin").nil?
            break if matched
          end
        end
      else
        matched = request.fullpath.gsub('//', '/').starts_with?("#{root_path}admin#{options[:match_path]}")
      end
      matched
    elsif options.key?(:selected)
      options[:selected]
    else
      args.include?(controller.controller_name.to_sym)
    end
    css_classes << 'selected' if selected

    if options[:css_class]
      css_classes << options[:css_class]
    end
    content_tag('li', link, :class => css_classes.join(' '))
  end
end