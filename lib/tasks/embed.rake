namespace :embed do
  desc 'Reprocess all ExternalEmbed records'
  task :reprocess => :environment do
    p "REPROCESSING ALL EXTERNAL EMBEDS"
    ExternalEmbed.all.each do |embed|
      embed.save!
      ap embed.inspect
    end
  end
end