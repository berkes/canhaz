class Style
  attr_reader :url_to_styles, :name, :field_name, :file_path
  def initialize full_url
    matches = full_url.match(/^(.*\/styles\/)([^\/]*)\/((.*)\/([^\/]*)(\/\w+\.\w+))$/)

    @url_to_styles = matches[1]
    @name = matches[2]
    @field_name = matches[5]
    @file_path = matches[3]
  end

  # @TODO: needs to check the regexp a little better then this. Causes many false positives.
  def vulnarable?
    return false if @name.nil?
    return true
  end

  def name=(name)
    @name = name
  end

  def url
    "#{@url_to_styles}#{@name}/#{@file_path}"
  end

  def nested
    Style.new(nested_url)
  end

  private
  # http://dic.audrey/sites/default/files/styles/large/public/field/image/news.jpg
  # http://dic.audrey/sites/default/files/styles/large/public/styles/large/public/field/image/news.jpg
  def nested_path
    "#{@name}/public/styles/#{@name}/#{@file_path}"
  end

  def nested_url
    "#{@url_to_styles}#{nested_path}"
  end
end
