module ParseDate

  def parse_date(input_date)
    case input_date.length
    when 10
      Date.strptime(input_date, '%Y-%m-%d')
    when 7 
      Date.strptime(input_date, '%Y-%m') 
    when 4
      Date.strptime(input_date, '%Y')
    end
  end

  def score(input_date, input_point)
    @watched = Date.strptime(input_date, '%Y-%m-%d')
    @user_point = input_point
  end
end


