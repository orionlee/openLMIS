# -*- coding: utf-8 -*-
module DatePeriodRangeHelper
  def date_periods_between(dp1, dp2)
    dps = []
    
    date = Date.from_date_period(dp1)
    end_date = Date.from_date_period(dp2)
    while date <= end_date
      dps << date.to_date_period
      date += 1.date_period
    end
    
    dps
  end
  
  def parse_date_range(params)
    if params[:date_range] =~ /:/
      date1, date2 = params[:date_range].split(':', 2).map { |d| Date.parse(d) }
    elsif params[:date_range] =~ /^\d{4}$/
      date1 = Date.parse(params[:date_range]+'-01-01')
      date2 = Date.parse(params[:date_range]+'-12-31')
    elsif params[:from_date] && params[:to_date]
      date1 = Date.parse(params[:from])
      date2 = Date.parse(params[:to])
    end

    return "#{date1.strftime("%Y-%m-%d")} — #{date2.strftime("%Y-%m-%d")}", date1..date2
  end

  def parse_date_period_range(ps=params, options={})
    date_period_range = get_date_period_range(ps)
    format = options[:format] || :short_month_of_year
    if date_period_range =~ /:/
      date1, date2 = date_period_range.split(':', 2) 
      return "#{I18n.l(Date.from_date_period(date1), :format => format)}–#{I18n.l(Date.from_date_period(date2), :format => format)}", (date1..date2).to_a.grep(/-(?:0[1-9]|1[012])/)
    elsif date_period_range =~ /^\d{4}$/
      return date_period_range, date_period_range+'-01'..date_period_range+'-12'
    elsif date_period_range =~ /^\d{4}-\d{2}$/
      return I18n.l(Date.from_date_period(date_period_range), :format => format), [date_period_range, date_period_range]
    else
      return parse_date_period_range({:date_period_range => default_date_period_range})
    end
  end
  
  def date_period_range_options
    options = (2007..Date.today.year).map { |y| [y.to_s, y.to_s] }
    
    options += (2008..Date.today.year).map { |y|
      july = Date.parse("#{y}-07-01")
      ["#{I18n.l(july - 1.year, :format => :month_of_year)}–#{I18n.l(july - 1.month, :format => :month_of_year)}", 
        "#{((july - 1.year).to_date_period)}:#{((july - 1.month).to_date_period)}"]       
    }
   
    options += (0..11).to_a.reverse.map { |n| [I18n.l(n.months.ago.to_date, :format => 'short_month_of_year'), n.months.ago.to_date.to_date_period] }
    options << last_six_months
    
    options
  end
  
  def last_six_months_of_this_year
    july = Date.parse("#{Date.today.year}-07-01")
    ["#{I18n.l(july, :format => :short_month_of_year)}–#{I18n.t('current_time')}", 
      "#{(july.to_date_period)}:#{(Date.today.to_date_period)}"]
  end
  
  def last_six_months
    last = 5.months.ago(Date.today).to_date
    now = Date.today
    
    [ "#{I18n.l(last, :format => :short_month_of_year)}–#{I18n.l(now, :format => :short_month_of_year)}",
      "#{last.to_date_period}:#{now.to_date_period}" ]
  end
  
  def default_date_period_range
    last_six_months
  end
  
  def get_date_period_range(ps=params)
    ps[:date_period_range] || default_date_period_range.last
  end
end
