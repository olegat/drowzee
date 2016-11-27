#!/usr/bin/ruby
#
# usage:
#   ./drawpkm.rb <PkmnDir>
#

# validate
if ARGV.count != 2 then
	print "usage: ./drawpkm.rb <PkmnDir> <OutImage>\n";
	exit 1
end

path     = ARGV[0];
out      = ARGV[1];
maxpk    = 151;
basepk   = 96; # TODO: 96 should be an arg
ncolumns = 6;
leftover = maxpk % ncolumns;
commands = "\\\n";
i        = 1;
while i <= maxpk do
	commands += '"("' + " \\\n";

	c = 0;
	while (c < ncolumns) and i <= maxpk do
		pattern = "#{path}/#{basepk}_#{i}"
		name = '#' + "#{i} " + File.read("#{pattern}_name.txt")
		img  = "\"#{pattern}.png\""
		name = name.gsub(/\n/, "");
		commands += '  "(" ';
#		commands += "#{img} -gravity center -background none -pointsize 30 \"label:#{name}\" -append "
		commands += "#{img} -gravity center                  -pointsize 30 \"label:#{name}\" -append "
		commands += '")"' + " \\\n"
		c += 1;
		i += 1;
	end
	commands +="+append \")\" \\\n";
end
commands += " -background White -append \\\n";

print "convert #{commands} #{out}\n"
`convert #{commands} #{out}`
