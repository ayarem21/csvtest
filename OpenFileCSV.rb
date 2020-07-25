require 'csv'

table = CSV.parse(File.read("csv/acme_worksheet.csv"), headers: true)
not_formatted_data = table["Date"].uniq!
employee_name = table["Employee Name"].uniq!
formatted_data = []
not_formatted_data.each_with_index do |elem, i|
  formatted_data[i] = "#{Date.parse(elem).year}-#{'%02i' % Date.parse(elem).mon}-#{ '%02i' % Date.parse(elem).mday}"
end

formatted_data = formatted_data.unshift("Name / Date")
print(formatted_data)
csv_array = ""

index = 0
cnt = 0
tmp_name = []
tmp_date = []
tmp_work = []
write_array = []
new_name_list = []
new_date_list = []
new_work_list = []
not_formatted_data.each do |dt|
  cnt = table["Date"].count(dt)
  index.upto(index + cnt - 1) do |index|
    tmp_name << {"Employee Name" => table["Employee Name"][index], "Work Hours" => table["Work Hours"][index]}
  end

  str = ""
  str2 = ""
  bool = ""
  bool2 = ""
  puts "#{index} #{index+cnt}"
    employee_name.each_with_index do |e_name,k|
      new_array = tmp_name.map{|x| x.values[1]}
        if tmp_name.map{|x| x.values[0]}.include?(e_name)
          str =  e_name
          bool = 1
        else
          str = e_name
          bool = 0
        end
    new_work_list << bool
    new_name_list << str
  end
  index += cnt
  tmp_name = []
  new_array = []
  tmp_work = []
end

new_hash_data = []
array_test = table["Work Hours"]
hour = ""
new_name_list.each_with_index do |name, i|
  if  new_work_list[i].to_i == 0
  # new_hash_data << {"Employee Name" => name, "Work Hours" => new_work_list[i]}
    array_test.insert(i, 0)
  end
end
puts array_test
new_name_list.each_with_index do |name, i|
  new_hash_data << {"Employee Name" => name, "Work Hours" => array_test[i]}
end
# puts array_test.length
array = []
CSV.open("csv/accounting.csv", "w",
  write_headers: true,
  headers: formatted_data
  ) do |csv|
    employee_name.each do |name|
      array.push(name)
      new_hash_data.each_with_index do |h_name, i|
        if h_name["Work Hours"].to_f > 0
          if h_name["Employee Name"] == name
            array.push(h_name["Work Hours"])
          end
        else
          if h_name["Employee Name"] == name
            array.push(h_name["Work Hours"])
          end
        end
      end
      csv << array
      array = []
    end

  end
puts(employee_name.count)
