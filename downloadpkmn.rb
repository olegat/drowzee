#!/usr/bin/ruby
#
# usage:
#   ./downloadpkmn.rb <PkNumber> <OutDir>
#

require 'nokogiri'
require 'open-uri'
require 'FileUtils'

#                                              2  2  1
# http://images.alexonsager.net/pokemon/fused/18/18.42.png
#
#                                 1  2
# http://pokemon.alexonsager.net/42/18
#
# //*[@id="pk_name"]
def ScrapPkmn(p1, p2, outdir)
	FileUtils.mkpath(outdir);

	pageURL  = "http://pokemon.alexonsager.net/#{p1}/#{p2}";
	imgURL   = "http://images.alexonsager.net/pokemon/fused/#{p2}/#{p2}.#{p1}.png";
	outName  = "#{outdir}/#{p1}_#{p2}_name.txt";
	outImg   = "#{outdir}/#{p1}_#{p2}.png";

	doc      = Nokogiri::HTML(open(pageURL));
	name     = doc.xpath('//*[@id="pk_name"]');

	File.write(outName, "#{name[0].content()}\n");
	`curl #{imgURL} > "#{outImg}"`
end

# Init pkmon numbers
i = 0;
j = 1;

# validate
if ARGV.count != 2 then
	print "usage: ./downloadpkmn.rb <PkNumber> <OutDir>\n";
	exit 1
else
	i = ARGV[0].to_i
	if (i < 0 or i > 151) then
		print "PkNumber should be between 1 to 151 (inclusive)";
		exit 1		
	end
end

# loop... download all 151 pkmn
while j <= 151 do
	ScrapPkmn( i, j, ARGV[1] );
	j = j + 1
end
