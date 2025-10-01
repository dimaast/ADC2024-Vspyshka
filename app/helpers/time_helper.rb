module TimeHelper
  def time_ago_in_words(time)
    return "только что" if time.nil?
    
    now = Time.current
    diff = now - time
    
    case diff
    when 0..59
      "только что"
    when 60..119
      "1 минуту назад"
    when 120..3599
      minutes = (diff / 60).to_i
      "#{minutes} #{pluralize_minutes(minutes)} назад"
    when 3600..86399
      hours = (diff / 3600).to_i
      "#{hours} #{pluralize_hours(hours)} назад"
    when 86400..2591999
      days = (diff / 86400).to_i
      "#{days} #{pluralize_days(days)} назад"
    when 2592000..31535999
      months = (diff / 2592000).to_i
      "#{months} #{pluralize_months(months)} назад"
    else
      years = (diff / 31536000).to_i
      "#{years} #{pluralize_years(years)} назад"
    end
  end
  
  private
  
  def pluralize_minutes(count)
    case count % 10
    when 1
      count % 100 == 11 ? "минут" : "минуту"
    when 2, 3, 4
      count % 100 >= 12 && count % 100 <= 14 ? "минут" : "минуты"
    else
      "минут"
    end
  end
  
  def pluralize_hours(count)
    case count % 10
    when 1
      count % 100 == 11 ? "часов" : "час"
    when 2, 3, 4
      count % 100 >= 12 && count % 100 <= 14 ? "часов" : "часа"
    else
      "часов"
    end
  end
  
  def pluralize_days(count)
    case count % 10
    when 1
      count % 100 == 11 ? "дней" : "день"
    when 2, 3, 4
      count % 100 >= 12 && count % 100 <= 14 ? "дней" : "дня"
    else
      "дней"
    end
  end
  
  def pluralize_months(count)
    case count % 10
    when 1
      count % 100 == 11 ? "месяцев" : "месяц"
    when 2, 3, 4
      count % 100 >= 12 && count % 100 <= 14 ? "месяцев" : "месяца"
    else
      "месяцев"
    end
  end
  
  def pluralize_years(count)
    case count % 10
    when 1
      count % 100 == 11 ? "лет" : "год"
    when 2, 3, 4
      count % 100 >= 12 && count % 100 <= 14 ? "лет" : "года"
    else
      "лет"
    end
  end
end