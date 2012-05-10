desc "Import data."
task :import_data => :environment do
	require 'rubygems'
	require 'spreadsheet'
	workbook = Spreadsheet.open("data.xls")
	worksheet = workbook.worksheet(0)
	
	0.upto worksheet.last_row_index do |index|
	
		row = worksheet.row(index)
		
		i = Item.new
		i.image_front = row[0]
		i.image_back = row[1]
		i.link = row[2]
		i.rank = row[3]
		
		i.save
	
	end
	
end