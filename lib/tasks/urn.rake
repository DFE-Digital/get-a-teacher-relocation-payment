namespace :urn do
  desc "generate and randomize unique urns"
  task generate: :environment do
    puts "running rake task urn:generate ..."
    a = Urn.count
    GenerateUrns.call
    b = Urn.count
    puts "#{b - a} URN created"
  end
end
