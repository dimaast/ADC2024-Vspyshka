module ApplicationHelper
  def category_icon(category_name)
    case category_name.downcase
    when 'концерт', 'музыка'
      'music'
    when 'спорт', 'турнир'
      'trophy'
    when 'мастер-класс', 'лекция'
      'graduation-cap'
    when 'фестиваль'
      'calendar-alt'
    when 'волонтёрство', 'добро'
      'heart'
    when 'дизайн'
      'palette'
    when 'еда'
      'utensils'
    when 'технологии'
      'laptop-code'
    when 'игры'
      'gamepad'
    when 'кино'
      'film'
    else
      'tag'
    end
  end

  def tag_icon(tag_name)
    case tag_name.downcase
    when 'музыка'
      'music'
    when 'спорт'
      'trophy'
    when 'дизайн'
      'palette'
    when 'технологии'
      'laptop-code'
    when 'еда'
      'utensils'
    when 'игры'
      'gamepad'
    when 'кино'
      'film'
    when 'добро', 'волонтёрство'
      'heart'
    when 'хобби'
      'star'
    else
      'tag'
    end
  end
end