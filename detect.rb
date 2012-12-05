class Detect
  attr_reader :agent
  def initialize url, agent = nil
    @url = url
    @agent = agent || get_agent
    @doc = get_doc
  end

  def haz?
    paths_with_ic_source.count > 0
  end

  def styles
    styles = []
    paths.each do |path|
      style = Style.new(path)
      styles << style.name unless styles.include? style.name
    end
    styles
  end

  def paths
   paths = []
    @doc.search("img").each do |img|
      src = img.attributes["src"]
      paths << src if src =~ STYLE_RE
    end
    paths
  end

  def potentials limit = 100, override_styles = nil
    counter = 0;
    limit = limit.to_i
    styles = override_styles || styles()

    potentials = []
    styles.each do |style|
      paths.each do |path|
        counter += 1
        if (counter <= limit)
          so = Style.new(path)
          potentials << so.mixmash(style, path)
        end
      end
    end

    if (potentials.count < limit)
      nested potentials, limit
    else
      potentials
    end
  end

  private
  def get_agent
    @agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
  end

  def get_doc
    @doc = Hpricot(@agent.get(@url).content)
  end

  def nested potentials, limit
    nested = []

    amount_runs = (limit / potentials.count).to_i

    potentials.each do |path|
      style = Style.new(path)
      amount_runs.times do
        style = style.nested
        #http://stackoverflow.com/questions/1289585/what-is-apaches-maximum-url-length
        nested << style.url unless style.url.length > 4000
      end
    end

    nested
  end
end
