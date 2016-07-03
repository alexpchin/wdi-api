require "json"

usrname = ENV["GITHUB_USERNAME"]
pwd     = ENV["GITHUB_PASSWORD"]
url     =

results = `curl -u #{usrname}:#{pwd} https://api.github.com/orgs/ga-wdi-exercises/repos`

results = JSON.parse(results)

exercises = results.map do |result| 
  {
    name:        result['name'],
    clone_url:   result['clone_url'],
    description: result['description'],
    tags:        result['description'].scan(/(?<=\[).+?(?=\])/).first.split(",").map(&:strip)
  }
end

directory_name = "exercises"
Dir.mkdir directory_name unless File.exists? directory_name

File.open("exercises/exercises.json","w") do |f|
  f.write(JSON.pretty_generate(exercises))
end

Dir.chdir directory_name

exercises.each do |exercise|
  if File.exists? "#{exercise[:name]}"
    Dir.chdir "#{exercise[:name]}"
    p "Updating #{exercise[:name]}"
    `git fetch origin && git reset --hard origin/master`
    p "Updated."
    Dir.chdir File.expand_path("..", Dir.pwd)
  else
    `git submodule add #{exercise[:clone_url]}`
  end
end

