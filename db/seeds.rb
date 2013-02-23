#encoding: utf-8

require 'yaml'

# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#
email     = shell.ask "Which email do you want use for logging into admin?"
password  = shell.ask "Tell me the password to use:"

shell.say ""

account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

articles = StaticPage.first(:route=>'/articles')
if articles.nil?
  shell.say '/articlesページを作成します'

  body = "<notextile>
<inline_script>
-StaticPage.articles.each do |article|
  =partial :'root/article', :locals=>{:article=>article}
</inline_script>
</notextile>"
  articles = StaticPage.create(:title=>'articles', :route=>'/articles', :body=>body, :is_template=>false, :is_article=>false, :template_id=>nil)
end

articles = StaticPage.first(:route=>'/')
if articles.nil?
  shell.say '/articlesページを作成します'

  body = "<notextile>
<inline_script>
-StaticPage.articles.each do |article|
  =partial :'root/article', :locals=>{:article=>article}
</inline_script>
</notextile>"
  articles = StaticPage.create(:title=>'トップページ', :route=>'/', :body=>body, :is_template=>false, :is_article=>false, :template_id=>nil)
end

articles_template = ApplicationConfig.value(:articles_template)
if articles_template.nil?
  body = "<notextile>
<inline_script>
=partial :'root/article', :locals=>{:article=>@static_page}
</inline_script>
</notextile>"
  articles_template = StaticPage.create(:title=>'articleパーマリンク用テンプレート', :route=>'', :body=>body, :is_template=>true, :is_article=>false, :template_id=>nil)

  ApplicationConfig.create(:name=>'articles_template', :value=>articles_template.id)
end

novels_root = ApplicationConfig.value(:novels_root)
if novels_root.nil?
  novels_root = Page.create(
    :title=>'novels',
    :slug=>'',
    :description=>'',
    :body=>'',
    :parent_collection=>nil,
    :is_collection=>true,
    :is_public=>true,
    :view_count=>0)

  ApplicationConfig.create(:name=>'novels_root', :value=>novels_root.id)
end

configs = YAML.load_file('config/site_variables.yml').symbolize_keys

# Hash#deleteは値を返す。なければnil
site_name = ApplicationConfig.value(:site_name)
if site_name.nil?
  ApplicationConfig.create(:name=>:site_name, :value=>(configs[:site_name].delete || 'hollyhock'))
end

site_url = ApplicationConfig.value(:site_url)
if site_url.nil?
  ApplicationConfig.create(:name=>:site_url, :value=>(configs[:site_url].delete || 'http://donuthole.org'))
end

author = ApplicationConfig.value(:author)
if author.nil?
  ApplicationConfig.create(:name=>:author, :value=>(configs[:author].delete || 'author_name'))
end

configs.each do |k, v|
  ApplicationConfig.first_or_create(:name=>k, :value=>v)
end

shell.say ""
