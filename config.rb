Time.zone = 'Tokyo'

activate :directory_indexes

activate :blog do |blog|
  blog.name = 'articles'
  blog.prefix = 'articles'

  blog.layout = 'article_layout'
  blog.permalink = '/{year}/{month}/{day}/{title}.html'
  blog.sources = '/items/{year}-{month}-{day}-{title}.html'
  blog.new_article_template = 'article_template.erb'
  blog.default_extension = '.md'

  blog.custom_collections = {
    category: {
      link: '/categories/{category}.html',
      template: '/articles/category.html'
    }
  }
end

activate :blog do |blog|
  blog.name = 'sessions'
  blog.prefix = 'sessions'

  blog.layout = 'sessions_layout'
  blog.permalink = '/{year}/{month}/{day}/{title}.html'
  blog.sources = '/items/{year}-{month}-{day}-{title}.html'
  blog.new_article_template = 'sessions_template.erb'
  blog.default_extension = '.md'
end

activate :blog do |blog|
  blog.name = 'tips'
  blog.prefix = 'tips'

  blog.layout = 'tips_layout'
  blog.permalink = '/{title}.html'
  blog.sources = '/items/{title}.html'
  blog.new_article_template = 'tips_template.erb'
  blog.default_extension = '.md'
end

page 'sitemap.xml', layout: 'xml_layout'

helpers do
  def page_title
    if current_page.data.title
      "#{current_page.data.title} | プロダクトマネージャ―カンファレンス 2016"
    elsif yield_content(:title)
      "#{yield_content(:title)} | プロダクトマネージャーカンファレンス 2016"
    else
      'プロダクトマネージャーカンファレンス 2016 | 10/24~10/25'
    end
  end

  def page_description
    if current_page.data.description
      current_page.data.description
    elsif yield_content(:description)
      yield_content(:description)
    else
      'Japan Product Manager Conference 2016 - プロダクトマネージャーが日本を救う'
    end
  end

  def page_url
    "http://htomine.github.io/pmconf/#{current_page.url}"
  end

  def jobs
    arr = []
    data.jobs.each { |j| arr << j }
    arr
  end

  def members
    arr = []
    data.staff.organizers.each { |o| arr << o }
    arr
  end

  def speakers
    arr = []
    data.speakers.keynotes.each { |spk| arr << spk }
    data.speakers.specials.each { |sps| arr << sps }
    data.speakers.staffs.each { |spst| arr << spst }
    data.speakers.sponsors.each { |spsp| arr << spsp }
    arr
  end

  def sponsors
    arr = []
    data.sponsors.platinas.each { |sp| arr << sp }
    data.sponsors.golds.each { |sg| arr << sg }
    data.sponsors.sivers.each { |ss| arr << ss }
    data.sponsors.drinks.each { |sd| arr << sd }
    arr
  end
end

set :images_dir, 'assets/images'

configure :development do
  activate :livereload
end

configure :build do
  activate :relative_assets
end

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.branch = 'gh-pages'
  deploy.remote = "https://#{ENV['GH_TOKEN']}@github.com/htomine/pmconf.git"
  deploy.build_before = true
end

activate :external_pipeline,
         name: :webpack,
         command: build? ? './node_modules/webpack/bin/webpack.js -p --bail' : './node_modules/webpack/bin/webpack.js --watch -d',
         source: '.tmp/dist',
         latency: 1
