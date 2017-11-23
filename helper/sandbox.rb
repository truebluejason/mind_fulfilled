def test
	File.open('sandboxfile.txt','w') do |f|
		f.puts "ahh..."
		f.puts "Second line is here."
	end
end

test