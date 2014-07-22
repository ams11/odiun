module NavigationHelper

  def link_to_delete(video, options={})
    name = options[:name] || t(:delete)
    name = (icon('delete') + ' ' + name) unless options[:no_icon]
    options.delete(:no_icon)
    url = options[:url] || video_url(video)
    link_to name, url,
      :class => options[:class_name] || "delete-resource",
      :data  => { :confirm => options[:confirm] || t(:are_you_sure),
                  :url => url }
  end

  def link_to_feature(url, options={})
    name = options[:name] || t(:feature)
    link_to name, "#",
      :class => "toggle-feature",
      :data => { :url => url,
                 :action => "feature" }
  end

  def link_to_admin_edit(video, options={})
    name = options[:name] || t(:edit)
    name = (icon('edit') + ' ' + name) unless options[:no_icon]
    url = options[:url] || edit_admin_video_url(video)
    link_options = options.key?(:class_name) ? { :class => options[:class_name] } : {}
    link_to name, url, link_options
  end

  def link_to_view(video, options={})
    name = icon(options[:icon] || 'play') + ' ' + (options[:name] || t(:watch))
    url = options[:url] || video_url(video)
    link_to name, url, :title => video.try(:name)
  end

  def approve_video_link video, options={}
    return "" if video.nil? || video.approved?

    name = options[:name] || t(:approve)
    url = options[:url] || admin_video_approve_url(video)
    link_to name, url,
            :class => "bolded approve-video",
            :data => { :url => url,
                       :action => "approve"}
  end

  def icon(icon_name = nil, options = {})
    class_option = options[:no_class] ? {} : { :class => "icon" }
    icon_name.blank? ? '' : image_tag("admin/icons/#{icon_name}.png", class_option)
  end

  def button(text, icon_name = nil, button_type = 'submit', options={})
    button_tag(content_tag('span', icon(icon_name) + ' ' + text), options.merge(:type => button_type))
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